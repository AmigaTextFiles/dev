|##########|
|#MAGIC   #|GMGMEJCC
|#PROJECT #|"MCCWheelLib"
|#PATHS   #|"StdProject"
|#LINK    #|""
|#GUIDE   #|""
|#STACK   #|"4096"
|#FLAGS   #|xx---x--xxx-xxx-----------------
|#USERSW  #|--------------------------------
|#USERMASK#|--------------------------------
|#SWITCHES#|---x-xxxxx-xx---
|##########|
IMPLEMENTATION MODULE MCCWheelDispatcher;

(*
  29.12.1999 Lemming
   - initial version

  todo
   - find out why GetConfigItem accepts pointer to pointer of LONGCARD here,
     whereas in TableGroup it accepts pointer to LONGCARD

   - bitmaps to be (repeatly mapped) on the wheel
*)


FROM System              IMPORT Regs, Equation;
FROM Exec                IMPORT LibraryPtr;
FROM Utility      AS u   IMPORT FindTagItem, TagItem, TagItemPtr, TagListPtr;

FROM Graphics     AS gfx IMPORT GfxBasicGrp, EraseRect, LayerGrp, BltGrp;
FROM Graphics39          IMPORT BitmapGrp;
FROM Intuition    AS i   IMPORT IDCMPGrp, OpSetPtr;
| seems to be a compiler bug: if you don't import "MuiKeys" explicitly, "wordLeft" won't be recognized, but "up", "down", "left", "right", "pageUp" will
FROM MuiO         AS mui IMPORT All, maxmax, MuiKeys, MuiPens, PenSpecPtr,
                                cNumeric, pHandleEventPtr, mHandleEvent;
FROM MuiClassface AS clf IMPORT ClassGrp;
FROM MCCWheel            IMPORT All;

FROM ArithmeticInt AS a  IMPORT ComparisonGrp;
FROM ComplexNumbers      IMPORT Pi;

$$IF Library THEN
  $$RangeChk    := FALSE
  $$OverflowChk := FALSE
  $$ReturnChk   := FALSE
  $$StrZeroChk  := FALSE
  $$StackChk    := FALSE
  $$NilChk      := FALSE
$$END

LIBRARY u.UtilityBase BY -156
  PROCEDURE UDivMod32 (dividend IN D0 : LONGCARD;
                       divisor  IN D1 : LONGCARD) : LONGCARD;

| I wonder if I should move this to ArithmeticReal.mod
PROCEDURE RealMod (x, y : LONGREAL) : LONGREAL;
BEGIN
  RETURN x - y * FLOOR (x/y);
END RealMod;

PROCEDURE GetPen (pen : LONGINT) : CARDINAL;
BEGIN
  RETURN CAST (LONGCARD, (CAST(LONGSET,pen)*LONGSET:{0..15}));
END GetPen;

PROCEDURE ReleasePenSafe (ri : RenderInfoPtr; VAR pen : LONGINT);
BEGIN
  IF pen#-1 THEN
    ReleasePen (ri, pen);
    pen := -1;
  END;
END ReleasePenSafe;

|FROM Resources IMPORT NotEnoughMemory;  | should not be used, as it causes the linker to link Resources.mod
EXCEPTION
  NotEnoughMemory : "";
  NoSize          : "";

CONST
  LONGCARDMAX = LONGCARD($FFFFFFFF);  | LONGCARD'MAX has the wrong value $7FFFFFFF, compiler bug

TYPE
  MouseModes   = (none, move);

  WheelFlags   = (horiz,             | horizontal direction
                  buffered,
                  hollow,
                  bounceBack,
                  infinit);
  WheelFlagSet = SET OF WheelFlags;

  WheelDataPtr = POINTER TO WheelData;
  WheelData =
    RECORD
      flagsSet, flagsMask,  | which and to which value flags were explicitly set by SetAttrs?
      flags          : WheelFlagSet;
      mode           : MouseModes;
      notchesSet,    notches    : LONGCARD;
      notchWidthSet, notchWidth : LONGCARD;
      slantWidthSet, slantWidth : LONGCARD;
      halfTurns      : LONGCARD;
      shineSpec, shadowSpec, notchSpec,
      backgroundSpec : PenSpecPtr;
      background, notchPen,
      shine, shadow  : LONGINT;
      ehNode         : EventHandlerNode;
      click          : INTEGER;  | the component relevant for the rotation of the mouse position while the first click on the wheel
      lastValue      : LONGINT;  | the value which was set, before mouse click appears
      pixelRatio     : REAL;     | ratio of screen pixel to value unit
      bufferRastPort : RastPort;
    END;

PROCEDURE WheelDispatcher (cl : IClassPtr; obj : AreaObject; msg : Msg):ANYPTR;
VAR
  data : WheelDataPtr;

TYPE
  WheelTagPtr = POINTER TO WheelTags;

  PROCEDURE ParseTags (REF tags : WheelTags);
  VAR
    tag : TagItemPtr;

  BEGIN
    data.backgroundSpec  := TGET (tags, wheelBackgroundPenSpec, data.backgroundSpec);
    data.shineSpec       := TGET (tags, wheelShinePenSpec,      data.shineSpec);
    data.shadowSpec      := TGET (tags, wheelShadowPenSpec,     data.shadowSpec);
    data.notchSpec       := TGET (tags, wheelNotchPenSpec,      data.notchSpec);
    data.notchesSet      := TGET (tags, wheelNotches,           data.notchesSet);
    data.notchWidthSet   := TGET (tags, wheelNotchWidth,        data.notchWidthSet);
    data.slantWidthSet   := TGET (tags, wheelSlantWidth,        data.slantWidthSet);

    tag := FindTagItem (CAST (TagItem, WheelTags : wheelBuffered : false).tag, TagListPtr(tags'PTR));
    IF tag # NIL THEN
      INCL (data.flagsMask, buffered);
      IF tag.data#0 THEN
        INCL (data.flagsSet, buffered);
      ELSE
        EXCL (data.flagsSet, buffered);
      END;
    END;
  END ParseTags;

  PROCEDURE New (REF tags : WheelTags):ANYPTR;
  BEGIN
    obj := NewSuper (cl, obj,
    MOREA : tags'PTR);

    IF obj # NIL THEN
      data := InstData (cl, obj);

      |TRY
        data.notchesSet      := LONGCARDMAX; |  20,   10
        data.notchWidthSet   := LONGCARDMAX; | $40, $800
        data.slantWidthSet   := LONGCARDMAX; | $40, $800
        ParseTags (tags);

        data.halfTurns       := TGET (tags, wheelHalfTurns,     1);
        data.ehNode.priority := TGET (tags, wheelEventPri,      1);
        IF false # TGET (tags, wheelHoriz,    false) THEN INCL (data.flags, horiz)    END;
        IF false # TGET (tags, wheelInfinit,  false) THEN INCL (data.flags, infinit)  END;
        |IF false # TGET (tags, wheelBuffered, true)  THEN INCL (data.flags, buffered) END;
        InitRastPort (data.bufferRastPort);

        | oops, numericDecrease is a method, not a tag
        |obj.NotifyA (MuiTags : numericDecrease : everyTime, notifySelf, pWriteLong:(methodId = mWriteLong, addr = $DFF180, value = triggerValue));

      (*
      EXCEPT
        OF NotEnoughMemory THEN
          FORGET CoerceMethod (cl, obj, LONGINT (i.dispose));
          obj := NIL;
        END;
      END;
      *)
    END;

    |WriteFormat ("return obj %lx"+&10, data := ANYPTR (obj));
    RETURN obj;
  END New;

(*
  PROCEDURE Dispose (msg : Msg):ANYPTR;
  BEGIN
    RETURN DoSuperMethodA (cl,obj,msg);
  END Dispose;
*)

  PROCEDURE Set (msg : OpSetPtr):ANYPTR;
  BEGIN
    ParseTags (WheelTagPtr(msg.attrList)^);
    RETURN DoSuperMethodA (cl,obj,msg);
  END Set;

  PROCEDURE AskMinMax (msg : pAskMinMaxPtr):ANYPTR;
  BEGIN
    FORGET DoSuperMethodA (cl, obj, msg);

    WITH msg.minMax AS mm DO
      INC (mm.maxWidth,  maxmax);
      INC (mm.maxHeight, maxmax);
      IF horiz IN data.flags THEN
        INC (mm.minWidth,   10);
        INC (mm.minHeight,   3);
        INC (mm.defWidth,   60);
        INC (mm.defHeight,  15);
      ELSE
        INC (mm.minWidth,    3);
        INC (mm.minHeight,  10);
        INC (mm.defWidth,   15);
        INC (mm.defHeight,  60);
      END;
    END;

    RETURN NIL;
  END AskMinMax;

  PROCEDURE DrawWheel (rp : RastPortPtr; REF clip : Rectangle);
  VAR
    width : LONGCARD;
    bgPen : CARDINAL;

    PROCEDURE DrawBar (pen : LONGINT; x0, x1 : REAL);
    VAR
      xm, xd : LONGINT;
      d0, d1 : LONGINT;

    BEGIN
      IF bgPen = GetPen(pen) THEN RETURN END;

      xm := LONGINT (FLOOR (x0+x1+0.5));
      xd := LONGINT (CEIL  (x1-x0));
      d0 := (xm-xd) SHR 1;
      d1 := d0 + xd;

      |WriteFormat ("d0 %ld, d1 %ld"+&10, data := d0, d1);
      IF d0<0               THEN d0:=0       END;
      IF d1>=LONGINT(width) THEN d1:=width-1 END;
      IF d0>=d1             THEN RETURN END;

      SetAPen (rp, GetPen(pen));
      IF horiz IN data.flags THEN
        RectFill (rp, clip.minX+d0, clip.minY, clip.minX+d1, clip.maxY);
      ELSE
        RectFill (rp, clip.minX, clip.minY+d0, clip.maxX, clip.minY+d1);
      END;
    END DrawBar;

  VAR
    amp : REAL;

    PROCEDURE CalcX (angle : REAL) : REAL;
    BEGIN
      |RETURN LONGINT (FLOOR (amp * (COS (angle)+1)+0.5));
      RETURN amp * (COS (angle)+1);
    END CalcX;

  VAR
    rad, phi0, phi,
    nphi, sphi         : REAL;
    x00, x01, x10, x11 : REAL;
    n              : LONGCARD;
    val, min, max  : LONGINT;

  BEGIN
    IF horiz IN data.flags THEN
      width := clip.maxX - clip.minX;
    ELSE
      width := clip.maxY - clip.minY;
    END;
    amp  := REAL (width-1)/2;
    rad  := Pi/REAL (data.notches);
    sphi := REAL (data.slantWidth)/$10000;
    nphi := (1-sphi)*REAL (data.notchWidth)/$10000*rad;  | partition space that is left by the two slants
    sphi := sphi * rad/2;
    |nphi := REAL (data.notchWidth)*rad/$10000;
    |sphi := REAL (data.slantWidth)*rad/$20000;

    |EraseRect (rp, clip.minX, clip.minY, clip.maxX, clip.maxY);
    bgPen := GetPen(data.background);
    SetAPen (rp, bgPen);
    RectFill (rp, clip.minX, clip.minY, clip.maxX, clip.maxY);

    min := obj.GetA (MuiTags : numericMin   : 0);
    max := obj.GetA (MuiTags : numericMax   : 0);
    val := obj.GetA (MuiTags : numericValue : 0);
    phi0 := RealMod (Pi * REAL (data.halfTurns) * REAL (val SHL 1-min-max)/2 / REAL (max-min), rad);
    |phi0 := RealMod (Pi * REAL (val SHL 1-min-max)/2 / REAL (max-min), rad);

    FOR n:=0 TO data.notches DO
      phi := REAL(n)*rad - phi0;
      x00 := CalcX (phi     +sphi);
      x01 := CalcX (phi);
      x10 := CalcX (phi-nphi);
      x11 := CalcX (phi-nphi-sphi);
      DrawBar (data.notchPen, x01, x10);
      DrawBar (data.shadow,   x10, x11);
      DrawBar (data.shine,    x00, x01);
    END;

  END DrawWheel;

  PROCEDURE Draw (msg : pDrawPtr):ANYPTR;
  VAR
    clip   : Rectangle;
    result : ANYPTR;

  BEGIN
    result := DoSuperMethodA (cl,obj,msg);

    IF data.bufferRastPort.bitMap#NIL THEN
      clip.minX := 0; clip.maxX := obj.mwidth();
      clip.minY := 0; clip.maxY := obj.mheight();
      DrawWheel (data.bufferRastPort'PTR, clip);
      clip.minX := obj.mleft();
      clip.minY := obj.mtop();
      BltBitMapRastPort (data.bufferRastPort.bitMap, 0, 0,
                         obj.mad.renderInfo.rastPort, clip.minX, clip.minY,
                         clip.maxX, clip.maxY, $C0);
    ELSE
      clip.minX := obj.mleft(); clip.maxX := obj.mright();
      clip.minY := obj.mtop();  clip.maxY := obj.mbottom();
      DrawWheel (obj.mad.renderInfo.rastPort, clip);
    END;

    RETURN result;
  END Draw;

  PROCEDURE Setup (msg : pSetUpPtr):ANYPTR;

    PROCEDURE Recall (id : LONGINT; VAR ptr : ANYPTR) : BOOLEAN;
    BEGIN
      RETURN 0#DOMethod (obj, LONGINT (mui.mGetConfigItem), id, ptr'ADR);
      |FORGET DOMethod (obj, LONGINT (mui.mGetConfigItem), id, ptr'ADR);
      |RETURN FALSE;
    END Recall;

    PROCEDURE RecallLongCard (id : LONGINT; valueSet, valueDefault : LONGCARD) : LONGCARD;
    VAR
      value : POINTER TO LONGINT; | := NIL;
    BEGIN
      IF valueSet # LONGCARDMAX THEN
        RETURN valueSet;
      OR_IF Recall (id, value)  THEN
        RETURN value^;
      ELSE
        RETURN valueDefault;
      END;
    END RecallLongCard;

    PROCEDURE RecallPenSpec (id : LONGINT; specSet : PenSpecPtr; REF specDefault : STRING) : PenSpecPtr;
    VAR
      penspec : PenSpecPtr;

    BEGIN
      IF specSet#NIL THEN
        RETURN specSet;
      OR_IF Recall (id,  penspec) THEN
        RETURN penspec;
      ELSE
        RETURN PenSpecPtr(specDefault.data'PTR);
      END;
    END RecallPenSpec;

  VAR
    bool    : POINTER TO BOOLEAN := NIL;
    |lb      : LONGBOOL;

  BEGIN
    IF DoSuperMethodA (cl, obj, msg) = NIL THEN
      RETURN LONGINT(false);

    ELSE
      data.notches    := Max (1, RecallLongCard (cfgWheelNotches,    data.notchesSet,    defaultNotches));
      data.notchWidth :=         RecallLongCard (cfgWheelNotchWidth, data.notchWidthSet, defaultNotchWidth);
      data.slantWidth :=         RecallLongCard (cfgWheelSlantWidth, data.slantWidthSet, defaultSlantWidth);

      data.background := ObtainPen (obj.mad.renderInfo, RecallPenSpec (cfgWheelBackgroundPen, data.backgroundSpec, "m2"), {});
      data.shine      := ObtainPen (obj.mad.renderInfo, RecallPenSpec (cfgWheelShinePen,      data.shineSpec,      "m1"), {});
      data.shadow     := ObtainPen (obj.mad.renderInfo, RecallPenSpec (cfgWheelShadowPen,     data.shadowSpec,     "m3"), {});
      data.notchPen   := ObtainPen (obj.mad.renderInfo, RecallPenSpec (cfgWheelNotchPen,      data.notchSpec,      "m2"), {});

      data.flags := data.flags - {buffered};
      IF buffered IN data.flagsMask THEN
        UNI (data.flags, data.flagsSet * data.flagsMask);
      OR_IF NOT Recall (cfgWheelBuffered, bool) OR bool^ THEN
        INCL (data.flags, buffered)
      END;

      |lb := buffered IN data.flags;
      |IF false # TGET (tags, wheelBuffered, CAST(CBOOLEAN,lb)) THEN INCL (data.flags, buffered) ELSE EXCL (data.flags, buffered) END;

      data.ehNode.events := {rawKey, mouseButtons};
      data.ehNode.object := obj;
      data.ehNode.class  := cl;
      obj.mad.renderInfo.windowObject.AddEventHandler (data.ehNode);
      RETURN LONGINT(true);
    END;
  END Setup;

  PROCEDURE Cleanup (msg : pSetUpPtr):ANYPTR;
  BEGIN
    obj.mad.renderInfo.windowObject.RemEventHandler (data.ehNode);
    ReleasePenSafe (obj.mad.renderInfo, data.background);
    ReleasePenSafe (obj.mad.renderInfo, data.shine);
    ReleasePenSafe (obj.mad.renderInfo, data.shadow);
    ReleasePenSafe (obj.mad.renderInfo, data.notchPen);

    (* test
    IF data.bufferRastPort.bitMap # NIL THEN
      i.DisplayBeep(NIL);
    END;
    *)

    RETURN DoSuperMethodA (cl,obj,msg);
  END Cleanup;

  PROCEDURE Show (msg : Msg):ANYPTR;
  VAR
    result : ANYPTR;
    width, height,
    size   : LONGCARD;

  BEGIN
    result := DoSuperMethodA (cl, obj, msg);
    width  := obj.mwidth();
    height := obj.mheight();
    IF horiz IN data.flags THEN
      size := width;
    ELSE
      size := height;
    END;
    data.pixelRatio := 2./Pi*
      REAL (obj.GetA (MuiTags : numericMax : 0) - obj.GetA (MuiTags : numericMin : 0)) /
      |(REAL(size));
      (REAL(size)*REAL(data.halfTurns));

    IF buffered IN data.flags THEN
      data.bufferRastPort.bitMap :=
        AllocBitMap (width+1, height+1, obj.mad.renderInfo.rastPort.bitMap.depth,
                     {},                obj.mad.renderInfo.rastPort.bitMap);
    END;

    RETURN result;
  END Show;

  PROCEDURE Hide (msg : Msg):ANYPTR;
  VAR
    result : ANYPTR;

  BEGIN
    result := DoSuperMethodA (cl, obj, msg);

    IF data.bufferRastPort.bitMap # NIL THEN
      WaitBlit();
      FreeBitMap (data.bufferRastPort.bitMap);
      data.bufferRastPort.bitMap := NIL;
    END;

    RETURN result;
  END Hide;

  | necessary because of the negative-numbers-in-enumeration compiler bug
  TYPE
    pHandleEvent    = RECORD OF MsgRoot; imsg : IntuiMessagePtr; muikey : LONGINT END;
    pHandleEventPtr = POINTER TO pHandleEvent;

  PROCEDURE HandleEvent (msg : pHandleEventPtr):EventHandlerResultSet;
  VAR
    result   := EventHandlerResultSet:{};

    PROCEDURE IncreaseValueWrap (step : LONGINT);
    BEGIN
      obj.SetAttrs (numericValue :
        Wrap (obj.GetA (MuiTags : numericValue : 0) + step,
              obj.GetA (MuiTags : numericMin   : 0),
              obj.GetA (MuiTags : numericMax   : 0)), DONE);
      result := {eat};   | keys processed by us neen't to be processed anymore
    END IncreaseValueWrap;

  VAR
    mouseC,
    beginP,
    endP     : INTEGER;
    newValue : LONGINT;

  BEGIN
    IF horiz IN data.flags THEN
      mouseC := msg.imsg.mouseX;
      beginP := obj.mleft();
      endP   := obj.mright();
    ELSE
      mouseC := msg.imsg.mouseY;
      beginP := obj.mtop();
      endP   := obj.mbottom();
    END;

    | in case of infinit we have to work-around the clipping of values by Numeric.mui
    IF (infinit IN data.flags) AND    | (msg.muikey>LONGINT(press)) THEN
       (msg.muikey OF LONGINT (MuiKeys.up)..LONGINT(lineEnd))  | to prevent range violation when converting to the (too short) MuiKeys type
      |WriteFormat ("msg.muikey %ld"+&10, data := msg.muikey);
      AND_IF KEY MuiKeys (msg.muikey)
        OF up,       left      THEN IncreaseValueWrap (- 1) END;
        OF down,     right     THEN IncreaseValueWrap (  1) END;
        OF pageUp,   wordLeft  THEN IncreaseValueWrap (-10) END;
        OF pageDown, wordRight THEN IncreaseValueWrap ( 10) END;
      END
    END;

    IF msg.imsg#NIL
      AND_IF KEY msg.imsg.class
        OF {mouseButtons} THEN

          IF msg.imsg.code=selectDown THEN
            IF IsInObject (obj, msg.imsg.mouseX, msg.imsg.mouseY) THEN
              data.lastValue := obj.GetA (MuiTags : numericValue : 0);
              data.mode      := move;
              data.click     := mouseC;
              Redraw (obj, {drawUpdate});
              obj.mad.renderInfo.windowObject.RemEventHandler (data.ehNode);
              INCL (data.ehNode.events, mouseMove);
              obj.mad.renderInfo.windowObject.AddEventHandler (data.ehNode);
            END;

          OR_IF (msg.imsg.code=selectUp) AND (data.mode NOT OF none) THEN
            data.mode := none;
            obj.mad.renderInfo.windowObject.RemEventHandler (data.ehNode);
            data.ehNode.events := data.ehNode.events - {mouseMove};
            obj.mad.renderInfo.windowObject.AddEventHandler (data.ehNode);
            Redraw (obj, {drawUpdate});
          END;
        END;

        OF {mouseMove} THEN
          IF KEY data.mode
            OF move THEN
              newValue := data.lastValue +
                  LONGINT(FLOOR(REAL (mouseC - data.click) * data.pixelRatio + 0.5));
              IF infinit IN data.flags THEN
                newValue := Wrap (newValue, obj.GetA (MuiTags : numericMin : 0),
                                            obj.GetA (MuiTags : numericMax : 0));
              END;
              obj.SetAttrs (numericValue : newValue, DONE);
            END;
          END;
        END;
      END
    END;

    RETURN result;
  END HandleEvent;

TYPE
  OpGetIntPtr =
    POINTER TO RECORD OF i.MsgRoot
      attrId  : LONGCARD;
      storage : POINTER TO LONGINT;
    END;

  PROCEDURE Get (msg : OpGetIntPtr):LONGINT;
  BEGIN
    |WriteString ("Get: "); WriteCardHex (msg.attrId, 8); WriteLn;
    IF KEY msg.attrId
      OF CAST (TagItem, WheelTags : wheelBackgroundPenSpec : NIL).tag THEN msg.storage^ := ANYPTR(data.backgroundSpec) END;
      OF CAST (TagItem, WheelTags : wheelShinePenSpec      : NIL).tag THEN msg.storage^ := ANYPTR(data.shineSpec)      END;
      OF CAST (TagItem, WheelTags : wheelShadowPenSpec     : NIL).tag THEN msg.storage^ := ANYPTR(data.shadowSpec)     END;
      OF CAST (TagItem, WheelTags : wheelNotchPenSpec      : NIL).tag THEN msg.storage^ := ANYPTR(data.notchSpec)      END;
      OF CAST (TagItem, WheelTags : wheelNotches           :   0).tag THEN msg.storage^ := data.notches         END;
      OF CAST (TagItem, WheelTags : wheelNotchWidth        :   0).tag THEN msg.storage^ := data.notchWidth      END;
      OF CAST (TagItem, WheelTags : wheelSlantWidth        :   0).tag THEN msg.storage^ := data.slantWidth      END;
      OF CAST (TagItem, WheelTags : wheelHalfTurns         :   0).tag THEN msg.storage^ := data.halfTurns       END;
      OF CAST (TagItem, WheelTags : wheelEventPri          :   0).tag THEN msg.storage^ := data.ehNode.priority END;

      OF CAST (TagItem, WheelTags : wheelHoriz    : false).tag THEN WITH BOOLEAN AS b DO b := horiz    IN data.flags; msg.storage^ := -CAST(SHORTINT,b) END; END;
      OF CAST (TagItem, WheelTags : wheelInfinit  : false).tag THEN WITH BOOLEAN AS b DO b := infinit  IN data.flags; msg.storage^ := -CAST(SHORTINT,b) END; END;
      OF CAST (TagItem, WheelTags : wheelBuffered : false).tag THEN WITH BOOLEAN AS b DO b := buffered IN data.flags; msg.storage^ := -CAST(SHORTINT,b) END; END;
    ELSE
      RETURN DoSuperMethodA (cl,obj,msg);
    END;
    RETURN 1;
  END Get;

BEGIN
(*
$$IF NOT Library THEN
WriteFormat ("method %lx"+&10, data := LONGINT (msg.methodId));
$$END
*)
  data := InstData (cl, obj);
  IF KEY msg.methodId
    OF i.set         THEN RETURN Set          (msg) END;
    OF i.get         THEN RETURN Get          (msg) END;
    OF mAskMinMax    THEN RETURN AskMinMax    (msg) END;
    OF mDraw         THEN RETURN Draw         (msg) END;
    OF mHandleEvent  THEN RETURN CAST (ANYPTR, HandleEvent  (msg)) END;
    OF i.new         THEN RETURN New          (WheelTagPtr(OpSetPtr(msg).attrList)^) END;
    |OF i.dispose     THEN RETURN Dispose      (msg) END;
    OF mShow         THEN RETURN Show         (msg) END;
    OF mHide         THEN RETURN Hide         (msg) END;
    OF mSetup        THEN RETURN Setup          (msg) END;
    OF mCleanup      THEN RETURN Cleanup        (msg) END;
                     ELSE RETURN DoSuperMethodA (cl, obj, msg);
  END;
END WheelDispatcher;

BEGIN
  wheelMCC := clf.CreateCustomClass (MuiClassDispatcher (WheelDispatcher), WheelData'SIZE, cNumeric
  $$IF Library THEN
    , base := LibraryPtr (System.OwnLibBase'PTR)
  $$END
  );
  AssertMuiError (#);

CLOSE
  IF wheelMCC # NIL THEN FORGET DeleteCustomClass (wheelMCC) END;
END MCCWheelDispatcher.
