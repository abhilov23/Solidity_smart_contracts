// SPDX-License-Identifier: MIT
 pragma solidity ^0.8.0;
 
 import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

 library PriceConverter {
    function getPrice() internal view returns(uint256) { //converting the msg.value to USD price
  // To interact with any other smart contract we need:
  //1. ABI
  //2. Address 0x694AA1769357215DE4FAC081bf1f309aDC325306
  AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
  (,int256 answer,,,) = priceFeed.latestRoundData();
  // price of ETH in terms of USD
  //3000.00000000
  return uint256(answer * 1e10); //1**10 == 10000000000

}

function getVersion() internal view returns(uint256){
  AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
  return priceFeed.version();
}

function getConversionRate(uint256 ethAmount) internal view returns(uint256){
  uint256 ethPrice = getPrice();
  uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
  return ethAmountInUsd;
} 
 }
