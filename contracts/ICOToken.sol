pragma solidity ^0.4.19;

import './Owned.sol';

// common token which is owned
contract ICOToken is Owned {

  // token common attributes
  string _name;
  string _symbol;
  uint8 _decimals;

  // ETH => RLT ratio
  uint256 _convertRatio;

  // total tokens generated (user view)
  uint256 _totalSupply;

  // tokens balances
  mapping (address => uint256) _balances;

  // events
  event OnTokensTransfered(address indexed _from, address indexed _to, uint256 _value);
  event OnFundsReceived(address _from, uint256 _eth, uint256 _tokens);
  event OnFundsTransfered(address _from, uint256 _balance);

  function ICOToken(string _n, string _s, uint8 _d, uint256 _initialSupply, uint256 _ratio) public {
    _name = _n;
    _symbol = _s;
    _decimals = _d;
    _balances[_owner] = _initialSupply;
    _convertRatio = _ratio;
    _totalSupply = _initialSupply * (10 ** uint256(_decimals));
  }

  // getters
  function name() public constant returns (string) { return _name; }
  function symbol() public constant returns (string) { return _symbol; }
  function decimals() public constant returns (uint8) { return _decimals; }
  function totalSupply() public constant returns (uint256) { return _totalSupply; }
  function convertRatio() public constant returns (uint256) { return _convertRatio; }
  function balanceOf(address _addr) public view returns (uint256) { return _balances[_addr]; }

  // transfer RLT tokens from an account to another one
  // returns the transfered tokens, the new sender balance and the new receiver balance
  function _transferTokens(address _from, address _to, uint256 _value)
    internal returns (uint256, uint256, uint256) {
    require(_to != 0x0);
    require(_from != _to);
    require(_balances[_from] >= _value);
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
  function convert(uint256 _value) public view returns (uint256) { return _value * _convertRatio; }

  function transferBalance() public restricted {
    _owner.transfer(this.balance);
    OnFundsTransfered(_owner, this.balance);
  }

  // modifier that gives RLT in exchange of ETH when receivig funds
  modifier tradable() {
    require(msg.value > 0);
    uint256 value = convert(msg.value);
    sendTokensFromOwner(msg.sender, value);
    OnFundsReceived(msg.sender, msg.value, value);
    _;
  }

  // explicit asking we need to be able to receive funds in ETH
  // calling our tradable modifier to give RLT based on ETH received
  function () public payable tradable {}

}
