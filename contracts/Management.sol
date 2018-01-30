pragma solidity ^0.4.18;

import "zeppelin-solidity/contracts/ownership/HasNoEther.sol";

/**
*   @title Contract that implements logic of management.
*   @dev Implement logic of multisig, interaction with other contracts and
*   role management
**/
contract Management is HasNoEther {

    /*** STORAGE ***/

    /// Number of admins. It cannot be less than 1 and greater than 256
    uint8 adminCount;

    // A mapping for approval that address is owner
    mapping (address => bool) ownerMapping;


    /*** EVENTS ***/

    // Emits when new admin was added
    event AdminWasAdded(address newAdmin);

    // Emits when admin was removed
    event AdminWasRemoved(address removedAdmin);


    /*** MODIFIERS ***/

    /// @dev Only admins modifier
    modifier onlyAdmins() {
        require(isAdmin(msg.sender));
        _;
    }

    /// @dev Only 3 or more admins can do it
    modifier onlyMultipleAdmins() {}

    /*** FUNCTIONS ***/

    /// @dev Default constructor for Management contract
    // mgs.sender will be assigned as first admin
    function Management(){
        ownerMapping[msg.sender] = true;
        adminCount = 1;
    }

    /**
    *   @dev Adds new admin. Can be called only by existing admin
    *   @param newAdmin             Address of new admin
    **/
    function addAdmin(address newAdmin) onlyAdmins public {
        // Require that number of admins is less than 256
        require(adminCount < 256);
        // Require that address is not zero
        require(newAdmin != 0x0);
        // Require that it's new admin
        require(!isAdmin(newAdmin));

        ownerMapping[newAdmin] = true;
        adminCount++;

        AdminWasAdded(newAdmin);
    }

    /**
    *   @dev Removes admin. Can be called only by multiple admins
    *   If admins count less than 3 it can be called by 1 admin
    *   @param adminAddress         Address of existing admin
    **/
    function removeAdmin(address adminAddress) onlyMultipleAdmins public {

    }

    /**
    *   @dev Checks that the address is an administrator
    *   @param _address             Address of possible admin
    **/
    function isAdmin(address _address) public constant returns (bool) {
        return ownerMapping[_address];
    }
}
