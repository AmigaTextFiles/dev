/* alias module - The module used when NOT using OPT MULTITHREADED */
MODULE 'target/PE/base'
PUBLIC MODULE 'PE/pSemaphores_dummy'
->unneeded at the moment: PUBLIC MODULE 'PE/pThreadNode_dummy'

PROC OptMultiThreaded() RETURNS multiThreaded:BOOL REPLACEMENT
	RETURN FALSE
ENDPROC
