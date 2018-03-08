pragma solidity ^0.4.19;

import './ICOToken.sol';

contract RandomLotteryToken is ICOToken {

  mapping (address => uint256) _bets;

  function RandomLotteryToken()
    ICOToken('Random Lottery Token', 'RLT', 18, 10 ** 9, 100) public {}

  function betOf(address _addr) public view returns (uint256) { return _bets[_addr]; }

  function bet(uint256 _value) public returns (uint256, uint256) {
    require(_balances[msg.sender] >= _value);
    _bets[msg.sender] += _value;
    _balances[msg.sender] -= _value;
    return (_bets[msg.sender], _balances[msg.sender]);
  }

}
