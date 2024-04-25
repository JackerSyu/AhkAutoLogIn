#Include %A_ScriptDir%\ahk_lib\LogManager.ahk
#Include %A_ScriptDir%\ahk_lib\ReadFile.ahk
#Include %A_ScriptDir%\ahk_lib\ClickPicManager.ahk


global LIN_PROG_PATH := LoadConfig("LIN_PROG_PATH", A_ScriptDir "\config.txt") ; 主程式檔案
global LIN_START_PATH := LoadConfig("LIN_START_PATH", A_ScriptDir "\config.txt") ; 登入器檢查是否更新
global LIN_SERVER_PATH := LoadConfig("LIN_SERVER_PATH", A_ScriptDir "\config.txt") ; 選擇伺服器
global LIN_LOGIN_PATH := LoadConfig("LIN_LOGIN_PATH", A_ScriptDir "\config.txt") ; 輸入完密碼登入
global LIN_CONFIRM_PATH := LoadConfig("LIN_CONFIRM_PATH", A_ScriptDir "\config.txt") ; 輸入完密碼後系統跳出的確認
global LIN_CONFIRM_CHAR_PATH := LoadConfig("LIN_CONFIRM_CHAR_PATH", A_ScriptDir "\config.txt") ; 選擇好角色確認
global LIN_CHANGE_ROLE_PATH := LoadConfig("LIN_CHANGE_ROLE_PATH", A_ScriptDir "\config.txt") ; 點重新登入
global LIN_EXIT_PATH := LoadConfig("LIN_EXIT_PATH", A_ScriptDir "\config.txt") ; 點離開
global LIN_ACCOUNT_PATH := LoadConfig("LIN_ACCOUNT_PATH", A_ScriptDir "\config.txt") ; 執行的帳號
global LIN_ACCOUNT_LIST_PATH := LoadConfig("LIN_ACCOUNT_LIST_PATH", A_ScriptDir "\config.txt") ; 所有帳號存放區
global LIN_BAG_PATH := LoadConfig("LIN_BAG_PATH", A_ScriptDir "\config.txt") ; bag
global LIN_BAG_ITEM_PATH := LoadConfig("LIN_BAG_ITEM_PATH", A_ScriptDir "\config.txt") ; bag
global LIN_TELEPORT_SCROLL_PATH := LoadConfig("LIN_TELEPORT_SCROLL_PATH", A_ScriptDir "\config.txt") ; blessed teleport scroll
global LIN_STORE_ITEMS_PATH := LoadConfig("LIN_STORE_ITEMS_PATH", A_ScriptDir "\config.txt") ; sell 
global LIN_GET_ITEMS_PATH := LoadConfig("LIN_GET_ITEMS_PATH", A_ScriptDir "\config.txt") ; get
global LIN_STORE_TEXT_PATH := LoadConfig("LIN_STORE_TEXT_PATH", A_ScriptDir "\config.txt") ; click
global LIN_STORE_TEXT2_PATH := LoadConfig("LIN_STORE_TEXT2_PATH", A_ScriptDir "\config.txt") ; click
global LIN_STORE_TEXT3_PATH := LoadConfig("LIN_STORE_TEXT3_PATH", A_ScriptDir "\config.txt") ; click
global LIN_STORE_CONFIRM_PATH := LoadConfig("LIN_STORE_CONFIRM_PATH", A_ScriptDir "\config.txt") ; save
global LIN_LACK_BAG_ACCOUNT_PATH := LoadConfig("LIN_LACK_BAG_ACCOUNT_PATH", A_ScriptDir "\config.txt") ; need buy bag
global LIN_ACCOUNT_DONE_SUCCESS_PATH := LoadConfig("LIN_ACCOUNT_DONE_SUCCESS_PATH", A_ScriptDir "\config.txt") ; success
global LIN_DEST_BAGMAN_PATH := LoadConfig("LIN_DEST_BAGMAN_PATH", A_ScriptDir "\config.txt") ; teleport to bagman
global LIN_DEST_BAGMAN2_PATH := LoadConfig("LIN_DEST_BAGMAN2_PATH", A_ScriptDir "\config.txt") ; teleport to bagman
global LIN_DEST_OUREA_PATH := LoadConfig("LIN_DEST_OUREA_PATH", A_ScriptDir "\config.txt") ; teleport to ourea
global LIN_DEST_OUREA2_PATH := LoadConfig("LIN_DEST_OUREA2_PATH", A_ScriptDir "\config.txt") ; teleport to ourea
global LIN_BUY_BAG_PATH := LoadConfig("LIN_BUY_BAG_PATH", A_ScriptDir "\config.txt") ; buybag

; 選角色的坐標
global ROLE_1_POS = [103, 188]
global ROLE_2_POS = [305, 188]
global ROLE_3_POS = [495, 188]
global ROLE_4_POS = [685, 188]

; 點擊重登畫面坐標
global EXIT_POS = [789, 584]

; 角色坐標陣列(之後切換多賬號可以當參數)
global ROLES_POS := [ROLE_1_POS, ROLE_2_POS, ROLE_3_POS, ROLE_4_POS]


; 只開啟第一個帳號 第一個角色
::cmd1::
Pause::
StartAccount(false, false, false)
Return

; 開袋子用, 上面所有的帳號角色都會跑過一變
::cmd2::
!Pause::
StartAccount(true, false, false)
Return

; 開袋子用+存入倉庫
::cmd3::
!PgUp::
StartAccount(true, true, false)
Return

; 開袋子用+存入倉庫
::cmd4::
!PgDn::
StartAccount(true, false, true)
Return




::cmdtest::
BuyBagProcess(false)
return

::cmdtel1::
teleportProcess(1)
return

::cmdtel2::
teleportProcess(2)
return

::cmdbagman::
talkToBagmanProcess()
return

::cmdbuy::
BuyBagProcess(false)
teleportProcess(1)
talkToBagmanProcess()
teleportProcess(2)
talkToTeleportWoman()
return

!numpad7::
StoreProcess()
Return

; 自動開啟天堂
StartAccount(isOpenBag, isStoreMode, isBuyMode){
    TODAY := A_YYYY A_MM A_DD
    openBagMode := isOpenBag
    WriteLog("Open Bag Mode: " openBagMode )
    WriteLog("Store Mode: " isStoreMode )
    accounts := ReadAccounts(LIN_ACCOUNT_PATH)

    if (isOpenBag = false)
    {
        totalAccountNum = 1
    }
    Else
    {
        ; 複製帳號清單到執行資料夾內
        CopyAccountToExec()
        accounts := ReadAccounts(LIN_ACCOUNT_PATH)
        totalAccountNum := accounts.Length()
    }
    

    accountIndex := 0
    Loop %totalAccountNum%
    {
        accountIndex++
        curAccount := accounts[accountIndex][1]
        curPassword := accounts[accountIndex][2]
        curFilePath := accounts[accountIndex][3]
        accountComplete := true
        WriteLog("Current Account: " curAccount )
        Run %LIN_PROG_PATH%
        sleep 1000
        send {Left}
        sleep 1000
        send {enter}
        sleep 3000
        if(!ClickPicture(LIN_START_PATH, 1, 1,true,true)) ; cannot bypass
            Return
        sleep 1000
        if(!ClickPicture(LIN_SERVER_PATH, 1, 1,true,true)) ; cannot bypass
            Return
        sleep 5000
        Send {Left} {Left} {Left} {Left} {Left} 
        sleep 2000
        Send %curAccount%
        sleep 1000
        Send {Down} 
        sleep 1000
        Send %curPassword%
        sleep 1000
        if(!ClickPicture(LIN_LOGIN_PATH, 1, 1,true,true)) ; cannot bypass
            Return
        sleep 2000
        if(!ClickPicture(LIN_CONFIRM_PATH, 1, 1,true,true)) ; cannot bypass
            Return
        sleep 2000
        ; 開始選角色流程
        totalRoles := ROLES_POS.Length()
        if(openBagMode = false)
        {
            totalRoles = 1
        }
        currentRole := 0
        Loop %totalRoles%, 
        {
            currentRole++
            hasBag := true
            pos_x := ROLES_POS[currentRole][1]
            pos_y := ROLES_POS[currentRole][2]
            ; Send, "now: " %pos_x% %pos_y%
            CoordMode,Mouse,"Screen"
            MouseClick, left, %pos_x%, %pos_y%, 1
            sleep 1000
            MouseClick, left, %pos_x%, %pos_y%, 1
            sleep 1000
            if(!ClickPicture(LIN_CONFIRM_CHAR_PATH, 1, 1,true,true)) ; cannot bypass
                Return
            sleep 2000
            if (currentRole = 1)
            {
                send {Home}
            }
            
            if (openBagMode == true)
            {
                sleep 2000
                if(!ClickPicture(LIN_BAG_PATH, 1, 1, true, false)) ; can bypass
                {
                    accountComplete := false
                    hasBag := false
                }   

                if(isBuyMode == true)
                {
                    if(!hasBag)
                    {
                        BuyBagProcess(hasBag)
                        teleportProcess(1)
                        talkToBagmanProcess()
                        teleportProcess(2)
                        talkToTeleportWoman()

                        if(!ClickPicture(LIN_BAG_PATH, 1, 1, true, false)) ; can bypass
                        {
                            accountComplete := false
                            hasBag := false
                        }
                        Else
                        {
                            accountComplete := true
                            hasBag := true
                        }
                    }
                }

                ; 袋子放在F9, 如果要開寶箱可以自己新增多個熱鍵, 按多次一點
                send {F9}
                sleep 2000
                ; add store process
                if (isStoreMode)
                {
                    StoreProcess()
                    Send, {esc} {esc} {esc}
                    WriteLog("Finish Store")
                    sleep, 500
                }
                    
                POS_X := EXIT_POS[1]
                POS_Y := EXIT_POS[2]
                MouseClick,left,%POS_X%,%POS_Y%,1
                sleep 2000
                if (currentRole < totalRoles)
                {
                    if(!ClickPicture(LIN_CHANGE_ROLE_PATH, 1, 1,true,true)) ; cannot by pass
                        Return
                }
                else
                {
                    ; 賬號結束
                    if(!ClickPicture(LIN_EXIT_PATH, 1, 1,true,true)) ; cannot bypass
                        Return
                    sleep 2000
                    MouseClick,left,%POS_X%,%POS_Y%,1
                }
                WriteLog("Finish Role Number: " currentRole)
                if(!hasBag)
                {
                    DestFolder := LIN_LACK_BAG_ACCOUNT_PATH "\" TODAY
                    WriteLog("Cannot find the bag: [" curAccount "]:" currentRole " => Copy to " DestFolder, "WARN")
                    if (FileExist(curFilePath)) {
                        If !FileExist(DestFolder) 
                            FileCreateDir, %DestFolder%
                        FileCopy, %curFilePath%, %DestFolder%
                    }
                    else
                    {
                        WriteLog("Cannot find the file: [" curFilePath "]:", "ERROR")
                    }
                }
            }
            sleep 2000
        }
        
        if(openBagMode == true && accountComplete == true)
        {
            DestFolder := LIN_ACCOUNT_DONE_SUCCESS_PATH "\" TODAY
            WriteLog("Account Process Success: " curAccount " => Move to " DestFolder)
            if (FileExist(curFilePath)) {
                If !FileExist(DestFolder) 
                    FileCreateDir, %DestFolder%
                FileMove, %curFilePath%, %DestFolder%
            }
            else
            {
                WriteLog("Cannot find the file: [" curFilePath "]:", "ERROR")
            }
        }
        sleep 5000

    }
    WriteLog("Process End")
}

; 自動存入倉庫
StoreProcess()
{
    ; talk to storeman
    Send, {esc} {esc} {esc}
    WriteLog("click storeman")
    JierPos_X := 443
    JierPos_Y := 196
    ; move to storeman
    MouseClick,left,%JierPos_X%,%JierPos_Y%,1
    sleep 500
    MouseClick,left,%JierPos_X%,%JierPos_Y%,1
    sleep 500
    MouseClick,left,%JierPos_X%,%JierPos_Y%,1
    
    sleep 3000
    MouseMove, 100, 200, 0 
    Loop 7 
    {
        send, {WheelDown}
    }
    ; click store
    sleep 500
    if(!ClickPicture(LIN_STORE_TEXT_PATH, 1, 1,true,false)) ; cannot bypass
        Return
    sleep 500
    if(!ClickPicture(LIN_STORE_TEXT2_PATH, 1, 1,true,false)) ; cannot bypass
        Return
    Images := ReadPic(LIN_STORE_ITEMS_PATH)
    scrollCount := 0
    MouseClick,left,109,164,1
    MouseMove, 109,164,1
    sleep 500
    Loop {
        found := false  
        for index, imagePath in Images {
            if (ClickPicture(imagePath, 1, 1, true, false)) {
                sleep, 200
                send, {Ctrl Up} 
                send, {1} {1} {1} {1} {1}
                found := true  
            }
        }
        if (found = false) {
            
            Loop 7 {
                send, {WheelDown}
                scrollCount++
                
            }
        sleep, 100
        }
        if (scrollCount >= 70)
            break
    }
    sleep 1500
    ; save btn 
    if(!ClickPicture(LIN_STORE_CONFIRM_PATH, 1, 1,true,true)) ; cannot bypass
        Return
    Else
        WriteLog("Save success")
    sleep 1000
}

; 自動購買袋子 
BuyBagProcess(hasBag)
{
    WriteLog("The charactor has found Bag:" hasBag)
    if(hasBag)
    {
        return 
    }
        
    ; talk to storeman (get adena and blessed scroll of teleportation)
    ; talk to storeman
    Send, {esc} {esc} {esc}
    WriteLog("click storeman")
    JierPos_X := 443
    JierPos_Y := 196
    ; move to storeman
    MouseClick,left,%JierPos_X%,%JierPos_Y%,1
    sleep 500
    MouseClick,left,%JierPos_X%,%JierPos_Y%,1
    sleep 500
    MouseClick,left,%JierPos_X%,%JierPos_Y%,1
    
    sleep 3000
    MouseMove, 100, 200, 0 
    Loop 7 
    {
        send, {WheelDown}
    }
    ; click store
    sleep 500
    if(!ClickPicture(LIN_STORE_TEXT_PATH, 1, 1,true,false)) ; cannot bypass
        Return
    sleep 500
    if(!ClickPicture(LIN_STORE_TEXT3_PATH, 1, 1,true,false)) ; cannot bypass
        Return
    Images := ReadPic(LIN_GET_ITEMS_PATH)
    scrollCount := 0
    MouseClick,left,109,164,1
    MouseMove, 109,164,1
    sleep 500
    Loop {
        found := false  
        for index, imagePath in Images {
            if (ClickPicture(imagePath, 1, 1, true, false)) {
                sleep, 200
                send, {Ctrl Up} 
                if(index = 1)
                    send, {1} {0} {0} {0} {0} {0}
                else 
                    send, {2}
                found := true  
                WriteLog("found:" found)
            }
        }
        if (found = false) {
            
            Loop 7 {
                send, {WheelDown}
                scrollCount++
                
            }
        sleep, 100
        }
        if (scrollCount >= 70)
            break
    }
    sleep 1500
    ; save btn 
    if(!ClickPicture(LIN_STORE_CONFIRM_PATH, 1, 1,true,true)) ; cannot bypass
        Return
    Else
        WriteLog("get adena and teleport scroll success")
    sleep 1000
    ; teleport to bagman
    WriteLog("start to teleport process..")
    ; teleportProcess(1)
    ; talk to bagman
    ; teleport to orea
    ; walk back to storeman
}

teleportProcess(destination)
{
    ; @destination => 1=bagman, 2=ourea
    dest := ""
    if(destination = 1)
        dest := "bagman"
    else if(destination = 2)
        dest := "ourea"
    WriteLog("Dest:" dest)
  
    send, {esc}
    sleep 100
    send, {Tab}
    sleep 1000
    MouseMove, 715,126,1
    sleep 100
    ; scroll to top 
    Loop 40 {
        send, {WheelUp}
    }
    sleep 500
    ; looking for the scroll teleport
    Loop {
        found := false  
        sleep 100
        pos_teleport := GetPicturePosition(LIN_TELEPORT_SCROLL_PATH)

        if %pos_teleport% {
            posX:=pos_teleport[1]
            posY:=pos_teleport[2]  
            MouseClick,left,%posX%,%posY%,1
            sleep 200
            MouseClick,left,%posX%,%posY%,1
            sleep 200
            MouseClick,left,%posX%,%posY%,1
            sleep 800
            found := true  

            ; MouseMove, %posX%,%posY%, 10
            ; sleep 200
            ; Send {LButton DOWN}
            ; sleep 800
            ; MouseMove, 707,540, 10
            ; sleep 800
            ; Send {LButton UP}

            ; ;防止沒放到
            ; MouseMove, %posX%,%posY%, 10
            ; sleep 200
            ; Send {LButton DOWN}
            ; sleep 800
            ; MouseMove, 707,540, 10
            ; sleep 800
            ; Send {LButton UP}
            
        }

        if (found == 0) {
            Loop 7 {
                send, {WheelDown}
                scrollCount++
            }
            sleep, 100
        }
        Else ; if found break;
            break

        if (scrollCount >= 70)
        {
            if(found == 0)
            {
                WriteLog("Cannot find the teleport scroll in item bag..")
                return false
            }
            break
        }
            
    }
    sleep 1000

    posToX := 0
    posToY := 0

    if(destination = 1)
    {
        posToX := 66
        posToY := 64
    }

    if(destination = 2)
    {
        posToX := 64
        posToY := 51
    }

    ClickPosition(posToX, posToY)
    sleep 200
    ClickPosition(posToX, posToY)
}

talkToBagmanProcess()
{
    send, {esc} {esc}
    WriteLog("click bagman")
    sleep 500
    BagmanPos_X := 426
    BagmanPos_Y := 153
    ; move to storeman
    ClickPosition(BagmanPos_X, BagmanPos_Y)
    sleep 500
    ClickPosition(BagmanPos_X, BagmanPos_Y)
    sleep 500
    ClickPosition(BagmanPos_X, BagmanPos_Y)
    sleep 1000
    ; click store
    sleep 500
    Page_1_Pos_X := 78
    Page_1_Pos_Y := 231
    ClickPosition(Page_1_Pos_X, Page_1_Pos_Y)
    sleep 500
    MouseMove, 100, 200, 0 
    sleep 500
    Loop 5
    {
        send, {WheelDown}
    }
    sleep 500
    if(!ClickPicture(LIN_BUY_BAG_PATH, 1, 1,true,false)) ; cannot bypass
    {
        WriteLog("cannot find" LIN_BUY_BAG_PATH)
        Return
    }
        
    sleep 200
    send, {esc} {esc}

     sleep 500
    MouseMove, 715,126,1
    sleep 100
    send, {tab}

    Loop 40 {
        send, {WheelUp}
    }

    ; looking for the bag
    Loop {
        found := false  
        sleep 100
        pos_bag := GetPicturePosition(LIN_BAG_ITEM_PATH)

        if %pos_bag% {
            posX:=pos_bag[1]
            posY:=pos_bag[2]  
            MouseClick,left,%posX%,%posY%,1
            sleep 200
            MouseClick,left,%posX%,%posY%,1
            sleep 200
            MouseClick,left,%posX%,%posY%,1
            sleep 800
            found := true  

            MouseMove, %posX%,%posY%, 10
            sleep 200
            Send {LButton DOWN}
            sleep 800
            MouseMove, 673,548, 10
            sleep 800
            Send {LButton UP}

            ;防止沒放到
            MouseMove, %posX%,%posY%, 10
            sleep 200
            Send {LButton DOWN}
            sleep 800
            MouseMove, 673,548, 10
            sleep 800
            Send {LButton UP}
        }

        if (found == 0) {
            Loop 7 {
                send, {WheelDown}
                scrollCount++
            }
            sleep, 100
        }
        Else ; if found break;
            break

        if (scrollCount >= 70)
        {
            if(found == 0)
            {
                WriteLog("Cannot find the bag in item bag..")
                return false
            }
            break
        }
            
    }

    sleep 200
    send, {esc} {esc}

}

talkToTeleportWoman()
{
    sleep 500
    
    TeleportWomanPos_X := 385
    TeleportWomanPos_Y := 77
    ClickPosition(TeleportWomanPos_X, TeleportWomanPos_Y)
    sleep 1000
    TeleportPos_Page1_X := 61
    TeleportPos_Page1_Y := 134

    ClickPosition(TeleportPos_Page1_X, TeleportPos_Page1_Y)
    sleep 300
    TeleportPos_Page2_X := 77
    TeleportPos_Page2_Y := 180
    ClickPosition(TeleportPos_Page2_X, TeleportPos_Page2_Y)
    sleep 500
    JierPos_X := 581
    JierPos_Y := 262
    ClickPosition(JierPos_X, JierPos_Y)
    sleep 100
    ClickPosition(JierPos_X, JierPos_Y)
    sleep 3000
    send, {esc}
}

CopyAccountToExec()
{
    MsgBox, 4,, Do you want to start copy files process?

    ifMsgBox Yes
    {
        global LIN_ACCOUNT_PATH  
        SourceFolder := LoadConfig("LIN_ACCOUNT_LIST_PATH", A_ScriptDir "\config.txt") 
        If (FileExist(SourceFolder))
        {
            Loop, %SourceFolder%\*.txt
            {
                FileName := A_LoopFileName
                FileCopy, % SourceFolder "\" FileName, % LIN_ACCOUNT_PATH "\" FileName, 1
                If (ErrorLevel != 0)
                {
                    WriteLog(FileName "copy to " SourceFolder " failed")
                }
            }
        }
        Else
        {
            WriteLog(SourceFolder "Not Exists")
        }
    }
    return
}




!numpad0::
Send, /bookmark \fY[其他] 袋子
Return


!numpad1::
Send, /bookmark \fY[其他] 歐瑞
Return


::vvolumeup::
SendInput, {Volume_Up}
Return

::mmute::
SendInput, {Volume_Mute}
Return


XButton1::
Send, {F7}
Return


XButton2::
Send, {F8}
Return