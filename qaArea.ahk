#Include %A_ScriptDir%\lib\LogManager.ahk
#Include %A_ScriptDir%\lib\ReadFile.ahk

!Numpad0::
IN_PROG_PATH := LoadConfig("LIN_SERVER_PATH", A_ScriptDir "\config.txt")
MsgBox, %IN_PROG_PATH%
Return

