OPT MODULE
OPT REG=5
OPT STRMERGE


MODULE 'playsid','libraries/playsidbase','exec/execbase'


OBJECT psidbase
   psid:playsidbase
   display:PTR TO displaydata
ENDOBJECT


DEF psidbase:PTR TO psidbase,song,res


EXPORT ENUM PSIDERR_NONE,PSIDERR_NOLIB,PSIDERR_RESOURCE,PSIDERR_BADMOD

EXPORT CONST PSIDINFO_TITLE=0,PSIDINFO_AUTHOR=2,PSIDINFO_COPYRIGHT=4,
             PSIDINFO_SONGS=6,PSIDINFO_DEFSONG=8


/*

MODULE 'grio/file','exec/memory'
PROC main()
DEF sh:PTR TO sidheader,size
 sh,size:=gReadFile(arg,MEMF_CHIP)
 IF sh
     psidPlay(sh,size)
     Wait($1000)
     psidStop()
     gFreeFile(sh)
 ENDIF
ENDPROC

*/


EXPORT PROC psidPlay(module:PTR TO sidheader,size)
DEF error
error:=PSIDERR_NOLIB ; res:=FALSE
IF (psidbase:=playsidbase:=OpenLibrary('playsid.library',1))
   error:=PSIDERR_RESOURCE 
   IF AllocEmulResource()=NIL
      error:=PSIDERR_BADMOD ;res:=TRUE
      IF CheckModule(module)=NIL
         SetVertFreq(execbase::execbase.vblankfrequency)
         SetDisplaySignal(FindTask(NIL),NIL)
         SetReverseEnable(-1)
         SetModule(module,module,size)
         IF StartSong(song:=module.defsong)=NIL
            SetDisplayEnable(-1)
            RETURN TRUE,PSIDERR_NONE
         ENDIF
      ENDIF
   ENDIF
ENDIF
ENDPROC psidStop(),error



EXPORT PROC psidStop()
IF psidbase
   IF psidbase.psid.playmode AND (PM_PLAY OR PM_PAUSE) THEN StopSong()
   IF res
      FreeEmulResource()
      res:=FALSE
   ENDIF
   CloseLibrary(psidbase)
   psidbase:=NIL
ENDIF
ENDPROC NIL



EXPORT PROC psidPause()
IF psidbase
   IF psidbase.psid.playmode=PM_PLAY
      PauseSong()
   ELSEIF psidbase.psid.playmode=PM_PAUSE
      ContinueSong()
   ENDIF
ENDIF
ENDPROC


EXPORT PROC psidSetSong(number)
IF psidbase
   IF psidbase.psid.playmode AND (PM_PLAY OR PM_PAUSE)
      StopSong()
      StartSong(song:=number)
   ENDIF
ENDIF
ENDPROC song


EXPORT PROC psidFwdSong(speed=32) IS ForwardSong(speed)


EXPORT PROC psidRewSong(speed=32) IS RewindSong(speed)


EXPORT PROC psidGetModInfo(module:PTR TO sidheader,buf,x)
DEF out,str[32]:STRING,fmtarg,fmt=0
SetStr(str,0)
out:=str
IF module.id=SID_HEADER
   SELECT x
       CASE 0
           out:=module.name
       CASE 1
           out:='Author :'
       CASE 2
           out:=module.author
       CASE 3
           out:='Copyright :'
       CASE 4
           out:=module.copyright
       CASE 5
           out:=' '
       CASE 6
           fmtarg:=module.number
           fmt:='Songs   : \d'
       CASE 7
           fmtarg:=module.defsong
           fmt:='Defsong : \d'
       CASE 8
           fmt:='Length : $\h'
           fmtarg:=module.length
       CASE 9
           out:=' '
       CASE 10
           fmt:='Start :  $\z\h[4]'
           fmtarg:=module.start
       CASE 11
           fmt:='Init  :  $\z\h[4]'
           fmtarg:=module.init
       CASE 12
           fmt:='Main  :  $\z\h[4]'
           fmtarg:=module.main
   ENDSELECT
ENDIF
IF fmt THEN StringF(str,fmt,fmtarg)
AstrCopy(buf,out)
ENDPROC



EXPORT PROC psidGetMinute()
IF psidbase
   RETURN psidbase.psid.timeminutes
ENDIF
ENDPROC NIL


EXPORT PROC psidGetSecond()
IF psidbase
   RETURN psidbase.psid.timeseconds
ENDIF
ENDPROC NIL



EXPORT PROC psidIsEnabled()
DEF x,i
IF psidbase
   IF psidbase.psid.playmode=PM_PLAY
      i:=NIL
      FOR x:=0 TO 3
         IF psidbase.display.enve[x]
            INC i
         ENDIF
         EXIT i
      ENDFOR
      IF i
         RETURN TRUE
      ENDIF
   ENDIF
ENDIF
ENDPROC FALSE



EXPORT PROC psidNumberSongs(module:PTR TO sidheader)
IF module.id=SID_HEADER
   RETURN module.number
ENDIF
ENDPROC NIL


EXPORT PROC psidCurrentSong() IS song


EXPORT PROC psidGetVolume(chan)
IF psidbase
   IF chan>0
      IF chan<5
         RETURN psidbase.display.enve[chan-1]
      ENDIF
   ENDIF
ENDIF
ENDPROC 0

/*
EXPORT PROC psidGetSample(chan)
IF psidbase
   IF chan
      IF chan<5
         RETURN psidbase.display.sample[chan-1],
                psidbase.display.length[chan-1],
                psidbase.display.period[chan-1]
      ENDIF
   ENDIF
ENDIF
ENDPROC
*/








