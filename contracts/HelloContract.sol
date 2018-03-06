pragma solidity ^0.4.4;

contract HelloContrat {

  string message = 'Hello Ethereum Salon!';

  function HelloContrat() public {
  }

  function GetMessage() public view returns (string) {
    return message;
  }

}
