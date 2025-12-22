MODULE  CyberQTUtils;

(* $IFNOT DEBUG *)
  (* $StackChk- $OvflChk- $RangeChk- $CaseChk- $ReturnChk- $NilChk- $TypeChk- $OddChk- $ClearVars- *)
(* $END *)

(* /// ------------------------------- "IMPORT" -------------------------------- *)
IMPORT  aio:=AsyncIO,
        d:=Dos,
        e:=Exec,
        es:=ExecSupport,
        g:=CyberQTGlobals,
        i:=Intuition,
        lv:=LibraryVer,
        mu:=MathUtils,
        ol:=OberonLib,
        u:=Utility,
        y:=SYSTEM;
(* \\\ ------------------------------------------------------------------------- *)

(* /// -------------------------------- "TYPE" --------------------------------- *)
TYPE    Array4=ARRAY 4 OF SHORTINT;
        Array2=ARRAY 2 OF SHORTINT;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ------------------------ "PROCEDURE PrintFCC()" ------------------------- *)
PROCEDURE PrintFCC * (fcc: LONGINT);

TYPE    arr=ARRAY 4 OF CHAR;

VAR     data: arr;
        null: LONGINT;

BEGIN
  null:=0;
  data:=y.VAL(arr,fcc);
  d.PrintF("%s ($%08lx)",y.ADR(data),fcc);
END PrintFCC;
(* \\\ ------------------------------------------------------------------------- *)

(* /// --------------------- "PROCEDURE PrintChunkHead()" ---------------------- *)
PROCEDURE PrintChunkHead * (id,size: LONGINT);
BEGIN
  d.PrintF("id: ");
  PrintFCC(id);
  d.PrintF(" size: $%08lx (%10ud)",size,size);
END PrintChunkHead;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ------------------------ "PROCEDURE PrintName()" ------------------------ *)
PROCEDURE PrintName * (name: ARRAY OF CHAR); (* $CopyArrays- *)

VAR     len: INTEGER;

BEGIN
  len:=ORD(name[0]);
  name[len+1]:=00X;
  d.PrintF("%s",y.ADR(name[1]));
END PrintName;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ------------------------ "PROCEDURE PrintReal()" ------------------------ *)
PROCEDURE PrintReal * (r: REAL);

VAR     x, y: LONGINT;

BEGIN
  mu.real2int(r,x,y,6);
  d.PrintF("%3ld.%06ld",x,y);
END PrintReal;
(* \\\ ------------------------------------------------------------------------- *)

(* /// --------------------------- "PROCEDURE oom()" --------------------------- *)
PROCEDURE oom();

VAR     errStr: e.STRING;
        prg: e.STRING;

BEGIN
  y.SETREG(0,d.GetProgramName(prg,SIZE(prg)));
  y.SETREG(0,d.Fault(d.noFreeStore,prg,errStr,SIZE(errStr)));
  d.PrintF("%s\n",y.ADR(errStr));
  HALT(5);
END oom;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ------------------------- "PROCEDURE AddPtr()" -------------------------- *)
PROCEDURE AddPtr * (VAR ptr: e.APTR;
                    add: LONGINT);
BEGIN
  ptr:=y.VAL(e.APTR,y.VAL(LONGINT,ptr)+add);
END AddPtr;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ---------------------- "PROCEDURE CheckVersions()" ---------------------- *)
PROCEDURE CheckVersions * (dummy: ARRAY OF CHAR); (* $CopyArrays- *)

VAR     garbage: e.LibraryPtr;

BEGIN
  IF ~lv.CheckVersion(y.ADR(e.SysBase.libNode),39,0) THEN
    d.PrintF("CyberQT needs at least AmigaOS 3.0 (V39)\n");
    HALT(0);
  END;
  IF ~(e.m68020 IN e.SysBase.attnFlags) THEN
    d.PrintF("CyberQT needs at least MC68020\n");
    HALT(0);
  END;
  IF ~lv.CheckVersion(aio.base,39,0) THEN
    d.PrintF("CyberQT needs asyncio.library V39+\n");
    HALT(0);
  END;
  garbage:=e.OpenLibrary("garbagecollector.library",3);
  IF ~lv.CheckVersion(garbage,3,80) THEN
    d.PrintF("CyberQT needs garbagecollector.library V3+\n");
    HALT(0);
  END;
  IF garbage#NIL THEN e.CloseLibrary(garbage); END;
END CheckVersions;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ---------------------- "PROCEDURE DisposeTrack()" ----------------------- *)
PROCEDURE DisposeTrack * (VAR trackList: e.List);

VAR     track: g.TrackPtr;

BEGIN
  WHILE ~es.ListEmpty(trackList) DO
    track:=e.RemHead(trackList);
    DISPOSE(track.descriptions);
    DISPOSE(track.times);
    DISPOSE(track.syncs);
    DISPOSE(track.samples);
    DISPOSE(track.sizes);
    DISPOSE(track.offsets);
    DISPOSE(track.edits);
    DISPOSE(track);
  END;
  es.NewList(trackList);
END DisposeTrack;
(* \\\ ------------------------------------------------------------------------- *)

(* /// --------------------- "PROCEDURE CalcDescEntries()" --------------------- *)
PROCEDURE CalcDescEntries * (trackList: e.List): LONGINT;

VAR     cnt: LONGINT;
        track: g.TrackPtr;

BEGIN
  cnt:=0;
  track:=trackList.head;
  WHILE track.node.succ#NIL DO
    INC(cnt,track.descriptionEntries);
    track:=track.node.succ;
  END;
  RETURN cnt;
END CalcDescEntries;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ----------------------- "PROCEDURE CalcMaxSize()" ----------------------- *)
PROCEDURE CalcMaxSize * (trackList: e.List;
                         video: BOOLEAN): LONGINT;

VAR     maxi: LONGINT;
        cnt: LONGINT;
        track: g.TrackPtr;

BEGIN
  maxi:=MIN(LONGINT);
  track:=trackList.head;
  IF video THEN
    WHILE track.node.succ#NIL DO
      FOR cnt:=0 TO track.sizeEntries-1 DO maxi:=mu.max(maxi,track.sizes[cnt]); END;
      track:=track.node.succ;
    END;
  ELSE
    WHILE track.node.succ#NIL DO
      FOR cnt:=0 TO track.sampleEntries-1 DO maxi:=mu.max(maxi,track.samples[cnt].samplesPerChunk); END;
      track:=track.node.succ;
    END;
  END;
  RETURN maxi;
END CalcMaxSize;
(* \\\ ------------------------------------------------------------------------- *)

(* /// --------------------- "PROCEDURE CountKeyframes()" ---------------------- *)
PROCEDURE CountKeyframes * (trackList: e.List): LONGINT;

VAR     track: g.TrackPtr;
        keys: LONGINT;

BEGIN
  keys:=0;
  track:=trackList.head;
  WHILE track.node.succ#NIL DO
    IF track.syncs#NIL THEN
      INC(keys,track.syncEntries);
    ELSE
      INC(keys,mu.max(track.sizeEntries,track.timeEntries)); (* sonst Anzahl der Bilder nehmen, weil alle Bilder Keyframes sind *)
    END;
    track:=track.node.succ;
  END;
  RETURN keys;
END CountKeyframes;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ----------------------- "PROCEDURE SortCodecs()" ------------------------ *)
PROCEDURE SortCodecs * (VAR trackList: e.List);

VAR     tempList: e.List;
        track: g.TrackPtr;
        pred: g.TrackPtr;
        foundPos: BOOLEAN;

BEGIN
  es.NewList(tempList);
  WHILE ~es.ListEmpty(trackList) DO e.AddTail(tempList,e.RemHead(trackList)); END;
  es.NewList(trackList);
  WHILE ~es.ListEmpty(tempList) DO
    track:=e.RemHead(tempList);
    IF es.ListEmpty(trackList) THEN
      e.AddHead(trackList,track);
    ELSIF track.initDuration<trackList.head(g.TrackPtr).initDuration THEN
      e.AddHead(trackList,track);
    ELSE
      foundPos:=FALSE;
      pred:=trackList.head;
      WHILE ~foundPos & (pred.node.succ#NIL) DO
        IF pred.initDuration>track.initDuration THEN
          foundPos:=TRUE;
          pred:=pred.node.pred;
        ELSE
          pred:=pred.node.succ;
        END;
      END;
      e.Insert(trackList,track,pred);
    END;
  END;
END SortCodecs;
(* \\\ ------------------------------------------------------------------------- *)

PROCEDURE CalcScrID * (idStr: ARRAY OF CHAR): LONGINT;

VAR     x: INTEGER;
        goon: BOOLEAN;
        id: LONGINT;

BEGIN
  id:=0;
  IF (idStr[0]="$") OR ((idStr[0]="0") & (idStr[1]="x")) THEN
    IF idStr[0]="$" THEN
      x:=1;
    ELSE
      x:=2;
    END;
    goon:=TRUE;
    WHILE (idStr[x]#00X) & goon DO
      id:=id*16;
      CASE idStr[x] OF
      | "0".."9": INC(id,ORD(idStr[x])-ORD("0"));
      | "a".."f": INC(id,ORD(idStr[x])-ORD("a")+10);
      | "A".."F": INC(id,ORD(idStr[x])-ORD("A")+10);
      ELSE
        id:=0;
        goon:=FALSE;
      END;
    END;
  END;
  RETURN id;
END CalcScrID;

BEGIN
  ol.OutOfMemHandler:=oom;
END CyberQTUtils.
