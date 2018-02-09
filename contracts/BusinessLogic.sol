pragma solidity ^0.4.19;

import "./Management.sol";
import "./CrowdsaleStorage.sol";

// @title Contract that implements all business logic of contract
contract BusinessLogic is Management {
    
    // @dev Instance of crowdsale storage
    CrowdsaleStorage crowdsaleStorage;
    
    // @dev Address of AdminMoneyVault contract
    address adminMoneyVault;
    
    // @dev Amount of fees admins take
    uint8 FEE = 1;
    
    // @dev A mapping where stored amount of invested funds by every address 
    mapping (address => uint256) invested;
    
    
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
        invested[msg.sender] += msg.value - amount;
    }
    
    // @dev Claims invested funds
    function claimRefunds() public {
        msg.sender.transfer(invested[msg.sender]);
    }
    
    // @dev Sets amount of fees in percentage
    function setFee(uint8 fee) public onlyCFO {
        FEE = fee;
    }
}