MODULE  CyberQTOpts;

(* $IFNOT DEBUG *)
  (* $StackChk- $OvflChk- $RangeChk- $CaseChk- $ReturnChk- $NilChk- $TypeChk- $OddChk- $ClearVars- *)
(* $END *)

(* /// ------------------------------- "IMPORT" -------------------------------- *)
IMPORT  b:=BestModeID,
        d:=Dos,
        e:=Exec,
        g:=CyberQTGlobals,
        ics:=IconSupport,
        ol:=OberonLib,
        wb:=Workbench,
        y:=SYSTEM;
(* \\\ ------------------------------------------------------------------------- *)

(* /// --------------------------------- "VAR" --------------------------------- *)
VAR     rda: d.RDArgsPtr;
        out: d.FileHandlePtr;
        oldOut: d.FileHandlePtr;

        pubScreen * : e.STRING;
        askScrMode - : BOOLEAN;
        screenModeID - : LONGINT;
        force24 - : BOOLEAN;
        grayScale - : BOOLEAN;
        aga - : BOOLEAN;
        ham8 - : BOOLEAN;
        dither - : BOOLEAN;
        cmap - : e.STRING;
        bufferSize - : LONGINT;
        startDelay - : LONGINT;
        doLoop - : BOOLEAN;
        maxFPS - : BOOLEAN;
        noSound - : BOOLEAN;
        noVideo - : BOOLEAN;
        doSkip - : BOOLEAN;
        audioPreload - : BOOLEAN;
        magnify - : LONGINT;
        doStats - : BOOLEAN;
        quiet - : BOOLEAN;
(* /// "$IF RUNDEBUG" *)
        debug - : BOOLEAN;
(* \\\ $END *)
(* \\\ ------------------------------------------------------------------------- *)

(* /// -------------------------------- "CONST" -------------------------------- *)
CONST   defBufferSize=64;
        defStartDelay=2;
        defPubScreen="";
        defMagnify=1;
        defScrModeID="0x00000000";
(* \\\ ------------------------------------------------------------------------- *)

(* /// ---------------------- "PROCEDURE CheckOptions()" ----------------------- *)
PROCEDURE CheckOptions();
BEGIN
  IF startDelay>10 THEN startDelay:=10; END;
  IF startDelay<0 THEN startDelay:=defStartDelay; END;
  IF bufferSize>4096 THEN bufferSize:=4096; END;
  IF bufferSize<=0 THEN bufferSize:=defBufferSize; END;
  bufferSize:=bufferSize*1024;
  IF magnify<-4 THEN magnify:=-4; END;
  IF (magnify=-1) OR (magnify=0) OR (magnify=1) THEN magnify:=defMagnify; END;
  IF magnify>4 THEN magnify:=4; END;
  IF ~aga THEN aga:=g.agaOnly; END;
  IF ham8 THEN
    IF ~g.cgfxOnly THEN
      aga:=TRUE;
    ELSE
      d.PrintF("You have no AGA chipset. The HAM8 option only works with AGA!\n");
      ham8:=FALSE;
    END;
  END;
  IF dither THEN aga:=TRUE; END;
  IF (pubScreen#"") & g.agaOnly THEN
    d.PrintF("You have no CyberGraphX installed. The PUBSCREEN option only works with CyberGraphX!\n");
    pubScreen:="";
  END;
  IF (pubScreen#"") & aga THEN aga:=FALSE; END;
  IF (pubScreen#"") & ham8 THEN
    d.PrintF("You must specify only one option of HAM8 and PUBSCREEN. HAM8 display switched off!\n");
    ham8:=FALSE;
  END;
  IF grayScale & ham8 THEN
    d.PrintF("You must specify only one option of HAM8 and GRAY. Grayscale display switched off!\n");
    grayScale:=FALSE;
  END;
  IF grayScale & dither THEN
    d.PrintF("You must specify only one option of DITHER and GRAY. Grayscale display switched off!\n");
    grayScale:=FALSE;
  END;
  IF ham8 & dither THEN
    d.PrintF("You must specify only one option of HAM8 and DITHER. HAM8 display switched off!\n");
    grayScale:=FALSE;
  END;
  IF noVideo & noSound THEN
    d.PrintF("You must not specify both options NOVIDEO and NOSOUND. Video playback switched on!\n");
    noVideo:=FALSE;
  END;
  IF noVideo & doStats THEN doStats:=FALSE; END;
(* /// "$IF RUNDEBUG" *)
  IF debug THEN quiet:=FALSE; END;
(* \\\ $END *)
END CheckOptions;
(* \\\ ------------------------------------------------------------------------- *)

(* /// --------------------- "PROCEDURE GetArgValueInt()" ---------------------- *)
PROCEDURE GetArgValueInt(arg: d.ArgLong;
                         def: LONGINT): LONGINT;
BEGIN
  IF arg#NIL THEN
    RETURN arg[0]
  ELSE
    RETURN def;
  END;
END GetArgValueInt;
(* \\\ ------------------------------------------------------------------------- *)

(* /// --------------------- "PROCEDURE GetArgValueStr()" ---------------------- *)
PROCEDURE GetArgValueStr(arg: d.ArgString;
                         def: e.STRING): e.STRING; (* $CopyArrays-*)

VAR     dummy: e.STRING;

BEGIN
  IF arg#NIL THEN
    COPY(arg^,dummy);
    RETURN dummy;
  ELSE
    RETURN def;
  END;
END GetArgValueStr;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ---------------------- "PROCEDURE GetShellOpts()" ----------------------- *)
PROCEDURE GetShellOpts * (template: ARRAY OF CHAR): d.ArgStringArray;

VAR     args: UNTRACED POINTER TO STRUCT(dummy: d.ArgsStruct)
            files: d.ArgStringArray;
            pubScreen: d.ArgString;
            scrModeReq: d.ArgBool;
            scrModeID: d.ArgString;
            force24: d.ArgBool;
            grayScale: d.ArgBool;
            aga: d.ArgBool;
            ham8: d.ArgBool;
            dither: d.ArgBool;
            cmap: d.ArgString;
            bufferSize: d.ArgLong;
            startDelay: d.ArgLong;
            loop: d.ArgBool;
            maxFPS: d.ArgBool;
            noSound: d.ArgBool;
            noVideo: d.ArgBool;
            skip: d.ArgBool;
            audioPreload: d.ArgBool;
            magnify: d.ArgLong;
            stats: d.ArgBool;
            quiet: d.ArgBool;
(* /// "$IF RUNDEBUG" *)
            debug: d.ArgBool;
(* \\\ $END *)
        END;
        scrID: e.STRING;

BEGIN
  NEW(args);
  rda:=d.ReadArgs(template,args^,NIL);
  IF rda#NIL THEN
    startDelay:=GetArgValueInt(args.startDelay,defStartDelay);
    bufferSize:=GetArgValueInt(args.bufferSize,defBufferSize);
    pubScreen:=GetArgValueStr(args.pubScreen,defPubScreen);
    noVideo:=(args.noVideo=e.LTRUE);
    noSound:=(args.noSound=e.LTRUE);
    doLoop:=(args.loop=e.LTRUE);
    askScrMode:=(args.scrModeReq=e.LTRUE);
    scrID:=GetArgValueStr(args.scrModeID,defScrModeID);
    aga:=(args.aga=e.LTRUE);
    ham8:=(args.ham8=e.LTRUE);
    dither:=(args.dither=e.LTRUE);
    cmap:=GetArgValueStr(args.cmap,"");
    grayScale:=(args.grayScale=e.LTRUE);
    force24:=(args.force24=e.LTRUE);
    maxFPS:=(args.maxFPS=e.LTRUE);
    doSkip:=(args.skip=e.LTRUE);
    audioPreload:=(args.audioPreload=e.LTRUE);
    magnify:=GetArgValueInt(args.magnify,defMagnify);
    doStats:=(args.stats=e.LTRUE);
    quiet:=(args.quiet=e.LTRUE);
(* /// "$IF RUNDEBUG" *)
    debug:=(args.debug=e.LTRUE);
(* \\\ $END *)
    CheckOptions();
    screenModeID:=b.CalcModeID(scrID);
    RETURN args.files;
  ELSE
    y.SETREG(0,d.PrintFault(d.IoErr(),NIL));
    RETURN NIL;
  END;
END GetShellOpts;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ----------------------- "PROCEDURE GetIconOpts()" ----------------------- *)
PROCEDURE GetIconOpts * (icon: wb.DiskObjectPtr);

VAR     scrID: e.STRING;

BEGIN
  bufferSize:=ics.GetTTValueInt(icon,"BUFFERSIZE",defBufferSize);
  startDelay:=ics.GetTTValueInt(icon,"DELAY",defStartDelay);
  force24:=ics.LookupToolType(icon,"FORCE24");
  grayScale:=ics.LookupToolType(icon,"GRAY") OR ics.LookupToolType(icon,"GREY");
  aga:=ics.LookupToolType(icon,"AGA");
  ham8:=ics.LookupToolType(icon,"HAM8");
  dither:=ics.LookupToolType(icon,"DITHER");
  cmap:=ics.GetTTValueStr(icon,"CMAP","");
  doLoop:=ics.LookupToolType(icon,"LOOP");
  maxFPS:=ics.LookupToolType(icon,"MAXFPS");
  noSound:=ics.LookupToolType(icon,"NOSOUND");
  noVideo:=ics.LookupToolType(icon,"NOVIDEO");
  pubScreen:=ics.GetTTValueStr(icon,"PUBSCREEN",defPubScreen);
  quiet:=ics.LookupToolType(icon,"QUIET");
  askScrMode:=ics.LookupToolType(icon,"SCREENMODEREQ");
  scrID:=ics.GetTTValueStr(icon,"SCREENMODEID",defScrModeID);
  doSkip:=ics.LookupToolType(icon,"SKIP");
  audioPreload:=ics.LookupToolType(icon,"AUDIOPRELOAD");
  magnify:=ics.GetTTValueInt(icon,"MAGNIFY",defMagnify);
  doStats:=ics.LookupToolType(icon,"STATS");
(* /// "$IF RUNDEBUG" *)
  debug:=ics.LookupToolType(icon,"DEBUG");
(* \\\ $END *)
  IF out=NIL THEN
    out:=d.Open(ics.GetTTValueStr(icon,"WINDOW","NIL:"),d.newFile);
    IF out=NIL THEN out:=d.Open("NIL:",d.newFile); END;
    oldOut:=d.SelectOutput(out);
  END;
  CheckOptions();
  screenModeID:=b.CalcModeID(scrID);
END GetIconOpts;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ----------------------- "PROCEDURE GetStdOpts()" ------------------------ *)
PROCEDURE GetStdOpts * ();
BEGIN
  startDelay:=defStartDelay;
  bufferSize:=defBufferSize;
  pubScreen:="";
  noVideo:=FALSE;
  noSound:=FALSE;
  doLoop:=FALSE;
  askScrMode:=FALSE;
  screenModeID:=b.CalcModeID(defScrModeID);
  aga:=FALSE;
  ham8:=FALSE;
  dither:=FALSE;
  cmap:="";
  grayScale:=FALSE;
  force24:=FALSE;
  maxFPS:=FALSE;
  doSkip:=FALSE;
  audioPreload:=FALSE;
  magnify:=defMagnify;
  doStats:=FALSE;
  quiet:=FALSE;
  IF ol.wbStarted & (out=NIL) THEN
    out:=d.Open("NIL:",d.newFile);
    oldOut:=d.SelectOutput(out);
  END;
(* /// "$IF RUNDEBUG" *)
  debug:=FALSE;
(* \\\ $END *)
END GetStdOpts;
(* \\\ ------------------------------------------------------------------------- *)

BEGIN
  rda:=NIL;
  out:=NIL;
CLOSE
  IF rda#NIL THEN d.FreeArgs(rda); END;
  IF ol.wbStarted & (out#NIL) THEN
    oldOut:=d.SelectOutput(oldOut);
    d.OldClose(out);
  END;
END CyberQTOpts.

