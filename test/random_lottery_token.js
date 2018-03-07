const RandomLotteryToken = artifacts.require('./RandomLotteryToken.sol');

contract('RandomLotteryToken', accounts => {

  const [rootAddr, aliceAddr] = accounts

  it('Transfert should transfert tokens', async function() {

    const ctx = await RandomLotteryToken.deployed();

    const rootBalance = await ctx.balanceOf.call(rootAddr);
    const aliceBalance = await ctx.balanceOf.call(aliceAddr);
    assert.strictEqual(rootBalance.toNumber(), 1000);
    assert.strictEqual(aliceBalance.toNumber(), 0);

    const newRootBalance = await ctx.transfert.call(aliceAddr, 3);
    const newAliceBalance = await ctx.balanceOf.call(aliceAddr);

    assert.strictEqual(newRootBalance.toNumber(), 997);

    //TODO fix that shit
    //assert.strictEqual(newAliceBalance.toNumber(), 3);

  });

});
