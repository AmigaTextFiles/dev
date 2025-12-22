/*                                                               */
/* pt-replay_routines V3 (14.02.1998) by Vyger of DASS           */
/*                                                               */
/* ProTracker 4 Channel Player Routinen in AmigaE unter          */
/* Benutzung der "ptreplay.library" V6.6                         */
/*                                                               */

MODULE 'ptreplay','reqtools','libraries/reqtools'

CONST FILEREQ=0

DEF pt6modbase,
    pt6modact,
    pt6modfile[34]:STRING,
    reqfile:PTR TO rtfilerequester,
    reqfilename[34]:STRING

PROC main()
   VOID '$VER: pt-replay_routines V3 (14.02.1998) by Vyger of Deutsche Amiga Software Schmiede'
   IF reqtoolsbase:=OpenLibrary('reqtools.library',37)
      pt6modact:=pt6_setupplayer()
      pt6modact:=pt6_modreq()
      IF pt6modbase:=PtLoadModule(pt6modfile)
         pt6modact:=PtSetPri(0)
         pt6modact:=pt6_playmod()
         RtEZRequestA('Playing ......','Cancel',NIL, NIL,NIL)
         pt6modact:=pt6_stopmod()
         RtEZRequestA('Playing stopped !','Okay',NIL,NIL,NIL)
      ELSE
         RtEZRequestA('Could not open Module !','Okay',NIL,NIL,NIL)
      ENDIF
      pt6modact:=pt6_setdownplayer()
   ELSE
      WriteF('Could not open reqtools.library v37 or higher !\n')
   ENDIF
   IF reqtoolsbase THEN CloseLibrary(reqtoolsbase)
ENDPROC

PROC pt6_modreq()
   IF reqtoolsbase
      IF (reqfile:=RtAllocRequestA(RT_FILEREQ,NIL))
         reqfilename[0] := 0
         IF RtFileRequestA(reqfile,reqfilename,'Pick a ProTracker Module !',0)
            pt6modact:=StrCopy(pt6modfile,reqfile.dir,ALL)
            pt6modact:=AddPart(pt6modfile,reqfilename,34)
         ELSE
            RtEZRequestA('You didn\at pick a ProTracker Module !','Okay',NIL,NIL,NIL)
         ENDIF
         RtFreeRequest(reqfile)
      ELSE
         RtEZRequestA('Out of memory!','Okay',NIL,NIL,NIL)
      ENDIF
   ENDIF
ENDPROC
 
PROC pt6_setupplayer()
   IF ptreplaybase:=OpenLibrary('ptreplay.library',6)
   ELSE
      WriteF('  Could not open "ptreplay.library" v6 or higher\n')
   ENDIF
ENDPROC

PROC pt6_setdownplayer()
   IF ptreplaybase THEN CloseLibrary(ptreplaybase)
ENDPROC

PROC pt6_playmod()
   pt6modact:=PtPlay(pt6modbase)
ENDPROC

PROC pt6_stopmod()
   pt6modact:=PtStop(pt6modbase)
   pt6modact:=PtUnloadModule(pt6modbase)
ENDPROC
