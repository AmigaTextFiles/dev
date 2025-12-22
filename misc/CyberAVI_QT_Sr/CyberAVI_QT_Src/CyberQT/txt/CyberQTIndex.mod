MODULE  CyberQTIndex;

(* $IFNOT DEBUG *)
  (* $StackChk- $OvflChk- $RangeChk- $CaseChk- $ReturnChk- $NilChk- $TypeChk- $OddChk- $ClearVars- *)
(* $END *)

(* /// ------------------------------- "IMPORT" -------------------------------- *)
IMPORT  a:=CyberQTAudio,
        BT:=BasicTypes,
        cu:=CyberQTUtils,
        d:=Dos,
        e:=Exec,
        es:=ExecSupport,
        g:=CyberQTGlobals,
        io:=AsyncIOSupport2,
        ll:=LinkedLists,
        mu:=MathUtils,
        o:=CyberQTOpts,
        ol:=OberonLib,
        s:=CyberQTSync,
        u:=Utility,
        v:=CyberQTVideo,
        y:=SYSTEM;
(* \\\ ------------------------------------------------------------------------- *)

(* /// -------------------------------- "TYPE" --------------------------------- *)
TYPE    IndexList=POINTER TO IndexListDesc;
        IndexListDesc=RECORD (ll.ListDesc);
        END;

        IndexNode=POINTER TO IndexNodeDesc;
        IndexNodeDesc=RECORD (ll.NodeDesc)
            num: LONGINT;
            offset: LONGINT;
            size: LONGINT;
            codecID: LONGINT;
            atTime: REAL;
            isDummy: BOOLEAN;
        END;

        AudioNode=POINTER TO AudioNodeDesc;
        AudioNodeDesc=RECORD (IndexNodeDesc)
            start: BOOLEAN;
            splitted: BOOLEAN;
            offset2: LONGINT;
            size2: LONGINT;
        END;

        VideoNode=POINTER TO VideoNodeDesc;
        VideoNodeDesc=RECORD (IndexNodeDesc)
            duration: REAL;
            isKey: BOOLEAN;
        END;
(* \\\ ------------------------------------------------------------------------- *)

(* /// -------------------------------- "CONST" -------------------------------- *)
CONST       epsilon=0.000005;
(* \\\ ------------------------------------------------------------------------- *)

(* /// --------------------------------- "VAR" --------------------------------- *)
VAR     videoIndexEntries: LONGINT;
        audioIndexEntries: LONGINT;
        onlyKeyframes: BOOLEAN;
        doVideo: BOOLEAN;
        doAudio: BOOLEAN;
        videoList: IndexList;
        audioList: IndexList;
        mainIndex: IndexList;
        keyframeCount: LONGINT;
        aInitDuration: REAL;
        aStartOffset: REAL;
        vInitDuration: REAL;
        vStartOffset: REAL;
        pause: BOOLEAN;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ------------------------ "PROCEDURE TestIndex()" ------------------------ *)
PROCEDURE TestIndex(node: BT.ANY;
                    x: BT.ANY);

VAR     time: e.STRING;
        dur: e.STRING;

BEGIN
  IF node IS VideoNode THEN
    WITH node: VideoNode DO
      mu.real2str(node.atTime,time,4);
      mu.real2str(node.duration,dur,4);
      d.PrintF("video node %5ld, offset: %8ld, size: %8ld, codec: %1ld, time: %10s, duration: %7s, key: %2ld\n",node.num,node.offset,node.size,node.codecID,y.ADR(time),y.ADR(dur),y.VAL(SHORTINT,node.isKey));
    END;
  ELSIF node IS AudioNode THEN
    WITH node: AudioNode DO
      mu.real2str(node.atTime,time,4);
      d.PrintF("audio node %5ld, offset: %8ld, size: %8ld, codec: %1ld, time: %10s, start: %2ld, splitted: %2ld, offset2: %8ld, size2: %8ld\n",node.num,node.offset,node.size,node.codecID,y.ADR(time),y.VAL(SHORTINT,node.start),y.VAL(SHORTINT,node.splitted),node.offset2,node.size2);
    END;
  END;
END TestIndex;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ---------------------- "PROCEDURE AudioPreload()" ----------------------- *)
PROCEDURE AudioPreload(node: BT.ANY;
                       x: BT.ANY);
BEGIN
  IF node IS AudioNode THEN
    WITH node: AudioNode DO
      a.DecodeFrame(node.offset,node.size,node.offset2,node.size2,node.codecID);
    END;
  END;
END AudioPreload;
(* \\\ ------------------------------------------------------------------------- *)

(* /// --------------------- "PROCEDURE CountKeyframes()" ---------------------- *)
PROCEDURE CountKeyframes(node: BT.ANY;
                         x: BT.ANY);
BEGIN
  IF node IS VideoNode THEN
    WITH node: VideoNode DO
      IF node.isKey THEN INC(keyframeCount); END;
    END;
  END;
END CountKeyframes;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ------------------------- "PROCEDURE Enqueue()" ------------------------- *)
PROCEDURE (list: IndexList) Enqueue(n: IndexNode);

VAR     x: IndexNode;

BEGIN
  IF list.isEmpty() THEN
    list.AddHead(n);
  ELSE
    x:=list.head(IndexNode);
    WHILE (x.atTime+epsilon<=n.atTime) & (x.next#NIL) DO x:=x.next(IndexNode); END;
    IF x.offset>n.offset THEN
      IF (x.atTime=n.atTime) OR ((x.prev#NIL) & (x.prev(IndexNode).offset>n.offset)) THEN
        WHILE (x.prev#NIL) & (x.prev(IndexNode).offset>n.offset) DO x:=x.prev(IndexNode); END;
      END;
    ELSE
(*
      IF (x.atTime=n.atTime) OR ((x.next#NIL) & (x.offset<n.offset)) THEN
        WHILE (x.next#NIL) & (x.offset<n.offset) DO x:=x.next(IndexNode); END;
      END;
*)
    END;
    IF (x IS AudioNode) THEN
      WITH x: AudioNode DO
        IF x.splitted & (x.offset2=-1) THEN (* 2.Teil noch nicht belegt *)
          x.offset2:=n.offset;
          x.size2:=n.size;
        ELSE (* sonst normal einfügen, ist 1.Teil *)
          IF x.atTime<n.atTime THEN
            x.AddBehind(n);
          ELSE
            x.AddBefore(n);
          END;
        END;
      END;
    ELSE
      WITH x: VideoNode DO
        IF x.offset<n.offset THEN
          x.AddBehind(n);
        ELSE
          x.AddBefore(n);
        END;
      END;
    END;
  END;
END Enqueue;
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
(*
    IF ret=g.pauseAnim THEN
      ret:=g.noError;
      pause:=~pause;
      IF pause THEN
        a.PauseSound(pause);
        s.PauseTimer(pause);
        EXCL(sigs,s.timerSig);
      ELSE
        INCL(sigs,s.timerSig);
        s.PauseTimer(pause);
        a.PauseSound(pause);
      END;
    END;
*)
    IF ret#g.noError THEN EXIT; END;
  END;
  RETURN ret;
END HandleEvents;
(* \\\ ------------------------------------------------------------------------- *)

(* /// --------------------- "PROCEDURE BuildVideoIndex()" --------------------- *)
PROCEDURE BuildVideoIndex();

VAR     track: g.TrackPtr;
        node: VideoNode;
        node2: VideoNode;
        chunk: LONGINT;
        sample: LONGINT;
        size: LONGINT;
        sample2Chunk: LONGINT;
        nextSample2Chunk: LONGINT;
        time2Sample: LONGINT;
        nextTime2Sample: LONGINT;
        syncSample: LONGINT;
        offset: LONGINT;
        numSamples: LONGINT;
        timeOffset: REAL;
        lastDuration: REAL;
        cur: LONGINT;
        timePerFrame: REAL;
        curEdit: LONGINT;
        curEditDuration: REAL;
        movieTime: REAL;
        trackTime: REAL;
        mediaTime: REAL;
        movieScale: LONGINT;
        trackScale: LONGINT;
        timeFactor: REAL;

BEGIN
  doVideo:=v.AllocBuffers() & ~o.noVideo;
(* /// "$IF RUNDEBUG" *)
  IF o.debug THEN d.PrintF("build video index\n"); END;
(* \\\ $END *)
  videoList.Init();
  IF ~es.ListEmpty(g.animInfo.videoTracks) THEN
    movieTime:=g.animInfo.mvhd.duration/g.animInfo.mvhd.timeScale;
    movieScale:=g.animInfo.mvhd.timeScale;
    cur:=0;
    track:=g.animInfo.videoTracks.head;
    WHILE track.node.succ#NIL DO
      trackTime:=track.head.duration/g.animInfo.mvhd.timeScale;
      trackScale:=track.mediaHead.timeScale;
      mediaTime:=track.mediaHead.duration/track.mediaHead.timeScale;
      timeFactor:=1.0;
      timeOffset:=vInitDuration;
      IF track.edits#NIL THEN
        IF track.edits[0].mediaTime#-1 THEN curEditDuration:=track.edits[0].duration/movieScale; END;
        IF trackTime<mediaTime THEN timeFactor:=trackTime/mediaTime; END; (* künstlich verkürzen? meist ca 99% statt 100% *)
      END;
      onlyKeyframes:=(track.syncs#NIL) & (track.syncEntries=track.sizeEntries) OR (track.syncEntries=0);
      sample:=0;
      sample2Chunk:=0;
      nextSample2Chunk:=track.samples[1].firstChunk;
      time2Sample:=0;
      IF track.times#NIL THEN
        nextTime2Sample:=track.times[0].count;
      ELSE
        nextTime2Sample:=-1;
        timePerFrame:=track.mediaHead.duration/trackScale/track.sizeEntries;
      END;
      syncSample:=0;
      curEdit:=0;
      FOR chunk:=0 TO track.offsetEntries-1 DO
        IF (chunk=nextSample2Chunk) & (sample2Chunk+1<track.sampleEntries) THEN
          INC(sample2Chunk);
          nextSample2Chunk:=track.samples[sample2Chunk+1].firstChunk;
        END;
        numSamples:=track.samples[sample2Chunk].samplesPerChunk;
        offset:=track.offsets[chunk];
        WHILE numSamples>0 DO
          DEC(numSamples);
          size:=track.sizes[sample];
          NEW(node);
          node.num:=cur;
          node.size:=size;
          node.offset:=offset;
          node.codecID:=track.samples[sample2Chunk].descriptionID;
          node.atTime:=timeOffset;
          IF track.times#NIL THEN
            lastDuration:=track.times[time2Sample].duration/trackScale;
          ELSE
            lastDuration:=timePerFrame;
          END;
          node.duration:=lastDuration*timeFactor;
          IF track.syncs#NIL THEN
            IF syncSample<track.syncEntries THEN
              IF track.syncs[syncSample]=sample THEN
                INC(syncSample);
                node.isKey:=TRUE;
              ELSE
                node.isKey:=FALSE;
              END;
            ELSE
              node.isKey:=FALSE;
            END;
          ELSE
            node.isKey:=TRUE;
          END;
          node.isDummy:=FALSE;
          videoList.AddTail(node);
          INC(sample);
          INC(offset,size);

          IF (sample=nextTime2Sample) & (time2Sample+1<track.timeEntries) THEN
            INC(time2Sample);
            INC(nextTime2Sample,track.times[time2Sample].count);
          END;

          IF (track.edits#NIL) & (track.editEntries>1) THEN
            curEditDuration:=curEditDuration-lastDuration;
            IF curEditDuration<=epsilon THEN (* edit-Zeit abgelaufen? dann nächsten Edit*)
              INC(curEdit);
              IF curEdit<track.editEntries THEN
                curEditDuration:=track.edits[curEdit].duration/movieScale;
                timeOffset:=track.edits[curEdit].mediaTime/trackScale;
                lastDuration:=0.0;
                IF track.edits[curEdit-1].mediaTime/trackScale+track.edits[curEdit-1].duration/movieScale>=timeOffset THEN
                  node:=videoList.tail(VideoNode);
                  WHILE node.atTime>timeOffset DO node:=node.prev(VideoNode); END;
                  WHILE node.atTime<timeOffset DO
                    NEW(node2);
                    INC(cur);
                    node2.num:=cur;
                    node2.offset:=node.offset;
                    node2.size:=node.size;
                    node2.codecID:=node.codecID;
                    node2.atTime:=node.atTime+node.duration;
                    node2.duration:=node.duration;
                    node2.isKey:=node.isKey;
                    videoList.AddTail(node2); (* letzten Knoten nochmal einhängen *)
                    node:=node.next(VideoNode);
                  END;
                END;
              END;
            END;
          END;
          timeOffset:=timeOffset+lastDuration;
          INC(cur);
        END;
      END;
      track:=track.node.succ;
    END;
  ELSE
    doVideo:=FALSE;
  END;
  WHILE videoList.nbElements()<nextTime2Sample DO
    node:=videoList.tail(VideoNode);
    NEW(node2);
    INC(cur);
    node2.num:=cur;
    node2.offset:=node.offset;
    node2.size:=node.size;
    node2.codecID:=node.codecID;
    node2.atTime:=node.atTime+node.duration;
    node2.duration:=node.duration;
    node2.isKey:=node.isKey;
    videoList.AddTail(node2); (* letzten Knoten nochmal einhängen *)
(* /// "$IF RUNDEBUG" *)
    IF o.debug THEN d.PrintF("added extra video frame\n"); END;
(* \\\ $END *)
  END;
  videoIndexEntries:=videoList.nbElements();

  IF vInitDuration>0.0 THEN
    NEW(node);
    node.num:=-1;
    node.size:=0;
    node.offset:=-1;
    node.codecID:=-1;
    node.atTime:=MIN(REAL);
    node.duration:=vInitDuration;
    node.isDummy:=TRUE;
    node.isKey:=FALSE;
    videoList.AddHead(node);
  END;

  NEW(node);
  node.num:=-2;
  node.offset:=-1;
  node.size:=0;
  node.codecID:=0;
  node.atTime:=MAX(REAL);
  node.duration:=0.0;
  node.isKey:=TRUE;
  videoList.AddTail(node); (* ein Dummynode *)
END BuildVideoIndex;
(* \\\ ------------------------------------------------------------------------- *)

(* /// -------------------- "PROCEDURE MergeAudioFrames()" --------------------- *)
PROCEDURE MergeAudioFrames();

VAR     node: AudioNode;
        node2: AudioNode;
        numMerged: LONGINT;

BEGIN
  node:=audioList.head(AudioNode);
  numMerged:=0;
  WHILE node.next#NIL DO
    node2:=node.next(AudioNode);
    IF (node.offset+node.size=node2.offset) & (node.codecID=node2.codecID) & (node.size+node2.size<=a.audioBufferSize) THEN
      node2.offset:=node.offset;
      node2.size:=node2.size+node.size;
      node2.atTime:=node.atTime;
      node2.start:=node2.start OR node.start;
      node.Remove();
      INC(numMerged);
    END;
    node:=node2;
  END;
(* /// "$IF RUNDEBUG" *)
  IF o.debug & (numMerged>0) THEN d.PrintF("merged %ld audio frames\n",numMerged); END;
(* \\\ $END *)
END MergeAudioFrames;
(* \\\ ------------------------------------------------------------------------- *)

(* /// --------------------- "PROCEDURE BuildAudioIndex()" --------------------- *)
PROCEDURE BuildAudioIndex();

VAR     track: g.TrackPtr;
        node: AudioNode;
        chunk: LONGINT;
        sample2Chunk: LONGINT;
        nextSample2Chunk: LONGINT;
        timeOffset: REAL;
        size: LONGINT;
        mainTimeScale: LONGINT;
        curEdit: LONGINT;
        inc: REAL;
        cur: LONGINT;

BEGIN
  doAudio:=a.AllocBuffers() & ~o.noSound & a.audioOpen;
(* /// "$IF RUNDEBUG" *)
  IF o.debug THEN d.PrintF("build audio index\n"); END;
(* \\\ $END *)
  audioList.Init();
  IF ~es.ListEmpty(g.animInfo.audioTracks) THEN
    track:=g.animInfo.audioTracks.head;
    cur:=0;
    WHILE track.node.succ#NIL DO
      size:=track.samples[0].samplesPerChunk;
      timeOffset:=aInitDuration;
(* ///
      IF track.edits#NIL THEN
        IF track.edits[0].mediaTime=-1 THEN
          timeOffset:=track.edits[0].duration/g.animInfo.mvhd.timeScale;
        ELSE
          timeOffset:=track.edits[0].mediaTime/track.mediaHead.timeScale;
        END;
      ELSE
        timeOffset:=0.0;
      END;
\\\ *)
      inc:=size/track.mediaHead.timeScale;
      timeOffset:=timeOffset-inc; (* negative Werte, damit Audio vor Video gelesen wird *)
      sample2Chunk:=0;
      nextSample2Chunk:=track.samples[1].firstChunk;
      FOR chunk:=0 TO track.offsetEntries-1 DO
        IF (chunk=nextSample2Chunk) & (sample2Chunk+1<track.sampleEntries) THEN
          INC(sample2Chunk);
          nextSample2Chunk:=track.samples[sample2Chunk+1].firstChunk;
        END;
        size:=track.samples[sample2Chunk].samplesPerChunk;
        NEW(node);
        node.num:=cur;
        node.size:=size;
        node.offset:=track.offsets[chunk];
        node.atTime:=timeOffset;
        node.isDummy:=FALSE;
        node.start:=(cur=1);
        node.splitted:=a.splittedStereo;
        node.offset2:=-1;
        node.size2:=-1;
        audioList.AddTail(node);
        timeOffset:=timeOffset+size/track.mediaHead.timeScale;
        INC(cur);
      END;
      track:=track.node.succ;
    END;
  ELSE
    doAudio:=FALSE;
  END;
  audioIndexEntries:=audioList.nbElements();
  IF audioIndexEntries=1 THEN audioList.head(AudioNode).start:=TRUE; END; (* bei nur einem Sample gleich beim ersten starten *)

  IF aInitDuration>0.0 THEN
    track:=g.animInfo.audioTracks.head;
    NEW(node);
    node.num:=-1;
    inc:=(g.animInfo.mvhd.duration-track.head.duration)/g.animInfo.mvhd.timeScale;
    IF inc-aInitDuration<=0 THEN inc:=aInitDuration; ELSE inc:=inc-aInitDuration; END;
    node.size:=mu.floor(inc*track.mediaHead.timeScale);
    node.offset:=-1;
    node.codecID:=-1;
    node.atTime:=MIN(REAL);
    node.isDummy:=TRUE;
    node.start:=FALSE;
    node.splitted:=a.splittedStereo;
    node.offset2:=-1;
    node.size2:=0;
    audioList.AddHead(node);
  END;

  NEW(node);
  node.num:=-2;
  node.offset:=-1;
  node.size:=0;
  node.codecID:=0;
  node.atTime:=MAX(REAL);
  node.start:=FALSE;
  audioList.AddTail(node); (* ein Dummynode *)

  MergeAudioFrames();
END BuildAudioIndex;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ----------------------- "PROCEDURE JoinIndices()" ----------------------- *)
PROCEDURE JoinIndices();

VAR     node: IndexNode;
        firstAudio: LONGINT;
        lastAudio: LONGINT;
        firstVideo: LONGINT;
        lastVideo: LONGINT;
        fileSize: LONGINT;

BEGIN
  mainIndex.Init();
  firstAudio:=audioList.head(IndexNode).offset;
  lastAudio:=audioList.tail(IndexNode).offset;
  firstVideo:=videoList.head(IndexNode).offset;
  lastVideo:=videoList.tail(IndexNode).offset;
(*
  fileSize:=io.FileSize(g.qtFile);
*)
  fileSize:=MAX(LONGINT);
  REPEAT
    node:=videoList.RemHead()(IndexNode);
    IF node.num#-2 THEN
      firstVideo:=mu.min(firstVideo,node.offset);
      lastVideo:=mu.max(lastVideo,node.offset);
      mainIndex.AddTail(node);
    END;
  UNTIL videoList.isEmpty();
  REPEAT
    node:=audioList.RemHead()(IndexNode);
    IF node.num#-2 THEN
      firstAudio:=mu.min(firstAudio,node.offset);
      lastAudio:=mu.max(lastAudio,node.offset);
      mainIndex.Enqueue(node);
    END;
  UNTIL audioList.isEmpty();
  IF (doVideo & (lastVideo>fileSize)) OR (doAudio & (lastAudio>fileSize)) THEN
    d.PrintF("File seems to be trancated!\n"
             "File size is %lD bytes, but should be at least %lD bytes!\n"
             "Playback may cause crashes!!!\n",fileSize,mu.min(lastVideo,lastAudio));
  END;
  IF ~o.audioPreload & doVideo & doAudio & (audioIndexEntries#0) & ((lastAudio<firstVideo) OR (firstAudio>lastVideo)) THEN d.PrintF("Audio and video data are not interleaved. Try option AUDIOPRELOAD if playback should be unsync.\n"); END;
  keyframeCount:=0;
  IF doVideo & o.doSkip THEN
    mainIndex.Do(CountKeyframes,NIL);
    node:=mainIndex.tail(IndexNode);
    WHILE ~(node IS VideoNode) DO node:=node.prev(IndexNode); END;
    IF keyframeCount<mu.floor(node(VideoNode).atTime+node(VideoNode).duration) THEN (* weniger als ein Key/sec *)
      d.PrintF("Not enough key frames (%ld), possible skips may produce wrong frames.\n",keyframeCount);
    END;
  END;

  NEW(node);
  node.num:=-2;
  node.offset:=0;
  node.size:=0;
  node.codecID:=0;
  node.atTime:=0.0;
  mainIndex.AddTail(node);
  (* mainIndex.Do(TestIndex,NIL); HALT(0); *)
END JoinIndices;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ---------------------- "PROCEDURE BuildIndices()" ----------------------- *)
PROCEDURE BuildIndices * ();

VAR     track: g.TrackPtr;
        movieScale: LONGINT;

BEGIN
  movieScale:=g.animInfo.mvhd.timeScale;
  vInitDuration:=0;
  vStartOffset:=0;
  aInitDuration:=0;
  aStartOffset:=0;
  IF ~es.ListEmpty(g.animInfo.videoTracks) THEN
    track:=g.animInfo.videoTracks.head;
    IF track.edits#NIL THEN
      IF track.edits[0].mediaTime=-1 THEN
        vInitDuration:=track.edits[0].duration/movieScale;
      ELSE
        vStartOffset:=track.edits[0].mediaTime/track.mediaHead.timeScale;
      END;
    END;
  END;
  IF ~es.ListEmpty(g.animInfo.audioTracks) THEN
    track:=g.animInfo.audioTracks.head;
    IF track.edits#NIL THEN
      IF track.edits[0].mediaTime=-1 THEN
        aInitDuration:=track.edits[0].duration/movieScale;
      ELSE
        aStartOffset:=track.edits[0].mediaTime/track.mediaHead.timeScale;
      END;
    END;
  END;
  vInitDuration:=vInitDuration+aStartOffset;
  aInitDuration:=aInitDuration+vStartOffset;
  BuildVideoIndex();
  BuildAudioIndex();
  JoinIndices();
END BuildIndices;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ------------------------ "PROCEDURE Playback()" ------------------------- *)
PROCEDURE Playback * (fileName: e.STRPTR): LONGINT;

VAR     errVal: LONGINT;
        vFramesDone: LONGINT;
        vFramesSkipped: LONGINT;
        skipping: BOOLEAN;
        sigs: LONGSET;
        node: IndexNode;
        time: e.STRING;
        audioStart: BOOLEAN;
        preLoaded: BOOLEAN;

BEGIN
  IF ~doVideo & ~doAudio THEN
    d.PrintF("Neither video nor audio samples to play!\n");
    RETURN g.noError;
  END;
  IF doAudio & (o.audioPreload OR (audioIndexEntries=1)) THEN
(* /// "$IF RUNDEBUG" *)
    IF o.debug THEN d.PrintF("preloading audio frames\n"); END;
(* \\\ $END *)
    mainIndex.Do(AudioPreload,NIL);
    preLoaded:=TRUE;
  ELSE
    preLoaded:=FALSE;
  END;
  errVal:=v.OpenDisplay(~doVideo,fileName);
  IF errVal#g.noError THEN
    v.CloseDisplay();
    RETURN errVal;
  END;
  vFramesSkipped:=0;
  IF doVideo THEN
    vFramesDone:=0;
    s.Wait(o.startDelay);
  ELSE
    vFramesDone:=1;
  END;
  LOOP
    skipping:=FALSE;
    audioStart:=FALSE;
    pause:=FALSE;
    node:=mainIndex.head(IndexNode);
    REPEAT
      IF (node IS VideoNode) & doVideo THEN
        WITH node: VideoNode DO
(* /// "$IF RUNDEBUG" *)
          IF o.debug THEN
            mu.real2str(node.atTime,time,4);
            d.PrintF("video sample: %5ld, size: %8ld, offset: %8ld, iskey: %2ld, codecID: %ld, time: %8s\n",node.num,node.size,node.offset,y.VAL(SHORTINT,node.isKey),node.codecID,y.ADR(time));
          END;
(* \\\ $END *)
          IF vFramesDone=0 THEN s.StartTimer(); END;
          errVal:=HandleEvents();
          IF skipping & node.isKey & ~onlyKeyframes THEN skipping:=FALSE; END;
          IF skipping THEN
            INC(vFramesSkipped);
          ELSE
            IF ~node.isDummy THEN
              v.DecodeFrame(node.offset,node.size,node.codecID);
            ELSE
              DEC(vFramesDone);
            END;
          END;
          s.DoFrameDelay(node.duration,skipping);
          skipping:=o.doSkip &
                    ~s.IsSync() &
                    (~node.isKey OR onlyKeyframes) OR
                    (skipping & ~onlyKeyframes);
          INC(vFramesDone);
        END;
      ELSIF (node IS AudioNode) & doAudio THEN
        WITH node: AudioNode DO
(* /// "$IF RUNDEBUG" *)
          IF o.debug THEN
            mu.real2str(node.atTime,time,4);
            d.PrintF("audio sample: %5ld, size: %8ld, offset: %8ld,            codecID: %ld, time: %8s\n",node.num,node.size,node.offset,node.codecID,y.ADR(time));
          END;
(* \\\ $END *)
          IF ~preLoaded THEN
            IF node.isDummy THEN
              a.DecodeDummyFrame(node.size);
            ELSE
              a.DecodeFrame(node.offset,node.size,node.offset2,node.size2,node.codecID);
            END;
          END;
          a.PlaySample(~doVideo);
          IF node.start & ~audioStart THEN audioStart:=TRUE; END;
        END;
      END;

      IF doAudio & audioStart & (vFramesDone>0) & ((node IS VideoNode) OR ~doVideo) THEN a.StartSound(); END;

      sigs:=e.SetSignal(LONGSET{},LONGSET{d.ctrlC,d.ctrlD});
      IF d.ctrlC IN sigs THEN errVal:=d.break; END;
      IF d.ctrlD IN sigs THEN errVal:=g.skipAnim; END;
      IF ~g.qtFile.readOk THEN errVal:=g.readError; END;
      IF errVal#g.noError THEN EXIT; END;
      node:=node.next(IndexNode);
    UNTIL (node.num=-2) OR (errVal#g.noError);
    a.Wait4LastSample(errVal#g.noError);
    IF ~o.doLoop THEN EXIT; END;
  END;
  s.Wait4LastFrame();
  IF doVideo & o.doStats THEN s.DoStats(vFramesDone,vFramesSkipped,videoIndexEntries); END;
  a.StopSound(errVal#g.noError);
  v.CloseDisplay();
  RETURN errVal;
END Playback;
(* \\\ ------------------------------------------------------------------------- *)

BEGIN
  NEW(videoList);
  NEW(audioList);
  NEW(mainIndex);
CLOSE
END CyberQTIndex.
