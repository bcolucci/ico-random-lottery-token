const RandomLotteryToken = artifacts.require('./RandomLotteryToken.sol');

module.exports = deployer => deployer.deploy(RandomLotteryToken, 1000)
