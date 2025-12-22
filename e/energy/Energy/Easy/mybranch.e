
	/* mydir.e */

MODULE 'dos/dos','dos/dosextens','exec/memory'

->	extern struct FileLock *Lock(),*DupLock(),*ParentDir()

PROC main()

DEF oldlock:PTR TO filelock -> fissa un Lock di scrittura sulla directory corrente

   	oldlock := Lock('',ACCESS_READ)
	
   		IF (oldlock <> 0)

       			WriteF('\nPath  della directory corrente: ')
		
       		/* non scrive lo slash se si trova al livello minimo*/
       			followpath(oldlock,0)
    		ELSE
       			WriteF('\n Non posso operare un lock sulla directory corrente\n')
		ENDIF
	WriteF('\n')
	ENDPROC

PROC followpath(lock:PTR TO filelock,printslash)	

DEF 	myinfo:PTR TO fileinfoblock,
	newlock:PTR TO filelock,
	success,error
		
	/* se raggiunge la fine non stampa nulla */

	IF (lock)=NIL THEN RETURN 0	
	
		myinfo :=  AllocMem(SIZEOF fileinfoblock,MEMF_CLEAR)
		IF (myinfo = 0) 
			WriteF('out of memory\n')
			RETURN 0
		ENDIF 	
		/* guarda se esiste una directory superiore  */
		newlock := ParentDir(lock)
		error := IoErr()   

   	/* newlock può fallire o per un errore o perché	qualcuno ha rimosso il disco */

		IF ((newlock = 0) AND (error <> 0)) THEN
  			WriteF('\n DISK I/O ERROR!  value = \d\n',error)
		
		/* richiama la funzione ricorsivamente sino alla directory primaria */

		followpath(newlock,1)
		
		
		success := Examine(lock, myinfo)
		IF (success) THEN WriteF('\s',myinfo.filename)
   			IF (newlock = 0) 
      				WriteF(':')
   			ELSE
		/* stampa lo slash solo se il parametro non è zero */
				IF (printslash) THEN WriteF('/')
			ENDIF
   		UnLock(lock)
		IF (myinfo) THEN FreeMem(myinfo, SIZEOF fileinfoblock)
		RETURN 1
ENDPROC
