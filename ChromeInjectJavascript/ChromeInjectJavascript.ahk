#SingleInstance, Force
#include Libs\acc.ahk
#include Libs\URIEncode.ahk

F8 up::
	;;Javascript to minify:
	js = 
	(LTrim
		alert("abc");
		alert("cde");
		
		//Count up from 5 to 10
		(function(){
			for(var n=5;10>n;n++) alert(n);
		})();
	)
	injectJS(js,true)
return

F9 Up::	
	;Pre-minified JS
	js=alert("abc");alert("cde");(function(){for(var n=5;10>n;n++) alert(n);})();
	injectJS(js,false)
return

injectJS(js,minify=1){
        if minify
	    js := getSingleLineOfJS(js)
	if !js 
		return
	addressBar := Acc_Get("Object","4.1.2.2.3.5.2",,"ahk_exe chrome.exe")
	;msgbox, % addressBar.accValue(0)
	winactivate,ahk_exe chrome.exe
	addressBar.accValue(0) := "javascript:void((function(){" . js . "})())"
	controlsend,Chrome Legacy Window,{F6}{enter},ahk_exe chrome.exe
}

getSingleLineOfJS(js){
	oHTTP   := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	oHTTP.Open("POST", "https://javascript-minifier.com/raw", True)
	oHTTP.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded")
	data:= "input=" . UriEncode(js)
	oHTTP.send(data)
	Status := oHTTP.WaitForResponse(-1)  ; Success = -1, Timeout = 0, No response = Empty String
	if status=0
	{
		msgbox, "You are not connected to the internet."
		return
	}
	

	return oHTTP.ResponseText
}
