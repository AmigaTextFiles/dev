/* AmigaOS implementation of pSemaphores */
OPT NATIVE, POINTER
MODULE 'target/PE/base', 'target/exec', 'target/exec/semaphores'
PUBLIC MODULE 'PE/pSemaphores_prototypes'

PRIVATE
OBJECT semaphore
	ss:ss
ENDOBJECT
PUBLIC

PROC NewSemaphore() RETURNS sem:SEMAPHORE REPLACEMENT
	sem := NewR(SIZEOF semaphore)
	InitSemaphore(sem::semaphore.ss)
ENDPROC

PROC DisposeSemaphore(sem:SEMAPHORE) RETURNS nil:SEMAPHORE REPLACEMENT
	nil := Dispose(sem)
ENDPROC

PROC SemLock(sem:SEMAPHORE) REPLACEMENT
	ObtainSemaphore(sem::semaphore.ss)
ENDPROC

PROC SemUnlock(sem:SEMAPHORE) REPLACEMENT
	ReleaseSemaphore(sem::semaphore.ss)
ENDPROC

PROC SemTryLock(sem:SEMAPHORE) RETURNS success:BOOL REPLACEMENT
	success := AttemptSemaphore(sem::semaphore.ss) <> 0
ENDPROC
