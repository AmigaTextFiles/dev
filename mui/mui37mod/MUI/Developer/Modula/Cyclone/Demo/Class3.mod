MODULE Class3 ;

(*
** Class3.mod by Olaf "Olf" Peters <olf@informatik.uni-bremen.de>
**
** based upon Class3.c by Stefan Stuntz.
**
** Updated Sep 09, 1996 by Olaf Peters
** - changed for new moRedraw() definition (CAST and NIL-check obsolete)
** - changed for new moObtainPen() definition (third parameter)
**
** Updated Feb 07, 1996 by Olaf Peters
** - now uses MuiClassSupport for Classinitialisation
**
** Updated Nov 27, 1995 by Olaf Peters:
**  - does not use MUIOBSOLETE tags any longer
**  - uses "the ideal input loop for an object oriented MUI application"
**      (see MUI_Application.doc/MUIM_Application_NewInput)
*)

(*$ RangeChk- *)

FROM SYSTEM     IMPORT  TAG, ADR, ADDRESS, LONGSET, CAST, SETREG, REG ;
FROM AmigaLib   IMPORT  DoSuperMethodA ;
FROM DosD       IMPORT  ctrlC ;
FROM ExecL      IMPORT  Wait ;

IMPORT
        ed  : ExecD,
        R   : Reg,
        gd  : GraphicsD,
        gl  : GraphicsL,
        id  : IntuitionD,
        il  : IntuitionL,
        m   : MuiD,
        mc  : MuiClasses,
        mcs : MuiClassSupport,
        ml  : MuiL,
        mm  : MuiMacros,
        ms  : MuiSupport,
        ud  : UtilityD,
        ul  : UtilityL ;

(***************************************************************************)
(* Here is the beginning of our new class...                               *)
(***************************************************************************)

(*
** This is the instance data for our custom class.
*)

TYPE
  Data  = RECORD
            x,
            y,
            sx,
            sy : INTEGER ;
          END (* RECORD *) ;

(*
** AskMinMax method will be called before the window is opened
** and before layout takes place. We need to tell MUI the
** minimum, maximum and default size of our object.
*)

(*/// "mAskMinMax(cl : id.IClassPtr; obj : id.ObjectPtr; msg : mc.mpAskMinMaxPtr) : ADDRES" *)

PROCEDURE mAskMinMax(cl : id.IClassPtr; obj : id.ObjectPtr; msg : mc.mpAskMinMaxPtr) : ADDRESS;

BEGIN
  (*
  ** let our superclass first fill in what it thinks about sizes.
  ** this will e.g. add the size of frame and inner spacing.
  *)

  IF DoSuperMethodA(cl, obj, msg) # NIL THEN END ;

  (*
  ** now add the values specific to our object. note that we
  ** indeed need to *add* these values, not just set them!
  *)

  INC(msg^.MinMaxInfo^.MinWidth, 100) ;
  INC(msg^.MinMaxInfo^.DefWidth, 120) ;
  INC(msg^.MinMaxInfo^.MaxWidth, 500) ;

  INC(msg^.MinMaxInfo^.MinHeight, 40) ;
  INC(msg^.MinMaxInfo^.DefHeight, 90) ;
  INC(msg^.MinMaxInfo^.MaxHeight, 300) ;

  RETURN NIL ;
END mAskMinMax ;

(*\\\*)

(*
** Draw method is called whenever MUI feels we should render
** our object. This usually happens after layout is finished
** or when we need to refresh in a simplerefresh window.
** Note: You may only render within the rectangle
**       _mleft(obj), _mtop(obj), _mwidth(obj), _mheight(obj).
*)

(*/// "mDraw(cl : id.IClassPtr; obj : id.ObjectPtr; msg : mc.mpDrawPtr) : ADDRES" *)

PROCEDURE mDraw(cl : id.IClassPtr; obj : id.ObjectPtr; msg : mc.mpDrawPtr) : ADDRESS;

VAR
  data : POINTER TO Data ;

BEGIN
  data := mc.InstData(cl, obj) ;

  (*
  ** let our superclass draw itself first, area class would
  ** e.g. draw the frame and clear the whole region. What
  ** it does exactly depends on msg->flags.
  **
  ** Note: You *must* call the super method prior to do
  ** anything else, otherwise msg->flags will not be set
  ** properly !!!
  *)

  IF DoSuperMethodA(cl, obj, msg) # NIL THEN END ;

  (*
  ** if MADF_DRAWOBJECT isn't set, we shouldn't draw anything.
  ** MUI just wanted to update the frame or something like that.
  *)

  IF mc.drawUpdate IN msg^.flags THEN
    IF (data^.sx # 0) OR (data^.sy # 0) THEN
      gl.SetBPen(mc.OBJ_rp(obj),mc.OBJ_dri(obj)^.pens^[id.shinePen]) ;
      gl.ScrollRaster(mc.OBJ_rp(obj),data^.sx,data^.sy,mc.OBJ_mleft(obj),mc.OBJ_mtop(obj),mc.OBJ_mright(obj),mc.OBJ_mbottom(obj));
      gl.SetBPen(mc.OBJ_rp(obj),0);
      data^.sx := 0;
      data^.sy := 0;
    ELSE
      gl.SetAPen(mc.OBJ_rp(obj),mc.OBJ_dri(obj)^.pens^[id.shadowPen]);
      IF gl.WritePixel(mc.OBJ_rp(obj),data^.x,data^.y) THEN END ;
    END (* IF *) ;
  ELSIF mc.drawObject IN msg^.flags THEN
    gl.SetAPen(mc.OBJ_rp(obj),mc.OBJ_dri(obj)^.pens^[id.shinePen]);
    gl.RectFill(mc.OBJ_rp(obj),mc.OBJ_mleft(obj),mc.OBJ_mtop(obj),mc.OBJ_mright(obj),mc.OBJ_mbottom(obj));
  END (* IF *) ;

  RETURN NIL ;
END mDraw ;

(*\\\*)
(*/// "mSetup(cl : id.IClassPtr; obj : id.ObjectPtr; msg : mc.mpHandleInputPtr) : ADDRES" *)

PROCEDURE mSetup(cl : id.IClassPtr; obj : id.ObjectPtr; msg : mc.mpHandleInputPtr) : ADDRESS;

BEGIN
  IF DoSuperMethodA(cl, obj, msg) = NIL THEN RETURN LONGINT(FALSE) END ;

  ml.moRequestIDCMP(obj,id.IDCMPFlagSet{id.mouseButtons, id.rawKey}) ;
  RETURN LONGINT(ed.LTRUE) ;
END mSetup ;

(*\\\*)
(*/// "mCleanup(cl : id.IClassPtr; obj : id.ObjectPtr; msg : mc.mpHandleInputPtr) : ADDRES" *)

PROCEDURE mCleanup(cl : id.IClassPtr; obj : id.ObjectPtr; msg : mc.mpHandleInputPtr) : ADDRESS;

BEGIN
  ml.moRejectIDCMP(obj,id.IDCMPFlagSet{id.mouseButtons, id.rawKey}) ;

  RETURN DoSuperMethodA(cl, obj, msg) ;
END mCleanup;

(*\\\*)
(*/// "mHandleInput(cl : id.IClassPtr; obj : id.ObjectPtr; msg : mc.mpHandleInputPtr) : ADDRES" *)

PROCEDURE mHandleInput(cl : id.IClassPtr; obj : id.ObjectPtr; msg : mc.mpHandleInputPtr) : ADDRESS;

  PROCEDURE Between(a, x, b : LONGINT) : BOOLEAN ;
  BEGIN
    RETURN (x >= a) AND (x <= b) ;
  END Between ;

  PROCEDURE IsInObject(x, y : LONGINT) : BOOLEAN ;
  BEGIN
    RETURN Between(mc.OBJ_mleft(obj), x, mc.OBJ_mright(obj)) AND Between(mc.OBJ_mtop(obj), y, mc.OBJ_mbottom(obj)) ;
  END IsInObject;

VAR
  data : POINTER TO Data ;

BEGIN
  data := mc.InstData(cl, obj) ;

  IF msg^.muikey # 0 THEN
    CASE msg^.muikey OF
    | mc.MUIKEYLEFT  : data^.sx := -1 ; ml.moRedraw(obj, mc.MADFlagSet{mc.drawUpdate}) ;
    | mc.MUIKEYRIGHT : data^.sx :=  1 ; ml.moRedraw(obj, mc.MADFlagSet{mc.drawUpdate}) ;
    | mc.MUIKEYUP    : data^.sy := -1 ; ml.moRedraw(obj, mc.MADFlagSet{mc.drawUpdate}) ;
    | mc.MUIKEYDOWN  : data^.sy :=  1 ; ml.moRedraw(obj, mc.MADFlagSet{mc.drawUpdate}) ;
    ELSE
    END (* CASE *) ;
  END (* IF *) ;

  IF msg^.imsg # NIL THEN
    IF id.mouseButtons IN msg^.imsg^.class THEN
      IF msg^.imsg^.code = id.selectDown THEN
        IF IsInObject(msg^.imsg^.mouseX, msg^.imsg^.mouseY) THEN
          data^.x := msg^.imsg^.mouseX ;
          data^.y := msg^.imsg^.mouseY ;
          ml.moRedraw(obj, mc.MADFlagSet{mc.drawUpdate}) ;
          ml.moRequestIDCMP(obj, id.IDCMPFlagSet{id.mouseMove}) ;
        END (* IF *) ;
      ELSE
        ml.moRejectIDCMP(obj, id.IDCMPFlagSet{id.mouseMove}) ;
      END (* IF *) ;
    ELSIF id.mouseMove IN msg^.imsg^.class THEN
      IF IsInObject(msg^.imsg^.mouseX, msg^.imsg^.mouseY) THEN
        data^.x := msg^.imsg^.mouseX ;
        data^.y := msg^.imsg^.mouseY ;
        ml.moRedraw(obj, mc.MADFlagSet{mc.drawUpdate}) ;
      END (* IF *) ;
    END (* IF *)
  END (* IF *) ;

  RETURN DoSuperMethodA(cl, obj, msg) ;
END mHandleInput ;

(*\\\*)

(*
** Here comes the dispatcher for our custom class.
** Unknown/unused methods are passed to the superclass immediately.
*)

(*/// "MyDispatcher(cl : id.IClassPtr; obj : ADDRESS; msg : ADDRESS) : ADDRESS" *)

PROCEDURE MyDispatcher(cl : id.IClassPtr; obj : ADDRESS; msg : ADDRESS) : ADDRESS ;

VAR
  mid : LONGCARD ;

BEGIN
  mid := CAST(id.Msg, msg)^.methodID ;

     IF mid = m.mmAskMinMax   THEN RETURN mAskMinMax(cl, obj, msg)
  ELSIF mid = m.mmSetup       THEN RETURN mSetup(cl, obj, msg)
  ELSIF mid = m.mmCleanup     THEN RETURN mCleanup(cl, obj, msg)
  ELSIF mid = m.mmDraw        THEN RETURN mDraw(cl, obj, msg)
  ELSIF mid = m.mmHandleInput THEN RETURN mHandleInput(cl, obj, msg)
  ELSE
    RETURN DoSuperMethodA(cl, obj, msg)
  END (* CASE *) ;
END MyDispatcher ;

(*\\\*)

(***************************************************************************)
(* Thats all there is about it. Now lets see how things are used...        *)
(***************************************************************************)

VAR
  app,
  window,
  grp,
  myObj,
  text     :  id.ObjectPtr ;
  mcc      :  mc.mCustomClassPtr ;
  signals  :  LONGSET ;
  running  : BOOLEAN ;
  myDispatcher : ADDRESS ;
  NULL     : ADDRESS ;

  tags     :  ARRAY [0..31] OF LONGINT ;

BEGIN
  running:= TRUE;
  NULL:= NIL;
  (* Create the new custom class with a call to MUI_CreateCustomClass(). *)
  (* Caution: This function returns not a struct IClass, but a           *)
  (* struct MUI_CustomClass which contains a struct IClass to be         *)
  (* used with NewObject() calls.                                        *)
  (* Note well: MUI creates the dispatcher hook for you, you may         *)
  (* *not* use its h_Data field! If you need custom data, use the        *)
  (* cl_UserData of the IClass structure!                                *)

  IF ml.muiMasterVersion < 11 THEN ms.fail(NULL, "You need MUI 3 to run this demo.") END;

  IF NOT mcs.InitClass(mcc, NIL, ADR(m.mcArea), NIL, SIZE(Data), MyDispatcher) THEN
    ms.fail(NULL, "Could not create custom class.")
  END (* IF *) ;

  mc.MakeDispatcher(MyDispatcher, mcc^.class) ;

  myObj := il.NewObjectA(mcc^.class, NIL, TAG(tags, m.maFrame,       m.mvFrameText,
                                              ud.tagDone)) ;

  text := mm.TextObject(TAG(tags, m.maFrame,        m.mvFrameText,
                                  m.maBackground,   m.miTextBack,
                                  m.maTextContents, ADR("\ecPaint with mouse,\nscroll with cursor keys."),
                            ud.tagDone)) ;

  grp := mm.GroupObject(TAG(tags, m.maGroupHoriz, FALSE,
                                  mm.Child,       text,
                                  mm.Child,       myObj,
                            ud.tagDone)) ;


  window := mm.WindowObject(TAG(tags, m.maWindowTitle, ADR("A rather complex custom class"),
                                      m.maWindowID,    mm.MakeID("CLS3"),
                                      mm.WindowContents, grp,
                                ud.tagDone)) ;
 
  app := mm.ApplicationObject(TAG(tags, m.maApplicationTitle,       ADR("Class3-M2"),
                                        m.maApplicationVersion,     ADR("$VER: Class3-M2 11.1 (22.9.95)"),
                                        m.maApplicationCopyright,   ADR("©1995, Olaf Peters, Stefan Stuntz"),
                                        m.maApplicationAuthor,      ADR("Olaf Peters, Stefan Stuntz"),
                                        m.maApplicationDescription, ADR("Demonstrate the use of custom classes."),
                                        m.maApplicationBase,        ADR("CLASS3M2"),
                                        mm.SubWindow,               window,
                                  ud.tagDone)) ;

  IF app = NIL THEN ms.fail(NULL, "Failed to create Application.") END ;

  mm.set(window,m.maWindowDefaultObject, LONGCARD(myObj)) ;

  mm.NoteClose(app, window, m.mvApplicationReturnIDQuit) ; 


(*
** Input loop...
*)

  mm.set(window, m.maWindowOpen, LONGCARD(ed.LTRUE)) ;

  signals := LONGSET{} ;

  LOOP
    IF ms.DOMethod(app, TAG(tags, m.mmApplicationNewInput, ADR(signals))) = m.mvApplicationReturnIDQuit THEN EXIT END ;

    IF signals # LONGSET{} THEN
      INCL(signals, ctrlC) ;
      signals := Wait(signals) ;
      IF ctrlC IN signals THEN EXIT END ;
    END (* IF *) ;
  END (* WHILE *) ;

  mm.set(window, m.maWindowOpen, LONGCARD(FALSE)) ;


(*
** Shut down...
*)

CLOSE
  IF app # NIL THEN
    ml.mDisposeObject(app) ;
    app := NIL ;
  END (* IF *) ;

  mcs.RemoveClass(mcc) ;
END Class3.
