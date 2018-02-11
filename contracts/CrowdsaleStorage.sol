pragma solidity ^0.4.18;

import "./Management.sol";

//  @title Storage contract for crowdsales.
//  @dev There stored data of all crowdsales
contract CrowdsaleStorage is Management {

    // @dev ID of active crowdsale
    uint256 public activeCrowdsaleId;

    // @dev Enum for crowdsale status
    enum CrowdsaleStatus {
        Waiting,        // For crowdsales, which waiting for acceptance from admins
        Active,         // For crowdsales, which is active at moment. At moment can be only 1 active crowdsale
        Ended           // For crowdsales, which is gone. They cannot be restarted
    }

    // @dev Basic struct for crowdsale info
    struct CrowdsaleInfo {
        address crowdsaleAddress;
        address tokenAddress;
        CrowdsaleStatus status;
    }


    /*** STORAGE ***/

    // @dev An array where stored all crowdsales
    CrowdsaleInfo[] crowdsales;


    /*** EVENTS ***/

    // @dev Emits when crowdsale was added to storage
    event CrowdsaleWasAdded(address _crowdsaleAddress, address _tokenAddress);

    // @dev Emits when admins set crowdsale status to active
    event CrowdsaleBecameActive(uint256 _crowdsaleId);

    // @dev Emits when crowdsale was ended
    event CrowdsaleWasEnded(uint256 _crowdsaleId);

    /*** FUNCTIONS ***/

    // @dev Default constructor for CrowdsaleStorage contract
    // @param _address Address of Ownership contract
    function CrowdsaleStorage(address _address) public Management(_address) {
        require(_address != 0x0);
        CrowdsaleInfo memory _crowdsale = CrowdsaleInfo({
             crowdsaleAddress: 0x0,
             tokenAddress: 0x0,
             status: CrowdsaleStatus.Active
             });
         // Add crowdsale to crowdsales array
         crowdsales.push(_crowdsale);
    }

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
            status: CrowdsaleStatus.Waiting
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
    function setCrowdsaleToken(uint256 _crowdsaleId, address _tokenAddress) onlyCEO public {
        crowdsales[_crowdsaleId].tokenAddress = _tokenAddress;
    }

    /**
    *   @dev Sets crowdsale status to ended
    *   @param _crowdsaleId         id of chosen crowdsale
    **/
    function setCrowdsaleEnded(uint256 _crowdsaleId) onlyCEO public {
        // Crowdsale cannot be set Ended without being set Active
        require(crowdsales[_crowdsaleId].status == CrowdsaleStatus.Active);
        crowdsales[_crowdsaleId].status = CrowdsaleStatus.Ended;
        activeCrowdsaleId = 0;
        CrowdsaleWasEnded(_crowdsaleId);
    }
    
    function setCrowdsaleActive(uint256 _crowdsaleId) onlyCEO public {
        require(activeCrowdsaleId == 0);
        require(crowdsales[_crowdsaleId].status == CrowdsaleStatus.Waiting);
        crowdsales[_crowdsaleId].status = CrowdsaleStatus.Active;
        activeCrowdsaleId = _crowdsaleId;
        CrowdsaleBecameActive(_crowdsaleId);
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
}
