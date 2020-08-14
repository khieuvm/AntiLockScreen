#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=icon.ico
#AutoIt3Wrapper_UseUpx=y
#AutoIt3Wrapper_Res_Description=AntiLockScreen
#AutoIt3Wrapper_Res_Fileversion=3.0.1.1
#AutoIt3Wrapper_Res_ProductName=Khieudeptrai
#AutoIt3Wrapper_Res_CompanyName=TSDV
#AutoIt3Wrapper_Res_LegalCopyright=Copyright © KhieuVM
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <Misc.au3>
#include <MsgBoxConstants.au3>
#include <TrayConstants.au3>
#include <GUIConstants.au3>
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>

_Singleton(@ScriptName)

Opt("TrayMenuMode", 3)
Opt("TrayOnEventMode", 1) ; Enable TrayOnEventMode.
Opt("GUIOnEventMode", 1) ; Change to OnEvent mode

Global $lock = True

; Check if the registry key is already existing, so as not to damage the user's system.
RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run", "AntiLockScreen")

; @error is set to non-zero when reading a registry key that doesn't exist.
If @error Then
	; Write a single REG_SZ value.
	Local $sfilePath
	$sfilePath = @ScriptDir & "\" & @ScriptName
	RegWrite("HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run", "AntiLockScreen", "REG_SZ", $sfilePath)
EndIf


Local $idAbout = TrayCreateItem("Always on Display")
TrayItemSetOnEvent(-1, "Lock")

Local $idConfig = TrayCreateItem("Allows Lock Screen")
TrayItemSetOnEvent(-1, "Unlock")

Local $idExit = TrayCreateItem("Exit")
TrayItemSetOnEvent(-1, "OnExit")

TraySetState($TRAY_ICONSTATE_SHOW) ; Show the tray menu.
TraySetClick(16) ; Show the tray menu when the mouse if hovered over the tray icon.

TraySetToolTip("AntiLockScreen")
TraySetIcon("icon.ico")

Send("{SCROLLLOCK off}")

PressLock()

Func PressLock()
While True
	If @HOUR < 18 OR @HOUR > 9 Then
		If $lock = True Then
			Send("{SCROLLLOCK}")
			Sleep(20)
			Send("{SCROLLLOCK}")
		EndIf
	EndIf
	Sleep(20000)
WEnd
EndFunc

Func Lock()
    $lock = True
EndFunc

Func Unlock()
    $lock = False
EndFunc

Func OnExit()
    Exit
EndFunc