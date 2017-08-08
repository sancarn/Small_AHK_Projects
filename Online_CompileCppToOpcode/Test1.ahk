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
;554889e5897dfc8b45fc0faf45fc5d
;---------------------------
;OK   
;---------------------------
