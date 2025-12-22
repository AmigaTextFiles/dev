MODULE Class1;

IMPORT
  m := Mui,
  mb := MuiBasics,
  u := Utility,
  I := Intuition,
  y := SYSTEM,
  e := Exec,
  g := Graphics,
  clf := Classface, (* IF you use V40 Interface *)
(*  clf := Boopsi, *)
  demo;

(***************************************************************************)
(* Here is the beginning of our simple new class...                        *)
(***************************************************************************)

(*
** This is an example for the simplest possible MUI class. It's just some
** kind of custom image and supports only two methods: 
** MUIM_AskMinMax and MUIM_Draw.
*)

(*
** This is the instance data for our custom class.
** Since it's a very simple class, it contains just a dummy entry.
*)

TYPE
  MyData = STRUCT;
             dummy : LONGINT;
           END;

(*
** AskMinMax method will be called before the window is opened
** and before layout takes place. We need to tell MUI the
** minimum, maximum and default size of our object.
*)


  PROCEDURE AskMinMax(cl: I.IClassPtr; obj: m.Object; msg: I.MsgPtr ):e.APTR;

    BEGIN
      (*
      ** let our superclass first fill in what it thinks about sizes.
      ** this will e.g. add the size of frame and inner spacing.
      *)

      IF clf.DoSuperMethodA( cl, obj, msg^ ) = NIL THEN END;

      (*
      ** now add the values specific to our object. note that we
      ** indeed need to *add* these values, not just set them!
      *)

      INC( msg(m.pAskMinMax).minMax.minWidth, 100 );
      INC( msg(m.pAskMinMax).minMax.defWidth, 120 );
      INC( msg(m.pAskMinMax).minMax.maxWidth, 500 );
      INC( msg(m.pAskMinMax).minMax.minHeight, 40 );
      INC( msg(m.pAskMinMax).minMax.defHeight, 90 );
      INC( msg(m.pAskMinMax).minMax.maxHeight,300 );

      RETURN NIL;
   END AskMinMax;


(*
** Draw method is called whenever MUI feels we should render
** our object. This usually happens after layout is finished
** or when we need to refresh in a simplerefresh window.
** Note: You may only render within the rectangle
**       _mleft(obj), _mtop(obj), _mwidth(obj), _mheight(obj).
*)

  PROCEDURE Draw(cl: I.IClassPtr; obj: m.Object; msg: I.MsgPtr ):e.APTR;
    VAR i : INTEGER;
    BEGIN

        (*
        ** let our superclass draw itself first, area class would
        ** e.g. draw the frame and clear the whole region. What
        ** it does exactly depends on msg->flags.
        *)

        IF clf.DoSuperMethodA( cl, obj, msg^ ) = NIL THEN END;

        (*
        ** if MADF_DRAWOBJECT isn't set, we shouldn't draw anything.
        ** MUI just wanted to update the frame or something like that.
        *)

        IF ~ (m.adfDrawobject IN msg(m.pDraw).flags) THEN
          RETURN 0;
        END;

        (*
        ** ok, everything ready to render...
        *)

        g.SetAPen( m.rp(obj), m.dri(obj).pens[I.textPen] );


        FOR i := m.mleft(obj) TO m.mright(obj) BY 5 DO
          g.Move(m.rp(obj), m.mleft(obj),m.mbottom(obj));
          g.Draw(m.rp(obj),i, m.mtop(obj));
          g.Move(m.rp(obj),m.mright(obj),m.mbottom(obj));
          g.Draw(m.rp(obj),i, m.mtop(obj));
        END;
        RETURN NIL;
    END Draw;


(*
** Here comes the dispatcher for our custom class. We only need to
** care about MUIM_AskMinMax and MUIM_Draw in this simple case.
** Unknown/unused methods are passed to the superclass immediately.
*)

  PROCEDURE MyDispatcher (cl: I.IClassPtr; obj: m.Object; msg: I.MsgPtr):e.APTR;
    BEGIN
      CASE msg.methodID OF
        | m.mAskMinMax : RETURN( AskMinMax(cl, obj, msg ) );
        | m.mDraw      : RETURN( Draw     (cl, obj, msg ) );
      ELSE;
        RETURN clf.DoSuperMethodA( cl, obj, msg^ );
      END;
    END MyDispatcher;



(***************************************************************************)
(* Thats all there is about it. Now lets see how things are used...        *)
(***************************************************************************)

  VAR app, window, MyObj : m.Object;
      MyClass, SuperClass : I.IClassPtr;
      signals : LONGSET;
      running : BOOLEAN;

CONST class1Id = y.VAL( LONGINT, "CLS1" );

BEGIN
  running := TRUE;

        (* Get a pointer to the superclass. MUI will lock this *)
        (* and prevent it from being flushed during you hold   *)
        (* the pointer. When you're done, you have to call     *)
        (* MUI_FreeClass() to release this lock.               *)

        SuperClass := m.GetClass( m.cArea );
        IF SuperClass = NIL THEN
          demo.fail( NIL, "Superclass for the new class not found." );
        END;

        (* create the new class *)
        MyClass := I.MakeClass( NIL, NIL, SuperClass, SIZE( MyData ), LONGSET{0} );
        IF MyClass = NIL THEN
          m.FreeClass( SuperClass );
          demo.fail ( NIL, "Failed to create class" );
        END;

        (* set the dispatcher for the new class *)
        u.InitHook( MyClass, y.VAL( u.HookFunc, MyDispatcher ) );

        mb.ApplicationObject( m.aApplicationTitle      , y.ADR( "Class1" ),
                              m.aApplicationVersion    , y.ADR( "$VER: Class1 1.0 (01.12.93)" ),
                              m.aApplicationCopyright  , y.ADR( "©1993, Stefan Stuntz" ),
                              m.aApplicationAuthor     , y.ADR( "Stefan Stuntz, Oberon: Albert Weinert" ),
                              m.aApplicationDescription, y.ADR( "Demonstrate the use of custom classes. Oberon Version" ),
                              m.aApplicationBase       , y.ADR( "CLASS1" ), u.end );

          mb.SubWindow; mb.WindowObject( m.aWindowTitle, y.ADR( "A Simple Custom Class") ,
                                         m.aWindowID   , class1Id, u.end );
                          mb.WindowContents; mb.VGroup;
                                               mb.Child; mb.INewObject( MyClass, NIL );
                                                            mb.TextFrame;
                                                            mb.TagItem( m.aBackground, m.iBACKGROUND );
                                                         MyObj := mb.IEnd();
                                             mb.end;
                        window := mb.End();
        app := mb.EndApplication();

        IF app = NIL THEN
                demo.fail(app,"Failed to create Application.");
        END;
        m.DoMethod( window,m.mNotify,m.aWindowCloseRequest,e.true,
                     app,2,m.mApplicationReturnID,m.vApplicationReturnIDQuit);



(*
** Input loop...
*)

    mb.Set(window,m.aWindowOpen,e.LTRUE);

  running := TRUE;
  WHILE running DO
    CASE m.DOMethod( app, m.mApplicationInput, y.ADR(signals), u.end ) OF
      | m.vApplicationReturnIDQuit :
          running := FALSE;
    ELSE END;
    IF (running) & (signals # LONGSET{}) THEN y.SETREG( 0, e.Wait(signals) ) END;
  END;
  mb.Set(window,m.aWindowOpen,I.LFALSE);


(*
** Shut down...
*)

        m.DisposeObject(app);      (* dispose all objects. *)
        IF I.FreeClass(MyClass) THEN END;          (* free our custom class. *)
        m.FreeClass(SuperClass);  (* release super class pointer. *)
        demo.fail( NIL, "");             (* exit, app is already disposed. *)
END Class1.
