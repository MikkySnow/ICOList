var Management = artifacts.require("./Management.sol");
var utils = require("./Utils.js");
var chai = require("chai");
var chaiAsPromised = require("chai-as-promised");
chai.use(chaiAsPromised);
chai.should();

contract('Management', function (accounts) {

    it("first address should be admin", function () {
        Management.deployed().then(function (instance) {
            return instance.isAdmin.call(accounts[0]);
        }).then(function (result) {
            assert.isTrue(result)
        })
    });

    it("not able to delete last admin", function () {
        return Management.deployed().then(function (instance) {
            return instance.removeAdmin(accounts[0]).should.be.rejected;
        })
    });

    it("second address should not be admin", function () {
        return Management.deployed().then(function (instance) {
            return instance.isAdmin.call(accounts[1]);
        }).then(function (result) {
            assert.isFalse(result)
        })
    });

    it("should reject any payment", function () {
        return Management.deployed().then(function (instance) {
            return instance.send(1).should.be.rejected;
        })
    });

    it("should not be able to add new admin by non-admin address", function () {
        return Management.deployed().then(function (instance) {
            return instance.addAdmin.call(accounts[5], {from: accounts[1]}).should.be.rejected;
        })
    });

    it("should not be able to pause contract by non-admin address", function () {
        return Management.deployed().then(function (instance) {
            return instance.pause.call({from: accounts[1]}).should.be.rejected;
        })
    });

    it("should be able to add new admin by existing admin", function () {
        return Management.deployed().then(function (instance) {
            return instance.addAdmin(accounts[2])
                .then(() => utils.assertEvent(instance, {event: "AdminWasAdded"}))
        })
    });

    it("should be able to pause contract", function () {
        return Management.deployed().then(function (instance) {
            return instance.pause()
                .then(() => utils.assertEvent(instance, {event: "Pause"}))
        })
    });

    it("should be able to unpause contract", function () {
        return Management.deployed().then(function (instance) {
            return instance.unpause()
                .then(() => utils.assertEvent(instance, {event: "Unpause"}))
        })
    });

    it('should be able to remove admin', function () {
        return Management.deployed().then(function (instance) {
            return instance.addAdmin(accounts[5])
                .then(() => instance.removeAdmin(accounts[5]))
                .then(() => utils.assertEvent(instance, {event : "AdminWasRemoved"}))
        })
    });
});
