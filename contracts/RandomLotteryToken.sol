pragma solidity ^0.4.19;

contract RandomLotteryToken {

  string internal TX_STATUS_PENDING = 'pending';
  string internal TX_STATUS_DONE = 'done';

  address _owner;

  string _name = 'Random Lottery Token';
  string _symbol = 'RLT';
  uint8 _decimals = 18;

  uint256 _totalSupply;

  mapping (address => uint256) _balances;

  event Transfer(
    address indexed from,
    address indexed to,
    uint256 value,
    string status
  );

  modifier restricted() {
    if (msg.sender == _owner) _;
  }

  function RandomLotteryToken(uint256 _initialSupply) public {
    _owner = msg.sender;
    _balances[_owner] = _initialSupply;
    _totalSupply = _initialSupply * (10 ** uint256(_decimals));
  }

  function owner() public constant returns (address) { return _owner; }
  function name() public constant returns (string) { return _name; }
  function symbol() public constant returns (string) { return _symbol; }
  function decimals() public constant returns (uint8) { return _decimals; }
  function totalSupply() public constant returns (uint256) { return _totalSupply; }
  function balanceOf(address _addr) public constant returns (uint256) { return _balances[_addr]; }

  function _transferFrom(address _from, address _to, uint256 _value) internal returns (bool) {
    Transfer(_from, _to, _value, TX_STATUS_PENDING);
    require(_to != 0x0 && _from != _to);
    require(_balances[_from] >= _value);
    _balances[_from] -= _value;
    _balances[_to] += _value;
    Transfer(_from, _to, _value, TX_STATUS_DONE);
    return true;
  }

  function transferFrom(address _from, address _to, uint256 _value) public restricted returns (bool) {
    return _transferFrom(_from, _to, _value);
  }

  function transfer(address _to, uint256 _value) public returns (bool) {
    return _transferFrom(_owner, _to, _value);
  }

  function () public payable {}

  function removeFunds() public restricted {
    _owner.transfer(this.balance);
  }

}
