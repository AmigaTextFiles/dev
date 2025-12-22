/*                                                               */
/* octamed-replay_routines V3 (14.02.1998) by Vyger of DASS      */
/*                                                               */
/* MED 8 Channel Player Routinen in AmigaE unter Benutzung der   */
/* "octaplayer.library" V7.0 by RBF Software                     */
/*                                                               */

MODULE 'octaplayer','reqtools','libraries/reqtools'

CONST FILEREQ=0

DEF med8modbase,
    med8modfile[34]:STRING,
    med8modact,
    reqfile:PTR TO rtfilerequester,
    reqfilename[34]:STRING

PROC main()
   VOID '$VER: octamed-replay_routines V3 (14.02.1998) by Vyger of Deutsche Amiga Software Schmiede'
   IF reqtoolsbase:=OpenLibrary('reqtools.library',37)
      med8modact:=med8_setupplayer()
      med8modact:=med8_modreq()
      IF med8modbase:=LoadModule8(med8modfile)
         med8modact:=med8_sethqon()
         med8modact:=med8_playmod()
         RtEZRequestA('Playing ......','Cancel',NIL, NIL,NIL)
         med8modact:=med8_stopmod()
         med8modact:=med8_sethqoff()
         RtEZRequestA('Playing stopped !','Okay',NIL,NIL,NIL)
      ELSE
         RtEZRequestA('Could not open Module !','Okay',NIL,NIL,NIL)
      ENDIF
      med8modact:=med8_removeplayer()
   ELSE
      WriteF('Could not open reqtools.library v37 or higher !\n')
   ENDIF
   IF reqtoolsbase THEN CloseLibrary(reqtoolsbase)
ENDPROC

PROC med8_modreq()
   IF reqtoolsbase
      IF (reqfile:=RtAllocRequestA(RT_FILEREQ,NIL))
         IF RtFileRequestA(reqfile,reqfilename,'Pick a OctaMED 8-Channel Module !',0)
            med8modact:=StrCopy(med8modfile,reqfile.dir,ALL)
            med8modact:=AddPart(med8modfile,reqfilename,34)
         ELSE
            RtEZRequestA('You didn\at pick a OctaMED 8-Channel Module !','Okay',NIL,NIL,NIL)
         ENDIF
         RtFreeRequest(reqfile)
      ELSE
         RtEZRequestA('Out of memory!','Okay',NIL,NIL,NIL)
      ENDIF
   ENDIF
ENDPROC

/* setup routines */

PROC med8_setupplayer()
  IF octaplayerbase:=OpenLibrary('octaplayer.library',7)
    med8modact:=GetPlayer8()
  ELSE
    WriteF(' Could not open "octaplayer.library" v7 or higher !\n')
  ENDIF
ENDPROC

PROC med8_removeplayer()
  med8modact:=FreePlayer8()
  IF octaplayerbase THEN CloseLibrary(octaplayerbase)
ENDPROC

/* command routines */

PROC med8_playmod()
  med8modact:=PlayModule8(med8modbase)
ENDPROC

PROC med8_stopmod()
  med8modact:=UnLoadModule8(med8modbase)
ENDPROC

/* control routines */

PROC med8_sethqoff()
  med8modact:=SetHQ(0)
ENDPROC

PROC med8_sethqon()
  med8modact:=SetHQ(1)
ENDPROC

