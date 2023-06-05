//Get funds from users 
// Withdraw funds
//Set a minimum funding value in USD

//SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "./PriceConverter.sol";

//Importing smart contracts directly from npm

error NotOwner();

contract FundMe {
     using PriceConverter for uint256;

uint256 public constant MINIMUM_USD = 50 * 1e18;

address[] public funders;
mapping(address => uint256) public addressToAmountFunded;

address public immutable i_owner;

constructor(){
  i_owner = payable(msg.sender);
}



function fund() public payable{
  //Here we want to make a minimum requirement for fund amount in USD
  //1. How do we send ETH to this contract

  //require(msg.value >= 1e18, "Didn't send enough"); //1e18 == 1 * 10 ** 18 == 1000000000000000000 i.e: 1 ETH
  require(msg.value.getConversionRate() >= MINIMUM_USD, "Didn't send enough");
  funders.push(msg.sender);
  addressToAmountFunded[msg.sender] = msg.value;
}
/*
function getPrice() public view returns(uint256) { //converting the msg.value to USD price
  // To interact with any other smart contract we need:
  //1. ABI
  //2. Address 0x694AA1769357215DE4FAC081bf1f309aDC325306
  AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
  (,int256 answer,,,) = priceFeed.latestRoundData();
  // price of ETH in terms of USD
  //3000.00000000
  return uint256(answer * 1e10); //1**10 == 10000000000

}

function getVersion() public view returns(uint256){
  AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
  return priceFeed.version();
}

function getConversionRate(uint256 ethAmount) public view returns(uint256){
  uint256 ethPrice = getPrice();
  uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
  return ethAmountInUsd;
}    */


function withdraw() public onlyOwner {  
  for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++)
  {
    address funder = funders[funderIndex];
    addressToAmountFunded[funder] = 0;
  }
  //reset the array
  funders = new address[](0);
  //actually withdraw the funds

  //3 different ways of sending currency:
  //1.transfer
  //payable(msg.sender).transfer(address(this).balance)
  //2.send
  //bool sendSuccess = payable(msg.sender).send(address(this).balance);
  //require(sendSuccess,"Send failed");
  //3.call
  (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
  require(callSuccess, "Call failed");
}

modifier onlyOwner { //applying modifier for checking the owner
  // require(msg.sender == i_owner, "Sender is not owner");
  if(msg.sender != i_owner){revert NotOwner(); }  // using the error functionality
  _;
}

receive() external payable {
  fund();
}
fallback() external payable{
  fund();
}

}
