/* pAmigaWb.e 28-12-2012
	A collection of useful procedures/wrappers for the Workbench library.
	Copyright (c) 2012 Christopher Steven Handley ( http://cshandley.co.uk/email )
*/

PUBLIC MODULE 'wb'
MODULE 'exec'
MODULE 'CSH/pAmigaDos'

PROC new()
	workbenchbase := OpenLibrary('workbench.library', 0)
ENDPROC

PROC end()
	CloseLibrary(workbenchbase)
ENDPROC

/*****************************/

PROC strSafeGetProgramPath() RETURNS path:OWNS STRING
	DEF name:OWNS STRING, temp:OWNS STRING, dirLock:BPTR
	
	->retrieve our program's path
	IF wbmessage
		->(run from Workbench)
		path := IF wbmessage.numargs > 0 THEN pathOfWbArg(wbmessage.arglist[0]) ELSE NILS
	ELSE
		->(run from Shell)
		IF temp := strSafeGetProgramName()		->this is not guaranteed to be the full path (and probably isn't)
			name, path := splitPath(temp)
			END path
		ENDIF
		END temp
		
		IF dirLock := GetProgramDir()
			IF name THEN path := fullPath(dirLock, name)
		ENDIF
	ENDIF
FINALLY
	END name, temp
ENDPROC
