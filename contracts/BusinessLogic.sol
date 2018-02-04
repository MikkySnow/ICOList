pragma solidity ^0.4.18;

import "./Management.sol";
import "./MoneyVault.sol";
import "./CrowdsaleStorage.sol";

import "zeppelin-solidity/contracts/token/ERC20/BasicToken.sol";
import "zeppelin-solidity/contracts/crowdsale/Crowdsale.sol";
import "zeppelin-solidity/contracts/math/SafeMath.sol";

/**
*   @title Contract for business logic
*   @dev There implemented all business logic
*   All users interaction works via this contract
*/
contract BusinessLogic is Management {

    using SafeMath for uint256;


    /*** EVENTS ***/


    /// @dev Emits when new MoneyVault address was set
    event NewMoneyVaultAddress(address _address, address _setBy);

    /// @dev Emits when new CrowdsaleStorage address was set
    event NewCrowdsaleStorageAddress(address _adress, address _setBy);


    /*** VARIABLES ***/

    /// @dev How much fee we take
    uint256 constant public CONTRIBUTE_FEE = 1;

    /// @dev Vault where stored users ether
    MoneyVault moneyVault;

    /// @dev Storage where all crowdsales stored
    CrowdsaleStorage crowdsaleStorage;


    /*** FUNCTIONS ***/

    /**
    *   @dev Function for crowdsale contributing by users
    *   Contributing of crowdsale takes some fees
    *   User money sends to MoneyVault
    **/
    function contribute() payable whenNotPaused public {

    }

    /**
     *  @dev Function for claiming tokens if crowdsale was successful
     */
    function claimTokens() public {

        // Getting crowdsale and token addresses
        address crowdsaleAddress = crowdsaleStorage.getCrowdsaleAddress();
        address tokenAddress = crowdsaleStorage.getCrowdsaleToken();

        // If balanceOf greater than 0, that mean we've bought some tokens
        BasicToken token = BasicToken(tokenAddress);
        require(token.balanceOf(msg.sender) > 0);

        // Getting how much tokens user should get
        Crowdsale crowdsale = Crowdsale(crowdsaleAddress);
//        uint256 amount = crowdsale.rate;

        // Transfer tokens to user
//        token.transfer(msg.sender, amount);
    }

    /**
     *   @dev Overrides disallowing function to receive ether
     *   Works the same as contribute()
     */
    function() public payable {
        uint256 amount = msg.value.mul(CONTRIBUTE_FEE).div(100);

    }



    /**
     *  @dev Sets MoneyVault contract address
     *  @param _address         New address of MoneyVault contract
     */
    function setMoneyVaultAddress(address _address) onlyAdmins whenPaused public {
        // We cannot set contract address to zero
        require(_address != 0x0);
        // Sets new address
        moneyVault = MoneyVault(_address);
        // Emits event
        NewMoneyVaultAddress(_address, msg.sender);
    }

    /**
     *  @dev Sets CrowdsaleStorage contract address
     *  Can be called only by more than 2 admins
     *  @param _address         New address of CrowdsaleStorage contract
     */
    function setCrowdsaleStorageAddress(address _address) onlyAdmins whenPaused public {
        // We cannot set contract address to zero
        require(_address != 0x0);

        if (adminCount == 1) {
            // Sets new address
            crowdsaleStorage = CrowdsaleStorage(_address);
            // Emits event
            NewCrowdsaleStorageAddress(_address, msg.sender);
        } else {
            // Checks if there enough votes
            if (proposals[_address].votesNumber > 2) {
                // Sets new address
                crowdsaleStorage = CrowdsaleStorage(_address);
                // Emits event
                NewCrowdsaleStorageAddress(_address, msg.sender);
                // Remove proposal
                delete proposals[_address];
            } else {
                // Checks if admin already voted
                if (!isAlreadyVoted(msg.sender, _address)) {
                    proposals[_address].votesNumber++;
                    proposals[_address].votes.push(msg.sender);
                }
            }
        }
    }
}
