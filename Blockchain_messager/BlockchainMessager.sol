//SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

contract BlockchainMessanger {
    uint public changeCounter; // it will count how many times the message was changed

    address  public owner;

    string public message;

    constructor(){
        owner = msg.sender;
    }
    
    function updateTheMessage(string memory _newMessage) public { //message update functionality
        require(msg.sender == owner);
        message = _newMessage;
        changeCounter++; 
    }


}
