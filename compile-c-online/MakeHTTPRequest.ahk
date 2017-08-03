#Include Libs\URIEncode.ahk
#Include Libs\JSON.ahk
c_code =
( LTrim
	//gcc 5.4.0

	#include  <stdio.h>

	int main(void)
	{
		printf("Hello, world!\n");
		return 0;
	}
)
msgbox, % compileC(c_code)
return





compileC(c_code){
	oHTTP   := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	oHTTP.Open("POST", "http://rextester.com/rundotnet/api", True)
	oHTTP.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded")
	uricode:=UriEncode(c_code)
	comparg:=UriEncode("source_file.c -o a.exe")
	data = 
	(LTrim Join&
		LanguageChoice=29
		Program=%uricode%
		Input=
		CompilerArgs=%comparg%
	)
	oHTTP.send(data)
	Timeout:=10
	Status := oHTTP.WaitForResponse(Timeout ? Timeout : -1)  ; Success = -1, Timeout = 0, No response = Empty String
	if status=0 {
		msgbox, "You are not connected to the internet."
		return
	}
	o := JSON.parse(oHTTP.ResponseText)
	return o.result
}