pragma solidity ^0.4.18;

import "zeppelin-solidity/contracts/math/SafeMath.sol";

/**
 * @title Contract where user ether stored
 * @dev Admins can only contribute crowdsales
 */
contract MoneyVault {

    using SafeMath for uint256;

    /**
     *   @dev A mapping for save amount that was invested by address
     */
    mapping (address => uint256) investedAmount;

    /**
     *   @dev Function for claiming our ether back, if crowdsale fails
     */
    function claimRefunds() public {
        uint256 memory amount = investedAmount[msg.sender];

        msg.sender.transfer(amount);

        investedAmount[msg.sender] -= amount;
    }
}
