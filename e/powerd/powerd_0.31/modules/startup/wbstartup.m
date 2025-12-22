GOPT	HEAD='wbstartup.o',EXEICON

MODULE	'dos','exec','intuition','graphics'

EDEF	ExecBase:PTR TO ExecBase,DOSBase:PTR TO Lib,IntuitionBase:PTR TO Lib,GfxBase:PTR TO Lib,arg:PTR TO CHAR,stdout,stdin,wbmessage
