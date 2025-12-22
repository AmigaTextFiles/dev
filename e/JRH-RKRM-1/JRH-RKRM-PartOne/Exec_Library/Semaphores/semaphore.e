-> semaphore.e - Exec semaphore example

MODULE 'exec/semaphores'

PROC main()
  DEF lockSemaphore:ss
  InitSemaphore(lockSemaphore)
  ObtainSemaphore(lockSemaphore)   -> Task now owns the semaphore.

  -> ...

  ReleaseSemaphore(lockSemaphore)  -> Task has released the semaphore.
ENDPROC
