pragma solidity ^0.4.18;

import "./Ownership.sol";
import "./BusinessLogic.sol";
import "./CrowdsaleStorage.sol";
import "./MoneyVault.sol";
import "./AdminMoneyVault.sol";
import "./Management.sol";

// @title Contract for all interactions
// @dev Provides functions for interactions with all contracts
contract Interactions is Ownership {
    
    /*** STORAGE ***/
    
    // @dev BusinessLogic contract
    BusinessLogic businessLogic;
    
    // @dev CrowdsaleStorage contract
    CrowdsaleStorage crowdsaleStorage;
    
    // @dev MoneyVault contract
    MoneyVault moneyVault;
    
    // @dev AdminMoneyVault contract
    AdminMoneyVault adminMoneyVault;
    
    /***  FUNCTIONS ***/
    
    // @dev Function for money withdrawal
    // @param amount Amount to withdraw
    // @param to Address to withdraw
    function withdraw(address to, uint256 amount) public onlyCFO {
        AdminMoneyVault.withdraw(to, amount);    
    }
    
    // @dev Pauses chosen contract
    // @param contractAddress Address of contract
    function pause(address contractAddress) public onlyAdmins {
        Management(contractAddress).pause();
    }
    
    // @dev Unpauses chosen contract
    // @param contractAddress Address of contract
    function unpause(address contractAddress) public onlyAdmins {
        Management(contractAddress).unpause();
    }
    
    // @dev Sets BusinessLogic contract address
    // @param contractAddress Address of contract
    function setBusinessLogic(address contractAddress) public onlyCEO {
        require(businessLogic != 0x0);
        businessLogic = contractAddress;
    }
    
    // @dev Sets CrowdsaleStorage contract address
    // @param contractAddress Address of contract
    function setCrowdsaleStorage(address contractAddress) public onlyCEO {
        require(contractAddress != 0x0);
        crowdsaleStorage = contractAddress;
    }
    
    // @dev Sets MoneyVault contract address
    // @param contractAddress Address of contract
    function setMoneyVault(address contractAddress) public onlyCEO {
        require(contractAddress != 0x0);
        moneyVault = contractAddress;
    }
    
    // @dev Sets AdminMoneyVault contract address
    // @param contractAddress Address of contract
    function setAdminMoneyVault(address contractAddress) public onlyCEO {
        require(contractAddress != 0x0);
        adminMoneyVault = contractAddress;
    }
}