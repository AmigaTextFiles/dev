;
; **********************************************
;
; Amiga ROM 3.1 RKM Includes files for PureBasic
;
; **********************************************
;
;

IncludePath   "PureInclude:"

XIncludeFile "exec/all.pb"
XIncludeFile "dos/all.pb"
XIncludeFile "graphics/all.pb"
XIncludeFile "intuition/all.pb"
XIncludeFile "utility/all.pb"
XIncludeFile "workbench/all.pb"
;XIncludeFile "prefs/all.pb"
;XIncludeFile "diskfont/all.pb"
;XIncludeFile "hardware/all.pb"
XIncludeFile "libraries/all.pb"
;XIncludeFile "gadgets/all.pb"
;XIncludeFile "rexx/all.pb"
;XIncludeFile "resources/all.pb"
;XIncludeFile "devices/all.pb"
;XIncludeFile "datatypes/all.pb"


;
; PureBasic Joypad constants definitions...
;

#PB_JOYPAD_BUTTON1 = 1 << 22
#PB_JOYPAD_BUTTON2 = 1 << 23
#PB_JOYPAD_BUTTON3 = 1 << 20
#PB_JOYPAD_BUTTON4 = 1 << 21
#PB_JOYPAD_BUTTON5 = 1 << 19
#PB_JOYPAD_BUTTON6 = 1 << 18
#PB_JOYPAD_BUTTON7 = 1 << 17

; Event constants
;

#PB_EventMenu          = #IDCMP_MENUPICK
#PB_EventCloseWindow   = #IDCMP_CLOSEWINDOW
#PB_EventGadget        = #IDCMP_GADGETUP
#PB_EventRepaint       = 0
#PB_EventMoveWindow    = #IDCMP_CHANGEWINDOW
#PB_EventSizeWindow    = #IDCMP_NEWSIZE
#PB_EventActivateWindow = #IDCMP_ACTIVEWINDOW

; Window flags
;

#PB_Window_CloseGadget    = #WFLG_CLOSEGADGET
#PB_Window_MinimizeGadget = 0
#PB_Window_MaximizeGadget = 0
#PB_Window_SizeGadget     = #WFLG_SIZEGADGET
