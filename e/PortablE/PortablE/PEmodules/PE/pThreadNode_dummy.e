/* dummy implementation of pThreadNode, for single-threaded programs */
OPT NATIVE, POINTER
MODULE 'target/PE/base'
PUBLIC MODULE 'PE/pThreadNode_prototypes'

PROC FindThreadNode(head:ARRAY OF PTR TO threadNode, sizeOfThreadNode) RETURNS match:PTR TO threadNode REPLACEMENT
	match := head[0]
	IF match = NIL
		head[0] := match := NewR(sizeOfThreadNode)
	ENDIF
ENDPROC

PROC EndAllThreadNodes(head:ARRAY OF PTR TO threadNode) REPLACEMENT
	head[0] := Dispose(head[0])
ENDPROC
