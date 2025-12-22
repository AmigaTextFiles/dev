OPT MODULE
OPT EXPORT
OPT REG=5

MODULE 'exec/nodes','intuition/screens','exec/lists'


PROC getPubScreenNode(screen)
DEF pubnode:PTR TO pubscreennode,name,pubcopy:PTR TO pubscreennode
IF (pubcopy:=New(SIZEOF pubscreennode))
    IF (pubnode:=LockPubScreenList())
       pubnode:=pubnode::lh.head
       WHILE pubnode
	   EXIT pubnode.screen=screen
	   pubnode:=pubnode.ln.succ
       ENDWHILE
       IF pubnode
	  CopyMem(pubnode,pubcopy,SIZEOF pubscreennode)
	  IF (name:=New(StrLen(pubnode.ln.name)+2))
	     AstrCopy(name,pubnode.ln.name,ALL)
	     pubcopy.ln.name:=name
	  ELSE
	     pubnode:=NIL
	  ENDIF
       ENDIF
       UnlockPubScreenList()
       IF pubnode=NIL
	  Dispose(pubcopy)
	  pubcopy:=NIL
       ENDIF
    ENDIF
ENDIF
ENDPROC pubcopy

PROC freePubScreenNode(pubnode:PTR TO pubscreennode)
    Dispose(pubnode.ln.name)
    Dispose(pubnode)
ENDPROC

