/************************************************************************
*									*
*	playahidb.e  V1.3  24.02.2018  by Rainer "No.3" Müller          *
*									*
*  an example how to use AHI with the Amiga E Language			*
*									*
*  this is a double buffer example, the file to be replayed must be	*
*									*
*  bigger than 8192 bytes						*
*									*
*  closing the window stops replaying					*
*									*
*  compile: ec playahidb						*
*									*
*  use: playahidb name	    name = name of the file you want to replay	*
*									*
*  new in:								*
*									*
*    V1.0  08.01.1999  first version					*
*									*
*    V1.1  04.03.1999  fixed a fatal "50%" bug, which could crash the   *
*		       system -> new lines marked with "########"       *
*									*
*    V1.2  06.09.2000  uses now ReadArgs()                              *
*									*
*    V1.3  24.02.2018  ReadArgs() did not FreeArgs() !  oooops...       *
*									*
************************************************************************/

OPT PREPROCESS

MODULE 'devices/ahi',
	   'dos/dos',         'dos/rdargs',
	  'exec/io',         'exec/memory',  'exec/nodes',  'exec/ports',
     'intuition/intuition',
       'utility/tagitem'


ENUM ER_NONE,	  ER_NOOPEN, ER_NOMEM,	 ER_NOLOAD, ER_NOPORT, ER_NOIOREQ, ER_NODEVICE,
     ER_NOWINDOW, ER_KICK,   ER_ENDPLAY, ER_BADARGS

CONST BUFFERSIZE=4096


PROC main() HANDLE
DEF rdargs=NIL:PTR TO rdargs
DEF myargs
DEF   file=NIL

   IF KickVersion(37)=FALSE THEN Raise(ER_KICK)

   IF (rdargs:=ReadArgs('File/A', {myargs}, NIL))=NIL THEN Raise(ER_BADARGS)

   IF (  file:=Open    (myargs, MODE_OLDFILE)   )=NIL THEN Raise(ER_NOOPEN)

   playahidb(file)

EXCEPT DO
   IF file   THEN Close  (file)
   IF rdargs THEN FreeArgs(rdargs)
   SELECT exception
      CASE ER_KICK;    WriteF('need Kick 37+\n')
      CASE ER_BADARGS; WriteF('bad args\n')
      CASE ER_NOOPEN;  WriteF('couldn`t open file\n')
      CASE ER_NONE;    WriteF('all OK\n')
   ENDSELECT
ENDPROC



PROC playahidb(file) HANDLE
DEF ahidevice=-1
DEF ahiMP  =NIL:PTR TO mp
DEF ahiIO  =NIL:PTR TO ahirequest
DEF ahiIOor=NIL:PTR TO ahirequest	-> ######## bug fix !!! ########
DEF ahiIO2 =NIL:PTR TO ahirequest
DEF link   =NIL:PTR TO ahirequest
DEF buffer1=NIL:PTR TO CHAR
DEF buffer2=NIL:PTR TO CHAR
DEF win     =NIL:PTR TO window, signals
DEF tmp
DEF type
DEF frequency
DEF pri
DEF volume
DEF length

	type:=AHIST_M8S   -> see ahi documentation for more types
   frequency:=22050	  -> frequency you want to replay with
	 pri:=128	  -> priority you want to allocate the audio channel
      volume:=$10000	  -> the volume you want replay with, stored as a LONG fixed value, see ahi-doc formore information

   IF (ahiMP:=CreateMsgPort()                          )=NIL THEN Raise(ER_NOPORT)   -> create a message port
   IF (ahiIO:=CreateIORequest(ahiMP, SIZEOF ahirequest))=NIL THEN Raise(ER_NOIOREQ)  -> create a io-request
       ahiIO.version:=4 								    -> see ahi-doc for more information
   IF (ahidevice:=OpenDevice(AHINAME, AHI_DEFAULT_UNIT, ahiIO, 0)) THEN Raise(ER_NODEVICE)  -> open audio-device


   IF (ahiIO2:=AllocVec(SIZEOF ahirequest, MEMF_ANY))=NIL THEN Raise(ER_NOMEM)  -> Make a copy of the request (for double buffering)
   CopyMem(ahiIO, ahiIO2, SIZEOF ahirequest)

   ahiIOor:=ahiIO	-> ######## bugfix !!! ########

   IF (buffer1:=AllocVec(BUFFERSIZE, MEMF_ANY))=NIL THEN Raise(ER_NOMEM)        -> allocate two buffers
   IF (buffer2:=AllocVec(BUFFERSIZE, MEMF_ANY))=NIL THEN Raise(ER_NOMEM)

   IF (win:=OpenWindowTagList(NIL,                                              -> create a just-for-fun window
      [WA_LEFT, 	11,
       WA_TOP,		11,
       WA_INNERWIDTH,	80,
       WA_INNERHEIGHT,	20,
       WA_IDCMP,	IDCMP_CLOSEWINDOW,
       WA_FLAGS,	WFLG_SMART_REFRESH OR WFLG_ACTIVATE OR WFLG_DRAGBAR OR
			WFLG_NOCAREREFRESH OR WFLG_RMBTRAP  OR WFLG_CLOSEGADGET,
       WA_AUTOADJUST,	1,  TAG_DONE]))=NIL THEN Raise(ER_NOWINDOW)

   LOOP
      length:=Read(file,buffer1,BUFFERSIZE)

      ahiIO.iostd.mn.ln.pri:=pri		-> fill in the ahi-structures and then replay
      ahiIO.iostd.command  :=CMD_WRITE
      ahiIO.iostd.data	   :=buffer1		-> pointer to the sampledata
      ahiIO.iostd.length   :=length		-> number of bytes to replay
      ahiIO.iostd.offset   :=0
      ahiIO.type	   :=type
      ahiIO.frequency	   :=frequency
      ahiIO.volume	   :=volume
      ahiIO.position	   :=$08000		-> Centered, see ahi-doc
      ahiIO.link	   :=link
      SendIO(ahiIO)                             -> Play buffer

      IF link
	 signals:=Wait( Shl(1, win.userport.sigbit) OR Shl(1, ahiMP.sigbit) )   -> Wait until the last buffer is finished (== the new buffer is started)

	 IF (signals AND Shl(1, win.userport.sigbit)) THEN Raise(ER_ENDPLAY)    -> Check for Ctrl-C and abort if pressed

	 IF WaitIO(link)                              THEN Raise(ER_ENDPLAY)    -> Remove the reply and abort on error
      ENDIF

      IF length <> BUFFERSIZE					-> Check for end-of-sound, and wait until it is finished before aborting
	 WaitIO(ahiIO)
	 Raise(ER_ENDPLAY)
      ENDIF

      link   :=ahiIO

      tmp    :=buffer1	       -> Swap buffer and request pointers, and restart
      buffer1:=buffer2
      buffer2:=tmp

      tmp    :=ahiIO
      ahiIO  :=ahiIO2
      ahiIO2 :=tmp
   ENDLOOP


EXCEPT

IF exception=ER_ENDPLAY
   AbortIO(ahiIO)       -> Abort any pending iorequests
   WaitIO (ahiIO)

   IF link		-> Only if the second request was started
      AbortIO(ahiIO2)   -> ########             ########
      WaitIO (ahiIO2)   -> ######## bug fix !!! ########
   ENDIF
ENDIF

IF ahiIOor<>ahiIO	-> ########		########
   tmp	  :=ahiIO	-> ########		########
   ahiIO  :=ahiIO2	-> ######## bug fix !!! ########
   ahiIO2 :=tmp 	-> ########		########
ENDIF			-> ########		########

   IF win	  THEN CloseWindow    (win)
   IF buffer2	  THEN FreeVec	      (buffer2)
   IF buffer1	  THEN FreeVec	      (buffer1)
   IF ahidevice=0 THEN CloseDevice    (ahiIO)
   IF ahiIO2	  THEN FreeVec	      (ahiIO2)
   IF ahiIO	  THEN DeleteIORequest(ahiIO)
   IF ahiMP	  THEN DeleteMsgPort  (ahiMP)
   SELECT exception
      CASE ER_NOPORT;	 WriteF('couldn`t create port\n')
      CASE ER_NOIOREQ;	 WriteF('couldn`t create iorequest\n')
      CASE ER_NODEVICE;  WriteF('couldn`t open ahi-device V4+\n')
      CASE ER_NOMEM;	 WriteF('couldn`t allocate memory\n')
      CASE ER_NOLOAD;	 WriteF('problems while reading from file\n')
      CASE ER_NOWINDOW;  WriteF('couldn`t open window\n')
   ENDSELECT
ENDPROC


