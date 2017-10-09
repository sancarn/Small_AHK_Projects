;Member Properties:		{accChild,accChildCount,accDefaultAction,accDescription,accFocus,accHelp,accHelpTopic,accKeyboardShortcut,accName,accParent,accRole,accSelection,accState,accValue}
;accChild				Read-only		An IDispatch interface for the specified child, if one exists. All objects must support this property. See get_accChild.
;accChildCount			Read-only		The number of children that belong to this object. All objects must support this property. See get_accChildCount.
;accDefaultAction		Read-only		A string that describes the object's default action. Not all objects have a default action. See get_accDefaultAction.
;accDescription			Read-only		Note  The accDescription property is not supported in the transition to UI Automation. Microsoft Active Accessibility servers and applications should not use it. A string that describes the visual appearance of the specified object. Not all objects have a description.
;accFocus				Read-only		The object that has the keyboard focus. All objects that receive the keyboard focus must support this property. See get_accFocus.
;accHelp				Read-only		A help string. Not all objects support this property. See get_accHelp.
;accHelpTopic			Read-only		Note  The accHelpTopic property is deprecated and should not be used.The full path of the help file associated with the specified object and the identifier of the appropriate topic within that file. Not all objects support this property.
;accKeyboardShortcut	Read-only		The object's shortcut key or access key, also known as the mnemonic. All objects that have a shortcut key or an access key support this property. See get_accKeyboardShortcut.
;accName				Read-only		The name of the object. All objects support this property. See get_accName.
;accParent				Read-only		The IDispatch interface of the object's parent. All objects support this property. See get_accParent.
;accRole				Read-only		Information that describes the role of the specified object. All objects support this property. See get_accRole.
;accSelection			Read-only		The selected children of this object. All objects that support selection must support this property. See get_accSelection.
;accState				Read-only		The current state of the object. All objects support this property. See get_accState.
;accValue				Read/write		The value of the object. Not all objects have a value. See get_accValue, put_accValue.

;Member Methods:		{accDoDefaultAction,accHitTest,accLocation,accNavigate,accSelect}
;accDoDefaultAction		Performs the specified object's default action. Not all objects have a default action.
;accHitTest				Retrieves the child element or child object at a given point on the screen. All visual objects support this method.
;accLocation				Retrieves the specified object's current screen location. All visual objects support this method. 
;accNavigate				Note  The accNavigate method is deprecated and should not be used. Clients should use other methods and properties such as AccessibleChildren, get_accChild, get_accParent, and IEnumVARIANT. Traverses to another user interface element within a container and retrieves the object. All visual objects support this method.
;accSelect				Modifies the selection or moves the keyboard focus of the specified object. All objects that support selection or receive the keyboard focus must support this method.




;------------------------------------------------------------------------------
; Acc.ahk Standard Library
; by Sean
; Updated by jethrow:
; 	Modified ComObjEnwrap params from (9,pacc) --> (9,pacc,1)
; 	Changed ComObjUnwrap to ComObjValue in order to avoid AddRef (thanks fincs)
; 	Added Acc_GetRoleText & Acc_GetStateText
; 	Added additional functions - commented below
; 	Removed original Acc_Children function
; last updated 2/19/2012
; Updated by Sancarn:
;	Added all relevant enumerations
; last updated 06/07/2017
;------------------------------------------------------------------------------

;https://msdn.microsoft.com/en-us/library/windows/desktop/dd373606(v=vs.85).aspx
class ACC_OBJID{
	static	WINDOW        		:=	0x00000000
	static	SYSMENU       		:=	0xFFFFFFFF
	static	TITLEBAR      		:=	0xFFFFFFFE
	static	MENU          		:=	0xFFFFFFFD
	static	CLIENT        		:=	0xFFFFFFFC
	static	VSCROLL       		:=	0xFFFFFFFB
	static	HSCROLL       		:=	0xFFFFFFFA
	static	SIZEGRIP      		:=	0xFFFFFFF9
	static	CARET         		:=	0xFFFFFFF8
	static	CURSOR        		:=	0xFFFFFFF7
	static	ALERT         		:=	0xFFFFFFF6
	static	SOUND         		:=	0xFFFFFFF5
	static	QUERYCLASSNAMEIDX 	:=	0xFFFFFFF4
	static	NATIVEOM			:=	0xFFFFFFF0
}

;https://msdn.microsoft.com/en-us/library/windows/desktop/dd373609(v=vs.85).aspx
class ACC_STATE {
	static	NORMAL 					:=		0					
	static	UNAVAILABLE 			:=		0x1                    
	static	SELECTED 				:=		0x2                    
	static	FOCUSED 				:=		0x4                    
	static	PRESSED 				:=		0x8                    
	static	CHECKED 				:=		0x10                   
	static	MIXED 					:=		0x20                   
	static	INDETERMINATE 			:=		this.MIXED			
	static	READONLY 				:=		0x40                   
	static	HOTTRACKED 				:=		0x80                   
	static	DEFAULT 				:=		0x100                  
	static	EXPANDED 				:=		0x200                  
	static	COLLAPSED 				:=		0x400                  
	static	BUSY 					:=		0x800                  
	static	FLOATING 				:=		0x1000                 
	static	MARQUEED 				:=		0x2000                 
	static	ANIMATED 				:=		0x4000                 
	static	INVISIBLE 				:=		0x8000                 
	static	OFFSCREEN 				:=		0x10000                
	static	SIZEABLE 				:=		0x20000                
	static	MOVEABLE 				:=		0x40000                
	static	SELFVOICING 			:=		0x80000                
	static	FOCUSABLE 				:=		0x100000               
	static	SELECTABLE 				:=		0x200000               
	static	LINKED 					:=		0x400000               
	static	TRAVERSED 				:=		0x800000               
	static	MULTISELECTABLE 		:=		0x1000000              
	static	EXTSELECTABLE 			:=		0x2000000              
	static	ALERT_LOW 				:=		0x4000000              
	static	ALERT_MEDIUM 			:=		0x8000000              
	static	ALERT_HIGH 				:=		0x10000000             
	static	PROTECTED 				:=		0x20000000             
	static	VALID 					:=		0x7fffffff			
}

;https://msdn.microsoft.com/en-us/library/windows/desktop/dd373608(v=vs.85).aspx
class ACC_ROLE {
	static	TITLEBAR 				:=		0x1	
	static	MENUBAR 				:=		0x2 
	static	SCROLLBAR 				:=		0x3 
	static	GRIP 					:=		0x4 
	static	SOUND 					:=		0x5 
	static	CURSOR 					:=		0x6 
	static	CARET 					:=		0x7 
	static	ALERT 					:=		0x8 
	static	WINDOW 					:=		0x9 
	static	CLIENT 					:=		0xa 
	static	MENUPOPUP 				:=		0xb 
	static	MENUITEM 				:=		0xc 
	static	TOOLTIP 				:=		0xd 
	static	APPLICATION 			:=		0xe 
	static	DOCUMENT 				:=		0xf 
	static	PANE 					:=		0x10
	static	CHART 					:=		0x11
	static	DIALOG 					:=		0x12
	static	BORDER 					:=		0x13
	static	GROUPING 				:=		0x14
	static	SEPARATOR 				:=		0x15
	static	TOOLBAR 				:=		0x16
	static	STATUSBAR 				:=		0x17
	static	TABLE 					:=		0x18
	static	COLUMNHEADER 			:=		0x19
	static	ROWHEADER 				:=		0x1a
	static	COLUMN 					:=		0x1b
	static	ROW 					:=		0x1c
	static	CELL 					:=		0x1d
	static	LINK 					:=		0x1e
	static	HELPBALLOON 			:=		0x1f
	static	CHARACTER 				:=		0x20
	static	LIST 					:=		0x21
	static	LISTITEM 				:=		0x22
	static	OUTLINE 				:=		0x23
	static	OUTLINEITEM 			:=		0x24
	static	PAGETAB 				:=		0x25
	static	PROPERTYPAGE 			:=		0x26
	static	INDICATOR 				:=		0x27
	static	GRAPHIC 				:=		0x28
	static	STATICTEXT 				:=		0x29
	static	TEXT 					:=		0x2a
	static	PUSHBUTTON 				:=		0x2b
	static	CHECKBUTTON 			:=		0x2c
	static	RADIOBUTTON 			:=		0x2d
	static	COMBOBOX 				:=		0x2e
	static	DROPLIST 				:=		0x2f
	static	PROGRESSBAR 			:=		0x30
	static	DIAL 					:=		0x31
	static	HOTKEYFIELD 			:=		0x32
	static	SLIDER 					:=		0x33
	static	SPINBUTTON 				:=		0x34
	static	DIAGRAM 				:=		0x35
	static	ANIMATION 				:=		0x36
	static	EQUATION 				:=		0x37
	static	BUTTONDROPDOWN 			:=		0x38
	static	BUTTONMENU 				:=		0x39
	static	BUTTONDROPDOWNGRID 		:=		0x3a
	static	WHITESPACE 				:=		0x3b
	static	PAGETABLIST 			:=		0x3c
	static	CLOCK 					:=		0x3d
	static	SPLITBUTTON 			:=		0x3e
	static	IPADDRESS 				:=		0x3f
	static	OUTLINEBUTTON 			:=		0x40
}

;https://msdn.microsoft.com/en-us/library/windows/desktop/dd373600(v=vs.85).aspx
class ACC_NAVDIR {
	static	MIN 		:=	0x0
	static	UP 			:=	0x1
	static	DOWN 		:=	0x2
	static	LEFT 		:=	0x3
	static	RIGHT 		:=	0x4
	static	NEXT 		:=	0x5
	static	PREVIOUS	:=	0x6
	static	FIRSTCHILD 	:=	0x7
	static	LASTCHILD 	:=	0x8
	static	MAX 		:=	0x9
}

;https://msdn.microsoft.com/en-us/library/windows/desktop/dd373634(v=vs.85).aspx
class ACC_SELECTIONFLAG {
	static	NONE 				:= 0x0	
	static	TAKEFOCUS 			:= 0x1 
	static	TAKESELECTION 		:= 0x2 
	static	EXTENDSELECTION 	:= 0x4 
	static	ADDSELECTION 		:= 0x8 
	static	REMOVESELECTION 	:= 0x10
	static	VALID 				:= 0x1f
}




Acc_Init()
{
	Static	h := DllCall("LoadLibrary","Str","oleacc","Ptr")
}

Acc_ObjectFromEvent(ByRef _idChild_, hWnd, idObject, idChild)
{
	Acc_Init()
	if (DllCall("oleacc\AccessibleObjectFromEvent"
	          , "Ptr", hWnd
			  , "UInt", idObject
			  , "UInt", idChild
			  , "Ptr*", pacc
			  , "Ptr", VarSetCapacity(varChild, 8 + 2 * A_PtrSize, 0) * 0 + &varChild) = 0) {
		_idChild_:=NumGet(varChild,8,"UInt")
		return ComObjEnwrap(9,pacc,1)
	}
}

Acc_ObjectFromPoint(ByRef _idChild_ = "", x = "", y = "")
{
	Acc_Init()
	if (DllCall("oleacc\AccessibleObjectFromPoint"
			  , "Int64", x == ""||y==""
						 ? 0 * DllCall("GetCursorPos","Int64*",pt) + pt
						 : x & 0xFFFFFFFF | y << 32
			  , "Ptr*", pacc
			  , "Ptr", VarSetCapacity(varChild, 8 + 2 * A_PtrSize, 0) * 0 + &varChild) = 0) {
		_idChild_:=NumGet(varChild,8,"UInt")
		return ComObjEnwrap(9,pacc,1)
	}
}

Acc_ObjectFromWindow(hWnd, idObject = -4)
{
	Acc_Init()
	if (DllCall("oleacc\AccessibleObjectFromWindow"
			  , "Ptr", hWnd
			  , "UInt", idObject &= 0xFFFFFFFF
			  , "Ptr", -VarSetCapacity(IID,16)
			           + NumPut(idObject == 0xFFFFFFF0
							    ? 0x46000000000000C0
								: 0x719B3800AA000C81
								, NumPut(idObject == 0xFFFFFFF0
								? 0x0000000000020400
								: 0x11CF3C3D618736E0,IID,"Int64"),"Int64")
			  , "Ptr*", pacc) = 0)
		return ComObjEnwrap(9,pacc,1)
}

Acc_WindowFromObject(pacc)
{
	if (DllCall("oleacc\WindowFromAccessibleObject"
	          , "Ptr", IsObject(pacc) ? ComObjValue(pacc) : pacc
			  , "Ptr*", hWnd) = 0)
		return hWnd
}

Acc_GetRoleText(nRole)
{
	nSize := DllCall("oleacc\GetRoleText"
	               , "Uint", nRole
				   , "Ptr", 0
				   , "Uint", 0)
	VarSetCapacity(sRole, (A_IsUnicode ? 2 : 1) * nSize)
	DllCall("oleacc\GetRoleText"
	      , "Uint", nRole
		  , "str", sRole
		  , "Uint", nSize+1)
	return sRole
}

Acc_GetStateText(nState)
{
	nSize := DllCall("oleacc\GetStateText"
	               , "Uint", nState
				   , "Ptr", 0
				   , "Uint", 0)
	VarSetCapacity(sState, (A_IsUnicode ? 2 : 1) * nSize)
	DllCall("oleacc\GetStateText"
	      , "Uint", nState
		  , "str", sState
		  , "Uint", nSize+1)
	return sState
}

; Written by jethrow
Acc_Role(Acc, ChildId=0) {
	try return ComObjType(Acc,"Name") = "IAccessible"
	           ? Acc_GetRoleText(Acc.accRole(ChildId))
			   : "invalid object"
}

Acc_State(Acc, ChildId=0) {
	try return ComObjType(Acc,"Name") = "IAccessible"
	           ? Acc_GetStateText(Acc.accState(ChildId))
			   : "invalid object"
}

Acc_Location(Acc, ChildId=0) { ; adapted from Sean's code
	try Acc.accLocation(ComObj(0x4003, & x := 0)
	                  , ComObj(0x4003,&y:=0)
					  , ComObj(0x4003,&w:=0)
					  , ComObj(0x4003,&h:=0)
					  , ChildId)
	catch
		return
	return { x:NumGet(x,0,"int")
	       , y:NumGet(y,0,"int")
		   , w:NumGet(w,0,"int")
		   , h:NumGet(h,0,"int")
		   , pos:"x" NumGet(x,0,"int")
		      . " y" NumGet(y,0,"int")
			  . " w" NumGet(w,0,"int")
			  . " h" NumGet(h,0,"int") }
}

Acc_Parent(Acc) { 
	try parent := Acc.accParent
	return parent ? Acc_Query(parent) :
}

Acc_Child(Acc, ChildId=0) {
	try child := Acc.accChild(ChildId)
	return child ? Acc_Query(child) :
}

; thanks Lexikos - www.autohotkey.com/forum/viewtopic.php?t=81731&p=509530#509530
Acc_Query(Acc) { 
	try return ComObj(9, ComObjQuery(Acc, "{618736e0-3c3d-11cf-810c-00aa00389b71}"), 1)
}

;Acc_GetChild(Acc_or_Hwnd, child_path) {
;   Acc := WinExist("ahk_id" Acc_or_Hwnd)? Acc_ObjectFromWindow(Acc_or_Hwnd):Acc_or_Hwnd
;   if ComObjType(Acc,"Name") = "IAccessible" {
;      Loop Parse, child_path, csv
;         Acc := A_LoopField="P"? Acc_Parent(Acc):Acc_Children(Acc)[A_LoopField]
;      return Acc
;   }
;}


Acc_Error(p="") {
	static setting:=0
	return p=""?setting:setting:=p
}
Acc_Children(Acc) {
	if ComObjType(Acc,"Name") != "IAccessible"
		ErrorLevel := "Invalid IAccessible Object"
	else {
		Acc_Init(), cChildren:=Acc.accChildCount, Children:=[]
		if DllCall("oleacc\AccessibleChildren", "Ptr",ComObjValue(Acc), "Int",0, "Int",cChildren, "Ptr",VarSetCapacity(varChildren,cChildren*(8+2*A_PtrSize),0)*0+&varChildren, "Int*",cChildren)=0 {
			Loop %cChildren%
				i:=(A_Index-1)*(A_PtrSize*2+8)+8, child:=NumGet(varChildren,i), Children.Insert(NumGet(varChildren,i-8)=9?Acc_Query(child):child), NumGet(varChildren,i-8)=9?ObjRelease(child):
			return Children.MaxIndex()?Children:
		} else
			ErrorLevel := "AccessibleChildren DllCall Failed"
	}
	if Acc_Error()
		throw Exception(ErrorLevel,-1)
}
Acc_ChildrenByRole(Acc, Role) {
	if ComObjType(Acc,"Name")!="IAccessible"
		ErrorLevel := "Invalid IAccessible Object"
	else {
		Acc_Init(), cChildren:=Acc.accChildCount, Children:=[]
		if DllCall("oleacc\AccessibleChildren", "Ptr",ComObjValue(Acc), "Int",0, "Int",cChildren, "Ptr",VarSetCapacity(varChildren,cChildren*(8+2*A_PtrSize),0)*0+&varChildren, "Int*",cChildren)=0 {
			Loop %cChildren% {
				i:=(A_Index-1)*(A_PtrSize*2+8)+8, child:=NumGet(varChildren,i)
				if NumGet(varChildren,i-8)=9
					AccChild:=Acc_Query(child), ObjRelease(child), Acc_Role(AccChild)=Role?Children.Insert(AccChild):
				else
					Acc_Role(Acc, child)=Role?Children.Insert(child):
			}
			return Children.MaxIndex()?Children:, ErrorLevel:=0
		} else
			ErrorLevel := "AccessibleChildren DllCall Failed"
	}
	if Acc_Error()
		throw Exception(ErrorLevel,-1)
}
Acc_Get(Cmd, ChildPath="", ChildID=0, WinTitle="", WinText="", ExcludeTitle="", ExcludeText="") {
	static properties := {Action:"DefaultAction", DoAction:"DoDefaultAction", Keyboard:"KeyboardShortcut"}
	AccObj :=   IsObject(WinTitle)? WinTitle
			:   Acc_ObjectFromWindow( WinExist(WinTitle, WinText, ExcludeTitle, ExcludeText), 0 )
	if ComObjType(AccObj, "Name") != "IAccessible"
		ErrorLevel := "Could not access an IAccessible Object"
	else {
		StringReplace, ChildPath, ChildPath, _, %A_Space%, All
		AccError:=Acc_Error(), Acc_Error(true)
		Loop Parse, ChildPath, ., %A_Space%
			try {
				if A_LoopField is digit
					Children:=Acc_Children(AccObj), m2:=A_LoopField ; mimic "m2" output in else-statement
				else
					RegExMatch(A_LoopField, "(\D*)(\d*)", m), Children:=Acc_ChildrenByRole(AccObj, m1), m2:=(m2?m2:1)
				if Not Children.HasKey(m2)
					throw
				AccObj := Children[m2]
			} catch {
				ErrorLevel:="Cannot access ChildPath Item #" A_Index " -> " A_LoopField, Acc_Error(AccError)
				if Acc_Error()
					throw Exception("Cannot access ChildPath Item", -1, "Item #" A_Index " -> " A_LoopField)
				return
			}
		Acc_Error(AccError)
		StringReplace, Cmd, Cmd, %A_Space%, , All
		properties.HasKey(Cmd)? Cmd:=properties[Cmd]:
		try {
			if (Cmd = "Location")
				AccObj.accLocation(ComObj(0x4003,&x:=0), ComObj(0x4003,&y:=0), ComObj(0x4003,&w:=0), ComObj(0x4003,&h:=0), ChildId)
			  , ret_val := "x" NumGet(x,0,"int") " y" NumGet(y,0,"int") " w" NumGet(w,0,"int") " h" NumGet(h,0,"int")
			else if (Cmd = "Object")
				ret_val := AccObj
			else if Cmd in Role,State
				ret_val := Acc_%Cmd%(AccObj, ChildID+0)
			else if Cmd in ChildCount,Selection,Focus
				ret_val := AccObj["acc" Cmd]
			else
				ret_val := AccObj["acc" Cmd](ChildID+0)
		} catch {
			ErrorLevel := """" Cmd """ Cmd Not Implemented"
			if Acc_Error()
				throw Exception("Cmd Not Implemented", -1, Cmd)
			return
		}
		return ret_val, ErrorLevel:=0
	}
	if Acc_Error()
		throw Exception(ErrorLevel,-1)
}
