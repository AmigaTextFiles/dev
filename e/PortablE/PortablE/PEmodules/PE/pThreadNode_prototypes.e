/* prototypes of pThreadNode */
OPT NATIVE, INLINE
MODULE 'target/PE/base'

OBJECT threadNode
	threadID
	next:/*OWNS*/ PTR TO threadNode	->circular list
ENDOBJECT

PROC FindThreadNode(head:ARRAY OF PTR TO threadNode, sizeOfThreadNode) RETURNS match:PTR TO threadNode PROTOTYPE IS EMPTY

PROC EndAllThreadNodes(head:ARRAY OF PTR TO threadNode) PROTOTYPE IS EMPTY
