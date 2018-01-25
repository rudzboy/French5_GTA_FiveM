# Simple Banking

Simple banking is a lua script that allows you to include a banking system in your server. This system uses
EssentialMod cash, and a seperate bank balance column in the database, to allow the player to seperate 'on-character'
cash from that stored safely away!

Some ATMs or Banks may be missing. Alert me to them and I'll add them asap.

##### Requires EssentialMod

### Features
  - Full GUI system
  - UI to show bank balance
  - Stores bank cash seperately
  - Limit giving cash to nearby player
  - 69 ATM Locations
  - 7 Bank Locations
  - Withdraw cash from ATM
  - Withdraw cash from bank
  - Deposit cash at bank
  - Transfer to another persons bank account
  - Check available balance
  - Customisable Settings


### Install
  - Download simple banking
  - Put 'banking' folder into your servers 'resources' folder
  - Add '- banking' to AutoStartResources in citmp-server.yml
  - Import 'db.sql' into EssentialMod database
  - Change database settings on line 2 of server.lua
  - Change options in client.lua file to meet your needs
  - Start / Restart server

### GUI Usage
Press the Context Action key (Default: E) when near an ATM or in a bank.

### Command Usage
#### /checkbalance
Example: /checkbalance


Returns the players current account balance. ***By default can be used anywhere (like using a mobile app)***

#### /withdraw [amount]
Example: /withdraw 50


Withdraws the specified amount from the players bank account. ***By default can only be used at ATMs or
banks.***
#### /deposit [amount]
Example: /deposit 50


Deposits the specified amount from the players bank account. ***By default can only be used inside banks.***
#### /transfer [id] [amount]
Example: /transfer 17 2000


Transfers money from the players bank account to the recipients bank account. ***By default can be used anywhere
(like using a mobile app)***
#### /givecash [id] [amount]
Example: /givecash 17 20


Transfers money from the players ***wallet*** to the recipients wallet. ***By default can be used anywhere
as long as the recipient is within 5 Meters***

### Settings
All settings are customisable in the client.lua file.
##### depositAtATM (Default: false)
Allows the player to deposit cash at ATMs. By default cash can only deposited in store at one of
the six bank locations.
##### giveCashAnywhere (Default: false)
Allows the player to give cash no matter how far away the other player is. By default the recipient
has to be nearby (5 Meters). This behaves similar to the bank transfer but for 'on-character' cash.
##### withdrawAnywhere (Default: false)
Allows the player to withdraw cash no matter where they are. By default the player can only withdraw
cash from ATMs or in Banks.
##### depositAnywhere (Default: false)
Similar to the withdrawAnywhere setting. This option allows players to deposit cash into their bank
account from anywhere. By default the player must be in 1 of the 6 bank stores.
##### displayBankBlips (Default: true)
Displays the locations of banks on the map. Default to show markers on map.
##### displayAtmBlips (Default: false)
Displays the locations of atms on the map. Default to hide markers on map. I do not recommend using this
option it is very ugly and clutters the map. Some icons overlap because some locations have more than one atm.
##### enableBankingGui (Default: true)
Enables the GUI system for banks and ATMs. SET THIS TO FALSE IF YOU ARE HAVING ISSUES WITH THE GUI. CHAT COMMANDS
STILL WORK.

#### Note
For 2.0 I suggest a complete re-install of simple banking. (Apart from the SQL bit, that hasn't changed.)


#### Upcoming
  - Multiple Personal Accounts
  - Savings Accounts (With Interest)
  - Business Accounts
  - Shared Accounts (Couples, Spouses, etc.)
