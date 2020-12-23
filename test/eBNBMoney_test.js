const BigNumber = web3.BigNumber;
const mlog = require('mocha-logger');
const util = require('util');

require('chai')
  .use(require('chai-bignumber')(BigNumber))
  .should();

const eBNBMoney = artifacts.require('eBNBMoney');

contract('eBNBMoney', ([owner, holder, receiver, nilAddress]) => {
  const TOKEN_COUNT = 3000000;

  beforeEach(async () => {
    this.eb = await eBNBMoney.new({ from: owner });
    this.eb.initialize();
  });
  describe('Given that I have a Token Contract', () => {
   
    it('it should have the correct totalsupply', async () => {
      const symbol = (await this.eb.totalSupply()).toString();
      symbol.should.be.bignumber.equal(30000000);
    });
    describe('Given that I have a fixed supply of tokens', () => {
      it('it should return the total supply of tokens for the Contract', async () => {
        const supply = (await this.eb.totalSupply()).toString();
        supply.should.be.bignumber.equal(toWei(TOKEN_COUNT));
      });
      it('the owner should have all the tokens when the Contract is created', async () => {
        const balance = (await this.eb.balanceOf(owner)).toString();
        balance.should.be.bignumber.equal(toWei(TOKEN_COUNT));
      });
      it('any account should have the tokens transfered to it', async () => {
        const amount = toWei(10);
        await this.eb.transfer(holder, amount)
        const balance = (await this.eb.balanceOf(holder)).toString();
        balance.should.be.bignumber.equal(amount);
      });
      it('an address that has no tokens should return a balance of zero', async () => {
        const balance = (await this.eb.balanceOf(nilAddress)).toString();
        balance.should.be.bignumber.equal(0);
      });
      describe('Given that I want to be able to transfer tokens', () => {
        it('it should not let me transfer tokens to myself', async () => {
          var hasError = true;
          try {
            const amount = toWei(10);
            await this.eb.transfer(owner, amount, { from: owner })
            hasError = false; // Should be unreachable
          } catch(err) { }
          assert.equal(false, hasError, "Function not throwing exception on transfer to self");
        });
        it('it should not let someone transfer tokens they do not have', async () => {
          var hasError = true;
          try {
            await this.eb.transfer(holder, toWei(10), { from: owner })
            await this.eb.transfer(receiver, toWei(20), { from: holder })
            hasError = false;
          } catch(err) { }
          assert.equal(true, hasError, "Insufficient funds");
        });
      });
    });
  });
});

function toWei(count) {
  return count * 10 ** 1
}
