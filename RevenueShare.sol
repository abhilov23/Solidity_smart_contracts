pragma solidity ^0.8.0;
contract RevenueShares{
    address public creator;
    mapping(uint => address)public payable shareholders;
    uint public numShareholders;

event Disburse(uint _amount, uint _numShareholders);

function RevenueShare(address[] memory addresses) public {
creator = msg.sender;
numShareholders = addresses.length;

for (uint i = 0; i < addresses.length; i++) {
    shareholders[i] = addresses[i];
 }
}
function shareRevenue() public returns (bool success){
    uint amount = msg.value / numShareholders;

    for (uint i = 0; i < numShareholders; i++) {
        if (!shareholders[i].send(amount)) {
            revert();            
        }        
    }

    Disburse(msg.value, numShareholders);
    return true;
}

function kill(){
    if (msg.sender == creator) {
        selfdestruct(creator);
    }
}
}