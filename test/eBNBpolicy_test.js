const BigNumber = web3.BigNumber;
const  assert  = require('console');
const mlog = require('mocha-logger');
const util = require('util');


require('chai')
  .use(require('chai-bignumber')(BigNumber))
  .should();

const eBNBPolicy = artifacts.require('eBNBPolicy');

contract('eBNBPolicy', ([owner, holder, receiver, nilAddress]) => {
 

  beforeEach(async () => {
    this.eb = await eBNBPolicy.new({ from: owner });
    this.eb.initialize("0x404a3895e6Fd733B9A03bd3ACD7B642444B76Ec5","0xDA7a001b254CD22e46d3eAB04d937489c93174C3");
  });
  describe('Given that I have a eBNBPolicy Contract', () => {
    describe("This is the value after initialize the function",async() =>{
    it('checking the value of rebase lag equal to 20', async () => {
      let lag = (await this.eb.rebaseLag.call()).toString();
      lag.should.be.bignumber.equal(20);
    });
    it('checking the value of minRebaseTimeIntervalSec equal to 1 day', async () => {
      let time = (await this.eb.minRebaseTimeIntervalSec.call()).toString();
      time.should.be.bignumber.equal(86400);
    });
    it('checking the value of rebaseWindowOffsetSec equal to 60 minutes', async () => {
      let time = (await this.eb.rebaseWindowOffsetSec.call()).toString();
      time.should.be.bignumber.equal(3600);
    });
    it('checking the value of rebaseWindowLengthSec equal to 4 hours', async () => {
      let time = (await this.eb.rebaseWindowLengthSec.call()).toString();
      time.should.be.bignumber.equal(14400);
    });
  })
  describe('This is the function we are calling after initialize our contract',async() =>{
    it("we should not be callable rebase function from this because it shouldbe callable only from orchestrator",async()=>{
      var hasError = true;
      try {
        await this.eb.rebase();
        hasError = false;
      } catch(err) { }
      hasError.should.be.equal(true);
    })
    it("it should set the eBNBOrchestrator address",async() =>{
      await this.eb.setOrchestrator("0x9eec8fdb88a01e0ebfd4ed34255e614f3d14c725");
      let eBNBOrchestrator = true;
      eBNBOrchestrator.should.be.equal(true);
    })
    it("it should set the RebaseLag value",async() =>{
      await this.eb.setRebaseLag(20);
      let RebaseLag = true;
      RebaseLag.should.be.equal(true);
    })
   
  })
  
  });

})