#Include %A_ScriptDir%\ahk_lib\LogManager.ahk
#Include %A_ScriptDir%\ahk_lib\ReadFile.ahk

!Numpad0::
LIN_PROG_PATH := LoadConfig("LIN_PROG_PATH", A_ScriptDir "\config.txt") ;主程式檔案
LIN_START_PATH := LoadConfig("LIN_START_PATH", A_ScriptDir "\config.txt") ;登入器檢查是否更新
LIN_START_PATH2 := "rererer" 
curFilePath :=  A_ScriptDir "\roles_account\1.txt"
TODAY := A_YYYY A_MM A_DD
DestFolder := A_ScriptDir  "\" TODAY

if (FileExist(curFilePath)) {
         If !FileExist(DestFolder) 
            FileCreateDir, %DestFolder%
        FileMove, %curFilePath%, %DestFolder%
            MsgBox, %DestFolder%
        }


Return

