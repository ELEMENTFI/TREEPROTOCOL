

// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;

/**
 * @dev Standard math utilities missing in the Solidity language.
 */
library Math {
    /**
     * @dev Returns the largest of two numbers.
     */
    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a >= b ? a : b;
    }

    /**
     * @dev Returns the smallest of two numbers.
     */
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }

    /**
     * @dev Returns the average of two numbers. The result is rounded towards
     * zero.
     */
    function average(uint256 a, uint256 b) internal pure returns (uint256) {
        // (a + b) / 2 can overflow, so we distribute
        return (a / 2) + (b / 2) + (((a % 2) + (b % 2)) / 2);
    }
}

/**
 * @dev Interface of the BEP20 standard as defined in the EIP.
 */
interface IBEP20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies in extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain`call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        return _functionCallWithValue(target, data, value, errorMessage);
    }

    function _functionCallWithValue(
        address target,
        bytes memory data,
        uint256 weiValue,
        string memory errorMessage
    ) private returns (bytes memory) {
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{value: weiValue}(data);
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

/**
 * @title SafeBEP20
 * @dev Wrappers around BEP20 operations that throw on failure (when the token
 * contract returns false). Tokens that return no value (and instead revert or
 * throw on failure) are also supported, non-reverting calls are assumed to be
 * successful.
 * To use this library you can add a `using SafeBEP20 for IBEP20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeBEP20 {
    using SafeMath for uint256;
    using Address for address;

    function safeTransfer(
        IBEP20 token,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(
        IBEP20 token,
        address from,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    /**
     * @dev Deprecated. This function has issues similar to the ones found in
     * {IBEP20-approve}, and its usage is discouraged.
     *
     * Whenever possible, use {safeIncreaseAllowance} and
     * {safeDecreaseAllowance} instead.
     */
    function safeApprove(
        IBEP20 token,
        address spender,
        uint256 value
    ) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require((value == 0) || (token.allowance(address(this), spender) == 0), "SafeBEP20: approve from non-zero to non-zero allowance");
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(
        IBEP20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(value);
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(
        IBEP20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeBEP20: decreased allowance below zero");
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function _callOptionalReturn(IBEP20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory returndata = address(token).functionCall(data, "SafeBEP20: low-level call failed");
        if (returndata.length > 0) {
            // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeBEP20: BEP20 operation did not succeed");
        }
    }
}

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() internal {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and make it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        // On the first call to nonReentrant, _notEntered will be true
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }
}

library Babylonian {
    function sqrt(uint256 y) internal pure returns (uint256 z) {
        if (y > 3) {
            z = y;
            uint256 x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
        // else z = 0
    }
}

/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() internal {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

contract Operator is Context, Ownable {
    address private _operator;

    event OperatorTransferred(address indexed previousOperator, address indexed newOperator);

    constructor() internal {
        _operator = _msgSender();
        emit OperatorTransferred(address(0), _operator);
    }

    function operator() public view returns (address) {
        return _operator;
    }

    modifier onlyOperator() {
        require(_operator == msg.sender, "operator: caller is not the operator");
        _;
    }

    function isOperator() public view returns (bool) {
        return _msgSender() == _operator;
    }

    function transferOperator(address newOperator_) public onlyOwner {
        _transferOperator(newOperator_);
    }

    function _transferOperator(address newOperator_) internal {
        require(newOperator_ != address(0), "operator: zero address given for new operator");
        emit OperatorTransferred(address(0), newOperator_);
        _operator = newOperator_;
    }
}

contract ContractGuard {
    mapping(uint256 => mapping(address => bool)) private _status;

    function checkSameOriginReentranted() internal view returns (bool) {
        return _status[block.number][tx.origin];
    }

    function checkSameSenderReentranted() internal view returns (bool) {
        return _status[block.number][msg.sender];
    }

    modifier onlyOneBlock() {
        require(!checkSameOriginReentranted(), "ContractGuard: one block, one function");
        require(!checkSameSenderReentranted(), "ContractGuard: one block, one function");

        _;

        _status[block.number][tx.origin] = true;
        _status[block.number][msg.sender] = true;
    }
}

interface IBasisAsset {
    function mint(address recipient, uint256 amount) external returns (bool);

    function burn(uint256 amount) external;

    function burnFrom(address from, uint256 amount) external;

    function isOperator() external returns (bool);

    function operator() external view returns (address);
}

interface IOracle {
    function update() external;

    function consult(address _token, uint256 _amountIn) external view returns (uint144 amountOut);

    function twap(address _token, uint256 _amountIn) external view returns (uint144 _amountOut);
}

interface IBoardroom {
    function balanceOf(address _director) external view returns (uint256);

    function earned(address _director) external view returns (uint256);

    function canWithdraw(address _director) external view returns (bool);

    function canClaimReward(address _director) external view returns (bool);

    function epoch() external view returns (uint256);

    function nextEpochPoint() external view returns (uint256);

    function getDollarPrice() external view returns (uint256);

    function setOperator(address _operator) external;

    function setLockUp(uint256 _withdrawLockupEpochs, uint256 _rewardLockupEpochs) external;

    function addPegToken(address _token, address _room) external;

    function setBpTokenBoardroom(address _token, address _room) external;

    function stake(uint256 _amount) external;

    function withdraw(uint256 _amount) external;

    function exit() external;

    function claimReward() external;

    function allocateSeigniorage(uint256 _amount) external;

    function allocateSeignioragePegToken(address _token, uint256 _amount) external;

    function governanceRecoverUnsupported(
        address _token,
        uint256 _amount,
        address _to
    ) external;
}

/**
 * @title Basis Dollar Treasury contract
 * @notice Monetary policy logic to adjust supplies of basis dollar assets
 * @author Summer Smith & Rick Sanchez
 */
contract Treasury is ContractGuard {
    using SafeBEP20 for IBEP20;
    using Address for address;
    using SafeMath for uint256;

    /* ========= CONSTANT VARIABLES ======== */

    uint256 public constant PERIOD = 6 hours;

    /* ========== STATE VARIABLES ========== */

    // governance
    address public operator;

    // flags
    bool public migrated = false;
    bool public initialized = false;

    // epoch
    uint256 public startTime;
    uint256 public epoch = 0;
    uint256 public epochSupplyContractionLeft = 0;

    // core components
    address public dollar = address(0xAb956B372CE8B5f7757F80E059fCD82290deC151);
    address public bond = address(0x1cb5B58ef258D62dd5A5180cf774fb08e4580d9c);
    address public share = address(0x63B80368b1e6ADd5708B58461477e7343824057e);

    address public boardroom;
    address public dollarOracle;

    // price
    uint256 public dollarPriceOne;
    uint256 public dollarPriceCeiling;

    uint256 public seigniorageSaved;

    // protocol parameters - https://github.com/bearn-defi/bdollar-smartcontracts/tree/master/docs/ProtocolParameters.md
    uint256 public maxSupplyExpansionPercent;
    uint256 public maxSupplyExpansionPercentInDebtPhase;
    uint256 public bondDepletionFloorPercent;
    uint256 public seigniorageExpansionFloorPercent;
    uint256 public maxSupplyContractionPercent;
    uint256 public maxDeptRatioPercent;

    /* =================== BDOIPs (bDollar Improvement Proposals) =================== */

    // BDOIP01: 28 first epochs (1 week) with 4.5% expansion regardless of BDO price
    uint256 public bdoip01BootstrapEpochs;
    uint256 public bdoip01BootstrapSupplyExpansionPercent;

    /* =================== Added variables (need to keep orders for proxy to work) =================== */
    uint256 public previousEpochDollarPrice;
    uint256 public allocateSeigniorageSalary;
    uint256 public maxDiscountRate; // when purchasing bond
    uint256 public maxPremiumRate; // when redeeming bond
    uint256 public discountPercent;
    uint256 public premiumPercent;
    uint256 public mintingFactorForPayingDebt; // print extra BDO during dept phase

    // BDOIP03: 10% of minted BDO goes to Community DAO Fund
    address public daoFund;
    uint256 public daoFundSharedPercent;

    // BDOIP04: 15% to DAO Fund, 3% to bVaults incentive fund, 2% to MKT
    address public bVaultsFund;
    uint256 public bVaultsFundSharedPercent;
    address public marketingFund;
    uint256 public marketingFundSharedPercent;

    // BDOIP05
    uint256 public externalRewardAmount; // buy back BDO by bVaults
    uint256 public externalRewardSharedPercent; // 100 = 1%
    uint256 public contractionBondRedeemPenaltyPercent;
    uint256 public incentiveByBondPurchaseAmount;
    uint256 public incentiveByBondPurchasePercent; // 500 = 5%
    mapping(uint256 => bool) public isContractionEpoch; // epoch => contraction (true/false)

    // Multi-Pegs
    address[] public pegTokens;
    mapping(address => address) public pegTokenOracle;
    mapping(address => address) public pegTokenFarmingPool; // to exclude balance from supply
    mapping(address => uint256) public pegTokenEpochStart;
    mapping(address => uint256) public pegTokenSupplyTarget;
    mapping(address => uint256) public pegTokenMaxSupplyExpansionPercent; // 1% = 10000

    /* =================== Events =================== */

    event Initialized(address indexed executor, uint256 at);
    event Migration(address indexed target);
    event RedeemedBonds(address indexed from, uint256 dollarAmount, uint256 bondAmount);
    event BoughtBonds(address indexed from, uint256 dollarAmount, uint256 bondAmount);
    event TreasuryFunded(uint256 timestamp, uint256 seigniorage);
    event BoardroomFunded(uint256 timestamp, uint256 seigniorage);
    event DaoFundFunded(uint256 timestamp, uint256 seigniorage);
    event BVaultsFundFunded(uint256 timestamp, uint256 seigniorage);
    event MarketingFundFunded(uint256 timestamp, uint256 seigniorage);
    event ExternalRewardAdded(uint256 timestamp, uint256 dollarAmount);
    event PegTokenBoardroomFunded(address pegToken, uint256 timestamp, uint256 seigniorage);
    event PegTokenDaoFundFunded(address pegToken, uint256 timestamp, uint256 seigniorage);
    event PegTokenMarketingFundFunded(address pegToken, uint256 timestamp, uint256 seigniorage);

    /* =================== Modifier =================== */

    modifier onlyOperator() {
        require(operator == msg.sender, "!operator");
        _;
    }

    modifier checkCondition {
        require(!migrated, "migrated");
        require(now >= startTime, "!started");

        _;
    }

    modifier checkEpoch {
        require(now >= nextEpochPoint(), "!opened");

        _;

        epoch = epoch.add(1);
        epochSupplyContractionLeft = (getDollarPrice() > dollarPriceCeiling) ? 0 : IBEP20(dollar).totalSupply().mul(maxSupplyContractionPercent).div(10000);
    }

    modifier checkOperator {
        require(
            IBasisAsset(dollar).operator() == address(this) &&
                IBasisAsset(bond).operator() == address(this) &&
                IBasisAsset(share).operator() == address(this) &&
                Operator(boardroom).operator() == address(this),
            "Treasury: need more permission"
        );

        _;
    }

    modifier notInitialized {
        require(!initialized, "initialized");

        _;
    }

    /* ========== VIEW FUNCTIONS ========== */

    // flags
    function isMigrated() public view returns (bool) {
        return migrated;
    }

    function isInitialized() public view returns (bool) {
        return initialized;
    }

    // epoch
    function nextEpochPoint() public view returns (uint256) {
        return startTime.add(epoch.mul(PERIOD));
    }

    function nextEpochLength() public pure returns (uint256) {
        return PERIOD;
    }

  // oracle
    function getDollarPrice() public view returns (uint256 dollarPrice) {
        try IOracle(dollarOracle).consult(dollar, 1e18) returns (uint144 price) {
            return uint256(price);
        } catch {
            revert("oracle failed");
        }
    }
    
 
/**function getDollarPrice() public view returns (uint256 ) {
     uint256 dollarPrice=1000000;
     return(dollarPrice);
    }**/
    function getDollarUpdatedPrice() public view returns (uint256 _dollarPrice) {
        try IOracle(dollarOracle).twap(dollar, 1e18) returns (uint144 price) {
            return uint256(price);
        } catch {
            revert("oracle failed");
        }
    }

    function getPegTokenPrice(address _token) public view returns (uint256 _pegTokenPrice) {
        if (_token == dollar) {
            return getDollarPrice();
        }
        try IOracle(pegTokenOracle[_token]).consult(_token, 1e18) returns (uint144 price) {
            return uint256(price);
        } catch {
            revert("oracle failed");
        }
    }

    function getPegTokenUpdatedPrice(address _token) public view returns (uint256 _pegTokenPrice) {
        if (_token == dollar) {
            return getDollarUpdatedPrice();
        }
        try IOracle(pegTokenOracle[_token]).twap(_token, 1e18) returns (uint144 price) {
            return uint256(price);
        } catch {
            revert("oracle failed");
        }
    }

    // budget
    function getReserve() public view returns (uint256) {
        return seigniorageSaved;
    }

    function getBurnableDollarLeft() public view returns (uint256 _burnableDollarLeft) {
        uint256 _dollarPrice = getDollarPrice();
        if (_dollarPrice <= dollarPriceOne) {
            uint256 _dollarSupply = IBEP20(dollar).totalSupply();
            uint256 _bondMaxSupply = _dollarSupply.mul(maxDeptRatioPercent).div(10000);
            uint256 _bondSupply = IBEP20(bond).totalSupply();
            if (_bondMaxSupply > _bondSupply) {
                uint256 _maxMintableBond = _bondMaxSupply.sub(_bondSupply);
                uint256 _maxBurnableDollar = _maxMintableBond.mul(_dollarPrice).div(1e18);
                _burnableDollarLeft = Math.min(epochSupplyContractionLeft, _maxBurnableDollar);
            }
        }
    }

    function getRedeemableBonds() public view returns (uint256 _redeemableBonds) {
        uint256 _dollarPrice = getDollarPrice();
        if (_dollarPrice > dollarPriceCeiling) {
            uint256 _totalDollar = IBEP20(dollar).balanceOf(address(this));
            uint256 _rewardAmount = externalRewardAmount.add(incentiveByBondPurchaseAmount);
            if (_totalDollar > _rewardAmount) {
                uint256 _rate = getBondPremiumRate();
                if (_rate > 0) {
                    _redeemableBonds = _totalDollar.sub(_rewardAmount).mul(1e18).div(_rate);
                }
            }
        }
    }

    function getBondDiscountRate() public view returns (uint256 _rate) {
        uint256 _dollarPrice = getDollarPrice();
        if (_dollarPrice <= dollarPriceOne) {
            if (discountPercent == 0) {
                // no discount
                _rate = dollarPriceOne;
            } else {
                uint256 _bondAmount = dollarPriceOne.mul(1e18).div(_dollarPrice); // to burn 1 dollar
                uint256 _discountAmount = _bondAmount.sub(dollarPriceOne).mul(discountPercent).div(10000);
                _rate = dollarPriceOne.add(_discountAmount);
                if (maxDiscountRate > 0 && _rate > maxDiscountRate) {
                    _rate = maxDiscountRate;
                }
            }
        }
    }

    function getBondPremiumRate() public view returns (uint256 _rate) {
        uint256 _dollarPrice = getDollarPrice();
        if (_dollarPrice > dollarPriceCeiling) {
            if (premiumPercent == 0) {
                // no premium bonus
                _rate = dollarPriceOne;
            } else {
                uint256 _premiumAmount = _dollarPrice.sub(dollarPriceOne).mul(premiumPercent).div(10000);
                _rate = dollarPriceOne.add(_premiumAmount);
                if (maxDiscountRate > 0 && _rate > maxDiscountRate) {
                    _rate = maxDiscountRate;
                }
            }
        }
    }

    function getBondRedeemTaxRate() public view returns (uint256 _rate) {
        // BDOIP05:
        // 10% tax will be charged (to burn) for claimed BDO rewards for the first expansion epoch after contraction.
        // 5% tax will be charged (to burn) for claimed BDO rewards for the 2nd of consecutive expansion epoch after contraction.
        // No tax is charged from the 3rd expansion epoch onward
        if (epoch >= 1 && isContractionEpoch[epoch - 1]) {
            _rate = 9000;
        } else if (epoch >= 2 && isContractionEpoch[epoch - 2]) {
            _rate = 9500;
        } else {
            _rate = 10000;
        }
    }

    function getBoardroomContractionReward() external view returns (uint256) {
        uint256 _dollarBal = IBEP20(dollar).balanceOf(address(this));
        uint256 _externalRewardAmount = (externalRewardAmount > _dollarBal) ? _dollarBal : externalRewardAmount;
        return _externalRewardAmount.mul(externalRewardSharedPercent).div(10000).add(incentiveByBondPurchaseAmount); // BDOIP05
    }

    function pegTokenLength() external view returns (uint256) {
        return pegTokens.length;
    }

    function getCirculatingSupply(address _token) public view returns (uint256) {
        return IBEP20(_token).totalSupply().sub(IBEP20(_token).balanceOf(pegTokenFarmingPool[_token]));
    }

    function getPegTokenExpansionRate(address _pegToken) public view returns (uint256 _rate) {
        uint256 _twap = getPegTokenUpdatedPrice(_pegToken);
        if (_twap > dollarPriceCeiling) {
            uint256 _percentage = _twap.sub(dollarPriceOne); // 1% = 1e16
            uint256 _mse = (_pegToken == dollar) ? maxSupplyExpansionPercent.mul(1e14) : pegTokenMaxSupplyExpansionPercent[_pegToken].mul(1e12);
            if (_percentage > _mse) {
                _percentage = _mse;
            }
            _rate = _percentage.div(1e12);
        }
    }

    function getPegTokenExpansionAmount(address _pegToken) external view returns (uint256) {
        uint256 _rate = getPegTokenExpansionRate(_pegToken);
        return getCirculatingSupply(_pegToken).mul(_rate).div(1e6);
    }

    /* ========== GOVERNANCE ========== */

    function initialize(
        address _dollar,
        address _bond,
        address _share,
        uint256 _startTime
    ) public notInitialized {
        dollar = _dollar;
        bond = _bond;
        share = _share;
        startTime = _startTime;

        dollarPriceOne = 10**18;
        dollarPriceCeiling = dollarPriceOne.mul(101).div(100);

        maxSupplyExpansionPercent = 300; // Upto 3.0% supply for expansion
        maxSupplyExpansionPercentInDebtPhase = 450; // Upto 4.5% supply for expansion in debt phase (to pay debt faster)
        bondDepletionFloorPercent = 10000; // 100% of Bond supply for depletion floor
        seigniorageExpansionFloorPercent = 3500; // At least 35% of expansion reserved for boardroom
        maxSupplyContractionPercent = 300; // Upto 3.0% supply for contraction (to burn BDO and mint bBDO)
        maxDeptRatioPercent = 3500; // Upto 35% supply of bBDO to purchase

        // BDIP01: First 28 epochs with 4.5% expansion
        bdoip01BootstrapEpochs = 28;
        bdoip01BootstrapSupplyExpansionPercent = 450;

        // set seigniorageSaved to it's balance
        seigniorageSaved = IBEP20(dollar).balanceOf(address(this));

        initialized = true;
        operator = msg.sender;
        emit Initialized(msg.sender, block.number);
    }

    function setOperator(address _operator) external onlyOperator {
        operator = _operator;
    }

    function setBoardroom(address _boardroom) external onlyOperator {
        boardroom = _boardroom;
    }

    function setDollarOracle(address _dollarOracle) external onlyOperator {
        dollarOracle = _dollarOracle;
    }

    function setDollarPricePeg(uint256 _dollarPriceOne, uint256 _dollarPriceCeiling) external onlyOperator {
        require(_dollarPriceOne >= 0.9 ether && _dollarPriceOne <= 1 ether, "out range"); // [$0.9, $1.0]
        require(_dollarPriceCeiling >= _dollarPriceOne && _dollarPriceCeiling <= _dollarPriceOne.mul(120).div(100), "out range"); // [$0.9, $1.2]
        dollarPriceOne = _dollarPriceOne;
        dollarPriceCeiling = _dollarPriceCeiling;
    }

    function setMaxSupplyExpansionPercents(uint256 _maxSupplyExpansionPercent, uint256 _maxSupplyExpansionPercentInDebtPhase) external onlyOperator {
        require(_maxSupplyExpansionPercent >= 10 && _maxSupplyExpansionPercent <= 1000, "out range"); // [0.1%, 10%]
        require(_maxSupplyExpansionPercentInDebtPhase >= 10 && _maxSupplyExpansionPercentInDebtPhase <= 1500, "out range"); // [0.1%, 15%]
        require(_maxSupplyExpansionPercent <= _maxSupplyExpansionPercentInDebtPhase, "out range");
        maxSupplyExpansionPercent = _maxSupplyExpansionPercent;
        maxSupplyExpansionPercentInDebtPhase = _maxSupplyExpansionPercentInDebtPhase;
        maxSupplyContractionPercent = _maxSupplyExpansionPercent;
    }

    function setExtraFunds(
        address _daoFund,
        uint256 _daoFundSharedPercent,
        address _bVaultsFund,
        uint256 _bVaultsFundSharedPercent,
        address _marketingFund,
        uint256 _marketingFundSharedPercent
    ) external onlyOperator {
        require(_daoFund != address(0), "zero");
        require(_daoFundSharedPercent <= 3000, "out of range"); // <= 30%
        require(_bVaultsFund != address(0), "zero");
        require(_bVaultsFundSharedPercent <= 1000, "out of range"); // <= 10%
        require(_marketingFund != address(0), "zero");
        require(_marketingFundSharedPercent <= 1000, "out of range"); // <= 10%
        daoFund = _daoFund;
        daoFundSharedPercent = _daoFundSharedPercent;
        bVaultsFund = _bVaultsFund;
        bVaultsFundSharedPercent = _bVaultsFundSharedPercent;
        marketingFund = _marketingFund;
        marketingFundSharedPercent = _marketingFundSharedPercent;
    }

    function setAllocateSeigniorageSalary(uint256 _allocateSeigniorageSalary) external onlyOperator {
        require(_allocateSeigniorageSalary <= 100 ether, "pay too much");
        allocateSeigniorageSalary = _allocateSeigniorageSalary;
    }

    function setMaxDiscountPremiumRate(uint256 _maxDiscountRate, uint256 _maxPremiumRate) external onlyOperator {
        maxDiscountRate = _maxDiscountRate;
        maxPremiumRate = _maxPremiumRate;
    }

    function setDiscountPremiumPercent(uint256 _discountPercent, uint256 _premiumPercent) external onlyOperator {
        require(_discountPercent <= 20000 && _premiumPercent <= 20000, "out range");
        discountPercent = _discountPercent;
        premiumPercent = _premiumPercent;
    }

    function setExternalRewardSharedPercent(uint256 _externalRewardSharedPercent) external onlyOperator {
        require(_externalRewardSharedPercent >= 100 && _externalRewardSharedPercent <= 5000, "out range"); // [1%, 50%]
        externalRewardSharedPercent = _externalRewardSharedPercent;
    }

    // set contractionBondRedeemPenaltyPercent = 0 to disable the redeem bond during contraction
    function setContractionBondRedeemPenaltyPercent(uint256 _contractionBondRedeemPenaltyPercent) external onlyOperator {
        require(_contractionBondRedeemPenaltyPercent <= 5000, "out range"); // <= 50%
        contractionBondRedeemPenaltyPercent = _contractionBondRedeemPenaltyPercent;
    }

    function setIncentiveByBondPurchasePercent(uint256 _incentiveByBondPurchasePercent) external onlyOperator {
        require(_incentiveByBondPurchasePercent <= 5000, "out range"); // <= 50%
        incentiveByBondPurchasePercent = _incentiveByBondPurchasePercent;
    }

    function addPegToken(address _token) external onlyOperator {
        require(IBEP20(_token).totalSupply() > 0, "invalid token");
        pegTokens.push(_token);
    }

    function setPegTokenConfig(
        address _token,
        address _oracle,
        address _pool,
        uint256 _epochStart,
        uint256 _supplyTarget,
        uint256 _expansionPercent
    ) external onlyOperator {
        pegTokenOracle[_token] = _oracle;
        pegTokenFarmingPool[_token] = _pool;
        pegTokenEpochStart[_token] = _epochStart;
        pegTokenSupplyTarget[_token] = _supplyTarget;
        pegTokenMaxSupplyExpansionPercent[_token] = _expansionPercent;
    }

    function migrate(address target) external onlyOperator checkOperator {
        require(!migrated, "migrated");

        // dollar
        Operator(dollar).transferOperator(target);
        Operator(dollar).transferOwnership(target);
        IBEP20(dollar).transfer(target, IBEP20(dollar).balanceOf(address(this)));

        // bond
        Operator(bond).transferOperator(target);
        Operator(bond).transferOwnership(target);
        IBEP20(bond).transfer(target, IBEP20(bond).balanceOf(address(this)));

        // share
        Operator(share).transferOperator(target);
        Operator(share).transferOwnership(target);
        IBEP20(share).transfer(target, IBEP20(share).balanceOf(address(this)));

        migrated = true;
        emit Migration(target);
    }

    /* ========== MUTABLE FUNCTIONS ========== */

    function _updateDollarPrice() internal {
        try IOracle(dollarOracle).update() {} catch {}
    }

    function _updatePegTokenPrice(address _token) internal {
        try IOracle(pegTokenOracle[_token]).update() {} catch {}
    }

    function buyBonds(uint256 _dollarAmount, uint256 targetPrice) external onlyOneBlock checkCondition checkOperator {
        require(_dollarAmount > 0, "zero amount");

        uint256 dollarPrice = getDollarPrice();
        require(dollarPrice == targetPrice, "price moved");
        require(
            dollarPrice < dollarPriceOne, // price < $1
            "not eligible"
        );

        require(_dollarAmount <= epochSupplyContractionLeft, "not enough bond");

        uint256 _rate = getBondDiscountRate();
        require(_rate > 0, "invalid bond rate");

        uint256 _bondAmount = _dollarAmount.mul(_rate).div(1e18);
        uint256 dollarSupply = IBEP20(dollar).totalSupply();
        uint256 newBondSupply = IBEP20(bond).totalSupply().add(_bondAmount);
        require(newBondSupply <= dollarSupply.mul(maxDeptRatioPercent).div(10000), "over max debt ratio");
        IBEP20(dollar).safeTransferFrom(msg.sender, address(this), _dollarAmount);

        if (incentiveByBondPurchasePercent > 0) {
            uint256 _incentiveByBondPurchase = _dollarAmount.mul(incentiveByBondPurchasePercent).div(10000);
            incentiveByBondPurchaseAmount = incentiveByBondPurchaseAmount.add(_incentiveByBondPurchase);
            _dollarAmount = _dollarAmount.sub(_incentiveByBondPurchase);
        }

        IBasisAsset(dollar).burn(_dollarAmount);
        IBasisAsset(bond).mint(msg.sender, _bondAmount);

        epochSupplyContractionLeft = epochSupplyContractionLeft.sub(_dollarAmount);
        _updateDollarPrice();

        emit BoughtBonds(msg.sender, _dollarAmount, _bondAmount);
    }

    function redeemBonds(uint256 _bondAmount, uint256 targetPrice) external onlyOneBlock checkCondition checkOperator {
        require(_bondAmount > 0, "zero amount");

        uint256 dollarPrice = getDollarPrice();
        require(dollarPrice == targetPrice, "price moved");

        uint256 _dollarAmount;

        if (dollarPrice < dollarPriceOne) {
            uint256 _contractionBondRedeemPenaltyPercent = contractionBondRedeemPenaltyPercent;
            require(_contractionBondRedeemPenaltyPercent > 0, "not allow");
            uint256 _penalty = _bondAmount.mul(_contractionBondRedeemPenaltyPercent).div(10000);
            _dollarAmount = _bondAmount.sub(_penalty);
            IBasisAsset(dollar).mint(address(this), _dollarAmount);
        } else {
            require(
                dollarPrice > dollarPriceCeiling, // price > $1.01
                "not eligible"
            );
            uint256 _rate = getBondPremiumRate();
            require(_rate > 0, "invalid bond rate");

            _dollarAmount = _bondAmount.mul(_rate).div(1e18);

            uint256 _bondRedeemTaxRate = getBondRedeemTaxRate();
            _dollarAmount = _dollarAmount.mul(_bondRedeemTaxRate).div(10000); // BDOIP05

            require(
                IBEP20(dollar).balanceOf(address(this)) >= _dollarAmount.add(externalRewardAmount).add(incentiveByBondPurchaseAmount),
                "has no more budget"
            );
            seigniorageSaved = seigniorageSaved.sub(Math.min(seigniorageSaved, _dollarAmount));
        }

        IBasisAsset(bond).burnFrom(msg.sender, _bondAmount);
        IBEP20(dollar).safeTransfer(msg.sender, _dollarAmount);

        _updateDollarPrice();

        emit RedeemedBonds(msg.sender, _dollarAmount, _bondAmount);
    }

    function _sendToBoardRoom(uint256 _amount) internal {
        IBasisAsset(dollar).mint(address(this), _amount);
        if (daoFundSharedPercent > 0) {
            uint256 _daoFundSharedAmount = _amount.mul(daoFundSharedPercent).div(10000);
            IBEP20(dollar).transfer(daoFund, _daoFundSharedAmount);
            emit DaoFundFunded(now, _daoFundSharedAmount);
            _amount = _amount.sub(_daoFundSharedAmount);
        }
        if (bVaultsFundSharedPercent > 0) {
            uint256 _bVaultsFundSharedAmount = _amount.mul(bVaultsFundSharedPercent).div(10000);
            IBEP20(dollar).transfer(bVaultsFund, _bVaultsFundSharedAmount);
            emit BVaultsFundFunded(now, _bVaultsFundSharedAmount);
            _amount = _amount.sub(_bVaultsFundSharedAmount);
        }
        if (marketingFundSharedPercent > 0) {
            uint256 _marketingSharedAmount = _amount.mul(marketingFundSharedPercent).div(10000);
            IBEP20(dollar).transfer(marketingFund, _marketingSharedAmount);
            emit MarketingFundFunded(now, _marketingSharedAmount);
            _amount = _amount.sub(_marketingSharedAmount);
        }
        IBEP20(dollar).safeApprove(boardroom, 0);
        IBEP20(dollar).safeApprove(boardroom, _amount);
        IBoardroom(boardroom).allocateSeigniorage(_amount);
        emit BoardroomFunded(now, _amount);
    }

    function allocateSeigniorage() external onlyOneBlock checkCondition checkEpoch checkOperator {
        _updateDollarPrice();
        previousEpochDollarPrice = getDollarPrice();
        uint256 dollarSupply = IBEP20(dollar).totalSupply().sub(seigniorageSaved);
        if (epoch < bdoip01BootstrapEpochs) {
            // BDOIP01: 28 first epochs with 4.5% expansion
            _sendToBoardRoom(dollarSupply.mul(bdoip01BootstrapSupplyExpansionPercent).div(10000));
        } else {
            if (previousEpochDollarPrice > dollarPriceCeiling) {
                // Expansion ($BDO Price > 1$): there is some seigniorage to be allocated
                uint256 bondSupply = IBEP20(bond).totalSupply();
                uint256 _percentage = previousEpochDollarPrice.sub(dollarPriceOne);
                uint256 _savedForBond;
                uint256 _savedForBoardRoom;
                if (seigniorageSaved >= bondSupply.mul(bondDepletionFloorPercent).div(10000)) {
                    // saved enough to pay dept, mint as usual rate
                    uint256 _mse = maxSupplyExpansionPercent.mul(1e14);
                    if (_percentage > _mse) {
                        _percentage = _mse;
                    }
                    _savedForBoardRoom = dollarSupply.mul(_percentage).div(1e18);
                } else {
                    // have not saved enough to pay dept, mint more
                    uint256 _mse = maxSupplyExpansionPercentInDebtPhase.mul(1e14);
                    if (_percentage > _mse) {
                        _percentage = _mse;
                    }
                    uint256 _seigniorage = dollarSupply.mul(_percentage).div(1e18);
                    _savedForBoardRoom = _seigniorage.mul(seigniorageExpansionFloorPercent).div(10000);
                    _savedForBond = _seigniorage.sub(_savedForBoardRoom);
                    if (mintingFactorForPayingDebt > 0) {
                        _savedForBond = _savedForBond.mul(mintingFactorForPayingDebt).div(10000);
                    }
                }
                if (_savedForBoardRoom > 0) {
                    _sendToBoardRoom(_savedForBoardRoom);
                }
                if (_savedForBond > 0) {
                    seigniorageSaved = seigniorageSaved.add(_savedForBond);
                    IBasisAsset(dollar).mint(address(this), _savedForBond);
                    emit TreasuryFunded(now, _savedForBond);
                }
            } else {
                // Contraction ($BDO Price <= 1$): there is some external reward to be allocated
                uint256 _externalRewardAmount = externalRewardAmount;
                uint256 _dollarBal = IBEP20(dollar).balanceOf(address(this));
                if (_externalRewardAmount > _dollarBal) {
                    externalRewardAmount = _dollarBal;
                    _externalRewardAmount = _dollarBal;
                }
                if (_externalRewardAmount > 0) {
                    uint256 _externalRewardSharedPercent = externalRewardSharedPercent;
                    if (_externalRewardSharedPercent > 0) {
                        uint256 _rewardFromExternal = _externalRewardAmount.mul(_externalRewardSharedPercent).div(10000);
                        uint256 _rewardForBoardRoom = _rewardFromExternal.add(incentiveByBondPurchaseAmount);
                        if (_rewardForBoardRoom > _dollarBal) {
                            _rewardForBoardRoom = _dollarBal;
                        }
                        incentiveByBondPurchaseAmount = 0; // BDOIP05
                        IBEP20(dollar).safeApprove(boardroom, 0);
                        IBEP20(dollar).safeApprove(boardroom, _rewardForBoardRoom);
                        externalRewardAmount = _externalRewardAmount.sub(_rewardFromExternal);
                        IBoardroom(boardroom).allocateSeigniorage(_rewardForBoardRoom);
                        emit BoardroomFunded(now, _rewardForBoardRoom);
                    }
                }
                isContractionEpoch[epoch + 1] = true;
            }
        }
        if (allocateSeigniorageSalary > 0) {
            IBasisAsset(dollar).mint(address(msg.sender), allocateSeigniorageSalary);
        }
        uint256 _ptlength = pegTokens.length;
        for (uint256 _pti = 0; _pti < _ptlength; ++_pti) {
            address _pegToken = pegTokens[_pti];
            uint256 _epochStart = pegTokenEpochStart[_pegToken];
            if (_epochStart > 0 && _epochStart <= epoch.add(1)) {
                _allocateSeignioragePegToken(_pegToken);
            }
        }
    }

    function _allocateSeignioragePegToken(address _pegToken) internal {
        _updatePegTokenPrice(_pegToken);
        uint256 _supply = getCirculatingSupply(_pegToken);
        if (_supply >= pegTokenSupplyTarget[_pegToken]) {
            pegTokenSupplyTarget[_pegToken] = pegTokenSupplyTarget[_pegToken].mul(12000).div(10000); // +20%
            pegTokenMaxSupplyExpansionPercent[_pegToken] = pegTokenMaxSupplyExpansionPercent[_pegToken].mul(9750).div(10000); // -2.5%
            if (pegTokenMaxSupplyExpansionPercent[_pegToken] < 1000) {
                pegTokenMaxSupplyExpansionPercent[_pegToken] = 1000; // min 0.1%
            }
        }
        uint256 _pegTokenTwap = getPegTokenPrice(_pegToken);
        if (_pegTokenTwap > dollarPriceCeiling) {
            uint256 _percentage = _pegTokenTwap.sub(dollarPriceOne); // 1% = 1e16
            uint256 _mse = pegTokenMaxSupplyExpansionPercent[_pegToken].mul(1e12);
            if (_percentage > _mse) {
                _percentage = _mse;
            }
            uint256 _amount = _supply.mul(_percentage).div(1e18);
            if (_amount > 0) {
                IBasisAsset(_pegToken).mint(address(this), _amount);

                uint256 _daoFundSharedAmount = _amount.mul(5750).div(10000);
                IBEP20(_pegToken).transfer(daoFund, _daoFundSharedAmount);
                emit PegTokenDaoFundFunded(_pegToken, now, _daoFundSharedAmount);

                uint256 _marketingFundSharedAmount = _amount.mul(500).div(10000);
                IBEP20(_pegToken).transfer(marketingFund, _marketingFundSharedAmount);
                emit PegTokenMarketingFundFunded(_pegToken, now, _marketingFundSharedAmount);

                _amount = _amount.sub(_daoFundSharedAmount.add(_marketingFundSharedAmount));
                IBEP20(_pegToken).safeIncreaseAllowance(boardroom, _amount);
                IBoardroom(boardroom).allocateSeignioragePegToken(_pegToken, _amount);
                emit PegTokenDaoFundFunded(_pegToken, now, _amount);
            }
        }
    }

    function notifyExternalReward(uint256 _amount) external {
        IBEP20(dollar).safeTransferFrom(msg.sender, address(this), _amount);
        externalRewardAmount = externalRewardAmount.add(_amount);
        emit ExternalRewardAdded(now, _amount);
    }

    function governanceRecoverUnsupported(
        IBEP20 _token,
        uint256 _amount,
        address _to
    ) external onlyOperator {
        // do not allow to drain core tokens
        require(address(_token) != address(dollar), "dollar");
        require(address(_token) != address(bond), "bond");
        require(address(_token) != address(share), "share");
        _token.safeTransfer(_to, _amount);
    }

    /* ========== BOARDROOM CONTROLLING FUNCTIONS ========== */

    function boardroomSetConfigs(
        address _operator,
        uint256 _withdrawLockupEpochs,
        uint256 _rewardLockupEpochs
    ) external onlyOperator {
        if (_operator != address(0)) IBoardroom(boardroom).setOperator(_operator);
        IBoardroom(boardroom).setLockUp(_withdrawLockupEpochs, _rewardLockupEpochs);
    }

    function boardroomAddPegToken(address _token, address _room) external onlyOperator {
        IBoardroom(boardroom).addPegToken(_token, _room);
    }

    function boardroomSetBpTokenBoardroom(address _token, address _room) external onlyOperator {
        IBoardroom(boardroom).setBpTokenBoardroom(_token, _room);
    }

    function boardroomAllocateSeigniorage(uint256 _amount) external onlyOperator {
        IBEP20(dollar).safeIncreaseAllowance(boardroom, _amount);
        IBoardroom(boardroom).allocateSeigniorage(_amount);
    }

    function boardroomAllocateSeignioragePegToken(address _token, uint256 _amount) external onlyOperator {
        IBEP20(_token).safeIncreaseAllowance(boardroom, _amount);
        IBoardroom(boardroom).allocateSeignioragePegToken(_token, _amount);
    }
}