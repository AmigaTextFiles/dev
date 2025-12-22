/* alias module - The module used by OPT MULTITHREADED */
PUBLIC MODULE 'PE/pSemaphores'
->unneeded at the moment: PUBLIC MODULE 'PE/pThreadNode'

PROC OptMultiThreaded() RETURNS multiThreaded:BOOL REPLACEMENT
	RETURN TRUE
ENDPROC
