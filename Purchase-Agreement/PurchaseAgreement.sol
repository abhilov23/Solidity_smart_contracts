//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract PurchaseAgreement {
    uint public value;
    address payable public seller;
    address payable public buyer;

    enum State{ created, locked, Release, Inactive} //enum is created
    State public state; //initializing a variable
    
    constructor() payable{
        seller = payable (msg.sender);
        value = msg.value/2; //because we are sending the amount as twice
    }
    
    
    //natspec comments:  also helpful in generating the error messages
    ///The function cannot be called at the current state.
    error InvalidState();
    
    
    modifier inState(State state_){
        if(state != state_){
            revert InvalidState();
        }
        _;
    }

    ///Only the buyer can call this function
    error OnlyBuyer();

    modifier onlyBuyer(){
        if (msg.sender != buyer){
            revert OnlyBuyer();
        }
        _;
    }


    ///Only the seller can call this function
    error onlySeller();

    modifier OnlySeller(){
        if(msg.sender != seller){
            revert onlySeller();
        }
        _;
    }

    function confirmPurchase() external inState(State.created) payable 
    {
        require(msg.value == (2 * value), "please send in two times the amount"); //depositing 2 times the amount for security purpose.
        buyer = payable(msg.sender);
        state = State.locked;
    }

    function confirmReceived() external onlyBuyer inState(State.locked) { //confirm received function
        state = State.Release;
        buyer.transfer(value);
    }
    
    function paySeller() external OnlySeller inState(State.locked) {
       state = State.Inactive;
       seller.transfer(3 * value);
    }

    function abort() external OnlySeller inState(State.created){ //to abort the deal
      state = State.Inactive;
      seller.transfer(address(this).balance);
    }


}
