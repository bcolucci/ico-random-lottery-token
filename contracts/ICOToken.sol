pragma solidity ^0.4.19;

import './Owned.sol';

// common token which is owned
contract ICOToken is Owned {

  address internal VOID_ADDR = 0x0;

  // token common attributes
  string _name;
  string _symbol;
  uint8 _decimals;

  // ETH => RLT ratio
  uint256 _convertRatio;

  // total tokens generated (user view)
  uint256 _totalSupply;

  // total tokens generated for airdrop (user view)
  uint256 _availableAirdrop;

  // timestamp representing when this ICO was started
  uint public _startedAt;

  // number of milliseconds before the ICO ends
  uint public _liveDuration;

  // tokens balances
  mapping (address => uint256) _balances;

  // events
  event OnRequireFailed(string _message);
  event OnTokensAirdropped(address indexed _to, uint256 _value, uint256 _available);
  event OnTokensTransfered(address indexed _from, address indexed _to, uint256 _value);
  event OnFundsReceived(address _from, uint256 _eth, uint256 _tokens);
  event OnFundsTransfered(address _from, uint256 _balance);

  function requireOrLog(bool _condition, string _message) internal {
    if (!_condition) {
      OnRequireFailed(_message);
    }
    require(_condition);
  }

  // constructor
  function ICOToken(string _tokenName, string _tokenSymbol, uint8 _tokenDecimals,
    uint256 _initialSupply, uint256 _airdropSupply, uint _duration, uint256 _ratio) public {
    requireOrLog(_initialSupply >= _airdropSupply, '_initialSupply < _airdropSupply');
    _name = _tokenName;
    _symbol = _tokenSymbol;
    _decimals = _tokenDecimals;
    _balances[_owner] = _initialSupply;
    _availableAirdrop = _airdropSupply;
    _liveDuration = _duration;
    _convertRatio = _ratio;
    _totalSupply = _initialSupply * 10 ** uint256(_decimals);
  }

  // getters
  function name() public constant returns (string) { return _name; }
  function symbol() public constant returns (string) { return _symbol; }
  function decimals() public constant returns (uint8) { return _decimals; }
  function totalSupply() public constant returns (uint256) { return _totalSupply; }
  function availableAirdrop() public constant returns (uint256) { return _availableAirdrop; }
  function convertRatio() public constant returns (uint256) { return _convertRatio; }

  function balanceOf(address _addr) public view returns (uint256) { return _balances[_addr]; }
  function startedAt() public view returns (uint) { return _startedAt; }

  // starts the ICO
  function start() public restricted returns (uint) {
    _startedAt = now;
    return _startedAt;
  }

  // returns true if the ICO is active
  function active() public view returns (bool) {
    return _startedAt > 0 && now < (_startedAt + _liveDuration);
  }

  // common addresses check
  function _checkAddresses(address _from, address _to) internal {
    requireOrLog(_from != VOID_ADDR, '_from == VOID_ADDR');
    requireOrLog(_to != VOID_ADDR, '_to == VOID_ADDR');
    requireOrLog(_from != _to, '_from == _to');
  }

  // airdrops tokens to an account
  function airdrop(address _to, uint256 _value) public restricted {
    requireOrLog(_to != VOID_ADDR, '_to == VOID_ADDR');
    requireOrLog(_availableAirdrop >= _value, '_availableAirdrop < _value');
    requireOrLog(active(), '!active()');
    _availableAirdrop -= _value;
    _balances[_owner] -= _value;
    _balances[_to] += _value;
    OnTokensAirdropped(_to, _value, _availableAirdrop);
  }

  // transfer RLT tokens from an account to another one
  // returns the transfered tokens, the new sender balance and the new receiver balance
  function _transferTokens(address _from, address _to, uint256 _value)
    internal returns (uint256, uint256, uint256) {
    requireOrLog(active(), '!active()');
    requireOrLog(_balances[_from] >= _value, '_balances[_from] < _value');
    _checkAddresses(_from, _to);
    // move tokens between accounts
    _balances[_from] -= _value;
    _balances[_to] += _value;
    OnTokensTransfered(_from, _to, _value);
    return (_value, _balances[_from], _balances[_to]);
  }

  // restricted function to send tokens between accounts
  function sendTokens(address _from, address _to, uint256 _value)
    public restricted returns (uint256, uint256, uint256) {
    return _transferTokens(_from, _to, _value);
  }

  // internal function to send tokens from the owner to another account
  function sendTokensFromOwner(address _to, uint256 _value)
    internal returns (uint256, uint256, uint256) {
    return _transferTokens(_owner, _to, _value);
  }

  // convert ETH to RLT
  function convert(uint256 _value) public view returns (uint256) {
    return _value * _convertRatio;
  }

  //TODO
  function transferBalance() public restricted {
    _owner.transfer(this.balance);
    OnFundsTransfered(_owner, this.balance);
  }

  // modifier that gives RLT in exchange of ETH when receivig funds
  modifier tradable() {
    requireOrLog(active(), '!active()');
    // cannot trade 0 ETH
    requireOrLog(msg.value > 0, 'msg.value <= 0');
    // RLT value here
    uint256 value = convert(msg.value);
    sendTokensFromOwner(msg.sender, value);
    OnFundsReceived(msg.sender, msg.value, value);
    _;
  }

  // explicit asking we need to be able to receive funds in ETH
  // calling our tradable modifier to give RLT based on ETH received
  function () public tradable payable {}

}
