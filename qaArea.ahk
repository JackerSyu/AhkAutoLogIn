#Include %A_ScriptDir%\ahk_lib\LogManager.ahk
#Include %A_ScriptDir%\ahk_lib\ReadFile.ahk

!Numpad0::
LIN_PROG_PATH := LoadConfig("LIN_PROG_PATH", A_ScriptDir "\config.txt") ;主程式檔案
LIN_START_PATH := LoadConfig("LIN_START_PATH", A_ScriptDir "\config.txt") ;登入器檢查是否更新


MsgBox, %LIN_PROG_PATH%`n%LIN_START_PATH%
Return

