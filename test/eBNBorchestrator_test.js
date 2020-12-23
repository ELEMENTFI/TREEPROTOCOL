const BigNumber = web3.BigNumber;
const  assert  = require('console');
const mlog = require('mocha-logger');
const util = require('util');


require('chai')
  .use(require('chai-bignumber')(BigNumber))
  .should();

const eBNBOrchestrator = artifacts.require('eBNBOrchestrator');

contract('eBNBOrchestrator', ([owner, holder, receiver, nilAddress]) => {
 

  beforeEach(async () => {
    this.eb = await eBNBOrchestrator.new({ from: owner });
    this.eb.initialize("0x7244bD6324bA55911c774c3765AC668b1AB7Ceb0");
  });
  describe('Given that I have a eBNBPolicy Contract', () => {
    describe("This is the function after initialize the function",async() =>{
    it('it should call rebase function for once in 24 hours ,it should be true or false', async () => {
        var hasError = true;
        try {
          await this.eb.rebase();
          hasError = false;
        } catch(err) { }
        hasError.should.be.equal(true);
    });
    it("it should  add Transaction ",async() =>{
        await this.eb.addTransaction(receiver,100);
        let addTransaction = true;
        addTransaction.should.be.equal(true);
      })
      it("it should not remove Transaction because  there is no transcation in that ",async() =>{
        var hasError = true;
        try {
          await this.eb.removeTransaction(1);
          hasError = false;
        } catch(err) { }
        hasError.should.be.equal(true);
      })
      it("it should not set Transaction as enabled because  there is no transcation in that ",async() =>{
        var hasError = true;
        try {
          await this.eb.setTransactionEnabled(1,true);
          hasError = false;
        } catch(err) { }
        hasError.should.be.equal(true);
      })
      it("it should return the transcation size or length ,if there is any transcation happens ",async() =>{
        var hasError = true;
        try {
          await this.eb.transactionsSize();
          hasError = false;
        } catch(err) { }
        hasError.should.be.equal(false);
      })      

})
  })
})