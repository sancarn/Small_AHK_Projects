#Include Libs\JSON.ahk
#Include Libs\Online_CPPToOpcodes.ahk
source =
(LTrim Join\n
	int square(int num)
	{
		return num * num;
	}
)
msgbox, % CppToOpcodesOnline(source)
return

;---------------------------
;Test1.ahk
;---------------------------
;0fafc989c8c3
;---------------------------
;OK   
;---------------------------

