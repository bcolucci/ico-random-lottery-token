pragma solidity ^0.4.19;

import './Owned.sol';

contract ICOToken is Owned {

  string _name;
  string _symbol;
  uint8 _decimals;

  uint256 _convertRatio;
  uint256 _totalSupply;

  mapping (address => uint256) _balances;

  event OnTokensTransfered(address indexed _from, address indexed _to, uint256 _value);

  event OnFundsReceived(address _from, uint256 _eth, uint256 _tokens);
  event OnFundsRemoved(uint256 _balance);

  function ICOToken(string _n, string _s, uint8 _d, uint256 _initialSupply, uint256 _ratio) public {
    _name = _n;
    _symbol = _s;
    _decimals = _d;
    _balances[_owner] = _initialSupply;
    _convertRatio = _ratio;
    _totalSupply = _initialSupply * (10 ** uint256(_decimals));
  }

  function name() public constant returns (string) { return _name; }
  function symbol() public constant returns (string) { return _symbol; }
  function decimals() public constant returns (uint8) { return _decimals; }
  function totalSupply() public constant returns (uint256) { return _totalSupply; }
  function convertRatio() public constant returns (uint256) { return _convertRatio; }
  function balanceOf(address _addr) public view returns (uint256) { return _balances[_addr]; }

  function _transferTokens(address _from, address _to, uint256 _value) internal returns (uint256) {
    require(_to != 0x0 && _from != _to);
    require(_balances[_from] >= _value);
    _balances[_from] -= _value;
    _balances[_to] += _value;
    OnTokensTransfered(_from, _to, _value);
    return _value;
  }

  function sendTokens(address _from, address _to, uint256 _value) public restricted returns (uint256) {
    return _transferTokens(_from, _to, _value);
  }

  function sendTokensFromOwner(address _to, uint256 _value) internal returns (uint256) {
    return _transferTokens(_owner, _to, _value);
  }

  function convert(uint256 _value) public view returns (uint256) { return _value * _convertRatio; }

  function removeFunds() public restricted {
    _balances[_owner] = 0;
    _owner.transfer(this.balance);
    OnFundsRemoved(this.balance);
  }

  modifier tradable() {
    require(msg.value > 0);
    uint256 value = convert(msg.value);
    sendTokensFromOwner(msg.sender, value);
    OnFundsReceived(msg.sender, msg.value, value);
    _;
  }

  function () public tradable payable {}

}
