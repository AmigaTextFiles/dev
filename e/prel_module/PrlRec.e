
/*************************************************************************
      PrlRec - a quick example how to REC using prelude.library                           
:Program       prlrec.e
:Description   Example using Prelude.library

:Autor.        AmigaE  Version Friedhelm Bunk
               Original in C from Thomas Wenzel and Marc Albrecht

:EC-Version     EC3.3a    
:OS.            > 2.0 
:PRG-Version    1.0

*************************************************************************/






OPT OSVERSION=37

MODULE 'exec/memory','dos/dos',
       'prelude','libraries/prelude'

OBJECT makes
wert
ENDOBJECT




DEF signal=NIL,sigmask=NIL,playmode=NIL,start=NIL:PTR TO prlctrl,
    bn[6]:ARRAY OF makes,playfreq=NIL,
    mystart=NIL:PTR TO preludebase,bufsize=NIL,task,
    fhandle=NIL,qsignal=NIL,rueck=NIL



PROC main() 
IF arg[]=0
WriteF('Usage: PrlRec [Raw 16bit stereo data, msb first]\n')
ELSE
VOID '$VER:PrlRec Example © F.Bunk  (25.07.1998)' 
WriteF('Rec: \s\n',arg)

/* Buffersize in Kbytes */
bufsize:=256

/* Format of sample data to rec: 16 bit stereo, big msb first */
playmode:=(PRL_Stereo OR PRL_FMT OR PRL_FMTX)

/* Sampling frequency */
playfreq:=44100

/* Open the library */
IF (preludebase:=OpenLibrary('prelude.library',2))=NIL
 WriteF('Couldn''t open prelude.library v2 \n')
ELSE
 WriteF('Library opened \n')
 mystart:=preludebase
 start:=mystart.pr_prlctrl

 /* Tell the library to signal us each time a playlist entry is done */
 task:=FindTask(NIL)
 signal:=AllocSignal(-1)
 sigmask:=Shl(1,signal)
ENDIF

/* Allocate two buffers for double buffering */
bn[0].wert:=AllocVec(bufsize*1024,(MEMF_CLEAR OR MEMF_PUBLIC))
bn[1].wert:=AllocVec(bufsize*1024,(MEMF_CLEAR OR MEMF_PUBLIC))

IF bn[0].wert >0 AND  bn[1].wert >0

rueck:=SetPrlCtrl([PRL_SMPL_MODE,playmode,PRL_FREQUENCY,playfreq,
                   PRL_INPUT_LEFT,PRL_InAUX1,PRL_INPUT_RIGHT,PRL_InAUX1,
                   PRL_ING_LEFT,0,PRL_ING_RIGHT,0,
                   PRL_MING_LEFT,0,PRL_MING_RIGHT,0,NIL])

fhandle:=Open(arg,MODE_NEWFILE)
PrlRecord([PRL_BUFF_1,bn[0].wert,PRL_BUFF_2,bn[1].wert,
           PRL_BUFF_LENGTH,(bufsize*1024),PRL_SIG_TASK,task,
           PRL_SIG_MASK,sigmask,PRL_SIG_ADR,1,
           PRL_SMPL_MODE,playmode,NIL])
ELSE
WriteF('No Memory !\n')
ENDIF

WriteF('Record started.\n')
/* Wait for current buffer to complete */
qsignal:=sigmask
WHILE  qsignal=sigmask
 qsignal:=Wait((sigmask OR SIGBREAKF_CTRL_C))
EXIT qsignal=SIGBREAKF_CTRL_C
 WriteF('.')
 Write(fhandle,bn[0].wert,bufsize*1024)
 qsignal:=Wait((sigmask OR SIGBREAKF_CTRL_C))
 WriteF('.')
 Write(fhandle,bn[1].wert,bufsize*1024)
ENDWHILE
Close(fhandle)

/* Stop Record  */
PrlStop(0)

IF bn[1].wert THEN FreeVec(bn[1].wert)
IF bn[0].wert THEN FreeVec(bn[0].wert)

/* Free the hardware */
 IF preludebase 
  PreludeQuit()
  FreeSignal(signal)
  CloseLibrary(preludebase)
 WriteF('\nLibrary closed.\n')
 ENDIF
ENDIF
ENDPROC

