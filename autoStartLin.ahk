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
global LIN_BAG_PATH := LoadConfig("LIN_BAG_PATH", A_ScriptDir "\config.txt") ; bag
global LIN_STORE_ITEMS_PATH := LoadConfig("LIN_STORE_ITEMS_PATH", A_ScriptDir "\config.txt") ; sell 
global LIN_STORE_TEXT_PATH := LoadConfig("LIN_STORE_TEXT_PATH", A_ScriptDir "\config.txt") ; click
global LIN_STORE_TEXT2_PATH := LoadConfig("LIN_STORE_TEXT2_PATH", A_ScriptDir "\config.txt") ; click
global LIN_STORE_CONFIRM_PATH := LoadConfig("LIN_STORE_CONFIRM_PATH", A_ScriptDir "\config.txt") ; save

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
StartAccount(false, false)
Return

; 開袋子用, 上面所有的帳號角色都會跑過一變
::cmd2::
!Pause::
StartAccount(true, true)
Return

StartAccount(isOpenBag, isStoreMode){
    openBagMode := isOpenBag
    WriteLog("Open Bag Mode: " openBagMode )
    WriteLog("Store Mode: " isStoreMode )
    accounts := ReadAccounts(LIN_ACCOUNT_PATH)
    totalAccountNum := accounts.Length()

    if (isOpenBag = false)
    {
        totalAccountNum = 1
    }

    accountIndex := 0
    Loop %totalAccountNum%
    {
        accountIndex++
        curAccount := accounts[accountIndex][1]
        curPassword := accounts[accountIndex][2]
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
            
            if (openBagMode = true)
            {
                sleep 2000
                if(!ClickPicture(LIN_BAG_PATH, 1, 1, true, false)) ; can bypass
                {
                    WriteLog("Cannot find the bag:" curAccount currentRole, "WARN")
                    accountComplete := false
                    hasBag := false
                }   
                ; 袋子放在F9, 如果要開寶箱可以自己新增多個熱鍵, 按多次一點
                send {F9}
                sleep 2000
                ; add store process
                if (isStoreMode)
                    StoreProcess()
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
            }
            WriteLog("Finish Role Number: " currentRole)
            if(!hasBag)
                WriteLog("Cannot find the bag: [" curAccount "]:" currentRole, "WARN")
            sleep 2000
        }
        WriteLog("Account Process Success: " curAccount)
        sleep 5000
    }
    WriteLog("Process End")
}


StoreProcess()
{
    ; talk to storeman
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
    if(!ClickPicture(LIN_STORE_TEXT_PATH, 1, 1,true,true)) ; cannot bypass
        Return
    if(!ClickPicture(LIN_STORE_TEXT2_PATH, 1, 1,true,true)) ; cannot bypass
        Return
    Images := ["C:\pic\equip1.PNG", "C:\pic\equip2.PNG", "C:\pic\equip3.PNG", "C:\pic\equip4.PNG", "C:\pic\equip5.PNG", "C:\pic\equip6.PNG"]
    scrollCount := 0
    Loop {
        found := false  ; 标记是否找到了图片
        ; 遍历所有图像路径
        for index, imagePath in Images {
            if (ClickPicture(imagePath, 1, 1, true, false)) {
                ; 图像找到并点击成功
                sleep, 200
                send, {Ctrl Up} ; 释放 Ctrl 键
                send, {9999}
                found := true  ; 标记找到图片
                WriteLog("found item:" imagePath)
            }
        }

        if (found = false) {
            ; 图像未找到，滚动下移7次为一组，每组之间停顿1秒
            Loop 7 {
                send, {WheelDown}
                scrollCount++
                
            }
	    sleep, 100
        }
	

        ; 如果滚动总数超过50次，则跳出循环
        if (scrollCount >= 50)
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