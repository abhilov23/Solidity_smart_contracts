//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FallbackExample{
    uint256 public result;

    receive() external payable{ //receive function is for accepting ether
      result = 1;
    }
    fallback() external payable{ //fallback function is for for accepting data 
        result = 2;
    }
}
