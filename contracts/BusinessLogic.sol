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

    /*** VARIABLES ***/

    /// @dev How much fee we take
    uint256 constant public CONTRIBUTE_FEE = 1;

    /// @dev How much ether needs to create crowdsale
    uint256 constant public CROWDSALE_FEE = 1;

    /*** STORAGE ***/

    /**
     *  Amounts of ether for each address
     */
    mapping (address => uint256) investedAmount;

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
        _address.send(_amount);

        MoneyWithdrawal(_amount, _address);
    }

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
    function createCrowdsale(uint256 _start, uint256 _end, uint256 _rate, uint256 _goal, uint256 _cap, address _wallet, address _token)
    public whenNotPaused payable onlyAdmins {

    }

    /**
    *   @dev Function for crowdsale contributing by users
    *   Contributing of crowdsale takes some fees
    **/
    function contribute() payable whenNotPaused public {

    }

    /**
    *   @dev Function for claiming our ether back, if crowdsale fails
    *   @param _crowdsaleId     ID of chosen crowdsale
    **/
    function claimRefunds(uint256 _crowdsaleId) public {

    }

    /**
     *  @dev Function for claiming tokens if crowdsale was successful
     */
    function claimTokens() {

    }

    /**
     *   @dev Overrides disallowing function to receive ether
     */
    function() public payable {
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
    function acceptWithdrawal(uint256 _amount, address _address) onlyAdmins {
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
    function declineWithdrawal() onlyAdmins {
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
}
