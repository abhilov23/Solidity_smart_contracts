//SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

contract consumer{
    function getBalance() public view returns(uint){
        return address(this).balance;
    }
    function deposit() public payable{}
} 

contract SmartContractWallet {

 address payable public owner;

 mapping(address => uint) public allowance;
 mapping(address => bool) public isAllowedSend;

 mapping(address => bool) public guardians;
 address payable nextOwner;
 mapping(address => mapping(address => bool)) nextOwnerGuardianVotedBool;
 uint guardianResetCount;
 uint public constant ConformationsFromGuardiansForReset = 3;

    constructor(){
        owner = payable(msg.sender);
    }

    function setGuardian(address _guardian, bool _isGuardian) public {
        require(msg.sender == owner, "You are not the owner.....  aborting");
        guardians[_guardian] = _isGuardian;
    }

    function proposeNewOwner(address payable newOwner) public {
        require(guardians[msg.sender], "You are not the owner... Aborting");
        require(nextOwnerGuardianVotedBool[newOwner][msg.sender] == false, "You already voted, aborting");
        if(newOwner != nextOwner){
            nextOwner = newOwner;
            guardianResetCount = 0;
        }
        guardianResetCount++;

        if(guardianResetCount >= ConformationsFromGuardiansForReset){
            owner = nextOwner;
            nextOwner = payable(address(0));
        }
    }

    function setAlowance(address _for, uint _amount) public{
        require(msg.sender == owner, "you are not the owner, aborting");
        allowance[msg.sender] = _amount;

        if(_amount > 0){
            isAllowedSend[_for] = true;
        }
        else{
            isAllowedSend[_for] =false;
        }
    }
    
    function transfer (address payable _to, uint _amount, bytes memory _payload) public returns(bytes memory){
        require(msg.sender == owner, "You are not the owner... aborting");
        if(msg.sender != owner)
        {
            require(allowance[msg.sender] >= _amount, "you are trying to send more than you are allowed to, aborting");
            require(isAllowedSend[msg.sender],"You are trying to send more than you are allowed to... aborting");
            allowance[msg.sender] -= _amount;
        }
        
       (bool success, bytes memory returnData) =  _to.call{value: _amount}(_payload);
       require(success, "aborting, call was not successful");
       return returnData;
    }

    receive() external payable{}

}