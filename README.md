## Use case

##### Management contract
Try to add 3 admins
```
Management.deployed().then(i=>i.addNewAdmin.call(web3.eth.accounts[1]));
Management.deployed().then(i=>i.addNewAdmin.call(web3.eth.accounts[2]));
```

After that you shouldn't be able to add new admin only by yourself
```
Management.deployed().then(i=>i.addNewAdmin.call(web3.eth.accounts[3]));
```

You can add new admin only by multiple calls from different admins

```
Management.deployed().then(i=>i.addNewAdmin.call(web3.eth.accounts[3], {from: web3.eth.accounts[1]}));
Management.deployed().then(i=>i.addNewAdmin.call(web3.eth.accounts[3], {from: web3.eth.accounts[2]}));
Management.deployed().then(i=>i.addNewAdmin.call(web3.eth.accounts[3]));
```

You can remove admin by yourself

```
Management.deployed().then(i=>i.removeAdmin.call(web3.eth.accounts[3], {from: web3.eth.accounts[1]}));
Management.deployed().then(i=>i.removeAdmin.call(web3.eth.accounts[2], {from: web3.eth.accounts[2]}));
Management.deployed().then(i=>i.removeAdmin.call(web3.eth.accounts[1]));
```

But you cannot remove founder 

```
Management.deployed().then(i=>i.removeAdmin.call(web3.eth.accounts[0]));
```

##### Crowdsale Storage

At first you should deploy ERC20Crowdsale and ERC20Token contracts and
set it in addCrowdsale function
```
CrowdsaleStorage.addCrowdsale(crowdsaleAddress, tokenAddress)
```
