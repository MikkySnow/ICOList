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


##### Testing and installation

1. Install [truffle](http://truffleframework.com) globally with `npm install -g truffle`
2. Install local packages with `npm install`

Then you can test it with:

1. Setup truffle rpc with `truffle develop`
2. Run tests with `truffle test`

Or deploy it manually:

1. Install [testrpc](https://github.com/ethereumjs/testrpc) globally with `npm install -g ethereumjs-testrpc`
2. Run testrpc in separate terminal `testrpc -l 600000000000000`
3. Copy one of private keys from testrpc console to truffle.js
4. Run tests with `truffle test`


On macOS you also need to install watchman: `brew install watchman`