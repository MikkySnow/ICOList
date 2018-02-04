pragma solidity ^0.4.18;

import "zeppelin-solidity/contracts/math/SafeMath.sol";
import "./Management.sol";

/**
 * @title Contract where user ether stored
 * @dev Admins can only contribute crowdsales
 */
contract MoneyVault is Management {

    /**
     *  @dev Emits when somebody want to claim refunds
     */
    event Refunded(address _address, uint256 _amount);

    using SafeMath for uint256;

    /**
     *   @dev A mapping for save amount that was invested by address
     */
    mapping (address => uint256) deposited;

    /**
     *   @dev Function for claiming our ether back, if crowdsale fails
     */
    function claimRefunds() public {
        uint256 amount = deposited[msg.sender];
        deposited[msg.sender] = 0;
        msg.sender.transfer(amount);
        Refunded(msg.sender, amount);
    }

    /**
     *  @dev Stores ether in MoneyVault contract
     */
    function deposit(address _to, uint256 _amount) external {
        deposited[_to] = deposited[_to].add(_amount);
    }

    /**
     *  @dev Returns amount of stored funds by chosen address
     */
    function getAmountOfFunds(address _address) constant public returns (uint256) {
        return deposited[_address];
    }

    /**
     *  @dev Sends all ether to crowdsale contract
     */
    function sendEtherToCrowdsale(address _crowdsale) public onlyAdmins {
        _crowdsale.transfer(this.balance);
    }
}
