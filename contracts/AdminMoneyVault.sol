pragma solidity ^0.4.0;

import "./Management.sol";


/**
 *   @title Vault for admins funds
 */
contract AdminMoneyVault is Management {

    // @dev Emits when somebody withdraws money from contract
    event MoneyWithdrawal(uint256 _amount, address _address);

    /**
     *  Number of admins which signed withdraw proposal
     */
    uint8 numberOfSigns;

    /**
     *  An array for signedAddresses
     */
    address[] signedAdmins;

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
        if (adminCount == 1) {
            withdraw(_address, _amount);
            // If withdraw starts we clear list of signed admins
            clearSignedAdminsList();
        } else if (numberOfSigns >= 3) {
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

    // @dev Overriden function for accepting ether directly
    function () payable {
    }

    /**
         *  @dev Checks if address already signed proposal
         */
    function isSigned(address _address) internal view returns (bool) {

        for (uint8 i=0; i<signedAdmins.length-1; i++) {
            if (_address == signedAdmins[i]) {
                return true;
            }
        }

        return false;
    }
}
