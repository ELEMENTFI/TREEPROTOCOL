/*created by:Martina Gracy(@Martinagracy28)
Role:solidity Developer-boson labs
date:30-DEC-2020
reviewed by:hemadri -project director-Boson Labs */
pragma solidity >=0.6.8;
// SPDX-License-Identifier: MIT
import "./ownership/Ownable.sol";
import "./math/SafeMathInt.sol";
import "./token/BEP20/BEP20Token.sol";
import "./eBNBMoney.sol";

contract seed is BEP20Token,OwnableUpgradeSafe{
    using SafeMath for uint256;
    using SafeMathInt for int256;
    uint256 public _totalSupply;
    uint256 private constant INITIAL_FRAGMENTS_SUPPLY = 12 * 10**5 * 10**1;
    uint256 private constant MAX_UINT256 = ~uint256(0);

    // TOTAL_GONS value is integer value of INITIAL_FRAGMENTS_SUPPLY.
    uint256 private constant TOTAL_GONS = MAX_UINT256 - (MAX_UINT256 % INITIAL_FRAGMENTS_SUPPLY);

    // MAX_SUPPLY = maximum integer < (sqrt(4*TOTAL_GONS + 1) - 1) / 2
    uint256 public constant MAX_SUPPLY = ~uint128(0);  // (2^128) - 1

    uint256 public _gonsPerFragment;
    mapping(address => uint256) private _gonBalances;
    mapping (address => mapping (address => uint256)) private _allowedFragments;
    address[] public players;
    eBNB public ebnb;
    modifier validRecipient(address to) {
        require(to != address(0x0));
        require(to != address(this));
        _;
    }
    bool public tokenPaused;
    modifier whenTokenNotPaused() {
        require(!tokenPaused);
        _;
    }
   address public own;
     function initialize(eBNB _ebnb)
        public
        initializer
    {
       BEP20Token.__BEP20_init("eBNBSeedtoken", "eBNBSEED");
        OwnableUpgradeSafe.__Ownable_init();
        _totalSupply = INITIAL_FRAGMENTS_SUPPLY;
        ebnb = _ebnb;
        own = msg.sender;
         _gonBalances[msg.sender] = TOTAL_GONS;
        _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
        emit Transfer(address(0x0), msg.sender, _totalSupply);
    }
    function totalSupply()
        public override
        view
        returns (uint256)
    {
        return _totalSupply;
    }
     
    function interact(uint256 _value) public  returns(bool){
      players =  ebnb. gettokenreceiver();
      uint256 valu= _value;
      uint256 count = ebnb. gettokenreceivercount();
      for(uint256 i =0;i<count;i++)
      {
          transfer(players[i],valu);
      }
      return true;
    }
   
    function transfer(address to, uint256 value)
        public override
        validRecipient(to)
        whenTokenNotPaused
        returns (bool)
    {
        uint256 gonValue = value.mul(_gonsPerFragment);
        _gonBalances[own] = _gonBalances[own].sub(gonValue);
        _gonBalances[to] = _gonBalances[to].add(gonValue);
        emit Transfer(msg.sender, to, value);
        return true;
    }
    function balanceOf(address who)
        public override
        view
        returns (uint256)
    {
        return _gonBalances[who].div(_gonsPerFragment);
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
