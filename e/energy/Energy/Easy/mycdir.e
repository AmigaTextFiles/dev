
/* mycdir.e */

MODULE 'dos/dos','dos/dosextens'

PROC main()

DEF success,lock:PTR TO filelock, oldlock:PTR TO filelock

	/* fissa un puntatore a una determinata directory */

	lock := Lock('c:', ACCESS_READ)
	IF (lock = 0) THEN WriteF('\nNon posso fissare un lock su C: directory\n')

	/* ci spostiamo nella directory per farne un list */
	
	oldlock := CurrentDir(lock)

	success := Execute('dir',0,0) /* lista della directory */

	/*ci spostiamo nella directory originale */

	oldlock := CurrentDir(oldlock)

	/* Unlock what we obtained from Lock() */

	/* Nota bene: non si operi un UnLock su nulla che sia
	  stato ottenuto con CurrentDir... questo farebbe scomparire
	  il disco dal sistema agli occhi del DOS.
	  Si sblocchi solo ciò che è stato ottenuto da Loch e DupLock.
	 */
	UnLock(lock)
ENDPROC
