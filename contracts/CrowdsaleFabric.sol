pragma solidity ^0.4.18;

import "zeppelin-solidity/contracts/lifecycle/Pausable.sol";
import "./BasicCrowdsale.sol";

/**
*   @title Fabric for crowdsales
*   @dev Contract for generation crowdsale contracts
*   There're not common interface for crowdsale, so
*   we should use fabric to avoid it. Also by using fabric we can support interactive crowdsale
**/

contract CrowdsaleFabric is Pausable{

    /*** EVENTS ***/

    // Emits when new crowdsale was created
    event CrowdsaleWasCreated(address _wallet, address _token);


    /*** FUNCTIONS ***/

    /**
    *   Function for creating crowdsale
    *   @param _start       Crowdsale start timestamp
    *   @param _end         Crowdsale end timestamp
    *   @param _rate        How much tokens we get for 1 ether
    *   @param _goal        Goal of crowdsale
    *   @param _cap         Minimal amount of funds
    *   @param _wallet      Address of crowdsale wallet
    *   @param _token       Address of crowdsale token
    **/
    function createCrowdsale(uint256 _start, uint256 _end, uint256 _rate, uint256 _goal, uint256 _cap, address _wallet, address _token)
    public whenNotPaused returns (BasicCrowdsale) {
        CrowdsaleWasCreated(_wallet, _token);
        return new BasicCrowdsale(_start, _end, _rate, _goal, _cap, _wallet, _token);
    }
}
