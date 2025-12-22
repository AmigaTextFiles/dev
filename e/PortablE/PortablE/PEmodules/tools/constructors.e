-> various constructors module

OPT POINTER, PREPROCESS

MODULE 'exec/lists', 'exec/nodes', 'exec/types'
MODULE 'exec'	->for AmigaOS4

PROC newlist(lh=NIL:PTR TO lh,type=0:UBYTE)
	IF lh=NIL THEN /*lh:=*/ NEW lh
	#ifdef pe_TargetOS_AmigaOS4
		NewList_exec(lh)
	#else
		lh.head:=lh.tail	->was: lh+4 !!PTR!!PTR TO ln
		lh.tailpred:=lh !!PTR!!PTR TO ln
		lh.tail:=NIL
		lh.pad:=0
	#endif
	lh.type:=type
ENDPROC lh

PROC newnode(ln=NIL:PTR TO ln,name=NILA:ARRAY OF CHAR,type=0:UBYTE,pri=0:BYTE)
	IF ln=NIL THEN /*ln:=*/ NEW ln
	ln.name:=name
	ln.pri:=pri
	ln.type:=type
ENDPROC ln
