// SPDX-License-Identifier: MIT

pragma solidity >=0.6.7;



contract PriceConsumerV3 {

    AggregatorV3Interface internal priceFeed;

    /**
     * Network: Binance Smart Chain
     * Aggregator: BNB/USD
     * Address: 0x0567F2323251f0Aab15c8dFb1967E4e8A7D42aeE
     */
    constructor() public {
        priceFeed = AggregatorV3Interface(0xeaF302b729B450cB42b702ca96BD41450212dd38);
    }

    /**
     * Returns the latest price
     */
    function getLatestPrice() public view returns (int) {
        (
            uint80 roundID, 
            int price,
            uint startedAt,
            uint timeStamp,
            uint80 answeredInRound
        ) = priceFeed.latestRoundData();
        return price;
    }
}