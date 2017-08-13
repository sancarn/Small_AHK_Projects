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
msgbox, % CppToOpcodesOnline(source)
return

;---------------------------
;Test3.ahk
;---------------------------
;803900741bba01000000660f1f44000089d04883c201807c11ff0075f3f3c39031c0c3
;---------------------------
;OK   
;---------------------------

