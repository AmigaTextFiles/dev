MODULE  CyberAVI;

(* $IFNOT DEBUG *)
  (* $StackChk- $OvflChk- $RangeChk- $CaseChk- $ReturnChk- $NilChk- $TypeChk- $OddChk- $ClearVars- *)
(* $END *)

(* /// ------------------------------- "IMPORT" -------------------------------- *)
IMPORT  a:=CyberAVIAudio,
        asl:=ASL,
        as:=ASLSupport,
        cu:=CyberAVIUtils,
        d:=Dos,
        ds:=DosSupport,
        e:=Exec,
        g:=CyberAVIGlobals,
        i2m:=Intel2Mot,
        ic:=Icon,
        io:=AsyncIOSupport,
        mu:=MathUtils,
        o:=CyberAVIOpts,
        ol:=OberonLib,
        s:=CyberAVISync,
        u:=Utility,
(* /// "$IF DEBUG" *)
        NoGuru,
        Break,
(* \\\ $END *)
        v:=CyberAVIVideo,
        wb:=Workbench,
        y:=SYSTEM;
(* \\\ ------------------------------------------------------------------------- *)

(* /// -------------------------------- "TYPE" --------------------------------- *)
TYPE    IndexEntryPtr=UNTRACED POINTER TO IndexEntry;
        IndexEntry=STRUCT
            id: LONGINT;
            flags: LONGSET;
            offset: LONGINT;
            size: LONGINT;
            isKey: BOOLEAN;
            frameType: LONGINT;
            streamNum: LONGINT;
        END;
        IndexPtr=UNTRACED POINTER TO ARRAY OF IndexEntry;

        Chunk=STRUCT
            id: LONGINT;
            size: LONGINT;
        END;
(* \\\ ------------------------------------------------------------------------- *)

(* /// -------------------------------- "CONST" -------------------------------- *)
CONST
(* $IF RUNDEBUG *)
        template="FILES/M,"

                 "PUBSCREEN/K,"
                 "SCREENMODEREQ=SMR/S,"
                 "SCREENMODEID=SMID/K,"

                 "FORCE24/S,"
                 "GRAY=GREY/S,"
                 "AGA/S,"
                 "HAM8/S,"
                 "DITHER/S,"
                 "CMAP/K,"

                 "BUFFERSIZE=BUF/K/N,"
                 "DELAY/K/N,"

                 "LOOP/S,"
                 "MAXFPS/S,"
                 "NOINDEX/S,"
                 "NOSOUND/S,"
                 "NOVIDEO/S,"
                 "SKIP/S,"
                 "MAGNIFY/K/N,"

                 "STATS/S,"
                 "QUIET/S"

                 ",DEBUG/S";
(* $ELSE *)
        template="FILES/M,"

                 "PUBSCREEN/K,"
                 "SCREENMODEREQ=SMR/S,"
                 "SCREENMODEID=SMID/K,"

                 "FORCE24/S,"
                 "GRAY=GREY/S,"
                 "AGA/S,"
                 "HAM8/S,"
                 "DITHER/S,"
                 "CMAP/K,"

                 "BUFFERSIZE=BUF/K/N,"
                 "DELAY/K/N,"

                 "LOOP/S,"
                 "MAXFPS/S,"
                 "NOINDEX/S,"
                 "NOSOUND/S,"
                 "NOVIDEO/S,"
                 "SKIP/S,"
                 "MAGNIFY/K/N,"

                 "STATS/S,"
                 "QUIET/S"

                 "";
(* $END *)

(* $IF BETA *)
        version="$VER: CyberAVI 1.12 beta 1, time limit is 31-Jan-98 (27.9.97)"
                "\oCyberAVI is ©1996-1997 Thore Böckelmann";
        expireDate=7336; (* = 31.1.98 *)
(* $ELSE *)
        version="$VER: CyberAVI 1.12 (20.1.98)"
                "\oCyberAVI is ©1996-1997 Thore Böckelmann";
(* $END *)

        idRIFF=y.VAL(LONGINT,"RIFF");
        idLIST=y.VAL(LONGINT,"LIST");
        idavih=y.VAL(LONGINT,"avih");
        idstrd=y.VAL(LONGINT,"strd");
        idstrh=y.VAL(LONGINT,"strh");
        idstrf=y.VAL(LONGINT,"strf");
        ididx1=y.VAL(LONGINT,"idx1");

        idAVI =y.VAL(LONGINT,"AVI ");

        idhdrl=y.VAL(LONGINT,"hdrl");
        idstrl=y.VAL(LONGINT,"strl");

        idvids=y.VAL(LONGINT,"vids");
        idauds=y.VAL(LONGINT,"auds");
        idpads=y.VAL(LONGINT,"pads");


        idmovi=y.VAL(LONGINT,"movi");
        idrec =y.VAL(LONGINT,"rec ");


        id0021=y.VAL(LONGINT,"0021");
        id0031=y.VAL(LONGINT,"0031");
        id0032=y.VAL(LONGINT,"0032");
        id00dx=y.VAL(LONGINT,"00dx");
        id00id=y.VAL(LONGINT,"00id");
        id00iv=y.VAL(LONGINT,"00iv");
        id00rt=y.VAL(LONGINT,"00rt");
        id00vc=y.VAL(LONGINT,"00vc");
        id00xm=y.VAL(LONGINT,"00xm");
        id00xx=y.VAL(LONGINT,"00xx");

        id00db=y.VAL(LONGINT,"00db");
        id01db=y.VAL(LONGINT,"01db");
        idxxdb=y.VAL(LONGINT,"\o\odb");
        id00dc=y.VAL(LONGINT,"00dc");
        id01dc=y.VAL(LONGINT,"01dc");
        idxxdc=y.VAL(LONGINT,"\o\odc");

        id00pc=y.VAL(LONGINT,"00pc");
        id01pc=y.VAL(LONGINT,"01pc");
        idxxpc=y.VAL(LONGINT,"\o\opc");

        id00wb=y.VAL(LONGINT,"00wb");
        id01wb=y.VAL(LONGINT,"01wb");
        idxxwb=y.VAL(LONGINT,"\o\owb");


        ahHasIndex=4;
        ahMustUseIndex=5;
        ahIsInterleaved=8;
        ahWasCaptureFile=16;
        ahCopyrighted=17;


        ashDisabled=0;
        ashVideoPalChanges=16;


        aieList=0;
        aieTwoCC=1;
        aieKeyframe=4;
        aieFirstPart=5;
        aieLastPart=6;
        aieMidPart=LONGSET{aieFirstPart,aieLastPart};
        aieNoTime=8;
        aieCompUse=y.VAL(LONGSET,0FFF0000H);

        listHeadSize=SIZE(Chunk)+SIZE(LONGINT);
(* \\\ ------------------------------------------------------------------------- *)

(* /// --------------------------------- "VAR" --------------------------------- *)
VAR     fileReq: asl.FileRequesterPtr;
        index: IndexPtr;
        indexEntries: LONGINT;
        useIndex: BOOLEAN;
        doVideo: BOOLEAN;
        doAudio: BOOLEAN;
        videoStream: LONGINT;
        audioStream: LONGINT;
        lastSTRH: LONGINT;
        onlyKeyframes: BOOLEAN;
        preLoaded: BOOLEAN;
        pause: BOOLEAN;
(* /// "$IF BETA" *)
        now: d.Date;
        expire: d.Date;
(* \\\ $END *)
(* \\\ ------------------------------------------------------------------------- *)

(* /// ------------------------ "PROCEDURE ReadAVIH()" ------------------------- *)
PROCEDURE ReadAVIH(size: LONGINT): BOOLEAN;

VAR     head: g.AVIHeader;
        forceIndex: BOOLEAN;

BEGIN
  IF size#038H THEN RETURN FALSE; END;
  head.microsPerFrame:=io.GetLSBLong();
  head.maxBytesPerSec:=io.GetLSBLong();
  head.reserved:=io.GetMSBLong();
  head.flags:=io.GetLSBLSet();
  head.totalFrames:=io.GetLSBLong();
  head.initialFrames:=io.GetLSBLong();
  head.streams:=io.GetLSBLong();
  head.suggestedBufferSize:=io.GetLSBLong();
  head.width:=io.GetLSBLong();
  head.height:=io.GetLSBLong();
  head.scale:=io.GetLSBLong();
  head.rate:=io.GetLSBLong();
  head.start:=io.GetLSBLong();
  head.length:=io.GetLSBLong();
(* /// "$IF RUNDEBUG" *)
  IF o.debug THEN
    d.PrintF("  µs: %ld\n"
             "  bytes/sec: %ld\n"
             "  flags: $%08lx =",head.microsPerFrame,head.maxBytesPerSec,head.flags);
    IF ahHasIndex IN head.flags THEN d.PrintF(" hasindex"); END;
    IF ahMustUseIndex IN head.flags THEN d.PrintF(" useindex"); END;
    IF ahIsInterleaved IN head.flags THEN d.PrintF(" interleaved"); END;
    IF ahWasCaptureFile IN head.flags THEN d.PrintF(" capture"); END;
    IF ahCopyrighted IN head.flags THEN d.PrintF(" copyright"); END;
    d.PrintF("\n"
             "  total frames: %ld\n"
             "  initial frames: %ld\n"
             "  streams: %ld\n"
             "  buffer size: %ld\n"
             "  width: %ld\n"
             "  height: %ld\n"
             "  scale: %ld\n"
             "  rate: %ld\n"
             "  start: %ld\n"
             "  length: %ld\n\n",head.totalFrames,head.initialFrames,head.streams,head.suggestedBufferSize,head.width,head.height,head.scale,head.rate,head.start,head.length);
  END;
(* \\\ $END *)
  g.animInfo.avih:=head;

  useIndex:=(ahHasIndex IN head.flags) & ~o.noIndex;
  forceIndex:=(ahMustUseIndex IN head.flags);
  IF forceIndex & ~useIndex THEN d.PrintF("AVI file must use index but there is none. Playback may be corrupted!\n"); END;
  IF o.doSkip & ~(ahHasIndex IN head.flags) & ~o.noIndex THEN d.PrintF("AVI file has no index, skipping of delayed frames is not possible!\n"); END;

  RETURN TRUE;
END ReadAVIH;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ------------------------ "PROCEDURE ReadSTRH()" ------------------------- *)
PROCEDURE ReadSTRH(size: LONGINT): BOOLEAN;

VAR     head: g.AVIStreamHeader;

BEGIN
  IF size<024H THEN RETURN FALSE; END;
  head.fccType:=io.GetMSBLong();
  head.fccHandler:=io.GetMSBLong();
  head.flags:=io.GetLSBLSet();
  head.priority:=io.GetLSBLong();
  head.initialFrames:=io.GetLSBLong();
  head.scale:=io.GetLSBLong();
  head.rate:=io.GetLSBLong();
  head.start:=io.GetLSBLong();
  head.length:=io.GetLSBLong();
  head.suggestedBufferSize:=io.GetLSBLong();
  head.quality:=io.GetLSBLong();
  head.sampleSize:=io.GetLSBLong();
  DEC(size,48);
(* /// "$IF RUNDEBUG" *)
  IF o.debug THEN
    d.PrintF("  type: "); cu.PrintFCC(head.fccType); d.PrintF("\n");
    d.PrintF("  handler: "); cu.PrintFCC(head.fccHandler); d.PrintF("\n");
    d.PrintF("  flags: $%08lx =",head.flags);
    IF ashDisabled IN head.flags THEN d.PrintF(" disabled"); END;
    IF ashVideoPalChanges IN head.flags THEN d.PrintF(" palette-change"); END;
    d.PrintF("\n"
             "  priority: %ld\n"
             "  initial frames: %ld\n"
             "  scale: %ld\n"
             "  rate: %ld\n"
             "  start: %ld\n"
             "  length: %ld\n"
             "  buffer size: %ld\n"
             "  quality: %ld\n"
             "  sample size: %ld\n\n",head.priority,head.initialFrames,head.scale,head.rate,head.start,head.length,head.suggestedBufferSize,head.quality,head.sampleSize);
  END;
(* \\\ $END *)
  IF size>0 THEN io.Skip(size); END;
  IF size<0 THEN RETURN FALSE; END; (* irgendwas ist faul *)

  lastSTRH:=head.fccType;
  CASE head.fccType OF
  | idvids: g.animInfo.vids.strh:=head;
  | idauds: g.animInfo.auds.strh:=head;
  ELSE
  END;
  RETURN TRUE;
END ReadSTRH;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ------------------------ "PROCEDURE ReadVIDS()" ------------------------- *)
PROCEDURE ReadVIDS(size: LONGINT): BOOLEAN;

VAR     head: g.VIDS;
        colorCnt: LONGINT;

BEGIN
  head.size:=io.GetLSBLong();
  head.width:=io.GetLSBLong();
  head.height:=io.GetLSBLong();
  head.planes:=io.GetLSBShort();
  head.bitCnt:=io.GetLSBShort();
  head.compression:=io.GetMSBLong();
  head.imageSize:=io.GetLSBLong();
  head.xPelsPerMeter:=io.GetLSBLong();
  head.yPelsPerMeter:=io.GetLSBLong();
  head.clrUsed:=io.GetLSBLong();
  head.clrImportant:=io.GetLSBLong();
  DEC(size,SIZE(head));
(* /// "$IF RUNDEBUG" *)
  IF o.debug THEN
    d.PrintF("  size: %ld\n"
             "  width: %ld\n"
             "  height: %ld\n"
             "  planes: %ld\n"
             "  bit count: %ld\n  compression: ",head.size,head.width,head.height,head.planes,head.bitCnt);
    cu.PrintFCC(head.compression); d.PrintF("\n");
    d.PrintF("  image size: %ld\n"
             "  xpels: %ld\n"
             "  ypels: %ld\n"
             "  color used: %ld\n"
             "  color important: %ld\n",head.imageSize,head.xPelsPerMeter,head.yPelsPerMeter,head.clrUsed,head.clrImportant);
  END;
(* \\\ $END *)
  IF (head.clrUsed=0) & (head.bitCnt<16) THEN head.clrUsed:=y.VAL(LONGINT,LONGSET{head.bitCnt}); END;
  g.animInfo.vids.strf:=head;

  colorCnt:=head.clrUsed;

  IF head.bitCnt>8 THEN
    v.ReadColorMap(0,FALSE); (* bei TrueColor nur gray-Flag setzen *)
  ELSE
(* /// "$IF RUNDEBUG" *)
    IF o.debug THEN d.PrintF("  reading color table, size: %ld = %ld entries\n",size,size DIV 4); END;
(* \\\ $END *)
    v.ReadColorMap(colorCnt,ashVideoPalChanges IN g.animInfo.vids.strh.flags);
    DEC(size,colorCnt*4); (* 4 Byte pro Farbe *)
  END;
  IF size>0 THEN io.Skip(size); END;
  IF size<0 THEN RETURN FALSE; END; (* irgendwas ist faul *)
(* /// "$IF RUNDEBUG" *)
  IF o.debug THEN d.PrintF("\n"); END;
(* \\\ $END *)

  IF v.AllocBuffers() THEN
    doVideo:=~o.noVideo;
  ELSE
    doVideo:=FALSE;
  END;

  RETURN TRUE;
END ReadVIDS;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ------------------------ "PROCEDURE ReadAUDS()" ------------------------- *)
PROCEDURE ReadAUDS(size: LONGINT): BOOLEAN;

VAR     head: g.AUDS;

BEGIN
  head.format:=io.GetLSBShort();
  head.channels:=io.GetLSBShort();
  head.samplesPerSec:=io.GetLSBLong();
  head.avgBytesPerSec:=io.GetLSBLong();
  head.blockAlign:=io.GetLSBShort();
  head.bitsPerSample:=io.GetLSBShort();
  head.extSize:=0;
  IF size<16 THEN
    head.bitsPerSample:=8;
    DEC(size,14);
  ELSE
    IF size>16 THEN
      head.extSize:=io.GetLSBShort();
      DEC(size,18);
      IF size=0 THEN head.extSize:=0; END; (* Workaround für AVIs mit falschen ExtSize-Werten, 18 statt 0 *)
    ELSE
      DEC(size,16);
    END;
  END;
(* /// "$IF RUNDEBUG" *)
  IF o.debug THEN
    d.PrintF("  codec: %ld\n"
             "  channels: %ld\n"
             "  samples/sec: %ld\n"
             "  average bytes/sec: %ld\n"
             "  align: %ld\n"
             "  bits per sample: %ld\n"
             "  extended size: %ld\n\n",head.format,head.channels,head.samplesPerSec,head.avgBytesPerSec,head.blockAlign,head.bitsPerSample,head.extSize);
  END;
(* \\\ $END *)
  g.animInfo.auds.strf:=head;

  a.ReadExtension(head.extSize);
  DEC(size,head.extSize);
  IF size>0 THEN io.Skip(size); END;
  IF size<0 THEN RETURN FALSE; END; (* irgendwas ist faul *)

  IF a.AllocBuffers() THEN
    doAudio:=~o.noSound & a.audioOpen;
  ELSE
    doAudio:=FALSE;
  END;

  RETURN TRUE;
END ReadAUDS;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ------------------------ "PROCEDURE ReadHDRL()" ------------------------- *)
PROCEDURE ReadHDRL(size: LONGINT): LONGINT;

VAR     ckID: LONGINT;
        ckSize: LONGINT;
        listID: LONGINT;
        errVal: LONGINT;
        streamCnt: INTEGER;

BEGIN
  IF ODD(size) THEN INC(size); END;
  streamCnt:=0;
  videoStream:=-1;
  audioStream:=-1;
  errVal:=g.noError;
  LOOP
    ckID:=io.GetMSBLong();
    ckSize:=io.GetLSBLong();
(* /// "$IF RUNDEBUG" *)
    IF o.debug THEN
      cu.PrintChunkHead(ckID,ckSize);
      IF ckID=idLIST THEN
        d.PrintF(" subID: ");
      ELSE
        d.PrintF("\n");
      END;
    END;
(* \\\ $END *)
    CASE ckID OF
    | idLIST:
        listID:=io.GetMSBLong();
(* /// "$IF RUNDEBUG" *)
        IF o.debug THEN cu.PrintFCC(listID); d.PrintF("\n"); END;
(* \\\ $END *)
        INC(size,ckSize-4);
    | idavih: IF ~ReadAVIH(ckSize) THEN errVal:=g.unknownError; END;
    | idstrh: IF ~ReadSTRH(ckSize) THEN errVal:=g.unknownError; END;
    | idstrf:
        IF streamCnt>=g.animInfo.avih.streams THEN
          d.PrintF("Too many streams!\n");
          errVal:=g.unknownError;
        ELSE
          CASE lastSTRH OF
          | idvids:
            IF videoStream=-1 THEN
              IF ~ReadVIDS(ckSize) THEN errVal:=g.unknownError; END;
              videoStream:=streamCnt;
            ELSE
              d.PrintF("Too many video streams!\n");
              errVal:=g.unknownError;
            END;
          | idauds:
            IF audioStream=-1 THEN
              IF ~ReadAUDS(ckSize) THEN errVal:=g.unknownError; END;
              audioStream:=streamCnt;
            ELSE
              d.PrintF("Too many audio streams!\n");
              errVal:=g.unknownError;
            END;
          ELSE
            io.Skip(ckSize);
          END;
          INC(streamCnt);
        END;
    ELSE
      io.Skip(ckSize);
    END;

    DEC(size,ckSize+8);
    IF size<=0 THEN EXIT; END;

    IF ~io.readOk THEN errVal:=g.readError; END;

    IF errVal#g.noError THEN EXIT; END;
  END;

  RETURN errVal;
END ReadHDRL;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ---------------------- "PROCEDURE HandleEvents()" ----------------------- *)
PROCEDURE HandleEvents(): LONGINT;

VAR     sigs: LONGSET;
        received: LONGSET;
        ret: LONGINT;

BEGIN
  ret:=g.noError;
  sigs:=LONGSET{s.timerSig,v.idcmpSig,d.ctrlC,d.ctrlD};
  LOOP
    received:=e.Wait(sigs+a.audioSigs);
    IF doAudio THEN a.PlaySample(FALSE); END;
    IF v.idcmpSig IN received THEN ret:=v.HandleIDCMP(); END;
    IF s.timerSig IN received THEN EXIT END;
    IF d.ctrlC IN received THEN ret:=d.break; END;
    IF d.ctrlD IN received THEN ret:=g.skipAnim; END;
    IF ret=g.pauseAnim THEN
      ret:=g.noError;
      pause:=~pause;
      a.PauseSound(pause);
      s.PauseTimer(pause);
      IF pause THEN
        EXCL(sigs,s.timerSig);
      ELSE
        INCL(sigs,s.timerSig);
      END;
    END;
    IF ret#g.noError THEN EXIT; END;
  END;
  RETURN ret;
END HandleEvents;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ---------------------- "PROCEDURE ParseMOVIFile()" ---------------------- *)
PROCEDURE ParseMOVIFile(size: LONGINT;
                        fileName: e.STRPTR): LONGINT;

VAR     ckID: LONGINT;
        ckSize: LONGINT;
        errVal: LONGINT;
        stream: LONGINT;
        type: LONGINT;
        framesDone: LONGINT;
        firstVFrame: BOOLEAN;
        sigs: LONGSET;

        loopBegin: LONGINT;
        loopSize: LONGINT;
        listID: LONGINT;

BEGIN
  IF a.mustPreload THEN
    d.PrintF("This animation seems to have only one audio chunk.\n"
             "CyberAVI is unable to play this audio stream without index.\n");
    doAudio:=FALSE;
  END;
  IF o.doLoop THEN
    loopBegin:=io.FilePos();
    IF loopBegin=-1 THEN RETURN 1; END;
    loopSize:=size;
  END;
  errVal:=v.OpenDisplay(~doVideo,fileName);
  IF errVal#g.noError THEN
    v.CloseDisplay();
    RETURN errVal;
  END;
  firstVFrame:=~doVideo;
  framesDone:=0;
  IF o.maxFPS THEN
    s.SetFrameDelay(0);
  ELSE
    s.SetFrameDelay(-1);
  END;
  IF doVideo THEN s.Wait(o.startDelay); END;
  LOOP
    ckID:=io.GetMSBLong();
    ckSize:=io.GetLSBLong();
(* /// "$IF RUNDEBUG" *)
    IF o.debug THEN d.PrintF("movi id: "); cu.PrintFCC(ckID); d.PrintF(", size: %ld\n",ckSize); END;
(* \\\ $END *)
    IF ckID=idLIST THEN
      listID:=io.GetMSBLong();
(* /// "$IF RUNDEBUG" *)
      IF o.debug THEN d.PrintF("movi list sub id: "); cu.PrintFCC(listID); d.PrintF("\n"); END;
(* \\\ $END *)
      INC(size,ckSize-4);
    ELSE
(* $RangeChk- *)
      stream:=y.LSH(ckID,-16)-03030H; (* nur die beiden vorderen Zeichen in Zahl umwandeln *)
      type:=y.VAL(LONGINT,y.VAL(LONGSET,ckID)*LONGSET{0..15});
(* $RangeChk= *)
      IF (stream=videoStream) & doVideo THEN
        IF type=idxxpc THEN
          v.ChangeColorMap(ckSize);
        ELSE (* Video, aber keine Palette => Bild *)
          firstVFrame:=(framesDone=1) OR (g.animInfo.vids.strh.length=1); (* entweder wird 2. Bild bearbeitet, oder es gibt nur ein einziges *)
          IF framesDone=0 THEN s.StartTimer(); END;
          errVal:=HandleEvents();
          v.DecodeFrame(ckSize,(type=idxxdb));
          INC(framesDone);
          s.DoFrameDelay(FALSE);
        END;
      ELSIF (stream=audioStream) & doAudio THEN
        a.DecodeFrame(ckSize);
      ELSE
        io.Skip(ckSize);
      END;
    END;

    IF firstVFrame & doAudio THEN a.StartSound(); END;

    IF ODD(ckSize) THEN INC(ckSize); END;
    DEC(size,ckSize+SIZE(Chunk));

    IF (size<=0) OR ((framesDone>0) & (framesDone MOD g.animInfo.avih.totalFrames=0)) THEN (* für AVIs mit falschen movi-Größen *)
      a.Wait4LastSample(errVal#g.noError);
      IF o.doLoop THEN
(* /// "$IF RUNDEBUG" *)
        IF o.debug THEN d.PrintF("looping...\n"); END;
(* \\\ $END *)
        io.SeekTo(loopBegin);
        size:=loopSize;
        v.Restore1stColorMap();
      ELSE
        EXIT; (* Animation am Ende *)
      END;
    END;

    sigs:=e.SetSignal(LONGSET{},LONGSET{d.ctrlC,d.ctrlD});
    IF d.ctrlC IN sigs THEN errVal:=d.break; END;
    IF d.ctrlD IN sigs THEN errVal:=g.skipAnim; END;
    IF ~io.readOk THEN errVal:=g.readError; END;
    IF errVal#g.noError THEN EXIT; END;
  END;
  s.Wait4LastFrame();
  IF doVideo & o.doStats THEN s.DoStats(framesDone,0); END;
  a.StopSound(errVal#g.noError);
  v.CloseDisplay();
  RETURN errVal;
END ParseMOVIFile;
(* \\\ ------------------------------------------------------------------------- *)

(* /// --------------------- "PROCEDURE ParseMOVIIndex()" ---------------------- *)
PROCEDURE ParseMOVIIndex(fileName: e.STRPTR): LONGINT;

VAR     errVal: LONGINT;
        framesDone: LONGINT;
        firstVFrame: BOOLEAN;
        sigs: LONGSET;

        idxCnt: LONGINT;
        entry: IndexEntry;
        skipped: LONGINT;
        skipping: BOOLEAN;
        vFrame: LONGINT;

BEGIN
  IF a.mustPreload THEN (* nur Preload, wenn der letzte Frame ein Audioframe ist *)
    IF index[indexEntries-1].frameType=idxxwb THEN
      a.Preload(index[indexEntries-1].offset,index[indexEntries-1].size);
    ELSE
      a.mustPreload:=FALSE;
    END;
  END;
  errVal:=v.OpenDisplay(~doVideo,fileName);
  IF errVal#g.noError THEN
    v.CloseDisplay();
    RETURN errVal;
  END;
  firstVFrame:=~doVideo;
  framesDone:=0;
  vFrame:=0;
  idxCnt:=0;
  skipped:=0;
  skipping:=FALSE;
  IF o.maxFPS THEN
    s.SetFrameDelay(0);
  ELSE
    s.SetFrameDelay(-1);
  END;
  IF doVideo THEN s.Wait(o.startDelay); END;
  LOOP
    entry:=index[idxCnt];
(* /// "$IF RUNDEBUG" *)
    IF o.debug THEN
      d.PrintF("\nindex entry %4ld: id: ",idxCnt); cu.PrintFCC(entry.id); d.PrintF("\n");
      d.PrintF("                  size: %ld\n",entry.size);
      d.PrintF("                  flags: $%08lx = ",entry.flags);
      IF aieList IN entry.flags THEN d.PrintF("list "); END;
      IF aieTwoCC IN entry.flags THEN d.PrintF("twocc "); END;
      IF aieKeyframe IN entry.flags THEN d.PrintF("keyframe "); END;
      IF aieFirstPart IN entry.flags THEN d.PrintF("firstpart "); END;
      IF aieLastPart IN entry.flags THEN d.PrintF("lastpart "); END;
      IF aieNoTime IN entry.flags THEN d.PrintF("notime "); END;
      d.PrintF("\n");
    END;
(* \\\ $END *)
    IF entry.id#idrec THEN
      IF (entry.streamNum=videoStream) & doVideo THEN
        io.SeekTo(entry.offset);
        IF entry.frameType=idxxpc THEN
          v.ChangeColorMap(entry.size);
        ELSE (* Video, aber keine Palette => Bild *)
          firstVFrame:=(framesDone=1) OR (g.animInfo.vids.strh.length=1); (* entweder wird 2. Bild bearbeitet, oder es gibt nur ein einziges *)
          IF framesDone=0 THEN s.StartTimer(); END;
          errVal:=HandleEvents();
          IF skipping & entry.isKey & ~onlyKeyframes THEN skipping:=FALSE; END;
          IF skipping THEN
            INC(skipped);
          ELSE
            v.DecodeFrame(entry.size,(entry.frameType=idxxdb));
          END;
          s.DoFrameDelay(skipping);
          skipping:=o.doSkip &
                    ~s.IsSync() &
                    (~entry.isKey OR onlyKeyframes) OR
                    (skipping & ~onlyKeyframes);
          INC(framesDone);
          INC(vFrame);
        END;
      ELSIF (entry.streamNum=audioStream) & doAudio & ~a.mustPreload THEN
        io.SeekTo(entry.offset);
        a.DecodeFrame(entry.size);
      ELSE
        (* irgendwas anderes als Audio oder Video *)
      END;
    END;

    IF doAudio THEN
      a.PlaySample(~doVideo);
      IF firstVFrame THEN a.StartSound(); END;
    END;

    INC(idxCnt);
    IF idxCnt=indexEntries THEN
      a.Wait4LastSample(errVal#g.noError);
      IF o.doLoop THEN
(* /// "$IF RUNDEBUG" *)
        IF o.debug THEN d.PrintF("looping...\n"); END;
(* \\\ $END *)
        idxCnt:=0;
        vFrame:=0;
        v.Restore1stColorMap();
      ELSE
        EXIT;
      END;
    END;

    sigs:=e.SetSignal(LONGSET{},LONGSET{d.ctrlC,d.ctrlD});
    IF d.ctrlC IN sigs THEN errVal:=d.break; END;
    IF d.ctrlD IN sigs THEN errVal:=g.skipAnim; END;
    IF ~io.readOk THEN errVal:=g.readError; END;
    IF errVal#g.noError THEN EXIT; END;
  END;
  s.Wait4LastFrame();
  IF doVideo & o.doStats THEN s.DoStats(framesDone,skipped); END;
  a.StopSound(errVal#g.noError);
  v.CloseDisplay();
  RETURN errVal;
END ParseMOVIIndex;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ------------------------ "PROCEDURE ReadIDX1()" ------------------------- *)
PROCEDURE ReadIDX1(size: LONGINT;
                   relStart: LONGINT): BOOLEAN;

TYPE    AVIIndexEntry=STRUCT
            id: LONGINT;
            flags: LONGSET;
            offset: LONGINT;
            size: LONGINT;
        END;

VAR     cnt: LONGINT;
        audioFrames: LONGINT;
        minOffset: LONGINT;
        keyCount: LONGINT;
        entry: AVIIndexEntry;
        flags: LONGSET;

BEGIN
  DISPOSE(index);
  indexEntries:=(size+15) DIV 16;
(* /// "$IF RUNDEBUG" *)
  IF o.debug THEN d.PrintF("\nreading index, %ld entries\n",indexEntries); END;
(* \\\ $END *)
  NEW(index,indexEntries*SIZE(IndexEntry));
  minOffset:=MAX(LONGINT);
  keyCount:=0;
  FOR cnt:=0 TO indexEntries-1 DO
    io.Read(y.ADR(entry),SIZE(AVIIndexEntry));
    index[cnt].id:=entry.id;
    flags:=i2m.LSB2MSBLSet(entry.flags);
    index[cnt].flags:=flags;
    index[cnt].offset:=i2m.LSB2MSBLong(entry.offset);
    index[cnt].size:=i2m.LSB2MSBLong(entry.size);
    index[cnt].isKey:=(aieKeyframe IN flags);
    IF aieKeyframe IN flags THEN INC(keyCount); END;
    index[cnt].frameType:=y.VAL(LONGINT,y.VAL(LONGSET,entry.id)*LONGSET{0..15});
    index[cnt].streamNum:=y.LSH(entry.id,-16)-03030H;
    minOffset:=mu.min(index[cnt].offset,minOffset);
    IF ~io.readOk THEN RETURN FALSE; END;
  END;
  IF minOffset=relStart THEN (* relativ zum Dateianfang? *)
(* /// "$IF RUNDEBUG" *)
    IF o.debug THEN d.PrintF("index seems to be corrupted, setting new relative start from %ld to %ld\n",relStart,SIZE(Chunk)); END;
(* \\\ $END *)
    relStart:=SIZE(Chunk); (* RIFFxxxx wird beim Offset zum Dateianfang nicht mitgezählt *)
  ELSE
    INC(relStart,SIZE(LONGINT));
  END;
  FOR cnt:=0 TO indexEntries-1 DO INC(index[cnt].offset,relStart); END;
  keyCount:=mu.max(1,keyCount);
  onlyKeyframes:=(keyCount>=g.animInfo.avih.totalFrames);
  IF (g.animInfo.avih.totalFrames DIV keyCount>s.GetFPS()) & o.doSkip THEN
    d.PrintF("Not enough key frames, possible skips may produce wrong frames.\n");
  END;
  RETURN TRUE;
END ReadIDX1;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ------------------------ "PROCEDURE ParseRIFF()" ------------------------ *)
PROCEDURE ParseRIFF(ap: d.AnchorPathPtr;
                    multi: BOOLEAN): LONGINT;

VAR     errVal: LONGINT;
        ckID: LONGINT;
        subID: LONGINT;
        ckSize: LONGINT;
        moviStart: LONGINT;
        moviSize: LONGINT;
        riffSize: LONGINT;
        riffSizeAtMOVI: LONGINT;
        indexRead: BOOLEAN;
        fileNamePtr: e.STRPTR;

BEGIN
  NEW(fileNamePtr);
  COPY(ap.info.fileName,fileNamePtr^);
  IF multi & ~o.quiet THEN
    d.PrintF("%s: ",y.ADR(ap.info.fileName));
    y.SETREG(0,d.Flush(d.Output()));
  END;

  IF ~io.Open(ap.info.fileName,o.bufferSize) THEN RETURN d.IoErr(); END;
  ckID:=io.GetMSBLong(); (* sollte "RIFF" sein *)
  riffSize:=io.GetLSBLong();
  subID:=io.GetMSBLong(); (* sollte "AVI " sein *)
  IF (ckID#idRIFF) OR (subID#idAVI) THEN RETURN d.objectWrongType; END;
  IF riffSize+8>ap.info.size THEN d.PrintF("Filesize is %lD, but should be %lD. Playback may be corrupted or even impossible!\n",ap.info.size,riffSize+8); END;
  DEC(riffSize,4);

  errVal:=g.noError;
  useIndex:=FALSE;
  indexRead:=FALSE;
  doVideo:=FALSE;
  doAudio:=FALSE;
  onlyKeyframes:=FALSE;
  preLoaded:=FALSE;
  IF ~o.quiet & multi THEN d.PrintF("\n"); END;

  REPEAT
    ckID:=io.GetMSBLong();
    ckSize:=io.GetLSBLong();
(* /// "$IF RUNDEBUG" *)
    IF o.debug THEN
      d.PrintF("riff id: "); cu.PrintFCC(ckID); d.PrintF(", size: %ld",ckSize);
      IF ckID#idLIST THEN d.PrintF("\n"); END;
    END;
(* \\\ $END *)
    CASE ckID OF
    | idLIST:
        subID:=io.GetMSBLong();
        DEC(ckSize,4);
        DEC(riffSize,4);
(* /// "$IF RUNDEBUG" *)
        IF o.debug THEN d.PrintF(" subid: "); cu.PrintFCC(subID); d.PrintF("\n"); END;
(* \\\ $END *)
        CASE subID OF
        | idhdrl: errVal:=ReadHDRL(ckSize);
        | idmovi:
            IF useIndex & ~indexRead THEN (* Index benutzten, ist aber noch nicht gelesen *)
(* /// "$IF RUNDEBUG" *)
              IF o.debug THEN d.PrintF("skipping MOVI to index\n"); END;
(* \\\ $END *)
              moviStart:=io.FilePos()-listHeadSize; (* LISTxxxmovi nochmal lesen *)
              moviSize:=ckSize;
              io.Skip(ckSize);
              IF ~io.readOk THEN
                d.PrintF("Index seems to be lost, continuing without index. If the file was truncated playback may cause crashes!\n");
                useIndex:=FALSE;
                indexRead:=TRUE;
                io.UndoError();
                io.SeekTo(moviStart);
              END;
              riffSizeAtMOVI:=riffSize+4; (* LISTxxxmovi nochmal lesen *)
            ELSE
              IF doVideo OR doAudio THEN (* gibts überhaupt was zum Spielen? *)
                IF useIndex THEN (* Index gelesen und benutzen *)
(* /// "$IF RUNDEBUG" *)
                  IF o.debug THEN d.PrintF("using index\n"); END;
(* \\\ $END *)
                  errVal:=ParseMOVIIndex(fileNamePtr);
                  io.SeekTo(moviStart+moviSize+listHeadSize); (* hinter MOVI Chunk gehen *)
                ELSE (* kein Index gefunden oder nicht benutzen *)
(* /// "$IF RUNDEBUG" *)
                  IF o.debug THEN d.PrintF("reading file\n"); END;
(* \\\ $END *)
                  errVal:=ParseMOVIFile(ckSize,fileNamePtr);
                END;
              ELSE
                d.PrintF("Neither Video nor Audio to play!\n");
                riffSize:=0;
              END;
            END;
        ELSE (* CASE subID *)
(* /// "$IF RUNDEBUG" *)
          IF o.debug THEN d.PrintF("unknown LIST chunk\n"); END;
(* \\\ $END *)
          io.Skip(ckSize);
        END;
    | ididx1:
        IF ~indexRead & useIndex THEN
          IF ~ReadIDX1(ckSize,moviStart+listHeadSize) THEN
            d.PrintF("Can't read index, continuing without index\n");
            useIndex:=FALSE;
          ELSE
            indexRead:=TRUE;
          END;
          io.SeekTo(moviStart);
          riffSize:=riffSizeAtMOVI+ckSize+SIZE(Chunk); (* Indexlänge aufaddieren, damit Index beim 2. Mal nicht unterschlagen wird *)
        ELSE
(* /// "$IF RUNDEBUG" *)
          IF o.debug THEN d.PrintF("skipping index\n"); END;
(* \\\ $END *)
          io.Skip(ckSize);
        END;
    ELSE
      io.Skip(ckSize);
    END;

    IF ODD(ckSize) THEN INC(ckSize); END;
    DEC(riffSize,ckSize+SIZE(Chunk));

    IF d.ctrlC IN e.SetSignal(LONGSET{},LONGSET{d.ctrlC}) THEN errVal:=d.break; END;
    IF ~io.readOk THEN errVal:=g.readError; END;
  UNTIL (riffSize<=0) OR (errVal#g.noError);
  IF errVal#g.noError THEN
    IF errVal=g.skipAnim THEN
      errVal:=g.noError;
    ELSE
      CASE errVal OF
      | g.unknownError,
        g.readError: errVal:=d.seekError;
      | d.break:
      ELSE
        errVal:=d.IoErr();
      END;
    END;
(* /// "$IF RUNDEBUG" *)
    IF o.debug THEN d.PrintF("errVal=%ld\n",errVal); END;
(* \\\ $END *)
  END;
  DISPOSE(fileNamePtr);
  RETURN errVal;
END ParseRIFF;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ---------------------- "PROCEDURE HandleFileReq()" ---------------------- *)
PROCEDURE HandleFileReq();
BEGIN
  IF asl.base=NIL THEN
    d.PrintF("CyberAVI needs asl.library V37+\n");
  ELSE
    fileReq:=asl.AllocAslRequestTags(asl.fileRequest,asl.initialPattern,y.ADR("#?.avi"),
                                                     asl.doPatterns,e.true,
                                                     asl.doMultiSelect,e.true,
                                                     asl.titleText,y.ADR("Please select animation"),
                                                     u.done);
    IF fileReq#NIL THEN
      WHILE asl.AslRequestTags(fileReq,u.done) DO
        IF as.DoAllFiles(fileReq,ParseRIFF) THEN END;
      END;
      asl.FreeAslRequest(fileReq);
      fileReq:=NIL;
    END;
  END;
END HandleFileReq;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ---------------------- "PROCEDURE HandleWBStart()" ---------------------- *)
PROCEDURE HandleWBStart();

VAR     icon: wb.DiskObjectPtr;
        wbs: wb.WBStartupPtr;
        name: e.STRING;
        cnt: LONGINT;
        anchor: d.AnchorPathPtr;
        oldCD: d.FileLockPtr;
        err: LONGINT;
        multi: BOOLEAN;

BEGIN
  wbs:=ol.wbenchMsg;
  IF wbs.numArgs=1 THEN (* ja, dann Optionen vom CyberAVI-Icon *)
    y.SETREG(0,d.NameFromLock(wbs.argList[0].lock,name,SIZE(name)));
    y.SETREG(0,d.AddPart(name,wbs.argList[0].name^,SIZE(name)));
    icon:=ic.GetDiskObject(name);
    IF icon#NIL THEN
      o.GetIconOpts(icon);
      ic.FreeDiskObject(icon);
    ELSE
      o.GetStdOpts();
    END;
    HandleFileReq();
  ELSE
    anchor:=e.AllocVec(SIZE(anchor^)+SIZE(e.STRING),e.any+LONGSET{e.memClear});
    IF anchor#NIL THEN
      anchor.strLen:=SIZE(e.STRING);
      cnt:=1;
      err:=0;
      multi:=(wbs.numArgs>2);
      REPEAT
        oldCD:=d.CurrentDir(wbs.argList[cnt].lock);
        IF wbs.argList[cnt].name^#"" THEN (* keine Verzeichnisse *)
          IF d.MatchFirst(wbs.argList[cnt].name^,anchor^)=0 THEN
            icon:=ic.GetDiskObject(anchor.info.fileName);
            IF icon#NIL THEN
              o.GetIconOpts(icon);
              ic.FreeDiskObject(icon);
            ELSE
              o.GetStdOpts();
            END;
            err:=ParseRIFF(anchor,multi);
            IF err#0 THEN y.SETREG(0,d.PrintFault(err,NIL)); END;
          END;
          d.MatchEnd(anchor^);
        END;
        y.SETREG(0,d.CurrentDir(oldCD));
        INC(cnt);
      UNTIL (cnt=wbs.numArgs) OR (err#0);
      e.FreeVec(anchor);
    END;
  END;
END HandleWBStart;
(* \\\ ------------------------------------------------------------------------- *)

(* /// -------------------- "PROCEDURE HandleShellStart()" --------------------- *)
PROCEDURE HandleShellStart();

VAR     files: d.ArgStringArray;

BEGIN
  files:=o.GetShellOpts(template);
  IF files#NIL THEN
    IF ds.DoAllFiles(files,FALSE,ParseRIFF) THEN END;
  ELSE
    HandleFileReq();
  END;
END HandleShellStart;
(* \\\ ------------------------------------------------------------------------- *)

BEGIN
(* /// "$IF BETA" *)
  expire:=d.Date(expireDate,0,0);
  d.DateStamp(now);
  IF d.CompareDates(expire,now)>0 THEN
    d.PrintF("This beta has expired! Please contact me to get a more recent one\n");
    HALT(0);
  END;
(* \\\ $END *)
  io.noOdd:=TRUE;
  cu.CheckVersions(version);
  IF ol.wbStarted THEN
    HandleWBStart();
  ELSE
    HandleShellStart();
  END;
(* /// "$IF RUNDEBUG" *)
  IF o.debug THEN d.PrintF("normal exit\n"); END;
(* \\\ $END *)
CLOSE
  IF fileReq#NIL THEN asl.FreeAslRequest(fileReq); END;
END CyberAVI.
