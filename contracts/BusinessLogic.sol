pragma solidity ^0.4.18;

import "./Management.sol";
import "zeppelin-solidity/contracts/math/SafeMath.sol";

/**
*   @title Contract for business logic
*   @dev There implemented all business logic
*   All users interaction works via this contract
*/
contract BusinessLogic is Management {

    using SafeMath for uint256;

    /*** EVENTS ***/

    /// @dev Emits when somebody withdraws money from contract
    event MoneyWithdrawal(uint256 _amount, address _address);

    /// @dev Emits when new MoneyVault address was set
    event NewMoneyVaultAddress(address _address, address _setBy);

    /// @dev Emits when new CrowdsaleStorage address was set
    event NewCrowdsaleStorageAddress(address _adress, address _setBy);


    /*** VARIABLES ***/

    /// @dev How much fee we take
    uint256 constant public CONTRIBUTE_FEE = 1;

    /// @dev Address of vault where stored users ether
    address moneyVaultAddress;

    /// @dev Address of storage where all crowdsales stored
    address crowdsaleStorageAddress;

    /**
     *  Number of admins which signed withdraw proposal
     */
    uint8 numberOfSigns;

    /**
     *  An array for signedAddresses
     */
    address[] signedAdmins;

    /*** FUNCTIONS ***/

    /**
    *   @dev Function for money withdrawal
    *   Can be called only by 2 or more admins
    *   @param _address         Address to withdraw
    *   @param _amount          Amount to withdraw
    **/
    function withdraw(address _address, uint256 _amount) internal {
        require(this.balance >= _amount);
        _address.transfer(_amount);

        MoneyWithdrawal(_amount, _address);
    }

    /**
    *   @dev Function for crowdsale contributing by users
    *   Contributing of crowdsale takes some fees
    *   User money sends to MoneyVault
    **/
    function contribute() payable whenNotPaused public {
        uint256 memory amount = msg.value.mul(CONTRIBUTE_FEE).div(100);
        moneyVaultAddress.transfer(amount);
        MoneyVault(moneyVaultAddress).deposit(msg.sender, amount);
    }

    /**
     *  @dev Function for claiming tokens if crowdsale was successful
     */
    function claimTokens() public {

    }

    /**
     *   @dev Overrides disallowing function to receive ether
     *   Works the same as contribute()
     */
    function() public payable {
        uint256 memory amount = msg.value.mul(CONTRIBUTE_FEE).div(100);
        moneyVaultAddress.transfer(amount);
        MoneyVault(moneyVaultAddress).deposit(msg.sender, amount);
    }

    /**
     *  @dev Checks if address already signed proposal
     */
    function isSigned(address _address) public constant returns (bool) {

        for (uint8 i=0; i<signedAdmins.length-1; i++) {
            if (_address == signedAdmins[i]) {
                return true;
            }
        }

        return false;
    }

    /**
     *  @dev Accepts money withdrawal
     *  Money withdrawal starts when at least 3 admins signed
     *  @param _address         Address to withdraw
     *  @param _amount          Amount to withdraw
     */
    function acceptWithdrawal(uint256 _amount, address _address) onlyAdmins public {
        // One person can't vote twice
        require(!isSigned(msg.sender));
        // We cannot withdraw to zero address
        require(_address != 0x0);
        // We cannot withdraw more than we have
        require(_amount <= this.balance);

        // Check if there more than 70000 gas
        require(msg.gas < 70000);

        // Votes for withdrawal
        numberOfSigns++;
        // Sets that msg.sender already voted
        signedAdmins[signedAdmins.length] = msg.sender;

        // Checks if we ready to start withdrawal
        if (numberOfSigns >= 3) {
            withdraw(_address, _amount);
            // If withdraw starts we clear list of signed admins
            clearSignedAdminsList();
        }
    }

    /**
     *  @dev Decline money withdrawal
     */
    function declineWithdrawal() onlyAdmins public {
        // One person can't vote twice
        require(!isSigned(msg.sender));

        // Check if number of signs is greater than zero
        require(numberOfSigns > 0);

        // Check if there more than 70000 gas
        require(msg.gas < 70000);

        // Decline one vote for withdrawal
        numberOfSigns--;

        // Sets that msg.sender already voted
        signedAdmins[signedAdmins.length] = msg.sender;

        // If number of signs is zero, we clear list of signed admins
        clearSignedAdminsList();
    }

    /**
     *  @dev Clears list of signed admins
     */
    function clearSignedAdminsList() internal {
        for (uint8 i=0; i<signedAdmins.length-1; i++) {
            delete signedAdmins[i];
        }
    }

    /**
     *  @dev Sets MoneyVault contract address
     *  @param _address         New address of MoneyVault contract
     */
    function setMoneyVaultAddress(address _address) onlyAdmins whenPaused public {
        // We cannot set contract address to zero
        require(_address != 0x0);
        // Sets new address
        moneyVaultAddress = _address;
        // Emits event
        NewMoneyVaultAddress(_address, msg.sender);
    }

    /**
     *  @dev Sets CrowdsaleStorage contract address
     *  @param _address         New address of CrowdsaleStorage contract
     */
    function setCrowdsaleStorageAddress(address _address) onlyAdmins whenPaused public {
        // We cannot set contract address to zero
        require(_address != 0x0);
        // Sets new address
        crowdsaleStorageAddress = _address;
        // Emits event
        NewCrowdsaleStorageAddress(_address, msg.sender);
    }
}
