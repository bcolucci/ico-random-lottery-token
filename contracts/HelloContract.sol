pragma solidity ^0.4.17;

contract HelloContract {

  string message = 'Hello Ethereum Salon!';

  function HelloContract() public {}

  function getMessage() public view returns (string) {
    return message;
  }

}
