|##########|
|#MAGIC   #|GMGMEPJP
|#PROJECT #|"MCPWheelLib"
|#PATHS   #|"StdProject"
|#LINK    #|""
|#GUIDE   #|""
|#STACK   #|"4096"
|#FLAGS   #|xx---x--xxx-xxx-x---------------
|#USERSW  #|--------------------------------
|#USERMASK#|--------------------------------
|#SWITCHES#|---x-xxxxx-xx---
|##########|
IMPLEMENTATION MODULE MCPWheelDispatcher;

(*
  09.01.2000 Lemming
   - initial version

  todo
   - image for wheel entry in MUI prefs
*)


IMPORT System;
FROM Exec                IMPORT LibraryPtr;

FROM Intuition    AS i   IMPORT OpSetPtr;
FROM MuiO         AS mui IMPORT All, MuiPens;
FROM MuiOSimple          IMPORT All;
FROM MuiClassface AS clf IMPORT ClassGrp;
FROM MCCWheel            IMPORT All;
FROM MCCWheelDispatcher  IMPORT ConfigGrp;

FROM ArithmeticInt AS a  IMPORT ComparisonGrp;

$$IF Library THEN
  $$RangeChk    := FALSE
  $$OverflowChk := FALSE
  $$ReturnChk   := FALSE
  $$StrZeroChk  := FALSE
  $$StackChk    := FALSE
  $$NilChk      := FALSE
$$END

TYPE
  DataspaceRec    = RECORD OF ObjectRec; END;
  DataspaceObject = POINTER TO DataspaceRec;

METHOD Find (dataspace : DataspaceObject; id : LONGINT) : ANYPTR;
BEGIN
  RETURN DOMethod (dataspace, LONGINT(mui.mDataspaceFind), id);
END Find;

METHOD Add (dataspace : DataspaceObject; ptr : ANYPTR; size : LONGINT);
BEGIN
  DoMethod (dataspace, LONGINT(mui.mDataspaceAdd), ptr, size);
END Add;

VAR
  percentSliderMCC : CustomClassPtr;

TYPE
  PercentSliderDataPtr = POINTER TO PercentSliderData;
  PercentSliderData    = RECORD
                           str : STRING(15);
                         END;

PROCEDURE PercentSliderDispatcher (cl : IClassPtr; obj : AreaObject; msg : Msg):ANYPTR;
VAR
  data : PercentSliderDataPtr;

TYPE
  WheelTagPtr = POINTER TO WheelTags;
  pNumericStringifyPtr = POINTER TO mui.pNumericStringify;

  PROCEDURE Stringify (msg : pNumericStringifyPtr):ANYPTR;
  FROM Conversions IMPORT IntToString;
  VAR
    val  : LONGINT;
    frac : LONGINT;
  BEGIN
    val  := Limit (msg.value, 0, $10000) * 1000 SHR 16;
    frac := val MOD 10;
    val  := val DIV 10;
    data.str := IntToString (val);
    data.str.data[data.str.len]   := ".";
    data.str.data[data.str.len+1] := CHAR(SHORTCARD("0")+frac);
    data.str.data[data.str.len+2] := "%";
    data.str.data[data.str.len+3] := &0;
    INC (data.str.len,4); | superfluous as I think
    RETURN data.str.data'PTR;
  END Stringify;

BEGIN
  data := InstData (cl, obj);
  IF KEY msg.methodId
    OF mui.mNumericStringify THEN RETURN Stringify (msg) END;
                             ELSE RETURN DoSuperMethodA (cl, obj, msg);
  END;
END PercentSliderDispatcher;

TYPE
  WheelDataPtr = POINTER TO WheelData;
  WheelData =
    RECORD
      slNotches,  slNotchWidth, slSlantWidth    : AreaObject;
      coShinePen, coShadowPen,  coBackgroundPen,
      coNotchPen                                : AreaObject;
      chBuffered                                : AreaObject;
    END;

PROCEDURE WheelDispatcher (cl : IClassPtr; obj : AreaObject; msg : Msg):ANYPTR;
VAR
  data : WheelDataPtr;

TYPE
  WheelTagPtr = POINTER TO WheelTags;

  PROCEDURE New (REF tags : WheelTags):ANYPTR;
  VAR
    newData : WheelData;
  BEGIN
    newData.slNotches       := MakeSlider (1, 100, defaultNotches, cycleChain : 1, DONE);
    newData.slNotchWidth    := NewCustomObject (percentSliderMCC.class, NIL, numericMin : 0, numericMax : $10000, numericValue : defaultNotchWidth, cycleChain : 1, DONE);
    newData.slSlantWidth    := NewCustomObject (percentSliderMCC.class, NIL, numericMin : 0, numericMax : $10000, numericValue : defaultSlantWidth, cycleChain : 1, DONE);
    newData.coBackgroundPen := NewObject (cPoppen, windowTitle : "shine pen",  cycleChain : 1, DONE);
    newData.coShinePen      := NewObject (cPoppen, windowTitle : "shine pen",  cycleChain : 1, DONE);
    newData.coShadowPen     := NewObject (cPoppen, windowTitle : "shadow pen", cycleChain : 1, DONE);
    newData.coNotchPen      := NewObject (cPoppen, windowTitle : "notch pen",  cycleChain : 1, DONE);
    newData.chBuffered      := MakeCheckMark (true, cycleChain : 1, DONE);

    obj := NewSuper (cl, obj,
      groupChild : MakeHVSpace(),
      groupChild : MakeColGroup (2,
        |groupColumns : 2,
        groupChild : MakeLabel ("Notches"),
        groupChild : newData.slNotches,
        groupChild : MakeLabel ("Notch width"),
        |groupChild : MakeSlider (0, $10000, $500, DONE),
        groupChild : newData.slNotchWidth,
        groupChild : MakeLabel ("Slant width"),
        |groupChild : MakeSlider (0, $10000, $500, DONE),
        groupChild : newData.slSlantWidth,
        groupChild : MakeLabel ("Background"),
        groupChild : newData.coBackgroundPen,
        groupChild : MakeLabel ("Shine"),
        groupChild : newData.coShinePen,
        groupChild : MakeLabel ("Shadow"),
        groupChild : newData.coShadowPen,
        groupChild : MakeLabel ("Notch"),
        groupChild : newData.coNotchPen,
        groupChild : MakeLabel ("Buffered"),
        groupChild : MakeHCenterObject (newData.chBuffered),
      DONE),
      groupChild : MakeHVSpace(),
      groupChild : MakeTextObject (
        TextFrame,
        textContents : &27+"c"+
                       "Wheel.mcc 19.00 (26.01.2000)"+&10+
                       "Copyright 2000 Henning Thielemann"+&10+
                       "http://home.pages.de/~lemming",
      DONE),
    MOREA : tags'PTR);

    IF obj # NIL THEN
      data := InstData (cl, obj);
      data^ := newData;

      DoMethod (data.coBackgroundPen, LONGINT(mui.mPendisplaySetMUIPen), LONGINT(MuiPens.background));
      DoMethod (data.coShinePen,      LONGINT(mui.mPendisplaySetMUIPen), LONGINT(MuiPens.halfshine));
      DoMethod (data.coShadowPen,     LONGINT(mui.mPendisplaySetMUIPen), LONGINT(MuiPens.halfshadow));
      DoMethod (data.coNotchPen,      LONGINT(mui.mPendisplaySetMUIPen), LONGINT(MuiPens.background));
    END;

    RETURN obj;
  END New;

(*
  PROCEDURE Dispose (msg : Msg):ANYPTR;
  BEGIN
    RETURN DoSuperMethodA (cl,obj,msg);
  END Dispose;
*)

  PROCEDURE ConfigToGadgets (msg : mui.pSettingsgroupConfigToGadgetsPtr):ANYPTR;

    PROCEDURE Recall (id : LONGINT) : ANYPTR;
    BEGIN
      RETURN DOMethod (msg.configdata, LONGINT (mui.mDataspaceFind), id);
    END Recall;

  VAR
    penspec : mui.PenSpecPtr;
    value   : POINTER TO LONGINT;
    bool    : POINTER TO SHORTINT;

  BEGIN
    value   := Recall (cfgWheelNotches);
    IF # THEN data.slNotches      .SetAttrs (numericValue : value^, DONE) END;
    value   := Recall (cfgWheelNotchWidth);
    IF # THEN data.slNotchWidth   .SetAttrs (numericValue : value^, DONE) END;
    value   := Recall (cfgWheelSlantWidth);
    IF # THEN data.slSlantWidth   .SetAttrs (numericValue : value^, DONE) END;
    penspec := Recall (cfgWheelBackgroundPen);
    IF # THEN data.coBackgroundPen.SetAttrs (pendisplaySpec : penspec, DONE) END;
    penspec := Recall (cfgWheelShinePen);
    IF # THEN data.coShinePen     .SetAttrs (pendisplaySpec : penspec, DONE) END;
    penspec := Recall (cfgWheelShadowPen);
    IF # THEN data.coShadowPen    .SetAttrs (pendisplaySpec : penspec, DONE) END;
    penspec := Recall (cfgWheelNotchPen);
    IF # THEN data.coNotchPen     .SetAttrs (pendisplaySpec : penspec, DONE) END;
    bool    := Recall (cfgWheelBuffered);
    IF # THEN data.chBuffered     .SetAttrs (selected : CBOOLEAN(bool^), DONE) END;

    RETURN 0;
  END ConfigToGadgets;

  PROCEDURE GadgetsToConfig (msg : mui.pSettingsgroupGadgetsToConfigPtr):ANYPTR;

    PROCEDURE Store (VAR data : ANYTYPE; id : LONGINT);
    BEGIN
      IF data'PTR#NIL THEN  | only possible, because NILChk is disabled
        DoMethod (msg.configdata, LONGINT (mui.mDataspaceAdd), data'ADR, data'SIZE, id);
      END;
    END Store;

  VAR
    penspec : mui.PenSpecPtr;
    value   : LONGINT;
    bool    : BOOLEAN;

  BEGIN
    value := data.slNotches.GetA (MuiTags : numericValue : 0);
    Store (value, cfgWheelNotches);
    value := data.slNotchWidth.GetA (MuiTags : numericValue : 0);
    Store (value, cfgWheelNotchWidth);
    value := data.slSlantWidth.GetA (MuiTags : numericValue : 0);
    Store (value, cfgWheelSlantWidth);
    penspec := ANYPTR (data.coBackgroundPen.GetA (MuiTags : pendisplaySpec : NIL));
    Store (penspec^, cfgWheelBackgroundPen);
    penspec := ANYPTR (data.coShinePen     .GetA (MuiTags : pendisplaySpec : NIL));
    Store (penspec^, cfgWheelShinePen);
    penspec := ANYPTR (data.coShadowPen    .GetA (MuiTags : pendisplaySpec : NIL));
    Store (penspec^, cfgWheelShadowPen);
    penspec := ANYPTR (data.coNotchPen     .GetA (MuiTags : pendisplaySpec : NIL));
    Store (penspec^, cfgWheelNotchPen);
    bool := 0#data.chBuffered.GetA (MuiTags : selected : false);
    Store (bool, cfgWheelBuffered);

    RETURN 0;
  END GadgetsToConfig;

BEGIN
  data := InstData (cl, obj);
  IF KEY msg.methodId
    OF i.new          THEN RETURN New          (WheelTagPtr(OpSetPtr(msg).attrList)^) END;
    |OF i.dispose     THEN RETURN Dispose      (msg) END;
    OF mui.mSettingsgroupConfigToGadgets THEN RETURN ConfigToGadgets (msg) END;
    OF mui.mSettingsgroupGadgetsToConfig THEN RETURN GadgetsToConfig (msg) END;
                      ELSE RETURN DoSuperMethodA (cl, obj, msg);
  END;
END WheelDispatcher;

BEGIN
  wheelMCP := clf.CreateCustomClass (MuiClassDispatcher (WheelDispatcher), WheelData'SIZE, "Mccprefs.mui", |"Settingsgroup.mui",
    base := LibraryPtr (System.OwnLibBase'PTR));
  AssertMuiError (#);

  | don't pass library base here!
  percentSliderMCC := clf.CreateCustomClass (MuiClassDispatcher (PercentSliderDispatcher), PercentSliderData'SIZE, cSlider);
  AssertMuiError (#);

CLOSE
  IF         wheelMCP # NIL THEN FORGET DeleteCustomClass         (wheelMCP) END;
  IF percentSliderMCC # NIL THEN FORGET DeleteCustomClass (percentSliderMCC) END;
END MCPWheelDispatcher.
