// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./Counter.sol"; //1. here we imported the contract we want to interact with

contract CounterCaller {

    Counter public myCounter; //2. we created a variable myCounter of the type Counter(name of callee smart contract)

    constructor(address counterAddress) { //3. here we give the address of the deployed Counter smart-contract

        myCounter = Counter(counterAddress); //4. And here we bind it with a given variable

    }

    function counterIncrement() external {

        myCounter.increment(); //5. finally here we call the increment function in the Counter smart-contract

    }

}
