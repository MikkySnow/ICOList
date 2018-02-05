import { default as Web3} from 'web3';
import { default as contract } from 'truffle-contract';

import CrowdsaleStorageArtifacts from '../build/contracts/CrowdsaleStorage.json';
import AdminMoneyVaultArtifacts from '../build/contracts/AdminMoneyVault.json';
import MoneyVaultArtifacts from '../build/contracts/MoneyVault.json';
import BusinessLogicArtifacts from '../build/contracts/BusinessLogic.json';
import ManagementArtifacts from '../build/contracts/Management.json';

// Creates usable abstractions
const CrowdsaleStorage = contract(CrowdsaleStorageArtifacts);
const AdminMoneyVault = contract(AdminMoneyVaultArtifacts);
const MoneyVault = contract(MoneyVaultArtifacts);
const BusinessLogic = contract(BusinessLogicArtifacts);
const Management = contract(ManagementArtifacts);

let account;    // Stores user account between calls

// Initialize accounts and check availability of Metamask
async function start() {
    CrowdsaleStorage.setProvider(web3.currentProvider);
    AdminMoneyVault.setProvider(web3.currentProvider);
    MoneyVault.setProvider(web3.currentProvider);
    BusinessLogic.setProvider(web3.currentProvider);
    Management.setProvider(web3.currentProvider);

    // Get the initial account
    web3.eth.getAccounts(function (err, accs) {
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

}
