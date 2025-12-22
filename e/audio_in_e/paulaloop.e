/*************************************************************************
*                                                                        *
*       paulaloop.e  V1.1  21.11.2020  by Rainer "No.3" Müller           *
*                                                                        *
*  an example how to play a short waveform repeatedly and change the     *
*                                                                        *
*  replay-rate and volume on the fly using the ADCMD_PERVOL command      *
*                                                                        *
*  compile: ec paulaloop                                                 *
*                                                                        *
*  use: paulaloop   and follow the instructions in the console window    *
*                                                                        *
*  new in:                                                               *
*                                                                        *
*    V1.0  24.02.2018  first version                                     *
*                                                                        *
*    V1.1  21.11.2020  some code revision i.e. WaitPort => WaitIO        *
*                      The use of REALLY_PAL is only correct for OS3.0+  *
*                                                                        *
*************************************************************************/

MODULE 'amigalib/io',
        'devices/audio',
           'exec/io',     'exec/memory', 'exec/nodes', 'exec/ports',
       'graphics/gfxbase'

ENUM ER_NONE, ER_NOMEM, ER_NOPORT, ER_NOIOREQ, ER_NODEVICE, ER_KICK

CONST NTSC_CLOCK=3579545,
       PAL_CLOCK=3546895

DEF clock


PROC main() HANDLE
DEF gfx:PTR TO gfxbase

   gfx:=gfxbase

   IF KickVersion(39)
      IF gfx.displayflags AND REALLY_PAL  THEN clock:=PAL_CLOCK  ELSE clock:=NTSC_CLOCK
   ELSE
      IF gfx.displayflags AND PAL         THEN clock:=PAL_CLOCK  ELSE clock:=NTSC_CLOCK
      IF KickVersion(37)=FALSE THEN Raise(ER_KICK)
   ENDIF

   play()

EXCEPT DO
   SELECT exception
      CASE ER_KICK; WriteF('Kickstart V37+ required\n')
      CASE ER_NONE; WriteF('all OK\n')
   ENDSELECT
ENDPROC


PROC play() HANDLE
DEF arequest1=NIL:PTR TO ioaudio
DEF arequest2    :       ioaudio
DEF reply1   =NIL:PTR TO mp
DEF reply2   =NIL:PTR TO mp
DEF chipbuf  =NIL:PTR TO CHAR, length=8
DEF deviceerror=1
DEF samplerate=2000
DEF volume=64
DEF button

   IF (chipbuf:=AllocVec(length, MEMF_CHIP+MEMF_PUBLIC))=NIL THEN Raise(ER_NOMEM)
   chipbuf[0]:=   0
   chipbuf[1]:=  90
   chipbuf[2]:= 127     -> fill some CHIP memory
   chipbuf[3]:=  90     -> with some kind of a sine wave  :-D
   chipbuf[4]:=   0
   chipbuf[5]:=- 90
   chipbuf[6]:=-128
   chipbuf[7]:=- 90


   IF (   reply1:=CreateMsgPort()                        )=NIL THEN Raise(ER_NOPORT)
   IF (   reply2:=CreateMsgPort()                        )=NIL THEN Raise(ER_NOPORT)
   IF (arequest1:=CreateIORequest(reply1, SIZEOF ioaudio))=NIL THEN Raise(ER_NOIOREQ)

   arequest1.io.command  :=ADCMD_ALLOCATE
   arequest1.io.flags    :=ADIOF_NOWAIT
   arequest1.io.mn.ln.pri:=ADALLOC_MAXPREC
   arequest1.allockey    :=0
   arequest1.data        :=[1,2,4,8]:CHAR
   arequest1.length      :=4
   IF deviceerror:=OpenDevice('audio.device', 0, arequest1, 0) THEN Raise(ER_NODEVICE)

   arequest1.io.command  :=CMD_WRITE
   arequest1.io.flags    :=ADIOF_PERVOL
   arequest1.data        :=chipbuf
   arequest1.length      :=length
   arequest1.period      :=clock / samplerate
   arequest1.volume      :=volume
   arequest1.cycles      :=800                  -> play the buffer sent to paula 800 times (max 65535, 0 = for ever until stopped)
   beginIO(arequest1)

   Delay(50)                                    -> wait 1 second

   CopyMem(arequest1,arequest2, SIZEOF ioaudio) -> make a copy of the audio request
   arequest2.io.mn.replyport:=reply2            -> assign a new message port to the copy !

   arequest2.io.command:=ADCMD_PERVOL           -> change period and volume
   arequest2.io.flags  :=0                      -> 0 = immediate change
   arequest2.period    :=clock / 2000           -> new period
   arequest2.volume    :=32                     -> new volume
   beginIO(arequest2)                           -> let's go
    WaitIO(arequest2)

   Delay(50)

   arequest2.io.command:=ADCMD_PERVOL           -> let's do a second change !  :-D
   arequest2.io.flags  :=0
   arequest2.period    :=clock / 1000
   arequest2.volume    :=48
   beginIO(arequest2)                           -> let's go
    WaitIO(arequest2)

    WaitIO(arequest1)                           -> wait for the 800 cycles are over


/** interactive part **/

   WriteF('\nnow it is your turn:\n\n')
   WriteF('press left or right mousebutton to increase/decrease the playback rate\n')
   WriteF('press both buttons to exit\n')

   arequest1.period:=clock / samplerate
   arequest1.volume:=volume
   arequest1.cycles:=0                          -> play the buffer forever
   beginIO(arequest1)

   WHILE   (button:=Mouse())<>3
      IF    button
         IF button =1        THEN samplerate:=samplerate + 100   ELSE samplerate:=samplerate - 100
         IF samplerate>28000 THEN samplerate:=28000
         IF samplerate<  100 THEN samplerate:=  100

         arequest2.io.command:=ADCMD_PERVOL
         arequest2.io.flags  :=0
         arequest2.period    :=clock / samplerate
         beginIO(arequest2)
          WaitIO(arequest2)
      ENDIF

      Delay(2)
   ENDWHILE

   AbortIO(arequest1)                           -> abort playback
    WaitIO(arequest1)

EXCEPT DO
   IF chipbuf       THEN FreeVec        (chipbuf)
   IF deviceerror=0 THEN CloseDevice    (arequest1)
   IF arequest1     THEN DeleteIORequest(arequest1)
   IF reply2        THEN DeleteMsgPort  (reply2)
   IF reply1        THEN DeleteMsgPort  (reply1)
   SELECT exception
      CASE ER_NOMEM;    WriteF('no memory\n')
      CASE ER_NOPORT;   WriteF('could not create port\n')
      CASE ER_NOIOREQ;  WriteF('could not create iorequest\n')
      CASE ER_NODEVICE; WriteF('could not open audio-device\n')
      CASE ER_NONE;     WriteF('all OK\n')
   ENDSELECT
ENDPROC


