/* PE/pThreadNode.e 12-09-09
   An efficient solution to thread-unsafe globals.
   
   By Christopher S Handley:
   26-06-09 - Implemented as part of a rewrite of FastMem, after discussions with Daniel Westerberg on reducing semaphore usage.
   15-08-09 - Moved out of FastMem, and into it's own module.
   12-09-09 - Changed module dependancies to make it's new() execute earlier.  Removed need for 'PE/ThreadNode_semaphore' module.
              Also changed to use pThreadNode prototypes.  Changed to use NewR() instead of New().  Capitalised procedures.
*/

OPT NATIVE, POINTER
MODULE 'PE/pSemaphores_prototypes'
MODULE 'target/PE/base', 'target/exec'
PUBLIC MODULE 'PE/pThreadNode_prototypes'

PRIVATE

DEF sem:SEMAPHORE

PUBLIC

PROC new()
	sem := NewSemaphore()
ENDPROC

PROC end()
	sem := DisposeSemaphore(sem)
ENDPROC


->OBJECT threadNode

->this finds/creates a threadNode object for the current thread
->NOTE: It must be passed a global static array of 1 item, i.e. from DEF threadNodes[1]:ARRAY OF PTR TO threadNode.
->NOTE: It must also be passed SIZEOF the child threadNode object you are using.
->NOTE: It returns the matching threadNode, which should be cast as the child threadNode object you are using.
->      This object is exclusive to your thread, and so can be safely read & modified.
PROC FindThreadNode(head:ARRAY OF PTR TO threadNode, sizeOfThreadNode) RETURNS match:PTR TO threadNode REPLACEMENT
	DEF threadID, localHead:PTR TO threadNode
	DEF node:PTR TO threadNode, threadNode:PTR TO threadNode, newThreadNode:OWNS PTR TO threadNode
	
	threadID := FindTask(NILA)		->this value can be anything unique to each thread, so this module need not be AmigaOS specific
	
	->search list for matching node
	threadNode := NIL
	IF localHead := head[0]
		node := localHead
		WHILE node.threadID <> threadID
			node := node.next
		ENDWHILE IF node = localHead
		
		IF node.threadID = threadID THEN threadNode := node
	ENDIF
	
	IF threadNode = NIL
		->(thread does not yet have a node) so add one to list
		newThreadNode := NewR(sizeOfThreadNode)
		threadNode := newThreadNode
		threadNode.threadID := threadID
		SemLock(sem)
		IF localHead := head[0]
			threadNode.next := /*PASS*/ localHead.next		->must *not* use PASS because this temporarily leaves the linked-list in an invalid state that could be seen by another thread
			localHead .next := PASS newThreadNode
		ELSE
			threadNode.next := PASS newThreadNode
			head[0] := threadNode
		ENDIF
		SemUnlock(sem)
	ENDIF
	->(have thread's node) so make it the head of the list, to optimise finding it next time
	head[0] := threadNode		->this assignment is assumed to be atomic!
	
	match   := threadNode
ENDPROC

->this deallocates all threadNode objects, so ensure that all threads are destroyed first!
PROC EndAllThreadNodes(head:ARRAY OF PTR TO threadNode) REPLACEMENT
	DEF node:OWNS PTR TO threadNode, next:OWNS PTR TO threadNode
	
	SemLock(sem)
	IF head[0]
		node := PASS head[0].next
		REPEAT
			next := PASS node.next
			Dispose(node)
			node := PASS next
		UNTIL node = NIL
		head[0] := NIL
	ENDIF
	SemUnlock(sem)
ENDPROC
