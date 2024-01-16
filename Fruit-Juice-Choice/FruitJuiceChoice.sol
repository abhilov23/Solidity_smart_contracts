//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
contract FruitJuice {
enum FruitJuiceChoice{small, medium, large}
FruitJuiceChoice choice;
FruitJuiceChoice defaultChoice;

constructor(){
defaultChoice = FruitJuiceChoice.medium;
}

function setSmall() external returns(FruitJuiceChoice){
    choice = FruitJuiceChoice.small;
    return choice;
}

function setMedium() external returns(FruitJuiceChoice){
    choice = FruitJuiceChoice.medium;
    return choice;
}

function setLarge() external returns(FruitJuiceChoice){
choice = FruitJuiceChoice.large;
return choice;
}

function checkChoice() external view returns(FruitJuiceChoice){
    return choice;
}

function defaultchoice() external view returns (FruitJuiceChoice){
    return defaultChoice; //returning the default choice
}

}

//sizechoice function
//for checking default choice
//function for small choice
//function for medium choice
//for getting large as choice

