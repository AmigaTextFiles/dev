GOPT	HEAD='startup_ieee.o',NOFPU,NOSTD

MODULE	'dos','exec','intuition','graphics'	//,'mathieeedoubbas','mathieeedoubtrans'
MODULE	'lib/powerd_ieee'

EDEF	DOSBase,args:PTR TO CHAR,stdout,stdin,IntuitionBase,GfxBase,MathIEEEDoubTransBase,MathIEEEDoubBasBase,ExecBase:PTR TO ExecBase,wbmessage
