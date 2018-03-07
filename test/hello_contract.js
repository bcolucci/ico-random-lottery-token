const HelloContract = artifacts.require('./HelloContract.sol');

contract('HelloContract', accounts => {

  it('GetMessage should return a correct string', done => {
    HelloContract.deployed()
      .then(ctx => ctx.GetMessage.call())
      .then(res => {
        assert.strictEqual(res, 'Hello Ethereum Salon!');
        done();
      })
  });

});
