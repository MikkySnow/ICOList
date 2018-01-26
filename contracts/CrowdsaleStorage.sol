pragma solidity ^0.4.18;

/**
*   Contract for storage of crowdsales. Using storage we divide business logic and storage.
*   In case of any bugs or vulnerables we can redeploy our contract for logic and keep data safe
*   Storage implement only create and retrieve functions
**/
contract CrowdsaleStorage {

    // Basic struct for crowdsale info
    struct CrowdsaleInfo {
        address crowdsaleAddress;
        address tokenAddress;
    }

    /*** STORAGE ***/

    /*** EVENTS ***/

    // Emits when crowdsale was added to storage
    event CrowdsaleWasAdded(address _crowdsaleAddress, address _tokenAddress);

    /*** FUNCTIONS ***/

    /**
    *   Adds crowdsale info to storage
    *   @param _crowdsaleAddress            address of crowdsale contract
    *   @param _tokenAddress                address of token contract
    **/
    function addCrowdsale(address _crowdsaleAddress, address _tokenAddress) internal {
        CrowdsaleWasAdded(_crowdsaleAddress, _tokenAddress);
    }
}
