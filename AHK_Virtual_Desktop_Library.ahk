﻿#Include AHK_Virtual_Desktop_Library/WinHook.ahk
#Include AHK_Virtual_Desktop_Library/SetClipboardHTML.ahk

DetectHiddenWindows, On
hwnd:=WinExist("ahk_pid " . DllCall("GetCurrentProcessId","Uint"))
hwnd+=0x1000<<32

hVirtualDesktopAccessor := DllCall("LoadLibrary", Str, "AHK_Virtual_Desktop_Library\VirtualDesktopAccessor.dll", "Ptr") 

global GoToDesktopNumberProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "GoToDesktopNumber", "Ptr")
global GetCurrentDesktopNumberProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "GetCurrentDesktopNumber", "Ptr")
global GetDesktopCountProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "GetDesktopCount", "Ptr")
global IsWindowOnCurrentVirtualDesktopProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "IsWindowOnCurrentVirtualDesktop", "Ptr")
global MoveWindowToDesktopNumberProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "MoveWindowToDesktopNumber", "Ptr")
global RegisterPostMessageHookProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "RegisterPostMessageHook", "Ptr")
global UnregisterPostMessageHookProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "UnregisterPostMessageHook", "Ptr")
global RestartVirtualDesktopAccessorProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "RestartVirtualDesktopAccessor", "Ptr")
global GetWindowDesktopNumberProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "GetWindowDesktopNumber", "Ptr")
global ViewIsShownInSwitchersProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "ViewIsShownInSwitchers", "Ptr")
global ViewIsVisibleProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "ViewIsShownInSwitchers", "Ptr")
global IsWindowOnDesktopNumberProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "IsWindowOnDesktopNumber", "Ptr")
global ViewGetThumbnailHwndProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "ViewGetThumbnailHwnd", "Ptr")
global ViewGetFocusedProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "ViewGetFocused", "Ptr")
global IsPinnedWindowProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "IsPinnedWindow", "Ptr")
global PinWindowProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "PinWindow", "Ptr")
global UnPinWindowProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "UnPinWindow", "Ptr")
global IsPinnedAppProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "IsPinnedApp", "Ptr")
global PinAppProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "PinApp", "Ptr")
global UnPinAppProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "UnPinApp", "Ptr")



global ViewGetFocusedProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "ViewGetFocused", "Ptr")
global ViewSetFocusProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "ViewSetFocus", "Ptr")
global ViewIsShownInSwitchersProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "ViewIsShownInSwitchers", "Ptr")
global ViewGetByLastActivationOrderProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "ViewGetByLastActivationOrder", "Ptr")





RestartVirtualDesktopAccessorWhenNeeded()


RestartVirtualDesktopAccessorWhenNeeded(){ ; its needed when Explorer.exe crashes or restarts(e.g. when coming from fullscreen game)
	explorerRestartMsg := DllCall("user32\RegisterWindowMessage", "Str", "TaskbarCreated")
	OnMessage(explorerRestartMsg, "RestartVirtualDesktopAccessor")
}

RestartVirtualDesktopAccessor(){
	DllCall(RestartVirtualDesktopAccessorProc, UInt, result)
}

; Do basic Stuff------------------------------------------

GoToDesktopNumber(num){
	BugFix()
	DllCall(GoToDesktopNumberProc, Int, num - 1)
	return
}

GoToNextDesktop(){
	BugFix()
	currentDesktop := GetCurrentDesktopNumber()
	nextDesktop := currentDesktop + 1
	GoToDesktopNumber(nextDesktop)
}

GoToPrevDesktop(){
	BugFix()
	currentDesktop := GetCurrentDesktopNumber()
	prevDesktop := currentDesktop - 1
	GoToDesktopNumber(prevDesktop)
}

BugFix(){
	;the next line fixes a bug, you can see the solution reading those:
	;-https://github.com/Ciantic/VirtualDesktopAccessor/issues/4
	;-https://pypi.org/project/pyvda/   (read the end part)
	DllCall("user32\AllowSetForegroundWindow", Int, - 1)
}

; Return information---------------------------------------

GetCurrentDesktopNumber(){
	return DllCall(GetCurrentDesktopNumberProc) + 1
}

GetNumberOfDesktops(){
	return DllCall(GetDesktopCountProc)
}

GetInWichDesktopTheWindowIs(hwnd){
	return DllCall(GetWindowDesktopNumberProc, int, hwnd) + 1
}

IsWindowOnCurrentDesktop(hwnd){
	return DllCall(IsWindowOnCurrentVirtualDesktopProc, UInt, hwnd) ;esta funcion no parece funcionar correctamente
}

IsWindowOnDesktopNumber(num, hwnd){
	return DllCall(IsWindowOnDesktopNumberProc, int, hwnd, int, num - 1)
}

; Move windows between desktops----------------------------

MoveCurrentWindowToDesktop(num) {
	activeHwnd := GetActiveHwnd()
	DllCall(MoveWindowToDesktopNumberProc, UInt, activeHwnd, UInt, num-1)
	FocusForemostHwndOnCurrentDesktop()
}

MoveWindowToDesktop(num, hwndToMove){
	activeHwnd := GetActiveHwnd()
	if (activeHwnd == hwndToMove)
	{
		MoveCurrentWindowToDesktop(num)
	}
	else
	{
		DllCall(MoveWindowToDesktopNumberProc, UInt, hwndToMove, UInt, num-1)
	}
}

FocusForemostHwndOnCurrentDesktop(){
	currentDesktop := GetCurrentDesktopNumber()
	foremostHwnd := GetForemostHwndOnDesktopNumber(currentDesktop)
	WinActivate, ahk_id %foremostHwnd%
}

GetForemostHwndOnDesktopNumber(num) {
	WinGet hwndsList, list ; hwndsList contains a list of windows hwnd´s (ordered from the foremost to the one in the back) for each desktop
	Loop % hwndsList {
		hwnd := % hwndsList%A_Index%
		windowIsOnDesktop := IsWindowOnDesktopNumber(num, hwnd)
		WinGetTitle, windowTitle, % "ahk_id " hwndsList%A_Index%
		if (windowIsOnDesktop == 1) ; return the first that founds, that one is the foremost window because of the order of the hwndsList
		{
			return hwnd
		}
	}
}


; Open specified program on desired desktop every time-----

AlwaysOpenOnDesktopNumber(num, winClass:="", winExe:=""){
	DetectHiddenWindows On ; FuncOrMethod will be called with DetectHiddenWindows On
	WinHook.Shell.Add(Func("MoveWindowToDesktop").Bind(num),,winClass,winExe,1) ; https://www.autohotkey.com/boards/viewtopic.php?f=76&t=86967
}

;AlwaysOpenOnDesktopNumberAndGo(num, winClass:="", winTitle:="", winExe:=""){
	;WinHook.Shell.Add(Func("MoveWindowToDesktop").Bind(num),,winClass,,1) ; https://www.autohotkey.com/boards/viewtopic.php?f=76&t=86967
	;GoToDesktopNumber(num)
;}

; Pin/UnPin------------------------------------------------


PinWindow(hwnd){
	return DllCall(PinWindowProc, UInt, hwnd)
}

UnpinWindow(hwnd){
	return DllCall(UnpinWindowProc, UInt, hwnd)
}

IsWindowPinned(hwnd){
	return DllCall(IsPinnedWindowProc, UInt, hwnd)
}

PinApp(hwnd){
	return DllCall(PinAppProc, UInt, hwnd)
}

UnpinApp(hwnd){
	return DllCall(UnpinAppProc, UInt, hwnd)
}

IsAppPinned(hwnd){
	return DllCall(IsPinnedAppProc, UInt, hwnd)
}

; Misc-----------------------------------------------------

CallFunctionOnDesktopSwitch(bool){
	if (bool = true)
	{
		DllCall(RegisterPostMessageHookProc, Int, hwnd, Int, 0x1400 + 30)
		OnMessage(0x1400 + 30, "OnDesktopSwitch")
	}
	if (bool = false)
	{
		DllCall(UnregisterPostMessageHookProc, Int, hwnd, Int, 0x1400 + 30)
		OnMessage(0x1400 + 30, "OnDesktopSwitch")
	}
}

;OnDesktopSwitch(){
	;CallByUser()
	;FocusLastIfOnDesktop()
;}

OpenDesktopManager(){
	Send #{Tab}
}

; Built in functions---------------------------------------

GetActiveHwnd(){
	WinGet, activeHwnd, ID, A
	return activeHwnd
}

GetActiveClass(){
	activeHwnd := GetActiveHwnd()
	WinGetClass, winClass, ahk_id %activeHwnd%
	return winClass
}

GetActiveExe(){
	activeHwnd := GetActiveHwnd()
	WinGet, winExe, ProcessName, ahk_id %activeHwnd%
	return winExe
}

CopyActiveHwnd(){
	activeHwnd := GetActiveHwnd()
	SetClipboardHTML("",, activeHwnd)
}

CopyActiveClass(){
	activeClass := GetActiveClass()
	SetClipboardHTML("",, activeClass)
}

CopyActiveExe(){
	activeExe := GetActiveExe()
	SetClipboardHTML("",, activeExe)
}

; ---------------------------------------------------------

ViewGetFocused(){
	return DllCall(ViewGetFocusedProc, UInt, hwnd)
}
ViewSetFocus(hwnd){
	return DllCall(ViewSetFocusProc, UInt, hwnd)
}
ViewIsShownInSwitchers(hwnd){
	return DllCall(ViewSetFocusProc, UInt, hwnd)
}

ViewGetByLastActivationOrder(){
	return DllCall(ViewGetByLastActivationOrderProc, Int, what goes here?,UINT, what goes here?,BOOL, what is this for?,BOOL,1)
}

ChangeBackground(imgPath){
	DllCall("SystemParametersInfo", UInt, 0x14, UInt, 0, Str, imgPath, UInt, 1)	
}
;* uint ViewGetByLastActivationOrder(HWND *windows, UINT count, BOOL onlySwitcherWindows, BOOL onlyCurrentDesktop) // Get windows in alt tab order

; Get AltTabWindows-------------------------



GetAltTabList(){
	static WS_EX_TOPMOST :=            0x8 ; sets the Always On Top flag
	static WS_EX_APPWINDOW :=      0x40000 ; provides a taskbar button
	static WS_EX_TOOLWINDOW :=        0x80 ; removes the window from the alt-tab list
	static GW_OWNER := 4
	
	AltTabList := {}
	windowList := ""
	DetectHiddenWindows, Off ; makes DllCall("IsWindowVisible") unnecessary
	WinGet, windowList, List ; gather a list of running programs
	Loop, %windowList%
	{
		ownerID := windowID := windowList%A_Index%
		Loop
		{ ;If the window we found is opened by another application or "child", let's get the hWnd of the parent
			ownerID := Format("0x{:x}",  DllCall("GetWindow", "UInt", ownerID, "UInt", GW_OWNER))
		} Until !Format("0x{:x}",  DllCall("GetWindow", "UInt", ownerID, "UInt", GW_OWNER))
		ownerID := ownerID ? ownerID : windowID
		
	; only windows that are not removed from the Alt+Tab list, AND have a taskbar button, will be appended to our list.
		If (Format("0x{:x}", DllCall("GetLastActivePopup", "UInt", ownerID)) = windowID)
		{
			WinGet, es, ExStyle, ahk_id %windowID%
			If (!((es & WS_EX_TOOLWINDOW) && !(es & WS_EX_APPWINDOW)) && !IsInvisibleWin10BackgroundAppWindow(windowID))
			{
				AltTabList.Push(windowID)
			}
		}
	}
	; UNCOMMENT THIS FOR TESTING
	; WinGetClass, class1, % "ahk_id" AltTabList[1]
	; WinGetClass, class2, % "ahk_id" AltTabList[2]
	; WinGetClass, classF, % "ahk_id" AltTabList.pop()
	; msgbox % "Number of Windows: " AltTabList.length() "`nFirst windowID: " class1 "`nSecond windowID: " class2 "`nFinal windowID: " classF
	return AltTabList
}

IsInvisibleWin10BackgroundAppWindow(hWindow){
	result := 0
	VarSetCapacity(cloakedVal, A_PtrSize) ; DWMWA_CLOAKED := 14
	hr := DllCall("DwmApi\DwmGetWindowAttribute", "Ptr", hWindow, "UInt", 14, "Ptr", &cloakedVal, "UInt", A_PtrSize)
	if !hr ; returns S_OK (which is zero) on success. Otherwise, it returns an HRESULT error code
	{
		result := NumGet(cloakedVal) ; omitting the "&" performs better
	}
	return result ? true : false
}

  /*
  DWMWA_CLOAKED: If the window is cloaked, the following values explain why:
  1  The window was cloaked by its owner application (DWM_CLOAKED_APP)
  2  The window was cloaked by the Shell (DWM_CLOAKED_SHELL)
  4  The cloak value was inherited from its owner window (DWM_CLOAKED_INHERITED)
*/

; end get AltTabWindows-------------------------

FocusLast(){
	altTabList := GetAltTabList()
	lastWindow := altTabList[2]
	WinGetTitle, title, % "ahk_id " altTabList[2]
	MsgBox, %title%
	;msgbox, %lastWindow%
	WinActivate, ahk_id %foremostHwnd%
}

/*

; agregando funciones-----------

FocusLastIfOnDesktop(){
	if DesktopIsActive()
	{
		FocusLastActive()
	}
}

DesktopIsActive(){
	activeClass := GetActiveClass()
	desktopClass := "WorkerW"
	if (activeClass == desktopClass)
	{
		return True
	}
	else
	{
		return False
	}
}


FocusLastActive(){
	cuerrentDesktop := GetCurrentDesktopNumber()
	lastActive := lastActiveInEachDesktop[cuerrentDesktop]
	WinActivate, ahk_id %lastActive%
}

GetLastActiveInEachDesktop(){ ; y si cerre el lastActive?, cada las active deberia ser una lista de last actives
	cuerrentDesktop := GetCurrentDesktopNumber()
	lastActive := GetActiveHwnd() ; esto tiene q dar un hwnd
	
	desktopHwnd := GetDesktopHwnd()
	desktopHwnd := GetTaskBarHwnd()
	
	if (lastActive not in desktopHwnd,taskbarHwnd) ; Any spaces or tabs around the delimiting commas are significant when using "in"
	{
		lastActiveInEachDesktop[cuerrentDesktop] := lastActive
		return lastActiveInEachDesktop ; nose como se retorna una lista
	}
}

SetTimer, GetLastActiveInEachDesktop, 0


windows := AltTabWindows()
Gui, Add, ListView, r20 w700, #|ID|Title
Loop, % windows.length()
{
  WinGetTitle, title, % "ahk_id " windows[A_Index]
  LV_Add("", A_Index, windows[A_Index], title)
}
LV_ModifyCol()  ; Auto-size each column to fit its contents.
Gui, Show
return

GuiClose:
Exitapp

AltTabWindows() {
   static WS_EX_TOPMOST :=            0x8 ; sets the Always On Top flag
   static WS_EX_APPWINDOW :=      0x40000 ; provides a taskbar button
   static WS_EX_TOOLWINDOW :=        0x80 ; removes the window from the alt-tab list
   static GW_OWNER := 4

   AltTabList := {}
   windowList := ""
   DetectHiddenWindows, Off ; makes DllCall("IsWindowVisible") unnecessary
   WinGet, windowList, List ; gather a list of running programs
   Loop, %windowList%
      {
      ownerID := windowID := windowList%A_Index%
      Loop { ;If the window we found is opened by another application or "child", let's get the hWnd of the parent
         ownerID := Format("0x{:x}",  DllCall("GetWindow", "UInt", ownerID, "UInt", GW_OWNER))
      } Until !Format("0x{:x}",  DllCall("GetWindow", "UInt", ownerID, "UInt", GW_OWNER))
      ownerID := ownerID ? ownerID : windowID

      ; only windows that are not removed from the Alt+Tab list, AND have a taskbar button, will be appended to our list.
      If (Format("0x{:x}", DllCall("GetLastActivePopup", "UInt", ownerID)) = windowID)
         {
         WinGet, es, ExStyle, ahk_id %windowID%
         If (!((es & WS_EX_TOOLWINDOW) && !(es & WS_EX_APPWINDOW)) && !IsInvisibleWin10BackgroundAppWindow(windowID))
            AltTabList.Push(windowID)
         }
      }

   ; UNCOMMENT THIS FOR TESTING
   ;WinGetClass, class1, % "ahk_id" AltTabList[1]
   ;WinGetClass, class2, % "ahk_id" AltTabList[2]
   ;WinGetClass, classF, % "ahk_id" AltTabList.pop()
   ;msgbox % "Number of Windows: " AltTabList.length() "`nFirst windowID: " class1 "`nSecond windowID: " class2 "`nFinal windowID: " classF
   return AltTabList
}

  IsInvisibleWin10BackgroundAppWindow(hWindow) {
    result := 0
    VarSetCapacity(cloakedVal, A_PtrSize) ; DWMWA_CLOAKED := 14
    hr := DllCall("DwmApi\DwmGetWindowAttribute", "Ptr", hWindow, "UInt", 14, "Ptr", &cloakedVal, "UInt", A_PtrSize)
    if !hr ; returns S_OK (which is zero) on success. Otherwise, it returns an HRESULT error code
      result := NumGet(cloakedVal) ; omitting the "&" performs better
    return result ? true : false
    }

  /*
  DWMWA_CLOAKED: If the window is cloaked, the following values explain why:
  1  The window was cloaked by its owner application (DWM_CLOAKED_APP)
  2  The window was cloaked by the Shell (DWM_CLOAKED_SHELL)
  4  The cloak value was inherited from its owner window (DWM_CLOAKED_INHERITED)
  */
 