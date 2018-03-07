pragma solidity ^0.4.19;

contract RandomLotteryToken {

  enum TxStatus { Pending, Done }

  // let's say for now that 1 ETH <=> 100 RLT
  uint256 internal CONVERTION_RATIO = 100;

  string _name = 'Random Lottery Token';
  string _symbol = 'RLT';
  uint8 _decimals = 18;

  address _owner;
  uint256 _totalSupply;
  uint _betDate;

  mapping (address => uint256) _balances;
  mapping (address => uint256) _bets;

  event Transfer(address indexed _from, address indexed _to, uint256 _value, TxStatus _status);

  modifier restricted() {
    if (msg.sender == _owner) _;
  }

  function RandomLotteryToken(uint256 _initialSupply) public {
    _owner = msg.sender;
    _balances[_owner] = _initialSupply;
    _totalSupply = _initialSupply * (10 ** uint256(_decimals));
    _betDate = block.timestamp;
  }

  function owner() public constant returns (address) { return _owner; }
  function name() public constant returns (string) { return _name; }
  function symbol() public constant returns (string) { return _symbol; }
  function decimals() public constant returns (uint8) { return _decimals; }
  function totalSupply() public constant returns (uint256) { return _totalSupply; }

  function betDate() public view returns (uint) { return _betDate; }
  function betOf(address _addr) public view returns (uint256) { return _bets[_addr]; }
  function balanceOf(address _addr) public view returns (uint256) { return _balances[_addr]; }

  function _transferFrom(address _from, address _to, uint256 _value) internal returns (bool) {
    Transfer(_from, _to, _value, TxStatus.Pending);
    require(_to != 0x0 && _from != _to);
    require(_balances[_from] >= _value);
    _balances[_from] -= _value;
    _balances[_to] += _value;
    Transfer(_from, _to, _value, TxStatus.Done);
    return true;
  }

  function transferFrom(address _from, address _to, uint256 _value) public restricted returns (bool) {
    return _transferFrom(_from, _to, _value);
  }

  function transfer(address _to, uint256 _value) public returns (bool) {
    return _transferFrom(_owner, _to, _value);
  }

  function convert(uint256 _value) public view returns (uint256) {
    return _value * CONVERTION_RATIO;
  }

  function receivePayment() public payable returns (uint256) {
    require(msg.value > 0);
    uint256 rltAmount = convert(msg.value);
    require(_balances[_owner] >= rltAmount);
    _balances[_owner] -= rltAmount;
    _balances[msg.sender] += rltAmount;
    return rltAmount;
  }

  function bet(uint256 _value) public {
    require(_balances[msg.sender] >= _value);
    _bets[msg.sender] += _value;
    _balances[msg.sender] -= _value;
  }

  function removeFunds() public restricted {
    _owner.transfer(this.balance);
  }

}
