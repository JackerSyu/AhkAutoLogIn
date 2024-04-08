# AhkAutoLogIn
Using Autohotkey to do some automotic process in Lineage Game. 
Include: 
1. Log in game automatically. 
   - Open game 
   - Input account info
   - Select role
   - Click certain picture
   - Check bag is exist
   - Exit game 
   - Repeat...(Scan the role_accounts folder until end.)
2. Sell equipments to vendor automatically in game.
3. Bookmark location in game



# Environment 
- Operating system: Windows 7
- Autohotkey version : 1.1
- Game solution : 800 * 600


# Usage 
1. Download
2. Put "ahk_lib" to your Lineage Folder
3. Put "autoStartLin.ahk" to your Lineage Folder
4. Create a config.txt (the format could reference mine (config.txt))
5. Create a pic folder (if you need the pngs, you can send me a request, or you could make your own by screen shot)
6. Create a store folder in your pic folder (to store items)
7. Create a role_account, new account info in txt (the first line = account, second line = pwd)
<span style="font-size: 10px; color: gray">if you want to start store items process, you may need .spr(變身檔) to highlight the NPC(storeman) location </span>




## Update History
- 2024-04-07 Add features: Confirm Msgbox selecting copy files to exec folder or not
- 2024-04-04 Add features: Copy files to execute folder after starting the process
- 2024-03-27 Add features: Move to specific folder after finishing the process.
- 2024-03-25 Add features: Implement a mechanism for storing items in storeman.