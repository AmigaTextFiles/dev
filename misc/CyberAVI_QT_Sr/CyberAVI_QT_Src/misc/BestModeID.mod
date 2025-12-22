MODULE  BestModeID;

(* $StackChk- $OvflChk- $RangeChk- $CaseChk- $ReturnChk- $NilChk- $TypeChk- $OddChk- $ClearVars- *)

(* /// ------------------------------- "IMPORT" -------------------------------- *)
IMPORT  asl:=ASL,
        cgfx:=CyberGraphics,
        e:=Exec,
        gfx:=Graphics,
        i2m:=Intel2Mot,
        u:=Utility,
        y:=SYSTEM;
(* \\\ ------------------------------------------------------------------------- *)

(* /// --------------------------------- "VAR" --------------------------------- *)
VAR     smrHook: u.HookPtr;
        desiredWidth: LONGINT;
        desiredHeight: LONGINT;
        desiredDepth: LONGINT;
        forceAGA: BOOLEAN;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ---------------------- "PROCEDURE SMReqHookFunc()" ---------------------- *)
PROCEDURE SMReqHookFunc(hook: u.HookPtr;
                        req: asl.ScreenModeRequesterPtr;
                        id: LONGINT): LONGINT;

VAR     modeDepth: LONGINT;
        modeWidth: LONGINT;
        modeHeight: LONGINT;
        dimInfo: gfx.DimensionInfo;
        dispInfo: gfx.DisplayInfo;
        aspect: REAL;

(* /// ------------------------ "PROCEDURE GetAspect()" ------------------------ *)
  PROCEDURE GetAspect(rect: gfx.Rectangle): REAL;
  BEGIN
    RETURN (rect.maxX-rect.minX+1)/(rect.maxY-rect.minY+1);
  END GetAspect;
(* \\\ ------------------------------------------------------------------------- *)

BEGIN
  IF forceAGA THEN
    y.SETREG(0,gfx.GetDisplayInfoData(NIL,dimInfo,SIZE(dimInfo),gfx.dtagDims,id));
    aspect:=GetAspect(dimInfo.nominal);
    modeDepth:=dimInfo.maxDepth;
    modeWidth:=dimInfo.nominal.maxX-dimInfo.nominal.minX+1;
    modeHeight:=dimInfo.nominal.maxY-dimInfo.nominal.minY+1;
    IF (desiredDepth<=8) & (modeDepth<=8) & (modeWidth>=desiredWidth) & (modeHeight>=desiredHeight) & (aspect>1.0) & (aspect<1.65) THEN RETURN e.true; END;
  ELSE
    IF cgfx.IsCyberModeID(id) THEN
      modeDepth:=cgfx.GetCyberIDAttr(cgfx.idAttrDepth,id);
      modeWidth:=cgfx.GetCyberIDAttr(cgfx.idAttrWidth,id);
      modeHeight:=cgfx.GetCyberIDAttr(cgfx.idAttrHeight,id);
      IF (desiredDepth<=8) & (modeDepth<=8) & (modeWidth>=desiredWidth) & (modeHeight>=desiredHeight) THEN RETURN e.true; END;
      IF (desiredDepth>8) & (modeDepth>8) & (modeWidth>=desiredWidth) & (modeHeight>=desiredHeight) THEN RETURN e.true; END;
    END;
  END;
  RETURN e.false;
END SMReqHookFunc;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ---------------------- "PROCEDURE IgnoreIfFalse()" ---------------------- *)
PROCEDURE IgnoreIfFalse(tagVal{0}: u.TagID;
                        tagData{1}: BOOLEAN): u.TagID;
BEGIN
  IF tagData THEN
    RETURN tagVal;
  ELSE
    RETURN u.ignore;
  END;
END IgnoreIfFalse;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ------------------------ "PROCEDURE BestMode()" ------------------------- *)
PROCEDURE BestMode * (width: LONGINT;
                      height: LONGINT;
                      depth: LONGINT;
                      aga: BOOLEAN;
                      ham: BOOLEAN): LONGINT;

VAR     id: LONGINT;
        w: LONGINT;
        h: LONGINT;
        hinc: LONGINT;
        dim: gfx.DimensionInfo;

BEGIN
  IF aga OR ham THEN
    IF gfx.pal IN gfx.base.displayFlags THEN (* PAL oder NTSC? *)
      w:=i2m.Round(width,160);
      h:=i2m.Round(height,128);
      IF h=128 THEN h:=256; END;
    ELSE
      w:=i2m.Round(width,160);
      h:=i2m.Round(height,100);
      IF h=100 THEN h:=200; END;
    END;
    WHILE w<h DO w:=i2m.Round(w*2,160); END;
    id:=gfx.BestModeID(gfx.bidTagNominalWidth,w,
                       gfx.bidTagNominalHeight,h,
                       gfx.bidTagDepth,depth,
                       IgnoreIfFalse(gfx.bidTagDipfMustHave,ham),LONGSET{gfx.isHAM},
                       u.done);
  ELSE
    w:=i2m.Round(width,320);
    h:=i2m.Round(height,240);
    IF depth<8 THEN depth:=8; END;
    WHILE w<h DO w:=i2m.Round(w*2,160); END;
    id:=cgfx.BestCModeIDTags(cgfx.bIDTGNominalWidth,w,
                             cgfx.bIDTGNominalHeight,h,
                             cgfx.bIDTGDepth,depth,
                             u.done);
  END;
  RETURN id;
END BestMode;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ------------------- "PROCEDURE SelectModeIDSimple()" -------------------- *)
PROCEDURE SelectModeIDSimple * (width: LONGINT;
                                height: LONGINT;
                                ham: BOOLEAN): LONGINT;

VAR     id: LONGSET;

BEGIN
  id:=LONGSET{};
  IF width>384 THEN INCL(id,gfx.hires); END;
  IF height>283 THEN INCL(id,gfx.lace); END;
  IF ham THEN INCL(id,gfx.ham); END;
  RETURN y.VAL(LONGINT,id);
END SelectModeIDSimple;
(* \\\ ------------------------------------------------------------------------- *)

(* /// -------------------- "PROCEDURE SelectModeIDByReq()" -------------------- *)
PROCEDURE SelectModeIDByReq * (width: LONGINT;
                               height: LONGINT;
                               depth: LONGINT;
                               initID: LONGINT;
                               aga: BOOLEAN;
                               ham: BOOLEAN): LONGINT;

VAR     scrModeReq: asl.ScreenModeRequesterPtr;
        minDepth: LONGINT;
        maxDepth: LONGINT;
        id: LONGINT;

BEGIN
  desiredWidth:=width;
  desiredHeight:=height;
  desiredDepth:=depth;
  IF (depth>8) & ~aga & ~ham THEN
    minDepth:=15;
    maxDepth:=32;
    forceAGA:=FALSE;
  ELSE
    minDepth:=depth;
    maxDepth:=8;
    forceAGA:=TRUE;
  END;
  id:=initID;
  scrModeReq:=asl.AllocAslRequestTags(asl.screenModeRequest,u.done);
  IF scrModeReq#NIL THEN
    IF asl.AslRequestTags(scrModeReq,asl.initialDisplayID,initID,
                                     asl.smMinWidth,width,
                                     asl.smMinHeight,height,
                                     asl.smMinDepth,minDepth,
                                     asl.smMaxDepth,maxDepth,
                                     asl.smFilterFunc,smrHook,
                                     IgnoreIfFalse(asl.smPropertyFlags,ham),LONGSET{gfx.isHAM},
                                     IgnoreIfFalse(asl.smPropertyMask,ham),LONGSET{gfx.isHAM},
                                     u.done) THEN
      id:=scrModeReq.displayID;
    END;
    asl.FreeAslRequest(scrModeReq);
  END;
  RETURN id;
END SelectModeIDByReq;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ----------------------- "PROCEDURE CalcModeID()" ------------------------ *)
PROCEDURE CalcModeID * (idStr: ARRAY OF CHAR): LONGINT; (* $CopyArrays- *)

VAR     x: INTEGER;
        max: INTEGER;
        goon: BOOLEAN;
        id: LONGINT;

BEGIN
  id:=0;
  IF (idStr[0]="$") OR ((idStr[0]="0") & (idStr[1]="x")) THEN
    IF idStr[0]="$" THEN
      x:=1;
      max:=9;
    ELSE
      x:=2;
      max:=10;
    END;
    goon:=TRUE;
    WHILE (x<max) & (idStr[x]#00X) & goon DO
      id:=id*16;
      CASE CAP(idStr[x]) OF
      | "0".."9": INC(id,ORD(idStr[x])-ORD("0"));
      | "A".."F": INC(id,ORD(CAP(idStr[x]))-ORD("A")+10);
      ELSE
        id:=0;
        goon:=FALSE;
      END;
      INC(x);
    END;
  END;
  RETURN id;
END CalcModeID;
(* \\\ ------------------------------------------------------------------------- *)

BEGIN
  NEW(smrHook);
  u.InitHook(smrHook,y.VAL(u.HookFunc,SMReqHookFunc));
END BestModeID.

