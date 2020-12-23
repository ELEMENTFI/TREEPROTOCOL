/*created by:Martina Gracy(@Martinagracy28)
Role:solidity Developer-boson labs
date:28-Nov-2020
reviewed by:hemadri -project director-Boson Labs */
pragma solidity >=0.6.8;
// SPDX-License-Identifier: MIT
import "./ownership/Ownable.sol";
import "./math/SafeMathInt.sol";
import "./token/BEP20/BEP20Token.sol";

contract eBNB is  BEP20Token,OwnableUpgradeSafe{
    using SafeMath for uint256;
    using SafeMathInt for int256;
    address public eBNBPolicyAuthentication;
    /*
     events emitted during function calls
    LogRebase,Log RebasePaused,LogTokenPaused,LogMonetaryPolicyUpdated 
   */
    event LogRebase(uint256 indexed epoch, uint256 totalSupply);
    event LogRebasePaused(bool paused);
    event LogTokenPaused(bool paused);
    event LogMonetaryPolicyUpdated(address eBNBPolicyAuthentication);

    /*
    Used for authentication only call from eBNBpolicy contract.
    It is udes in rebase function call.
    */
    modifier onlyeBNBPolicyAuthentication() {
        require(msg.sender == eBNBPolicyAuthentication);
        _;
    }

    bool public rebasePaused;
    bool public tokenPaused;
    
    // Precautionary emergency controls for rebase.
    modifier whenRebaseNotPaused() {
        require(!rebasePaused);
        _;
    }
    
    // Precautionary emergency controls for transfer.
    modifier whenTokenNotPaused() {
        require(!tokenPaused);
        _;
    }

    // To ckeck the sender address is valid or not.
    modifier validRecipient(address to) {
        require(to != address(0x0));
        require(to != address(this));
        _;
    }

    uint256 private constant DECIMALS = 1;
    uint256 private constant MAX_UINT256 = ~uint256(0);
    uint256 private constant INITIAL_FRAGMENTS_SUPPLY = 12 * 10**5 * 10**DECIMALS;

    // TOTAL_GONS value is integer value of INITIAL_FRAGMENTS_SUPPLY.
    uint256 private constant TOTAL_GONS = MAX_UINT256 - (MAX_UINT256 % INITIAL_FRAGMENTS_SUPPLY);

    // MAX_SUPPLY = maximum integer < (sqrt(4*TOTAL_GONS + 1) - 1) / 2
    uint256 public constant MAX_SUPPLY = ~uint128(0);  // (2^128) - 1
    uint256 public  _totalSupply;
    uint256 public _gonsPerFragment;
    mapping(address => uint256) private _gonBalances;
    mapping (address => mapping (address => uint256)) private _allowedFragments;

   /*
    Initialize Token name,Symbol and TotalSupply.
    Token name ="eBNB";
     Token Symbol = "eBNB";
     Total Supply ="12000000";
     It initialize rebasePaused and tokenPaused to false as a default value.
    */
    function initialize()
        public
        initializer
    {
       BEP20Token.__BEP20_init("eBNBdev", "eBNBDEV");
        OwnableUpgradeSafe.__Ownable_init();
        rebasePaused = false;
        tokenPaused = false;
        _totalSupply = INITIAL_FRAGMENTS_SUPPLY;
        _gonBalances[msg.sender] = TOTAL_GONS;
        _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
       
        emit Transfer(address(0x0), msg.sender, _totalSupply);
    }
    /*
    It will set eBNBPolicy and connect the eBNBMoney to eBNBPolicy contract.
    */
    function seteBNBPolicyAuthentication(address eBNBPolicyAuthentication_)
        external
        onlyOwner
    {
        eBNBPolicyAuthentication = eBNBPolicyAuthentication_;
        emit LogMonetaryPolicyUpdated(eBNBPolicyAuthentication_);
    }
    /*
    Pauses or Unpauses the rebase operation.
    If it is true,rebase is Paused. 
    */
 
     function setRebasePaused(bool paused)
        external
        onlyOwner
    {
        rebasePaused = paused;
        emit LogRebasePaused(paused);
    }

    /**
     *  Pauses or unpauses execution of BEP-20 transactions.
     *  paused Pauses BEP-20 transactions if this is true.
     */
    function setTokenPaused(bool paused)
        external
        onlyOwner
    {
        tokenPaused = paused;
        emit LogTokenPaused(paused);
    }
    /*
    During rebase function call checking onlyeBNBPolicyAuthentication and WhenRebaseNotPaused
    After calling rebase function it will call the tranferfrom function for distrube the free coins
    */
    
    function rebase(uint256 epoch, int256 supplyDelta)
        external
        onlyeBNBPolicyAuthentication 
        whenRebaseNotPaused
        returns (uint256)
    {
        if (supplyDelta == 0) {
            emit LogRebase(epoch, _totalSupply);
            return _totalSupply;
        }

        if (supplyDelta < 0) {
            _totalSupply = _totalSupply; 
        } else {
            _totalSupply = _totalSupply.add(uint256(supplyDelta));//positive rebase
        }

        if (_totalSupply > MAX_SUPPLY) {
            _totalSupply = MAX_SUPPLY;
        }

        _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
        emit LogRebase(epoch, _totalSupply);
        return _totalSupply;
    }
    /*
    It is initialized when calling initialize function.
    It will return the totalsupply of our token.
    */
  function totalSupply()
        public override
        view
        returns (uint256)
    {
        return _totalSupply;
    }

    /**
     * @param who The address to query.
     * @return The balance of the specified address.
     */
    function balanceOf(address who)
        public override
        view
        returns (uint256)
    {
        return _gonBalances[who].div(_gonsPerFragment);
    }

    /**
     * Transfer tokens to a specified address.
     * The address to transfer .
     *  The amount to be transferred.
     *  True on success, false otherwise.
     */
    function transfer(address to, uint256 value)
        public override
        validRecipient(to)
        whenTokenNotPaused
        returns (bool)
    {
        uint256 gonValue = value.mul(_gonsPerFragment);
        _gonBalances[msg.sender] = _gonBalances[msg.sender].sub(gonValue);
        _gonBalances[to] = _gonBalances[to].add(gonValue);
        emit Transfer(msg.sender, to, value);
        return true;
    }

    /**
     *  Function to check the amount of tokens that an owner has allowed to a spender.
     * The owner_ address which owns the funds.
     *  The spender address which will spend the funds.
     *Returns the number of tokens still available for the spender.
     */
    function allowance(address owner_, address spender)
        public override
        view
        returns (uint256)
    {
        return _allowedFragments[owner_][spender];
    }

    /**
     * Transfer tokens from one address to another.
     *  from address you want to send tokens from.
     * to  address you want to transfer to.
     *  value The amount of tokens to be transferred.
     */
    function transferFrom(address from, address to, uint256 value)
        public override
        validRecipient(to)
        whenTokenNotPaused
        returns (bool)
    {
        _allowedFragments[from][msg.sender] = _allowedFragments[from][msg.sender].sub(value);
         uint256 gonValue = value.mul(_gonsPerFragment);
        _gonBalances[from] = _gonBalances[from].sub(gonValue);
        _gonBalances[to] = _gonBalances[to].add(gonValue);
        emit Transfer(from, to, value);

        return true;
    }

    /**
     *  Approve the passed address to spend the specified amount of tokens on behalf of
     * msg.sender. This method is included for BEP20 compatibility.
     * spender address which will spend the funds.
     * value amount of tokens to be spent.
     */
    function approve(address spender, uint256 value)
        public override
        whenTokenNotPaused
        returns (bool)
    {
        _allowedFragments[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    /**
     * Increase the amount of tokens that an owner has allowed to a spender.
     * spender address which will spend the funds.
     * addedValue amount of tokens to increase the allowance by.
     */
    function increaseAllowance(address spender, uint256 addedValue)
        public
        whenTokenNotPaused
        returns (bool)
    {
        _allowedFragments[msg.sender][spender] =
            _allowedFragments[msg.sender][spender].add(addedValue);
        emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);
        return true;
    }

    /**
     *  Decrease the amount of tokens that an owner has allowed to a spender.
     *  spender address which will spend the funds.
     *  subtractedValue amount of tokens to decrease the allowance by.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue)
        public
        whenTokenNotPaused
        returns (bool)
    {
        uint256 oldValue = _allowedFragments[msg.sender][spender];
        if (subtractedValue >= oldValue) {
            _allowedFragments[msg.sender][spender] = 0;
        } else {
            _allowedFragments[msg.sender][spender] = oldValue.sub(subtractedValue);
        }
        emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);
        return true;
    }

    
}