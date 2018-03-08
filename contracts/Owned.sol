pragma solidity ^0.4.19;

contract Owned {

  address _owner;

  function Owned() public { _owner = msg.sender; }

  function owner() public constant returns (address) { return _owner; }

  modifier restricted() { if (msg.sender == _owner) _; }
  
}
