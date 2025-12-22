#ifndef POWERPC_PORTSPPC_H
#define POWERPC_PORTSPPC_H
#ifndef EXEC_PORTS_H
MODULE  'exec/ports'
#endif
#ifndef EXEC_LISTS_H
MODULE  'exec/lists'
#endif
#ifndef POWERPC_SEMAPHORESPPC_H
MODULE  'powerpc/semaphoresPPC'
#endif
OBJECT MsgPortPPC
 
	 Port:MsgPort
	 IntMsg:List
	 Semaphore:SignalSemaphorePPC
ENDOBJECT

#define NT_MSGPORTPPC 101
#endif
