//SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

contract AccessControl{
   
   event GrantRole(bytes32 indexed role, address indexed account);
    event RevokeRole(bytes32 indexed role, address indexed account);

    // role => account => bool
    mapping(bytes32 => mapping(address => bool))public roles;
    //the role is byte32 because we gonna hash the name of the role.
    bytes32 private constant ADMIN = keccak256(abi.encodePacked("ADMIN"));
    bytes32 private constant USER = keccak256(abi.encodePacked("USER"));

        modifier onlyRole(bytes32 _role){ //we can also pass the roles in the modifier
        require(roles[_role][msg.sender], "not Authorized");
        _;
        }  
    
    constructor(){
        _grantrole(ADMIN, msg.sender);
    }


    function _grantrole(bytes32 _role, address _address) internal {
      roles[_role][_address] = true; //grant role to the account
      emit GrantRole(_role, _address);
    }

    //only users with admin role can call this
    function grantRole(bytes32 _role, address _address) external onlyRole(ADMIN) {
        _grantrole(_role, _address);
    }

    function revokeRole(bytes32 _role, address _address) external onlyRole(ADMIN) {
    roles[_role][_address] = false; //grant role to the account
      emit RevokeRole(_role, _address);
    }


}
