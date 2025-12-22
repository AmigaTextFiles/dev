/*****************************************************************************

              Amiga E - Demo Program using the AEDoor.library

                       Copyright 1993 by SiNTAX/WøT


*****************************************************************************/

MODULE 'AEDoor'				    /* Include libcalls & constants */

ENUM LC,NOLIB,NOERR,ERROPEN	     /* Declare our constants (ENUMERATION) */

RAISE	LC IF Prompt()=NIL,	  /* Setup automatic exception calling when */
	LC IF GetStr()=NIL	  /* there is a LOSS of CARRIER!! NOTE: be  */
				  /* sure to close everything you opened and*/
				  /* free whatever you alloc'ed (except the */
				  /* mem alloc'ed by E funcs)		    */

DEF d,res:LONG

PROC main() HANDLE	      /* Notify E that we have an exception routine */

	IF (aedoorbase:=OpenLibrary('AEDoor.library',1))=NIL THEN Raise(NOLIB)

	d:=CreateComm(arg[])				/* Establish Link   */

	WriteStr(d,'\n[1;33mDEMO DOOR V0.1[0m by SiNTAX/WøT\n',LF)


	/* Now let's try something that wouldn't be allowed without using   */
	/* exceptions... Normally we would first have to test the result of */
	/* the GetStr() call to determin if there was a LC and then do the  */
	/* string compare.. now we can put it on 1 line!!                   */
	/* NOTE: This isn't perfect ofcoz, since we don't test a lower case */
	/*	 'y'  but this is just an example... DON'T use UpperStr() on*/
	/*	 the pointer that GetStr() returns, since that points to the*/
	/*	 stringfield of the message port that is used to send the   */
	/*	 messages to ami express!!!          			    */

	WriteStr(d,'Continue? ',NOLF)

	IF StrCmp(GetStr(d,1,'Y'),'Y',ALL)
		WriteStr(d,'\nYops',LF)
	ELSE
		WriteStr(d,'\nNop.. sniff',LF)
		Raise(NOERR)
	ENDIF	

	/* Now let's show an example with nested exceptions, this is 	    */
	/* sometimes needed if a sub routine needs to close/dealloc some    */
	/* stuff... ofcourse we could include all that code in the main     */
	/* exception routine, but it's more structured to keep everything   */
	/* together!							    */

	subprg()
	WriteStr(d,'EXITED FROM SUBPRG',LF)


	Raise(NOERR)				     /* To Close Lib & Link */


EXCEPT	/* Exception handling routines */

	SELECT exception
		CASE LC
			WriteStr(d,'\nLOST CARRIER!',LF)
		CASE NOLIB
			/* Generate a RECOVERABLE alert! The node will lock */
			/* up ofcourse since it doesn't get a response from */
			/* this door, but at least we know what is happening*/
			DisplayAlert(0,{alert},20)
	ENDSELECT
			

	IF d<>NIL THEN DeleteComm(d)			/* Close Link w /X  */
	IF aedoorbase<>NIL THEN CloseLibrary(aedoorbase)
ENDPROC

/* Fast & Dirty way to make a valid AlertMessage structure, but it works    */
/* and it is allowed to do it this way, else it wouldn't have been possible */
alert:	INT	200
	CHAR	12,'Needs AEDoor.library V1+ to run!\0',0


/*  SUBPRG()

In this sub routine we open a temporary file, if this fails then we return
to the main program WITHOUT quitting the program.. Just to show the different
possibilities.
If we get a LC then we first handle this local exception, which closes the
filehandle of the temporary file and then we go to the main exception, which
closes everything else

*/
PROC subprg() HANDLE
  DEF f,text[50]:STRING

	IF (f:=Open('t:tempfile',NEWFILE))=NIL THEN Raise(ERROPEN)

	/* DO SOMETHING

	.
	.
	.

	*/

	res:=Prompt(d,49,'\nEnter something: ')
	StrCopy(text,res,ALL)

	/* DO SOMETHING

	.
	.
	.

	*/

	Close(f)

EXCEPT	/* This is a local exception handler for this sub routine */
	SELECT exception
		CASE ERROPEN
			WriteStr(d,'ERROR: Couldn\at create file!',LF)

		CASE LC
			Close(f)	/* Close filehandle       */
			Raise(LC)	/* Pass LC on to main exc */
	ENDSELECT
ENDPROC
