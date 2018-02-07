pragma solidity ^0.4.18;

import "zeppelin-solidity/contracts/math/SafeMath.sol";
import "./Management.sol";

/**
 * @title Contract where user ether stored
 * @dev Business logic stores users ether here
 * @dev and admins can only contribute crowdsales by this ether
 */
contract MoneyVault is Management {

    // Emits when somebody want to claim refunds
    event Refunded(address _address, uint256 _amount);

    using SafeMath for uint256;

    // A mapping for save amount that was invested by address
    mapping (address => uint256) deposited;

    // @dev Function for claiming our ether back
    function claimRefunds() public {
        uint256 amount = deposited[msg.sender];
        deposited[msg.sender] = 0;
        msg.sender.transfer(amount);
        Refunded(msg.sender, amount);
    }

    /**
     *  @dev Stores ether in MoneyVault contract
     *  @param _to      Address which sent ether to this contract
     *  @param _amount  Amount which address sent to this contract
     */
    function deposit(address _to, uint256 _amount) external {
        deposited[_to] = deposited[_to].add(_amount);
    }

    /**
     *  @dev Returns amount of stored funds by chosen address
     *  @param _address Address of investor
     *  @return Amount of invested funds
     */
    function getAmountOfFunds(address _address) view public returns (uint256 amount) {
        return deposited[_address];
    }

    /**
     *  @dev Sends all ether to crowdsale contract
     *  Only admins can call this function
     *  @param _crowdsale Address of crowdsale
     */
    function sendEtherToCrowdsale(address _crowdsale) public onlyAdmins {
        _crowdsale.transfer(this.balance);
    }
}
