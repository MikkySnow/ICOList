pragma solidity ^0.4.18;

/**
 *   @title Contract that implements logic of management.
 *   @dev Implements logic of role management
 */
contract Management {

    // @dev Base struct for all proposals
    // @param votes Array where stored all addresses of signed participants
    // @param votesNumber How much participants was voted
    struct Proposal {
        address[] votes;           // @dev Addresses which voted for this proposal
        uint256 votesNumber;        // @dev Number of votes
    }

    // State of contract. Some operations cannot be done if contract is paused
    bool public paused = false;

    //  A mapping where all proposals stored
    mapping (address => Proposal) proposals;

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

    /**
     *  @dev Checks if address already voted for proposal
     *  @dev Iterates through proposals array and checks if admin already voted
     *  @param _address             Address of admin
     *  @param _voteFor             Address in proposal
     *  @return true if msg.sender already voted
     */
    function isAlreadyVoted(address _address, address _voteFor) view public returns (bool isVoted) {
        // Iterates through proposals array
        for (uint8 i = 0; i < proposals[_voteFor].votes.length - 1; i++) {
            // If admin already voted returns true
            if (proposals[_voteFor].votes[i] == _address) return true;
        }
        // If admin didn't vote returns false
        return false;
    }
}
