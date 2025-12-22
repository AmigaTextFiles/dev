OPT OSVERSION=37

MODULE 'devices/audio',
       'dos/dos',
       'exec/memory',
       'exec/types',
       'exec/io'

MODULE 'exec/libraries',
       'exec/nodes',
       'exec/ports',
       'graphics/gfxbase'

/* Offsets required for beginIO() */
CONST IO_DEVICE=20,
      DEV_BEGINIO=-30

DEF gfxBase:PTR TO gfxbase, deviceerror,
    audiomp=NIL:PTR TO mp, audiomsg=NIL:PTR TO mn, audioio: PTR TO ioaudio,
    waveptr:PTR TO CHAR, clock=3579545

PROC beginIO(iorequestptr:PTR TO ioaudio)
  MOVE.L  iorequestptr,A1
  MOVE.L  IO_DEVICE(A1),A6
  JSR     DEV_BEGINIO(A6)
ENDPROC

PROC main ()
  DEF frequency=440, duration=3, samples=2, samcyc=1,
      request:PTR TO iostd, message:PTR TO mn, node:PTR TO ln

  gfxBase:=gfxbase
  IF gfxBase.displayflags AND PAL THEN clock:=3546895
  IF (audioio:=AllocMem(SIZEOF ioaudio,
                        MEMF_PUBLIC+MEMF_CLEAR))=NIL THEN JUMP killaudio
  WriteF('Bloc IO créé...\n')

  IF (audiomp:=CreateMsgPort())=NIL THEN JUMP killaudio
  WriteF('Port créé...\n')

  request:=audioio.io  /* .request */
  message:=request.mn  /* .message */
  message.replyport:=audiomp
  node:=message.ln  /* .node */
  node.pri:=0
  request.command:=ADCMD_ALLOCATE
  request.flags:=ADIOF_NOWAIT
  audioio.allockey:=0
  audioio.data:=[1,2,4,8]:CHAR
  audioio.length:=4
  WriteF('Bloc I/O initialisé pour l\aallocation des canaux...\n')

  IF deviceerror:=OpenDevice('audio.device', 0, audioio, 0) THEN JUMP killaudio
  WriteF('Priphérique Audio ouvert, canaux alloués...\n')
  IF (waveptr:=AllocMem(samples, MEMF_CHIP+MEMF_PUBLIC))=NIL THEN JUMP killaudio
  waveptr[0]:= 127
  waveptr[1]:=-127
  WriteF('Données Wave prêtes...\n')

  request:=audioio.io
  message:=request.mn
  message.replyport:=audiomp
  request.command:=CMD_WRITE
  request.flags:=ADIOF_PERVOL OR IOF_QUICK
  audioio.data:=waveptr
  audioio.length:=samples
  audioio.period:=clock*samcyc/(samples*frequency)
  audioio.volume:=64
  audioio.cycles:=frequency*duration/samcyc
  WriteF('Bloc I/O initialisé pour jouer...\n')

  WriteF('Commence à jouer...\n')
  beginIO(audioio)
  WaitPort(audiomp)
  audiomsg:=GetMsg(audiomp)

  WriteF('Son terminé...\n')

killaudio:
  WriteF('Enlève le périphérique audio...\n')
  IF waveptr THEN FreeMem(waveptr, 2)
  IF deviceerror=0 THEN CloseDevice(audioio)
  IF audiomp THEN DeleteMsgPort(audiomp)
  IF audioio THEN FreeMem(audioio, SIZEOF ioaudio)
ENDPROC

