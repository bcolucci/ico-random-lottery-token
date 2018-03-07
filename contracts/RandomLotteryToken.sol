pragma solidity ^0.4.17;

contract RandomLotteryToken {

  string public name = 'Random Lottery Token';
  string public symbol = 'RLT';
  uint8 public decimals = 18;

  uint256 public totalSupply;

  mapping (address => uint256) public balances;

  //event Transfer(address indexed from, address indexed to, uint256 value);

  function RandomLotteryToken(uint256 initialSupply) public {
    totalSupply = initialSupply * 10 ** uint256(decimals);
    balances[msg.sender] = initialSupply;
  }

  function _transfert(address from, address to, uint256 value) internal returns (uint256) {
    require(to != 0x0);
    require(from != to);
    require(value > 0);
    require(balances[from] >= value);
    balances[from] -= value;
    balances[to] += value;
    //Transfer(from, to, value);
    return balances[from];
  }

  function transfert(address to, uint256 value) public returns (uint256) {
    return _transfert(msg.sender, to, value);
  }

  function balanceOf(address addr) public view returns (uint256) {
    return balances[addr];
  }

}
