GOPT	HEAD='amigae.o'

MODULE	'dos','exec','intuition','graphics'

EDEF	execbase:PTR TO execbase,dosbase:PTR TO lib,intuitionbase:PTR TO lib,gfxbase:PTR TO lib,arg:PTR TO CHAR,stdout,stdin,wbmessage
