pragma solidity ^0.4.18;

import "zeppelin-solidity/contracts/crowdsale/CappedCrowdsale.sol";
import "zeppelin-solidity/contracts/crowdsale/RefundableCrowdsale.sol";
import "zeppelin-solidity/contracts/token/ERC20/ERC20.sol";

/**
*   Interface for crowdsale
**/

contract BasicCrowdsale is CappedCrowdsale, RefundableCrowdsale {

    // Address of token contract
    address tokenAddress;

    // Constructor for custom crowdsale
    function BasicCrowdsale(uint256 _start, uint256 _end, uint256 _rate, uint256 _goal, uint256 _cap, address _wallet, address _token) public
    CappedCrowdsale(_cap)
    RefundableCrowdsale(_goal)
    Crowdsale(_start, _end, _rate, _wallet) {
        require(_cap < _goal);
        tokenAddress = _token;
    }

    // Overrided internal function which returns token contract
    function createTokenContract() internal returns (ERC20) {
        return ERC20(tokenAddress);
    }
}
