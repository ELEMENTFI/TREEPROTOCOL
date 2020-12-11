// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0;

import "./BEP20Token.sol";
import "../../utils/Pausable.sol";
import "../../Initializable.sol";

/**
 * @dev BEP20 token with pausable token transfers, minting and burning.
 *
 * Useful for scenarios such as preventing trades until the end of an evaluation
 * period, or having an emergency switch for freezing all token transfers in the
 * event of a large bug.
 */
abstract contract BEP20PausableUpgradeSafe is Initializable, BEP20Token, PausableUpgradeSafe {
    function __BEP20Pausable_init() internal initializer {
        __Context_init_unchained();
        __Pausable_init_unchained();
        __BEP20Pausable_init_unchained();
    }

    function __BEP20Pausable_init_unchained() internal initializer {


    }

    /**
     * @dev See {BEP20-_beforeTokenTransfer}.
     *
     * Requirements:
     *
     * - the contract must not be paused.
     */
   

    uint256[50] private __gap;
}