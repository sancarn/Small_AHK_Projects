#Include Libs\JSON.ahk
#Include Libs\Online_CPPToOpcodes.ahk
source =
(LTrim Join\n
	int MyFunction()
	{
	  return 42;
	}
)
msgbox, % CppToOpcodesOnline(source)
return

;---------------------------
;Test2.ahk
;---------------------------
;554889e5b82a0000005d
;---------------------------
;OK   
;---------------------------
