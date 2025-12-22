MODULE  CyberAVIAudio;

(* $IFNOT DEBUG *)
  (* $StackChk- $OvflChk- $RangeChk- $CaseChk- $ReturnChk- $NilChk- $TypeChk- $OddChk- $ClearVars- *)
(* $END *)

(* /// ------------------------------- "IMPORT" -------------------------------- *)
IMPORT  au:=Audio,
        aus:=AudioSupport,
        cu:=CyberAVIUtils,
        d:=Dos,
        e:=Exec,
        es:=ExecSupport,
        els:=ExecListSupport,
        g:=CyberAVIGlobals,
        i2m:=Intel2Mot,
        io:=AsyncIOSupport,
        mu:=MathUtils,
        o:=CyberAVIOpts,
        ol:=OberonLib,
        s:=CyberAVISync,
        u:=Utility,
        v:=CyberAVIVideo,
        y:=SYSTEM;
(* \\\ ------------------------------------------------------------------------- *)

(* /// -------------------------------- "TYPE" --------------------------------- *)
TYPE    CommonDataPtr=UNTRACED POINTER TO CommonData;
        CommonData=STRUCT
            downScale: BOOLEAN;
        END;


        CodecHeader=STRUCT
            compression: INTEGER;
            channels: INTEGER;
            bits: INTEGER;
            extSize: INTEGER;
            stereo: BOOLEAN;
            description: e.STRING;
            compFactor: LONGINT;
        END;

        ExtendedDataPtr=UNTRACED POINTER TO ExtendedData;
        ExtendedData=STRUCT
        END;

        DecoderProc=PROCEDURE(from{8}: e.APTR;
                              toL{9}: e.APTR;
                              toR{10}: e.APTR;
                              size{0}: LONGINT;
                              spec{11}: CommonDataPtr): LONGINT;

        SampleNodePtr=UNTRACED POINTER TO SampleNode;
        SampleNode=STRUCT (node: e.MinNode)
            freq: LONGINT;
            dataL: e.LSTRPTR;
            dataR: e.LSTRPTR;
            size: LONGINT;
            done: LONGINT;
            id: LONGINT;
        END;
(* \\\ ------------------------------------------------------------------------- *)

(* /// -------------------------------- "CONST" -------------------------------- *)
CONST   waveUnknown=00000H;
        wavePCM=0001H;
        waveMsADPCM=0002H;
        waveIBMCVSD=0005H;
        waveALAW=0006H;
        waveMULAW=0007H;
        waveOkiADPCM=0010H;
        waveDviADPCM=0011H;
        waveDigiStd=0015H;
        waveDigiFix=0016H;
        waveYamahaADPCM=0020H;
        waveDSPTrueSpeech=0022H;
        waveMsGSM610=0031H;
        ibmMULAW=0101H;
        ibmALAW=0102H;
        ibmADPCM=0103H;

        codecSupported * =1;
        codecUnknown * =0;
        codecUnsupported * =-1;

        maxAudioHWSize=131072;
(* \\\ ------------------------------------------------------------------------- *)

(* /// --------------------------------- "VAR" --------------------------------- *)
VAR     mainData: e.LSTRPTR;
        mainPort: e.MsgPortPtr;
        mainIO: au.IOAudioPtr;
        leftData: ARRAY 2 OF e.LSTRPTR;
        leftPort: ARRAY 2 OF e.MsgPortPtr;
        leftIO: ARRAY 2 OF au.IOAudioPtr;
        rightData: ARRAY 2 OF e.LSTRPTR;
        rightPort: ARRAY 2 OF e.MsgPortPtr;
        rightIO: ARRAY 2 OF au.IOAudioPtr;
        audioOpen - : BOOLEAN;
        decoderProc: DecoderProc;
        decoderSpec: CommonDataPtr;
        audioFreq: LONGINT;
        audioBufferSize: LONGINT;
        audioSizeScale: LONGINT;
        currSample: SHORTINT;
        stereo: BOOLEAN;
        playing: BOOLEAN;
        bufPlaying: ARRAY 2 OF BOOLEAN;
        currentRead: LONGINT;
        maxRead: LONGINT;
        totalRead: LONGINT;
        totalAudioSize: LONGINT;
        initFrames: LONGINT;
        extendedData: ExtendedDataPtr;
        sampleQueue: els.Queue;
        audioSigs - :  LONGSET;
        mustPreload * : BOOLEAN;
(* \\\ ------------------------------------------------------------------------- *)

(* /// --------------------- "PROCEDURE FlushQueueFunc()" ---------------------- *)
PROCEDURE FlushQueueFunc(n: e.CommonNodePtr);
BEGIN
  DISPOSE(n(SampleNodePtr).dataL);
  DISPOSE(n(SampleNodePtr).dataR);
  DISPOSE(n);
END FlushQueueFunc;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ---------------------- "PROCEDURE ReadExtension()" ---------------------- *)
PROCEDURE ReadExtension * (size: LONGINT);
BEGIN
  IF size>0 THEN
    ol.New(extendedData,size);
    io.Read(extendedData,size);
  ELSE
    extendedData:=NIL;
  END;
END ReadExtension;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ----------------------- "PROCEDURE CloseAudio()" ------------------------ *)
PROCEDURE CloseAudio();

VAR     cnt: INTEGER;

BEGIN
  IF audioOpen THEN e.CloseDevice(mainIO); audioOpen:=FALSE; END;
  IF mainIO#NIL THEN e.DeleteIORequest(mainIO); mainIO:=NIL; END;
  IF mainPort#NIL THEN e.DeleteMsgPort(mainPort); mainPort:=NIL; END;
  FOR cnt:=0 TO 1 DO
    IF leftIO[cnt]#NIL THEN e.DeleteIORequest(leftIO[cnt]); leftIO[cnt]:=NIL; END;
    IF rightIO[cnt]#NIL THEN e.DeleteIORequest(rightIO[cnt]); rightIO[cnt]:=NIL; END;
    IF leftPort[cnt]#NIL THEN e.DeleteMsgPort(leftPort[cnt]); leftPort[cnt]:=NIL; END;
    IF rightPort[cnt]#NIL THEN e.DeleteMsgPort(rightPort[cnt]); rightPort[cnt]:=NIL; END;
  END;
END CloseAudio;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ------------------------ "PROCEDURE OpenAudio()" ------------------------ *)
PROCEDURE OpenAudio();

VAR     cnt: INTEGER;

BEGIN
  playing:=FALSE;
  bufPlaying[0]:=FALSE;
  bufPlaying[1]:=FALSE;
  currSample:=0;
  es.NewList(sampleQueue);
  mainPort:=e.CreateMsgPort();
  IF mainPort=NIL THEN
    d.PrintF("Can't create audio message port\n");
    CloseAudio();
  END;
  mainIO:=e.CreateIORequest(mainPort,SIZE(mainIO^));
  IF mainIO=NIL THEN
    d.PrintF("Can't create audio iorequest\n");
    CloseAudio();
  END;

  FOR cnt:=0 TO 1 DO
    leftPort[cnt]:=e.CreateMsgPort();
    rightPort[cnt]:=e.CreateMsgPort();
    IF (leftPort[cnt]=NIL) OR (rightPort[cnt]=NIL) THEN
      d.PrintF("Can't create audio message port\n");
      CloseAudio();
    END;
    leftIO[cnt]:=e.CreateIORequest(leftPort[cnt],SIZE(leftIO[cnt]^));
    rightIO[cnt]:=e.CreateIORequest(rightPort[cnt],SIZE(rightIO[cnt]^));
    IF (leftIO[cnt]=NIL) OR (rightIO[cnt]=NIL) THEN
      d.PrintF("Can't create audio iorequest\n");
      CloseAudio();
    END;
  END;
  mainIO.request.message.node.pri:=au.allocMaxprec;
  mainIO.data:=y.ADR(aus.channelMap);
  mainIO.length:=aus.channelSize;
  audioOpen:=(e.OpenDevice(au.audioName,0,mainIO,LONGSET{})=0);
  IF ~audioOpen THEN
    d.PrintF("Can't open audio.device!\n");
    CloseAudio();
  ELSE
    aus.CopyUnit(mainIO,leftIO[0],aus.leftOnly);
    aus.CopyUnit(mainIO,leftIO[1],aus.leftOnly);
    aus.CopyUnit(mainIO,rightIO[0],aus.rightOnly);
    aus.CopyUnit(mainIO,rightIO[1],aus.rightOnly);
    aus.ResetAudio(mainIO);
    aus.StopAudio(mainIO);
  END;
END OpenAudio;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ----------------------- "PROCEDURE PlaySample()" ------------------------ *)
PROCEDURE PlaySample * (forceWait: BOOLEAN);

VAR     node: SampleNodePtr;
        freq: LONGINT;
        dataL: e.LSTRPTR;
        dataR: e.LSTRPTR;
        size: LONGINT;
        offset: LONGINT;
        reUse: BOOLEAN;

BEGIN
  IF ~playing THEN RETURN; END;
  IF bufPlaying[currSample] THEN
    IF s.speedChanged THEN
      IF e.CheckIO(leftIO[currSample])=NIL THEN e.AbortIO(leftIO[currSample]); END;
      IF e.CheckIO(rightIO[currSample])=NIL THEN e.AbortIO(rightIO[currSample]); END;
    ELSIF ~forceWait THEN
      (* d.PrintF("check %ld\n",currSample); *)
      IF (e.CheckIO(leftIO[currSample])=NIL) OR (e.CheckIO(rightIO[currSample])=NIL) THEN (* d.PrintF("still playing\n"); *) RETURN; END; (* Sample wird noch gespielt *)
      (* d.PrintF("wait %ld\n",currSample); *)
    END;
    y.SETREG(0,e.WaitIO(leftIO[currSample]));
    y.SETREG(0,e.WaitIO(rightIO[currSample]));
  END;
  node:=els.First(sampleQueue);
  IF node#NIL THEN
    freq:=node.freq;
    size:=node.size;
    offset:=node.done;
    (* d.PrintF("rem: %08lx, %7ld, %7ld, %8ld\n",node,size,offset,node.id); *)
    reUse:=FALSE;
    IF size>maxAudioHWSize THEN
      IF offset+maxAudioHWSize<size THEN
        size:=maxAudioHWSize;
        reUse:=TRUE;
      ELSE
        size:=size-offset;
      END;
    END;
    dataL:=leftData[currSample];
    e.CopyMemAPTR(y.ADR(node.dataL[offset]),dataL,size);
    IF stereo THEN
      dataR:=rightData[currSample];
      e.CopyMemAPTR(y.ADR(node.dataR[offset]),dataR,size);
    ELSE
      dataR:=dataL;
    END;
    aus.WriteAudio(leftIO[currSample],dataL,size,freq,64);
    aus.WriteAudio(rightIO[currSample],dataR,size,freq,64);
    bufPlaying[currSample]:=TRUE;
    currSample:=1-currSample;
    audioSigs:=LONGSET{leftPort[currSample].sigBit,rightPort[currSample].sigBit};
    IF reUse THEN
      INC(node.done,maxAudioHWSize);
    ELSIF mustPreload & o.doLoop THEN
      node.done:=0;
      y.SETREG(0,els.Dequeue(sampleQueue));
      els.Enqueue(sampleQueue,node);
    ELSE
      y.SETREG(0,els.Dequeue(sampleQueue));
      FlushQueueFunc(node);
    END;
  END;
END PlaySample;
(* \\\ ------------------------------------------------------------------------- *)

(* /// --------------------- "PROCEDURE Wait4LastSample()" --------------------- *)
PROCEDURE Wait4LastSample * (aborted: BOOLEAN);
BEGIN
  IF ~aborted THEN
    IF mustPreload & o.doLoop THEN
      els.Flush(sampleQueue,FlushQueueFunc);
    ELSE
      WHILE ~es.ListEmpty(sampleQueue) DO PlaySample(~s.speedChanged); END;
    END;
  END;
END Wait4LastSample;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ----------------------- "PROCEDURE StartSound()" ------------------------ *)
PROCEDURE StartSound * ();
BEGIN
  IF ~playing THEN
    playing:=TRUE;
    IF ~bufPlaying[0] THEN PlaySample(FALSE); END;
    IF bufPlaying[0] THEN
(* /// "$IF RUNDEBUG" *)
      IF o.debug THEN d.PrintF("starting audio\n"); END;
(* \\\ $END *)
      aus.StartAudio(mainIO);
    ELSE
      playing:=FALSE;
    END;
  END;
END StartSound;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ------------------------ "PROCEDURE StopSound()" ------------------------ *)
PROCEDURE StopSound * (aborted: BOOLEAN);
BEGIN
  (* IF es.ListEmpty(sampleQueue) THEN d.PrintF("empty\n"); END; *)
  IF playing THEN
    IF ~aborted & ~s.speedChanged THEN
      y.SETREG(0,e.Wait(LONGSET{leftPort[1-currSample].sigBit}));
      y.SETREG(0,e.Wait(LONGSET{rightPort[1-currSample].sigBit}));
    END;
    IF bufPlaying[1-currSample] THEN
      WHILE e.CheckIO(leftIO[1-currSample])=NIL DO e.AbortIO(leftIO[1-currSample]); END;
      y.SETREG(0,e.WaitIO(leftIO[1-currSample]));
      WHILE e.CheckIO(rightIO[1-currSample])=NIL DO e.AbortIO(rightIO[1-currSample]); END;
      y.SETREG(0,e.WaitIO(rightIO[1-currSample]));
    END;
    IF bufPlaying[currSample] THEN
      WHILE e.CheckIO(leftIO[currSample])=NIL DO e.AbortIO(leftIO[currSample]); END;
      y.SETREG(0,e.WaitIO(leftIO[currSample]));
      WHILE e.CheckIO(rightIO[currSample])=NIL DO e.AbortIO(rightIO[currSample]); END;
      y.SETREG(0,e.WaitIO(rightIO[currSample]));
    END;
    aus.StopAudio(mainIO);
  END;
  playing:=FALSE;
  bufPlaying[0]:=FALSE;
  bufPlaying[1]:=FALSE;
  currSample:=0;
  CloseAudio();
  OpenAudio();
END StopSound;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ----------------------- "PROCEDURE PauseSound()" ------------------------ *)
PROCEDURE PauseSound * (pause: BOOLEAN);
BEGIN
  IF pause THEN
    aus.StopAudio(mainIO);
  ELSE
    aus.StartAudio(mainIO);
  END;
END PauseSound;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ---------------------------- "TYPE PCMData" ----------------------------- *)
TYPE    PCMDataPtr=UNTRACED POINTER TO PCMData;
        PCMData=STRUCT (common: CommonData)
        END;

VAR     pcmData: PCMDataPtr;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ----------------------- "PROCEDURE DecodePCM8()" ------------------------ *)
PROCEDURE DecodePCM8Mono {"_DecodePCM8Mono"} (from{8}: e.APTR;
                                              toL{9}: e.APTR;
                                              toR{10}: e.APTR;
                                              size{0}: LONGINT;
                                              spec{11}: CommonDataPtr): LONGINT;

PROCEDURE DecodePCM8Stereo {"_DecodePCM8Stereo"} (from{8}: e.APTR;
                                                  toL{9}: e.APTR;
                                                  toR{10}: e.APTR;
                                                  size{0}: LONGINT;
                                                  spec{11}: CommonDataPtr): LONGINT;

PROCEDURE SetupPCM8(codec: CodecHeader);
BEGIN
  IF pcmData=NIL THEN NEW(pcmData); END;
  IF codec.stereo THEN
    decoderProc:=DecodePCM8Stereo;
  ELSE
    decoderProc:=DecodePCM8Mono;
  END;
  decoderSpec:=pcmData;
END SetupPCM8;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ----------------------- "PROCEDURE DecodePCM16()" ----------------------- *)
PROCEDURE DecodePCM16Mono {"_DecodePCM16Mono"} (from{8}: e.APTR;
                                                toL{9}: e.APTR;
                                                toR{10}: e.APTR;
                                                size{0}: LONGINT;
                                                spec{11}: CommonDataPtr): LONGINT;


PROCEDURE DecodePCM16Stereo {"_DecodePCM16Stereo"} (from{8}: e.APTR;
                                                    toL{9}: e.APTR;
                                                    toR{10}: e.APTR;
                                                    size{0}: LONGINT;
                                                    spec{11}: CommonDataPtr): LONGINT;

PROCEDURE SetupPCM16(codec: CodecHeader);
BEGIN
  IF pcmData=NIL THEN NEW(pcmData); END;
  IF codec.stereo THEN
    decoderProc:=DecodePCM16Stereo;
  ELSE
    decoderProc:=DecodePCM16Mono;
  END;
  decoderSpec:=pcmData;
END SetupPCM16;
(* \\\ ------------------------------------------------------------------------- *)

(* /// -------------------------- "TYPE MSADPCMData" --------------------------- *)
TYPE    MSADPCMDataPtr=UNTRACED POINTER TO MSADPCMData;
        MSADPCMData=STRUCT (common: CommonData)
            samplesPerBlock: INTEGER;
        END;

        MSADPCMExtDataPtr=UNTRACED POINTER TO MSADPCMExtData;
        MSADPCMExtData=STRUCT(dummy: ExtendedData)
            samplesPerBlock: INTEGER;
            numCoefs: INTEGER;
        END;

VAR     msAdpcmData: MSADPCMDataPtr;
(* \\\ ------------------------------------------------------------------------- *)

(* /// --------------------- "PROCEDURE DecodeMSADPCM4()" ---------------------- *)
PROCEDURE DecodeMSADPCM4Mono {"_DecodeMSADPCM4Mono"} (from{8}: e.APTR;
                                                      toL{9}: e.APTR;
                                                      toR{10}: e.APTR;
                                                      size{0}: LONGINT;
                                                      spec{11}: CommonDataPtr): LONGINT;

PROCEDURE DecodeMSADPCM4Stereo {"_DecodeMSADPCM4Stereo"} (from{8}: e.APTR;
                                                          toL{9}: e.APTR;
                                                          toR{10}: e.APTR;
                                                          size{0}: LONGINT;
                                                          spec{11}: CommonDataPtr): LONGINT;

PROCEDURE SetupMSADPCM4(codec: CodecHeader);
BEGIN
  IF msAdpcmData=NIL THEN NEW(msAdpcmData); END;
  IF (extendedData#NIL) & (g.animInfo.auds.strf.extSize>=2) THEN
    msAdpcmData.samplesPerBlock:=i2m.LSB2MSBShort(extendedData(MSADPCMExtData).samplesPerBlock);
  ELSE
    d.PrintF("No extension data for MS ADPCM!\n");
  END;
  IF codec.stereo THEN
    decoderProc:=DecodeMSADPCM4Stereo;
  ELSE
    decoderProc:=DecodeMSADPCM4Mono;
  END;
  decoderSpec:=msAdpcmData;
END SetupMSADPCM4;
(* \\\ ------------------------------------------------------------------------- *)

(* /// -------------------------- "TYPE DVIADPCMData" -------------------------- *)
TYPE    DVIADPCMDataPtr=UNTRACED POINTER TO DVIADPCMData;
        DVIADPCMData=STRUCT (common: CommonData)
            blockCnt: INTEGER;
        END;

        DVIADPCMExtDataPtr=UNTRACED POINTER TO DVIADPCMExtData;
        DVIADPCMExtData=STRUCT(dummy: ExtendedData)
            blockCnt: INTEGER;
        END;

VAR     dviAdpcmData: DVIADPCMDataPtr;
(* \\\ ------------------------------------------------------------------------- *)

(* /// --------------------- "PROCEDURE DecodeDVIADPCM4()" --------------------- *)
PROCEDURE DecodeDVIADPCM4Mono {"_DecodeDVIADPCM4Mono"} (from{8}: e.APTR;
                                                        toL{9}: e.APTR;
                                                        toR{10}: e.APTR;
                                                        size{0}: LONGINT;
                                                        spec{11}: CommonDataPtr): LONGINT;

PROCEDURE DecodeDVIADPCM4Stereo {"_DecodeDVIADPCM4Stereo"} (from{8}: e.APTR;
                                                            toL{9}: e.APTR;
                                                            toR{10}: e.APTR;
                                                            size{0}: LONGINT;
                                                            spec{11}: CommonDataPtr): LONGINT;

PROCEDURE SetupDVIADPCM4(codec: CodecHeader);
BEGIN
  IF dviAdpcmData=NIL THEN NEW(dviAdpcmData); END;
  IF (extendedData#NIL) & (g.animInfo.auds.strf.extSize>=2) THEN
    dviAdpcmData.blockCnt:=i2m.LSB2MSBShort(extendedData(DVIADPCMExtData).blockCnt);
  ELSE
    d.PrintF("No extension data for DVI ADPCM!\n");
  END;
  IF codec.stereo THEN
    decoderProc:=DecodeDVIADPCM4Stereo;
  ELSE
    decoderProc:=DecodeDVIADPCM4Mono;
  END;
  decoderSpec:=dviAdpcmData;
END SetupDVIADPCM4;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ----------------------- "PROCEDURE CodecQuery()" ------------------------ *)
PROCEDURE CodecQuery * (VAR codec: CodecHeader): LONGINT;

VAR     ret: LONGINT;

BEGIN
  ret:=codecSupported;
  codec.stereo:=(codec.channels>1);
  CASE codec.compression OF
  | wavePCM:
      codec.description:="PCM";
      codec.compFactor:=1;
      IF codec.bits=8 THEN
        SetupPCM8(codec);
      ELSIF codec.bits=16 THEN
        SetupPCM16(codec);
      ELSE
        ret:=codecUnsupported;
      END;
  | waveMsADPCM:
      codec.description:="Microsoft ADPCM";
      codec.compFactor:=2;
      IF codec.bits=4 THEN
        SetupMSADPCM4(codec);
      ELSE
        ret:=codecUnsupported;
      END;
  | waveDviADPCM:
      codec.description:="DVI ADPCM";
      codec.compFactor:=2;
      IF codec.bits=4 THEN
        SetupDVIADPCM4(codec);
      ELSE
        ret:=codecUnsupported;
      END;
  | waveIBMCVSD:
      codec.description:="IBM CVSD";
      ret:=codecUnsupported;
  | waveALAW:
      codec.description:="a-Law";
      ret:=codecUnsupported;
  | waveMULAW:
      codec.description:="µ-Law";
      ret:=codecUnsupported;
  | waveOkiADPCM:
      codec.description:="Oki ADPCM";
      ret:=codecUnsupported;
  | waveYamahaADPCM:
      codec.description:="Yamaha ADPCM";
      ret:=codecUnsupported;
  | waveDSPTrueSpeech:
      codec.description:="DSP TrueSpeech";
      ret:=codecUnsupported;
  | waveMsGSM610:
      codec.description:="Microsoft GSM610";
      ret:=codecUnsupported;
  | ibmMULAW:
      codec.description:="IBM µ-Law";
      ret:=codecUnsupported;
  | ibmALAW:
      codec.description:="IBM a-Law";
      ret:=codecUnsupported;
  | ibmADPCM:
      codec.description:="IBM ADPCM";
      ret:=codecUnsupported;
  ELSE
    codec.description:="unknown";
    ret:=codecUnknown;
  END;
  RETURN ret;
END CodecQuery;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ---------------------- "PROCEDURE CheckAudioDMA()" ---------------------- *)
PROCEDURE CheckAudioDMA(freq: LONGINT): LONGINT;
BEGIN
  IF (freq>27000) & ~v.doubleScanned THEN
    decoderSpec.downScale:=TRUE;
    freq:=freq DIV 2;
  ELSE
    decoderSpec.downScale:=FALSE;
  END;
  RETURN freq;
END CheckAudioDMA;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ----------------------- "PROCEDURE DecodeFrame()" ----------------------- *)
PROCEDURE DecodeFrame * (size: LONGINT);

VAR     node: SampleNodePtr;
        decSize: LONGINT;

BEGIN
  IF audioFreq=-1 THEN audioFreq:=CheckAudioDMA(g.animInfo.auds.strf.samplesPerSec); END;
  IF size>1 THEN
    io.Read(mainData,size);
    NEW(node);
    decSize:=i2m.Round(size*audioSizeScale,e.blockSize);
    ol.New(node.dataL,decSize);
    IF stereo THEN ol.New(node.dataR,decSize); END;
    decSize:=decoderProc(mainData,node.dataL,node.dataR,size,decoderSpec);
    node.freq:=audioFreq;
    node.size:=decSize;
    node.done:=0;
    (* node.id:=u.GetUniqueID(); *)
    els.Enqueue(sampleQueue,node);
  END;
END DecodeFrame;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ------------------------- "PROCEDURE Preload()" ------------------------- *)
PROCEDURE Preload * (offset: LONGINT;
                     size: LONGINT);
BEGIN
(* /// "$IF RUNDEBUG" *)
  IF o.debug THEN d.PrintF("preload single audio frame (offset: %ld, size: %ld)\n",offset,size); END;
(* \\\ $END *)
  io.SeekTo(offset);
  DecodeFrame(size);
END Preload;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ---------------------- "PROCEDURE AllocBuffers()" ----------------------- *)
PROCEDURE AllocBuffers * (): BOOLEAN;

VAR     codec: CodecHeader;
        cnt: INTEGER;
        ret: BOOLEAN;
        round: LONGINT;
        samplesPerSec: LONGINT;
        bytesPerSec: LONGINT;
        fps: LONGINT;

BEGIN
  ret:=TRUE;
  codec.compression:=g.animInfo.auds.strf.format;
  codec.bits:=g.animInfo.auds.strf.bitsPerSample;
  codec.channels:=g.animInfo.auds.strf.channels;
  codec.extSize:=g.animInfo.auds.strf.extSize;
  CASE CodecQuery(codec) OF
  | codecUnsupported:
      d.PrintF("  Unsupported audio encoding: %s, %ld bits, %ld channels\n",y.ADR(codec.description),
                                                                            codec.bits,
                                                                            codec.channels);
      IF ~o.noSound THEN d.PrintF("Continuing without sound\n"); END;
      ret:=FALSE;
  | codecUnknown:
      d.PrintF("  Unknown audio encoding: $%08lx, %ld bits, %ld channels\n",codec.compression,
                                                                            codec.bits,
                                                                            codec.channels);
      IF ~o.noSound THEN d.PrintF("Continuing without sound\n"); END;
      ret:=FALSE;
  ELSE
    IF ~o.quiet THEN
      IF codec.stereo THEN
        d.PrintF("  Audio: %s %ld bit Stereo, %lD Hz\n",y.ADR(codec.description),
                                                        codec.bits,
                                                        g.animInfo.auds.strf.samplesPerSec);
      ELSE
        d.PrintF("  Audio: %s %ld bit Mono, %lD Hz\n",y.ADR(codec.description),
                                                      codec.bits,
                                                      g.animInfo.auds.strf.samplesPerSec);
      END;
    END;
    IF ~o.noSound THEN (* soll überhaupt was gespielt werden?? *)
      stereo:=codec.stereo;
      IF ~(8 IN g.animInfo.avih.flags) & (g.animInfo.avih.initialFrames=0) & (g.animInfo.auds.strh.length#0) & (g.animInfo.auds.strh.suggestedBufferSize=0) THEN
        bytesPerSec:=g.animInfo.auds.strh.length*g.animInfo.auds.strh.sampleSize; (* früher *....scale *)
        samplesPerSec:=mu.min(bytesPerSec,maxAudioHWSize);
        mustPreload:=TRUE;
      ELSE
        bytesPerSec:=g.animInfo.auds.strf.avgBytesPerSec;
        samplesPerSec:=g.animInfo.auds.strf.samplesPerSec;
        mustPreload:=FALSE;
      END;
      round:=mu.max(g.animInfo.auds.strf.blockAlign,64); (* 8 reicht nicht immer *)
      bytesPerSec:=i2m.Round(bytesPerSec,round);
      samplesPerSec:=i2m.Round(samplesPerSec,round);
      IF codec.compFactor#1 THEN samplesPerSec:=mu.max(samplesPerSec,bytesPerSec*codec.compFactor); END;
      DISPOSE(mainData);
      ol.New(mainData,bytesPerSec); (* Speicher für eine Sekunde allokieren *)
      INCL(ol.MemReqs,e.chip);
      FOR cnt:=0 TO 1 DO
        DISPOSE(leftData[cnt]);
        DISPOSE(rightData[cnt]);
        ol.New(leftData[cnt],samplesPerSec);
        IF stereo THEN ol.New(rightData[cnt],samplesPerSec); END;
      END;
      EXCL(ol.MemReqs,e.chip);
      audioFreq:=-1;
      audioBufferSize:=mu.min(bytesPerSec,maxAudioHWSize);
      audioSigs:=LONGSET{};
      audioSizeScale:=codec.compFactor;
    END;
  END;
  es.NewList(sampleQueue);
  RETURN ret;
END AllocBuffers;
(* \\\ ------------------------------------------------------------------------- *)

BEGIN
  OpenAudio();
CLOSE
  CloseAudio();
END CyberAVIAudio.
