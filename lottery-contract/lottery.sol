//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Lottery{
//enter lottery function
//pick winner function 
//get random number function
//Optional functions 
// get pot balance function
// get players function
// other function
address owner;
address payable[] public players;
uint public lotteryId;
mapping (uint => address payable) public lotteryHistory;

constructor(){
    owner = msg.sender;
}

function getWinnerByLottery(uint lottery) public view returns(address payable){
    return lotteryHistory[lottery];
}


modifier onlyOwner(){
  require(msg.sender == owner);
  _;
}

function enterLottery() public payable {
    require(msg.value > .01 ether,"not enough amount");
    players.push(payable(msg.sender)); //push function gonna push the msg.sender to the array
}

//we are going to use pseudo random numbers
function getRandomNumber() public view returns(uint){
    return uint(keccak256(abi.encodePacked(owner, block.timestamp)));
}

function pickwinner() public onlyOwner {
    uint index = getRandomNumber() % players.length;
    players[index].transfer(address(this).balance);

    lotteryHistory[lotteryId] = players[index];
    lotteryId++;

    //reset the state of the contract
    players = new address payable[](0);
}

function getBalance() public view returns(uint){
    return address(this).balance;
}

  function getPlayers() public view returns(address payable[] memory){
    return players;
  }

}
