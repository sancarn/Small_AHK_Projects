#Include Libs\JSON.ahk
#Include Libs\Online_CPPToOpcodes.ahk
source =
(LTrim Join\n
	int stringlen(char *str)
	{
	  int i=0;
	  for (; str[i]!=0; i++);
	  return i;
	}
)
msgbox, % JSON.stringify(compileCpp(source))
msgbox, % CppToOpcodesOnline(source)
return

;---------------------------
;Test3.ahk
;---------------------------
;554889e548897de8c745fc000000008b45fc4863d0488b45e84801d00fb60084c074068345fc01ebe68b45fc5dc3
;---------------------------
;OK   
;---------------------------