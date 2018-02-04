pragma solidity ^0.4.18;

/**
 *   @title Contract that implements logic of management.
 *   @dev Implement logic of role management
 */
contract Management {

    struct NewAdminProposal {
        address[] votes;           // Addresses which voted for this proposal
        uint256 votesNumber;        // Number of votes
    }

    /*** STORAGE ***/

    // @dev Number of admins. It cannot be less than 1 and greater than 256
    uint8 adminCount;

    /**
     * @dev Address of founder
     * @dev Founder cannot be removed from admins list
     */
    address founder;

    // @dev State of contract. Some operations cannot be done if contract is paused
    bool public paused = false;

    // @dev A mapping for approval that address is owner
    mapping (address => bool) ownerMapping;

    // @dev A mapping where all proposals stored
    mapping (address => NewAdminProposal) proposals;


    /*** EVENTS ***/

    // @dev Emits when new admin was added
    event AdminWasAdded(address newAdmin);

    // @dev Emits when admin was removed
    event AdminWasRemoved(address removedAdmin);

    // @dev Emits when contract was paused
    event Pause();

    // @dev Emits when contract was unpaused
    event Unpause();

    /*** MODIFIERS ***/

    /**
     * @dev Only admins modifier
     */
    modifier onlyAdmins() {
        require(isAdmin(msg.sender));
        _;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is not paused.
     */
    modifier whenNotPaused() {
        require(!paused);
        _;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is paused.
     */
    modifier whenPaused() {
        require(paused);
        _;
    }


    /*** FUNCTIONS ***/

    /**
     * @dev Default constructor for Management contract
     * mgs.sender will be assigned as first admin
     * Constructor rejects incoming ether. The payable flag is added for access
     * to msg.value without warning
     */
    function Management() public payable {
        require(msg.value == 0);
        ownerMapping[msg.sender] = true;
        founder = msg.sender;
        adminCount = 1;
    }

    /**
     *   @dev Adds new admin. Can be called only by existing admin
     *   @param newAdmin             Address of new admin
     *   If function calls first time, it creates proposal of adding new admin
     *   If function calls multiple times with the same newAdmin param, it votes for
     *   newAdmin adding. If number of votes for one admin is more than 2, it executes and
     *   adding new admin.
     *   Only second admin adds without creating proposal
     */
    function addAdmin(address newAdmin) onlyAdmins public {
        // Require that number of admins is less than 256
        require(adminCount < 5);
        // Require that address is not zero
        require(newAdmin != 0x0);
        // Require that it's new admin
        require(!isAdmin(newAdmin));

        // If we creating the second admin, it can be added without proposal
        if (adminCount == 1) {
            ownerMapping[newAdmin] = true;
            adminCount++;

            AdminWasAdded(newAdmin);
        } else {
            // Checks if there enough votes
            if (proposals[newAdmin].votesNumber > 2) {
                // Adds new admin
                ownerMapping[newAdmin] = true;
                adminCount++;
                // Remove proposal
                delete proposals[newAdmin];
            // If there not enough votes for adding, votes for chosen admin
            } else {
                // Checks if admin already voted
                if (!isAlreadyVoted(msg.sender, newAdmin)) {
                    proposals[newAdmin].votesNumber++;
                    proposals[newAdmin].votes.push(msg.sender);
                }
            }
        }
    }

    /**
     *   @dev Removes admin. Can be called only by multiple admins
     *   @dev If admins count less than 3 it can be called by 1 admin
     *   @param adminAddress         Address of existing admin
     */
    function removeAdmin(address adminAddress) onlyAdmins public {
        // Require that number of admins is more than one
        require(adminCount > 1);
        // Require that address is not founder
        require(adminAddress != founder);
        // Require that address exists
        require(isAdmin(adminAddress));

        delete ownerMapping[adminAddress];
        adminCount--;

        AdminWasRemoved(adminAddress);
    }

    /**
    *   @dev Checks that the address is an administrator
    *   @param _address             Address of possible admin
    **/
    function isAdmin(address _address) public view returns (bool) {
        return ownerMapping[_address];
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
     * @dev Disallows sending ether
     */
    function () payable {
        require(msg.value == 0);
    }

    /**
     *  @dev Checks if address already voted for proposal
     *  @param _address             Address of admin
     *  @param _voteFor             Address in proposal
     */
    function isAlreadyVoted(address _address, address _voteFor) view internal returns (bool) {
        for (uint8 i = 0; i < proposals[_voteFor].votes.length - 1; i++) {
            if (proposals[_voteFor].votes[i] == _address) return true;
        }
        return false;
    }
}
