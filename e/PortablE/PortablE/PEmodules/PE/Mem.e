/* PE/Mem.e
   Implements New()/etc using any allocator, adding auto-deallocation upon program exit.
*/
OPT NATIVE, POINTER, INLINE, PREPROCESS
MODULE 'target/PE/base', 'PE/Mem_prototypes'

PRIVATE
OBJECT memNode
	next:PTR TO memNode	->circular
	prev:PTR TO memNode
ENDOBJECT

CONST ALIGN_SIZE    = SIZEOF VALUE	->must be a power of 2, and >= 4
CONST ALIGN_SIZE_M1 = ALIGN_SIZE - 1
#define AlignRoundUp(mem) ((mem) + ALIGN_SIZE_M1 AND NOT ALIGN_SIZE_M1)	->rounded up to a multiple of SIZEOF VALUE, so it is VALUE aligned

#define SIZEOF_memNode AlignRoundUp(SIZEOF memNode)	->memNode header must be rounded up (if it isn't already), so that the memory after it stays VALUE aligned

DEF memHead:PTR TO memNode, memTail:PTR TO memNode, memSem:SEMAPHORE
PUBLIC

PROC new()
	->a dummy allocation so that never have to deal with head or tail being NIL (nor removal of tail node)
	memHead := baseNew(SIZEOF_memNode) ; IF memHead = NIL THEN Raise("MEM")
	memHead.next := memHead
	memHead.prev := memHead
	memTail := memHead
	
	memSem := baseNewSemaphore()
ENDPROC

PROC end()
	DEF node:PTR TO memNode, next:PTR TO memNode
	
	->auto-deallocate anything remaining in the list
	next := memHead
	REPEAT
		node := next
		next := node.next
		
		baseDispose(node)
	UNTIL next = memHead
	memHead := NIL
	memTail := NIL
	
	memSem := baseDisposeSemaphore(memSem)
ENDPROC


PROC NewR(size, noClear=FALSE:BOOL) RETURNS mem:ARRAY REPLACEMENT
	mem := New(size, noClear)
	IF mem = NIL THEN Raise("MEM")
ENDPROC

PROC New(size, noClear=FALSE:BOOL) RETURNS mem:ARRAY REPLACEMENT
	DEF node:PTR TO memNode
	
	IF node := baseNew(size + SIZEOF_memNode, noClear)
		->add mem to head of linked list
		baseSemLock(memSem)
		node.prev := memTail
		node.next := memHead
		memTail.next := node
		memHead.prev := node
		memHead := node
		baseSemUnlock(memSem)
		
		->return mem without node header
		mem := node + SIZEOF_memNode
	ENDIF
ENDPROC

PROC Dispose(mem:ARRAY) REPLACEMENT
	DEF node:PTR TO memNode
	
	IF mem
		->retrieve node
		node := mem - SIZEOF_memNode
		
		->remove mem from linked list
		baseSemLock(memSem)
		node.next.prev := node.prev
		node.prev.next := node.next
		IF memHead = node THEN memHead := node.next
		baseSemUnlock(memSem)
		
		->finally perform deallocation
		baseDispose(node)
	ENDIF
ENDPROC NILA
