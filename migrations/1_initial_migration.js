var Migrations = artifacts.require("./Migrations.sol");
var AdminMoneyVault = artifacts.require("./AdminMoneyVault.sol");
var BusinessLogic = artifacts.require("./BusinessLogic.sol");
var Management = artifacts.require("./Management.sol");
var MoneyVault = artifacts.require("./MoneyVault.sol");
var CrowdsaleStorage = artifacts.require("./CrowdsaleStorage.sol");
var ERC20Token = artifacts.require("./ERC20Token.sol");
var ERC20Crowdsale = artifacts.require("./ERC20Crowdsale.sol");

module.exports = function(deployer, accounts) {
  deployer.deploy(Migrations);
  deployer.deploy(AdminMoneyVault);
  deployer.deploy(BusinessLogic);
  deployer.deploy(Management);
  deployer.deploy(MoneyVault);
  deployer.deploy(CrowdsaleStorage);

  const initialSupply = 10000000;
  const name = "Test Coin";
  const symbol = "TCC";

  var addressOfTokenUsedAsReward;
  deployer.deploy(ERC20Token, initialSupply, name, symbol)
      .then(function (token) {
         addressOfTokenUsedAsReward = token.address;
      });

  const ifSuccessfulSendTo = accounts[6];
  const fundingGoalInEthers = 1000;
  const durationInMinutes = 100;
  const etherCostOfEachToken = 1;

  deployer.deploy(ERC20Crowdsale, ifSuccessfulSendTo, fundingGoalInEthers, durationInMinutes, etherCostOfEachToken, addressOfTokenUsedAsReward);
};
