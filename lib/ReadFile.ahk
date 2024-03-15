#Include %A_ScriptDir%\lib\LogManager.ahk

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


LoadConfig(key, folder_path)
{
    configFile := folder_path ; 替換為您的配置文件路徑

    if !FileExist(configFile)
    {
        WriteLog("Can not find the config file")
        return
    }

    FileRead, content, %configFile%

    lines := StrSplit(content, "`r`n") ; 更換為適合您的行結束符

    for index, line in lines
    {
        if InStr(line, key)
        {
            value := SubStr(line, InStr(line, ":=") + 3)
            value := Trim(value, "`n`r`t ")
            
            if value ~= "[A-Z]:\\" ; 檢查是否為路徑
                value := value . "\" ; 添加尾部反斜線

           %key% := value
            return value
        }
    }

    WriteLog("Cannot find the corresponding key.")
    return
}