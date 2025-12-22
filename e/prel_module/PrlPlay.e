
/*************************************************************************
      PrlPlay - a quick example how to play double buffered data 
                  using prelude.library                           
:Program       prlplay.e
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
    bn[6]:ARRAY OF makes,buffer=NIL,playfreq=NIL,
    mystart=NIL:PTR TO preludebase,bufsize=NIL,task,bytestoplay=NIL,
    fhandle=NIL,qsignal=NIL



PROC main() 
IF arg[]=0
WriteF('Usage: PrlPlay [Raw 16bit stereo data, msb first]\n')
ELSE
VOID '$VER:PrlPlay Example © F.Bunk  (25.07.1998)' 
WriteF('Play: \s\n',arg)

/* Buffersize in Kbytes */
bufsize:=256

/* Format of sample data to play: 16 bit stereo, big msb first */
playmode:=(PRL_Stereo OR PRL_FMT OR PRL_FMTX)

/* Playback frequency */
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
 start.pl_sigtask:=task
 start.pl_sigmask:=sigmask
ENDIF

/* Allocate two buffers for double buffering */
bn[0].wert:=AllocVec(bufsize*1024,(MEMF_CLEAR OR MEMF_PUBLIC))
bn[1].wert:=AllocVec(bufsize*1024,(MEMF_CLEAR OR MEMF_PUBLIC))
IF bn[0].wert >0 AND  bn[1].wert >0

buffer:=0
fhandle:=Open(arg,MODE_OLDFILE)

/* Preload first buffer and append it to playlist */
bytestoplay:=Read(fhandle,bn[buffer].wert,bufsize*1024)
PrlPlay(bn[buffer].wert,bufsize*1024,playmode,playfreq)
ELSE
WriteF('No Memory !\n')
ENDIF

WHILE bytestoplay=(bufsize*1024)

/* Swap buffers */
buffer:=1-buffer
WriteF('.')

/* Load next buffer and and append it to playlist */
bytestoplay:=Read(fhandle,bn[buffer].wert,bufsize*1024)
PrlPlay(bn[buffer].wert,bufsize*1024,playmode,playfreq)

/* Wait for current buffer to complete */
qsignal:=Wait((sigmask OR SIGBREAKF_CTRL_C))
EXIT qsignal=SIGBREAKF_CTRL_C
ENDWHILE

Close(fhandle)
/* Stop playback and remove all pending requests from playlist */
PrlStop(0)
KillPrlPlayList()

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

