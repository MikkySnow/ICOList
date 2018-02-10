pragma solidity ^0.4.18;

import "./Management.sol";
import "./CrowdsaleStorage.sol";
import "./ERC20.sol";

// @title Contract that implements all business logic of contract
contract BusinessLogic is Management {
    
    // @dev Struct for crowdsale campaign
    struct Campaign {
        // @dev A mapping where stored amount of invested funds by every address 
        mapping (address => uint256) invested;
        // @dev How many wei raised crowdsale
        uint256 weiRaised;
        // @dev Is campaign finished
        bool isFinished;
    }
    
    // @dev Instance of crowdsale storage
    CrowdsaleStorage crowdsaleStorage;
    
    // @dev Address of AdminMoneyVault contract
    address adminMoneyVault;
    
    // @dev Amount of fees admins take
    uint8 FEE = 1;
    
    // @dev A mapping where stored how much wei raised every crowdsale
    mapping (uint256 => Campaign) campaigns;
    
    // @dev Default constructor for Business logic contract
    // @param _address Address of Ownership contract
    function BusinessLogic(address _address) public Management (_address) {
        require(_address != 0x0);
    }
    
    // @dev Sets address of CrowdsaleStorage  contract
    // @param crowdsaleStorageAddress Address of crowdsale storage
    function setCrowdsaleStorage(address crowdsaleStorageAddress) onlyCEO public {
        require(crowdsaleStorageAddress != 0x0);
        crowdsaleStorage = CrowdsaleStorage(crowdsaleStorageAddress);
    }
    
    // @Sets address of AdminMoneyVault contract
    function setAdminMoneyVault(address adminMoneyVaultAddress) onlyCEO public {
        require(adminMoneyVaultAddress != 0x0);
        adminMoneyVault = adminMoneyVaultAddress;
    }
    
    // @dev Contributes this contract
    function contribute() public whenNotPaused payable {
        uint256 amount = msg.value * FEE / 100;
        adminMoneyVault.transfer(amount);
        campaigns[crowdsaleStorage.activeCrowdsaleId()].invested[msg.sender] += msg.value - amount;
    }
    
    // @dev Sets amount of fees in percentage
    function setFee(uint8 fee) public onlyCFO {
        FEE = fee;
    }
    
    // @dev Buy tokens of active crowdsale
    function buyTokens() public onlyCFO {
        uint256 crowdsaleId = crowdsaleStorage.activeCrowdsaleId();
        address crowdsaleAddress = crowdsaleStorage.getCrowdsaleAddressById(crowdsaleId);
        require(crowdsaleId != 0);
        campaigns[crowdsaleId].weiRaised = this.balance;
        crowdsaleAddress.transfer(campaigns[crowdsaleId].weiRaised);
        campaigns[crowdsaleId].isFinished = true;
    }
    
    // @dev Claims tokens
    function claimTokens(uint256 crowdsaleId) public {
        // Converts to ERC20 Interface
        ERC20 token = ERC20(crowdsaleStorage.getTokenAddressById(crowdsaleId));
        uint256 amount = campaigns[crowdsaleId].weiRaised / token.balanceOf(this) * campaigns[crowdsaleId].invested[msg.sender];
        token.transfer(msg.sender, amount);
    }
}