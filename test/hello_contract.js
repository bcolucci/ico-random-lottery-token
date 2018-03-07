const HelloContract = artifacts.require('./HelloContract.sol');

contract('HelloContract', accounts => {

  it('GetMessage should return a correct string', async function() {
    const ctx = await HelloContract.deployed();
    const res = await ctx.getMessage.call();
    assert.strictEqual(res, 'Hello Ethereum Salon!');
  });

});
