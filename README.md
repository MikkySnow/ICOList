#PooledFund

# Installation

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