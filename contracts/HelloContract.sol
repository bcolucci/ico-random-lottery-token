pragma solidity ^0.4.17;

contract HelloContract {

  string message = 'Hello Ethereum Salon!';

  function HelloContract() public {
  }

  function GetMessage() public view returns (string) {
    return message;
  }

}
