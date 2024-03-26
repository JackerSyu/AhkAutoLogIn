#Include %A_ScriptDir%\ahk_lib\LogManager.ahk

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





ReadPic(PicPath)
{
    FileList := [] 

    Loop, Files, % PicPath "\*.png"
    {
        fullFilePath := A_LoopFileFullPath  
        FileList.Push(fullFilePath)  
    }
	; Loop, % FileList.length() 
	; {
	; 	file := FileList[A_Index]
	;         MsgBox 文件名： %file%
	; }
    Return FileList
}

LoadConfig(key, folder_path)
{
    configFile := folder_path 

    if !FileExist(configFile)
    {
        WriteLog("Can not find the config file")
        return
    }

    FileRead, content, %configFile%

    lines := StrSplit(content, "`r`n") 

    for index, line in lines
    {
        if InStr(line, key)
        {
            value := SubStr(line, InStr(line, ":=") + 3)
            value := Trim(value, "`n`r`t ")
            
            if value ~= "[A-Z]:\\" ; 檢查是否為路徑

           %key% := value
            return value
        }
    }

    WriteLog("Cannot find the corresponding key.")
    return
}