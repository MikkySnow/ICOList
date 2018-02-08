pragma solidity ^0.4.18;

/**
 *   @title Contract that implements logic of management.
 *   @dev Implements logic of role management
 */
contract Management {
    
    /*** STORAGE ***/

    // State of contract. Some operations cannot be done if contract is paused
    bool public paused = false;

    // Address of ownership contract
    address ownershipContract;


    /*** EVENTS ***/

    // Emits when contract was paused
    event Pause();

    // Emits when contract was unpaused
    event Unpause();


    /*** MODIFIERS ***/

    // @dev Requires that msg.sender is admin
    modifier onlyAdmins() {
        require(msg.sender == ownershipContract);
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

    /**
     * @dev Default constructor for Management contract
     * @dev msg.sender will be assigned as first admin
     * Constructor rejects incoming ether. The payable flag is added for access
     * to msg.value without warning
     */
    function Management(address _ownershipContract) public {
        require(_ownershipContract != 0x0);
        ownershipContract = _ownershipContract;
    }

    /**
     * @dev called by the owner to pause, triggers stopped state
     */
    function pause() onlyAdmins whenNotPaused public {
        paused = true;
        Pause();
    }

    /**
     * @dev called by the owner to unpause, returns to normal state
     */
    function unpause() onlyAdmins whenPaused public {
        paused = false;
        Unpause();
    }

    // Transfers ownership of contract to new Ownership contract
    function transferOwnership(address _address) onlyAdmins public {
        ownershipContract = _address;
    }
}
