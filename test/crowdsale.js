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

const Crowdsale = artifacts.require('./Crowdsale.sol');

contract('Crowdsale', function ([_, wallet, wallet2, wallet3]) {

    var crowdsale;
    var management;
    var ownership;
    var token;
    var startTime;
    // TODO: find out why mock is cannot be loaded
    function makeSuite(name, tests) {
        describe(name, async function () {
            before(async function () {
                await advanceBlock();
                startTime = latestTime() + duration.minutes(1);
                // msg.sender is admin
                crowdsale = await Crowdsale.new("0x1", 10, 60, 10000, "0x2");
                await increaseTimeTo(startTime);
            });
            tests();
        });
    }

    makeSuite('checkGoalReached() afterDeadline:', async function() {
        it('should be passed but dont change crowdsale state', async function () {
            await crowdsale.checkGoalReached();
            let isFundReach = await crowdsale.fundingGoalReached();
            let isCrowdsaleClosed = await crowdsale.crowdsaleClosed();
            isFundReach.should.be.equal(false);
            isCrowdsaleClosed.should.be.equal(false);
        })
        it('should be passed and set crowdsale to closed', async function () {
            // deadline = now
            let crowdsaleAlreadyEnded = await Crowdsale.new("0x1", 10, 0, 10000, "0x2");
            await crowdsaleAlreadyEnded.checkGoalReached();
            let isFundReach = await crowdsaleAlreadyEnded.fundingGoalReached();
            let isCrowdsaleClosed = await crowdsaleAlreadyEnded.crowdsaleClosed();
            isFundReach.should.be.equal(false);
            isCrowdsaleClosed.should.be.equal(true);
        })
        it('should be passed and set crowdsale to closed and reached', async function () {
            // deadline = now and goal = 0
            let crowdsaleAlreadyEnded = await Crowdsale.new("0x1", 0, 0, 10000, "0x2");
            await crowdsaleAlreadyEnded.checkGoalReached();
            let isFundReach = await crowdsaleAlreadyEnded.fundingGoalReached();
            let isCrowdsaleClosed = await crowdsaleAlreadyEnded.crowdsaleClosed();
            isFundReach.should.be.equal(true);
            isCrowdsaleClosed.should.be.equal(true);
        })
    })
/*
    makeSuite('safeWithdrawal() afterDeadline:', async function() {
        
        it('withdrawal after sending', async function () {
            // todo: end it
            const value = ether(1);
            let crowdsaleAlreadyEnded = await Crowdsale.new("0x1", 10, 0, 10000, "0x2");
            //let moneyOne = wallet.value;
            //console.log("ThisTest contract address is " + moneyOne);
            await crowdsaleAlreadyEnded.transfer({from: wallet, value: value});
            await crowdsaleAlreadyEnded.safeWithdrawal({from: wallet, value: value})

            //let moneyTwo = wallet.value();
            //console.log("ThisTest contract address is " + moneyTwo);
            //moneyTwo.should.be.rejected;

            // deadline = now
            /*
            let crowdsaleAlreadyEnded = await Crowdsale.new("0x1", 10, 0, 10000, "0x2");
            await crowdsaleAlreadyEnded.checkGoalReached();
            let isFundReach = await crowdsaleAlreadyEnded.fundingGoalReached();
            let isCrowdsaleClosed = await crowdsaleAlreadyEnded.crowdsaleClosed();
            isFundReach.should.be.equal(false);
            isCrowdsaleClosed.should.be.equal(true);
            *//*
        })


    })
*/


})