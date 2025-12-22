/**************************************************************************
*                                                                         *
*       playpaula.e  V1.4  21.11.2020  by Rainer "No.3" Müller            *
*                                                                         *
*  an example how to use audio-device with the Amiga E Language           *
*                                                                         *
*  if the file is bigger than 128 KByte, double buffering is used         *
*                                                                         *
*  compile: ec playpaula                                                  *
*                                                                         *
*  use: playpaula name      name = name of the file you want to replay    *
*                                                                         *
*  new in:                                                                *
*                                                                         *
*    V1.0  08.01.1999  first version                                      *
*                                                                         *
*    V1.2  06.09.2000  uses now ReadArgs(), checks for OS2.0+             *
*                                                                         *
*    V1.3  24.02.2018  now checks for the correct displayflag REALLY_PAL  *
*                      and for an even play length                        *
*                      ReadArgs() did not FreeArgs() !  oooops...         *
*                      major code cleanups and optimizations              *
*                                                                         *
*    V1.4  21.11.2020  some code revision i.e. WaitPort => WaitIO         *
*                      The use of REALLY_PAL is only correct for OS3.0+   *
*                                                                         *
**************************************************************************/

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
DEF arequest1=NIL:PTR TO ioaudio
DEF arequest2    :       ioaudio
DEF ioa      =NIL:PTR TO ioaudio
DEF reply    =NIL:PTR TO mp
DEF chipbuf1 =NIL:PTR TO CHAR, buflen=8192
DEF chipbuf2 =NIL:PTR TO CHAR
DEF deviceerror=1
DEF offset
DEF times, rest
DEF samplerate=22000
DEF volume=64

   IF Odd(length) THEN DEC length               -> the play length has to be even

   IF (   reply :=CreateMsgPort())=NIL THEN Raise(ER_NOPORT)
   IF (arequest1:=CreateIORequest(reply, SIZEOF ioaudio))=NIL THEN Raise(ER_NOIOREQ)

   arequest1.io.command  :=ADCMD_ALLOCATE       -> command for allocating audio channels
   arequest1.io.flags    :=ADIOF_NOWAIT         -> if allocation fails return an error instead of waiting for success
   arequest1.io.mn.ln.pri:=ADALLOC_MAXPREC      -> allocate with maximum priority
   arequest1.allockey    :=0                    -> 0 = generate new allocation key
   arequest1.data        :=[1,2,4,8]:CHAR       -> array of mono channel combinations, [3,5,10,12] for stereo channels, [15] for all 4 channels
   arequest1.length      :=4;                   -> array length
   IF deviceerror:=OpenDevice('audio.device', 0, arequest1, 0) THEN Raise(ER_NODEVICE)

   arequest1.io.command  :=CMD_WRITE            -> command for writing data to an audio channel
   arequest1.io.flags    :=ADIOF_PERVOL         -> set volume und period
   arequest1.period      :=clock / samplerate   -> translate samplerate to period
   arequest1.volume      :=volume               -> Paula's volume range is from 0 (=no volume) to 64 (max volume)
   arequest1.cycles      :=1                    -> play the buffer sent to paula 1 time (max 65535, 0 = for ever until stopped)


   IF length >= 131072                          -> sample is bigger than 128 KByte => we have to use double buffering
      IF (chipbuf1:=AllocVec(buflen, MEMF_CHIP+MEMF_PUBLIC))=NIL THEN Raise(ER_NOMEM)
      IF (chipbuf2:=AllocVec(buflen, MEMF_CHIP+MEMF_PUBLIC))=NIL THEN Raise(ER_NOMEM)

      CopyMem(arequest1,arequest2, SIZEOF ioaudio)      -> copy iorequest for double buffered operation

      times:=         Div(length, buflen)
       rest:=length - Mul(times,  buflen)
      times:=times  - 1

      CopyMem(ptr, chipbuf1, buflen)            -> copy data into chip-ram
      offset          :=buflen
      arequest1.data  :=chipbuf1                -> set pointer to first chip mem buffer
      arequest2.data  :=chipbuf2                -> set pointer to second chip buffer
      arequest1.length:=buflen                  -> set bufferlength
      arequest2.length:=buflen                  -> set bufferlength
      beginIO(arequest1)                        -> start rocking

      ioa:=arequest2                            -> arequest2 is next to be filled

      REPEAT                                    -> until done, start the next buffer while one is playin
         IF times>0
            CopyMem(ptr+offset, ioa.data, buflen)
            beginIO(ioa)                        -> keep on rocking, arequest.length was already set to 'buffer' before the loop
            offset:=offset+buflen
            DEC times

         ELSEIF (times=0) AND (rest<>0)
            CopyMem(ptr+offset, ioa.data, rest)
            ioa.length:=rest                    -> adapt the arequest.length to the remaining length
            beginIO(ioa)
            rest:=0
         ENDIF

         IF ioa =arequest1
            ioa:=arequest2                      -> arequest2 next to be filled
         ELSE
            ioa:=arequest1                      -> arequest1 next to be filled
         ENDIF

         WaitIO(ioa)                            -> the arequest next to be filled is still playing, so we have to wait for it
      UNTIL (times=0) AND (rest=0)

      IF ioa =arequest1                         -> ioal points to the second last arequest
         ioa:=arequest2                         -> now it points to the last arequest which is still playing
      ELSE
         ioa:=arequest1
      ENDIF

      WaitIO(ioa)                               -> wait for the final arequest to finish


   ELSE
      IF (chipbuf1:=AllocVec(length, MEMF_CHIP+MEMF_PUBLIC))=NIL THEN Raise(ER_NOMEM)
      CopyMem(ptr, chipbuf1, length)            -> copy sample data to chip-memory

      arequest1.data  :=chipbuf1
      arequest1.length:=length
      beginIO(arequest1)                        -> let's rock
       WaitIO(arequest1)                        -> wait until finished
   ENDIF

EXCEPT DO
   IF chipbuf2      THEN FreeVec        (chipbuf2)
   IF chipbuf1      THEN FreeVec        (chipbuf1)
   IF deviceerror=0 THEN CloseDevice    (arequest1)
   IF arequest1     THEN DeleteIORequest(arequest1)
   IF reply         THEN DeleteMsgPort  (reply)
   SELECT exception
      CASE ER_NOMEM;    WriteF('no memory\n')
      CASE ER_NOPORT;   WriteF('could not create port\n')
      CASE ER_NOIOREQ;  WriteF('could not create iorequest\n')
      CASE ER_NODEVICE; WriteF('could not open audio-device\n')
      CASE ER_NONE;     WriteF('all OK\n')
   ENDSELECT
ENDPROC

