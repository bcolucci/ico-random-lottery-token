const RandomLotteryToken = artifacts.require('./RandomLotteryToken.sol');

const fundsOf = addr => web3.eth.getBalance(addr).toNumber();

contract('RandomLotteryToken', ([owner, alice, bob]) => {

  let RLT = null;
  beforeEach('setup contract for each test', async function() {
    RLT = await RandomLotteryToken.new();
  });

  const strictEqual = assert.strictEqual.bind(assert);

  const assertFunds = async function(addr, value) {
    strictEqual(fundsOf(addr), value);
  };

  const assertNoFunds = async function(addr) {
    await assertFunds(addr, 0);
  };

  const balanceOf = async function(addr) {
    const balance = await RLT.balanceOf.call(addr);
    return balance.toNumber();
  };

  const assertBalance = async function(addr, value) {
    strictEqual(await balanceOf(addr), value);
  };

  it('should have an owner with no funds and initial tokens', async function() {
    strictEqual(await RLT.owner(), owner);
    await assertBalance(owner, 1e+9);
    await assertNoFunds(await RLT.address);
  });

  it('should have initial accounts without any tokens', async function() {
    await assertBalance(alice, 0);
    await assertBalance(bob, 0);
  });

  it('should accept funds', async function() {
    await assertNoFunds(await RLT.address);
    await RLT.sendTransaction({
      from: alice,
      value: 123,
    });
    await assertFunds(await RLT.address, 123);
    await assertBalance(owner, 1e+9 - 123 * 100);
    await assertBalance(alice, 123 * 100);
  });

  //TODO bet

  it('should transfer owner balance', async function() {
    const ownerFundsBefore = fundsOf(owner);
    const addressFundsBefore = fundsOf(await RLT.address);
    await assertNoFunds(await RLT.address);
    await RLT.sendTransaction({
      from: alice,
      value: 123,
    });
    await assertFunds(await RLT.address, 123);
    const res = await RLT.transferBalance.call();
    console.log(res);
    const ownerFundsAfter = fundsOf(owner);
    const addressFundsAfter = fundsOf(await RLT.address);
    console.log(ownerFundsBefore, ownerFundsAfter, ownerFundsAfter -
      ownerFundsBefore);
    console.log(addressFundsBefore, addressFundsAfter,
      addressFundsAfter - addressFundsBefore);
    //await assertNoFunds(await RLT.address);
  });

});
