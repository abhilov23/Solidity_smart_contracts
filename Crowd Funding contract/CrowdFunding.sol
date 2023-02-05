///SPDX-License-Identifier: MIT   
pragma solidity ^0.8.0;
contract CrowdFunding{
    struct Backer {
        address payable addr;
        uint amount;
    }
    address payable public owner;
    uint public numBackers;
    uint public deadline;
    string public champaignStatus;
    bool ended;
    uint public goal;
    uint public amountRaised;
    mapping (uint => Backer) backers;

    event Deposit(address _from, uint _amount);
    event Refund(address _to,uint _amount);

    modifier onlyOwner(){
        if (msg.sender != owner)
           revert();
    _;
    }
    constructor(uint _deadline, uint _goal){
        owner = payable(msg.sender);
        deadline = _deadline;
        goal = _goal;
        champaignStatus = "Funding";
        numBackers = 0;
        amountRaised = 0;
        ended = false;
    }
    function fund()public payable{
        Backer memory b = backers[numBackers++];
        b.addr = payable(msg.sender);
        b.amount = msg.value;
        amountRaised += b.amount;
        emit Deposit(msg.sender, msg.value);
    }

    function checkGoalReached() onlyOwner public payable{
        if(ended)
        revert(); //this function has already being called

        if (block.timestamp < deadline) {
            revert();
        }

        if (amountRaised >= goal) {
            champaignStatus = "Campaign Succeeded";
            ended = true;
            if (!owner.send(address(this).balance)) {
                revert();//if anything fails
                         // this will revert the changes above
            }
            else {
                uint i = 0;
                champaignStatus = "Campaign Failed";
                ended = true;
                while (i <= numBackers) {
                    backers[i].amount = 0;
                    if(!backers[i].addr.send(backers[i].amount))
                    revert();//if anythng fails, this will revert the changes above
                }
                emit Refund(backers[i].addr, backers[i].amount);
                i++;
            }
        }
    }
    function destroy() internal{
        if(msg.sender == owner){
            selfdestruct(owner);
        }
    }
    fallback() external{  //Fallback functions must be defined as externals
        revert();
    }
} //This is the most perfect smart contract from me 06/02/23;2:53
