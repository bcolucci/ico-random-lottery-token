pragma solidity ^0.4.19;

// represents a contract which is owned
contract Owned {

  // contract owner
  address _owner;

  function Owned() public { _owner = msg.sender; }

  function owner() public constant returns (address) { return _owner; }

  // gives the ability to restrict a function access to the contract owner
  modifier restricted() { if (msg.sender == _owner) _; }

}
