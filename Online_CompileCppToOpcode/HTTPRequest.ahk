#Include Libs\JSON.ahk
source =
(LTrim Join\n
	int square(int num) {
		return num * num;
	}
)
msgbox, % CppToOpcodesOnline(source)
return


CppToOpcodesOnline(source){
	;compile CPP online
	response:=compileCpp(source)
	if response=""
		return
	
	;Bool to keep track of functions
	bool:=0
	opCodes := ""
	
	;Loop through compiled assembly and generate op codes as hex string.
	for k,packet in response.asm
	{
		if packet.text ~= "\w+\(.*?\):"		;This regex likely needs improving to find the function in the Assembly code.
			bool:=1
		if packet.text ~= "\s+ret\s+"
			bool:=0
		if bool
			opCodes .= strjoin(packet.opcodes)
	}
	return opCodes
}

compileCpp(source){
	;JSON to parse via POST request to godbolt
	in={"source":"%source%","compiler":"g71","options":{"userArguments":"","compilerOptions":{},"filters":{"binary":true,"labels":true,"directives":true,"commentOnly":true,"trim":true,"intel":true}}}
	
	;Setup HTTP Request
	oHTTP:= ComObjCreate("WinHttp.WinHttpRequest.5.1")
	oHTTP.Open("POST", "https://godbolt.org/api/compiler/g71/compile", True)
	oHTTP.SetRequestHeader("Accept","application/json, text/javascript")
	oHTTP.SetRequestHeader("Content-Type","application/json")
	oHTTP.send(in)
	;Timeout = 10 seconds
	Timeout:=10
	Status := oHTTP.WaitForResponse(Timeout ? Timeout : -1)  ; Success = -1, Timeout = 0, No response = Empty String
	if status=0
	{
		msgbox, "Can not connect to the server."
		return
	}
	return JSON.parse(oHTTP.ResponseText)
}

StrJoin(obj,delimiter:="",OmitChars:=""){
	string:=obj[1]
	Loop % obj.MaxIndex()-1
		string .= delimiter Trim(obj[A_Index+1],OmitChars)
	return string
}