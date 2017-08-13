#Include Libs\JSON.ahk
#Include Libs\Online_CPPToOpcodes.ahk
source =
(LTrim Join\n
	int square(int num)
	{
		return num * num;
	}
)
a := CppToOpcodesOnline(source)
b := CppToOpcodesOnline(source,"-Ofast")
c := CppToOpcodesOnline(source,"-Ofast -m32","g62")	;This returns errors for some reason

results =
(
x64:
%a%

fast x64:
%b%

fast x32:
%c%
)

msgbox, %results%
return

;---------------------------
;Test1.ahk
;---------------------------
;x64:
;554889e5894d108b45100faf45105dc3
;
;fast x64:
;0fafc989c8c3
;
;fast x32:
;
;---------------------------
;OK   
;---------------------------


