pragma solidity ^0.4.18;

/**
*   Contract for storage of crowdsales. Using storage we divide business logic and storage.
*   In case of any bugs or exploits we can redeploy our contract for logic and keep data safe
*   Storage implement only create and retrieve functions
**/
contract CrowdsaleStorage {

    // Basic struct for crowdsale info
    struct CrowdsaleInfo {
        address crowdsaleAddress;
        address tokenAddress;
    }

    /*** STORAGE ***/

    // An array where stored all crowdsales
    CrowdsaleInfo[] crowdsales;

    // A mapping from crowdsale index to address that owns it
    mapping (uint256 => address) indexToOwner;

    /*** EVENTS ***/

    // Emits when crowdsale was added to storage
    event CrowdsaleWasAdded(address _crowdsaleAddress, address _tokenAddress);

    /*** FUNCTIONS ***/

    /**
    *   Adds crowdsale info to storage. Calls only by Crowdsale fabric contract
    *   in createCrowdsale() function
    *   @param _crowdsaleAddress            address of crowdsale contract
    *   @param _tokenAddress                address of token contract
    **/
    function addCrowdsale(address _crowdsaleAddress, address _tokenAddress, address _owner) internal {
        CrowdsaleInfo memory _crowdsale = CrowdsaleInfo(_crowdsaleAddress, _tokenAddress);

        uint256 index = crowdsales.push(_crowdsale) - 1;
        indexToOwner[index] = _owner;

        CrowdsaleWasAdded(_crowdsaleAddress, _tokenAddress);
    }
}
