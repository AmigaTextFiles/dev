/* pAmiga_stdSemaphores.e
	An Amiga-only equivalent to 'std/pSemaphores' which does not need OPT MULTITHREADED.
	This is basically a work-around until OPT MULTITHREADED can be used in modules that require it.
*/
OPT POINTER
MODULE 'exec', 'exec/semaphores'

TYPE SEMAPHORE IS PTR

PRIVATE
OBJECT semaphore
	ss:ss
ENDOBJECT
PUBLIC

PROC NewSemaphore() RETURNS sem:SEMAPHORE
	sem := NewR(SIZEOF semaphore)
	InitSemaphore(sem::semaphore.ss)
ENDPROC

PROC DisposeSemaphore(sem:SEMAPHORE) RETURNS nil:SEMAPHORE
	nil := Dispose(sem)
ENDPROC

PROC SemLock(sem:SEMAPHORE)
	ObtainSemaphore(sem::semaphore.ss)
ENDPROC

PROC SemUnlock(sem:SEMAPHORE)
	ReleaseSemaphore(sem::semaphore.ss)
ENDPROC

PROC SemTryLock(sem:SEMAPHORE) RETURNS success:BOOL
	success := AttemptSemaphore(sem::semaphore.ss) <> 0
ENDPROC
