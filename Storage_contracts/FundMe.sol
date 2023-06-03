//Get funds from users 
// Withdraw funds
//Set a minimum funding value in USD

//SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;
contract FundMe {

uint256 public minimumUsd = 50;

function fund() public payable{
  //Here we want to make a minimum requirement for fund amount in USD
  //1. How do we send ETH to this contract

  //require(msg.value >= 1e18, "Didn't send enough"); //1e18 == 1 * 10 ** 18 == 1000000000000000000 i.e: 1 ETH
  require(msg.value >= minimumUsd, "Didn't send enough");
}


//function withdraw(){}

}
