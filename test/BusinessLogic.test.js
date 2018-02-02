var MoneyVault = artifacts.require("./MoneyVault.sol");
var BusinessLogic = artifacts.require("./BusinessLogic.sol");
var utils = require("./Utils.js");
var chai = require("chai");
var chaiAsPromised = require("chai-as-promised");
chai.use(chaiAsPromised);
chai.should();

contract(BusinessLogic, function (accounts) {

    let businessLogic;

    beforeEach(function () {
       BusinessLogic.deployed().then(function (instance) {
           businessLogic = instance;
       })
    });

    describe("Testing deployment of business logic", function () {
        it('should reject creating contract without money vault', function () {

        });

        it('should reject creating contract without crowdsale storage', function () {

        });
    });

    describe("Testing storing ether in money vault", function () {
        it('should reject claimRefund request for msg.sender with zero deposit', function () {
            // return moneyVault.claimRefunds().should.be.rejected;
        });

        it('should accept claimRefund request for msg.sender with non-zero deposit', function () {

        });

        it('should return correct amount of funds stored by address', function () {

        })
    })
});
