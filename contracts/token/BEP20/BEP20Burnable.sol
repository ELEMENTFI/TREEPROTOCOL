// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0;

import "../../GSN/Context.sol";
import "./BEP20Token.sol";
import "../../Initializable.sol";

/**
 * @dev Extension of {BEP20} that allows token holders to destroy both their own
 * tokens and those that they have an allowance for, in a way that can be
 * recognized off-chain (via event analysis).
 */
abstract contract BEP20BurnableUpgradeSafe is Initializable, ContextUpgradeSafe, BEP20Token {
    function __BEP20Burnable_init() internal initializer {
        __Context_init_unchained();
        __BEP20Burnable_init_unchained();
    }

    function __BEP20Burnable_init_unchained() internal initializer {


    }

    /**
     * @dev Destroys `amount` tokens from the caller.
     *
     * See {BEP20-_burn}.
     */
   

    /**
     * @dev Destroys `amount` tokens from `account`, deducting from the caller's
     * allowance.
     *
     * See {BEP20-_burn} and {BEP20-allowance}.
     *
     * Requirements:
     *
     * - the caller must have allowance for ``accounts``'s tokens of at least
     * `amount`.
     */
   
    uint256[50] private __gap;
}
