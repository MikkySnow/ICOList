pragma solidity ^0.4.18;

import "./Management.sol";
import "./MoneyVault.sol";
import "./CrowdsaleStorage.sol";
import "./AdminMoneyVault.sol";
import "zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol";

/**
*   @title Contract for business logic
*   @dev There implemented all business logic.
*   All users interaction works via this contract
*/
contract BusinessLogic is Management {

    using SafeMath for uint256;


    /*** EVENTS ***/

    // Emits when new MoneyVault address was set
    event NewMoneyVaultAddress(address _address);

    // Emits when new CrowdsaleStorage address was set
    event NewCrowdsaleStorageAddress(address _address);

    // Emits when new AdminMoneyVault address was set
    event NewAdminMoneyVaultAddress(address _address);


    /*** VARIABLES ***/

    // How much fee we take
    uint256 constant public CONTRIBUTE_FEE = 1;

    // Vault where stored users ether
    MoneyVault moneyVault;

    // Storage where all crowdsales stored
    CrowdsaleStorage crowdsaleStorage;

    // Vault where stored admins ether
    AdminMoneyVault adminMoneyVault;


    /*** FUNCTIONS ***/

    function BusinessLogic(address _address) Management(_address) {
        require(_address != 0x0);
    }

    /**
    *   @dev Function for crowdsale contributing by users
    *   Contributing of crowdsale takes some fees.
    *   @dev User ether sends to MoneyVault contract, admin fees
    *   sends to AdminMoneyVault contract
    **/
    function contribute() payable whenNotPaused public {
        // Sending ether to MoneyVault contract
        uint256 amount = msg.value.mul(CONTRIBUTE_FEE).div(100);
        // There is no necessity to use require, transfer throws exception if transfer was failed
        moneyVault.transfer(amount);
        // Saves info about msg.sender and how much he invested
        moneyVault.deposit(msg.sender, amount);
        // Sending fees to AdminMoneyVault contract
        adminMoneyVault.transfer(msg.value - amount);
    }

    /**
     *  @dev Function for claiming tokens if crowdsale was successful
     *  @dev Function connects to token contract and gets how much tokens contract
     *  bought by calling balanceOf(this). After that we count how much tokens
     *  we should send to user according to the amount he invested. Tokens will be sent by
     *  transfer(address, amount) functions, which containt either in ERC20 and ERC223
     */
    function claimTokens(uint256 crowdsaleId) public {
        // Checks is crowdsale finished
        require(crowdsaleStorage.isCrowdsaleFinished(crowdsaleId));
        // Use ERC20 basic interface for token contract
        ERC20Basic token = ERC20Basic(crowdsaleStorage.getTokenAddressById(crowdsaleId));
        // Counts how many tokens user should get
        uint256 raised = crowdsaleStorage.getWeiRaised(crowdsaleId);
        // Counts how many wei user invested
        uint256 invested = moneyVault.getAmountOfFunds(msg.sender);
        // Counts how many tokens contract bought
        uint256 amount = token.balanceOf(this);
        // Sending tokens to user
        token.transfer(msg.sender, amount.div(raised).mul(invested));
    }

    /**
     *   @dev Function for accepting ether coming directly to contract
     *   @dev Overrides disallowing function to receive ether. To
     *   implement logic of contributing calls contribute()
     */
    function() public payable {
        contribute();
    }

    /**
     *  @dev Sets MoneyVault contract address
     *  @dev Can be called when contract is paused only by 2 or more admins
     *  if adminCount more than 1 and by 1 admin if adminCount is 1.
     *  @param _address         New address of MoneyVault contract
     */
    function setMoneyVaultAddress(address _address) onlyAdmins whenPaused public {
        // We cannot set contract address to zero
        require(_address != 0x0);
        //  Checks adminCount
        if (adminCount == 1) {
            // Sets new address
            moneyVault = MoneyVault(_address);
            // Emits event
            NewMoneyVaultAddress(_address);
        } else {
            // Checks if there enough votes
            if (proposals[_address].votesNumber >= 2) {
                // Sets new address
                moneyVault = MoneyVault(_address);
                // Emits event
                NewMoneyVaultAddress(_address);
                // Remove proposal
                delete proposals[_address];
            } else {
                // Checks if admin already voted
                if (!isAlreadyVoted(msg.sender, _address)) {
                    // Incrementing number of votes for this proposal
                    proposals[_address].votesNumber++;
                    // Sets that msg.sender was voted for this proposal
                    proposals[_address].votes.push(msg.sender);
                }
            }
        }
    }

    /**
     *  @dev Sets CrowdsaleStorage contract address
     *  @dev Can be called when contract is paused only by 2 or more admins
     *  if adminCount more than 1 and by 1 admin if adminCount is 1.
     *  @param _address         New address of CrowdsaleStorage contract
     */
    function setCrowdsaleStorageAddress(address _address) onlyAdmins whenPaused public {
        // We cannot set contract address to zero
        require(_address != 0x0);
        // Checks adminCount
        if (adminCount == 1) {
            // Sets new address
            crowdsaleStorage = CrowdsaleStorage(_address);
            // Emits event
            NewCrowdsaleStorageAddress(_address);
        } else {
            // Checks if there enough votes
            if (proposals[_address].votesNumber >= 2) {
                // Sets new address
                crowdsaleStorage = CrowdsaleStorage(_address);
                // Emits event
                NewCrowdsaleStorageAddress(_address);
                // Remove proposal
                delete proposals[_address];
            } else {
                // Checks if admin already voted
                if (!isAlreadyVoted(msg.sender, _address)) {
                    // Incrementing number of votes for this proposal
                    proposals[_address].votesNumber++;
                    // Sets that msg.sender was voted for this proposal
                    proposals[_address].votes.push(msg.sender);
                }
            }
        }
    }

    /**
     *  @dev Sets AdminMoneyVault contract address
     *  @dev Can be called when contract is paused only by 2 or more admins
     *  if adminCount more than 1 and by 1 admin if adminCount is 1.
     *  @param _address         New address of AdminMoneyVault contract
     */
    function setAdminMoneyVaultAddress(address _address) onlyAdmins whenPaused public {
        // We cannot set contract address to zero
        require(_address != 0x0);
        // Checks adminCount
        if (adminCount == 1) {
            // Sets new address
            adminMoneyVault = AdminMoneyVault(_address);
            // Emits event
            NewAdminMoneyVaultAddress(_address);
        } else {
            // Checks if there enough votes
            if (proposals[_address].votesNumber >= 2) {
                // Sets new address
                adminMoneyVault = AdminMoneyVault(_address);
                // Emits event
                NewAdminMoneyVaultAddress(_address);
                // Remove proposal
                delete proposals[_address];
            } else {
                // Checks if admin already voted
                if (!isAlreadyVoted(msg.sender, _address)) {
                    // Incrementing number of votes for this proposal
                    proposals[_address].votesNumber++;
                    // Sets that msg.sender was voted for this proposal
                    proposals[_address].votes.push(msg.sender);
                }
            }
        }
    }
}
