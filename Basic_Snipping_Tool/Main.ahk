#Include libs\Gdip.ahk
#SingleInstance force

IfNotExist,%A_AppData%\AHKMacroRecorder
	FileCreateDir, %A_AppData%\AHKMacroRecorder

OnMessage(0x14, "WM_ERASEBKGND")
Gui, -Caption +ToolWindow
Gui, +LastFound
WinSet, TransColor, Black

;Create the pen here so we don't need to create/delete it every time.
RedPen := DllCall("CreatePen", "int", PS_SOLID:=0, "int", 5, "uint", 0xff)

return

#s::
	GoSub, TAKE_A_SCREENSHOT
return

TAKE_A_SCREENSHOT:
	TAKING_SCREENSHOT:=true
	;Wait for first left button down
	KeyWait, LButton, D
	
	;Get current mouse position and start drawing rectangle.
	CoordMode, Mouse, Screen
	MouseGetPos, begin_x, begin_y
	MouseGetPos, xorigin, yorigin
	SetTimer, rectangle, 10
	
	;Wait for left button to go up
	KeyWait, LButton
	
	;Stop rectangle from bing drawn and get final coordinates.
	SetTimer, rectangle, Off
	Gui, Cancel
	MouseGetPos, end_x, end_y
	
	;Calculate region to take a screenshot of
	if (end_x > begin_x AND end_y > begin_y){
		Capture_x:=begin_x
		Capture_y:=begin_y
	}else  if (end_x < begin_x AND end_y < begin_y){
		Capture_x:=end_x
		Capture_y:=end_y
	}else  if (end_x < begin_x AND end_y > begin_y){
		Capture_x:=end_x
		Capture_y:=begin_y
	}else  if (end_x > begin_x AND end_y < begin_y){
		Capture_x:=begin_x
		Capture_y:=end_y
	}
	Capture_width	:=	Abs(end_x-begin_x)
	Capture_height	:=	Abs(end_y-begin_y)
	screen := Capture_x . "|" . Capture_y . "|" . Capture_width . "|" Capture_height  ;  X|Y|W|H	
	
	;If screenshot directory doesn't exist, create it.
	IfNotExist,%A_AppData%\AHKMacroRecorder\Screenshots
		FileCreateDir, %A_AppData%\AHKMacroRecorder\Screenshots
	
	;Save the screenshot
	filename := makeGUID()
	x=%A_AppData%\AHKMacroRecorder\Screenshots\%filename%.png
	Screenshot(x,screen)
	TAKING_SCREENSHOT:=false
return

;Rectangle for displaying region to take screenshots in...
rectangle:
	CoordMode, Mouse, Screen
	MouseGetPos, x2, y2
	
	; Has the mouse moved?
	if (x1 y1) = (x2 y2)
		return
	
	; Allow dragging to the left of the click point.
	if (x2 < xorigin) {
		x1 := x2
		x2 := xorigin
	} else
		x1 := xorigin
	
	; Allow dragging above the click point.
	if (y2 < yorigin) {
		y1 := y2
		y2 := yorigin
	} else
		y1 := yorigin
	
	Gui, Show, % "NA X" x1 " Y" y1 " W" x2-x1 " H" y2-y1
	Gui, +LastFound
	DllCall("RedrawWindow", "uint", WinExist(), "uint", 0, "uint", 0, "uint", 5)
return

makeGUID(){
	VarSetCapacity(pguid, 16, 0)
	if (DllCall("ole32.dll\CoCreateGuid", "ptr", &pguid) != 0)
		return (ErrorLevel := 1) & 0
	size := VarSetCapacity(sguid, 38 * (A_IsUnicode ? 2 : 1) + 1, 0)
	if !(DllCall("ole32.dll\StringFromGUID2", "ptr", &pguid, "ptr", &sguid, "int", size))
		return (ErrorLevel := 2) & 0
	return StrGet(&sguid)
}

Screenshot(outfile, screen) {
	pToken := Gdip_Startup()
	raster := 0x40000000 + 0x00CC0020

	pBitmap := Gdip_BitmapFromScreen(screen,raster)

	Gdip_SaveBitmapToFile(pBitmap, outfile, 100)
	Gdip_DisposeImage(pBitmap)
	Gdip_Shutdown(pToken)
}

WM_ERASEBKGND(wParam, lParam)
{
	global x1, y1, x2, y2, RedPen
	Critical 50
	if A_Gui = 1
	{
		; Retrieve stock brush.
		blackBrush := DllCall("GetStockObject", "int", BLACK_BRUSH:=0x4)
		; Select pen and brush.
		oldPen := DllCall("SelectObject", "uint", wParam, "uint", RedPen)
		oldBrush := DllCall("SelectObject", "uint", wParam, "uint", blackBrush)
		; Draw rectangle.
		DllCall("Rectangle", "uint", wParam, "int", 0, "int", 0, "int", x2-x1, "int", y2-y1)
		; Reselect original pen and brush (recommended by MS).
		DllCall("SelectObject", "uint", wParam, "uint", oldPen)
		DllCall("SelectObject", "uint", wParam, "uint", oldBrush)
		return 1
	}
}

#If TAKING_SCREENSHOT 
LButton::
return
