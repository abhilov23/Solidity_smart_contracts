//SPDX-License-Identifier: MIT
//faucet : A faucet is a program that gives out a specified amount of tokens to anyone who requests them.
pragma solidity ^0.8.17;

interface IERC20{
 function transfer(address to, uint256 amount) external view returns (bool);
 function balanceOf(address account) external view returns(uint256);
 event Transfer(address indexed from, address indexed to, uint256 value);
}


contract Faucet{
     address payable owner;
     IERC20 public token; //state variable of interface
     uint256 public withdrawlAmount = 50 * (10**18);


     event withdrawl(address indexed to, uint256 indexed amount);
     event Deposit(address indexed from, uint256 indexed amount);

     mapping(address => uint256) nextAccessTime;
     uint256 lockTime = 1 minutes; //minutes is a global variable, basically the time variables are allowed in the solidity


     constructor(address tokenAddress) payable {
        token = IERC20(tokenAddress);
        owner = payable(msg.sender);
     }

     modifier onlyOwner(){
        require(msg.sender == owner, "Only contract owner can call this function");
        _;
     }



     function requestTokens() public {
        require(msg.sender == address(0), "request must originate from a zero account");
        require(token.balanceOf(address(this))>=withdrawlAmount, "Insufficient balance in the wallet for withdrawl");
        require(block.timestamp >= nextAccessTime[msg.sender], "Insufficient time elapsed since last withdrawl, try again later.");
        nextAccessTime[msg.sender] = block.timestamp + lockTime;

        token.transfer(msg.sender, withdrawlAmount);
     }

     
     receive() external payable{
       emit Deposit(msg.sender, msg.value);
     }

     function getBalance() external view returns(uint256) {
       return token.balanceOf(address(this));
     }

     function SetWithdrawlAmount(uint256 amount) public onlyOwner {
        withdrawlAmount = amount * (10**18);
     }
     
     function setLockTime(uint256 amount) public onlyOwner{
        lockTime = amount * 1 minutes;
     }

     function withdraw() external onlyOwner{
        emit withdrawl(msg.sender, token.balanceOf(address(this)));
        token.transfer(msg.sender, token.balanceOf(address(this)));
     }
    
}


