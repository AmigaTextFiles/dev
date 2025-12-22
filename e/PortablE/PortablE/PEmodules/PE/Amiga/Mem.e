/* AmigaOS implementation needed by PE/Mem */
OPT INLINE, POINTER
OPT PREPROCESS
MODULE 'target/PE/base', 'PE/Mem_prototypes'
MODULE 'target/exec', 'target/exec/semaphores', 'target/utility/tagitem'

PROC baseNew(size, noClear=FALSE:BOOL) RETURNS mem:ARRAY REPLACEMENT
	#ifdef pe_TargetOS_AmigaOS4
		IF OptMultiThreaded()
			mem := AllocVecTagList(size, [
				AVT_TYPE,MEMF_SHARED,
				AVT_LOCK,FALSE,
				IF noClear THEN TAG_IGNORE ELSE AVT_CLEARWITHVALUE,0,
			TAG_END]:tagitem)
		ELSE
			mem := AllocVec(size, MEMF_PRIVATE OR IF noClear THEN 0 ELSE MEMF_CLEAR)
		ENDIF
	#else
		mem := AllocVec(size, MEMF_PUBLIC OR IF noClear THEN 0 ELSE MEMF_CLEAR)
	#endif
ENDPROC

PROC baseDispose(mem:ARRAY) REPLACEMENT
	FreeVec(mem)
ENDPROC


PRIVATE
OBJECT memSemaphore
	ss:ss
ENDOBJECT
PUBLIC

PROC baseNewSemaphore() RETURNS sem:SEMAPHORE REPLACEMENT
	sem := baseNew(SIZEOF memSemaphore)
	IF sem = NIL THEN Throw("MEM", 'baseNewSemaphore(); allocation failed')
	InitSemaphore(sem::memSemaphore.ss)
ENDPROC

PROC baseDisposeSemaphore(sem:SEMAPHORE) RETURNS nil:SEMAPHORE REPLACEMENT
	baseDispose(sem)
	nil := NIL
ENDPROC

PROC baseSemLock(sem:SEMAPHORE) REPLACEMENT
	ObtainSemaphore(sem::memSemaphore.ss)
ENDPROC

PROC baseSemUnlock(sem:SEMAPHORE) REPLACEMENT
	ReleaseSemaphore(sem::memSemaphore.ss)
ENDPROC
