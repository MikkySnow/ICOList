pragma solidity ^0.4.18;

// @title Contract for role management
contract Ownership {

    /*** EVENTS ***/

    // @dev Event emits when new CFO was added
    // @param newCFO Address of new CFO
    event CFOAdded(address newCFO);

    // @dev Event emits when new admin was added
    // @param newAdmin Address of new admin
    event AdminWasAdded(address newAdmin);

    // @dev Event emits when CFO was deleted
    // @param newAdmin Address of CFO
    event CFOWasDeleted(address CFOAddress);

    // @dev Event emits when admin was deleted
    // @param newAdmin Address of admin
    event AdminWasDeleted(address adminAddress);

    /*** VARIABLES ***/

    // @dev Number of admins. It cannot be less than 1 and greater than 256
    uint8 internal adminCount;

    // @dev Address of founder, who cannot be removed from admins list
    address internal CEO;

    // @dev Address of CFO, who can withdraw money from contract
    address internal CFO;

    /*** MODIFIERS ***/

    // @dev Mapping for approwal of adminship
    mapping(address => bool) internal isAdmin;

    // @dev Modifier for actions, which can do only CEO
    modifier onlyCEO() {
        require(msg.sender == CEO);
        _;
    }

    // @dev Modifier for actions, which can do only CFO
    modifier onlyCFO() {
        require(msg.sender == CFO);
        _;
    }

    // @dev Modifier for actions, which can do only admins
    modifier onlyAdmins() {
        require(isAdmin[msg.sender]);
        _;
    }

    /*** FUNCTIONS ***/

    // @dev Default constructor for Ownership contract
    function Ownership() public {
        isAdmin[msg.sender] = true;
        CEO = msg.sender;
        adminCount = 1;
    }

    // @dev Sets address of CFO
    // @param CFOAddress Address of new CFO
    function setCFO(address CFOAddress) onlyCEO public {
        require(CFOAddress != 0x0);
        require(CFO == 0x0);
        require(adminCount < 5);
        require(!isAdmin[CFOAddress]);
        isAdmin[CFOAddress] = true;
        CFO = CFOAddress;
        adminCount++;
    }

    // @dev Sets address of new admin
    // @param adminAddress Address of new admin
    function setAdmin(address adminAddress) onlyCEO public {
        require(adminAddress != 0x0);
        require(adminCount < 5);
        require(!isAdmin[adminAddress]);
        isAdmin[adminAddress] = true;
        adminCount++;
    }

    // @dev Removes CFO
    // @param CFOAddress Address of existing CFO
    function removeCFO(address CFOAddress) onlyCEO public {
        require(CFO == CFOAddress);
        adminCount--;
        delete isAdmin[CFOAddress];
        CFO = 0x0;
    }

    // @dev Removes admin
    // @param adminAddress Addres of existing admin
    function removeAdmin(address adminAddress) onlyAdmins public {
        require(isAdmin[adminAddress]);
        require(adminAddress != CEO && adminAddress != CFO);
        delete isAdmin[adminAddress];
        adminCount--;
    }

    // @dev Disallows sending ether
    function () public payable {
        require(msg.value == 0);
    }
}
