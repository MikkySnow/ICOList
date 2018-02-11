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

const Management = artifacts.require('./Management.sol');
const Ownership = artifacts.require('./Ownership.sol');

contract('Management', function ([_, wallet, wallet2, wallet3]) {

    var crowdsale;
    var management;
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
                management = await Management.new(ownership.address);
                await increaseTimeTo(startTime);
            });
            tests();
        });
    }

    makeSuite('transferOwnership(address _address) onlyCEO:', async function() {
        it('should be rejected with 0x0 _address', async function () {
            await management.transferOwnership("0x0").should.be.rejected;
        })
        it('should be passed with correct _address', async function () {
            await management.transferOwnership("0x1");
        })
    })

    makeSuite('pause() onlyAdmins whenNotPaused:', async function() {
        it('should be passed by default', async function () {
            await management.pause();
            let ps = await management.paused();
            ps.should.be.equal(true);
        })
        it('should be rejected when already paused', async function () {
            await management.pause().should.be.rejected;
        })
    })
    makeSuite('unpause() onlyAdmins whenPaused:', async function() {
        it('should be rejected by default (pause = false)', async function () {
            let ps = await management.paused();
            ps.should.be.equal(false);
            await management.unpause().should.be.rejected;
        })
        it('should be passed when paused, but not twice', async function () {
            await management.pause();
            await management.unpause();
            await management.unpause().should.be.rejected;
        })
    })
})