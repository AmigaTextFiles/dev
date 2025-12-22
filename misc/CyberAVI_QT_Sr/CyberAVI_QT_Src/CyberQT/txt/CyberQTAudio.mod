MODULE  CyberQTAudio;

(* $IFNOT DEBUG *)
  (* $StackChk- $OvflChk- $RangeChk- $CaseChk- $ReturnChk- $NilChk- $TypeChk- $OddChk- $ClearVars- *)
(* $END *)

(* /// ------------------------------- "IMPORT" -------------------------------- *)
IMPORT  au:=Audio,
        aus:=AudioSupport,
        cu:=CyberQTUtils,
        d:=Dos,
        e:=Exec,
        es:=ExecSupport,
        els:=ExecListSupport,
        fp:=FixedPoint,
        g:=CyberQTGlobals,
        i2m:=Intel2Mot,
        io:=AsyncIOSupport2,
        mu:=MathUtils,
        o:=CyberQTOpts,
        ol:=OberonLib,
        s:=CyberQTSync,
        u:=Utility,
        v:=CyberQTVideo,
        y:=SYSTEM;
(* \\\ ------------------------------------------------------------------------- *)

(* /// -------------------------------- "TYPE" --------------------------------- *)
TYPE    CommonDataPtr=UNTRACED POINTER TO CommonData;
        CommonData=STRUCT
            downScale: BOOLEAN;
        END;

        DecoderProc=PROCEDURE(from{8}: e.APTR;
                              toL{9}: e.APTR;
                              toR{10}: e.APTR;
                              size{0}: LONGINT;
                              spec{11}: CommonDataPtr): LONGINT;

        CodecHeader=STRUCT
            decoder: DecoderProc;
            special: CommonDataPtr;
            frequency: LONGINT;
            compression: LONGINT;
            channels: INTEGER;
            bits: INTEGER;
            stereo: BOOLEAN;
            realCompression: BOOLEAN;
            compressFactor: REAL;
            description: e.STRING;
        END;

        CodecArray=UNTRACED POINTER TO ARRAY MAX(INTEGER) OF CodecHeader;

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
CONST   idraw =y.VAL(LONGINT,"raw ");
        idraw0=0;
        idtwos=y.VAL(LONGINT,"twos");
        idMAC3=y.VAL(LONGINT,"MAC3");
        idMAC6=y.VAL(LONGINT,"MAC6");
        idima4=y.VAL(LONGINT,"ima4");
        idulaw=y.VAL(LONGINT,"µlaw");

        codecSupported * =1;
        codecUnknown * =0;
        codecUnsupported * =-1;

        maxAudioHWSize=131072;
(* \\\ ------------------------------------------------------------------------- *)

(* /// --------------------------------- "VAR" --------------------------------- *)
VAR     audioFile: io.ASFile;
        mainData: e.LSTRPTR;
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
        decoderSpec: e.APTR;
        audioFreq: LONGINT;
        audioBufferSize - : LONGINT;
        currSample: SHORTINT;
        playing: BOOLEAN;
        bufPlaying: ARRAY 2 OF BOOLEAN;
        stereo: BOOLEAN;
        splittedStereo - : BOOLEAN;
        sampleSize: LONGINT;
        codecs: CodecArray;
        codecCnt: LONGINT;
        currentCodec: LONGINT;
        audioSizeScale: LONGINT;
        sampleQueue: els.Queue;
        audioSigs - : LONGSET;
        (* fh: d.FileHandlePtr; *)
(* \\\ ------------------------------------------------------------------------- *)

(* /// --------------------- "PROCEDURE FlushQueueFunc()" ---------------------- *)
PROCEDURE FlushQueueFunc(n: e.CommonNodePtr);
BEGIN
  DISPOSE(n(SampleNodePtr).dataL);
  DISPOSE(n(SampleNodePtr).dataR);
  DISPOSE(n);
END FlushQueueFunc;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ----------------------- "PROCEDURE CloseAudio()" ------------------------ *)
PROCEDURE CloseAudio();

VAR     cnt: INTEGER;

BEGIN
  els.Flush(sampleQueue,FlushQueueFunc);
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
    d.PrintF("Can't create audio message port!\n");
    CloseAudio();
  END;
  mainIO:=e.CreateIORequest(mainPort,SIZE(mainIO^));
  IF mainIO=NIL THEN
    d.PrintF("Can't create audio iorequest!\n");
    CloseAudio();
  END;

  FOR cnt:=0 TO 1 DO
    leftPort[cnt]:=e.CreateMsgPort();
    rightPort[cnt]:=e.CreateMsgPort();
    IF (leftPort[cnt]=NIL) OR (rightPort[cnt]=NIL) THEN
      d.PrintF("Can't create audio message port!\n");
      CloseAudio();
    END;
    leftIO[cnt]:=e.CreateIORequest(leftPort[cnt],SIZE(leftIO[cnt]^));
    rightIO[cnt]:=e.CreateIORequest(rightPort[cnt],SIZE(rightIO[cnt]^));
    IF (leftIO[cnt]=NIL) OR (rightIO[cnt]=NIL) THEN
      d.PrintF("Can't create audio iorequest!\n");
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
    IF stereo OR splittedStereo THEN
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
    ELSIF o.audioPreload & o.doLoop THEN
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
    WHILE ~es.ListEmpty(sampleQueue) DO PlaySample(~s.speedChanged); END;
  END;
END Wait4LastSample;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ----------------------- "PROCEDURE StartSound()" ------------------------ *)
PROCEDURE StartSound * ();
BEGIN
  IF ~playing THEN
    (* d.PrintF("start\n"); *)
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

(* /// -------------------------- "TYPE IMAADPCMData" -------------------------- *)
TYPE    IMAADPCMDataPtr=UNTRACED POINTER TO IMAADPCMData;
        IMAADPCMData=STRUCT (common: CommonData)
        END;

VAR     imaAdpcmData: IMAADPCMDataPtr;
(* \\\ ------------------------------------------------------------------------- *)

(* /// --------------------- "PROCEDURE DecodeIMAADPCM4()" --------------------- *)
PROCEDURE DecodeIMAADPCM4Mono {"_DecodeIMAADPCM4Mono"} (from{8}: e.APTR;
                                                        toL{9}: e.APTR;
                                                        toR{10}: e.APTR;
                                                        size{0}: LONGINT;
                                                        spec{11}: CommonDataPtr): LONGINT;

PROCEDURE DecodeIMAADPCM4Stereo {"_DecodeIMAADPCM4Stereo"} (from{8}: e.APTR;
                                                            toL{9}: e.APTR;
                                                            toR{10}: e.APTR;
                                                            size{0}: LONGINT;
                                                            spec{11}: CommonDataPtr): LONGINT;

PROCEDURE SetupIMAADPCM4(VAR codec: CodecHeader);
BEGIN
  IF imaAdpcmData=NIL THEN NEW(imaAdpcmData); END;
  IF codec.stereo THEN
    codec.decoder:=DecodeIMAADPCM4Stereo;
  ELSE
    codec.decoder:=DecodeIMAADPCM4Mono;
  END;
  codec.realCompression:=TRUE;
  codec.compressFactor:=1/4;
  codec.special:=imaAdpcmData
END SetupIMAADPCM4;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ---------------------------- "TYPE MACEData" ---------------------------- *)
TYPE    MACEDataPtr=UNTRACED POINTER TO MACEData;
        MACEData=STRUCT (common: CommonData)
        END;

VAR     maceData: MACEDataPtr;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ----------------------- "PROCEDURE SetupMACE3()" ------------------------ *)
PROCEDURE DecodeMACE3Mono {"_DecodeMACE3Mono"} (from{8}: e.APTR;
                                                toL{9}: e.APTR;
                                                toR{10}: e.APTR;
                                                size{0}: LONGINT;
                                                spec{11}: CommonDataPtr): LONGINT;

PROCEDURE DecodeMACE3Stereo {"_DecodePCM8Stereo"} (from{8}: e.APTR;
                                                   toL{9}: e.APTR;
                                                   toR{10}: e.APTR;
                                                   size{0}: LONGINT;
                                                   spec{11}: CommonDataPtr): LONGINT;

PROCEDURE SetupMACE3(VAR codec: CodecHeader);
BEGIN
  IF maceData=NIL THEN NEW(maceData); END;
  IF codec.stereo THEN
    codec.decoder:=DecodeMACE3Stereo;
  ELSE
    codec.decoder:=DecodeMACE3Mono;
  END;
  codec.realCompression:=TRUE;
  codec.compressFactor:=1/3;
  codec.special:=maceData;
END SetupMACE3;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ----------------------- "PROCEDURE SetupMACE6()" ------------------------ *)
PROCEDURE DecodeMACE6Mono {"_DecodeMACE6Mono"} (from{8}: e.APTR;
                                                toL{9}: e.APTR;
                                                toR{10}: e.APTR;
                                                size{0}: LONGINT;
                                                spec{11}: CommonDataPtr): LONGINT;

PROCEDURE DecodeMACE6Stereo {"_DecodeMACE6Stereo"} (from{8}: e.APTR;
                                                    toL{9}: e.APTR;
                                                    toR{10}: e.APTR;
                                                    size{0}: LONGINT;
                                                    spec{11}: CommonDataPtr): LONGINT;

PROCEDURE SetupMACE6(VAR codec: CodecHeader);
BEGIN
  IF maceData=NIL THEN NEW(maceData); END;
  IF codec.stereo THEN
    codec.decoder:=DecodeMACE6Stereo;
  ELSE
    codec.decoder:=DecodeMACE6Mono;
  END;
  codec.realCompression:=TRUE;
  codec.compressFactor:=1/6;
  codec.special:=maceData;
END SetupMACE6;
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

PROCEDURE SetupPCM8(VAR codec: CodecHeader);
BEGIN
  IF pcmData=NIL THEN NEW(pcmData); END;
  IF codec.stereo THEN
    codec.decoder:=DecodePCM8Stereo;
  ELSE
    codec.decoder:=DecodePCM8Mono;
  END;
  codec.realCompression:=FALSE;
  codec.compressFactor:=1;
  codec.special:=pcmData;
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

PROCEDURE SetupPCM16(VAR codec: CodecHeader);
BEGIN
  IF pcmData=NIL THEN NEW(pcmData); END;
  IF codec.stereo THEN
    codec.decoder:=DecodePCM16Stereo;
  ELSE
    codec.decoder:=DecodePCM16Mono;
  END;
  codec.realCompression:=FALSE;
  codec.compressFactor:=1;
  codec.special:=pcmData;
END SetupPCM16;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ---------------------------- "TYPE TWOSData" ---------------------------- *)
TYPE    TWOSDataPtr=UNTRACED POINTER TO TWOSData;
        TWOSData=STRUCT (common: CommonData)
        END;

VAR     twosData: TWOSDataPtr;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ----------------------- "PROCEDURE DecodeTWOS8()" ----------------------- *)
PROCEDURE DecodeTWOS8Mono {"_DecodeTWOS8Mono"} (from{8}: e.APTR;
                                                toL{9}: e.APTR;
                                                toR{10}: e.APTR;
                                                size{0}: LONGINT;
                                                spec{11}: CommonDataPtr): LONGINT;

PROCEDURE DecodeTWOS8Stereo {"_DecodeTWOS8Stereo"} (from{8}: e.APTR;
                                                    toL{9}: e.APTR;
                                                    toR{10}: e.APTR;
                                                    size{0}: LONGINT;
                                                    spec{11}: CommonDataPtr): LONGINT;

PROCEDURE SetupTWOS8(VAR codec: CodecHeader);
BEGIN
  IF twosData=NIL THEN NEW(twosData); END;
  IF codec.stereo THEN
    codec.decoder:=DecodeTWOS8Stereo;
  ELSE
    codec.decoder:=DecodeTWOS8Mono;
  END;
  codec.realCompression:=FALSE;
  codec.compressFactor:=1;
  codec.special:=twosData;
END SetupTWOS8;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ---------------------- "PROCEDURE DecodeTWOS16()" ----------------------- *)
PROCEDURE DecodeTWOS16Mono {"_DecodeTWOS16Mono"} (from{8}: e.APTR;
                                                  toL{9}: e.APTR;
                                                  toR{10}: e.APTR;
                                                  size{0}: LONGINT;
                                                  spec{11}: CommonDataPtr): LONGINT;

PROCEDURE DecodeTWOS16Stereo {"_DecodeTWOS16Stereo"} (from{8}: e.APTR;
                                                      toL{9}: e.APTR;
                                                      toR{10}: e.APTR;
                                                      size{0}: LONGINT;
                                                      spec{11}: CommonDataPtr): LONGINT;

PROCEDURE SetupTWOS16(VAR codec: CodecHeader);
BEGIN
  IF twosData=NIL THEN NEW(twosData); END;
  IF codec.stereo THEN
    codec.decoder:=DecodeTWOS16Stereo;
  ELSE
    codec.decoder:=DecodeTWOS16Mono;
  END;
  codec.realCompression:=FALSE;
  codec.compressFactor:=1;
  codec.special:=twosData;
END SetupTWOS16;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ----------------------- "PROCEDURE CodecQuery()" ------------------------ *)
PROCEDURE CodecQuery * (VAR codec: CodecHeader): LONGINT;

VAR     ret: LONGINT;

BEGIN
  ret:=codecSupported;
  codec.stereo:=(codec.channels>1);
  CASE codec.compression OF
  | idima4:
      codec.description:="IMA ADPCM";
      IF codec.bits=16 THEN
        SetupIMAADPCM4(codec);
      ELSE
        ret:=codecUnsupported;
      END;
  | idMAC3:
      codec.description:="MACE 3:1";
      IF codec.bits=8 THEN
        SetupMACE3(codec);
      ELSE
        ret:=codecUnsupported;
      END;
  | idMAC6:
      codec.description:="MACE 6:1";
      IF codec.bits=8 THEN
        SetupMACE6(codec);
      ELSE
        ret:=codecUnsupported;
      END;
  | idraw,
    idraw0:
      IF codec.compression=idraw THEN
        codec.description:="PCM";
      ELSE
        codec.description:="PCM0";
      END;
      IF codec.bits=8 THEN
        SetupPCM8(codec);
      ELSIF codec.bits=16 THEN
        SetupTWOS16(codec);
        (* SetupPCM16(codec); *)
      ELSE
        ret:=codecUnsupported;
      END;
  | idtwos:
      codec.description:="TWOS";
      IF codec.bits=8 THEN
        SetupTWOS8(codec);
      ELSIF codec.bits=16 THEN
        SetupTWOS16(codec);
      ELSE
        ret:=codecUnsupported;
      END;
  | idulaw:
      codec.description:="µ-Law";
      ret:=codecUnsupported;
  ELSE
    codec.description:="unknown";
    ret:=codecUnknown;
  END;
  RETURN ret;
END CodecQuery;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ---------------------- "PROCEDURE CheckAudioDMA()" ---------------------- *)
PROCEDURE CheckAudioDMA(codec: CodecHeader): LONGINT;

VAR     freq: LONGINT;

BEGIN
  freq:=codec.frequency;
  IF (freq>27000) & ~v.doubleScanned THEN
(* /// "$IF RUNDEBUG" *)
    IF o.debug THEN d.PrintF("resampling enabled\n"); END;
(* \\\ $END *)
    codec.special.downScale:=TRUE;
    freq:=freq DIV 2;
  ELSE
(* /// "$IF RUNDEBUG" *)
    IF o.debug THEN d.PrintF("no resampling necessary\n"); END;
(* \\\ $END *)
    codec.special.downScale:=FALSE;
  END;
  RETURN freq;
END CheckAudioDMA;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ---------------------- "PROCEDURE InitAudioFile()" ---------------------- *)
PROCEDURE InitAudioFile * (name: ARRAY OF CHAR): BOOLEAN; (* $CopyArrays- *)
BEGIN
  RETURN io.Open(audioFile,name,o.bufferSize,FALSE);
END InitAudioFile;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ----------------------- "PROCEDURE DecodeFrame()" ----------------------- *)
PROCEDURE DecodeFrame * (offset: LONGINT;
                         size: LONGINT;
                         offset2: LONGINT;
                         size2: LONGINT;
                         codec: LONGINT);

VAR     node: SampleNodePtr;
        decSize: LONGINT;

BEGIN
  IF codec#currentCodec THEN
    decoderProc:=codecs[codec].decoder;
    decoderSpec:=codecs[codec].special;
    audioFreq:=CheckAudioDMA(codecs[codec]);
    stereo:=codecs[codec].stereo;
    currentCodec:=codec;
  END;
  IF size2=-1 THEN size2:=size; END;
  size:=mu.min(size,size2)*audioSizeScale;
  IF (size>1) & (size<=audioBufferSize) THEN
    io.SeekTo(audioFile,offset);
    io.Read(audioFile,mainData,size);
    (* y.SETREG(0,d.Write(fh,mainData^,size DIV 3)); *)
    NEW(node);
    decSize:=i2m.Round(size,e.blockSize);
    ol.New(node.dataL,decSize);
    IF stereo OR splittedStereo THEN ol.New(node.dataR,decSize); END;
    decSize:=decoderProc(mainData,node.dataL,node.dataR,size,decoderSpec);
    IF splittedStereo THEN
      io.SeekTo(audioFile,offset2);
      io.Read(audioFile,mainData,size);
      decSize:=decoderProc(mainData,node.dataR,NIL,size,decoderSpec);
    END;
    (* d.PrintF("%ld -> %ld\n",size DIV 3,decSize); *)
    node.freq:=audioFreq;
    node.size:=decSize;
    node.done:=0;
    (* node.id:=u.GetUniqueID(); *)
    e.AddTail(sampleQueue,node);
  ELSE
    d.PrintF("shit\n");
  END;
END DecodeFrame;
(* \\\ ------------------------------------------------------------------------- *)

(* /// -------------------- "PROCEDURE DecodeDummyFrame()" --------------------- *)
PROCEDURE DecodeDummyFrame * (size: LONGINT);

VAR     node: SampleNodePtr;
        decSize: LONGINT;

BEGIN
  REPEAT
    NEW(node);
    decSize:=mu.min(size,audioBufferSize);
    ol.New(node.dataL,decSize);
    IF stereo OR splittedStereo THEN ol.New(node.dataR,decSize); END;
    node.freq:=audioFreq;
    node.size:=decSize;
    node.done:=0;
    (* node.id:=u.GetUniqueID(); *)
    e.AddTail(sampleQueue,node);
    DEC(size,decSize);
  UNTIL size<=0;
END DecodeDummyFrame;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ---------------------- "PROCEDURE AllocBuffers()" ----------------------- *)
PROCEDURE AllocBuffers * (): BOOLEAN;

VAR     track: g.TrackPtr;
        desc: g.SoundDescriptionPtr;
        codec: CodecHeader;
        cnt: LONGINT;
        cur: LONGINT;
        ret: BOOLEAN;

BEGIN
  ret:=TRUE;
  track:=g.animInfo.audioTracks.head;
  DISPOSE(codecs);
  IF es.ListEmpty(g.animInfo.audioTracks) THEN RETURN FALSE; END;

  codecCnt:=cu.CalcDescEntries(g.animInfo.audioTracks);
  ol.New(codecs,codecCnt*SIZE(CodecHeader));
  cur:=0;
  WHILE track.node.succ#NIL DO
    FOR cnt:=0 TO track.descriptionEntries-1 DO
      desc:=y.VAL(g.SoundDescriptionPtr,track.descriptions[cnt]);
      codec.compression:=desc.head.dataFormat;
      codec.bits:=desc.sampleSize;
      codec.channels:=desc.channels;
      codec.frequency:=fp.FP32toINT(desc.sampleRate);

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
                                                            codec.frequency);
          ELSE
            d.PrintF("  Audio: %s %ld bit Mono, %lD Hz\n",y.ADR(codec.description),
                                                          codec.bits,
                                                          codec.frequency);
          END;
        END;
      END;
      codecs[cur]:=codec;
      INC(cur);
    END;
    audioSizeScale:=1;
    IF (codec.bits=16) & ~codec.realCompression THEN audioSizeScale:=audioSizeScale*2; END; (* kein special => keine Kompression, nur Kodierung *)
    IF codec.stereo THEN audioSizeScale:=audioSizeScale*2; END;
    track:=track.node.succ;
  END;

  IF ret & ~o.noSound THEN
    audioBufferSize:=i2m.Round(cu.CalcMaxSize(g.animInfo.audioTracks,FALSE)*audioSizeScale,e.blockSize);
    DISPOSE(mainData);
    audioBufferSize:=mu.max(audioBufferSize,codecs[0].frequency);
    audioBufferSize:=mu.min(audioBufferSize,maxAudioHWSize);
    ol.New(mainData,audioBufferSize);
    INCL(ol.MemReqs,e.chip);
    stereo:=codecs[0].stereo;
    splittedStereo:=(codecCnt=2) & ~stereo;
    (* alte Position von "audioBufferSize:=mu.min(audioBufferSize,maxAudioHWSize);" *)
    FOR cnt:=0 TO 1 DO
      DISPOSE(leftData[cnt]);
      DISPOSE(rightData[cnt]);
      ol.New(leftData[cnt],audioBufferSize);
      IF stereo OR splittedStereo THEN ol.New(rightData[cnt],audioBufferSize); END;
    END;
    EXCL(ol.MemReqs,e.chip);
    currentCodec:=-1;
    audioSigs:=LONGSET{};
    audioFreq:=codecs[0].frequency;
    stereo:=codecs[0].stereo;
  END;
  es.NewList(sampleQueue);

  RETURN ret;
END AllocBuffers;
(* \\\ --------------------------------- *)

BEGIN
  OpenAudio();
  (* fh:=d.Open("sd0:x",d.newFile); *)
CLOSE
  CloseAudio();
  io.Close(audioFile);
  (* d.OldClose(fh); *)
END CyberQTAudio.
