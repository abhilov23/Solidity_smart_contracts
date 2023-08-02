//SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

contract SampleUnits {
    modifier betweenOne{
        require(msg.value >= 1 ether && msg.value <= 2 ether);
        // require(msg.value >= 1e18 && msg<= 2e18);
        // you can use units like ether, gwei, wei etc.
        _;
    }
    uint runUntilTimeStamp;
    uint startTimeStamp;

    constructor(uint StartInDays){
        startTimeStamp = block.timestamp + (StartInDays *  1 days);
        //startTimeStamp = block.timestamp + (StartInDays * 24 * 60 * 60);
        runUntilTimeStamp = startTimeStamp + (7 days);
        //runUntilTimeStamp = startTimeStamp + (7 * 24 * 60 * 60);
        // You can also use multiple timeunits like seconds, minutes, hours, days, weeks
    }
}