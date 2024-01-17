//SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

contract vendingMachine{
    //purchase function
    //restock function
    //getbalance function
    
    //state variables: owner, balances, 
    //constructor: set owner, set initial balance of vending machine

    address public owner;
    mapping (address => uint) public donutBalances;

    constructor(){
      owner = msg.sender;
      donutBalances[address(this)] = 100;
    }

    modifier OnlyOwner(){
        require(msg.sender==owner, "Only owner can restart the function");
        _;
    }

    function purchase(uint amount) public payable{
      require(msg.value >= amount * 2 ether, "You must pay at least 2 ether per donut");
      require(donutBalances[address(this)] >= amount,"Not enough donuts in stocks to fulfill the demand");
      donutBalances[address(this)] -= amount;
      donutBalances[msg.sender] += amount;
    }

    function restock(uint amount) public OnlyOwner {
     donutBalances[address(this)] += amount;
    }

    function getBalance() public view returns(uint){
       return donutBalances[address(this)];
    }
    
}
