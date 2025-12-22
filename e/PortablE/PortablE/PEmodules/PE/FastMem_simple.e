OPT NATIVE, INLINE
MODULE 'target/PE/base'

/*NATIVE {FastNew}*/
PROC FastNew(size, noClear=FALSE:BOOL) RETURNS mem:ARRAY REPLACEMENT
	mem := New(size, noClear)
	IF mem = NIL THEN Raise("MEM")
ENDPROC

/*NATIVE {FastDispose}*/
PROC FastDispose(mem:ARRAY, size) REPLACEMENT
	size BUT Dispose(mem)
ENDPROC NILA

PROC FastVerify(quiet=FALSE:BOOL) RETURNS failed:BOOL REPLACEMENT
	quiet := FALSE	->dummy
	failed := FALSE
ENDPROC

PROC FastReport(quiet=FALSE:BOOL) RETURNS leakSize, leakCount, unusedSize, unusedCount, poolCount REPLACEMENT
	quiet := FALSE	->dummy
	leakSize := leakCount := unusedSize := unusedCount := poolCount := 0
ENDPROC

