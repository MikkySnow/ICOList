const BigNumber = web3.BigNumber;

require('chai')
    .use(require('chai-as-promised'))
    .use(require('chai-bignumber')(BigNumber))
    .should();

const MoneyVault = artifacts.require("./MoneyVault.sol");

contract(MoneyVault, function (accounts) {

    const amount = 1000000;

    beforeEach(function () {
        MoneyVault.deployed().then(function (instance) {
            moneyVault = instance;
        })
    });

    it('should reject claimRefund from address with zero balance', function () {
        return MoneyVault.deployed().then(function (instance) {
            return instance.claimRefunds().should.be.rejected;
        })
    });

    it('should accept ether by deposit function', function () {
        return MoneyVault.deployed().then(function (instance) {
            return instance.deposit(accounts[0], {value: amount}).should.be.not.rejected;
        })
    });

    it('should not accept ether directly', function () {
        return MoneyVault.deployed().then(function (instance) {
            return instance.send(1).should.be.rejected;
        })
    });

    it('should accept claimRefund from address with non-zero balance', function () {
        return MoneyVault.deployed().then(function (instance) {
            return instance.claimRefunds().should.be.not.rejected;
        })
    });

    it('should return correct amount of stored fund by address', function () {
        return MoneyVault.deployed().then(function (instance) {
            return instance.getAmountOfFunds(accounts[0]).should.be.bignumber.equal(amount);
        })
    });
});
