pragma solidity ^0.4.18;

// @title Interface for interaction with ERC20 and ERC223 Tokens
contract ERC20 {
  function balanceOf(address who) public view returns (uint256);
  function transfer(address to, uint256 value) public returns (bool);
}