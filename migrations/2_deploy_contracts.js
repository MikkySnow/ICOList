const Ownership = artifacts.require("Ownership");
const Management = artifacts.require("Management");	
const Crowdsale = artifacts.require("Crowdsale");
const CrowdsaleStorage = artifacts.require("CrowdsaleStorage");

module.exports = function(deployer) {
	deployer.deploy(Ownership);
	deployer.deploy(Management, "0x1");
	deployer.deploy(Crowdsale, "0x1", 10, 60, 10000, "0x2");
	deployer.deploy(CrowdsaleStorage, "0x1");
};
