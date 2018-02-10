// @flow
'use strict'

const BigNumber = web3.BigNumber;
const expect = require('chai').expect;
const should = require('chai')
    .use(require('chai-as-promised'))
    .use(require('chai-bignumber')(web3.BigNumber))
    .should();

import ether from './helpers/ether';
import {advanceBlock} from './helpers/advanceToBlock';
import {increaseTimeTo, duration} from './helpers/increaseTime';
import latestTime from './helpers/latestTime';
import RevertThrow from './helpers/revertThrow';
import InvalidOpcodeThrow from './helpers/invalidOpcodeThrow';

// npm install
// truffle develop
// truffle test

const Ownership = artifacts.require('./Ownership.sol');

contract('Ownership', function ([_, wallet, wallet2, wallet3]) {

    var crowdsale;
    var ownership;
    var token;
    var startTime;

    function makeSuite(name, tests) {
        describe(name, async function () {
            before(async function () {
                await advanceBlock();
                startTime = latestTime() + duration.minutes(1);
                // msg.sender is admin
                ownership = await Ownership.new(_);
                await increaseTimeTo(startTime);
            });
            tests();
        });
    }
/*
    function customFunc(param) {
        describe('' , async function () {
        });
    }
*/

    makeSuite('setCFO(address CFOAddress) onlyCEO:', async function() {
        // as same as admin, should be less or equal 5 admins
        it('should be rejected with 0x0 CFOAddress', async function () {
            await ownership.setCFO("0x0").should.be.rejected;
        })
        it('should be passed (setting)', async function () {
            await ownership.setCFO(wallet);
        })
        it('should be rejected on change CFO', async function () {
            await ownership.setCFO(wallet2).should.be.rejected;
        })
    })

    makeSuite('setAdmin(address adminAddress) onlyCEO:', async function() {
        // should be less or equal 5 admins
        it('should be rejected with 0x0 address', async function () {
            await ownership.setAdmin("0x0").should.be.rejected;
        })
        it('should be passed (setting)', async function () {
            await ownership.setAdmin(wallet);
        })
        it('should be passed 5 admins and 6 will be rejected', async function () {
            await ownership.setAdmin(wallet2);
            await ownership.setAdmin(wallet3);
            await ownership.setAdmin("0x5");
            await ownership.setAdmin("0x6").should.be.rejected;
        })
    })

    makeSuite('removeCFO(address CFOAddress) onlyCEO:', async function() {
        
        it('should be rejected with 0x0 CFOAddress', async function () {
            // if its not, there are adminCount bug
            await ownership.removeCFO("0x0").should.be.rejected;
        })
        it('should be rejected with not CFO Address', async function () {
            await ownership.removeCFO(wallet).should.be.rejected;
        })
        it('should be passed with removing real CFO', async function () {
            await ownership.setCFO(wallet);
            await ownership.removeCFO(wallet);
            let isCFO = await ownership.isAdminAddress(wallet);
            isCFO.should.be.equal(false);
        })
    })

    makeSuite('removeAdmin(address adminAddress) onlyAdmins:', async function() {
        
        it('should be rejected with 0x0 adminAddress', async function () {
            // if its not, there are adminCount bug
            await ownership.removeAdmin("0x0").should.be.rejected;
        })
        it('should be rejected with not admin`s Address', async function () {
            await ownership.removeAdmin(wallet).should.be.rejected;
        })
        it('should be passed with removing real admin (notCFO)', async function () {
            await ownership.setCFO(wallet);
            await ownership.removeAdmin(wallet).should.be.rejected;
            await ownership.setAdmin(wallet2);
            await ownership.removeAdmin(wallet2);
            let isAdmin = await ownership.isAdminAddress(wallet2);
            isAdmin.should.be.equal(false);
        })
    })

    makeSuite('isAdminAdress(address adminAddress):', async function() {

        it('should return true on CEO check', async function () {
            let isAdmin = await ownership.isAdminAddress(_);
            isAdmin.should.be.equal(true);
        })

        it('should return false on 0x0 address', async function () {
            let isAdmin = await ownership.isAdminAddress("0x0");
            isAdmin.should.be.equal(false);
        })
        it('should return firstly false and than true on setted address', async function () {
            let isAdmin = await ownership.isAdminAddress(wallet);
            let isAdmin2 = await ownership.isAdminAddress(wallet2);
            isAdmin.should.be.equal(false);
            isAdmin.should.be.equal(false);
            await ownership.setCFO(wallet);
            await ownership.setAdmin(wallet2);

            isAdmin = await ownership.isAdminAddress(wallet);
            isAdmin2 = await ownership.isAdminAddress(wallet2);

            isAdmin.should.be.equal(true);
            isAdmin.should.be.equal(true);
        })
    })
})    
