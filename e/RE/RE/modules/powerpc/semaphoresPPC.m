#ifndef POWERPC_SEMAPHORESPPC_H
#define POWERPC_SEMAPHORESPPC_H
#ifndef EXEC_SEMAPHORES_H
MODULE  'exec/semaphores'
#endif

OBJECT SignalSemaphorePPC
 
         SS:SignalSemaphore
        reserved:LONG                    
        lock:UWORD                       
ENDOBJECT


#define SSPPC_SUCCESS      -1
#define SSPPC_NOMEM        0

#define ATTEMPT_SUCCESS   -1
#define ATTEMPT_FAILURE   0
#endif
