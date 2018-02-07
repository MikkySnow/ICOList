












# BusinessLogic

### Contract for business logic

All users interaction works via this contract

## Functions



### Constant functions

#### CONTRIBUTE_FEE




##### Inputs

empty list


##### Returns

|#  |Param|Type|TypeHint|Description|
|---|-----|----|--------|-----------|
|0|return0|uint256||CONTRIBUTE_FEE|


#### paused




##### Inputs

empty list


##### Returns

|#  |Param|Type|TypeHint|Description|
|---|-----|----|--------|-----------|
|0|return0|bool||paused|






### State changing functions

#### addAdmin

If function calls first time, it creates proposal of adding new admin
If function calls multiple times with the same newAdmin param, it votes fornewAdmin adding. If number of votes for one admin is 2 or more, it executes andadding new admin.

##### Inputs

|#  |Param|Type|TypeHint|Description|
|---|-----|----|--------|-----------|
|0|newAdmin|address||            Address of new admin|


#### claimTokens

Function connects to token contract and gets how much tokens contract
bought by calling balanceOf(this). After that we count how much tokenswe should send to user according to the amount he invested. Tokens will be sent bytransfer(address, amount) functions, which containt either in ERC20 and ERC223

##### Inputs

|#  |Param|Type|TypeHint|Description|
|---|-----|----|--------|-----------|
|0|crowdsaleId|uint256|||


#### contribute

User ether sends to MoneyVault contract, admin fees
FUNCTIONSContributing of crowdsale takes some fees.sends to AdminMoneyVault contract

##### Inputs

empty list


#### isAdmin




##### Inputs

|#  |Param|Type|TypeHint|Description|
|---|-----|----|--------|-----------|
|0|_address|address||            Address of possible admin|


#### 

Overrides disallowing function to receive ether. To
implement logic of contributing calls contribute()

##### Inputs

empty list


#### pause

called by the owner to pause, triggers stopped state


##### Inputs

empty list


#### removeAdmin

If admins count less than 3 it can be called by 1 admin


##### Inputs

|#  |Param|Type|TypeHint|Description|
|---|-----|----|--------|-----------|
|0|adminAddress|address||        Address of existing admin|


#### setAdminMoneyVaultAddress

Can be called when contract is paused only by 2 or more admins
if adminCount more than 1 and by 1 admin if adminCount is 1.

##### Inputs

|#  |Param|Type|TypeHint|Description|
|---|-----|----|--------|-----------|
|0|_address|address||        New address of AdminMoneyVault contract|


#### setCrowdsaleStorageAddress

Can be called when contract is paused only by 2 or more admins
if adminCount more than 1 and by 1 admin if adminCount is 1.

##### Inputs

|#  |Param|Type|TypeHint|Description|
|---|-----|----|--------|-----------|
|0|_address|address||        New address of CrowdsaleStorage contract|


#### setMoneyVaultAddress

Can be called when contract is paused only by 2 or more admins
if adminCount more than 1 and by 1 admin if adminCount is 1.

##### Inputs

|#  |Param|Type|TypeHint|Description|
|---|-----|----|--------|-----------|
|0|_address|address||        New address of MoneyVault contract|


#### unpause

called by the owner to unpause, returns to normal state


##### Inputs

empty list






### Events

#### AdminWasAdded




##### Params

|#  |Param|Type|TypeHint|Description|
|---|-----|----|--------|-----------|
|0|newAdmin|address|||


#### AdminWasRemoved




##### Params

|#  |Param|Type|TypeHint|Description|
|---|-----|----|--------|-----------|
|0|removedAdmin|address|||


#### Pause




##### Params

empty list


#### Unpause




##### Params

empty list


#### NewMoneyVaultAddress




##### Params

|#  |Param|Type|TypeHint|Description|
|---|-----|----|--------|-----------|
|0|_address|address|||


#### NewCrowdsaleStorageAddress




##### Params

|#  |Param|Type|TypeHint|Description|
|---|-----|----|--------|-----------|
|0|_address|address|||


#### NewAdminMoneyVaultAddress




##### Params

|#  |Param|Type|TypeHint|Description|
|---|-----|----|--------|-----------|
|0|_address|address|||





### Enums




### Structs

#### Proposal




##### Params

|#  |Param|Type|TypeHint|Description|
|---|-----|----|--------|-----------|
|0|votes|address|||
|1|votesNumber|uint256|||




