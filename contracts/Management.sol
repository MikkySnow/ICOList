pragma solidity ^0.4.18;

import "./Ownership.sol";

/**
 *   @title Contract that implements Pausable, Migratable and Ownable
 */
contract Management {
    
    /*** STORAGE ***/

    // @dev State of contract. Some operations cannot be done if contract is paused
    bool public paused = false;

    // @dev Address of ownership contract
    Ownership ownershipContract;


    /*** EVENTS ***/

    // @dev Emits when contract was paused
    event Pause();

    // @dev Emits when contract was unpaused
    event Unpause();


    /*** MODIFIERS ***/

    // @dev Requires that msg.sender is admin
    modifier onlyAdmins() {
        require(ownershipContract.isAdminAddress(msg.sender));
        _;
    }
    
    // @dev Requires that msg.sender is CEO
    modifier onlyCEO() {
        require(msg.sender == ownershipContract.CEO());
        _;
    }
    
    // @dev Requires that msg.sender is CFO
    modifier onlyCFO() {
        require(msg.sender == ownershipContract.CFO());
        _;
    }

    // @dev Means that function can be called only when the contract is not paused
    modifier whenNotPaused() {
        require(!paused);
        _;
    }

    // @dev Modifier to make a function callable only when the contract is paused.
    modifier whenPaused() {
        require(paused);
        _;
    }

    /*** FUNCTIONS ***/

    // @dev Default constructor for Management contract
    // @param _ownershipContract Address of Ownership contract
    function Management(address _ownershipContract) public {
        require(_ownershipContract != 0x0);
        ownershipContract = Ownership(_ownershipContract);
    }

    // @dev called by the owner to pause, triggers stopped state
    function pause() onlyAdmins whenNotPaused public {
        paused = true;
        Pause();
    }


    // @dev called by the owner to unpause, returns to normal state
    function unpause() onlyAdmins whenPaused public {
        paused = false;
        Unpause();
    }

    // @dev Transfers ownership of contract to new Ownership contract
    // @param _address Address of new Ownership contract
    function transferOwnership(address _address) onlyCEO public {
        require(_address != 0x0);
        ownershipContract = Ownership(_address);
    }
}
