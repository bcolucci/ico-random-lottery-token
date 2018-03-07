const Migrations = artifacts.require('./Migrations.sol');
const RandomLotteryToken = artifacts.require('./RandomLotteryToken.sol');

module.exports = deployer => {
  deployer.deploy(Migrations);
  deployer.deploy(RandomLotteryToken, 1000);
}
