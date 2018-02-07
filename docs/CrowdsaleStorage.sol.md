












# CrowdsaleStorage

### Storage contract for crowdsales.

By using storage we divide business logic and storage.In case of any bugs or exploits we can redeploy our contract for logic and keep data safe.Storage implement only create and retrieve functions

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

#### addAdmin

If function calls first time, it creates proposal of adding new admin
If function calls multiple times with the same newAdmin param, it votes fornewAdmin adding. If number of votes for one admin is 2 or more, it executes andadding new admin.

##### Inputs

|#  |Param|Type|TypeHint|Description|
|---|-----|----|--------|-----------|
|0|newAdmin|address||            Address of new admin|


#### addCrowdsale

Calls internal by Crowdsale fabric contract
FUNCTIONSin createCrowdsale() function

##### Inputs

|#  |Param|Type|TypeHint|Description|
|---|-----|----|--------|-----------|
|0|_crowdsaleAddress|address||           address of crowdsale contract|
|1|_tokenAddress|address||               address of token contract|


#### getCrowdsaleAddress

Returns crowdsale address of active crowdsale


##### Inputs

empty list


#### getCrowdsaleAddressById

Returns crowdsale address by its id


##### Inputs

|#  |Param|Type|TypeHint|Description|
|---|-----|----|--------|-----------|
|0|_crowdsaleId|uint256||           Crowdsale ID|


#### getCrowdsaleToken

Returns token address of active crowdsale


##### Inputs

empty list


#### getTokenAddressById

Returns crowdsale token address by its id


##### Inputs

|#  |Param|Type|TypeHint|Description|
|---|-----|----|--------|-----------|
|0|_crowdsaleId|uint256||           Crowdsale ID|


#### getWeiRaised




##### Inputs

|#  |Param|Type|TypeHint|Description|
|---|-----|----|--------|-----------|
|0|_crowdsaleId|uint256|||


#### isAdmin




##### Inputs

|#  |Param|Type|TypeHint|Description|
|---|-----|----|--------|-----------|
|0|_address|address||            Address of possible admin|


#### isCrowdsaleFinished




##### Inputs

|#  |Param|Type|TypeHint|Description|
|---|-----|----|--------|-----------|
|0|_crowdsaleId|uint256||           Crowdsale ID|


#### 

Disallows sending ether


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


#### setCrowdsaleActive

Uses internally by admin contract. Only admins can set it active


##### Inputs

|#  |Param|Type|TypeHint|Description|
|---|-----|----|--------|-----------|
|0|_crowdsaleId|uint256||        id of chosen crowdsale|


#### setCrowdsaleEnded

Sets crowdsale status to ended
Uses internally in finalization function or can be called by admin contract

##### Inputs

|#  |Param|Type|TypeHint|Description|
|---|-----|----|--------|-----------|
|0|_crowdsaleId|uint256||        id of chosen crowdsale|


#### setCrowdsaleToken

Can be called only by admins


##### Inputs

|#  |Param|Type|TypeHint|Description|
|---|-----|----|--------|-----------|
|0|_crowdsaleId|uint256||  ID of chosen crowdsale|
|1|_tokenAddress|address|||


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


#### CrowdsaleWasAdded




##### Params

|#  |Param|Type|TypeHint|Description|
|---|-----|----|--------|-----------|
|0|_crowdsaleAddress|address|||
|1|_tokenAddress|address|||


#### CrowdsaleBecameActive




##### Params

|#  |Param|Type|TypeHint|Description|
|---|-----|----|--------|-----------|
|0|_crowdsaleId|uint256|||


#### CrowdsaleWasEnded




##### Params

|#  |Param|Type|TypeHint|Description|
|---|-----|----|--------|-----------|
|0|_crowdsaleId|uint256|||





### Enums

#### CrowdsaleStatus




|#  |Member|Description|
|---|------|-----------|
|0|Waiting||
|1|Active||
|2|Ended||




### Structs

#### Proposal




##### Params

|#  |Param|Type|TypeHint|Description|
|---|-----|----|--------|-----------|
|0|votes|address|||
|1|votesNumber|uint256|||


#### CrowdsaleInfo




##### Params

|#  |Param|Type|TypeHint|Description|
|---|-----|----|--------|-----------|
|0|crowdsaleAddress|address|||
|1|tokenAddress|address|||
|2|status|CrowdsaleStatus|||
|3|weiRaised|uint256|||




