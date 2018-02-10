pragma solidity ^0.4.0;

import "./Management.sol";

/**
 *   @title A vault for admins funds
 *   @dev There stored all admins ether earned by taking fees
 */
contract AdminMoneyVault is Management {

    // @dev Event emits when somebody withdraws money from contract
    // @param _amount How much wei was sent
    // @param _address To what address wei was sent
    event MoneyWithdrawal(uint256 _amount, address _address);

    /**
    *   @dev Function for money withdrawal
    *   @dev Can be called only from Interactions contract
    *   @param _address         Address to withdraw
    *   @param _amount          Amount to withdraw
    **/
    function withdraw(address _address, uint256 _amount) onlyCFO external {
        // Checks if contract balance greater than withdrawal amount
        require(this.balance >= _amount);
        // Transfers ether to _address
        _address.transfer(_amount);
        // Emits withdrawal event
        MoneyWithdrawal(_amount, _address);
    }

    // @dev Default constructor for BusinessLogic contract
    // @param _address Address of Ownership contract
    function AdminMoneyVault(address _address) Management(_address) public {
        require(_address != 0x0);
    }

    //  @dev Accepts incoming ether directly
    function () public payable {
    }
}
