pragma solidity ^0.4.0;

import "./Management.sol";

/**
 *   @title A vault for admins funds
 *   @notice Only admins can use this contract
 */
contract AdminMoneyVault is Management {

    // Emits when somebody withdraws money from contract
    event MoneyWithdrawal(uint256 _amount, address _address);

    //  Number of admins which signed withdraw proposal
    uint8 numberOfSigns;

    //  An array for signedAddresses
    address[] signedAdmins;

    /**
    *   @notice Function for money withdrawal
    *   @dev Can be called only by 2 or more admins
    *   @param _address         Address to withdraw
    *   @param _amount          Amount to withdraw
    **/
    function withdraw(address _address, uint256 _amount) internal {
        // Checks if contract balance greater than withdrawal amount
        require(this.balance >= _amount);
        // Transfers ether to _address
        _address.transfer(_amount);
        // Emits withdrawal event
        MoneyWithdrawal(_amount, _address);
    }

    /**
     *  @notice Accepts money withdrawal
     *  @dev Money withdrawal starts when at least 3 admins signed
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
     *  @notice Decline money withdrawal
     *  @dev Declines money withdrawal by decrementing votes for withdrawal proposal
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
     *  @notice Clears list of signed admins
     *  @dev Could be a leak of gas, but length of signedAdmins array
     *  cannot be greater than 5
     */
    function clearSignedAdminsList() internal {
        for (uint8 i=0; i<signedAdmins.length-1; i++) {
            delete signedAdmins[i];
        }
    }

    /**
     *  @notice Accepts incoming ether directly
     *  @dev Overridden function for accepting ether directly
     */
    function () public payable {
    }

    /**
     *  @notice Checks if address already signed proposal
     *  @dev Iterating through signedAdmins array and compares addresses stored there
     *  with _address
     *  @return true if admin already signed proposal
     */
    function isSigned(address _address) internal view returns (bool isAlreadySigned) {
        // Iteration through signedAdmins array
        for (uint8 i=0; i<signedAdmins.length-1; i++) {
            // Checks if admin already signed proposal
            if (_address == signedAdmins[i]) {
                // If signed return true
                return true;
            }
        }
        // If not return false
        return false;
    }
}
