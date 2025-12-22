OPT NATIVE, POINTER, FORCENATIVE
MODULE 'target/intuition', 'target/utility/tagitem', 'target/exec', 'target/graphics'

NATIVE {GADGETSIZE} CONST GADGETSIZE = 120

PROC SetColour(screen:PTR TO screen, colourreg:UBYTE, r:UBYTE, g:UBYTE, b:UBYTE) IS NATIVE {SetColour(} screen {,} colourreg {,} r {,} g {,} b {)} ENDNATIVE


PROC OpenW(x, y, width, height, idcmp, wflags, title:ARRAY OF CHAR, screen:PTR TO screen, sflags, gadgets:PTR TO gadget, taglist=NILA:ARRAY OF tagitem) IS NATIVE {OpenW(} x {,} y {,} width {,} height {,} idcmp {,} wflags {,} title {,} screen {,} sflags {,} gadgets {,} taglist {)} ENDNATIVE !!PTR TO window

PROC CloseW(wptr:PTR TO window) IS NATIVE {CloseW(} wptr {)} ENDNATIVE

PROC OpenS(width, height, depth, sflags, title:ARRAY OF CHAR, taglist=NILA:ARRAY OF tagitem) IS NATIVE {OpenS(} width {,} height {,} depth {,} sflags {,} title {,} taglist {)} ENDNATIVE !!PTR TO screen

PROC CloseS(sptr:PTR TO screen) IS NATIVE {CloseS(} sptr {)} ENDNATIVE

PROC Gadget(buffer:ARRAY, glist:ARRAY, id, flags, x, y, width, string:ARRAY OF CHAR) IS NATIVE {Gadget(} buffer {,} glist {,} id {,} flags {,} x {,} y {,} width {,} string {)} ENDNATIVE !!ARRAY

PROC Mouse() IS NATIVE {Mouse()} ENDNATIVE !!VALUE

PROC LeftMouse(win:PTR TO window) IS NATIVE {LeftMouse(} win {)} ENDNATIVE !!BOOL

PROC WaitLeftMouse(win:PTR TO window) IS NATIVE {WaitLeftMouse(} win {)} ENDNATIVE

PROC MouseX(win:PTR TO window) IS NATIVE {MouseX(} win {)} ENDNATIVE !!VALUE

PROC MouseY(win:PTR TO window) IS NATIVE {MouseY(} win {)} ENDNATIVE !!VALUE


PROC WaitIMessage(win:PTR TO window) IS NATIVE {WaitIMessage(} win {)} ENDNATIVE !!VALUE

PROC MsgCode() IS NATIVE {MsgCode()} ENDNATIVE !!VALUE

PROC MsgQualifier() IS NATIVE {MsgQualifier()} ENDNATIVE !!VALUE

PROC MsgIaddr() IS NATIVE {MsgIaddr()} ENDNATIVE !!APTR

