pragma solidity ^0.4.19;

import './ICOToken.sol';

contract RandomLotteryToken is ICOToken {

  // total bets by address (for the current day)
  mapping (address => uint256) _bets;

  // nb bets by address from the begining (one per day max)
  mapping (address => uint8) _nbBets;

  function RandomLotteryToken()
    ICOToken('Random Lottery Token', 'RLT', 18, 10 ** 9, 100) public {}

  function betOf(address _addr) public view returns (uint256) { return _bets[_addr]; }

  // allows account to bet
  // returns the bet value, the total bet (for the day), the current balance
  function bet(uint256 _value) public returns (uint256, uint256, uint256) {
    // cannot bet more than we have
    require(_balances[msg.sender] >= _value);
    // first bet of the day, let's increment the account bet counter
    if (_bets[msg.sender] == 0) {
      _nbBets[msg.sender] += 1;
    }
    // move from balance to bet
    _balances[msg.sender] -= _value;
    _bets[msg.sender] += _value;
    return (
      _value,
      _bets[msg.sender],
      _balances[msg.sender]
    );
  }

}
