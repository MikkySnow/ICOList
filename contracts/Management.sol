pragma solidity ^0.4.18;

import "zeppelin-solidity/contracts/ownership/HasNoEther.sol";

/**
*   @title Contract that implements logic of management.
*   @dev Implement logic of multisig, interaction with other contracts and
*   role management
**/
contract Management is HasNoEther {

    /*** STORAGE ***/

    // An array for all admins
    address[] admins;

    // A mapping for approval that address is owner
    mapping (address => bool) ownerMapping;

    /*** MODIFIERS ***/

    /// @dev Only admins modifier
    modifier onlyAdmins() {}

    /*** FUNCTIONS ***/

    /// @dev Default constructor for Management contract
    // mgs.sender will be assigned as first admin
    function Management(){

    }

}
