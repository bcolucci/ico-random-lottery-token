pragma solidity ^0.4.19;

import './ICOToken.sol';

contract RandomLotteryToken is ICOToken {

  mapping (address => uint256) _bets;
  mapping (address => uint8) _todayBets;
  mapping (address => uint8) _nbBets;

  function RandomLotteryToken()
    ICOToken('Random Lottery Token', 'RLT', 18, 10 ** 9, 100) public {}

  function betOf(address _addr) public view returns (uint256) { return _bets[_addr]; }

  function bet(uint256 _value) public returns (uint256, uint256) {
    require(_balances[msg.sender] >= _value);
    _bets[msg.sender] += _value;
    _balances[msg.sender] -= _value;
    if (_todayBets[msg.sender] == 0) {
      _todayBets[msg.sender] = 1;
      _nbBets[msg.sender] += 1;
    }
    return (_bets[msg.sender], _balances[msg.sender]);
  }

}
