
global LIN_CONFIRM_CHAR_PATH := "D:\ahk\pic\crab.PNG"

!numpad0::
; 1. 設定特定資料夾路徑
  Start(true)
Return

Start(isOpenBag := false)
{
  openBagMode := isOpenBag
  WriteLog("Open Bag Mode: " openBagMode )
  ; 2. 定義二維陣列
  accounts := ReadAccounts()
  
  ; 4. 使用 Loop 印出二維陣列的內容
  Loop, % accounts.Length()
  {
      account := accounts[A_Index][1]
      password := accounts[A_Index][2]
      WriteLog("Current Account: " account )
      ; 開始自動開天堂程式
      ;MsgBox, TXT_%A_Index%: %account%, %password%
      ClickPicture(LIN_CONFIRM_CHAR_PATH, 1, 1,true,true)
  }
  
}

ReadAccounts(FolderPath := "D:\ahk\roles_account")
{
  accounts := []
  ; 3. 讀取資料夾內的所有 txt 檔案並寫入二維陣列
  Loop, Files, % FolderPath "\*.txt"
  {
      filepath := A_LoopFileFullPath
      
      ; 讀取 txt 檔案的第一行和第二行
      FileReadLine, account, % filepath, 1
      FileReadLine, password, % filepath, 2
      WriteLog("Read Account_" A_Index ": " account)
      ; 將帳號和密碼存入二維陣列
      accounts.push([account, password])
  }
  return accounts
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
            ; MSGBOX %ErrorMessage%
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

!1::
:*:run ahk::
Run, D:\ahk\test.ahk
Sleep, 500
Send, {Enter}
Return