pragma solidity ^0.4.18;

import "zeppelin-solidity/contracts/lifecycle/Pausable.sol";
import "zeppelin-solidity/contracts/math/SafeMath.sol";

/**
*   @title Contract for business logic
*   @dev There implemented all business logic
*   All users interaction works via this contract
*/
contract BusinessLogic is Pausable {

    using SafeMath for uint256;

    /*** EVENTS ***/

    /// @dev Emits when somebody withdraws money from contract
    event MoneyWithdrawal(uint256 _amount, address _address);

    /*** VARIABLES ***/

    /// @dev How much fee we take
    uint256 constant public CONTRIBUTE_FEE = 1;

    /// @dev How much ether needs to create crowdsale
    uint256 constant public CROWDSALE_FEE = 0.01;

    /*** FUNCTIONS ***/

    /**
    *   @dev Function for money withdrawal
    *   Can be called only by 2 or more admins
    *   @param _address         Address to withdraw
    *   @param _amount          Amount to withdraw
    **/
    function withdraw(address _address, uint256 _amount);

    /**
    *   @dev Function for creating crowdsale by user
    *   Creation of crowdsale costs some ether
    *   @param _start           Crowdsale start timestamp
    *   @param _end             Crowdsale end timestamp
    *   @param _rate            How much tokens we get for 1 ether
    *   @param _goal            Goal of crowdsale
    *   @param _cap             Minimal amount of funds
    *   @param _wallet          Address of crowdsale wallet
    *   @param _token           Address of crowdsale token
    **/
    function createCrowdsale(uint256 _start, uint256 _end, uint256 _rate, uint256 _goal, uint256 _cap, address _wallet, address _token) public payable;

    /**
    *   @dev Function for crowdsale contributing by users
    *   Contributing of crowdsale takes some fee
    *   @param _crowdsaleId     ID of chosen crowdsale
    **/
    function contributeCrowdsale(uint256 _crowdsaleId) payable public;

    /**
    *   @dev Function for claiming our ether back, if crowdsale fails
    *   @param _crowdsaleId     ID of chosen crowdsale
    **/
    function claimRefunds(uint256 _crowdsaleId) public;
}
