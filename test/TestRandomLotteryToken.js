const RandomLotteryToken = artifacts.require('./RandomLotteryToken.sol');

contract('RandomLotteryToken', ([ownerAddr, aliceAddr, bobAddr]) => {

  let ctx = null;

  beforeEach('setup contract for each test', async function() {
    ctx = await RandomLotteryToken.new(ownerAddr);
    //console.log("ownerBalance=", web3.eth.getBalance(ownerAddr).toNumber());
    //console.log("aliceBalance=", web3.eth.getBalance(aliceAddr).toNumber());
    //console.log("bobBalance=", web3.eth.getBalance(bobAddr).toNumber());
  });

  it('should have an owner', async function() {
    assert.equal(await ctx.owner(), ownerAddr);
  })

  it('should accept funds', async function() {
    const fundsAddr = await ctx.address;
    assert.equal(web3.eth.getBalance(fundsAddr).toNumber(), 0);
    await ctx.sendTransaction({
      from: aliceAddr,
      value: 1e+18,
    });
    assert.equal(web3.eth.getBalance(fundsAddr).toNumber(), 1e+18);
  });

  it('should permit owner to receive funds', async function() {

    await ctx.sendTransaction({
      from: aliceAddr,
      value: 1e+18,
    });

    const ownerBalanceBeforeRemovingFunds = web3.eth
      .getBalance(ownerAddr)
      .toNumber();

    const fundsAddr = await ctx.address;
    assert.equal(web3.eth.getBalance(fundsAddr).toNumber(), 1e+18);

    await ctx.removeFunds();

    const ownerBalanceAfterTransfer = web3.eth.getBalance(ownerAddr).toNumber();

    // I don't fucking uderstand
    console.log(
      'before', ownerBalanceBeforeRemovingFunds,
      'after', ownerBalanceAfterTransfer,
      'diff', ownerBalanceAfterTransfer -
      ownerBalanceBeforeRemovingFunds
    );

    assert.equal(web3.eth.getBalance(fundsAddr).toNumber(), 0);
    assert.isAbove(
      ownerBalanceAfterTransfer,
      ownerBalanceBeforeRemovingFunds
    );

  });

  it('should be able to transfer funds', async function() {
    assert.equal(web3.eth.getBalance(bobAddr).toNumber(), 1e+20);
    const b = await ctx.balanceOf.call(bobAddr)
    console.log(b);
  });

});
