// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
contract Escrew {
    address payable public buyer;
    address payable public seller;
    uint public deposit;
    uint public timeToExpiry;
    uint public startTime;

    //Buyer sets up the escrew and pays the deposit
    function Escrow(address payable _seller, uint _timeToExpiry) public{
        buyer = msg.sender;
        seller = _seller;
        deposit = msg.value;
        timeToExpiry = _timeToExpiry;
        startTime = block.timestamp;
    }

    //buyer release deposit to seller
    function releaseToSeller() public{
        if (msg.sender == buyer) {
            selfdestruct(seller);
        }
        else{
            revert();
        }
    }

    //buyer can withdraw deposit if the escrow is expired
    function withdraw() public{
        if(!isExpired()){
            revert();
        }
        if(msg.sender == buyer){
            selfdestruct(buyer); //finish the contract and send all the funds to buyer
        }
        else{
            revert();
        }
    }

    //seller can cancel escrow and return all the functions to buyer
    function cancel() public{
        if (msg.sender == seller) {
           selfdestruct(buyer); 
        }
        else{
            revert();
        }
    }

    function isExpired() view public returns(bool){
        if (block.timestamp > startTime + timeToExpiry) {
            return true;
        }
        else{
            return false;
        }
    }
}
