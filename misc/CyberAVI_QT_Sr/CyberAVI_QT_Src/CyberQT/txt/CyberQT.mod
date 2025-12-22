MODULE  CyberQT;

(* $IFNOT DEBUG *)
  (* $StackChk- $OvflChk- $RangeChk- $CaseChk- $ReturnChk- $NilChk- $TypeChk- $OddChk- $ClearVars- *)
(* $END *)

(* /// ------------------------------- "IMPORT" -------------------------------- *)
IMPORT  a:=CyberQTAudio,
        asl:=ASL,
        as:=ASLSupport,
        cu:=CyberQTUtils,
        d:=Dos,
        ds:=DosSupport,
        e:=Exec,
        es:=ExecSupport,
        g:=CyberQTGlobals,
        i:=CyberQTIndex,
        i2m:=Intel2Mot,
        ic:=Icon,
        io:=AsyncIOSupport2,
        o:=CyberQTOpts,
        ol:=OberonLib,
        p:=CyberQTParser,
        sl:=StringLib,
        u:=Utility,
(* /// "$IF DEBUG" *)
        NoGuru,
        Break,
(* \\\ $END *)
        v:=CyberQTVideo,
        wb:=Workbench,
        y:=SYSTEM;
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
                 "NOSOUND/S,"
                 "NOVIDEO/S,"
                 "SKIP/S,"
                 "AUDIOPRELOAD=APL/S,"
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
                 "NOSOUND/S,"
                 "NOVIDEO/S,"
                 "SKIP/S,"
                 "AUDIOPRELOAD=APL/S,"
                 "MAGNIFY/K/N,"

                 "STATS/S,"
                 "QUIET/S"

                 "";
(* $END *)

(* $IF BETA *)
        version="$VER: CyberQT 1.4 beta 0, time limit is 30-Nov-97 (2.10.97)"
                "\oCyberQT is ©1996-1997 Thore Böckelmann";
        expireDate=7274; (* = 30.11.97 *)
(* $ELSE *)
        version="$VER: CyberQT 1.4 (20.1.98)"
                "\oCyberQT is ©1996-1997 Thore Böckelmann";
(* $END *)

        idfree=y.VAL(LONGINT,"free");
        idmdat=y.VAL(LONGINT,"mdat");
        idmoov=y.VAL(LONGINT,"moov");
        idpnot=y.VAL(LONGINT,"pnot");
        idskip=y.VAL(LONGINT,"skip");
(* \\\ ------------------------------------------------------------------------- *)

(* /// --------------------------------- "VAR" --------------------------------- *)
VAR     fileReq: asl.FileRequesterPtr;
(* /// "$IF BETA" *)
        now: d.Date;
        expire: d.Date;
(* \\\ $END *)
(* \\\ ------------------------------------------------------------------------- *)

(* /// -------------------------- "PROCEDURE IsQT()" --------------------------- *)
PROCEDURE IsQT(total: LONGINT): BOOLEAN;

VAR     pos: LONGINT;
        len: LONGINT;
        cid: LONGINT;
        d1: LONGINT;
        d2: LONGINT;

BEGIN
  len:=io.GetMSBLong(g.qtFile);
  pos:=len;
  cid:=io.GetMSBLong(g.qtFile);
  IF cid=idmdat THEN
    io.SeekTo(g.qtFile,0);
    IF len=0 THEN
      RETURN FALSE;
    ELSE
      RETURN (len<total);
    END;
  ELSIF cid=idmoov THEN
    io.SeekTo(g.qtFile,0);
    RETURN TRUE;
  END;
  IF len<4 THEN RETURN FALSE; END;
  WHILE pos<total DO
    io.SeekTo(g.qtFile,pos);
    len:=io.GetMSBLong(g.qtFile);
    IF len=0 THEN
      len:=io.GetMSBLong(g.qtFile);
      INC(pos,4);
    END;
    d1:=io.GetMSBLong(g.qtFile);
    d2:=io.GetMSBLong(g.qtFile);
    IF d1=idmoov THEN
      io.SeekTo(g.qtFile,pos);
      RETURN TRUE;
    END;
    INC(pos,4);
    IF d2=idmoov THEN
      io.SeekTo(g.qtFile,pos);
      RETURN TRUE;
    END;
    IF len=0 THEN RETURN FALSE; END;
  END;
  RETURN FALSE;
END IsQT;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ---------------------- "PROCEDURE TestRSRCFork()" ----------------------- *)
PROCEDURE TestRSRCFork(file: ARRAY OF CHAR): BOOLEAN; (* $CopyArrays- *)

VAR     rsrc: e.STRING;

BEGIN
(* /// "$IF RUNDEBUG" *)
  IF o.debug THEN d.PrintF("just .data fork, trying .rsrc fork\n"); END;
(* \\\ $END *)
  sl.sprintf(rsrc,".resource/%s",y.ADR(file));
  IF io.Open(g.qtFile,rsrc,o.bufferSize,FALSE) THEN
    RETURN IsQT(io.FileSize(g.qtFile));
  ELSE
    sl.sprintf(rsrc,"resource/%s",y.ADR(file));
    IF io.Open(g.qtFile,rsrc,o.bufferSize,FALSE) THEN
      RETURN IsQT(io.FileSize(g.qtFile));
    ELSE
      sl.sprintf(rsrc,"%s.rsrc",y.ADR(file));
      IF io.Open(g.qtFile,rsrc,o.bufferSize,FALSE) THEN
        RETURN IsQT(io.FileSize(g.qtFile));
      ELSE
        sl.sprintf(rsrc,"%s.rs",y.ADR(file));
        IF io.Open(g.qtFile,rsrc,o.bufferSize,FALSE) THEN
          RETURN IsQT(io.FileSize(g.qtFile));
        ELSE
          d.PrintF("File \"%s\" is just the .data fork, .rsrc fork is missing.\n"
                   "Neither \".resource/%s\" nor \"resource/%s\" nor \"%s.rsrc\" nor \"%s.rs\" do exist.\n",y.ADR(file),y.ADR(file),y.ADR(file),y.ADR(file),y.ADR(file));
          RETURN FALSE;
        END;
      END;
    END;
  END;
END TestRSRCFork;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ------------------------- "PROCEDURE ParseQT()" ------------------------- *)
PROCEDURE ParseQT(ap: d.AnchorPathPtr;
                  multi: BOOLEAN): LONGINT;

VAR     atom: g.Atom;
        errVal: LONGINT;
        moovParsed: BOOLEAN;
        size: LONGINT;
        rsrcNeeded: BOOLEAN;
        fileNamePtr: e.STRPTR;

BEGIN
  NEW(fileNamePtr);
  COPY(ap.info.fileName,fileNamePtr^);
  IF multi & ~o.quiet THEN
    d.PrintF("%s: ",y.ADR(ap.info.fileName));
    y.SETREG(0,d.Flush(d.Output()));
  END;

  IF ~io.Open(g.qtFile,ap.info.fileName,o.bufferSize,FALSE) THEN RETURN d.IoErr(); END;
  size:=ap.info.size;
  errVal:=g.noError;
  moovParsed:=FALSE;
  rsrcNeeded:=FALSE;

  IF ~o.quiet & multi THEN d.PrintF("\n"); END;

  IF ~IsQT(size) THEN
    IF ~TestRSRCFork(ap.info.fileName) THEN
      RETURN d.objectWrongType;
    ELSE
      rsrcNeeded:=TRUE;
      size:=io.FileSize(g.qtFile)-io.FilePos(g.qtFile); (* verbleibende Größe neu ausrechnen, hat sich bei IsQT() geändert! *)
    END;
  END;

  WHILE ~moovParsed & (size>0) & (errVal=g.noError) DO
    io.Read(g.qtFile,y.ADR(atom),SIZE(atom));
    DEC(size,atom.size);
    DEC(atom.size,SIZE(atom));
(* /// "$IF RUNDEBUG" *)
      IF o.debug THEN
        d.PrintF("id: "); cu.PrintFCC(atom.id); d.PrintF(", size: %ld\n\n",atom.size);
      END;
(* \\\ $END *)
    CASE atom.id OF
    | idmoov:
        errVal:=p.ParseMOOV(atom.size);
        moovParsed:=(errVal=g.noError);
    | idmdat,
      idskip,
      idfree,
      idpnot: io.Skip(g.qtFile,atom.size);
    ELSE
(* /// "$IF RUNDEBUG" *)
        IF o.debug THEN d.PrintF("unknown atom\n"); END;
(* \\\ $END *)
      io.Skip(g.qtFile,atom.size);
    END;

    IF d.ctrlC IN e.SetSignal(LONGSET{},LONGSET{d.ctrlC}) THEN errVal:=d.break; END;
    IF ~g.qtFile.readOk THEN errVal:=g.readError; END;
  END;

  IF moovParsed THEN
(*
    IF rsrcNeeded THEN
      IF ~io.Open(g.qtFile,ap.info.fileName,o.bufferSize,FALSE) THEN RETURN d.IoErr(); END;
    ELSE
      io.SeekTo(g.qtFile,0); (* sonst wieder an den Anfang seek()en *)
    END;
*)
    io.Close(g.qtFile);
    IF a.InitAudioFile(ap.info.fileName) & v.InitVideoFile(ap.info.fileName) THEN
      i.BuildIndices();
      errVal:=i.Playback(fileNamePtr);
    END;
  END;
  cu.DisposeTrack(g.animInfo.videoTracks);
  cu.DisposeTrack(g.animInfo.audioTracks);

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
END ParseQT;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ---------------------- "PROCEDURE HandleFileReq()" ---------------------- *)
PROCEDURE HandleFileReq();
BEGIN
  IF asl.base=NIL THEN
    d.PrintF("CyberQT needs asl.library V37+\n");
  ELSE
    fileReq:=asl.AllocAslRequestTags(asl.fileRequest,asl.initialPattern,y.ADR("#?.(mov|qt)(%|.rsrc|.rs)"),
                                                     asl.doPatterns,e.true,
                                                     asl.doMultiSelect,e.true,
                                                     asl.titleText,y.ADR("Please select animation"),
                                                     u.done);
    IF fileReq#NIL THEN
      WHILE asl.AslRequestTags(fileReq,u.done) DO
        IF as.DoAllFiles(fileReq,ParseQT) THEN END;
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
  IF wbs.numArgs=1 THEN (* ja, dann Optionen vom CyberQT-Icon *)
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
            err:=ParseQT(anchor,multi);
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
    IF ds.DoAllFiles(files,FALSE,ParseQT) THEN END;
  ELSE
    HandleFileReq();
  END;
END HandleShellStart;
(* \\\ ------------------------------------------------------------------------- *)

BEGIN
(*
(* /// "$IF BETA" *)
  expire:=d.Date(expireDate,0,0);
  d.DateStamp(now);
  IF d.CompareDates(expire,now)>0 THEN
    d.PrintF("This beta has expired! Please contact me to get a more recent one.\n");
    HALT(0);
  END;
(* \\\ $END *)
*)
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
END CyberQT.

