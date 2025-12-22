GOPT	HEAD='warpup.o',CPU=603

MODULE	'dos','exec','intuition','graphics','powerpc'

EDEF	ExecBase:PTR TO ExecBase,DOSBase:PTR TO Lib,IntuitionBase:PTR TO Lib,GfxBase:PTR TO Lib,arg:PTR TO CHAR,stdout,stdin,PowerPCBase:PTR TO Lib,wbmessage
