/***********************************************************************
*								       *
*	playahi.e  V1.3  24.02.2018  by Rainer "No.3" Müller           *
*								       *
*  an example how to use AHI with the Amiga E Language		       *
*								       *
*  close the window to stop replaying				       *
*								       *
*  compile: ec playahi						       *
*								       *
*  use: playahi name	   name = name of the file you want to replay  *
*								       *
*  new in:							       *
*								       *
*    V1.0  08.01.1999  first version				       *
*								       *
*    V1.2  06.09.2000  uses now ReadArgs()                             *
*								       *
*    V1.3  24.02.2018  ReadArgs() did not FreeArgs() !  oooops...      *
*								       *
***********************************************************************/

OPT PREPROCESS

MODULE 'devices/ahi',
	   'dos/dos',         'dos/rdargs',
	  'exec/io',         'exec/memory',  'exec/nodes',  'exec/ports',
     'intuition/intuition',
       'utility/tagitem'


ENUM ER_NONE, ER_NOOPEN, ER_NOMEM, ER_NOLOAD, ER_NOPORT, ER_NOIOREQ, ER_NODEVICE, ER_NOWINDOW, ER_KICK, ER_BADARGS


PROC main() HANDLE
DEF rdargs=NIL:PTR TO rdargs
DEF myargs
DEF   file=NIL
DEF    ptr=NIL:PTR TO CHAR
DEF    len=NIL

   IF KickVersion(37)=FALSE THEN Raise(ER_KICK)

   IF (rdargs:=ReadArgs  ('File/A', {myargs}, NIL)   ) =NIL THEN Raise(ER_BADARGS)

   IF (  file:=Open      (myargs,  MODE_OLDFILE)     ) =NIL THEN Raise(ER_NOOPEN)
	 len :=FileLength(myargs)
   IF (  ptr :=AllocVec  (len,  MEMF_ANY+MEMF_PUBLIC)) =NIL THEN Raise(ER_NOMEM)
   IF	      Read	 (file, ptr,  len)            <>len THEN Raise(ER_NOLOAD)

   playahi(ptr,len)

EXCEPT DO
   IF ptr    THEN FreeVec(ptr)
   IF file   THEN Close  (file)
   IF rdargs THEN FreeArgs(rdargs)
   SELECT exception
      CASE ER_KICK;    WriteF('need Kick 37+\n')
      CASE ER_BADARGS; WriteF('bad args\n')
      CASE ER_NOOPEN;  WriteF('couldn`t open file\n')
      CASE ER_NOMEM;   WriteF('no memory\n')
      CASE ER_NOLOAD;  WriteF('problems while reading\n')
      CASE ER_NONE;    WriteF('all OK\n')
   ENDSELECT
ENDPROC




PROC playahi(ptr,len) HANDLE
DEF ahidevice=-1
DEF ahiMP=NIL:PTR TO mp
DEF ahiIO=NIL:PTR TO ahirequest
DEF win  =NIL:PTR TO window
DEF signals
DEF type
DEF frequency
DEF pri
DEF volume

	type:=AHIST_M8S   -> see ahi documentation for more types
   frequency:=22050	  -> frequency you want to replay with
	 pri:=128	  -> priority you want to allocate the audio channel
      volume:=$10000	  -> the volume you want replay with, stored as a LONG fixed value, see ahi-doc formore information

   IF (ahiMP:=CreateMsgPort()                          )=NIL THEN Raise(ER_NOPORT)   -> create a message port
   IF (ahiIO:=CreateIORequest(ahiMP, SIZEOF ahirequest))=NIL THEN Raise(ER_NOIOREQ)  -> create a io-request
       ahiIO.version:=4 								    -> see ahi-doc for more information
   IF (ahidevice:=OpenDevice(AHINAME, AHI_DEFAULT_UNIT, ahiIO, 0)) THEN Raise(ER_NODEVICE)  -> open audio-device


   IF (win:=OpenWindowTagList(NIL,      -> create a just-for-fun window
      [WA_LEFT, 	11,
       WA_TOP,		11,
       WA_INNERWIDTH,	80,
       WA_INNERHEIGHT,	20,
       WA_IDCMP,	IDCMP_CLOSEWINDOW,
       WA_FLAGS,	WFLG_SMART_REFRESH OR WFLG_ACTIVATE OR WFLG_DRAGBAR OR
			WFLG_NOCAREREFRESH OR WFLG_RMBTRAP  OR WFLG_CLOSEGADGET,
       WA_AUTOADJUST,	1,  TAG_DONE]))=NIL THEN Raise(ER_NOWINDOW)


    ahiIO.iostd.mn.ln.pri:=pri			-> fill in the ahi-structures and then replay
    ahiIO.iostd.command  :=CMD_WRITE
    ahiIO.iostd.data	 :=ptr			-> pointer to the sampledata
    ahiIO.iostd.length	 :=len			-> number of bytes to replay
    ahiIO.iostd.offset	 :=0
    ahiIO.type		 :=type
    ahiIO.frequency	 :=frequency
    ahiIO.volume	 :=volume
    ahiIO.position	 :=$08000		-> Centered, see ahi-doc
    ahiIO.link		 :=NIL
    SendIO(ahiIO)                               -> start replay


/* wait till replaying is finished, or you stop replaying by closing the window */
    signals:=Wait( Shl(1, win.userport.sigbit) OR Shl(1, ahiMP.sigbit) )

    IF (signals AND Shl(1, win.userport.sigbit))
       WriteF('break by user\n')
       AbortIO(ahiIO)
	WaitIO(ahiIO)
    ENDIF

    IF (signals AND Shl(1, ahiMP.sigbit))
       WriteF('break by ahi\n')
    ENDIF

EXCEPT DO
   IF win	  THEN CloseWindow    (win)
   IF ahidevice=0 THEN CloseDevice    (ahiIO)
   IF ahiIO	  THEN DeleteIORequest(ahiIO)
   IF ahiMP	  THEN DeleteMsgPort  (ahiMP)
   SELECT exception
      CASE ER_NOPORT;	 WriteF('couldn`t create port\n')
      CASE ER_NOIOREQ;	 WriteF('couldn`t create iorequest\n')
      CASE ER_NODEVICE;  WriteF('couldn`t open ahi-device V4+\n')
      CASE ER_NOWINDOW;  WriteF('couldn`t open window\n')
   ENDSELECT
ENDPROC


