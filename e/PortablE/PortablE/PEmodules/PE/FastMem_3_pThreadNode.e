/* PE/FastMem.e 10-12-11
   A re-implementation of AmigaE's fast memory functions, but made thread-safe.
   
   By Christopher S Handley.
   06-01-08 - Completed and put in the Public Domain, based upon Tomasz Wiszkowski's description of how AmigaE implemented it.
   02-04-08 - Replaced "NEW" by "MEM".
   12-10-08 - Replaced Shr() by SHR.
   11-03-09 - Fixed memory alignment issue reported by Daniel Westerberg.
   31-03-09 - Made thread-safe using semaphores, with help from Daniel Westerberg.
   26-06-09 - Nearly eliminated semaphore usage, by greatly reducing shared global state, after discussions with Daniel Westerberg.  Changed to use FastMem prototypes.
   15-08-09 - Moved thread-hiding code into a separate module (ThreadNode).
   10-12-11 - Added dummy FastVerify() procedure, so it can compile again.  Also fixed wrong pThreadNode module being used, so it can compile again.
*/

OPT NATIVE, INLINE, POINTER
MODULE 'target/PE/base', 'PE/pThreadNode_prototypes'

PRIVATE

CONST MAX_FAST_SIZE = 256			->must be a multiple of 4
CONST HEADER_SIZE = SIZEOF BYTE
CONST ALIGN_SIZE  = SIZEOF VALUE	->must be a power of 2, and >= 4

CONST ALIGN_SIZE_M1 = ALIGN_SIZE - 1
CONST MISALIGN_FOR_HEADER = ALIGN_SIZE - HEADER_SIZE

OBJECT fastMemThreadNode OF threadNode
	freeListArray[MAX_FAST_SIZE/4+1]:ARRAY OF ARRAY
	chopMem:ARRAY
	chopLeft
ENDOBJECT

DEF threadNodes[1]:ARRAY OF PTR TO threadNode

PROC end()
	EndAllThreadNodes(threadNodes)
ENDPROC

PUBLIC


PROC FastNew(size, noClear=FALSE:BOOL) RETURNS mem:ARRAY REPLACEMENT
	DEF index:BYTE, threadNode:PTR TO fastMemThreadNode
	
	IF size <= 0 THEN Raise("MEM")
	
	size := size + HEADER_SIZE
	IF size > MAX_FAST_SIZE
		mem := NewR(size + MISALIGN_FOR_HEADER, noClear) + MISALIGN_FOR_HEADER	->mis-align memory, so that header re-aligns it
		index := 0
	ELSE
		size := (size + ALIGN_SIZE_M1) AND NOT ALIGN_SIZE_M1		->round-up to a multiple of ALIGN_SIZE
		index := size SHR 2 !!BYTE
		
		threadNode := FindThreadNode(threadNodes, SIZEOF fastMemThreadNode)::fastMemThreadNode
		
		mem := threadNode.freeListArray[index]
		IF mem <> NILA
			threadNode.freeListArray[index] := GetArray(mem!!VALUE!!PTR TO ARRAY)		->move to next item in singly-linked-list
		ELSE
			IF (threadNode.chopMem = NILA) OR (threadNode.chopLeft < size)
				threadNode.chopLeft := 65536
				threadNode.chopMem  := NewR(threadNode.chopLeft + MISALIGN_FOR_HEADER, /*noClear=*/ TRUE) + MISALIGN_FOR_HEADER	->mis-align memory, so that header re-aligns it
				->memory will be freed automagically upon exit
			ENDIF
			
			mem := threadNode.chopMem
			threadNode.chopMem  := threadNode.chopMem  + size
			threadNode.chopLeft := threadNode.chopLeft - size
		ENDIF
		
		IF noClear = FALSE THEN NATIVE {memset(} mem {, 0,} size {)} ENDNATIVE
	ENDIF
	PutByte(mem!!VALUE!!PTR TO BYTE, index)
	mem := mem + HEADER_SIZE	->memory is now aligned
ENDPROC

PROC FastDispose(mem:ARRAY, size) REPLACEMENT
	DEF index:BYTE, threadNode:PTR TO fastMemThreadNode
	
	IF mem
		IF (size <= 0) AND (size <> -999) THEN Throw("MEM", 'FastDispose(); size<=0')
		
		mem   := mem - HEADER_SIZE
		index := GetByte(mem!!VALUE!!PTR TO BYTE)
		
		IF size <> -999
			size := size + HEADER_SIZE
			IF size > MAX_FAST_SIZE
				IF index <> 0 THEN Throw("MEM", 'FastDispose(); wrong size supplied or memory header corrupted')
			ELSE
				size := (size + ALIGN_SIZE_M1) AND NOT ALIGN_SIZE_M1
				IF index <> (size SHR 2) THEN Throw("MEM", 'FastDispose(); wrong size supplied or memory header corrupted')
			ENDIF
		ENDIF
		
		IF index = 0
			Dispose(mem - MISALIGN_FOR_HEADER)
		ELSE
			threadNode := FindThreadNode(threadNodes, SIZEOF fastMemThreadNode)::fastMemThreadNode
			
			PutArray(mem!!VALUE!!PTR TO ARRAY, threadNode.freeListArray[index])
			threadNode.freeListArray[index] := mem
		ENDIF
	ENDIF
ENDPROC NILA

PROC FastVerify(quiet=FALSE:BOOL) RETURNS failed:BOOL REPLACEMENT
	quiet := FALSE	->dummy
	failed := FALSE
ENDPROC
