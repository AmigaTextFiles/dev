|##########|
|#MAGIC   #|GMGLLOFB
|#PROJECT #|"MCCWheelDemo"
|#PATHS   #|"StdProject"
|#LINK    #|""
|#GUIDE   #|""
|#STACK   #|"4096"
|#FLAGS   #|xx---x--xxx-xxx-----------------
|#USERSW  #|--------------------------------
|#USERMASK#|--------------------------------
|#SWITCHES#|xx---xxxxx-xx---
|##########|

(*
**   Cluster Source Code for the MCCWheel Demo Program
**   ------------------------------------------------------
**
**           written 1999 by Henning Thielemann
**
*)

MODULE MCCWheelDemo;

FROM System        AS y   IMPORT SysStringPtr;
FROM Exec                 IMPORT TaskSigSet, Wait;

FROM MuiO                 IMPORT All, MuiPens;
FROM MuiClassface  AS clf IMPORT ClassGrp;
FROM MuiOSimple           IMPORT All;
FROM MCCWheel      AS tbl IMPORT All;

FROM T_Intuition          IMPORT WindowNotOpen;
FROM Intuition     AS I   IMPORT OpSetPtr;
FROM Graphics             IMPORT FontGrp, GfxBasicGrp, LayerGrp, EraseRect;
FROM DiskFont             IMPORT All;

FROM ArithmeticInt        IMPORT Min;

TYPE
  SquareTags = TAGS OF MuiTags;
    squareLeft             = $F9F80220 : LONGINT;           |  V1 .sg
    squareTop              = $F9F80221 : LONGINT;           |  V1 .sg
    squareRotate           = $F9F80222 : LONGINT;           |  V1 .sg
    squareZoom             = $F9F80223 : LONGINT;           |  V1 .sg
  END;

  SquareTagAPtr = POINTER TO SquareTagA;
  SquareTagA    = ARRAY OF SquareTags;

  SquareParameters =
    RECORD
      zoom, rotate,
      left, top : LONGINT;
    END;

  SquareDataPtr = POINTER TO SquareData;
  SquareData =
    RECORD
      cur, last : SquareParameters;
      ratioX, ratioY : REAL;
    END;

PROCEDURE SquareDispatcher (cl : IClassPtr; obj : AreaObject; msg : Msg):ANYPTR;
VAR
  data : SquareDataPtr;

TYPE
  SquareTagPtr = POINTER TO SquareTags;

  PROCEDURE New (REF tags : SquareTags):ANYPTR;
  BEGIN
    obj := NewSuper (cl, obj,
    MOREA : tags'PTR);

    IF obj # NIL THEN
      data := InstData (cl, obj);
    END;

    |WriteFormat ("return obj %lx"+&10, data := ANYPTR (obj));
    RETURN obj;
  END New;

  PROCEDURE AskMinMax (msg : pAskMinMaxPtr):ANYPTR;
  BEGIN
    FORGET DoSuperMethodA (cl, obj, msg);

    WITH msg.minMax AS mm DO
      INC (mm.minWidth,   20);
      INC (mm.defWidth,  120);
      INC (mm.maxWidth,  maxmax);
      INC (mm.minHeight,  10);
      INC (mm.defHeight,  90);
      INC (mm.maxHeight, maxmax);
    END;

    RETURN NIL;
  END AskMinMax;

  PROCEDURE DrawSquare (msg : pDrawPtr):ANYPTR;
  FROM ComplexNumbers IMPORT Pi;
  VAR
    rp          : RastPortPtr;
    clip        : Rectangle;
    result      : ANYPTR;
    size, size1 : REAL;
    dx, dy      : REAL;
    dxx, dyx    : LONGINT;
    dxy, dyy    : LONGINT;
    mx, my      : LONGINT;
    clipHandle  : ClippingHandlePtr;

  BEGIN
    result := DoSuperMethodA (cl,obj,msg);

    rp := obj.mad.renderInfo.rastPort;
    clip.minX := obj.mleft(); clip.maxX := obj.mright();
    clip.minY := obj.mtop();  clip.maxY := obj.mbottom();
    size  := REAL (obj.mwidth())/data.ratioX;
    size1 := REAL (obj.mheight())/data.ratioY;
    IF size1 < size THEN size := size1 END;
    size := size/2;

    IF (drawObject IN msg.flags) OR
       (data.last.zoom   # data.cur.zoom)   OR
       (data.last.rotate # data.cur.rotate) OR
       (data.last.left   # data.cur.left)   OR
       (data.last.top    # data.cur.top)    THEN

      clipHandle := AddClipping (obj.mad.renderInfo, clip.minX, clip.minY, clip.maxX-clip.minX, clip.maxY-clip.minY);
      EraseRect (rp, clip.minX, clip.minY, clip.maxX, clip.maxY);
      dx := size * 2.^(REAL (data.cur.zoom)*0.01) * COS (REAL (data.cur.rotate)*Pi/180);
      dy := size * 2.^(REAL (data.cur.zoom)*0.01) * SIN (REAL (data.cur.rotate)*Pi/180);
      dxx := LONGINT (FLOOR (dx*data.ratioX +0.5));
      dyx := LONGINT (FLOOR (dy*data.ratioX +0.5));
      dxy := LONGINT (FLOOR (dx*data.ratioY +0.5));
      dyy := LONGINT (FLOOR (dy*data.ratioY +0.5));
      mx := (clip.minX + clip.maxX) SHR 1 + data.cur.left;
      my := (clip.minY + clip.maxY) SHR 1 + data.cur.top;
      |WriteFormat ("mx %ld, my %ld, dx %ld, dy %ld"+&10, data := mx, my, dx, dy);
      Move (rp, mx+dxx, my+dyy);
      SetAPen (rp, obj.mad.renderInfo.pens[MuiPens.fill]);
      Draw (rp, mx-dyx, my+dxy);
      SetAPen (rp, obj.mad.renderInfo.pens[MuiPens.text]);
      Draw (rp, mx-dxx, my-dyy);
      Draw (rp, mx+dyx, my-dxy);
      Draw (rp, mx+dxx, my+dyy);
      RemoveClipping (obj.mad.renderInfo, clipHandle); | never skip this!
      data.last := data.cur;
    END;

    RETURN result;
  END DrawSquare;

  PROCEDURE Set (REF tags : SquareTags):ANYPTR;
  VAR
    result : ANYPTR;

  BEGIN
    result := DoSuperMethodA (cl,obj,msg);
    data.cur.zoom   := TGET (tags, squareZoom,   data.cur.zoom);
    data.cur.rotate := TGET (tags, squareRotate, data.cur.rotate);
    data.cur.left   := TGET (tags, squareLeft,   data.cur.left);
    data.cur.top    := TGET (tags, squareTop,    data.cur.top);
    Redraw (obj, {drawUpdate});
    RETURN result;
  END Set;

  PROCEDURE Setup (msg : pSetUpPtr):ANYPTR;
  FROM Graphics IMPORT GetVPModeID, GetDisplayInfoData,
                       DisplayInfo, dtagDisp;
  VAR
    dispInfo   : DisplayInfo;
    dispModeID : LONGCARD;

  BEGIN
    IF DoSuperMethodA (cl, obj, msg) = NIL THEN
      RETURN LONGINT(false);
    ELSE
      dispModeID := GetVPModeID (msg.renderInfo.screen.viewPort'PTR);
      IF GetDisplayInfoData (NIL, dispInfo'PTR, dispInfo'SIZE, CAST (LONGCARD, dtagDisp), dispModeID) > 0 THEN
        data.ratioX := 44. / REAL (dispInfo.resolution.x);
        data.ratioY := 44. / REAL (dispInfo.resolution.y);
      ELSE
        data.ratioX := 1;
        data.ratioY := 1;
      END;
      RETURN LONGINT(true);
    END;
  END Setup;

BEGIN
  data := InstData (cl, obj);
  IF KEY msg.methodId
    OF I.set         THEN RETURN Set          (SquareTagPtr(OpSetPtr(msg).attrList)^) END;
    OF mDraw         THEN RETURN DrawSquare   (msg) END;
    OF mSetup        THEN RETURN Setup        (msg) END;
    OF mAskMinMax    THEN RETURN AskMinMax    (msg) END;
    OF I.new         THEN RETURN New          (SquareTagPtr(OpSetPtr(msg).attrList)^) END;
                     ELSE RETURN DoSuperMethodA (cl, obj, msg);
  END;
END SquareDispatcher;


VAR
  squareMCC : CustomClassPtr;

  app     : ApplicationObject;
  win     : WindowObject;
  grp     : GroupObject;
  whHoriz, whVert,
  whZoom,  whRot : AreaObject;
  square  : AreaObject;

  signal  : TaskSigSet;

BEGIN
  squareMCC := clf.CreateCustomClass (MuiClassDispatcher (SquareDispatcher), SquareData'SIZE, cArea);

  whVert  := MakeWheelObject (wheelHoriz : false, CAST (WheelTags, SliderFrame), cycleChain : 1, numericMin   : -150, numericMax : 150, DONE);
  whHoriz := MakeWheelObject (wheelHoriz : true,  CAST (WheelTags, SliderFrame), cycleChain : 1, numericMin   : -150, numericMax : 150, DONE);
  whRot   := MakeWheelObject (wheelHoriz : false, CAST (WheelTags, SliderFrame), cycleChain : 1, wheelInfinit : true, numericMax : 360, wheelHalfTurns : 2, wheelNotches :  6, wheelNotchWidth : $1000, wheelSlantWidth : $3000, DONE);
  whZoom  := MakeWheelObject (wheelHoriz : true,  CAST (WheelTags, SliderFrame), cycleChain : 1, numericMin   : -200, numericMax : 100, wheelHalfTurns : 3, wheelNotches : 10, wheelNotchWidth : $2000, wheelSlantWidth : $2000, DONE);
  square  := NewCustomObject (squareMCC.class, NIL, ReadListFrame, DONE);

  |vw.NotifyA (MuiTags : numericValue : everyTime, virt, pSet : (methodId = mSet, tag = virtgroupTop  : triggerValue));
  |hw.NotifyA (MuiTags : numericValue : everyTime, virt, pSet : (methodId = mSet, tag = virtgroupLeft : triggerValue));
  WITH pSet AS ps DO
    ps.methodId := mSet;
    CAST (SquareTags, ps.tag) := SquareTags : squareTop    : triggerValue; whVert .NotifyA (MuiTags : numericValue : everyTime, square, ps);
    CAST (SquareTags, ps.tag) := SquareTags : squareLeft   : triggerValue; whHoriz.NotifyA (MuiTags : numericValue : everyTime, square, ps);
    CAST (SquareTags, ps.tag) := SquareTags : squareZoom   : triggerValue; whZoom .NotifyA (MuiTags : numericValue : everyTime, square, ps);
    CAST (SquareTags, ps.tag) := SquareTags : squareRotate : triggerValue; whRot  .NotifyA (MuiTags : numericValue : everyTime, square, ps);
  END;

  grp := MakeColGroup (2,
    groupChild : square,
    groupChild : MakeVGroup (
      groupChild : whRot,
      groupChild : whVert,
      vertWeight : 1900,
    DONE),
    groupChild : MakeHGroup (
      groupChild : whZoom,
      groupChild : whHoriz,
      horizWeight : 1900,
    DONE),
    groupChild : MakeHVSpace (),
  DONE);

  win :=
    MakeWindowObject (
      windowTitle      : "Wheel.mcc demo",
      windowIDChar     : "Main".data,
      windowRootObject : grp,
    DONE);

  app :=
    MakeApplicationObject (
      applicationTitle         : "MCCWheel-Demo",
      applicationVersion       : "$VER: MCCWheel-Demo 1.0 (29.12.1999)",
      applicationCopyright     : "Copyright ©1999, Henning Thielemann",
      applicationAuthor        : "Henning Thielemann",
      applicationDescription   : "Demonstrates the features of Wheel.mcc",
      applicationBase          : "WHEELDEMO",

      applicationWindow        : win,
    DONE);

  AssertMuiError (app # NIL);

  win.Notify (MuiTags : windowCloseRequest : true, notifyApplication, LONGINT (mApplicationReturnID), applicationReturnIDQuit);
  win.Set (MuiTags : windowOpen : true);
  ASSERT (0 # win.GetA (MuiTags : windowOpen : true), WindowNotOpen);

  (* little test
  SetWheelAttrs (whHoriz, wheelNotches : 10, DONE);
  SetWheelAttrs (whVert,  wheelNotchWidth : $2000, DONE);
  SetWheelAttrs (whHoriz, wheelSlantWidth : $2000, DONE);
  SetWheelAttrs (whVert,  wheelBuffered : false, DONE);
  SetWheelAttrs (whHoriz, wheelShinePenSpec  : MuiO.PenSpecPtr("m5".data'PTR), wheelBackgroundPenSpec : MuiO.PenSpecPtr("m7".data'PTR), DONE);
  SetWheelAttrs (whVert,  wheelShadowPenSpec : MuiO.PenSpecPtr("m6".data'PTR), wheelNotchPenSpec      : MuiO.PenSpecPtr("m8".data'PTR), DONE);
  *)

  signal := {};
  WHILE app.NewInput (signal) NOT OF applicationReturnIDQuit DO
    IF signal NOT OF {} THEN signal := Wait(signal) END;
  END;

CLOSE
  IF app      #NIL THEN DisposeObject (app) END;
  IF squareMCC#NIL THEN FORGET DeleteCustomClass (squareMCC) END;

END MCCWheelDemo.
