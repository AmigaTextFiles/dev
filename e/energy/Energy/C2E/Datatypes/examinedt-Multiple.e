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

ENUM	OPT_NAME,OPT_MAX,ERR_LIB,ERR_DT,ERR_LOCK

RAISE ERR_LIB  IF OpenLibrary()=NIL
RAISE ERR_DT   IF ObtainDataTypeA()=NIL
RAISE ERR_LOCK IF Lock()=NIL

PROC main() HANDLE

DEF 	dth:PTR TO datatypeheader,
    	dtn:PTR TO datatype,
    	buffer[6]:STRING,
    	lock,
    	options:PTR TO LONG,
    	rdargs:PTR TO rdargs,names:PTR TO LONG

options:=[0,0]

	/* Parse the arguments */
	rdargs := ReadArgs('NAMES/M/A', options, NIL)

	    /* Open the libraries */
	  datatypesbase := OpenLibrary('datatypes.library', 39)
	   iffparsebase := OpenLibrary('iffparse.library', 39)

		    /* Get a pointer to the name array */
		    names := options[OPT_NAME]

		    /* Step through the name array */
		    WHILE ^names

			/* Lock the current name */
			lock := Lock(^names, ACCESS_READ)

			    /* Determine the DataType of the file */
			    dtn := ObtainDataTypeA(DTST_FILE, lock, NIL)

				dth := dtn.header

				PrintF('informazioni su: \s\n', ^names)
				PrintF('    Descrizione: \s\n', dth.name)
				PrintF('      Base Nome: \s\n', dth.basename)
				PrintF('           Tipo: \s\n', GetDTString((dth.flags AND DTF_TYPE_MASK) + DTMSG_TYPE_OFFSET))
				PrintF('         Gruppo: \s\n', GetDTString(dth.groupid))
				PrintF('             ID: \s\n\n', IdtoStr(dth.id, buffer))

			UnLock(lock)
			/* Prende il prossimo nome */
			names++
		   ENDWHILE

EXCEPT DO
	/* Free the allocated memory after ReadArgs */
 IF rdargs THEN FreeArgs(rdargs)
  SELECT exception
  CASE ERR_LIB;	  PrintF('couldn''t open Library V39\n')
  CASE ERR_DT;   PrintFault(IoErr(), ^names)
  CASE ERR_LOCK;   PrintFault(IoErr(), ^names)
  ENDSELECT
ENDPROC
