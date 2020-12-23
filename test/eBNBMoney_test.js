const BigNumber = web3.BigNumber;
const  assert  = require('console');
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
          hasError.should.be.equal(false);
        });
        it('it should not let someone transfer tokens they do not have', async () => {
          var hasError = true;
          try {
            await this.eb.transfer(holder, toWei(10), { from: owner })
            await this.eb.transfer(receiver, toWei(20), { from: holder })
            hasError = false;
          } catch(err) { }
          hasError.should.be.equal(true);
        });
        describe("it should checking some functions",() =>{
          it('it should approve the spender with value',async() =>{
           await this.eb.approve(receiver,100);
           let approve = true;
          approve.should.be.equal(true);
        })
        it('it should increase the value os spender',async()=>{
          await this.eb.increaseAllowance(receiver,10);
          let increased = true;
          increased.should.be.equal(true);
        })
        it("it should decrease the allowance of spender",async() =>{
          await this.eb.decreaseAllowance(receiver,10);
          let decreased = true;
          decreased.should.be.equal(true);
        })
        it("we should not be callable rebase function from this because it shouldbe callable only from orchestrator",async()=>{
          var hasError = true;
          try {
            await this.eb.rebase(1,2);
            hasError = false;
          } catch(err) { }
          hasError.should.be.equal(true);
        })
        it("set eBNBPolicyAuthentication for eBNBMoney",async() =>{
          await this.eb.seteBNBPolicyAuthentication("0x9a6c7f937336879B8469ff0F2EB796d3EE2C1a4A");
          let eBNBPolicy = true;
          eBNBPolicy.should.be.equal(true);
        })
      })
      });
    });
  });
});

function toWei(count) {
  return count * 10 ** 1
}
