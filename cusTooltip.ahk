
!numpad1::
    CusSplashText("Input the message here", 2000)
    CusToolTip("Input the message here", 2000)
Return

CusSplashText(Message, time := 2000)
{
    SplashTextOn,,, %Message%
    Sleep, %time%
    SplashTextOff
}

CusToolTip(Message, time := 2000)
{
    ToolTip, %Message%
    Sleep, %time% ; 
    ToolTip ; 移除提示
}

!1::
:*:run ahk::
Run, D:\ahkAutoLogIn\AhkAutoLogIn\test.ahk
Sleep, 500
Send, {Enter}
Return