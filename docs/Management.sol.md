












# Management

### Contract that implements logic of management.



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


#### isAdmin




##### Inputs

|#  |Param|Type|TypeHint|Description|
|---|-----|----|--------|-----------|
|0|_address|address||            Address of possible admin|


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





### Enums




### Structs

#### Proposal




##### Params

|#  |Param|Type|TypeHint|Description|
|---|-----|----|--------|-----------|
|0|votes|address|||
|1|votesNumber|uint256|||




