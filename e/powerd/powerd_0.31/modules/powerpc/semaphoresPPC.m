MODULE 'exec/semaphores'
/* SignalSemaphorePPC structure used by PPC semaphore functions */

OBJECT SignalSemaphorePPC
  SS:SignalSemaphore,
  reserved:APTR,          /* private */
  lock:UWORD             /* private */

/* return value from InitSemaphore and AddSemaphore */
ENUM SSPPC_SUCCESS=-1,
 SSPPC_NOMEM
/* return values of AttemptSemaphore */
ENUM ATTEMPT_SUCCESS=-1,
 ATTEMPT_FAILURE
/* status returned by AddUniqueSemaphorePPC */
ENUM UNISEM_SUCCESS=-1,
 UNISEM_NOTUNIQUE
