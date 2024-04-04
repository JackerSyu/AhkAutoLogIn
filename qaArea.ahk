#Encoding UTF-8

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

; 设置快捷键以触发复制操作
^+c::   ; 按下Ctrl+Shift+C触发复制
SourceFolder := LoadConfig("LIN_ACCOUNT_LIST_PATH", A_ScriptDir "\config.txt") 
DestFolder := LoadConfig("LIN_ACCOUNT_PATH", A_ScriptDir "\config.txt")
; 检查源文件夹是否存在
If (FileExist(SourceFolder))
{
    ; 获取源文件夹中的所有文件
    Loop, %SourceFolder%\*.txt
    {
        ; 提取文件名
        FileName := A_LoopFileName
        ; 将文件复制到目标文件夹
        FileCopy, % SourceFolder "\" FileName, % DestFolder "\" FileName, 1
        ; 检查复制是否成功
        If (ErrorLevel != 0)
        {
            WriteLog(FileName "copy to " SourceFolder " failed")
        }
    }
}
Else
{
    MsgBox, copy file falied
}
Return



