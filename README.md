# AHK_Virtual_Desktop_Library

# Introduction:
In Windows you can use virtual desktops, this library gives you functions to fully manipulate them<br/>
For example:
- `GoToDesktop(desktop_number)`
- `GetCurrentDesktop()`
- `GetAmountOfDesktops()`
- `MoveCurrentWindowToDesktop(desktop_number)`
- `SetBackgroundOnDesktop(desktop_number, imgPath)`(You can have one background per desktop)
- `NewDesktop()`
- you can open a program always on a specifed desktop with `AlwaysOpenOnDesktopNumber(in_wich_desktop, the_program_you_want)`
- `GetAltTabList()`
- and more!
- Also there's a [list of usefull ideas to use this library](https://github.com/adrian88888888/AHK_Virtual_Desktop_Library/#usefull-ideas-to-use-this-library "list of usefull ideas to use this library")

## Index:
- [Installation](https://github.com/adrian88888888/AHK_Vitrual_Desktop_Library/#installation "Installation")
- [Documentation](https://github.com/adrian88888888/AHK_Vitrual_Desktop_Library/#documentation "Documentation")
- [Working AHK Example](https://github.com/adrian88888888/AHK_Vitrual_Desktop_Library/#working-ahk-example "Working ahk example")
- [Usefull ideas to use this library](https://github.com/adrian88888888/AHK_Virtual_Desktop_Library/#usefull-ideas-to-use-this-library "Usefull ideas to use this library")
- [Credits](https://github.com/adrian88888888/AHK_Vitrual_Desktop_Library/#credits "Credits")

------------------

# Documentation:

Note: a lot of functions takes the parameter hwnd, you can use the [Built in Function](https://github.com/adrian88888888/AHK_Vitrual_Desktop_Library/#usefull-built-in-functions "Built in Functions") `GetActiveHwnd()` to get the active hwnd<br/>
To the newbies: hwnd = ahk_id = it's the id of the window, every window has one

## Navigate between desktops:
| Functions  |  Description |
| :------------ | :------------ |
|`GoToDesktop(desktop_number)` |  Goes to the desired desktop |
|`GoToNextDesktop()` |  Goes to the next desktop |
|`GoToPrevDesktop()`  |  Goes to the previous desktop |

## Return information:
| Functions  |  Description |
| :------------ | :------------ |
|`GetCurrentDesktop()` | Returns in wich desktop you are, for example if you are in desktop 8 it will return 8|
|`GetAmountOfDesktops()`  |  Returns the total number of virtual desktops|
|`InWichDesktopThisWindowIs(hwnd)` |  Returns in which desktop a given hwnd is|
|`IsWindowOnCurrentDesktop(hwnd)` |  Returns if the given hwnd is in the current desktop|
|`IsWindowOnDesktopNumber(desktop_number, hwnd)`| Return if a hwnd is in a specified desktop|
|`GetAltTabList()`|Alt+Tab shows an array/list of open windows, this funtion returns that array, his order is from the foremost window to the one in the back, and is a array of hwnd's|
|`IsFullScreenMode(ExesToIgnore)`|Returns `True` if you are in full screen mode<br/>Returns `False` if you are in window mode<br/>`ExesToIgnore` parameter: You can leave it empty or you can pass an array to it of .exe´s, and it will ignore those, so even if they are in full screen it will return `False`<br/>For example. ```ExesToIgnore := ["atom.exe","GitHubDesktop.exe","chrome.exe"]```<br/>Use the funtion `CopyActiveExe()` in the [Built in Functions](https://github.com/adrian88888888/AHK_Vitrual_Desktop_Library/#usefull-built-in-functions "Built in Functions") to get the exe easier<br><br/>For multimonitor support read the function in the source code|

## Move windows between desktops:

| Functions  |  Description |
| :------------ | :------------ |
|`MoveCurrentWindowToDesktop(desktop_number)`|Moves current window to the desired desktop|
|`MoveCurrentWindowToDesktopAndGo(desktop_number)`|Same as above but also goes to that desktop|
|`MoveWindowToDesktop(desktop_number, hwndToMove)`|Meant to move a background window from the actual desktop to another<br/><br/>You can get a list of all background windows with `GetAltTabList()`|
|`MoveWindowToDesktopAndGo(desktop_number, hwndToMove)`|Same as above but moves to that desktop and it will focus that window|

Note: Functions here have repetitive names, but that's because I already combined them for you and dealed with side effects of it(for example flickering)<br/>
So don't combine funtions, use the already combined ones from the table IF possible<br/>
For example instead of this:
```autohotkey
q::
MoveCurrentWindowToDesktop(2)
GoToDesktop(2)
return
```
Do this:
```autohotkey
q::
MoveCurrentWindowToDesktopAndGo(2)
return
```

## Open specified program on desired desktop every time:
| Functions  |  Description |
| :------------ | :------------ |
|`AlwaysOpenOnDesktopNumber(desktop_number, exe)`|You can use this to have your favourite programs in the desktops you want.<br/>Every time you open the a specified program(does not matter how) it will open in the desired desktop.<br/>Requires 2 parameters:<br/>`desktop_number`:In wich desktop the program will open<br/>`exe`: a string with the .exe.<br/>For example. `AlwaysOpenOnDesktopNumber(3, "Notepad.exe")` <br/><br/>In this part you can use the [Built in Function](https://github.com/adrian88888888/AHK_Vitrual_Desktop_Library/#usefull-built-in-functions "Built in Function") `CopyActiveExe()` to make it easier.<br/><br/>If all windows start to open in that desktop, that means that the parameters are wrong|
|`AlwaysOpenOnDesktopNumberAndGo(desktop_number, exe)`|Same as above, but also goes to that desktop|

## Open/Close Desktop:
| Functions  |  Description |
| :------------ | :------------ |
|`NewDesktop()`|Opens a new desktop|
|`CloseDesktop()`|Closes current desktop|

## Pin/UnPin Windows:
When you pin a Window or an App, it means that it will stay in all desktops, Windows remembers pins even if the script closes, so remember to unpin if you want to
| Functions  |  Description |
| :------------ | :------------ |
|`PinWindow(hwnd)`|Pins the specified window(making it stay in all desktops)|
|`UnPinWindow(hwnd)`|UnPins the specified window|
|`IsPinnedWindow(hwnd)`|Returns 1 if pinned, 0 if not pinned, -1 if not valid|
|`PinApp(hwnd)`|Pins the specified app(making it stay in all desktops)|
|`UnPinApp(hwnd)`|UnPins the specified app|
|`IsPinnedApp(hwnd)`|Returns 1 if pinned, 0 if not pinned, -1 if not valid|

## Set a background for each desktop:
| Functions  |  Description |
| :------------ | :------------ |
|`SetBackgroundOnDesktop(desktop_number, path)`|Sets the background of a particular desktop<br/>Parameter `path`: You can put in it one of 2 things:<br/>1. The path to an image<br/>2. The path to a folder with only images on it, and it will take a random one from it, for example `SetBackgroundOnDesktop(1,"C:\Personalizing Windows\Wallpapers\For desktop 1\")`, don´t forget to put an "\" at the end<br/><br/>Note: you can give to it a folder path and have only one image in it, that way when you decide to change the wallpaper you have to interact with the folder and not with the code|
|`SetDefaultBackground(path)`|For example if you didn't set up the background with `SetBackgroundOnDesktop(desktop_number, path)` in desktop 4, the background will be the default one that you set here, the parameter `path` works exactly the same as the function above|

Note: The wallpaper does not changes instantly(takes 200 ms?), windows was not made with this feature in mind so this is my best try

## Misc:
| Functions  |  Description |
| :------------ | :------------ |
|`AltTabOnSwitch(bool)`|If `True` when you go to another desktop and everything is minimized it will automaticaly alt+tab(it does not send the keystrokes Alt+Tab because I tryed and looks bad and has bugs, the script imitates alt tab, does not use it)|
|`CallFunctionOnDesktopSwitch(bool)`|If `True` calls a funcion named `OnDesktopSwitch()` each time the desktop changes, if `True` then YOU need to create that funcion`OnDesktopSwitch()` and add to it what you want to happen every time the desktop changes<br/>If `False` stops calling that function|
|`OpenDesktopManager()`|Opens desktop manager, if you call it again it closes it|
|`OpenAltTab()`|Same as Ctrl+Alt+Tab|
|`FocusLast()`|Like Alt+Tab, but does not press Alt+Tab, it's an ahk imitation|
|`ShowHideDesktop()`|Show/hide desktop, Sends Win+D|


## Usefull Built in Functions:
Meant to make it easier<br/>
### Hwnd
| Functions  |  Description |
| :------------ | :------------ |
|`GetActiveHwnd()`|Returns the hwnd of the active window|
|`CopyActiveHwnd()`|Copies into the clipboard the hwnd of the active window|
|`IsHwndActive(hwnd)`|Returns `True` if is active and `False` if not, you have to give it a `hwnd` as a parameter|
### Exe
| Functions  |  Description |
| :------------ | :------------ |
|`GetActiveExe()`|Returns the exe of the active window|
|`CopyActiveExe()`|Copies into the clipboard the exe of the active window|
|`IsExeActive(exe)`|Returns `True` if is active and `False` if not, you have to give it an `exe` as a parameter|
### Class
| Functions  |  Description |
| :------------ | :------------ |
|`GetActiveClass()`|Returns the class of the active window|
|`CopyActiveClass()`|Copies into the clipboard the class of the active window|
|`IsClassActive(class)`|Returns `True` if is active and `False` if not, you have to give it a `class` as a parameter|
### Title
| Functions  |  Description |
| :------------ | :------------ |
|`GetActiveTitle()`|Returns the title of the active window|
|`CopyActiveTitle()`|Copies into the clipboard the title of the active window|
|`IsTitleActive(title)`|Returns `True` if is active and `False` if not, you have to give it a `windowTitle` as a parameter|

# Working AHK Example:
I put a bunch of hotkeys together so you can test it for yourself, with escape you exit
```autohotkey
#Include lib\AHK-Virtual-Desktop-Library\Main.ahk

GoToDesktop(2) ; tip: if you call this at the beginning of your script and if you start it with windows, you will start windows always on the desktop you want

; You can use this to have your favourite programs in the desktops you want:
; try opening paint with this script running, it will open in desktop 3:
AlwaysOpenOnDesktopNumber(3,"mspaint.exe")
; try opening notepad with this script running, it will open in desktop 1 and also go to it:
AlwaysOpenOnDesktopNumberAndGo(1,"Notepad.exe")

q::GoToPrevDesktop()
w::GoToNextDesktop()
e::OpenDesktopManager() ; press again to close

1::GoToDesktop(1)
2::GoToDesktop(2)
3::GoToDesktop(3)

z::
currentDesktop := GetCurrentDesktop()
MsgBox, You are on desktop number %currentDesktop%
return

x::MoveCurrentWindowToDesktop(3)
; x::MoveCurrentWindowToDesktopAndGo(3)

a::CallFunctionOnDesktopSwitch(true) ; If true calls a funcion named OnDesktopSwitch(), is not obligatory to use

OnDesktopSwitch(){
	MsgBox, I run every time the desktop changes, I stop with the key "s"
}

s::CallFunctionOnDesktopSwitch(false) ; stops calling OnDesktopSwitch()

; to get the hwnd and exe easier:
r::CopyActiveHwnd() ; thats it, just paste it wherever you want
y::CopyActiveExe()

;Pin current window(remember to unpin)
f::
activeHwnd := GetActiveHwnd() ; you can use the built in function GetActiveHwnd() to get the active hwnd
PinWindow(activeHwnd)
return

;UpPin current window
g::
activeHwnd := GetActiveHwnd() ; you can use the built in function GetActiveHwnd() to get the active hwnd
UnPinWindow(activeHwnd)
return

Escape::ExitApp
```
# Usefull ideas to use this library:
- Go to the next/prev desktop when the mouse touches the left/right side of the screen
- Move a window to the next/prev desktop when dragged to the left/right side of the screen, and to snap them to the sides use [Microsoft PowerToys](https://github.com/microsoft/PowerToys "PowerToys")(in Youtube there's demos of PowerToys)
- When you go to another desktop and everything is minimized automaticaly focus the last minimized window with this function `AltTabOnSwitch(True)`[Function in this table](https://github.com/adrian88888888/AHK_Virtual_Desktop_Library/#misc "Function in this table")
- Have your favourite programs open always in the desktops you want(no matter how you open them) with the [Function in this table](https://github.com/adrian88888888/AHK_Virtual_Desktop_Library/#open-specified-program-on-desired-desktop-every-time "Function in this table")
- Pressing a key and moving the mouse to one corner will `OpenDesktopManager()`[Function in this table](https://github.com/adrian88888888/AHK_Virtual_Desktop_Library/#misc "Function in this table")
- XButton2(also called 5th mouse button or button foward in the mouse) to `FocusLast()`([Function in this table](https://github.com/adrian88888888/AHK_Virtual_Desktop_Library/#misc "Function in this table")) without sending the keystroke alt+tab

If you have any usefull way you use this library and is not in this list, please open an isue and tell me so i add it to this list, that way i hope between everyone we get a good list<br/>
I also put only original ideas, pressing 1,2,3 to go to desktop 1,2,3 its not going to be here

# Installation:
Note: This DLL and library works only on 64 bit Windows 10 and it was tested with 1809 build 17663, it was done with ahk v1<br/>
1. You probably need [VS 2017 runtimes vc_redist.x64.exe and/or vc_redist.x86.exe](https://support.microsoft.com/en-us/help/2977003/the-latest-supported-visual-c-downloads "VS 2017 runtimes vc_redist.x64.exe and/or vc_redist.x86.exe") if they are not installed already
2. Download the folder lib
3. Put it in the same folder as your script
4. You should end up with:

```
Your script folder
├── lib
│    ├── AHK-Virtual-Desktop-Library
│    ├── Other Library if you have
│    ├── Other Library if you have
│    └──...
└── Your Script Here.ahk
```

5. Then include the library in your script like this:

```autohotkey
#Include lib\AHK-Virtual-Desktop-Library\Main.ahk
```
Note: If you want to modify the structure in the Main.ahk put the dir of the VirtualDesktopAccessor.dll right again<br/><br/>
6. I really recomend deactivating the animation of changing desktops, they are enemies of instant responsiveness, try it for a while, to do so:<br/>
Win+r > sysdm.cpl > enter > advanced options > performance > configuration > uncheck the "Animate windows when minimizing and maximizing" > apply > ok

# Credits:
I want to thank Ciantic(Jari Pennanen) because he did the .dll that connects to Windows, thats black magic for me, so thanks<br/>
Ciantic: https://github.com/Ciantic/VirtualDesktopAccessor<br/>

Thanks to lschwahn because he did a complex program and I took ideas from his code<br/>
lschwahn: https://github.com/lschwahn/win-10-virtual-desktop-enhancer<br/>

As a newbie I couldn't find something easy to use, something ready to go, something with documentation, so here it is, I also added more than 20 of my own functions

Credits to Fanatic Guru for the [[Class] WinHook](https://www.autohotkey.com/boards/viewtopic.php?t=59149 "[Class] WinHook")

Thanks SKAN for the [function that copies to the clipboard](https://www.autohotkey.com/boards/viewtopic.php?f=6&t=80706&hilit=SetClipboardHTML")

Also thanks to tom-bowles for a "bug fix" [here](https://github.com/Ciantic/VirtualDesktopAccessor/issues/4 "here"), it was really usefull

Thanks to Icarus for half of the `IsFullScreenMode()` function [here](https://autohotkey.com/board/topic/38882-detect-fullscreen-application/ "here")

`GetAltTabList()` took from [here](https://www.autohotkey.com/boards/viewtopic.php?t=46069 "here")

Thanks to itzjakm for his idea of being able to pick a random image from a folder to set it as a wallpaper

And thanks to the ahk community
