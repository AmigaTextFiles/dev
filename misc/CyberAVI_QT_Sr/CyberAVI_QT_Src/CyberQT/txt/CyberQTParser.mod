MODULE  CyberQTParser;

(* $IFNOT DEBUG *)
  (* $StackChk- $OvflChk- $RangeChk- $CaseChk- $ReturnChk- $NilChk- $TypeChk- $OddChk- $ClearVars- *)
(* $END *)

(* /// ------------------------------- "IMPORT" -------------------------------- *)
IMPORT  cu:=CyberQTUtils,
        d:=Dos,
        e:=Exec,
        es:=ExecSupport,
        fp:=FixedPoint,
        g:=CyberQTGlobals,
        io:=AsyncIOSupport2,
        mu:=MathUtils,
        o:=CyberQTOpts,
        ol:=OberonLib,
        y:=SYSTEM;
(* \\\ ------------------------------------------------------------------------- *)

(* /// -------------------------------- "CONST" -------------------------------- *)
CONST   idchap=y.VAL(LONGINT,"chap");
        idclip=y.VAL(LONGINT,"clip");
        idcrng=y.VAL(LONGINT,"crng");
        idctab=y.VAL(LONGINT,"ctab");
        iddinf=y.VAL(LONGINT,"dinf");
        iddref=y.VAL(LONGINT,"dref");
        idedts=y.VAL(LONGINT,"edts");
        idelst=y.VAL(LONGINT,"elst");
        idgmhd=y.VAL(LONGINT,"gmhd");
        idgmin=y.VAL(LONGINT,"gmin");
        idhdlr=y.VAL(LONGINT,"hdlr");
        idimap=y.VAL(LONGINT,"imap");
        idkmat=y.VAL(LONGINT,"kmat");
        idload=y.VAL(LONGINT,"load");
        idmatt=y.VAL(LONGINT,"matt");
        idmdhd=y.VAL(LONGINT,"mdhd");
        idmdia=y.VAL(LONGINT,"mdia");
        idminf=y.VAL(LONGINT,"minf");
        idmvhd=y.VAL(LONGINT,"mvhd");
        idscpt=y.VAL(LONGINT,"scpt");
        idskip=y.VAL(LONGINT,"skip");
        idsmhd=y.VAL(LONGINT,"smhd");
        idssrc=y.VAL(LONGINT,"ssrc");
        idstbl=y.VAL(LONGINT,"stbl");
        idstco=y.VAL(LONGINT,"stco");
        idstgs=y.VAL(LONGINT,"stgs");
        idstsc=y.VAL(LONGINT,"stsc");
        idstsd=y.VAL(LONGINT,"stsd");
        idstsh=y.VAL(LONGINT,"stsh");
        idstss=y.VAL(LONGINT,"stss");
        idstsz=y.VAL(LONGINT,"stsz");
        idstts=y.VAL(LONGINT,"stts");
        idsync=y.VAL(LONGINT,"sync");
        idtkhd=y.VAL(LONGINT,"tkhd");
        idtmcd=y.VAL(LONGINT,"tmcd");
        idtrak=y.VAL(LONGINT,"trak");
        idtref=y.VAL(LONGINT,"tref");
        idudta=y.VAL(LONGINT,"udta");
        idvmhd=y.VAL(LONGINT,"vmhd");

        trackEnabled=0;
        trackInMovie=1;
        trackInPreview=2;
        trackInPoster=3;
(* \\\ ------------------------------------------------------------------------- *)

(* /// --------------------------------- "VAR" --------------------------------- *)
VAR     currentTrack: g.TrackPtr;
        videoFlag: BOOLEAN;
        audioFlag: BOOLEAN;
        trackHead: g.TrackHeader;
        mediaHead: g.MediaHeader;
        trackStartOffset: LONGINT;
        trackInitDuration: LONGINT;
        edits: g.EditListIndex;
        editEntries: LONGINT;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ------------------- "PROCEDURE CorrectTrackValues()" -------------------- *)
PROCEDURE CorrectTrackValues(VAR trackList: e.List);

VAR     track: g.TrackPtr;
        cnt: LONGINT;
        lastCodec: LONGINT;
        lastChunk: LONGINT;
BEGIN
  IF es.ListEmpty(trackList) THEN RETURN; END;
  track:=trackList.head;
  lastCodec:=-1;
  lastChunk:=-1;
  WHILE track.node.succ#NIL DO
    IF track.syncs#NIL THEN
      FOR cnt:=0 TO track.syncEntries-1 DO
        DEC(track.syncs[cnt]);
      END;
    END;
    FOR cnt:=0 TO track.sampleEntries-1 DO
      INC(track.samples[cnt].descriptionID,lastCodec);
      INC(track.samples[cnt].firstChunk,lastChunk);
    END;
    INC(lastCodec,track.descriptionEntries);
    INC(lastChunk,track.samples[track.sampleEntries-1].firstChunk);
    track:=track.node.succ;
  END;
END CorrectTrackValues;
(* \\\ ------------------------------------------------------------------------- *)

(* /// "STBL" *)
(* /// ------------------------ "PROCEDURE ReadSTSD()" ------------------------- *)
PROCEDURE ReadSTSD(size: LONGINT): BOOLEAN;

VAR     entries: LONGINT;
        cnt: LONGINT;
        head: g.DescriptionHead;
        desc: g.DummyDescriptionPtr;

BEGIN
  io.Skip(g.qtFile,4); (* version/flags *)
  entries:=io.GetMSBLong(g.qtFile);
  DEC(size,8);
  ol.New(currentTrack.descriptions,entries*SIZE(g.DummyDescriptionPtr));
  currentTrack.descriptionEntries:=entries;
  FOR cnt:=0 TO entries-1 DO
    io.Read(g.qtFile,y.ADR(head),SIZE(head));
    ol.New(desc,head.size);
    desc.head:=head;
    io.Read(g.qtFile,y.ADR(desc.data),head.size-SIZE(head));
    DEC(size,head.size);
    currentTrack.descriptions[cnt]:=desc;
  END;
  IF size>0 THEN io.Skip(g.qtFile,size); END;
  RETURN TRUE;
END ReadSTSD;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ------------------------ "PROCEDURE ReadSTTS()" ------------------------- *)
PROCEDURE ReadSTTS(size: LONGINT): BOOLEAN;

VAR     index: g.TimeToSampleIndex;
        entries: LONGINT;
        cnt: LONGINT;

BEGIN
  IF ~videoFlag THEN io.Skip(g.qtFile,size); RETURN TRUE; END;
  io.Skip(g.qtFile,4); (* version/flags *)
  entries:=io.GetMSBLong(g.qtFile);
  DEC(size,8);
  ol.New(index,entries*SIZE(g.TimeToSample));
  io.Read(g.qtFile,index,entries*SIZE(g.TimeToSample));
  DEC(size,entries*SIZE(g.TimeToSample));
  currentTrack.times:=index;
  currentTrack.timeEntries:=entries;
  IF size>0 THEN io.Skip(g.qtFile,size); END;
  RETURN TRUE;
END ReadSTTS;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ------------------------ "PROCEDURE ReadSTSS()" ------------------------- *)
PROCEDURE ReadSTSS(size: LONGINT): BOOLEAN;

VAR     index: g.SyncSampleIndex;
        entries: LONGINT;
        cnt: LONGINT;

BEGIN
  io.Skip(g.qtFile,4); (* version/flags *)
  entries:=io.GetMSBLong(g.qtFile);
  DEC(size,8);
  ol.New(index,entries*SIZE(LONGINT));
  io.Read(g.qtFile,index,entries*SIZE(LONGINT));
  DEC(size,entries*SIZE(LONGINT));
  currentTrack.syncEntries:=entries;
  currentTrack.syncs:=index;
  IF size>0 THEN io.Skip(g.qtFile,size); END;
  RETURN TRUE;
END ReadSTSS;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ------------------------ "PROCEDURE ReadSTSC()" ------------------------- *)
PROCEDURE ReadSTSC(size: LONGINT): BOOLEAN;

VAR     index: g.SampleToChunkIndex;
        entries: LONGINT;
        cnt: LONGINT;
        last: LONGINT;

BEGIN
  io.Skip(g.qtFile,4); (* version/flags *)
  entries:=io.GetMSBLong(g.qtFile);
  DEC(size,8);
  IF entries#0 THEN
    cnt:=size DIV entries;
  ELSE
    cnt:=0;
  END;
  ol.New(index,entries*SIZE(g.SampleToChunk));
  IF cnt=16 THEN (* old style STSC *)
    FOR cnt:=0 TO entries-1 DO
      index[cnt].firstChunk:=io.GetMSBLong(g.qtFile);
      io.Skip(g.qtFile,4);
      index[cnt].samplesPerChunk:=io.GetMSBLong(g.qtFile);
      index[cnt].descriptionID:=io.GetMSBLong(g.qtFile);
      DEC(size,16);
    END;
  ELSE
    io.Read(g.qtFile,index,entries*SIZE(g.SampleToChunk));
    DEC(size,entries*SIZE(g.SampleToChunk));
  END;
  currentTrack.samples:=index;
  currentTrack.sampleEntries:=entries;
  IF size>0 THEN io.Skip(g.qtFile,size); END;
  RETURN TRUE;
END ReadSTSC;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ------------------------ "PROCEDURE ReadSTSZ()" ------------------------- *)
PROCEDURE ReadSTSZ(size: LONGINT): BOOLEAN;

VAR     index: g.SampleSizeIndex;
        entries: LONGINT;
        sampleSize: LONGINT;
        cnt: LONGINT;

BEGIN
  io.Skip(g.qtFile,4); (* version/flags *)
  sampleSize:=io.GetMSBLong(g.qtFile);
  entries:=io.GetMSBLong(g.qtFile);
  DEC(size,12);
  IF sampleSize=0 THEN
    ol.New(index,entries*SIZE(LONGINT));
    io.Read(g.qtFile,index,entries*SIZE(LONGINT));
    DEC(size,entries*SIZE(LONGINT));
  ELSIF (sampleSize=1) OR (sampleSize=2) THEN (* 1 für 8bit, 2 für 16bit *)
    ol.New(index,SIZE(LONGINT));
    index[0]:=entries;
    entries:=sampleSize;
  ELSE
    ol.New(index,entries*SIZE(LONGINT));
    FOR cnt:=0 TO entries-1 DO index[cnt]:=sampleSize; END;
  END;
  currentTrack.sizes:=index;
  currentTrack.sizeEntries:=entries;
  IF size>0 THEN io.Skip(g.qtFile,size); END;
  RETURN TRUE;
END ReadSTSZ;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ------------------------ "PROCEDURE ReadSTCO()" ------------------------- *)
PROCEDURE ReadSTCO(size: LONGINT): BOOLEAN;

VAR     index: g.ChunkOffsetIndex;
        entries: LONGINT;

BEGIN
  io.Skip(g.qtFile,4); (* version/flags *)
  entries:=io.GetMSBLong(g.qtFile);
  DEC(size,8);
  ol.New(index,entries*SIZE(LONGINT));
  io.Read(g.qtFile,index,entries*SIZE(LONGINT));
  DEC(size,entries*SIZE(LONGINT));
  currentTrack.offsets:=index;
  currentTrack.offsetEntries:=entries;
  IF size>0 THEN io.Skip(g.qtFile,size); END;
  RETURN TRUE;
END ReadSTCO;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ------------------------ "PROCEDURE ReadSTGS()" ------------------------- *)
PROCEDURE ReadSTGS(size: LONGINT): BOOLEAN;

VAR     index: g.ChunkOffsetIndex;
        entries: LONGINT;
        cnt: LONGINT;

BEGIN
  io.Skip(g.qtFile,4); (* version/flags *)
  entries:=io.GetMSBLong(g.qtFile);
  DEC(size,8);
(*
  FOR cnt:=0 TO entries-1 DO
    d.PrintF("samps: %ld\n",io.GetMSBLong());
    d.PrintF("pad: %ld\n", io.GetMSBLong());
    DEC(size,8);
  END;
*)
  io.Skip(g.qtFile,size); size:=0;
  IF size>0 THEN io.Skip(g.qtFile,size); END;
  RETURN TRUE;
END ReadSTGS;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ------------------------ "PROCEDURE ParseSTBL()" ------------------------ *)
PROCEDURE ParseSTBL(size: LONGINT): LONGINT;

VAR     atom: g.Atom;
        errVal: LONGINT;

BEGIN
  errVal:=g.noError;
  IF ~(videoFlag OR audioFlag) THEN
    io.Skip(g.qtFile,size);
    RETURN errVal;
  END;
  WHILE (size>0) & (errVal=g.noError) DO
    io.Read(g.qtFile,y.ADR(atom),SIZE(atom));
    DEC(size,atom.size);
    DEC(atom.size,SIZE(atom));
(* /// "$IF RUNDEBUG" *)
    IF o.debug THEN
      d.PrintF("          stbl id: "); cu.PrintFCC(atom.id); d.PrintF(", size: %ld\n",atom.size);
    END;
(* \\\ $END *)
    CASE atom.id OF
    | idstsd: IF ~ReadSTSD(atom.size) THEN errVal:=g.unknownError; END;
    | idstts: IF ~ReadSTTS(atom.size) THEN errVal:=g.unknownError; END;
    | idstss: IF ~ReadSTSS(atom.size) THEN errVal:=g.unknownError; END;
    | idstsc: IF ~ReadSTSC(atom.size) THEN errVal:=g.unknownError; END;
    | idstsz: IF ~ReadSTSZ(atom.size) THEN errVal:=g.unknownError; END;
    | idstco: IF ~ReadSTCO(atom.size) THEN errVal:=g.unknownError; END;
    | idstgs: IF ~ReadSTGS(atom.size) THEN errVal:=g.unknownError; END;
    | idstsh: io.Skip(g.qtFile,atom.size);
    ELSE
(* /// "$IF RUNDEBUG" *)
      IF o.debug THEN d.PrintF("unknown dinf atom\n"); END;
(* \\\ $END *)
      io.Skip(g.qtFile,atom.size);
    END;

    IF d.ctrlC IN e.SetSignal(LONGSET{},LONGSET{d.ctrlC}) THEN errVal:=d.break; END;
    IF ~g.qtFile.readOk THEN errVal:=g.readError; END;
  END;

  RETURN errVal;
END ParseSTBL;
(* \\\ ------------------------------------------------------------------------- *)
(* \\\ *)

(* /// "MINF" *)
(* /// ------------------------ "PROCEDURE ReadVMHD()" ------------------------- *)
PROCEDURE ReadVMHD(size: LONGINT): BOOLEAN;

VAR     head: g.VideoMediaHeader;
        newTrack: g.TrackPtr;

BEGIN
  IF size#SIZE(head) THEN
    d.PrintF("wrong size\n");
    RETURN FALSE;
  END;
  io.Read(g.qtFile,y.ADR(head),size);
(* /// "$IF RUNDEBUG" *)
  IF o.debug THEN
    d.PrintF("          version: %ld\n"
             "          flags: $%06lx\n"
             "          graphics mode: %ld\n"
             "          opColors: %ld %ld %ld\n"
             "\n",y.LSH(head.version,-24),
                  head.version MOD y.LSH(1,24),
                  head.graphicsMode,
                  head.opColor[0],
                  head.opColor[1],
                  head.opColor[2]);
  END;
(* \\\ $END *)

  videoFlag:=TRUE;
  NEW(newTrack);
  newTrack.head:=trackHead;
  newTrack.mediaHead:=mediaHead;
  newTrack.startOffset:=trackStartOffset;
  newTrack.initDuration:=trackInitDuration;
  newTrack.edits:=edits;
  newTrack.editEntries:=editEntries;
  e.AddTail(g.animInfo.videoTracks,newTrack);
  currentTrack:=newTrack;

  RETURN TRUE;
END ReadVMHD;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ------------------------ "PROCEDURE ReadSMHD()" ------------------------- *)
PROCEDURE ReadSMHD(size: LONGINT): BOOLEAN;

VAR     head: g.SoundMediaHeader;
        newTrack: g.TrackPtr;

BEGIN
  IF size#SIZE(head) THEN
    d.PrintF("wrong size\n");
    RETURN FALSE;
  END;
  io.Read(g.qtFile,y.ADR(head),size);
(* /// "$IF RUNDEBUG" *)
  IF o.debug THEN
    d.PrintF("          version: %ld\n"
             "          flags: $%06lx\n"
             "          balance: %ld\n"
             "\n",y.LSH(head.version,-24),
                  head.version MOD y.LSH(1,24),
                  head.balance);
  END;
(* \\\ $END *)

  audioFlag:=TRUE;
  NEW(newTrack);
  newTrack.head:=trackHead;
  newTrack.mediaHead:=mediaHead;
  newTrack.startOffset:=trackStartOffset;
  newTrack.initDuration:=trackInitDuration;
  newTrack.edits:=edits;
  newTrack.editEntries:=editEntries;
  e.AddTail(g.animInfo.audioTracks,newTrack);
  currentTrack:=newTrack;

  RETURN TRUE;
END ReadSMHD;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ------------------------ "PROCEDURE ParseMINF()" ------------------------ *)
PROCEDURE ParseMINF(size: LONGINT): LONGINT;

VAR     atom: g.Atom;
        errVal: LONGINT;

BEGIN
  errVal:=g.noError;
  WHILE (size>0) & (errVal=g.noError) DO
    io.Read(g.qtFile,y.ADR(atom),SIZE(atom));
    DEC(size,atom.size);
    DEC(atom.size,SIZE(atom));
(* /// "$IF RUNDEBUG" *)
    IF o.debug THEN
      d.PrintF("        minf id: "); cu.PrintFCC(atom.id); d.PrintF(", size: %ld\n",atom.size);
    END;
(* \\\ $END *)
    CASE atom.id OF
    | idvmhd: IF ~ReadVMHD(atom.size) THEN errVal:=g.unknownError; END;
    | idsmhd: IF ~ReadSMHD(atom.size) THEN errVal:=g.unknownError; END;
    | idstbl: errVal:=ParseSTBL(atom.size);
    | iddinf,
      idhdlr,
      idgmhd: io.Skip(g.qtFile,atom.size);
    ELSE
(* /// "$IF RUNDEBUG" *)
      IF o.debug THEN d.PrintF("unknown minf atom\n"); END;
(* \\\ $END *)
      io.Skip(g.qtFile,atom.size);
    END;

    IF d.ctrlC IN e.SetSignal(LONGSET{},LONGSET{d.ctrlC}) THEN errVal:=d.break; END;
    IF ~g.qtFile.readOk THEN errVal:=g.readError; END;
  END;
  RETURN errVal;
END ParseMINF;
(* \\\ ------------------------------------------------------------------------- *)
(* \\\ *)

(* /// "MDIA" *)
(* /// ------------------------ "PROCEDURE ReadMDHD()" ------------------------- *)
PROCEDURE ReadMDHD(size: LONGINT): BOOLEAN;

VAR     head: g.MediaHeader;

BEGIN
  IF size#SIZE(head) THEN
    d.PrintF("wrong size\n");
    RETURN FALSE;
  END;
  io.Read(g.qtFile,y.ADR(head),size);
(* /// "$IF RUNDEBUG" *)
  IF o.debug THEN
    d.PrintF("        version: %ld\n"
             "        flags: $%06lx\n"
             "        creation time: %lu\n"
             "        modification time: %lu\n"
             "        time scale: %ld\n"
             "        duration: %ld\n"
             "        language: %ld\n"
             "        quality: %ld\n"
             "\n",y.LSH(head.head.version,-24),
                  head.head.version MOD y.LSH(1,24),
                  head.head.creation,
                  head.head.modification,
                  head.timeScale,
                  head.duration,
                  head.language,
                  head.quality);
  END;
(* \\\ $END *)

  mediaHead:=head;
  RETURN TRUE;
END ReadMDHD;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ------------------------ "PROCEDURE ReadHDLR()" ------------------------- *)
PROCEDURE ReadHDLR(size: LONGINT): BOOLEAN;

VAR     head: g.HandlerReference;

BEGIN
  IF size>SIZE(head) THEN
    d.PrintF("wrong size\n");
    RETURN FALSE;
  END;
  io.Read(g.qtFile,y.ADR(head),size);
(* /// "$IF RUNDEBUG" *)
  IF o.debug THEN
    d.PrintF("        version: %ld\n"
             "        flags: $%06lx\n",y.LSH(head.version,-24),
                                       head.version MOD y.LSH(1,24));
    d.PrintF("        type: "); cu.PrintFCC(head.type); d.PrintF("\n");
    d.PrintF("        subType: "); cu.PrintFCC(head.subType); d.PrintF("\n");
    d.PrintF("        manufacturer: %ld\n"
             "        flags: $%08lx\n"
             "        flagMask: $%08lx\n",head.manufacturer,
                                          head.flags,
                                          head.flagMask);
    d.PrintF("        name: "); cu.PrintName(head.name); d.PrintF("\n\n");

  END;
(* \\\ $END *)

  RETURN TRUE;
END ReadHDLR;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ------------------------ "PROCEDURE ParseMDIA()" ------------------------ *)
PROCEDURE ParseMDIA(size: LONGINT): LONGINT;

VAR     atom: g.Atom;
        errVal: LONGINT;

BEGIN
  errVal:=g.noError;
  WHILE (size>0) & (errVal=g.noError) DO
    io.Read(g.qtFile,y.ADR(atom),SIZE(atom));
    DEC(size,atom.size);
    DEC(atom.size,SIZE(atom));
(* /// "$IF RUNDEBUG" *)
    IF o.debug THEN
      d.PrintF("      mdia id: "); cu.PrintFCC(atom.id); d.PrintF(", size: %ld\n",atom.size);
    END;
(* \\\ $END *)
    CASE atom.id OF
    | idmdhd: IF ~ReadMDHD(atom.size) THEN errVal:=g.unknownError; END;
    | idhdlr: IF ~ReadHDLR(atom.size) THEN errVal:=g.unknownError; END;
    | idminf: errVal:=ParseMINF(atom.size);
    | idudta: io.Skip(g.qtFile,atom.size);
    ELSE
(* /// "$IF RUNDEBUG" *)
      IF o.debug THEN d.PrintF("unknown mdia atom\n"); END;
(* \\\ $END *)
      io.Skip(g.qtFile,atom.size);
    END;

    IF d.ctrlC IN e.SetSignal(LONGSET{},LONGSET{d.ctrlC}) THEN errVal:=d.break; END;
    IF ~g.qtFile.readOk THEN errVal:=g.readError; END;
  END;
  RETURN errVal;
END ParseMDIA;
(* \\\ ------------------------------------------------------------------------- *)
(* \\\ *)

(* /// "TRAK" *)
(* /// ------------------------ "PROCEDURE ReadTKHD()" ------------------------- *)
PROCEDURE ReadTKHD(size: LONGINT): BOOLEAN;

VAR     head: g.TrackHeader;
        flags: LONGSET;
        s: e.STRING;
        w: e.STRING;
        h: e.STRING;

BEGIN
  IF size#SIZE(head) THEN
    d.PrintF("wrong size\n");
    RETURN FALSE;
  END;
  io.Read(g.qtFile,y.ADR(head),size);
(* /// "$IF RUNDEBUG" *)
  IF o.debug THEN
    mu.real2str(fp.FP16toREAL(head.volume),s,4);
    mu.real2str(fp.FP32toREAL(head.width),w,4);
    mu.real2str(fp.FP32toREAL(head.height),h,4);
    flags:=y.VAL(LONGSET,head.head.version)*LONGSET{0..23};
    d.PrintF("      version: %ld\n",y.LSH(head.head.version,-24));
    d.PrintF("      flags: $%06lx =",y.VAL(LONGINT,flags));
    IF trackEnabled IN flags THEN d.PrintF(" enabled"); END;
    IF trackInMovie IN flags THEN d.PrintF(" inMovie"); END;
    IF trackInPreview IN flags THEN d.PrintF(" inPreview"); END;
    IF trackInPoster IN flags THEN d.PrintF(" inPoster"); END;
    d.PrintF("\n"
             "      creation time: %lu\n"
             "      modification time: %lu\n"
             "      track ID: %ld\n"
             "      duration: %ld\n"
             "      layer: %ld\n"
             "      alt group: %ld\n"
             "      volume: %s\n"
             "      width: %s\n"
             "      height: %s\n"
             "\n",head.head.creation,
                  head.head.modification,
                  head.trackID,
                  head.duration,
                  head.layer,
                  head.altGroup,
                  y.ADR(s),
                  y.ADR(w),
                  y.ADR(h));
  END;
(* \\\ $END *)

  trackHead:=head;
  RETURN TRUE;
END ReadTKHD;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ------------------------ "PROCEDURE ReadELST()" ------------------------- *)
PROCEDURE ReadELST(size: LONGINT): BOOLEAN;

VAR     cnt: LONGINT;
        s: e.STRING;

BEGIN
  IF size=0 THEN RETURN TRUE; END;
  size:=io.GetMSBLong(g.qtFile);
  io.Skip(g.qtFile,8); (* "elst", flags/version *)
  editEntries:=io.GetMSBLong(g.qtFile);
  DEC(size,16);
  ol.New(edits,editEntries*SIZE(g.EditList));
  io.Read(g.qtFile,edits,editEntries*SIZE(g.EditList));
  IF edits[0].mediaTime=0FFFFFFFFH THEN
    INC(trackInitDuration,edits[0].duration);
(* /// "$IF RUNDEBUG" *)
    IF o.debug THEN d.PrintF("      elst init duration: %ld\n\n",trackInitDuration); END;
(* \\\ $END *)
  ELSIF edits[0].mediaTime#0 THEN
    INC(trackStartOffset,edits[0].mediaTime);
(* /// "$IF RUNDEBUG" *)
    IF o.debug THEN d.PrintF("      elst start offset: %ld\n\n",trackStartOffset); END;
(* \\\ $END *)
  END;
(* /// "$IF RUNDEBUG" *)
  IF o.debug THEN
    FOR cnt:=0 TO editEntries-1 DO
      mu.real2str(fp.FP32toREAL(edits[cnt].mediaRate),s,4);
      d.PrintF("      entry %2ld: duration: %ld\n"
               "                time: %ld\n"
               "                rate: %s\n"
               "\n",cnt,edits[cnt].duration,edits[cnt].mediaTime,y.ADR(s));
    END;
  END;
(* \\\ $END *)
  RETURN TRUE;
END ReadELST;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ------------------------ "PROCEDURE ParseTRAK()" ------------------------ *)
PROCEDURE ParseTRAK(size: LONGINT): LONGINT;

VAR     atom: g.Atom;
        errVal: LONGINT;

BEGIN
  videoFlag:=FALSE;
  audioFlag:=FALSE;
  trackStartOffset:=0;
  trackInitDuration:=0;
  edits:=NIL;
  editEntries:=0;
  currentTrack:=NIL;

  errVal:=g.noError;
  WHILE (size>0) & (errVal=g.noError) DO
    io.Read(g.qtFile,y.ADR(atom),SIZE(atom));
    DEC(size,atom.size);
    DEC(atom.size,SIZE(atom));
(* /// "$IF RUNDEBUG" *)
    IF o.debug THEN
      d.PrintF("    trak id: "); cu.PrintFCC(atom.id); d.PrintF(", size: %ld\n",atom.size);
    END;
(* \\\ $END *)
    CASE atom.id OF
    | idtkhd: IF ~ReadTKHD(atom.size) THEN errVal:=g.unknownError; END;
    | idedts: IF ~ReadELST(atom.size) THEN errVal:=g.unknownError; END;
    | idmdia: errVal:=ParseMDIA(atom.size);
    | idclip,
      idmatt,
      idtref,
      idload,
      idimap,
      idudta: io.Skip(g.qtFile,atom.size);
    ELSE
(* /// "$IF RUNDEBUG" *)
      IF o.debug THEN d.PrintF("unknown trak atom\n"); END;
(* \\\ $END *)
      io.Skip(g.qtFile,atom.size);
    END;

    IF d.ctrlC IN e.SetSignal(LONGSET{},LONGSET{d.ctrlC}) THEN errVal:=d.break; END;
    IF ~g.qtFile.readOk THEN errVal:=g.readError; END;
    IF trackHead.duration=0 THEN
      io.Skip(g.qtFile,size);
      size:=0;
    END;
  END;

  RETURN errVal;
END ParseTRAK;
(* \\\ ------------------------------------------------------------------------- *)
(* \\\ *)

(* /// "MOOV" *)
(* /// ------------------------ "PROCEDURE ReadMVHD()" ------------------------- *)
PROCEDURE ReadMVHD(size: LONGINT): BOOLEAN;

VAR     head: g.MovieHeader;
        s1: e.STRING;
        s2: e.STRING;

BEGIN
  IF size#SIZE(head) THEN
    d.PrintF("wrong size\n");
    RETURN FALSE;
  END;
  io.Read(g.qtFile,y.ADR(head),size);
(* /// "$IF RUNDEBUG" *)
  IF o.debug THEN
    mu.real2str(fp.FP32toREAL(head.rate),s1,4);
    mu.real2str(fp.FP16toREAL(head.volume),s2,4);
    d.PrintF("    version: %ld\n"
             "    flags: $%06lx\n"
             "    creation time: %lu\n"
             "    modification time: %lu\n"
             "    time scale: %ld\n"
             "    duration: %ld\n"
             "    rate: %s\n"
             "    volume: %s\n"
             "    preview time: %ld\n"
             "    preview duration: %ld\n"
             "    poster time: %ld\n"
             "    selection time: %ld\n"
             "    selection duration: %ld\n"
             "    currentTime: %ld\n"
             "    next track ID: %ld\n"
             "\n",y.LSH(head.head.version,-24),
                  head.head.version MOD y.LSH(1,24),
                  head.head.creation,
                  head.head.modification,
                  head.timeScale,
                  head.duration,
                  y.ADR(s1),
                  y.ADR(s2),
                  head.previewTime,
                  head.previewDuration,
                  head.posterTime,
                  head.selectTime,
                  head.selectDuration,
                  head.currentTime,
                  head.nextTrackID);
  END;
(* \\\ $END *)
  g.animInfo.mvhd:=head;

  RETURN TRUE;
END ReadMVHD;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ------------------------ "PROCEDURE ParseMOOV()" ------------------------ *)
PROCEDURE ParseMOOV * (size: LONGINT): LONGINT;

VAR     atom: g.Atom;
        errVal: LONGINT;

BEGIN
  errVal:=g.noError;
  WHILE (size>0) & (errVal=g.noError) DO
    io.Read(g.qtFile,y.ADR(atom),SIZE(atom));
    DEC(size,atom.size);
    DEC(atom.size,SIZE(atom));
(* /// "$IF RUNDEBUG" *)
    IF o.debug THEN
      d.PrintF("  moov id: "); cu.PrintFCC(atom.id); d.PrintF(", size: %ld\n",atom.size);
    END;
(* \\\ $END *)
    CASE atom.id OF
    | idmvhd: IF ~ReadMVHD(atom.size) THEN errVal:=g.unknownError; END;
    | idtrak: errVal:=ParseTRAK(atom.size);
    | idclip,
      idctab,
      idudta: io.Skip(g.qtFile,atom.size);
    ELSE
(* /// "$IF RUNDEBUG" *)
      IF o.debug THEN d.PrintF("unknown moov atom\n"); END;
(* \\\ $END *)
      io.Skip(g.qtFile,atom.size);
    END;

    IF d.ctrlC IN e.SetSignal(LONGSET{},LONGSET{d.ctrlC}) THEN errVal:=d.break; END;
    IF ~g.qtFile.readOk THEN errVal:=g.readError; END;
  END;

  IF errVal=g.noError THEN
    IF ~es.ListEmpty(g.animInfo.videoTracks) THEN
      cu.SortCodecs(g.animInfo.videoTracks);
      CorrectTrackValues(g.animInfo.videoTracks);
    END;
    IF ~es.ListEmpty(g.animInfo.audioTracks) THEN
      cu.SortCodecs(g.animInfo.audioTracks);
      CorrectTrackValues(g.animInfo.audioTracks);
    END;
  END;

  RETURN errVal;
END ParseMOOV;
(* \\\ ------------------------------------------------------------------------- *)
(* \\\ *)

END CyberQTParser.

