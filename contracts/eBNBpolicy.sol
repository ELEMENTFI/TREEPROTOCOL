/*created by:Prabhakaran(@Prabhakaran1998)
Role:solidity Developer-boson labs
date:28-Nov-2020
reviewed by:hemadri -project director-Boson Labs */

pragma solidity >=0.6.8;
pragma experimental ABIEncoderV2;
// SPDX-License-Identifier: MIT
import "./token/BEP20/BEP20Token.sol";
import './math/UInt256Lib.sol';
import "./Initializable.sol";
import "./ownership/Ownable.sol";
import "./math/SafeMath.sol";
import "./math/SafeMathInt.sol";
import "./eBNBMoney.sol";
import "../oracle/Bandprotocol.sol";


contract eBNBPolicy is OwnableUpgradeSafe{
    IStdReference internal ref;
    uint256 public price;
    using SafeMath for uint256;
    using SafeMathInt for int256;
    using UInt256Lib for uint256;

    event LogRebase(
        uint256 indexed epoch,
        uint256 exchangeRate,
        uint256 cpi,
        int256 requestedSupplyAdjustment,
        uint256 timestampSec        
    );    

       //reference for eBNB
         eBNB public eBNBmoney;
      // CPI value at the time of launch, as an 18 decimal fixed point number.
        uint256 private baseCpi;

        // If the current exchange rate is within this fractional distance from the target, no supply
        // update is performed. Fixed point number--same format as the rate.
        // (ie) abs(rate - targetRate) / targetRate < deviationThreshold, then no supply change.
        // DECIMALS Fixed point number.
        uint256 public deviationThreshold;

        // The rebase lag parameter, used to dampen the applied supply adjustment by 1 / rebaseLag
        uint256 public rebaseLag;
        uint256 public supplyAfterRebase;
        uint256 public exchangeRate;

        // Minimum time taken for rebase operation.
         uint256 public minRebaseTimeIntervalmin;
        
        // Block timestamp of last rebase operation
        uint256 public lastRebaseTimestampmin;

        // The rebase window begins this many minutes into the minRebaseTimeInterval period.
        // For example if minRebaseTimeInterval is 24hrs, it represents the time of day in minutes.
        uint256 public rebaseWindowOffsetmin;

        // The length of the time window where a rebase operation is allowed to execute, in hours.
        uint256 public rebaseWindowLengthhours;

        // The number of rebase cycles since inception
        uint256 public epoch;
        uint256 private constant DECIMALS = 18;
       

        // Due to the expression in computeSupplyDelta(), MAX_RATE * MAX_SUPPLY must fit into an int256.
        // Both are 18 decimals fixed point numbers.
        uint256 private constant MAX_RATE = 10**6 * 10**DECIMALS;
        // MAX_SUPPLY = MAX_INT256 / MAX_RATE
        uint256 public constant MAX_SUPPLY = ~(uint256(1) << 255) / MAX_RATE;

        // eBNBOrchestrator Authentication
        address public eBNBorchestratorref;

        modifier onlyeBNBOrchestrator() {
            require(msg.sender == eBNBorchestratorref);
            _;
        }

        /*
          @prabhakaran1998 
           This method Initialize eBNBMoney address(eBNBmoney = eBNBmoney_),
           It will Initialize the Owner address(OwnableUpgradeSafe.__Ownable_init()),
           It initialize Band protocol ref address(ref = _ref), 
           It initialize  rebase  time Interval = 1 day,
           It Initialize  rebaseWindowLengthhours = 4 hours;
           It Initialize  rebaseWindowOffsetmin = 60 minutes;  
           It Initialize   deviationThreshold = 5 * 10 ** (DECIMALS-2);;  
           It initialize  rebaseLag = 50;
        */
       function initialize(eBNB eBNBmoney_,IStdReference _ref)
            public
            initializer
        {
            OwnableUpgradeSafe.__Ownable_init();
            deviationThreshold = 5 * 10 ** (DECIMALS-2);
            rebaseLag = 50;
            minRebaseTimeIntervalmin = 1 days;
            rebaseWindowOffsetmin = 60 minutes;  
            rebaseWindowLengthhours = 4 hours;
            lastRebaseTimestampmin = 0;
            epoch = 0;
            eBNBmoney = eBNBmoney_;
            ref = _ref;
           
        }
       
        function getPrice() external payable  returns (uint256){
        IStdReference.ReferenceData memory data = ref.getReferenceData("BNB","USD");
        price =data.rate;
        return price;
    }
         
        /**
        *Initiates a new rebase operation, provided the minimum time period has elapsed.
        *
        *      The supply adjustment equals (_totalSupply * DeviationFromTargetRate) / rebaseLag
        *      Where DeviationFromTargetRate is (MarketOracleRate - targetRate) / targetRate
        *      and targetRate is CpiOracleRate / baseCpi
        */
     
        function rebase() external  onlyeBNBOrchestrator  {
            require(inRebaseWindow());

            // This comparison also ensures there is no reentrancy.
           require(lastRebaseTimestampmin.add(minRebaseTimeIntervalmin) < block.timestamp);

            // Snap the rebase time to the start of this window.
            lastRebaseTimestampmin = block.timestamp.sub( block.timestamp.mod(minRebaseTimeIntervalmin)).add(rebaseWindowOffsetmin);
            epoch = epoch.add(1);

            uint256 cpi = 1;
            bool cpiValid = true;
           
            require(cpiValid);
            uint256 targetRate = cpi.mul(10 ** DECIMALS);
            bool rateValid = true;
            require(rateValid);
            exchangeRate = price;


            if (exchangeRate > MAX_RATE) {
                exchangeRate = MAX_RATE;
            }

            int256 supplyDelta = computeSupplyDelta(exchangeRate, targetRate);
           
            // Apply the Dampening factor.
            supplyDelta = supplyDelta.div(rebaseLag.toInt256Safe());

            if (supplyDelta > 0 && eBNBmoney.totalSupply().add(uint256(supplyDelta)) > MAX_SUPPLY) {
                supplyDelta = (MAX_SUPPLY.sub(eBNBmoney.totalSupply())).toInt256Safe();
            }

            supplyAfterRebase = eBNBmoney.rebase(epoch, supplyDelta);
            assert(supplyAfterRebase <= MAX_SUPPLY);
            emit LogRebase(epoch, exchangeRate, targetRate, supplyDelta, block.timestamp);
           
           
        }

        /**
        * @notice Sets the reference to the eBNBorchestrator.
        * @param eBNBorchestratorref_ The address of the eBNBorchestrator contract.
        */
        function setOrchestrator(address eBNBorchestratorref_)
            external
            onlyOwner
        {
            eBNBorchestratorref = eBNBorchestratorref_;
        }

        /**
        * @notice Sets the deviation threshold fraction. If the exchange rate given by the market
        *         oracle is within this fractional distance from the targetRate, then no supply
        *         modifications are made. DECIMALS fixed point number.
        * @param deviationThreshold_ The new exchange rate threshold fraction.
        */
        function setDeviationThreshold(uint256 deviationThreshold_)
            external
            onlyOwner
        {
            deviationThreshold = deviationThreshold_;
        }

        /**
        * @notice Sets the rebase lag parameter.
                It is used to dampen the applied supply adjustment by 1 / rebaseLag
                If the rebase lag R, equals 1, the smallest value for R, then the full supply
                correction is applied on each rebase cycle.
                If it is greater than 1, then a correction of 1/R of is applied on each rebase.
        * @param rebaseLag_ The new rebase lag parameter.
        */
       function setRebaseLag(uint256 rebaseLag_)
            external
            onlyOwner
        {
            require(rebaseLag_ > 0);
            rebaseLag = rebaseLag_;
        }

        /**
        * @notice Sets the parameters which control the timing and frequency of
        *         rebase operations.
        *         a) the minimum time period that must elapse between rebase cycles.
        *         b) the rebase window offset parameter.
        *         c) the rebase window length parameter.
        * @param minRebaseTimeIntervalSec_ More than this much time must pass between rebase
        *        operations, in seconds.
        * @param rebaseWindowOffsetSec_ The number of seconds from the beginning of
                the rebase interval, where the rebase window begins.
        * @param rebaseWindowLengthSec_ The length of the rebase window in seconds.
        */
         function setRebaseTimingParameters(
            uint256 minRebaseTimeIntervalSec_,
            uint256 rebaseWindowOffsetSec_,
            uint256 rebaseWindowLengthSec_)
            external
            onlyOwner
        {
            require(minRebaseTimeIntervalSec_ > 0);
            require(rebaseWindowOffsetSec_ < minRebaseTimeIntervalSec_);

            minRebaseTimeIntervalmin = minRebaseTimeIntervalSec_;
            rebaseWindowOffsetmin = rebaseWindowOffsetSec_;
            rebaseWindowLengthhours = rebaseWindowLengthSec_;
        }


        /**
        * @return If the latest block timestamp is within the rebase time window it, returns true.
        *         Otherwise, returns false.
        */
        function inRebaseWindow() public view returns (bool) {
            return (
                block.timestamp.mod(minRebaseTimeIntervalmin) >= rebaseWindowOffsetmin &&
                block.timestamp.mod(minRebaseTimeIntervalmin) < (rebaseWindowOffsetmin.add(rebaseWindowLengthhours))
            );
        }

        /**
        * @return Computes the total supply adjustment in response to the exchange rate
        *         and the targetRate.
        */
        function computeSupplyDelta(uint256 rate, uint256 targetRate)
            public
            view
            returns (int256)
        {
            if (withinDeviationThreshold(rate, targetRate)) {
                return 0;
            }

            // supplyDelta = totalSupply * (rate - targetRate) / targetRate
            int256 targetRateSigned = targetRate.toInt256Safe();
            return  eBNBmoney.totalSupply().toInt256Safe()
                .mul(rate.toInt256Safe().sub(targetRateSigned))
                .div(targetRateSigned);
        }

        /**
        *  current exchange rate is  an 18 decimal fixed point number.
        *  The target exchange rate is an 18 decimal fixed point number.
        *  If the rate is within the deviation threshold from the target rate, returns true.
        *         Otherwise, returns false.
        */
       function withinDeviationThreshold(uint256 rate, uint256 targetRate)
            private
            view
            returns (bool)
        {
            uint256 absoluteDeviationThreshold = targetRate.mul(deviationThreshold)
                .div(10 ** DECIMALS);

            return (rate >= targetRate && rate.sub(targetRate) < absoluteDeviationThreshold)
                || (rate < targetRate && targetRate.sub(rate) < absoluteDeviationThreshold);
        }
    }