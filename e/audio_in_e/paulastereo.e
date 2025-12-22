/*****************************************************************************
*                                                                            *
*       paulastereo.e  V1.0  21.11.2020  by Rainer "No.3" Müller             *
*                                                                            *
*  an example how to use audio-device with the Amiga E Language              *
*                                                                            *
*  this is a stereo double buffering example, it also replays short samples  *
*  i.e. short and long ones are replayed with the same algorithm!            *                        *
*                                                                            *
*  compile: ec paulastereo                                                   *
*                                                                            *
*  use: paulastereo name    name = name of the file you want to replay       *
*                                                                            *
*  note: same data is played on the left and the right                       *
*        for real stereo playback separate data needs to be provided         *
*        see appropriate comments below, lines 158-160 and 188-189           *
*                                                                            *
*  new in:                                                                   *
*                                                                            *
*    V1.0  21.11.2020  first version                                         *
*                                                                            *
*****************************************************************************/

MODULE 'amigalib/io',
        'devices/audio',
            'dos/dos',     'dos/rdargs',
           'exec/io',     'exec/memory', 'exec/nodes', 'exec/ports',
       'graphics/gfxbase'

ENUM ER_NONE, ER_NOOPEN, ER_NOMEM, ER_NOPORT, ER_NOIOREQ, ER_NODEVICE, ER_NOLOAD, ER_BADARGS, ER_KICK

CONST NTSC_CLOCK=3579545,
       PAL_CLOCK=3546895

DEF clock


PROC main() HANDLE
DEF fileptr=NIL
DEF dataptr=NIL:PTR TO CHAR
DEF datalen=NIL
DEF  rdargs=NIL:PTR TO rdargs
DEF  myargs
DEF     gfx    :PTR TO gfxbase

   gfx:=gfxbase

   IF KickVersion(39)
      IF gfx.displayflags AND REALLY_PAL  THEN clock:=PAL_CLOCK  ELSE clock:=NTSC_CLOCK
   ELSE
      IF gfx.displayflags AND PAL         THEN clock:=PAL_CLOCK  ELSE clock:=NTSC_CLOCK
      IF KickVersion(37)=FALSE THEN Raise(ER_KICK)
   ENDIF

   IF ( rdargs:=ReadArgs('File/A', {myargs},NIL))=NIL THEN Raise(ER_BADARGS)

   IF (fileptr:=Open(myargs,  MODE_OLDFILE))     =NIL THEN Raise(ER_NOOPEN)
       datalen:=FileLength(myargs)
   IF (dataptr:=AllocVec(datalen,MEMF_ANY))      =NIL THEN Raise(ER_NOMEM)
   IF Read(fileptr, dataptr,  datalen)<>datalen       THEN Raise(ER_NOLOAD)

   playSample(dataptr, datalen)

EXCEPT DO
   IF dataptr THEN FreeVec (dataptr)
   IF fileptr THEN Close   (fileptr)
   IF rdargs  THEN FreeArgs(rdargs)
   SELECT exception
      CASE ER_KICK;    WriteF('Kickstart V37+ required\n')
      CASE ER_BADARGS; WriteF('bad args\n')
      CASE ER_NOOPEN;  WriteF('could not open file\n')
      CASE ER_NOMEM;   WriteF('no memory\n')
      CASE ER_NOLOAD;  WriteF('problems while loading\n')
      CASE ER_NONE;    WriteF('all OK\n')
   ENDSELECT
ENDPROC



PROC playSample(ptr,length) HANDLE
DEF arequestl1=NIL:PTR TO ioaudio,  chipbufl1=NIL:PTR TO CHAR
DEF arequestl2    :       ioaudio,  chipbufl2=NIL:PTR TO CHAR
DEF arequestr1    :       ioaudio,  chipbufr1=NIL:PTR TO CHAR
DEF arequestr2    :       ioaudio,  chipbufr2=NIL:PTR TO CHAR
DEF      ioal =NIL:PTR TO ioaudio,    replyl =NIL:PTR TO mp
DEF      ioar =NIL:PTR TO ioaudio,    replyr =NIL:PTR TO mp
DEF deviceerror=1
DEF allocchannel=0, channelleft, channelright
DEF offset, togo
DEF samplerate=22000, volume=64
DEF buflen=8192

   IF Odd(length) THEN DEC length               -> the play length has to be even

   IF buflen>=length                            -> ok, no double buffering needed
      togo  :=0
      buflen:=length
   ELSE                                         -> prepare some data for double buffering
      togo  :=length - buflen
      offset:=buflen
   ENDIF


   IF (   replyl :=CreateMsgPort())=NIL THEN Raise(ER_NOPORT)
   IF (   replyr :=CreateMsgPort())=NIL THEN Raise(ER_NOPORT)
   IF (arequestl1:=CreateIORequest(replyl, SIZEOF ioaudio))=NIL THEN Raise(ER_NOIOREQ)

   arequestl1.io.command  :=ADCMD_ALLOCATE      -> command for allocating audio channels
   arequestl1.io.flags    :=ADIOF_NOWAIT        -> if allocation fails return an error instead of waiting for success
   arequestl1.io.mn.ln.pri:=ADALLOC_MAXPREC     -> allocate with maximum priority
   arequestl1.allockey    :=0                   -> 0 = generate new allocation key
   arequestl1.data        :=[3,5,10,12]:CHAR    -> array of stereo channel combinations
   arequestl1.length      :=4                   -> array length
   IF deviceerror:=OpenDevice('audio.device', 0, arequestl1, 0) THEN Raise(ER_NODEVICE)

   allocchannel:=arequestl1.io.unit             -> the channels we got allocated
   channelleft :=allocchannel AND %1001         -> left channel we got
   channelright:=allocchannel AND %0110         -> right channel we got


   arequestl1.io.command:=CMD_STOP              -> "stop" all channels
   arequestl1.io.unit   :=allocchannel
   beginIO(arequestl1)
    WaitIO(arequestl1)


   arequestl1.io.unit   :=channelleft           -> assign appropriate channel
   arequestl1.io.command:=CMD_WRITE             -> command for writing data to an audio channel
   arequestl1.io.flags  :=ADIOF_PERVOL          -> set volume und period
   arequestl1.length    :=buflen                -> set bufferlength
   arequestl1.period    :=clock / samplerate    -> translate samplerate to period
   arequestl1.volume    :=volume                -> Paula's volume range is from 0 (=no volume) to 64 (max volume)
   arequestl1.cycles    :=1                     -> play the buffer sent to paula 1 time (max 65535, 0 = for ever until stopped)


   CopyMem(arequestl1,arequestr1, SIZEOF ioaudio)       -> copy iorequest for stereo channels
   arequestr1.io.mn.replyport:=replyr                   -> set the appropriate reply port for the right side
   arequestr1.io.unit        :=channelright             -> assign appropriate channel for the right side

   CopyMem(arequestl1,arequestl2, SIZEOF ioaudio)       -> copy left  iorequest for double buffered operation
   CopyMem(arequestr1,arequestr2, SIZEOF ioaudio)       -> copy right iorequest for double buffered operation


   IF (chipbufl1:=AllocVec(buflen, MEMF_CHIP+MEMF_PUBLIC))=NIL THEN Raise(ER_NOMEM)
   IF (chipbufl2:=AllocVec(buflen, MEMF_CHIP+MEMF_PUBLIC))=NIL THEN Raise(ER_NOMEM)
   IF (chipbufr1:=AllocVec(buflen, MEMF_CHIP+MEMF_PUBLIC))=NIL THEN Raise(ER_NOMEM)
   IF (chipbufr2:=AllocVec(buflen, MEMF_CHIP+MEMF_PUBLIC))=NIL THEN Raise(ER_NOMEM)

   arequestl1.data:=chipbufl1                   -> set pointer to first  left  chip mem buffer
   arequestl2.data:=chipbufl2                   -> set pointer to second left  chip buffer
   arequestr1.data:=chipbufr1                   -> set pointer to first  right chip mem buffer
   arequestr2.data:=chipbufr2                   -> set pointer to second right chip buffer


   CopyMem(ptr, chipbufl1, buflen)              -> copy left data into chip-ram
   CopyMem(ptr, chipbufr1, buflen)              -> use the left data for the right side in order to play a mono sample left and right
                                                -> for real stereo playback separate data for the right data needs to be provided

   beginIO(arequestl1)                          -> queue start rocking
   beginIO(arequestr1)                          -> queue start rocking


   arequestl1.io.command:=CMD_START             -> "start"
   arequestl1.io.unit   :=allocchannel          -> all channels
   beginIO(arequestl1)                          -> at once
    WaitIO(arequestl1)


   arequestl1.io.command:=CMD_WRITE             -> set audiorequest command back to CMD_WRITE
   arequestl1.io.unit   :=channelleft           -> assign appropriate channel to arequest1


   ioal:=arequestl2                             -> arequest2 is next to be filled
   ioar:=arequestr2


   WHILE (togo > 0)
      IF buflen>=togo                           -> ok, end of double buffering reached
         buflen:=togo
         togo  :=0
         ioal.length:=buflen                    -> adapt the arequest.length to the remaining length
         ioar.length:=buflen
      ENDIF

      CopyMem(ptr+offset, ioal.data, buflen)    -> fill next buffer
      CopyMem(ptr+offset, ioar.data, buflen)    -> use same data for left and right,
                                                -> for real stereo playback separate data for the right data needs to be provided
      beginIO(ioal)                             -> keep on rocking
      beginIO(ioar)
      offset:=offset + buflen
      togo  :=togo   - buflen

      IF ioal =arequestl1
         ioal:=arequestl2                       -> arequest2 next to be filled
         ioar:=arequestr2
      ELSE
         ioal:=arequestl1                       -> arequest1 next to be filled
         ioar:=arequestr1
      ENDIF

      WaitIO(ioal)                              -> the arequest next to be filled is still
      WaitIO(ioar)                              -> playing, so we have to wait for it
   ENDWHILE


   IF ioal =arequestl1                          -> ioal points to the second last arequest
      ioal:=arequestl2                          -> now it points to the last arequest which is still playing
      ioar:=arequestr2
   ELSE
      ioal:=arequestl1
      ioar:=arequestr1
   ENDIF

   WaitIO(ioal)                                 -> wait for the final arequest to finish
   WaitIO(ioar)


EXCEPT DO
   IF chipbufr2     THEN FreeVec        (chipbufr2)
   IF chipbufr1     THEN FreeVec        (chipbufr1)
   IF chipbufl2     THEN FreeVec        (chipbufl2)
   IF chipbufl1     THEN FreeVec        (chipbufl1)
   IF deviceerror=0 THEN CloseDevice    (arequestl1)
   IF arequestl1    THEN DeleteIORequest(arequestl1)
   IF replyr        THEN DeleteMsgPort  (replyr)
   IF replyl        THEN DeleteMsgPort  (replyl)
   SELECT exception
      CASE ER_NOMEM   ; WriteF('no memory\n')
      CASE ER_NOPORT  ; WriteF('could not create port\n')
      CASE ER_NOIOREQ ; WriteF('could not create iorequest\n')
      CASE ER_NODEVICE; WriteF('could not open audio-device\n')
      CASE ER_NONE    ; WriteF('all OK\n')
   ENDSELECT
ENDPROC


