pragma solidity ^0.4.18;

import "./Management.sol";

/**
*   @title Storage contract for crowdsales.
*   @dev There stored data of all crowdsales.
*   By using storage we divide business logic and storage.
*   In case of any bugs or exploits we can redeploy our contract for logic and keep data safe.
*   Storage implement only create and retrieve functions
**/
contract CrowdsaleStorage is Management {

    // ID of active crowdsale
    uint256 activeCrowdsaleId;

    // Enum for crowdsale status
    enum CrowdsaleStatus {
        Waiting,        // For crowdsales, which waiting for acceptance from admins
        Active,         // For crowdsales, which is active at moment. At moment can be only 1 active crowdsale
        Ended           // For crowdsales, which is gone. They cannot be restarted
    }

    // Basic struct for crowdsale info
    struct CrowdsaleInfo {
        address crowdsaleAddress;
        address tokenAddress;
        CrowdsaleStatus status;
        uint256 weiRaised;
    }


    /*** STORAGE ***/

    // An array where stored all crowdsales
    CrowdsaleInfo[] crowdsales;


    /*** EVENTS ***/

    // Emits when crowdsale was added to storage
    event CrowdsaleWasAdded(address _crowdsaleAddress, address _tokenAddress);

    // Emits when admins set crowdsale status to active
    event CrowdsaleBecameActive(uint256 _crowdsaleId);

    // Emits when crowdsale was ended
    event CrowdsaleWasEnded(uint256 _crowdsaleId);

    /*** FUNCTIONS ***/

    /**
    *   @dev Adds crowdsale info to storage.
    *   @dev Calls internal by Crowdsale fabric contract
    *   in createCrowdsale() function
    *   @param _crowdsaleAddress            address of crowdsale contract
    *   @param _tokenAddress                address of token contract
    **/
    function addCrowdsale(address _crowdsaleAddress, address _tokenAddress) onlyAdmins public {
        // Creates new example of struct
        CrowdsaleInfo memory _crowdsale = CrowdsaleInfo({
            crowdsaleAddress: _crowdsaleAddress,
            tokenAddress: _tokenAddress,
            status: CrowdsaleStatus.Waiting,
            weiRaised: 0
            });
        // Add crowdsale to crowdsales array
        crowdsales.push(_crowdsale);
        // Emits CrowdsaleWasAdded event
        CrowdsaleWasAdded(_crowdsaleAddress, _tokenAddress);
    }

    /**
     *  @dev Sets token address for chosen crowdsale
     *  @dev Can be called only by admins
     *  @param _crowdsaleId   ID of chosen crowdsale
     */
    function setCrowdsaleToken(uint256 _crowdsaleId, address _tokenAddress) onlyAdmins public {
        crowdsales[_crowdsaleId].tokenAddress = _tokenAddress;
    }

    /**
    *   @dev Sets crowdsale status to active
    *   @dev Uses internally by admin contract. Only admins can set it active
    *   @param _crowdsaleId         id of chosen crowdsale
    **/
    function setCrowdsaleActive(uint256 _crowdsaleId) onlyAdmins public {
        // Crowdsale cannot be active twice
        require(crowdsales[_crowdsaleId].status != CrowdsaleStatus.Ended);
        // Checks if crowdsale exists
        require(crowdsales[_crowdsaleId].crowdsaleAddress != 0x0);

        if (adminCount == 1) {
            crowdsales[_crowdsaleId].status = CrowdsaleStatus.Active;
            CrowdsaleBecameActive(_crowdsaleId);
        } else {
            if (proposals[crowdsales[_crowdsaleId].crowdsaleAddress].votesNumber >= 2) {
                crowdsales[_crowdsaleId].status = CrowdsaleStatus.Active;
                CrowdsaleBecameActive(_crowdsaleId);
                delete proposals[crowdsales[_crowdsaleId].crowdsaleAddress];
            } else {
                // Checks if admin already voted
                if (!isAlreadyVoted(msg.sender, crowdsales[_crowdsaleId].crowdsaleAddress)) {
                    proposals[crowdsales[_crowdsaleId].crowdsaleAddress].votesNumber++;
                    proposals[crowdsales[_crowdsaleId].crowdsaleAddress].votes.push(msg.sender);
                }
            }
        }
    }

    /**
    *   @dev Sets crowdsale status to ended
    *   Uses internally in finalization function or can be called by admin contract
    *   @param _crowdsaleId         id of chosen crowdsale
    **/
    function setCrowdsaleEnded(uint256 _crowdsaleId) onlyAdmins public {
        // Crowdsale cannot be set Ended without being set Active
        require(crowdsales[_crowdsaleId].status != CrowdsaleStatus.Waiting);
        crowdsales[_crowdsaleId].status = CrowdsaleStatus.Ended;
        CrowdsaleWasEnded(_crowdsaleId);
    }

    /**
     *  @dev Returns token address of active crowdsale
     *  @return token address
     */
    function getCrowdsaleToken() public view returns (address tokenAddress) {
        return crowdsales[activeCrowdsaleId].tokenAddress;
    }

    /**
     *  @dev Returns crowdsale address of active crowdsale
     *  @return Crowdsale address
     */
    function getCrowdsaleAddress() public view returns (address crowdsaleAddress) {
        return crowdsales[activeCrowdsaleId].crowdsaleAddress;
    }

    /**
     *  @dev Returns crowdsale address by its id
     *  @param _crowdsaleId            Crowdsale ID
     *  @return address of crowdsale
     */
    function getCrowdsaleAddressById(uint256 _crowdsaleId) public view returns (address crowdsaleAddress) {
        return crowdsales[_crowdsaleId].crowdsaleAddress;
    }

    /**
     *  @dev Returns crowdsale token address by its id
     *  @param _crowdsaleId            Crowdsale ID
     *  @return address of crowdsale token
     */
    function getTokenAddressById(uint256 _crowdsaleId) public view returns (address tokenAddress) {
        return crowdsales[_crowdsaleId].tokenAddress;
    }

    /**
     *  @dev Returns status of crowdsale
     *  @param _crowdsaleId            Crowdsale ID
     *  @return true if crowdsale finished, false if crowdsale is waiting or active
     */
    function isCrowdsaleFinished(uint256 _crowdsaleId) public view returns (bool isFinished) {
        return crowdsales[_crowdsaleId].status == CrowdsaleStatus.Ended;
    }

    /**
     *  @dev Returns how much wei raised by MoneyVault
     *  @param  _crowdsaleId            Crowdsale ID
     *  @return Amount of wei
     */
    function getWeiRaised(uint256 _crowdsaleId) public view returns (uint256 weiRaised) {
        return crowdsales[_crowdsaleId].weiRaised;
    }
}
