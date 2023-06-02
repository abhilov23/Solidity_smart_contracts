// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Counter {

    uint public number; 

   ///This contract will be called by the CounterCallr contract

    function increment() external {

        number += 1;

    }

}
