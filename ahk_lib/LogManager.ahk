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
    FileAppend, %NOW% [%type%] => %message%`n, %folderPath%\%FileName%
    ; MsgBox, 已在%FullPath% 寫入 `r => %NOW% [%type%]%message%   
}