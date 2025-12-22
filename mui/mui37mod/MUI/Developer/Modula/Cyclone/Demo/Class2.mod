MODULE Class2 ;

(*
** Class2.mod by Olaf "Olf" Peters <olf@informatik.uni-bremen.de>
**
** based upon Class2.c by Stefan Stuntz.
**
** IMPORTANT: RangeChk must be switched off, otherwise you'll get an error
** when entering the Colorwheel-Page!
**
** Updated Sep 09, 1996 by Olaf Peters
** - changed for new moRedraw() definition (CAST and NIL-check obsolete)
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
(* Here is the beginning of our simple new class...                        *)
(***************************************************************************)

(*
** This class is the same as within Class1.c except that it features
** a pen attribute.
*)

TYPE
  LongcardPtr = POINTER TO LONGCARD ;

  Data = RECORD
           penspec   : m.mPenSpec ;
           pen       : ADDRESS;
           penchange : BOOLEAN ;
         END (* RECORD *) ;

CONST
  MyAttrPen = LONGCARD(8022H) ; (* tag value for the new attribute.            *)

(*/// "mNew(cl : id.IClassPtr; obj : id.ObjectPtr; msg : id.OpSetPtr) : ADDRESS" *)

PROCEDURE mNew(cl : id.IClassPtr; obj : id.ObjectPtr; msg : id.OpSetPtr) : ADDRESS ;

VAR
  data  : POINTER TO Data ;
  tag,
  tags  : ud.TagItemPtr ;

BEGIN
  obj := DoSuperMethodA(cl, obj, msg) ;
  IF obj = NIL THEN RETURN NIL END ;

  data := mc.InstData(cl, obj) ;

  (* parse initial taglist *)

  tags := msg^.attrList ;
  tag  := ul.NextTagItem(tags) ;
  WHILE tag # NIL DO
    CASE tag^.tag OF
    | MyAttrPen : IF tag^.data # 0 THEN
                    data^.penspec := CAST(m.mPenSpecPtr, tag^.data)^ ;
                  END (* IF *) ;
    ELSE
    END (* CASE *) ;
    tag := ul.NextTagItem(tags) ;
  END (* WHILE *) ;

  RETURN obj ;
END mNew ;

(*\\\*)
(*/// "mDispose(cl : id.IClassPtr; obj : id.ObjectPtr; msg : ADDRESS) : ADDRESS" *)

PROCEDURE mDispose(cl : id.IClassPtr; obj : id.ObjectPtr; msg : ADDRESS) : ADDRESS ;

BEGIN
  (* OM_NEW didnt allocates something, just do nothing here... *)
  RETURN DoSuperMethodA(cl, obj, msg) ;
END mDispose ;

(*\\\*)

(*
** OM_SET method, we need to see if someone changed the penspec attribute.
*)

(*/// "mSet(cl : id.IClassPtr; obj : id.ObjectPtr; msg : id.OpSetPtr) : ADDRESS" *)

PROCEDURE mSet(cl : id.IClassPtr; obj : id.ObjectPtr; msg : id.OpSetPtr) : ADDRESS ;

VAR
  data : POINTER TO Data ;
  tag,
  tags : ud.TagItemPtr ;

BEGIN
  data := mc.InstData(cl, obj) ;

  tags := msg^.attrList ;
  tag  := ul.NextTagItem(tags) ;
  WHILE tag # NIL DO
    CASE tag^.tag OF
    | MyAttrPen : IF tag^.data # 0 THEN
                    data^.penspec   := CAST(m.mPenSpecPtr, tag^.data)^ ;
                    data^.penchange := TRUE ;
                    ml.moRedraw(obj, mc.MADFlagSet{mc.drawObject}) ;
                  END (* IF *) ;
    ELSE
    END (* CASE *) ;
    tag := ul.NextTagItem(tags) ;
  END (* WHILE *) ;

  RETURN DoSuperMethodA(cl, obj, msg) ;
END mSet ;

(*\\\*)

(*
** OM_GET method, see if someone wants to read the color.
*)

(*/// "mGet(cl : id.IClassPtr; obj : id.ObjectPtr; msg : id.OpGetPtr) : ADDRES" *)

PROCEDURE mGet(cl : id.IClassPtr; obj : id.ObjectPtr; msg : id.OpGetPtr) : ADDRESS;

VAR
  data  : POINTER TO Data ;
  store : LongcardPtr ;

BEGIN
  data := mc.InstData(cl, obj) ;
  store := CAST(LongcardPtr, msg^.storage) ;

  CASE msg^.attrID OF
  | MyAttrPen : store^ := ADR(data^.penspec) ;
                RETURN LONGCARD(ed.LTRUE) ;
  ELSE
    RETURN DoSuperMethodA(cl, obj, msg) ;
  END (* CASE *) ;
END mGet ;

(*\\\*)
(*/// "mSetup(cl : id.IClassPtr; obj : id.ObjectPtr; msg : id.OpSetPtr) : ADDRES" *)

PROCEDURE mSetup(cl : id.IClassPtr; obj : id.ObjectPtr; msg : id.OpSetPtr) : ADDRESS;

VAR
  data : POINTER TO Data ;
  test : ADDRESS ;

BEGIN
  data := mc.InstData(cl, obj) ;

  IF DoSuperMethodA(cl, obj, msg) = NIL THEN
    RETURN LONGCARD(FALSE) ;
  END (* IF *) ;

  test := mc.muiRenderInfo(obj) ;
  data^.pen := ml.moObtainPen(mc.muiRenderInfo(obj), ADR(data^.penspec), NIL) ;

  RETURN LONGCARD(ed.LTRUE) ;
END mSetup ;     

(*\\\*)
(*/// "mCleanup(cl : id.IClassPtr; obj : id.ObjectPtr; msg : id.OpSetPtr) : ADDRES" *)

PROCEDURE mCleanup(cl : id.IClassPtr; obj : id.ObjectPtr; msg : id.OpSetPtr) : ADDRESS;

VAR
  data :POINTER TO Data ;

BEGIN
  data := mc.InstData(cl, obj) ;
  ml.moReleasePen(mc.muiRenderInfo(obj), data^.pen) ;
  RETURN DoSuperMethodA(cl, obj, msg) ;
END mCleanup ;

(*\\\*)
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

(*/// "mDraw(cl : id.IClassPtr; obj : id.ObjectPtr; msg : mc.mpDraw) : ADDRES" *)

PROCEDURE mDraw(cl : id.IClassPtr; obj : id.ObjectPtr; msg : mc.mpDrawPtr) : ADDRESS;

VAR
  data : POINTER TO Data ;
  i    : INTEGER ;

BEGIN
  data := mc.InstData(cl, obj) ;

  (*
  ** let our superclass draw itself first, area class would
  ** e.g. draw the frame and clear the whole region. What
  ** it does exactly depends on msg->flags.
  *)

  IF DoSuperMethodA(cl, obj, msg) # NIL THEN END ;

  (*
  ** if MADF_DRAWOBJECT isn't set, we shouldn't draw anything.
  ** MUI just wanted to update the frame or something like that.
  *)

  IF NOT (mc.drawObject IN msg^.flags) THEN RETURN NIL END ;

  (*
  ** test if someone changed our pen
  *)

  IF data^.penchange THEN
    data^.penchange := FALSE ;
    ml.moReleasePen(mc.muiRenderInfo(obj), data^.pen) ;
    data^.pen := ml.moObtainPen(mc.muiRenderInfo(obj), ADR(data^.penspec), NIL) ;
  END (* IF *) ;

  (*
  ** ok, everything ready to render...
  ** Note that we *must* use the MUIPEN() macro before actually
  ** using pens from MUI_ObtainPen() in rendering calls.
  *)

  gl.SetAPen(mc.OBJ_rp(obj),mc.muiPen(data^.pen));

  FOR i := mc.OBJ_mleft(obj) TO mc.OBJ_mright(obj) BY 5 DO
    gl.Move(mc.OBJ_rp(obj),mc.OBJ_mleft(obj),mc.OBJ_mtop(obj));
    gl.Draw(mc.OBJ_rp(obj),i,mc.OBJ_mbottom(obj));
    gl.Move(mc.OBJ_rp(obj),mc.OBJ_mright(obj),mc.OBJ_mtop(obj));
    gl.Draw(mc.OBJ_rp(obj),i,mc.OBJ_mbottom(obj));
  END (* FOR *) ;

  RETURN NIL ;
END mDraw ;

(*\\\*)

(*
** Here comes the dispatcher for our custom class. We only need to
** care about MUIM_AskMinMax and MUIM_Draw in this simple case.
** Unknown/unused methods are passed to the superclass immediately.
*)

(*/// "MyDispatcher(cl : id.IClassPtr; obj : ADDRESS; msg : ADDRESS) : ADDRESS" *)

PROCEDURE MyDispatcher(cl : id.IClassPtr; obj : ADDRESS; msg : ADDRESS) : ADDRESS ;

VAR
  mid : LONGCARD ;

BEGIN
  mid := CAST(id.Msg, msg)^.methodID ;

     IF mid = id.omNEW      THEN RETURN mNew(cl, obj, msg)
  ELSIF mid = id.omDISPOSE  THEN RETURN mDispose(cl, obj, msg)
  ELSIF mid = id.omSET      THEN RETURN mSet(cl, obj, msg)
  ELSIF mid = id.omGET      THEN RETURN mGet(cl, obj, msg)
  ELSIF mid = m.mmAskMinMax THEN RETURN mAskMinMax(cl, obj, msg)
  ELSIF mid = m.mmSetup     THEN RETURN mSetup(cl, obj, msg)
  ELSIF mid = m.mmCleanup   THEN RETURN mCleanup(cl, obj, msg)
  ELSIF mid = m.mmDraw      THEN RETURN mDraw(cl, obj, msg)
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
  pen      : id.ObjectPtr ;
  mcc      : mc.mCustomClassPtr ;
  signals  : LONGSET ;
  startpen : m.mPenSpecPtr ;
  NULL     : ADDRESS;

  tags     : ARRAY [0..31] OF LONGINT ;
  tags1    : ARRAY [0..9]  OF LONGINT ;

BEGIN
  NULL:= NIL;
  (* Create the new custom class with a call to MUI_CreateCustomClass(). *)
  (* Caution: This function returns not a struct IClass, but a           *)
  (* struct MUI_CustomClass which contains a struct IClass to be         *)
  (* used with NewObject() calls.                                        *)
  (* Note well: MUI creates the dispatcher hook for you, you may         *)
  (* *not* use its h_Data field! If you need custom data, use the        *)
  (* cl_UserData of the IClass structure!                                *)

  IF ml.muiMasterVersion < 12 THEN ms.fail(NULL, "You need MUI 3.1 to run this demo.") END;

  IF NOT mcs.InitClass(mcc, NIL, ADR(m.mcArea), NIL, SIZE(Data), MyDispatcher) THEN
    ms.fail(NULL, "Could not create custom class.")
  END (* IF *) ;

  pen := mm.PoppenObject(TAG(tags, m.maCycleChain, ed.LTRUE,
                                   m.maWindowTitle, ADR("Custom Class Color"),
                             ud.tagDone)) ;

  myObj := il.NewObjectA(mcc^.class, NIL, TAG(tags, m.maFrame,      m.mvFrameText,
                                                    m.maBackground, m.miBACKGROUND,
                                              ud.tagDone)) ;

  grp := mm.GroupObject(TAG(tags, m.maGroupHoriz,  FALSE,
                                  mm.Child,        mm.TextObject(TAG(tags1, m.maFrame, m.mvFrameText,
                                                                            m.maBackground, m.miTextBack,
                                                                            m.maTextContents, ADR("\ecThis is a custom class with attributes.\nClick on the button at the bottom of\nthe window to adjust the color."),
                                                                     ud.tagDone)),
                                  mm.Child,        myObj,
                                  mm.Child,        mm.GroupObject(TAG(tags1, m.maWeight, 10,
                                                                             m.maGroupHoriz, ed.LTRUE,
                                                                             mm.Child, mm.FreeLabel(ADR("Custom Class Color:")),
                                                                             mm.Child, pen,
                                                                      ud.tagDone)),

                            ud.tagDone)) ;

  window := mm.WindowObject(TAG(tags, m.maWindowTitle, ADR("Another Custom Class"),
                                      m.maWindowID,    mm.MakeID("CLS2"),
                                      mm.WindowContents, grp,
                                ud.tagDone)) ;

  app := mm.ApplicationObject(TAG(tags, m.maApplicationTitle,       ADR("Class2-M2"),
                                        m.maApplicationVersion,     ADR("$VER: Class2-M2 11.1 (21.9.95)"),
                                        m.maApplicationCopyright,   ADR("©1995, Olaf Peters, Stefan Stuntz"),
                                        m.maApplicationAuthor,      ADR("Olaf Peters, Stefan Stuntz"),
                                        m.maApplicationDescription, ADR("Demonstrate the use of custom classes."),
                                        m.maApplicationBase,        ADR("CLASS2M2"),
                                        mm.SubWindow,               window,
                                  ud.tagDone)) ;

  IF app = NIL THEN ms.fail(NULL, "Failed to create Application.") END ;

  mm.NoteClose(app, window, m.mvApplicationReturnIDQuit) ;

  ms.DoMethod(pen,TAG(tags, m.mmNotify, m.maPendisplaySpec, m.mvEveryTime,
                         myObj, 3, m.mmSet, MyAttrPen, m.mvTriggerValue,
                   ud.tagDone));

  mm.get(pen, m.maPendisplaySpec, ADR(startpen)) ;
  mm.set(myObj, MyAttrPen, LONGCARD(startpen)) ;

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
END Class2.
