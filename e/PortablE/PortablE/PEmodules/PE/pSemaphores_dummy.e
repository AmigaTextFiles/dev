/* dummy implementation of pSemaphores, for single-threaded programs */
OPT NATIVE
MODULE 'target/PE/base'
PUBLIC MODULE 'PE/pSemaphores_prototypes'

PROC NewSemaphore() RETURNS sem:SEMAPHORE REPLACEMENT
	sem := NIL
ENDPROC

PROC DisposeSemaphore(sem:SEMAPHORE) RETURNS nil:SEMAPHORE REPLACEMENT
	sem := NIL
	nil := NIL
ENDPROC

PROC SemLock(sem:SEMAPHORE) REPLACEMENT
	sem := NIL
ENDPROC

PROC SemUnlock(sem:SEMAPHORE) REPLACEMENT
	sem := NIL
ENDPROC

PROC SemTryLock(sem:SEMAPHORE) RETURNS success:BOOL REPLACEMENT
	sem := NIL
	success := TRUE
ENDPROC
