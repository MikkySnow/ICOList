// Import libraries we need
import { default as Web3} from 'web3';
import { default as contract } from 'truffle-contract';

// Import our contract artifacts and turn them to usable abstraction
import ManagementArtifacts from '../build/contracts/Management.json';

// Creates usable abstractions
const Management = contract(ManagementArtifacts);

let account;    // Stores user account between calls

window.App = {
    // Initializing function
    start: function () {
        Management.setProvider(web3.currentProvider);

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
     pause: function () {
        Management.deployed().then(function (instance) {
            instance.pause({from: account})
        }).catch(function (e) {
            console.log(e)
        })
    },

    unpause: function () {
        Management.deployed().then(function (instance) {
            instance.unpause({from: account})
        }).catch(function (e) {
            console.log(e)
        })
    },

    transferOwnership: function (_address) {
        Management.deployed().then(function (instance) {
            instance.transferOwnership(_address, {from: account})
        }).catch(function (e) {
            console.log(e)
        })
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
