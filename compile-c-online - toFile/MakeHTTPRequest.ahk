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

msgbox, % compileCToFile(c_code,A_Temp . "\myExecutable.exe")
return

compileCToFile(c_code,file) {
	oHTTP   := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	oHTTP.Open("POST", "http://www.onlinecompiler.net/catalog/view/code/compiler/compiler.php?language=ccplusplus", True)
	oHTTP.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded")
	uricode:=UriEncode(c_code)
	data = 
	(LTrim Join&
		fname=%uricode%
		os=windows
		save=false
		description=
	)
	oHTTP.send(data)
	Timeout:=10
	Status := oHTTP.WaitForResponse(Timeout ? Timeout : -1)  ; Success = -1, Timeout = 0, No response = Empty String
	if status = 0
	{
		msgbox, "You are not connected to the internet."
		return
	}
	
	regex = i)Link to executable file:.*?/tmp/(.*?).exe
	pos:=RegexMatch(oHTTP.ResponseText,regex,M)
	url=http://www.onlinecompiler.net/upload/tmp/%M1%.exe
	UrlDownloadToFile, %URL%, %file%
	return %file%
}