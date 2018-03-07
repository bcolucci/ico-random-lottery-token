const HelloContract = artifacts.require('./HelloContract.sol');

module.exports = deployer => deployer.deploy(HelloContract);
