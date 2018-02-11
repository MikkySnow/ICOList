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

const CrowdsaleStorage = artifacts.require('./CrowdsaleStorage.sol');
const Ownership = artifacts.require('./Ownership.sol');

contract('CrowdsaleStorage', function ([_, wallet, wallet2, wallet3]) {

    var crowdsaleSt;
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
                crowdsaleSt = await CrowdsaleStorage.new(ownership.address);
                await increaseTimeTo(startTime);
            });
            tests();
        });
    }

    makeSuite('addCrowdsale(address _crowdsaleAddress, address _tokenAddress) onlyAdmins:', async function() {
        it('should be passed', async function () {
            //correct format
            let crowdAddr = "0x0000000000000000000000000000000000000002";
            let tokenAddr = "0x0000000000000000000000000000000000000003";
            await crowdsaleSt.addCrowdsale(crowdAddr, tokenAddr);

            let a = await crowdsaleSt.getCrowdsaleAddressById(1);
            let b = await crowdsaleSt.getTokenAddressById(1);
            
            a.should.be.equal(crowdAddr);
            b.should.be.equal(tokenAddr);
        })
    })

    makeSuite('setCrowdsaleActive(uint256 _crowdsaleId) onlyCEO:', async function() {
        it('should be passed on waiting', async function () {
            let crowdAddr = "0x0000000000000000000000000000000000000002";
            let tokenAddr = "0x0000000000000000000000000000000000000003";
            await crowdsaleSt.addCrowdsale(crowdAddr, tokenAddr); // 1
            await crowdsaleSt.setCrowdsaleActive(1);
            let indxAct = await crowdsaleSt.activeCrowdsaleId();
            indxAct.should.be.bignumber.equal(1);
        })
        it('should be rejected on ended/active', async function () {
            await crowdsaleSt.setCrowdsaleActive(1).should.be.rejected;
            await crowdsaleSt.setCrowdsaleEnded(1);

            let crowdAddr = "0x0000000000000000000000000000000000000002";
            let tokenAddr = "0x0000000000000000000000000000000000000003";
            await crowdsaleSt.addCrowdsale(crowdAddr, tokenAddr); 
            await crowdsaleSt.setCrowdsaleActive(2);
            await crowdsaleSt.setCrowdsaleEnded(2);
            // on ended
            await crowdsaleSt.setCrowdsaleActive(2).should.be.rejected;
        })
    })

    makeSuite('setCrowdsaleEnded(uint256 _crowdsaleId) onlyCEO:', async function() {
        it('should be rejected with waiting crowdsale', async function () {
            await crowdsaleSt.addCrowdsale(0x0, 0x0); 
            await crowdsaleSt.setCrowdsaleEnded(1).should.be.rejected;
        })
        it('should be passed on current active and default the id', async function () {
            await crowdsaleSt.addCrowdsale(0x0, 0x0); 
            await crowdsaleSt.setCrowdsaleActive(1);
            await crowdsaleSt.setCrowdsaleEnded(1);
            let indxAct = await crowdsaleSt.activeCrowdsaleId();
            indxAct.should.be.bignumber.equal(0);
        })
    })

    makeSuite('getCrowdsaleToken()_getCrowdsaleAddress():', async function() {
        it('should both return 0x0 by default', async function () {
            let zero = "0x0000000000000000000000000000000000000000";
            let t = await crowdsaleSt.getCrowdsaleToken();
            let a = await crowdsaleSt.getCrowdsaleAddress();

            t.should.be.equal(zero);
            a.should.be.equal(zero);
        })
    })


    makeSuite('isCrowdsaleFinished(uint256 _crowdsaleId):', async function() {
        it('should both return false by default', async function () {
            let t = await crowdsaleSt.isCrowdsaleFinished(0);
            t.should.be.equal(false);
        })
        it('should be rejected for incorrect value', async function () {
            await crowdsaleSt.isCrowdsaleFinished(2).should.be.rejected;
        })
            
    })
})