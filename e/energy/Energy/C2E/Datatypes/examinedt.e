/*
 * examinedt.e
 * Shows how to examine a file using datatypes.library
 * Written by Marco Talamelli
 *
 */

OPT OSVERSION=39

MODULE  'exec/types',
	'exec/memory',
	'exec/libraries',
	'dos/rdargs',
	'dos/dos',
	'dos/dosextens',
	'datatypes/datatypes',
	'datatypes',
	'datatypes/datatypesclass',
	'libraries/iffparse',
	'iffparse'

ENUM	OPT_NAME,OPT_MAX

PROC main()

DEF 	dth:PTR TO datatypeheader,
    	dtn:PTR TO datatype,
    	buffer[6]:STRING,
    	lock,
    	options:PTR TO LONG,
    	rdargs:PTR TO rdargs,names:PTR TO LONG

options:=[0,0]

	/* Parse the arguments */
	IF (rdargs := ReadArgs('NAMES/M/A', options, NIL))

	    /* Open the libraries */
	  IF (datatypesbase := OpenLibrary('datatypes.library', 39))
	      IF (iffparsebase := OpenLibrary('iffparse.library', 39))

		    /* Get a pointer to the name array */
		    names := options[OPT_NAME]

		    /* Step through the name array */
		    WHILE ^names

			/* Lock the current name */
			IF (lock := Lock(^names, ACCESS_READ))

			    /* Determine the DataType of the file */
			    IF (dtn := ObtainDataTypeA(DTST_FILE, lock, NIL))

				dth := dtn.header

				PrintF('informazioni su: \s\n', ^names)
				PrintF('    Descrizione: \s\n', dth.name)
				PrintF('      Base Nome: \s\n', dth.basename)
				PrintF('           Tipo: \s\n', GetDTString((dth.flags AND DTF_TYPE_MASK) + DTMSG_TYPE_OFFSET))
				PrintF('         Gruppo: \s\n', GetDTString(dth.groupid))
				PrintF('             ID: \s\n\n', IdtoStr(dth.id, buffer))

				/* Release the DataType */
				ReleaseDataType(dtn)
			    ELSE
				PrintFault(IoErr(), ^names)
			   ENDIF
			ELSE
			   PrintFault(IoErr(), ^names)
			ENDIF
			UnLock(lock)
			/* Prende il prossimo nome */
			names++
		   ENDWHILE

		    CloseLibrary(iffparsebase)
		ELSE
		  PrintF('couldn''t open iffparse.library V39\n')
		ENDIF
		CloseLibrary(datatypesbase)
	    ELSE
		PrintF('couldn''t open datatypes.library V39\n')
	    ENDIF
	/* Free the allocated memory after ReadArgs */
	FreeArgs(rdargs)
        ENDIF
ENDPROC
