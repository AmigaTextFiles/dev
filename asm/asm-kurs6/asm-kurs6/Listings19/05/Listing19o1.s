
; Listig19o1.s
; 
; (WinUAE 4.9.0 A500 configuration)
; Console-Debugger

dj [<level bitmask>] Enable joystick/mouse input debugging. 

;------------------------------------------------------------------------------
from https://www.markwrobel.dk/post/amiga-machine-code-letter11/

Before booting up the Amiga, make sure to enable debug logging in WinUAE under
properties. I have choosen to select "Log window", so that I can see the
updates in a separate window.
WinUAE/Settings/Paths/Debug logging	"Log window"


dj [<level bitmask>] Enable joystick/mouse input debugging. 

// 01 = host events
// 02 = joystick
// 04 = cia buttons
// 16 = potgo r/w
// 32 = vsync
// 128 = potgo write
// 256 = cia buttons write

;------------------------------------------------------------------------------	
																				; WinUAE/Settings/Paths/Debug logging	"Log window"
																				; enable "Log window"
																				; press Start
;------------------------------------------------------------------------------	
KS ver = 34 (0x22)																; Log Window with lot of information
Stored port 0/2 d=0: added 200 0 Windows mouse WINMOUSE1
Port0: COMBO 'Windows mouse' + 'WINMOUSE1' matched
Stored port 1/2 d=0: added 0 0
Stored port 1/2 d=0: added 0 0
Port1: ID 'kbd1' matched
....
PAL mode V=49.9204Hz H=15625.0879Hz (227x312+1) IDX=10 (PAL) D=0 RTG=0/0
ShowCursor 0


																				; Shift + F12 to get the prompt >
;------------------------------------------------------------------------------
>dj 2
Input logging level 2
>g
JOY0DAT=f84a 00fc0f94
JOY1DAT=0000 00fc0f94
...
																				; Shift + F12
;------------------------------------------------------------------------------
>dj 0																			; to break
Input logging level 0
>g
CPU tracer enabled
CPU tracer disabled
ShowCursor 0
