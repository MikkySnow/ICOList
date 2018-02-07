var Migrations = artifacts.require("./Migrations.sol");
var AdminMoneyVault = artifacts.require("./AdminMoneyVault.sol");
var BusinessLogic = artifacts.require("./BusinessLogic.sol");
var Management = artifacts.require("./Management.sol");
var MoneyVault = artifacts.require("./MoneyVault.sol");
var CrowdsaleStorage = artifacts.require("./CrowdsaleStorage.sol");

module.exports = function(deployer) {
  deployer.deploy(Migrations);
};
