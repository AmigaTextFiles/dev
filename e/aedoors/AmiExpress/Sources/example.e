/*****************************************************************************

              Amiga E - Demo Program using the AEDoor.library

                       Copyright 1993 by SiNTAX/WøT


*****************************************************************************/

MODULE 'AEDoor'				    /* Include libcalls & constants */

DEF diface,strfield,res:LONG,
    usern[50]:STRING,str[256]:STRING,
    location[100]:STRING

PROC main()
  IF aedoorbase:=OpenLibrary('AEDoor.library',1)

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


	IF (res:=Prompt(diface,80,'\nGimme some input: '))<>NIL
							/* Ask some input   */
		StrCopy(str,res,80)			/* Store input	    */
	  	WriteStr(diface,'Entered: ',NOLF)	/* Write w/o RETURN */
		WriteStr(diface,str,LF)			/* Write inputstring*/

		IF (res:=GetStr(diface,3,'YES'))<>NIL
					/* Ask input, with a default string */

			IF StrCmp(res,'YES',3)
			  ShowFile(diface,'S:User-Startup')
							/* Show a dos file  */
			  ShowGFile(diface,'BBS:BULL30')
							/* Show an /X file  */
			ENDIF
		ELSE
			WriteStr(diface,'LOST CARRIER',LF)
		ENDIF

	ELSE
		WriteStr(diface,'LOST CARRIER',LF)	/* If Loss Carrier  */
	ENDIF



	DeleteComm(diface)				/* Close Link w /X  */

	CloseLibrary(aedoorbase)
  ELSE
    WriteF('Could not open AEDoor.library V1!\n')
  ENDIF
ENDPROC
