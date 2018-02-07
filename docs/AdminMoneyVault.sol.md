












# AdminMoneyVault

### There stored all admins ether,

earned by taking fees. Only admins can use this contract

## Functions



### Constant functions

#### paused




##### Inputs

empty list


##### Returns

|#  |Param|Type|TypeHint|Description|
|---|-----|----|--------|-----------|
|0|return0|bool||paused|






### State changing functions

#### acceptWithdrawal

Money withdrawal starts when at least 3 admins signed


##### Inputs

|#  |Param|Type|TypeHint|Description|
|---|-----|----|--------|-----------|
|0|_amount|uint256||         Amount to withdraw|
|1|_address|address||        Address to withdraw|


#### addAdmin

If function calls first time, it creates proposal of adding new admin
If function calls multiple times with the same newAdmin param, it votes fornewAdmin adding. If number of votes for one admin is 2 or more, it executes andadding new admin.

##### Inputs

|#  |Param|Type|TypeHint|Description|
|---|-----|----|--------|-----------|
|0|newAdmin|address||            Address of new admin|


#### declineWithdrawal

Declines money withdrawal by decrementing votes for withdrawal proposal


##### Inputs

empty list


#### isAdmin

Checks that the address is an administrator


##### Inputs

|#  |Param|Type|TypeHint|Description|
|---|-----|----|--------|-----------|
|0|_address|address||            Address of possible admin|


#### 

Overridden function for accepting ether directly


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


#### MoneyWithdrawal




##### Params

|#  |Param|Type|TypeHint|Description|
|---|-----|----|--------|-----------|
|0|_amount|uint256|||
|1|_address|address|||





### Enums




### Structs

#### Proposal




##### Params

|#  |Param|Type|TypeHint|Description|
|---|-----|----|--------|-----------|
|0|votes|address|||
|1|votesNumber|uint256|||




