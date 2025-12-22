OPT POINTER
MODULE 'target/exec'

PROC NewM(size,flags)
	DEF mem:ARRAY
	
	IF flags AND (MEMF_CHIP OR MEMF_FAST OR MEMF_PUBLIC OR MEMF_LOCAL OR MEMF_24BITDMA)
		Print('NewM() emulation was passed an unsupported flag\n')
		Raise("MEM")
	ENDIF
	
	mem := New(size)
	IF mem = NIL THEN Raise("MEM")
ENDPROC mem
