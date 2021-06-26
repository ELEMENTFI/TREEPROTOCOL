
// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

import '@pancakeswap/pancake-swap-lib/contracts/math/SafeMath.sol';
import '@pancakeswap/pancake-swap-lib/contracts/token/BEP20/IBEP20.sol';
import '@pancakeswap/pancake-swap-lib/contracts/token/BEP20/SafeBEP20.sol';
import '@pancakeswap/pancake-swap-lib/contracts/access/Ownable.sol';

import "@pancakeswap/pancake-swap-lib/contracts/token/BEP20/BEP20.sol";

import "@pancakeswap/pancake-swap-lib/contracts/token/BEP20/BEP20.sol";


contract MasterChef is Ownable {
    using SafeMath for uint256;
    using SafeBEP20 for IBEP20;

    // Info of each user.
    struct UserInfo {
        uint256 amount;     // How many LP tokens the user has provided.
        uint256 rewardDebt; // Reward debt. See explanation below.
        //
        // We do some fancy math here. Basically, any point in time, the amount of CAKEs
        // entitled to a user but is pending to be distributed is:
        //
        //   pending reward = (user.amount * pool.accCakePerShare) - user.rewardDebt
        //
        // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
        //   1. The pool's `accCakePerShare` (and `lastRewardBlock`) gets updated.
        //   2. User receives the pending reward sent to his/her address.
        //   3. User's `amount` gets updated.
        //   4. User's `rewardDebt` gets updated.
    }

    // Info of each pool.
    struct PoolInfo {
        IBEP20 lpToken;           // Address of LP token contract.
        uint256 allocPoint;       // How many allocation points assigned to this pool. CAKEs to distribute per block.
        uint256 lastRewardBlock;  // Last block number that CAKEs distribution occurs.
        uint256 accCakePerShare; // Accumulated CAKEs per share, times 1e9. See below.
    }

    // The CAKE TOKEN!
    IBEP20 public cake;
   
    // Dev address.
    address public communitywallet;
    // CAKE tokens created per block.
    uint256 public cakePerBlock;
    // Bonus muliplier for early cake makers.
    uint256 public BONUS_MULTIPLIER = 1;
   

    // Info of each pool.
    PoolInfo public poolInfo;
    // Info of each user that stakes LP tokens.
    mapping  (address => UserInfo) public userInfo;
    // Total allocation points. Must be the sum of all allocation points in all pools.
    uint256 public totalAllocPoint = 0;
    // The block number when CAKE mining starts.
    uint256 public startBlock;
    //---------------------locking variables-------------------------//
    uint256 public maxStakeAmount = 1000000 * 10**9;
    uint256 public lockPeriod = 2 weeks;
    uint256 public withdrawLockupPeriod = 1 days;
    uint256 public rewardLockupPeriod = 12 hours;
    uint256 public startTime;
    uint256 public rewardStartdate;
    mapping(address => uint256) public stakelock;
    mapping (address => uint256) private unLockTime;
    mapping(address => uint256) private stakeBalance ;
    event Deposit(address indexed user, uint256 amount);
    event Withdraw(address indexed user, uint256 amount);
    event EmergencyWithdraw(address indexed user,  uint256 amount);

    constructor(IBEP20 _cake,uint256 _cakePerBlock,address  _communitywallet) public {
        cake = _cake;        
        cakePerBlock = _cakePerBlock;
        startBlock = block.number;
        communitywallet=_communitywallet;
        startTime = block.timestamp;
        rewardStartdate = block.timestamp + 2 minutes;
        // staking pool
        poolInfo.lpToken= _cake;
        poolInfo.allocPoint=1000;
        poolInfo.lastRewardBlock= startBlock;
        poolInfo.accCakePerShare= 0;
        totalAllocPoint = 1000;
      
    }

    function updateMultiplier(uint256 multiplierNumber) public onlyOwner {
        BONUS_MULTIPLIER = multiplierNumber;
    }
   
    // Return reward multiplier over the given _from to _to block.
    function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
        if((stakelock[msg.sender] - withdrawLockupPeriod) >= (startTime + 1 days) ){
            return _to.sub(_from).mul(BONUS_MULTIPLIER);
        }
        else{
            return _to.sub(_from).mul(BONUS_MULTIPLIER * 2);
        }
    }

    // View function to see pending CAKEs on frontend.
    function pendingCake(address _user) external view returns (uint256) {
        if(rewardStartdate <= block.timestamp ){
            PoolInfo storage pool = poolInfo;
            UserInfo storage user = userInfo[_user];
            uint256 accCakePerShare = pool.accCakePerShare;
            uint256 lpSupply = pool.lpToken.balanceOf(address(this));
            if (block.number > pool.lastRewardBlock && lpSupply != 0) {
                uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
                uint256 cakeReward = multiplier.mul(cakePerBlock).mul(pool.allocPoint).div(totalAllocPoint);
                accCakePerShare = accCakePerShare.add(cakeReward.mul(1e9).div(lpSupply));
            }
            return user.amount.mul(accCakePerShare).div(1e9).sub(user.rewardDebt);
        }
        else
            return 0;
        
    }


    // Update reward variables of the given pool to be up-to-date.
    function updatePool() public {
        PoolInfo storage pool = poolInfo;
        if (block.number <= pool.lastRewardBlock) {
            return;
        }
        uint256 lpSupply = pool.lpToken.balanceOf(address(this));
        if (lpSupply == 0) {
            pool.lastRewardBlock = block.number;
            return;
        }
        uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
        uint256 cakeReward = multiplier.mul(cakePerBlock).mul(pool.allocPoint).div(totalAllocPoint);
        pool.accCakePerShare = pool.accCakePerShare.add(cakeReward.mul(1e9).div(lpSupply));
        pool.lastRewardBlock = block.number;
    }

    // Deposit LP tokens to MasterChef for CAKE allocation.
    function deposit(uint256 _amount) public {
        require(!lock(msg.sender),"sender is in locking state");
	    uint256 stakedAmount =(_amount * 90)/100;
	    checkStakeLimit(stakedAmount);
        PoolInfo storage pool = poolInfo;
        UserInfo storage user = userInfo[msg.sender];
        updatePool();
       
        if (_amount > 0) {
            pool.lpToken.safeTransferFrom(address(msg.sender), address(this), stakedAmount);
            user.amount = user.amount.add(stakedAmount);
        }
        user.rewardDebt = user.amount.mul(pool.accCakePerShare).div(1e9);
        stakelock[msg.sender]= block.timestamp + withdrawLockupPeriod;
        emit Deposit(msg.sender, stakedAmount);
    }

    // Withdraw LP tokens from MasterChef.
    function withdraw(uint256 _amount) public {
        require(rewardStartdate <= block.timestamp,"reward not yet Started" );
        require (stakelock[msg.sender] <= block.timestamp, "Boardroom: still in withdraw lockup");
        PoolInfo storage pool = poolInfo;
        UserInfo storage user = userInfo[msg.sender];
        require(user.amount >= _amount, "withdraw: not good");
        updatePool();
        uint256 pending = user.amount.mul(pool.accCakePerShare).div(1e9).sub(user.rewardDebt);
        if(pending > 0) {
            safeCakeTransfer(msg.sender, pending);
        }
        if(_amount > 0) {
            user.amount = user.amount.sub(_amount);
            pool.lpToken.safeTransfer(address(msg.sender), _amount);
        }
        user.rewardDebt = user.amount.mul(pool.accCakePerShare).div(1e9);
        emit Withdraw(msg.sender, _amount);
    }



    // Withdraw without caring about rewards. EMERGENCY ONLY.
    function emergencyWithdraw() public {
        PoolInfo storage pool = poolInfo;
        UserInfo storage user = userInfo[msg.sender];
		uint256 currentBalance = user.amount;
		require(currentBalance>0,"Insufficient balance !");
		user.amount = 0;
        user.rewardDebt = 0;
        bool flag = pool.lpToken.transfer(address(msg.sender), currentBalance);
		require(flag, "Transfer unsuccessful !");
        emit EmergencyWithdraw(msg.sender, user.amount);
        
    }
    

    // Safe cake transfer function, just in case if rounding error causes pool to not have enough CAKEs.
    function safeCakeTransfer(address _to, uint256 _amount) internal {
        cake.transferFrom(communitywallet,_to, _amount);
    }

//---------------------locking-------------------------//
    //checks the account is locked(true) or unlocked(false)
    function lock(address account) public view returns(bool){
        return unLockTime[account] > block.timestamp;
    }
	
	 //if sender is in frozen state,then this function returns epoch value remaining for the address for it to get unfrozen.
    function secondsLeft(address account) public view returns(uint256){
        if(lock(account)){
            return  ( unLockTime[account] - block.timestamp );
        }
         else
            return 0;
    }
 
 
 
    function checkStakeLimit(uint256 _stakeAmount) internal{	  
        require(_stakeAmount <= maxStakeAmount,"Cannot stake  more than permissible limit");
        uint256 balance =  stakeBalance[msg.sender]  + _stakeAmount;
        if(balance == maxStakeAmount) {
            stakeBalance[msg.sender] = 0;        
		    unLockTime[msg.sender] = block.timestamp + lockPeriod;        
        }
        else{
            require(balance < maxStakeAmount,"cannot stake more than permissible limit");
            stakeBalance[msg.sender] = balance;       
        }
	  
    }
    
    //----------------------endlocking-----//
   //------------------claim reward----------------------------//
   
   function claimReward() external {
        require(rewardStartdate <= block.timestamp,"reward not yet Started" );
        require (((stakelock[msg.sender] + rewardLockupPeriod )- withdrawLockupPeriod)  <=  block.timestamp, "Boardroom: still in withdraw lockup");
        PoolInfo storage pool = poolInfo;
        UserInfo storage user = userInfo[msg.sender];
        updatePool();
        uint256 pending = user.amount.mul(pool.accCakePerShare).div(1e9).sub(user.rewardDebt);
        if(pending > 0) {
            safeCakeTransfer(msg.sender, pending);
        }
        
        user.rewardDebt = user.amount.mul(pool.accCakePerShare).div(1e9);
        emit Withdraw(msg.sender,pending);
   }
   
   
   //----------------reward end------------------------------------------------//

  //----------setter---------------------------------------------//

    function setCakePerBlock(uint256 _cakePerBlock) public onlyOwner {
        cakePerBlock = _cakePerBlock;
    }
    
     function setTotalAllocationPoint(uint256 _totalAllocPoint) public onlyOwner {
        totalAllocPoint = _totalAllocPoint;
    }
    
     function setAllocationPoint(uint256 _allocPoint) public onlyOwner {
        poolInfo.allocPoint = _allocPoint;
    }
    
    function setRewardStartDate(uint256 _rewardStartdate) public onlyOwner {
       rewardStartdate = _rewardStartdate;
    }
    
    function setWithdrawLockupPeriod(uint256 _withdrawLockupPeriod) public onlyOwner {
       withdrawLockupPeriod = _withdrawLockupPeriod;
    }
    
    function setRewardLockupPeriod(uint256 _rewardLockupPeriod) public onlyOwner {
       rewardLockupPeriod = _rewardLockupPeriod;
    }
    
    function unLockWeeklyLock(address account) public onlyOwner{
        unLockTime[account] = block.timestamp;
    }
    
    function unLockStakeHolder(address account) public onlyOwner{
        stakelock[account] = block.timestamp;
    }
}
