pragma solidity ^0.4.18;

import "./Management.sol";

/**
*   @title Storage contract for crowdsales.
*   @dev There stored data of all crowdsales
*   Using storage we divide business logic and storage.
*   In case of any bugs or exploits we can redeploy our contract for logic and keep data safe
*   Storage implement only create and retrieve functions
**/
contract CrowdsaleStorage is Management {

    /// @dev Active crowdsale id
    uint256 activeCrowdsaleId;

    /// @dev Enum for crowdsale status
    enum CrowdsaleStatus {
        Waiting,        // For crowdsales, which waiting for acceptance from admins
        Active,         // For crowdsales, which is active at moment. At moment can be only 1 active crowdsale
        Ended           // For crowdsales, which is gone. They cannot be restarted
    }

    /// @dev Basic struct for crowdsale info
    struct CrowdsaleInfo {
        address crowdsaleAddress;
        address tokenAddress;
        CrowdsaleStatus status;
        uint256 weiRaised;
    }


    /*** STORAGE ***/

    /// @dev An array where stored all crowdsales
    CrowdsaleInfo[] crowdsales;

    /// @dev A mapping from crowdsale index to address that owns it
    mapping (uint256 => address) indexToOwner;

    /*** EVENTS ***/

    /// @dev Emits when crowdsale was added to storage
    event CrowdsaleWasAdded(address _crowdsaleAddress, address _tokenAddress);

    /// @dev Emits when admins set crowdsale status to active
    event CrowdsaleBecameActive(uint256 _crowdsaleId);

    /// @dev Emits when crowdsale was ended
    event CrowdsaleWasEnded(uint256 _crowdsaleId);

    /*** FUNCTIONS ***/

    /**
    *   @dev Adds crowdsale info to storage.
    *   Calls internal by Crowdsale fabric contract
    *   in createCrowdsale() function
    *   @param _crowdsaleAddress            address of crowdsale contract
    *   @param _tokenAddress                address of token contract
    **/
    function addCrowdsale(address _crowdsaleAddress, address _tokenAddress, address _owner) onlyAdmins public {
        CrowdsaleInfo memory _crowdsale = CrowdsaleInfo({
            crowdsaleAddress: _crowdsaleAddress,
            tokenAddress: _tokenAddress,
            status: CrowdsaleStatus.Waiting
            });

        uint256 index = crowdsales.push(_crowdsale) - 1;
        indexToOwner[index] = _owner;

        CrowdsaleWasAdded(_crowdsaleAddress, _tokenAddress);
    }

    /**
    *   @dev Sets crowdsale status to active
    *   Uses internally by admin contract. Only admins can set it active
    *   @param _crowdsaleId         id of chosen crowdsale
    **/
    function setCrowdsaleActive(uint256 _crowdsaleId) onlyAdmins public {
        crowdsales[_crowdsaleId].status = CrowdsaleStatus.Active;
        CrowdsaleBecameActive(_crowdsaleId);
    }

    /**
    *   @dev Sets crowdsale status to ended
    *   Uses internally in finalization function or can be called by admin contract
    *   @param _crowdsaleId         id of chosen crowdsale
    **/
    function setCrowdsaleEnded(uint256 _crowdsaleId) onlyAdmins public {
        crowdsales[_crowdsaleId].status = CrowdsaleStatus.Ended;
        CrowdsaleWasEnded(_crowdsaleId);
    }

    /**
     *  @dev Returns token address of active crowdsale
     */
    function getCrowdsaleToken() public constant returns (address) {
        return crowdsales[activeCrowdsaleId].tokenAddress;
    }

    /**
     *  @dev Returns crowdsale address of active crowdsale
     */
    function getCrowdsaleAddress() public constant returns (address) {
        return crowdsales[activeCrowdsaleId].crowdsaleAddress;
    }

    /**
     *  @dev Returns crowdsale address by its id
     *  @param _crowdsaleId            Crowdsale ID
     *  @return address of crowdsale
     */
    function getCrowdsaleAddressById(uint256 _crowdsaleId) public view returns (address) {
        return crowdsales[_crowdsaleId].crowdsaleAddress;
    }

    /**
     *  @dev Returns crowdsale token address by its id
     *  @param _crowdsaleId            Crowdsale ID
     *  @return address of crowdsale token
     */
    function getTokensAddressById(uint256 _crowdsaleId) public view returns (address) {
        return crowdsales[_crowdsaleId].tokenAddress;
    }

    /**
     *  @dev Returns status of crowdsale
     *  @param _crowdsaleId            Crowdsale ID
     *  @return true if crowdsale finished, false if crowdsale is waiting or active
     */
    function isCrowdsaleFinished(uint256 _crowdsaleId) public view returns (bool) {
        return crowdsales[_crowdsaleId].status == CrowdsaleStatus.Ended;
    }

    function getWeiRaised(uint256 _crowdsaleId) public view returns (uint256) {
        return crowdsales[_crowdsaleId].weiRaised;
    }
}
