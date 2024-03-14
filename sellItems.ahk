!1::
EquipImages := ["C:\pic\equip1.PNG", "C:\pic\equip2.PNG", "C:\pic\equip3.PNG", "C:\pic\equip4.PNG", "C:\pic\equip5.PNG", "C:\pic\equip6.PNG"]

SearchAndClick(EquipImages*)
Return

SearchAndClick(Images*) {
    scrollCount := 0

    Loop {
        found := false  ; 标记是否找到了图片

        ; 遍历所有图像路径
        for index, imagePath in Images {
            if (ClickPicture(imagePath, 1, 1, true, false)) {
                ; 图像找到并点击成功
                sleep, 200
                send, {Ctrl Up} ; 释放 Ctrl 键
                send, {1}
                found := true  ; 标记找到图片
            }
        }

        if (found = false) {
            ; 图像未找到，滚动下移7次为一组，每组之间停顿1秒
            Loop 7 {
                send, {WheelDown}
                scrollCount++
                
            }
	    sleep, 100
        }
	

        ; 如果滚动总数超过50次，则跳出循环
        if (scrollCount >= 50)
            break
    }
}