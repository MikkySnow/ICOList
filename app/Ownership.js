// Import libraries we need
import { default as Web3} from 'web3';
import { default as contract } from 'truffle-contract';

// Import our contract artifacts and turn them to usable abstraction
import OwnershipArtifacts from '../build/contracts/Ownership.json';

// Creates usable abstractions
const Ownership = contract(OwnershipArtifacts);

let account;    // Stores user account between calls

window.App = {
    // Initializing function
    start: function () {
        Ownership.setProvider(web3.currentProvider);

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
    // Sets address of CFO
    setCFO: function (address) {
        console.log("Trying to add new CFO");
        Ownership.deployed().then(function (instance) {
            instance.setCFO(address, {from: account})
        }).then(function () {
            console.log("New CFO was added");
        }).catch(function (e) {
            console.log(e);
            console.log("Error while adding")
        })
    },
    setAdmin: function (address) {
        console.log("Trying to set new admin");
        Ownership.deployed().then(function (instance) {
            instance.setAdmin(address, {from: account})
        }).then(function () {
            console.log("Admin was added");
        }).catch(function (e) {
            console.log(e);
            console.log("Error while adding")
        })
    },
    removeCFO: function () {
        console.log("Trying to remove CFO");
        Ownership.deployed().then(function (instance) {
            instance.removeCFO(address, {from: account})
        }).then(function () {
            console.log("CFO was removed");
        }).catch(function (e) {
            console.log(e);
            console.log("Error while removing")
        })
    },
    removeAdmin: function() {
        console.log("Trying to remove admin");
        Ownership.deployed().then(function (instance) {
            instance.removeAdmin(address, {from: account})
        }).then(function () {
            console.log("Admin was removed");
        }).catch(function (e) {
            console.log(e);
            console.log("Error while removing")
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
