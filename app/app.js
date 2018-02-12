// Import libraries we need
import { default as Web3} from 'web3';
import { default as contract } from 'truffle-contract';

// Import our contract artifacts and turn them to usable abstraction
import CrowdsaleStorageArtifacts from '../build/contracts/CrowdsaleStorage.json';
import AdminMoneyVaultArtifacts from '../build/contracts/AdminMoneyVault.json';
import BusinessLogicArtifacts from '../build/contracts/BusinessLogic.json';
import ManagementArtifacts from '../build/contracts/Management.json';
import OwnershipArtifacts from '../build/contracts/Ownership.json';

// Creates usable abstractions
const CrowdsaleStorage = contract(CrowdsaleStorageArtifacts);
const AdminMoneyVault = contract(AdminMoneyVaultArtifacts);
const BusinessLogic = contract(BusinessLogicArtifacts);
const Management = contract(ManagementArtifacts);
const Ownership = contract(OwnershipArtifacts);

let account;    // Stores user account between calls

window.App = {
    start: function () {
        CrowdsaleStorage.setProvider(web3.currentProvider);
        AdminMoneyVault.setProvider(web3.currentProvider);
        BusinessLogic.setProvider(web3.currentProvider);
        Management.setProvider(web3.currentProvider);
        Ownership.setProvider(web3.currentProvider);


    }
}
