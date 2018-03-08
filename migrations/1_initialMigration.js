const Migrations = artifacts.require('./Migrations.sol');
const RandomLotteryToken = artifacts.require('./RandomLotteryToken.sol');

module.exports = deployer => {
  return [
    deployer.deploy(Migrations),
    deployer.deploy(RandomLotteryToken),
  ];
}
