
	/* opta.e */

MODULE 	'dos/dos',
	'dos/dosextens',
	'exec/memory'

PROC main()

DEF	oldlock:PTR TO filelock
   	
		/* fissa un lock di lettura sulla directory corrente */
	
   		oldlock := Lock('',ACCESS_READ)
   		IF (oldlock <> 0)
      			followthread(oldlock,0)
   		ELSE
      			WriteF('\n Non posso fissare un lock sulla directory corrente')
   		ENDIF
	WriteF('\n')

ENDPROC
	
	/* Ora scende ricorsivamente lungo le directory listandole e listandone i contenuti*/
	
PROC followthread(lock:PTR TO filelock,tab_level=0)   
	
DEF	m:PTR TO fileinfoblock,
   	newlock:PTR TO filelock,
	oldlock:PTR TO filelock,
	ignoredlock:PTR TO filelock,
   	success,i
  	 
   	    		/* se è arrivato in fondo npn stampa nulla */
   	    IF (lock)=FALSE THEN RETURN 0   

	    		/* alloca spazio per un fileinfoblock */

   	    m := AllocMem(SIZEOF fileinfoblock,MEMF_CLEAR)
	
   	    success := Examine(lock,m)
  	 
   			/* la prima chiamata di examine riempie la 							 * FileInfoBlock con le informazioni riguardanti la 
			 * directory. Se si trova al primo livello stampa
			 * il nome del disco.
		  	 */
	
   	    WHILE (success <> 0)

      		IF (m.direntrytype > 0)

	 		/* sè è una directory, prendere un lock su di essa e 
			 * entra all'interno per elencare i suoi contenuti come pure il 
			 * nome delle directory */
	
         	newlock := Lock(m.filename,ACCESS_READ)
	
	 		/* Se il lock è valido rende questa directory
			   quella corrente ma salva il valore del
			   lock precedente 				
			*/
	
	 	oldlock := CurrentDir(newlock)	/* si sposta in tale directory */
	
	 		/* fa la stessa cosa ricorsivamente sino in fondo */

         	followthread(newlock,tab_level+1)
	
	 		/* dopo aver listato il contenuto della nuova directory torna qui */

	 	ignoredlock := CurrentDir(oldlock)  /* e procede */
      		ENDIF
		success := ExNext(lock, m)	/* esamina la prossima */
      		IF (success)

	      		WriteF('\n')
	      		FOR i:=0 TO i<tab_level DO WriteF('\t')
		/* opera un tab per mostare il livello della directory */
      	      		WriteF(m.filename)
              		IF (m.direntrytype > 0) THEN WriteF(' [dir]')	
				/* dice all'utente che è una directory */
     		ENDIF
   	     ENDWHILE

   	IF (lock) THEN UnLock(lock)
   	FreeMem(m,SIZEOF fileinfoblock)
ENDPROC
