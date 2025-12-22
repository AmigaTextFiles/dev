/*****************************************************************************

              Amiga E - Demo Program using the AEDoor.library

                       Copyright 1993 by SiNTAX/WøT


*****************************************************************************/

MODULE 'AEDoor'				    /* Include libcalls & constants */

ENUM LC,NOLIB,NOERR		     /* Declare our constants (ENUMERATION) */

RAISE	LC IF Prompt()=NIL,	  /* Setup automatic exception calling when */
	LC IF GetStr()=NIL	  /* there is a LOSS of CARRIER!! NOTE: be  */
				  /* sure to close everything you opened and*/
				  /* free whatever you alloc'ed (except the */
				  /* mem alloc'ed by E funcs)		    */

DEF diface,strfield,res:LONG,
    usern[50]:STRING,str[256]:STRING,
    location[100]:STRING

PROC main() HANDLE	      /* Notify E that we have an exception routine */

	IF (aedoorbase:=OpenLibrary('AEDoor.library',1))=NIL THEN Raise(NOLIB)


	diface:=CreateComm(arg[])			/* Establish Link   */
	strfield:= GetString(diface)	/* Get a pointer to the JHM_String  */
					/* field. Only need to do this once */



	GetDT(diface,DT_NAME,0)		/* Get USER  name, no string input  */
					/* here, so use 0 as last parameter */
	StrCopy(usern,strfield,50)	/* Copy result from JHM_String to   */
					/* our own string. Don't 4 get this */

	GetDT(diface,DT_LOCATION,0)		    /* Get LOCATION of user */
	StrCopy(location,strfield,100)		    /* Copy result (see b4) */

	WriteStr(diface,'User name : ',NOLF)		/* Write something  */
	WriteStr(diface,usern,LF)
	WriteStr(diface,'Location  : ',NOLF)		/* Write something  */
	WriteStr(diface,location,LF)



	GetDT(diface,DT_DUMP,'T:user.dump')	 /* Dump user's data struct */



	/* Here's where the exception routines come in handy, now we don't  */
	/* have to include the Prompt() or GetStr() call in an IF statement */
	/* anymore, making the source easier to read.. and it makes our     */
	/* lives alot easier :-)					    */

	res:=Prompt(diface,80,'\nGimme some input: ')	/* Ask some input   */
	StrCopy(str,res,80)				/* Store input	    */
	WriteStr(diface,'Entered: ',NOLF)		/* Write w/o RETURN */
	WriteStr(diface,str,LF)				/* Write inputstring*/

	res:=GetStr(diface,3,'YES')	/* Ask input, with a default string */
	IF StrCmp(res,'YES',3)
	  ShowFile(diface,'S:User-Startup')		/* Show a dos file  */
	  ShowGFile(diface,'BBS:BULL30')		/* Show an /X file  */
	ENDIF
	Raise(NOERR)				     /* To Close Lib & Link */


EXCEPT	/* Exception handling routines */

	SELECT exception
		CASE LC
			WriteStr(diface,'LOST CARRIER!',LF)
		CASE NOLIB
			WriteF('Needs AEDoor.library V1+ to run!\n')
	ENDSELECT
			

	IF diface<>NIL THEN DeleteComm(diface)		/* Close Link w /X  */
	IF aedoorbase<>NIL THEN CloseLibrary(aedoorbase)

ENDPROC
