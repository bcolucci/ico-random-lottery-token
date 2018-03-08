pragma solidity ^0.4.19;

import './Owned.sol';

// default truffle migration contract
contract Migrations is Owned {

  uint lastMigration;

  function setCompleted(uint _completed) public restricted { lastMigration = _completed; }

  function upgrade(address _newAddress) public restricted {
    Migrations upgraded = Migrations(_newAddress);
    upgraded.setCompleted(lastMigration);
  }

}
