pragma solidity ^0.4.18;

import "zeppelin-solidity/contracts/ownership/HasNoEther.sol";
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
    function _addCrowdsale(address _crowdsaleAddress, address _tokenAddress, address _owner) internal {
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
    function _setCrowdsaleActive(uint256 _crowdsaleId) internal {
        crowdsales[_crowdsaleId].status = CrowdsaleStatus.Active;
        CrowdsaleBecameActive(_crowdsaleId);
    }

    /**
    *   @dev Sets crowdsale status to ended
    *   Uses internally in finalization function or can be called by admin contract
    *   @param _crowdsaleId         id of chosen crowdsale
    **/
    function _setCrowdsaleEnded(uint256 _crowdsaleId) internal {
        crowdsales[_crowdsaleId].status = CrowdsaleStatus.Ended;
        CrowdsaleWasEnded(_crowdsaleId);
    }

    /**
    *   @dev Creates proposal, which crowdsale make active
    *   If there more than 3 admins, crowdsale can be set active only by 3 admins
    *   If there less than 3 admins, crowdsale can be set active by 1 admin
    *   @param _crowdsaleId         id of chosen crowdsale
    **/
    function addCrowdsaleActivationProposal(uint256 _crowdsaleId);

    /**
    *   @dev Checks if admin already signed proposal
    *
    **/
    function isAlreadySigned(address _adminAddress) constant returns (bool);

    /**
     *  @dev Returns token address of active crowdsale
     */
    function getCrowdsaleToken() constant returns (address) {
        return crowdsales[activeCrowdsaleId].tokenAddress;
    }

    /**
     *  @dev Returns crowdsale address of active crowdsale
     */
    function getCrowdsaleAddress() constant returns (address) {
        return crowdsales[activeCrowdsaleId].crowdsaleAddress;
    }
}
