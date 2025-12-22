OPT EXPORT

/* some functions fit better as macros */

MACRO SetStdIn(in) IS (D1:=stdin) BUT (stdin:=in) BUT D1
MACRO SetStdOut(out) IS (D1:=stdout) BUT (stdout:=out) BUT D1
MACRO SetStdRast(rast) IS (D1:=stdrast) BUT (stdrast:=rast) BUT D1

MACRO OpenS(w,h,d,flags,title,taglist) IS Stores(w,h,d,flags,title,taglist) BUT ASM ' bsr PROC_OpenS'
MACRO OpenW(x,y,w,h,idcmp,wflags,title,screen,sflags,gadgets,taglist) IS Stores(x,y,w,h,idcmp,wflags,title,screen,sflags,gadgets,taglist) BUT ASM ' bsr PROC_OpenW'

MACRO CloseS(scr) IS Stores(scr) BUT ASM ' bsr PROC_CloseS'
MACRO CloseW(win) IS Stores(win) BUT ASM ' bsr PROC_CloseW'

MACRO MsgCode() IS ASM ' bsr PROC_MsgCode'
MACRO MsgIAddr() IS ASM ' bsr PROC_MsgIAddr'
MACRO MsgQualifier() IS ASM ' bsr PROC_MsgQualifier'
MACRO WaitIMessage(win) IS Stores(win) BUT ASM ' bsr PROC_WaitIMessage'
MACRO WaitLeftMouse(win) IS Stores(win) BUT ASM ' bsr PROC_WaitLeftMouse'

MACRO Imp(fh) IS Stores(fh) BUT ASM ' bsr PROC_Imp'
MACRO Out(fh, char) IS Stores(char, fh) BUT ASM ' bsr PROC_Out'

