global LIN_PROG_PATH := "C:\Program Files\Gamania\悠風(Lineage 3.5C)\Login.exe" ;主程式檔案
global LIN_START_PATH := "C:\pic\start.PNG" ;登入器檢查是否更新
global LIN_SERVER_PATH := "C:\pic\server.PNG" ; 選擇伺服器
global LIN_LOGIN_PATH := "C:\pic\login.PNG" ;輸入完密碼登入
global LIN_CONFIRM_PATH := "C:\pic\confirm.PNG" ;輸入完密碼後系統跳出的確認
global LIN_CONFIRM_CHAR_PATH := "C:\pic\confirm2.PNG" ;選擇好角色確認
global LIN_CHANGE_ROLE_PATH := "C:\pic\change_role.PNG" ; 點重新登入
global LIN_EXIT_PATH := "C:\pic\exit.PNG" ; 點離開
global LIN_ACCOUNT_PATH := "C:\roles_account"

;選角色的坐標
global ROLE_1_POS = [103, 188]
global ROLE_2_POS = [305, 188]
global ROLE_3_POS = [495, 188]
global ROLE_4_POS = [685, 188]

;點擊重登畫面坐標
global EXIT_POS = [789, 584]

;角色坐標陣列(之後切換多賬號可以當參數)
global ROLES_POS := [ROLE_1_POS, ROLE_2_POS, ROLE_3_POS, ROLE_4_POS]


; 只開啟第一個帳號 第一個角色
::cmd1::
Pause::
StartAccount(false)
Return

; 開袋子用, 上面所有的帳號角色都會跑過一變
::cmd2::
!Pause::
StartAccount(true)
Return

StartAccount(isOpenBag){
    openBagMode := isOpenBag
    WriteLog("Open Bag Mode: " openBagMode )
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
        WriteLog("Current Account: " account )
        Run %LIN_PROG_PATH%
        sleep 1000
        send {Left}
        sleep 1000
        send {enter}
        sleep 3000
        if(!ClickPicture(LIN_START_PATH, 1, 1,true,true)) 
            Return
        if(!ClickPicture(LIN_SERVER_PATH, 1, 1,true,true)) 
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
        if(!ClickPicture(LIN_LOGIN_PATH, 1, 1,true,true)) 
            Return
        sleep 2000
        if(!ClickPicture(LIN_CONFIRM_PATH, 1, 1,true,true)) 
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
            pos_x := ROLES_POS[currentRole][1]
            pos_y := ROLES_POS[currentRole][2]
            ; Send, "now: " %pos_x% %pos_y%
            CoordMode,Mouse,"Screen"
            MouseClick, left, %pos_x%, %pos_y%, 1
            sleep 1000
            MouseClick, left, %pos_x%, %pos_y%, 1
            sleep 1000
            if(!ClickPicture(LIN_CONFIRM_CHAR_PATH, 1, 1,true,true))
                Return
            sleep 2000
            if (currentRole = 1)
            {
                send {Home}
            }
            
            if (openBagMode = true)
            {
                sleep 2000
                ; 袋子放在F9, 如果要開寶箱可以自己新增多個熱鍵, 按多次一點
                send {F9}
                sleep 2000
                POS_X := EXIT_POS[1]
                POS_Y := EXIT_POS[2]
                MouseClick,left,%POS_X%,%POS_Y%,1
                sleep 2000
                if (currentRole < totalRoles)
                {
                    if(!ClickPicture(LIN_CHANGE_ROLE_PATH, 1, 1,true,true))
                        Return
                }
                else
                {
                    ; 賬號結束
                    if(!ClickPicture(LIN_EXIT_PATH, 1, 1,true,true))
                        Return
                    sleep 2000
                    MouseClick,left,%POS_X%,%POS_Y%,1
                }
            }
            sleep 2000
        }
        sleep 5000
    }
}


#MaxThreadsPerHotkey 2

$!f1::

PressKey := ! PressKey

Loop
{
    If ! PressKey
        Break
    Send {f3 Down}
    Sleep 500
    Send {f3 Up}
    Sleep 500
    
}
Return





$!f2::

PressKey := ! PressKey

Loop
{
    If ! PressKey
        Break
    Send {f5 Down}
    Sleep 500
    Send {f5 Up}
    Sleep 1000
    Send {LButton Down}
    Sleep 500
    Send {LButton Up}
    Sleep 10000
    
}
Return

#MaxThreadsPerHotkey 1


ChangeEquip(X, Y){
    CoordMode,Mouse,"Screen"
    Loop 5 {
        MouseClick,left,%X%,%Y%,1
 Sleep 100
    }
    MouseClick,left,%X%,%Y%,1
    Sleep 100
}

;模擬滑鼠點擊圖片
ClickPicture(ImageFilePath,ClickCount:=1,Speed:=0,Return:=true,ShowError:=true){
    pos:=GetPicturePosition(ImageFilePath)
    if %pos%{
        posX:=pos[1]
        posY:=pos[2]
        ClickPosition(posX,posY,ClickCount,Speed,,Return)
        return [posX,posY]
    }else{
        if %ShowError% {
            ErrorMessage := "Can not find the picture " ImageFilePath
            WriteLog(Error ErrorMessage, "ERROR" )
            MSGBOX %ErrorMessage%
        }
        return false
    }
}

;模擬滑鼠點擊
ClickPosition(posX,posY,ClickCount:=1,Speed:=0,CoordMode:="Screen",Return:=true){
    ;若使用相對模式
    if (CoordMode="Relative"){
        CoordMode,Mouse,Screen
        MouseGetPos, posX_i, posY_i ;儲存原來的滑鼠位置
        ;根據點擊次數是否為零來使用MouseClick或MouseMove
        if %ClickCount%{
            MouseClick,,%posX%,%posY%,%ClickCount%,%Speed%,,R ;點擊相對位置
        }else{
            MouseMove, %posX%, %posY%,%Speed%
        }
    ;若使用其他模式
    }else{
        CoordMode,Mouse,%CoordMode%
        MouseGetPos, posX_i, posY_i ;儲存原來的滑鼠位置
        ;根據點擊次數是否為零來使用MouseClick或MouseMove
        if %ClickCount%{
            MouseClick,,%posX%,%posY%,%ClickCount%,%Speed%
        }else{
            MouseMove, %posX%, %posY%,%Speed%
        }
    }
    ;是否點擊後返回
    if %Return%{
        MouseMove, %posX_i%, %posY_i%,%Speed%
    }
    return
}

;獲取圖片的位置
GetPicturePosition(ImageFilePath){
    gui,add,picture,hwndmypic,%ImageFilePath%
    controlgetpos,,,width,height,,ahk_id %mypic%
    CoordMode Pixel
    ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight,%ImageFilePath%
    CoordMode Mouse
    if %FoundX%{
        return [FoundX+width/2,FoundY+height/2]
    } else {
        return FoundX
    }
}

WriteLog(message, type:= "INFO", folderPath := "")
{
    ; 在執行ahk的目錄下創建logs
    if(folderPath = "")
        folderPath := A_ScriptDir . "\logs"
    NOW := A_YYYY "-" A_MM  "-"  A_DD " " A_Hour  ":"  A_Min  ":" A_Sec
    TODAY := A_YYYY A_MM A_DD
    FileName := TODAY . ".log" ;以日期命名
    FullPath := folderPath . "\" . FileName
    ; 檢查檔案是否存在
    If !FileExist(FullPath) 
        FileCreateDir, %folderPath%
    FileAppend, %NOW% [%type%] => %message%`r, %folderPath%\%FileName%
    ; MsgBox, 已在%FullPath% 寫入 `r => %NOW% [%type%]%message%   
}

ReadAccounts(FolderPath := "D:\ahk\roles_account")
{
  accounts := []
  Loop, Files, % FolderPath "\*.txt"
  {
      filepath := A_LoopFileFullPath
      
      ; 讀取 txt 檔案的第一行和第二行
      FileReadLine, account, % filepath, 1
      FileReadLine, password, % filepath, 2
      
      ; 將帳號和密碼存入二維陣列
      WriteLog("Read Account_" A_Index ": " account)
      accounts.push([account, password])
  }
  return accounts
}