// Import libraries we need
import { default as Web3} from 'web3';
import { default as contract } from 'truffle-contract';

// Import our contract artifacts and turn them to usable abstraction
import BusinessLogicArtifacts from '../build/contracts/BusinessLogic.json';

// Creates usable abstractions
const BusinessLogic = contract(BusinessLogicArtifacts);

let account;    // Stores user account between calls

window.App = {
    // Initializing function
    start: function () {
        BusinessLogic.setProvider(web3.currentProvider);

        // Get the initial account balance so it can be displayed.
        web3.eth.getAccounts(function(err, accs) {
            if (err !== null) {
                alert('Log in your MetaMask account')
                return
            }

            if (accs.length === 0) {
                alert('Cannot get accounts from MetaMask')
                return
            }
            account = accs[0]
        })
    },

    setCrowdsaleStorage: function (address) {
        BusinessLogic.deployed().then(function (instance) {
            instance.setCrowdsaleStorage(address, {from: account})
        }).catch(function (e) {
            console.log(e)
        })
    },

    setAdminMoneyVault: function (address) {
        BusinessLogic.deployed().then(function (instance) {
            instance.setAdminMoneyVault(address, {from: account})
        }).catch(function (e) {
            console.log(e)
        })
    },

    pause: function () {
        BusinessLogic.deployed().then(function (instance) {
            instance.pause({from: account});
        }).catch(function (e) {
            console.log(e)
        })
    },

    unpause: function () {
        BusinessLogic.deployed().then(function (instance) {
            instance.unpause({from: account})
        }).catch(function (e) {
            console.log(e)
        })
    },

    setFees: function (amount) {
        BusinessLogic.deployed().then(function (instance) {
            instance.setFee(amount)
        }).catch(function (e) {
            console.log(e)
        })
    },

    claimTokens: function (crowdsaleID) {
    	BusinessLogic.deployed().then(function (instance) {
    		instance.claimTokens(crowdsaleID)
    	}).catch(function (e) {
    		console.log(e)
    	})
    },

    buyTokens: function () {
    	BusinessLogic.deployed.then(i=>i.buyTokens({from: account}))
    		.catch(e=>{console.log(e)})
    },

    contribute: function (amount) {
    	BusinessLogic.deployed().then(i=>i.contribute({from: account, value: amount}))
    	.catch(e=>{console.log(e)})
    }
};

window.addEventListener('load', function () {
    // Checking if Web3 has been injected by the browser (Mist/MetaMask)
    if (typeof web3 !== 'undefined') {
        window.web3 = new Web3(web3.currentProvider)
    } else {
        alert('You should download MetaMask/Mist for security reasons')
    }

    App.start()
});
