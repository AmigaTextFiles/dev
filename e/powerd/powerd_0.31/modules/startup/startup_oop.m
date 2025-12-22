GOPT	HEAD='startup_oop.o'

MODULE	'dos','exec','intuition','graphics','oop'

EDEF	ExecBase:PTR TO ExecBase,DOSBase:PTR TO Lib,IntuitionBase:PTR TO Lib,GfxBase:PTR TO Lib,OOPBase:PTR TO Lib,arg:PTR TO CHAR,stdout,stdin,wbmessage
