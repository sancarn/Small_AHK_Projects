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
;b82a000000c3
;---------------------------
;OK   
;---------------------------

