MODULE BguiDemo;

(*
 * BGUIDEMO.C
 *
 * (C) Copyright 1995 Jaba Development.
 * (C) Copyright 1995 Jan van den Baard.
 *     All Rights Reserved.
 *
 *     Oberon Conversion - Larry Kuhns 12/01/96
 *)

(****
**  Bugs : Backfill does not display bitmap ???
****)

IMPORT
  B   := Bgui,
  BM  := BguiMacro,
  D   := Dos,
  DC  := DemoCode,
  E   := Exec,
  G   := Graphics,
  GT  := GadTools,
  I   := Intuition,
  IE  := InputEvent,
  u   := Utility,
  wb  := Workbench,
  y   := SYSTEM;

TYPE
  str4 = ARRAY 4 OF E.LSTRPTR;
  str5 = ARRAY 5 OF E.LSTRPTR;
  str6 = ARRAY 6 OF E.LSTRPTR;
  str7 = ARRAY 7 OF E.LSTRPTR;
  str9 = ARRAY 9 OF E.LSTRPTR;

CONST
(*
** Online-Help texts.
**)
  MainHelp     = "\ecBGUI is a shared library which offers a set of\nBOOPSI classes to allow for easy and flexible GUI creation.\n\nThe main window is also an AppWindow. Drop some icons\non it and see what happens.\n\nAll windows also detect the aspect ratio of the screen they are\nlocated on and adjust frame thickness accoording to this.\n\nAll other windows in this demo also have online-help. To access\nthis help press the \ebHELP\en key when the window is active.";

  GroupsHelp   = "\ecThe BGUI layout engine is encapsulated in the groupclass.\nThe groupclass will layout all of it's members into a specific area.\nYou can pass layout specific attributes to all group members\nwhich allows for flexible and powerful layout capabilities.";


  NotifHelp    = "\ecNotification can be used to let an object keep one or\nmore other objects informed about it's status. BGUI offers several\nkinds of notification of which two (conditional and map-list) are\nshown in this demonstration.";

  InfoHelp     = "\ecNot much more can be said about the BGUI infoclass than\nis said in this window. Except maybe that this text is shown in an\ninfoclass object as are all body texts from a BGUI requester.";

  ImageHelp    = "\ecThis window shows you the built-in images that BGUI has\nto offer. Ofcourse these images are all scalable and it is possible\nto create your own, scalable, imagery with the BGUI vectorclass.";

  BackfillHelp = "\ecHere you see the built-in backfill patterns BGUI supports.\nThese backfill patterns can all be used in groups and frames.\nThe frameclass also offers you the possibility to add hooks for\ncustom backfills and frame rendering.\n\nThe bottom frame shows you a custom backfill hook which renders a\nsimple pattern known from the WBPattern prefs editor as background.";

  PagesHelp    = "\ecThe pageclass allows you to setup a set of pages containing\nBGUI gadgets or groups. This will give you the oppertunity to\nhave several set's of gadgets in a single window.\n\nThis window has a IDCMP-hook installed which allows you to\ncontrol the Tabs object with your TAB key.";


(*
** Window objects.
**)

VAR
  waMain, waGroups, waNotif : B.Object;
  waInfo, waImage,  waBfill : B.Object;
  waPages                   : B.Object;
(*
** Gadget objects from the main window.
**)
  btGroups,   btNotif,    btQuit     : B.Object;
  btInfo,     btImages,   btBfill    : B.Object;
  btPages,    btIconDone, btIconQuit : B.Object;
  lvIconList, pgPager                : B.Object;
  w                                  : ARRAY 4 OF B.Object;
(*
** One, shared, message port for all
** demo windows.
**)
  SharedPort : E.MsgPortPtr;
(*
** Hooks
*)
  BackFill  : u.Hook;
  TabHook   : u.Hook;

  bp        : B.Pattern; (* For bitmap backfill *)

(*
** Menus & gadget ID's.
**)

CONST
  idAbout *= 1;
  idQuit  *= 2;

(*
** A small menu strip.
**)
TYPE
  menu5 = ARRAY 5 OF GT.NewMenu;

CONST
  MainMenus = menu5(
    GT.title, y.ADR("Project"),    NIL,        {}, LONGSET{}, 0,
    GT.item,  y.ADR("About"),      y.ADR('?'), {}, LONGSET{}, idAbout,
    GT.item,  GT.barLabel,         NIL,        {}, LONGSET{}, NIL,
    GT.item,  y.ADR("Quit"),       y.ADR('Q'), {}, LONGSET{}, idQuit,
    0,        NIL,                 NIL,        {}, LONGSET{}, 0        );

(*
** Put up a simple requester.
**)
(* ULONG Req( struct Window *win, UBYTE *gadgets, UBYTE *body, ... ) *)
PROCEDURE Req( win : I.WindowPtr; gadgets : E.LSTRPTR; body : E.LSTRPTR ) : LONGINT;
  VAR
    req : B.request;
  BEGIN

    req.gadgetFormat:= gadgets;
    req.textFormat  := body;
    req.flags       := LONGSET{ B.reqfCenterWindow, B.reqfXenButtons, B.reqfAutoAspect };

    RETURN B.RequestA( win, y.ADR( req ), NIL );
  END Req;

(*
** Main window button ID's.
**)

CONST
  idMainGroups   *= 3;
  idMainNotif    *= 4;
  idMainInfo     *= 5;
  idMainImage    *= 6;
  idMainBfill    *= 7;
  idMainPages    *= 8;
  idMainIconCont *= 9;

(*
** Open main window.
**)
(* struct Window *OpenMainWindow( ULONG *appmask ) *)
PROCEDURE OpenMainWindow( VAR appmask : LONGSET ): I.WindowPtr;
  VAR
    window : I.WindowPtr;
    rc     : LONGINT;
    if11, vg11a, vg11b, vg11c,
    hg11,
    vg1,
    if21, hg21,
    vg2,
    mg                         : B.Object;
  BEGIN
    window:= NIL;

    if11:= BM.InfoObject( B.infoTextFormat,   y.ADR("\ec\ed8\es\ebBGUI Demo\n\ed2\en©1996 Ian J. Einman\n©1993-1995 Jaba Development\n\n\eiPress the HELP key for more info.")     ,
                          B.infoFixTextWidth, E.true,
                          B.infoMinLines,     5,
                          B.frmType,          B.frTypeNext,
                          u.done );

    btGroups:= BM.PrefButton( y.ADR("_Groups"),       idMainGroups );
    btNotif := BM.PrefButton( y.ADR("_Notification"), idMainNotif  );

    vg11a:= BM.VGroupObject( B.groupSpacing,     B.grSpaceNormal,    (* NormalSpacing *)
                             B.groupMember,      btGroups, u.done, 0,
                             B.groupMember,      btNotif,  u.done, 0,
                             B.groupSpaceObject, B.defaultWeight,       (* VarSpace(DEFAULT_WEIGHT) *)
                             u.done );

    btImages:= BM.PrefButton( y.ADR("_Images"),   idMainImage );
    btBfill := BM.PrefButton( y.ADR("_BackFill"), idMainBfill );
    btQuit  := BM.PrefButton( y.ADR("_Quit"),     idQuit      );

    vg11b:= BM.VGroupObject( B.groupSpacing, B.grSpaceNormal,           (* NormalSpacing *)
                             B.groupMember,  btImages, u.done, 0,
                             B.groupMember,  btBfill,  u.done, 0,
                             B.groupMember,  btQuit,   u.done, 0,
                             u.done );

    btPages:= BM.PrefButton( y.ADR("_Pages"),     idMainPages  );
    btInfo := BM.PrefButton( y.ADR("Info_Class"), idMainInfo   );

    vg11c:= BM.VGroupObject( B.groupSpacing, B.grSpaceNormal,           (* NormalSpacing *)
                             B.groupMember, btPages, u.done, 0,
                             B.groupMember, btInfo,  u.done, 0,
                             B.groupSpaceObject, B.defaultWeight,       (* VarSpace(DEFAULT_WEIGHT) *)
                             u.done );

    hg11:= BM.HGroupObject( B.groupSpacing, B.grSpaceNormal,            (* NormalSpacing *)
                            B.groupMember,  vg11a, u.done, 0,
                            B.groupMember,  vg11b, u.done, 0,
                            B.groupMember,  vg11c, u.done, 0,
                            u.done );

    vg1:= BM.VGroupObject( B.groupSpacing,  B.grSpaceWide,              (* WideSpacing *)
                           B.groupBackfill, B.shineRaster,
                           B.groupMember,   if11, u.done, 0,
                           B.groupMember,   hg11,
                                            B.lgoFixMinHeight, E.true,  (* FixMinHeight *)
                                            B.groupEqualWidth, E.true,  (* EqualWidth   *)
                                            u.done, 0,
                           u.done );

    if21:= BM.InfoObject( B.infoTextFormat,   y.ADR("\ecThe following icons were dropped\nin the window:"),
                          B.infoFixTextWidth, E.true,
                          B.infoMinLines,     2,
                          B.infoHorizOffset,  13,
                          B.frmType,          B.frTypeButton,
                          B.frmRecessed,      E.true,
                          u.done );

    lvIconList:= BM.ListviewObject( B.listvReadOnly, E.true,
                                    u.done );

    btIconDone:= BM.PrefButton( y.ADR("_Continue"), idMainIconCont );
    btIconQuit:= BM.PrefButton( y.ADR("_Quit"),     idQuit );

    hg21:= BM.HGroupObject( B.groupMember, btIconDone, u.done, 0,
                            B.groupSpaceObject, B.defaultWeight,   (* VarSpace(DEFAULT_WEIGHT) *)
                            B.groupMember, btIconQuit, u.done, 0,
                            u.done );

    vg2:= BM.VGroupObject( B.groupSpacing,  B.grSpaceNormal,
                           B.groupBackfill, B.shineRaster,
                           B.groupMember, if21,
                                          B.lgoFixMinHeight, E.true,   (* FixMinHeight *)
                                          u.done, 0,
                           B.groupMember, lvIconList, u.done, 0,
                           B.groupMember, hg21,
                                          B.lgoFixMinHeight, E.true,   (* FixMinHeight *)
                                          u.done, 0,
                           u.done );

    (*
    ** Main page.
    **)
    pgPager:= BM.PageObject( B.pageMember, vg1,
                             B.pageMember, vg2,
                             u.done );

    mg:= BM.VGroupObject( B.groupHorizOffset, B.grSpaceNormal,       (* NormalOffset *)
                          B.groupVertOffset,  B.grSpaceNormal,
                          B.groupSpacing,     B.grSpaceNormal,       (* NomalSpacing *)
                          B.groupBackfill,    B.shineRaster,
                          B.groupMember,      pgPager, u.done, 0,
                          u.done );

    waMain:= BM.WindowObject( B.windowTitle,        y.ADR("BGUI Demo"),
                              B.windowScreenTitle,  y.ADR("BGUI Demo - ©1996 Ian J. Einman, ©1993-1995 Jaba Development."),
                              B.windowMenuStrip,    y.ADR( MainMenus ),
                              B.windowSmartRefresh, E.true,
                              B.windowAppWindow,    E.true,
                              B.windowSizeGadget,   E.false,
                              B.windowHelpText,     y.ADR( MainHelp ),
                              B.windowAutoAspect,   E.true,
                              B.windowSharedPort,   SharedPort,
                              B.windowAutoKeyLabel, E.true,
                              B.windowScaleWidth,   10,
                              B.windowCloseOnEsc,   E.true,
                              B.windowMasterGroup,  mg,
                              u.done );

    (*
    ** Object created OK?
    **)
    IF waMain # NIL THEN
      (*
      ** Open the window.
      **)
      window:= BM.WindowOpen( waMain );
      IF window # NIL THEN
        (*
        ** Obtain appwindow signal mask.
        **)
        rc:= I.GetAttr( B.windowAppMask, waMain, appmask );
      END;
    END;

    RETURN window;
  END OpenMainWindow;

(*
** Macros for the group objects. GObj() creates
** a simple infoclass object with some text in
** it. TObj() creates a simple groupclass object
** with a button frame.
**)
PROCEDURE GObj ( t : ARRAY OF CHAR ): B.Object;
  (* CopyArrays- *)
  BEGIN
    RETURN B.NewObject( B.infoGadget,
                        B.infoTextFormat,   y.ADR( t ),
                        B.infoFixTextWidth, E.true,
                        B.infoHorizOffset,  4,
                        B.infoVertOffset,   3,
                        B.frmType,          B.frTypeButton,
                        B.frmFlags,         LONGSET{B.frfRecessed},  (* ButtonFrame *)
                        u.done );

  END GObj;

PROCEDURE NWObj( v : LONGINT; id : LONGINT ) : B.Object;
  BEGIN
    RETURN B.NewObject( B.stringGadget,
                        I.stringaLongVal,       v,
                        I.stringaMaxChars,      3,
                        B.stringaIntegerMin,    1,
                        B.stringaIntegerMax,    999,
                        I.stringaJustification, LONGSET{I.stringCenter},
                        I.gaID,                 id,
                        B.frmType,              B.frTypeFuzzRidge,  (* FuzzRidgeFrame *)
                        u.done );
                        (* Weight(v) *)
  END NWObj;

PROCEDURE TObj() : B.Object;
  BEGIN
    RETURN BM.HGroupObject( B.groupHorizOffset, 4,               (* HOffset(4) *)
                            B.groupVertOffset,  3,               (* VOffset(3) *)
                            B.frmType,          B.frTypeButton,  (* ButtonFrame *)
                            B.frmBackFill,      B.fillRaster,
                            B.frmFlags,         LONGSET{B.frfRecessed},
                            u.done );
  END TObj;

CONST
  idGroupW0 *= 500;
  idGroupW1 *= 501;
  idGroupW2 *= 502;
  idGroupW3 *= 503;

(*
** Open up the groups window.
**)
(* struct Window *OpenGroupsWindow( void ) *)
PROCEDURE OpenGroupsWindow( ): I.WindowPtr;
  VAR
    window : I.WindowPtr;
    to     : ARRAY 19 OF B.Object;
    i      : LONGINT;
    hg11a, vg11b, vg11c    : B.Object;
    hg11c1, hg11c2, hg11c3 : B.Object;
    hg11                   : B.Object;
    hg12a, hg12b           : B.Object;
    vg12                   : B.Object;
    vg1                    : B.Object;
  BEGIN
    window:= NIL;

    (*
    ** If the object has not been created
    ** already we build it.
    **)
    IF waGroups = NIL THEN
      FOR i:= 0 TO 14 DO to[i]:= TObj() END;
      to[15]:= GObj( "\ecFree" );
      to[16]:= GObj( "\ec\ebFixed" );
      to[17]:= GObj( "\ecFree" );
      to[18]:= GObj( "\ec\ebFixed" );

      hg11a:= BM.HGroupObject( B.frmType,           B.frTypeNext,        (* NeXTFrame *)
                               B.frmTitle,          y.ADR("Horizontal"), (* FrameTitle() *)
                               B.groupSpacing,      B.grSpaceNormal,     (* NormalSpacing *)
                               B.groupHorizOffset,  B.grSpaceNormal,     (* NormalHOffset *)
                               B.groupTopOffset,    B.grSpaceNarrow,     (* TOffset(b.grspaceNarrow) *)
                               B.groupBottomOffset, B.grSpaceNormal,     (* BOffset(b.grspaceNormal) *)
                               B.groupMember, to[0], u.done, 0,
                               B.groupMember, to[1], u.done, 0,
                               B.groupMember, to[2], u.done, 0,
                               u.done );

      vg11b:= BM.VGroupObject( B.frmType,           B.frTypeNext,        (* NeXTFrame *)
                               B.frmTitle,          y.ADR("Vertical"),   (* FrameTitle() *)
                               B.groupSpacing,      B.grSpaceNormal,     (* NormalSpacing *)
                               B.groupHorizOffset,  B.grSpaceNormal,     (* NormalHOffset *)
                               B.groupTopOffset,    B.grSpaceNarrow,     (* TOffset(b.grspaceNarrow) *)
                               B.groupBottomOffset, B.grSpaceNormal,     (* BOffset(b.grspaceNormal) *)
                               B.groupMember, to[3], u.done, 0,
                               B.groupMember, to[4], u.done, 0,
                               B.groupMember, to[5], u.done, 0,
                               u.done );

      hg11c1:= BM.HGroupObject( B.groupSpacing, B.grSpaceNormal,   (* NormalSpacing *)
                                B.groupMember,  to[6], u.done, 0,
                                B.groupMember,  to[7], u.done, 0,
                                B.groupMember,  to[8], u.done, 0,
                                u.done );

      hg11c2:= BM.HGroupObject( B.groupSpacing, B.grSpaceNormal,   (* NormalSpacing *)
                                B.groupMember,  to[9],  u.done, 0,
                                B.groupMember,  to[10], u.done, 0,
                                B.groupMember,  to[11], u.done, 0,
                                u.done );

      hg11c3:= BM.HGroupObject( B.groupSpacing, B.grSpaceNormal,     (* NormalSpacing *)
                                B.groupMember,  to[12], u.done, 0,
                                B.groupMember,  to[13], u.done, 0,
                                B.groupMember,  to[14], u.done, 0,
                                u.done );


      vg11c:= BM.VGroupObject( B.frmType,           B.frTypeNext,     (* NeXTFrame *)
                               B.frmTitle,          y.ADR("Grid"),    (* FrameTitle( "Grid" ) *)
                               B.groupSpacing,      B.grSpaceNormal,  (* NormalSpacing *)
                               B.groupHorizOffset,  B.grSpaceNormal,  (* NormalHOffset *)
                               B.groupTopOffset,    B.grSpaceNarrow,  (* TOffset(b.grspaceNarrow) *)
                               B.groupBottomOffset, B.grSpaceNormal,  (* BOffset(b.grspaceNormal) *)
                               B.groupMember, hg11c1, u.done, 0,
                               B.groupMember, hg11c2, u.done, 0,
                               B.groupMember, hg11c3, u.done, 0,
                               u.done );

      hg11:= BM.HGroupObject( B.groupSpacing, B.grSpaceWide,         (* WideSpacing *)
                              B.groupMember,  hg11a, u.done, 0,
                              B.groupMember,  vg11b, u.done, 0,
                              B.groupMember,  vg11c, u.done, 0,
                              u.done );

      w[0]:= NWObj( 25, idGroupW0 );
      w[1]:= NWObj( 50, idGroupW1 );
      w[2]:= NWObj( 75, idGroupW2 );
      w[3]:= NWObj(100, idGroupW3 );

      hg12a:= BM.HGroupObject( B.groupSpacing, B.grSpaceNormal,  (* NormalSpacing *)
                               B.groupMember, w[0],
                                              B.lgoWeight, 25,   (* Weight(25) *)
                                              u.done, 0,
                               B.groupMember, w[1],
                                              B.lgoWeight, 50,   (* Weight(50) *)
                                              u.done, 0,
                               B.groupMember, w[2],
                                              B.lgoWeight, 75,   (* Weight(75) *)
                                              u.done, 0,
                               B.groupMember, w[3],
                                              B.lgoWeight, 100,  (* Weight(100) *)
                                              u.done, 0,
                               u.done );

      hg12b:= BM.HGroupObject( B.groupSpacing, B.grSpaceNormal,           (* NormalSpacing *)
                               B.groupMember,  to[15], u.done, 0,
                               B.groupMember,  to[16],
                                               B.lgoFixMinWidth, E.true,  (* FixMinWidth *)
                                               u.done, 0,
                               B.groupMember,  to[17], u.done, 0,
                               B.groupMember,  to[18],
                                               B.lgoFixMinWidth, E.true,  (* FixMinWidth *)
                                               u.done, 0,
                               u.done );

      vg12:= BM.VGroupObject( B.groupSpacing,      B.grSpaceNormal,               (* NormalSpacing *)
                              B.frmTitle, y.ADR("Free, Fixed and Weight sizes."), (* FrameTitle(t) *)
                              B.frmType,           B.frTypeNext,                  (* NeXTFrame *)
                              B.groupHorizOffset,  B.grSpaceNormal,               (* NormalHOffset *)
                              B.groupTopOffset,    B.grSpaceNarrow,               (* TOffset(b.grspaceNarrow) *)
                              B.groupBottomOffset, B.grSpaceNormal,               (* BOffset(b.grspaceNormal) *)
                              B.groupMember, hg12a, u.done, 0,
                              B.groupMember, hg12b, u.done, 0,
                              u.done );

      vg1:= BM.VGroupObject( B.groupHorizOffset, B.grSpaceNormal,       (* NormalOffset *)
                             B.groupVertOffset,  B.grSpaceNormal,
                             B.groupSpacing,     B.grSpaceNormal,       (* NormalSpacing *)
                             B.groupMember, hg11, u.done, 0,
                             B.groupMember, vg12,
                                            B.lgoFixMinHeight, E.true,  (* FixMinWeight *)
                                            u.done, 0,
                             u.done );



      waGroups:= BM.WindowObject( B.windowTitle,        y.ADR("BGUI Groups"),
                                  B.windowRMBTrap,      E.true,
                                  B.windowSmartRefresh, E.true,
                                  B.windowHelpText,     y.ADR( GroupsHelp ),
                                  B.windowAutoAspect,   E.true,
                                  B.windowSharedPort,   SharedPort,
                                  B.windowScaleWidth,   20,
                                  B.windowScaleHeight,  20,
                                  B.windowMasterGroup,  vg1,
                                  u.done );
    END; (* IF waGroups = NIL *)

    (*
    ** Object OK?
    **)
    IF waGroups # NIL THEN
      (*
      ** Open the window.
      **)
      window:= BM.WindowOpen( waGroups );
    END;

    RETURN window;

  END OpenGroupsWindow;

(*
** Cycle gadget labels.
**)
CONST
  NotifLabels = str4( y.ADR("Enabled-->"), y.ADR("Disabled-->"), y.ADR("Still Disabled-->"), NIL );

(*
** Notification map-lists.
**)
TYPE
  map3 = ARRAY 3 OF LONGINT;
CONST
  pga2sl = map3( I.pgaTop,       B.sliderLevel,  u.done );
  sl2prg = map3( B.sliderLevel,  B.progressDone, u.done );
  prg2in = map3( B.progressDone, B.indicLevel,   u.done );

(*
** Open the notification window.
**)
(* struct Window *OpenNotifWindow( void ) *)
PROCEDURE OpenNotifWindow( ): I.WindowPtr;
  VAR
    window                           : I.WindowPtr;
    c, bt, p1, p2, s1, s2, p, i1, i2 : B.Object;
    to1, to2                         : B.Object;
    hg1, vg2a, vg2b, hg2, vg         : B.Object;
  BEGIN
    window:= NIL;

    (*
    ** Not created yet? Create it now!
    **)
    IF waNotif = NIL THEN

      to1:= BM.TitleSeparator( y.ADR("Conditional") );

      c  := BM.PrefCycle( NIL, y.ADR( NotifLabels ), 0, 0 );
      bt := BM.PrefButton( y.ADR("Target"), 0 );
      hg1:= BM.HGroupObject( B.groupSpacing, B.grSpaceNormal,     (* NormalSpacing *)
                             B.groupMember,  c , u.done, 0,
                             B.groupMember,  bt, u.done, 0,
                             u.done );

      to2:= BM.TitleSeparator( y.ADR("Map-List") );

      i1:=   BM.IndicatorFormat( 0, 100, 0, B.idjCenter, y.ADR("%ld%%"));
      p1:=   BM.HorizProgress( NIL, 0, 100, 0 );

      vg2a:= BM.VGroupObject( B.groupSpacing, B.grSpaceNormal,            (* NormalSpacing *)
                              B.groupMember,  i1,
                                              B.lgoFixMinHeight, E.true,  (* FixMinHeight *)
                                              u.done, 0,
                              B.groupMember, p1, u.done, 0,
                              u.done );

      s1:= BM.VertSlider     ( NIL,   0, 100, 0, 0 );
      p := BM.VertScroller   ( NIL,   0, 101, 1, 0 );

      s2:= BM.VertSlider     ( NIL,   0, 100, 0, 0 );
      i2:= BM.IndicatorFormat(  0,  100,   0, B.idjCenter, y.ADR("%ld%%"));
      p2:= BM.VertProgress   ( NIL,   0, 100, 0 );

      vg2b:= BM.VGroupObject( B.groupSpacing, B.grSpaceNormal,            (* NormalSpacing *)
                              B.groupMember,  i2,
                                              B.lgoFixMinHeight, E.true,  (* FixMinHeight *)
                                              u.done, 0,
                              B.groupMember,  p2, u.done, 0,
                              u.done );

      hg2:= BM.HGroupObject( B.groupSpacing, B.grSpaceNormal,          (* NormalSpacing *)
                             B.groupMember,  vg2a, u.done, 0,
                             B.groupMember,  s1,
                                             B.lgoFixWidth, 16,        (* FixWidth( 16 ) *)
                                             u.done, 0,
                             B.groupMember,  p,
                                             B.lgoFixWidth, 16,        (* FixWidth( 16 ) *)
                                             u.done, 0,
                             B.groupMember,  s2,
                                             B.lgoFixWidth, 16,        (* FixWidth( 16 ) *)
                                             u.done, 0,
                             B.groupMember,  vg2b, u.done, 0,
                             u.done );

      vg:= BM.VGroupObject( B.groupHorizOffset, B.grSpaceNormal,       (* NormalOffset  *)
                            B.groupVertOffset,  B.grSpaceNormal,
                            B.groupSpacing,     B.grSpaceNormal,       (* NormalSpacing *)
                            B.groupMember, to1,
                                           B.lgoFixMinHeight, E.true,
                                           u.done, 0,
                            B.groupMember, hg1,
                                           B.lgoFixMinHeight, E.true,  (* FixMinHeight *)
                                           u.done, 0,
                            B.groupMember, to2,
                                           B.lgoFixMinHeight, E.true,
                                           u.done, 0,
                            B.groupMember, hg2, u.done, 0,
                            u.done );

      waNotif:= BM.WindowObject( B.windowTitle,        y.ADR("BGUI notification"),
                                 B.windowRMBTrap,      E.true,
                                 B.windowSmartRefresh, E.true,
                                 B.windowHelpText,     y.ADR( NotifHelp ),
                                 B.windowAutoAspect,   E.true,
                                 B.windowSharedPort,   SharedPort,
                                 B.windowMasterGroup,  vg,
                                 u.done );



      IF waNotif # NIL THEN
        (*
        ** Connect the cycle object with the button.
        **)
        BM.AddCondit( c, bt, B.cycActive, 0, I.gaDisabled, E.false, I.gaDisabled, E.true );
        (*
        ** Connect sliders, prop, progression and indicators.
        **)
        BM.AddMap( s1, p1, y.ADR( sl2prg ));
        BM.AddMap( s2, p2, y.ADR( sl2prg ));
        BM.AddMap( p,  s1, y.ADR( pga2sl ));
        BM.AddMap( p,  s2, y.ADR( pga2sl ));
        BM.AddMap( p1, i1, y.ADR( prg2in ));
        BM.AddMap( p2, i2, y.ADR( prg2in ));
      END; (* IF waNotif # NIL *)
    END; (* IF waNotif = NIL *)

    (*
    ** Object OK?
    **)
    IF waNotif # NIL THEN
      (*
      ** Open window.
      **)
      window:= BM.WindowOpen( waNotif );
    END;

    RETURN window;

  END OpenNotifWindow;

(*
** Open infoclass window.
**)
(* struct Window *OpenInfoWindow( void ) *)
PROCEDURE OpenInfoWindow( ): I.WindowPtr;
  VAR
    window  : I.WindowPtr;
    args    : ARRAY 2 OF LONGINT;
    inf, vg : B.Object;
  BEGIN
    window:= NIL;

    (*
    ** Setup arguments for the
    ** infoclass object.
    **)
    args[0]:= E.AvailMem( LONGSET{E.chip} );
    args[1]:= E.AvailMem( LONGSET{E.fast} );

    (*
    ** Not created already?
    **)
    IF waInfo = NIL THEN
      inf:= BM.InfoFixed( NIL,
                          y.ADR("\ecBGUI offers the InfoClass.\nThis class is a text display class which\nallows things like:\n\n\ed3C\ed4o\ed5l\ed6o\ed8r\ed2s\n\n\elLeft Aligned...\n\erRight Aligned...\n\ecCentered...\n\n\ebBold...\n\en\eiItalic...\n\en\euUnderlined...\n\y.ADR(n\eb\eiAnd combinations!\n\n\enFree CHIP:\ed3 %lD\ed2, Free FAST:\ed3 %lD\n"),
                          y.ADR( args[ 0 ] ),
                          17 );
      vg:= BM.VGroupObject( B.groupHorizOffset, 4,       (* HOffset( 4 ) *)
                            B.groupVertOffset,  4,       (* VOffset( 4 ) *)
                            B.groupMember, inf, u.done, 0,
                            u.done );

      waInfo:= BM.WindowObject( B.windowTitle,        y.ADR("BGUI information class"),
                                B.windowRMBTrap,      E.true,
                                B.windowSmartRefresh, E.true,
                                B.windowHelpText,     y.ADR(InfoHelp),
                                B.windowAutoAspect,   E.true,
                                B.windowSharedPort,   SharedPort,
                                B.windowMasterGroup,  vg,
                                u.done );
    END; (* IF waNotif = NIL *)

    (*
    ** Object OK?
    **)
    IF waInfo # NIL THEN
      (*
      ** Open window.
      **)
      window:= BM.WindowOpen( waInfo );
    END;

    RETURN window;

  END OpenInfoWindow;

(*
** Open images window.
**)
(* struct Window *OpenImageWindow( void ) *)
PROCEDURE OpenImageWindow( ): I.WindowPtr;
  VAR
    window       : I.WindowPtr;
    bt           : ARRAY 20 OF B.Object;
    vg, hg1, vg1,
    hg1a, hg1b   : B.Object;
  BEGIN
    window:= NIL;

    (*
    ** Not yet created?
    **)
    IF waImage = NIL THEN

      bt[ 0]:= BM.ButtonObject( B.vitBuiltIn, B.builtinGetPath,    u.done );
      bt[ 1]:= BM.ButtonObject( B.vitBuiltIn, B.builtinGetFile,    u.done );
      bt[ 2]:= BM.ButtonObject( B.vitBuiltIn, B.builtinPopup,      u.done );
      bt[ 3]:= BM.ButtonObject( B.vitBuiltIn, B.builtinCycle,      u.done );
      bt[ 4]:= BM.ButtonObject( B.vitBuiltIn, B.builtinCycle2,     u.done );
      bt[ 5]:= BM.ButtonObject( B.vitBuiltIn, B.builtinCheckMark,  u.done );
      bt[ 6]:= BM.ButtonObject( B.vitBuiltIn, B.builtinArrowUp,    u.done );
      bt[ 7]:= BM.ButtonObject( B.vitBuiltIn, B.builtinArrowDown,  u.done );
      bt[ 8]:= BM.ButtonObject( B.vitBuiltIn, B.builtinArrowLeft,  u.done );
      bt[ 9]:= BM.ButtonObject( B.vitBuiltIn, B.builtinArrowRight, u.done );
      bt[10]:= BM.ButtonObject( B.vitBuiltIn, B.builtinGetPath,    u.done );
      bt[11]:= BM.ButtonObject( B.vitBuiltIn, B.builtinGetFile,    u.done );
      bt[12]:= BM.ButtonObject( B.vitBuiltIn, B.builtinPopup,      u.done );
      bt[13]:= BM.ButtonObject( B.vitBuiltIn, B.builtinCycle,      u.done );
      bt[14]:= BM.ButtonObject( B.vitBuiltIn, B.builtinCycle2,     u.done );
      bt[15]:= BM.ButtonObject( B.vitBuiltIn, B.builtinCheckMark,  u.done );
      bt[16]:= BM.ButtonObject( B.vitBuiltIn, B.builtinArrowUp,    u.done );
      bt[17]:= BM.ButtonObject( B.vitBuiltIn, B.builtinArrowDown,  u.done );
      bt[18]:= BM.ButtonObject( B.vitBuiltIn, B.builtinArrowLeft,  u.done );
      bt[19]:= BM.ButtonObject( B.vitBuiltIn, B.builtinArrowRight, u.done );

      hg1:= BM.HGroupObject( B.groupTopOffset,    B.grSpaceNarrow,     (* TOffset(B.grspaceNarrow) *)
                             B.groupBottomOffset, B.grSpaceNormal,     (* BOffset(B.grspaceNormal) *)
                             B.groupSpacing,      B.grSpaceNormal,     (* NormalSpacing *)
                             B.frmType,           B.frTypeNext,        (* NeXTFrame *)
                             B.frmTitle,          y.ADR("Fixed size"), (* FrameTitle("Fixed size") *)
                             B.groupSpaceObject,  B.defaultWeight,     (* VarSpace(B.defaultWeight) *)
                             B.groupMember, bt[ 0],
                                            B.lgoFixMinWidth,  E.true, (* FixMinSize *)
                                            B.lgoFixMinHeight, E.true,
                                            u.done, 0,
                             B.groupMember, bt[ 1],
                                            B.lgoFixMinWidth,  E.true, (* FixMinSize *)
                                            B.lgoFixMinHeight, E.true,
                                            u.done, 0,
                             B.groupMember, bt[ 2],
                                            B.lgoFixMinWidth,  E.true, (* FixMinSize *)
                                            B.lgoFixMinHeight, E.true,
                                            u.done, 0,
                             B.groupMember, bt[ 3],
                                            B.lgoFixMinWidth,  E.true, (* FixMinSize *)
                                            B.lgoFixMinHeight, E.true,
                                            u.done, 0,
                             B.groupMember, bt[ 4],
                                            B.lgoFixMinWidth,  E.true, (* FixMinSize *)
                                            B.lgoFixMinHeight, E.true,
                                            u.done, 0,
                             B.groupMember, bt[ 5],
                                            B.lgoFixMinWidth,  E.true, (* FixMinSize *)
                                            B.lgoFixMinHeight, E.true,
                                            u.done, 0,
                             B.groupMember, bt[ 6],
                                            B.lgoFixMinWidth,  E.true, (* FixMinSize *)
                                            B.lgoFixMinHeight, E.true,
                                            u.done, 0,
                             B.groupMember, bt[ 7],
                                            B.lgoFixMinWidth,  E.true, (* FixMinSize *)
                                            B.lgoFixMinHeight, E.true,
                                            u.done, 0,
                             B.groupMember, bt[ 8],
                                            B.lgoFixMinWidth,  E.true, (* FixMinSize *)
                                            B.lgoFixMinHeight, E.true,
                                            u.done, 0,
                             B.groupMember, bt[ 9],
                                            B.lgoFixMinWidth,  E.true, (* FixMinSize *)
                                            B.lgoFixMinHeight, E.true,
                                            u.done, 0,
                             B.groupSpaceObject,  B.defaultWeight,     (* VarSpace(B.defaultWeight) *)
                             u.done );

      hg1a:= BM.HGroupObject( B.groupSpacing,      B.grSpaceNormal,     (* NormalSpacing *)
                              B.groupMember, bt[10], u.done, 0,
                              B.groupMember, bt[11], u.done, 0,
                              B.groupMember, bt[12], u.done, 0,
                              B.groupMember, bt[13], u.done, 0,
                              B.groupMember, bt[14], u.done, 0,
                              u.done );

      hg1b:= BM.HGroupObject( B.groupSpacing,      B.grSpaceNormal,     (* NormalSpacing *)
                              B.groupMember, bt[15], u.done, 0,
                              B.groupMember, bt[16], u.done, 0,
                              B.groupMember, bt[17], u.done, 0,
                              B.groupMember, bt[18], u.done, 0,
                              B.groupMember, bt[19], u.done, 0,
                              u.done );

      vg1:= BM.VGroupObject( B.groupHorizOffset,  B.grSpaceNormal,     (* NormalHOffset *)
                             B.groupTopOffset,    B.grSpaceNarrow,     (* TOffset(B.grspaceNarrow) *)
                             B.groupBottomOffset, B.grSpaceNormal,     (* BOffset(B.grspaceNormal) *)
                             B.groupSpacing,      B.grSpaceNormal,     (* NormalSpacing *)
                             B.frmType,           B.frTypeNext,        (* NeXTFrame *)
                             B.frmTitle,          y.ADR("Free size"),  (* FrameTitle("Free size") *)
                             B.groupMember, hg1a, u.done, 0,
                             B.groupMember, hg1b, u.done, 0,
                             u.done );

      vg:= BM.VGroupObject( B.groupHorizOffset, B.grSpaceNormal,       (* NormalOffset *)
                            B.groupVertOffset,  B.grSpaceNormal,
                            B.groupSpacing,     B.grSpaceWide,         (* WideSpacing *)
                            B.groupMember, hg1,
                                           B.lgoFixMinHeight, E.true,  (* FixMinHeight *)
                                           u.done, 0,
                            B.groupMember, vg1, u.done, 0,
                            u.done );

      waImage:= BM. WindowObject( B.windowTitle,        y.ADR("BGUI images"),
                                  B.windowRMBTrap,      E.true,
                                  B.windowSmartRefresh, E.true,
                                  B.windowHelpText,     y.ADR( ImageHelp ),
                                  B.windowAutoAspect,   E.true,
                                  B.windowSharedPort,   SharedPort,
                                  B.windowScaleHeight,  10,
                                  B.windowMasterGroup,  vg,
                                  u.done );

    END; (* IF waImage = NIL *)

    (*
    ** Object OK?
    **)
    IF waImage # NIL THEN
      (*
      ** Open the window.
      **)
      window:= BM.WindowOpen( waImage );
    END;

    RETURN window;
  END OpenImageWindow;

(*
** The BackFill hook to show custom backfills.
** Renders a pattern from the WBPattern preferences
** editor as back-fill.
**)
TYPE
  fdmPtr = UNTRACED POINTER TO fdm;
  fdm = STRUCT( d : B.ArgsDesc )
    data : B.FrameDrawMsg;
    END;

  intArray = ARRAY 32 OF INTEGER;
CONST
  pat = intArray( 0000H, 0000H, 0002H, 0002H, 000AH, 000AH, 002AH, 002AH,
                  00AAH, 002AH, 03EAH, 000AH, 0FFAH, 0002H, 3FFEH, 0000H,
                  0000H, 7FFCH, 4000H, 5FF0H, 5000H, 57C0H, 5400H, 5500H,
                  5400H, 5400H, 5000H, 5000H, 4000H, 4000H, 0000H, 0000H );


(* SAVEDS ASM ULONG BackFillHook( REG(a0) struct Hook *hook, REG(a2) Object *imo, REG(a1) struct FrameDrawMsg *fdm ) *)
PROCEDURE BackFillHook ( hook : B.Hook; imo : B.Object; args : B.Args ) : LONGINT;
  BEGIN
    args(fdm).data.rPort.mask:= SHORTSET{ 0,1};  (* 03H *)
    G.SetAfPt ( args(fdm).data.rPort, y.ADR( pat ), -4 );
    G.SetAPen ( args(fdm).data.rPort, ASH( 1, args(fdm).data.drawInfo.depth ) - 1 );
    G.RectFill( args(fdm).data.rPort,
                args(fdm).data.bounds.minX, args(fdm).data.bounds.minY,
                args(fdm).data.bounds.maxX, args(fdm).data.bounds.maxY );
    G.SetAfPt ( args(fdm).data.rPort, NIL, 0 );
    RETURN B.frcOk;
  END BackFillHook;

(*
** Open back-fill window.
**)
(* struct Window *OpenFillWindow( void ) *)
PROCEDURE OpenFillWindow( ): I.WindowPtr;
  VAR
    window         : I.WindowPtr;
    screen         : I.ScreenPtr;
    in             : ARRAY 10 OF B.Object;
    hg1a, hg1b,
    vg1, vg2, vg3,
    hg             : B.Object;

  PROCEDURE InfoObj( bg : LONGINT ) : B.Object;
    BEGIN
      RETURN BM.InfoObject( B.frmType,     B.frTypeButton,
                            B.frmBackFill, bg,
                            u.done );
    END InfoObj;

  BEGIN
    window:= NIL;
    screen:= I.LockPubScreen( "" );

    (*
    ** Not yet created?
    **)
    IF waBfill = NIL THEN

      in[0]:= InfoObj( B.shineRaster );
      in[1]:= InfoObj( B.shadowRaster );
      in[2]:= InfoObj( B.shineShadowRaster );
      in[3]:= InfoObj( B.fillRaster );
      in[4]:= InfoObj( B.shineFillRaster );
      in[5]:= InfoObj( B.shadowFillRaster );
      in[6]:= InfoObj( B.shineBlock );
      in[7]:= InfoObj( B.shadowBlock );

      in[8]:= BM.InfoObject( B.frmType,         B.frTypeButton,
                             B.frmBackFillHook, y.ADR( BackFill ),
                             u.done );

      in[9]:= BM.InfoObject( B.frmType,         B.frTypeButton,  (* ButtonFrame *)
                             B.frmFillPattern,  y.ADR( bp ),
                             u.done );

      hg1a:= BM.HGroupObject( B.groupSpacing, B.grSpaceNormal,  (* NormalSpacing *)
                              B.groupMember, in[0], 0, u.done,
                              B.groupMember, in[1], 0, u.done,
                              B.groupMember, in[2], 0, u.done,
                              B.groupMember, in[3], 0, u.done,
                              u.done );

      hg1b:= BM.HGroupObject( B.groupSpacing, B.grSpaceNormal,  (* NormalSpacing *)
                              B.groupMember, in[4], 0, u.done,
                              B.groupMember, in[5], 0, u.done,
                              B.groupMember, in[6], 0, u.done,
                              B.groupMember, in[7], 0, u.done,
                              u.done );

      vg1:= BM.VGroupObject( B.groupHorizOffset, B.grSpaceNormal,      (* NormalOffset *)
                             B.groupVertOffset,  B.grSpaceNormal,
                             B.frmType,          B.frTypeNext,         (* NeXTFrame *)
                             B.frmTitle,         y.ADR("Raster Fill"),
                             B.groupSpacing,     B.grSpaceNormal,      (* NormalSpacing *)
                             B.groupMember, hg1a, 0, u.done,
                             B.groupMember, hg1b, 0, u.done,
                             u.done );

      vg2:= BM.VGroupObject( B.groupHorizOffset, B.grSpaceNormal,      (* NormalOffset *)
                             B.groupVertOffset,  B.grSpaceNormal,
                             B.frmType,          B.frTypeNext,         (* NeXTFrame *)
                             B.frmTitle,         y.ADR("Custom Hook"),
                             B.groupMember, in[8], 0, u.done,
                             u.done );

      vg3:= BM.VGroupObject( B.groupHorizOffset, B.grSpaceNormal,         (* NormalOffset *)
                             B.groupVertOffset,  B.grSpaceNormal,
                             B.frmType,          B.frTypeNext,            (* NeXTFrame *)
                             B.frmTitle,         y.ADR("Bitmap Pattern"),
                             B.groupMember, in[9], 0, u.done,
                             u.done );

      hg:= BM.HGroupObject( B.groupHorizOffset, B.grSpaceNormal,  (* NormalOffset *)
                            B.groupVertOffset,  B.grSpaceNormal,
                            B.groupSpacing,     B.grSpaceWide,    (* WideSpacing *)
                            B.groupMember, vg1, 0, u.done,
                            B.groupMember, vg2, 0, u.done,
                            B.groupMember, vg3, 0, u.done,
                            u.done );

      waBfill:= BM. WindowObject( B.windowTitle,        y.ADR("BGUI back fill patterns"),
                                  B.windowRMBTrap,      E.true,
                                  B.windowSmartRefresh, E.true,
                                  B.windowHelpText,     y.ADR( BackfillHelp ),
                                  B.windowScaleWidth,   40,
                                  B.windowScaleHeight,  40,
                                  B.windowAutoAspect,   E.true,
                                  B.windowSharedPort,   SharedPort,
                                  B.windowPubScreen,    screen,
                                  B.windowMasterGroup,  hg,
                                  u.done );


    END; (* IF waBfill = NIL *)

    I.UnlockPubScreen( "", screen );

    (*
    ** Object OK?
    **)
    IF waBfill # NIL THEN
      bp.flags  := LONGSET{};
      bp.left   := 0;
      bp.top    := 0;
      bp.width  := 120;
      bp.height := 80;
      bp.bitMap := screen.rastPort.bitMap;
      bp.object := NIL;
      (*
      ** Open window.
      **)
      window:= BM.WindowOpen( waBfill );
    END;

    RETURN window;

  END OpenFillWindow;

(*
** Cycle and Mx labels.
**)
CONST

  PageLab = str5( y.ADR("Buttons"), y.ADR("Strings"), y.ADR("CheckBoxes"), y.ADR("Radio-Buttons"), NIL );
  MxLab   = str5( y.ADR("MX #1"),   y.ADR("MX #2"),   y.ADR("MX #3"),      y.ADR("MX #4"),         NIL );

(*
** Cycle to Page map-list.
**)
  Cyc2Page = map3( B.mxActive, B.pageActive, u.done );

(*
** Create a MX object with a title on top.
**)
PROCEDURE MxGadget( label : ARRAY OF CHAR; labels : E.APTR ) : B.Object;
  (* $CopyArrays- *)
  BEGIN
   RETURN B.NewObject( B.mxGadget,
                       B.groupStyle,    B.grStyleVertical,
                       B.labLabel,      y.ADR( label ),
                       B.labPlace,      B.placeAbove,
                       B.labUnderscore, y.VAL( LONGINT, ORD('_')),
                       B.labHighlight,  E.true,
                       B.mxLabels,      labels,
                       B.mxLabelPlace,  B.placeLeft,
                       u.done );
                       (* FixMinSize *)
  END MxGadget;


(*
** Tabs-key control of the tabs gadget.
**)

TYPE
  tabInfo = STRUCT( d : B.ArgsDesc )
    msg : I.IntuiMessage;
    END;

(* SAVEDS ASM VOID TabHookFunc( REG(a0) struct Hook *hook, REG(a2) Object *obj, REG(a1) struct IntuiMessage *msg ) *)
PROCEDURE TabHookFunc( hook : B.Hook; obj : B.Object; args : B.Args ) : LONGINT;
  VAR
    window : I.WindowPtr;
    mxObj  : B.Object;
    pos    : LONGINT;
    rc     : LONGINT;
    gad    : I.GadgetPtr;
  BEGIN
    mxObj:= y.VAL( B.Object, hook.data );  (* ( Object * )hook->h_Data *)

    (*
    ** Obtain window pointer and
    ** current tab position.
    **)
    rc:= I.GetAttr( B.windowWindow, obj,  window );
    rc:= I.GetAttr( B.mxActive, mxObj, pos );

    (*
    ** What key is pressed?
    **)
    IF args(tabInfo).msg.code = 42H THEN
      IF ( args(tabInfo).msg.qualifier * SET{ IE.lShift, IE.rShift} ) # SET{} THEN
        DEC( pos );
      ELSE
        INC( pos );
      END;
      gad:= y.VAL( I.GadgetPtr, mxObj );
      rc:= I.SetGadgetAttrs( gad^, window, NIL, B.mxActive, pos, u.done );
    END;

  END TabHookFunc;


(*
** Open pages window.
**)
(* struct Window *OpenPagesWindow( void ) *)
PROCEDURE OpenPagesWindow( ): I.WindowPtr;
  VAR
    bt      : ARRAY 3 OF B.Object;
    s       : ARRAY 3 OF B.Object;
    cb      : ARRAY 3 OF B.Object;
    c, p, m : B.Object;
    window  : I.WindowPtr;
    vg1, vg2, vg3, vg4 : B.Object;
    vg3a1, hg3a        : B.Object;
    hg4a               : B.Object;
    vg                 : B.Object;
  BEGIN
    window:= NIL;

    (*
    ** Not yet created?
    **)
    IF waPages = NIL THEN
      (*
      ** Create tabs-object.
      **)
      c:= BM.Tabs( NIL, y.ADR( PageLab ), 0, 0 );

      (*
      ** Put it in the hook data.
      **)
      TabHook.data:= c;

      bt[0]:= BM.PrefButton( y.ADR("Button #_1"), 0 );
      bt[1]:= BM.PrefButton( y.ADR("Button #_2"), 0 );
      bt[2]:= BM.PrefButton( y.ADR("Button #_3"), 0 );

      vg1:= BM.VGroupObject( B.groupSpacing,     B.grSpaceNormal,       (* NormalSpacing *)
                             B.groupSpaceObject, B.defaultWeight,       (* VarSpace(B.defaultWeight) *)
                             B.groupMember, bt[0],
                                            B.lgoFixMinHeight, E.true,  (* FixMinHeight *)
                                            u.done, 0,
                             B.groupMember, bt[1],
                                            B.lgoFixMinHeight, E.true,  (* FixMinHeight *)
                                            u.done, 0,
                             B.groupMember, bt[2],
                                            B.lgoFixMinHeight, E.true,  (* FixMinHeight *)
                                            u.done, 0,
                             B.groupSpaceObject, B.defaultWeight,       (* VarSpace(B.defaultWeight) *)
                             u.done );

      s[0]:= BM.PrefString( y.ADR("String #_1"), NIL, 256, 0 );
      s[1]:= BM.PrefString( y.ADR("String #_2"), NIL, 256, 0 );
      s[2]:= BM.PrefString( y.ADR("String #_3"), NIL, 256, 0 );

      vg2:= BM.VGroupObject( B.groupSpacing,     B.grSpaceNormal,       (* NormalSpacing *)
                             B.groupSpaceObject, B.defaultWeight,       (* VarSpace(B.defaultWeight) *)
                             B.groupMember, s[0],
                                            B.lgoFixMinHeight, E.true,  (* FixMinHeight *)
                                            u.done, 0,
                             B.groupMember, s[1],
                                            B.lgoFixMinHeight, E.true,  (* FixMinHeight *)
                                            u.done, 0,
                             B.groupMember, s[2],
                                            B.lgoFixMinHeight, E.true,  (* FixMinHeight *)
                                            u.done, 0,
                             B.groupSpaceObject, B.defaultWeight,       (* VarSpace(B.defaultWeight) *)
                             u.done );

      cb[0]:= BM.PrefCheckBox( y.ADR("CheckBox #_1"), E.false, 0 );
      cb[1]:= BM.PrefCheckBox( y.ADR("CheckBox #_2"), E.false, 0 );
      cb[2]:= BM.PrefCheckBox( y.ADR("CheckBox #_3"), E.false, 0 );

      vg3a1:= BM.VGroupObject( B.groupSpacing, B.grSpaceNormal,         (* NormalSpacing *)
                               B.groupMember, cb[0], u.done, 0,
                               B.groupMember, cb[1], u.done, 0,
                               B.groupMember, cb[2], u.done, 0,
                               u.done );

      hg3a:= BM.HGroupObject( B.groupSpaceObject, B.defaultWeight,      (* VarSpace(B.defaultWeight) *)
                              B.groupMember, vg3a1,
                                             B.lgoFixMinWidth, E.true,  (* FixMinWidth *)
                                             u.done, 0,
                              B.groupSpaceObject, B.defaultWeight,      (* VarSpace(B.defaultWeight) *)
                              u.done );

      vg3:= BM.VGroupObject( B.groupSpacing,     B.grSpaceNormal,       (* NormalSpacing *)
                             B.groupSpaceObject, B.defaultWeight,       (* VarSpace(B.defaultWeight) *)
                             B.groupMember, hg3a, u.done, 0,
                             B.groupSpaceObject, B.defaultWeight,       (* VarSpace(B.defaultWeight) *)
                             u.done );

      m:= MxGadget( "_Mx Object", y.ADR( MxLab ));

      hg4a:= BM.HGroupObject( B.groupSpaceObject, B.defaultWeight,      (* VarSpace(B.defaultWeight) *)
                              B.groupMember, m, 
                                             B.lgoFixMinWidth,  E.true, (* FixMinSize - from MxGadget*)
                                             B.lgoFixMinHeight, E.true,
                                             u.done, 0,
                              B.groupSpaceObject, B.defaultWeight,      (* VarSpace(B.defaultWeight) *)
                              u.done );

      vg4:= BM.VGroupObject( B.groupSpaceObject, B.defaultWeight,       (* VarSpace(B.defaultWeight) *)
                             B.groupMember, hg4a,
                                            B.lgoFixMinHeight, E.true,  (* FixMinHeight *)
                                            u.done, 0,
                             B.groupSpaceObject, B.defaultWeight,       (* VarSpace(B.defaultWeight) *)
                             u.done );

      p:= BM.PageObject( B.pageMember, vg1,
                         B.pageMember, vg2,
                         B.pageMember, vg3,
                         B.pageMember, vg4,
                         u.done );

      vg:= BM.VGroupObject( B.groupHorizOffset, B.grSpaceNormal,        (* NormalOffset *)
                            B.groupVertOffset,  B.grSpaceNormal,
                            B.groupSpacing,     B.grSpaceNormal,        (* NormalSpacing *)
                            B.groupMember,  c,
                                            B.lgoFixMinHeight, E.true,  (* FixMinHeight *)
                                            u.done, 0,
                            B.groupMember , p, u.done, 0,
                            u.done );


      waPages:= BM.WindowObject( B.windowTitle,         y.ADR("BGUI pages"),
                                 B.windowRMBTrap,       E.true,
                                 B.windowSmartRefresh,  E.true,
                                 B.windowHelpText,      y.ADR( PagesHelp ),
                                 B.windowAutoAspect,    E.true,
                                 B.windowIDCMPHookBits, LONGSET{I.rawKey},
                                 B.windowIDCMPHook,     y.ADR( TabHook ),
                                 B.windowSharedPort,    SharedPort,
                                 B.windowAutoKeyLabel,  E.true,
                                 B.windowMasterGroup,   vg,
                                 u.done );

      (*
      ** Object OK?
      **)
      IF waPages # NIL THEN
        (*
        ** Connect the cycle to the page.
        **)
        BM.AddMap( c, p, y.ADR( Cyc2Page ));
        (*
        ** Set tab-cycling order.
        **)
        B.DoMethod( waPages, B.wmTabCycleOrder, vg1, vg2, vg3, vg4, NIL );
      END;
    END; (* IF waPages = NIL *)

    (*
    ** Object OK?
    **)
    IF waPages # NIL THEN
      (*
      ** Open the window.
      **)
      window:= BM.WindowOpen( waPages );
    END;

    RETURN window;

  END OpenPagesWindow;

(*
** Main entry.
**)
(* VOID StartDemo( void ) *)
PROCEDURE StartDemo( );
  VAR
    main, groups, notif, info, image, bfill, pages, sigwin : I.WindowPtr;
    apm     : wb.AppMessagePtr;
    ap      : wb.WBArgumentsPtr;
    sigmask : LONGSET;
    sigrec  : LONGSET;
    rc, i   : LONGINT;
    appsig  : LONGSET;
    id      : LONGINT;
    running : BOOLEAN;
    name    : E.STRING;
    gad     : I.GadgetPtr;
  BEGIN

    main:= NIL; groups:= NIL; notif:= NIL; info:= NIL; image:= NIL; bfill:= NIL; pages:= NIL;
    sigwin := y.VAL( I.WindowPtr, -1 );
    sigmask:= LONGSET{};
    appsig := LONGSET{};
    running:= TRUE;

    (*
    ** Create the shared message port.
    **)
    SharedPort:= E.CreateMsgPort();
    IF SharedPort # NIL THEN
      (*
      ** Open the main window.
      **)
      main:= OpenMainWindow( appsig );
      IF main # NIL THEN
        (*
        ** OR signal masks.
        **)
        sigmask:= appsig + LONGSET{ SharedPort.sigBit };
        (*
        ** Loop...
        **)
        WHILE running DO
          (*
          ** Wait for the signals to come.
          **)
          sigrec:= E.Wait( sigmask );

          (*
          ** AppWindow signal?
          **)
          IF ( sigrec * appsig ) # LONGSET{} THEN
            (*
            ** Obtain AppWindow messages.
            **)
            LOOP
              apm:= BM.GetAppMsg( waMain );
              IF apm = NIL THEN EXIT END;
              (*
              ** Get all dropped icons.
              **)
              ap:= apm.argList;
              i:= 0;
              WHILE i < apm.numArgs DO (* for ( ap = apm->am_ArgList, i = 0; i < apm->am_NumArgs; i++, ap++ ) *)
                (*
                ** Build fully qualified name.
                **)
                IF D.NameFromLock( ap[i].lock, name, 256 ) THEN END;
                IF D.AddPart( name, ap[i].name^, 256 ) THEN END;
                (*
                ** Add it to the listview.
                **)
                BM.AddEntry( main, lvIconList, y.ADR(name), B.lvapSorted );
                INC( i );
              END; (* WHILE i < apm.numArgs *) (* for *)
              (*
              ** Important! We must reply the message!
              **)
              E.ReplyMsg( apm );
            END; (* LOOP *)
            (*
            ** Switch to the Icon page.
            **)
            gad:= y.VAL( I.GadgetPtr, pgPager );
            rc:= I.SetGadgetAttrs( gad^, main, NIL, B.pageActive, 1, u.done );
          END; (* IF ( sigrec & appsig ) *)

          (*
          ** Find out the which window signalled us.
          **)
          IF ( sigrec * LONGSET{ SharedPort.sigBit }) # LONGSET{} THEN

            LOOP
              sigwin:= BM.GetSignalWindow( waMain );
              IF sigwin = NIL THEN EXIT END;
              (*
              ** Main window signal?
              **)
              IF sigwin = main THEN
                (*
                ** Call the main-window event handler.
                **)
                LOOP
                  CASE BM.HandleEvent( waMain ) OF
                    | B.wmhiNoMore      : EXIT;

                    | B.wmhiCloseWindow,
                      idQuit:
                        running:= FALSE;

                    | idAbout:
                        rc:= Req( main, y.ADR("OK"),
                                  y.ADR("\ec\eb\ed8BGUIDemo \en\ed2\n(C) Copyright 1993-1995 Jaba Development" ));

                    | idMainGroups:
                        (*
                        ** Open groups window.
                        **)
                        IF groups = NIL THEN groups:= OpenGroupsWindow() END;

                    | idMainNotif:
                       (*
                       ** Open notification window.
                       **)
                       IF notif = NIL THEN  notif:= OpenNotifWindow() END;

                    | idMainInfo:
                       (*
                       ** Open infoclass window.
                       **)
                       IF info = NIL THEN info:= OpenInfoWindow() END;

                    | idMainImage:
                       (*
                       ** Open images window.
                       **)
                       IF image = NIL THEN image:= OpenImageWindow() END;

                    | idMainBfill:
                       (*
                       ** Open backfill window.
                       **)
                       IF bfill = NIL THEN bfill:= OpenFillWindow() END;

                    | idMainPages:
                       (*
                       ** Open pages window.
                       **)
                       IF pages = NIL THEN pages:= OpenPagesWindow() END;

                    | idMainIconCont:
                       (*
                       ** Switch back to the main page.
                       **)
                       gad:= y.VAL( I.GadgetPtr, pgPager );
                       rc:= I.SetGadgetAttrs( gad^, main, NIL, B.pageActive, 0, u.done );
                       (*
                       ** Clear all entries from the listview.
                       **)
                       BM.ClearList( main, lvIconList );

                  ELSE
                  END; (* CASE rc *)
                END; (* LOOP *)
              END; (* IF sigwin = main *)

              (*
              ** The code below will close the
              ** specific window.
              **)
              IF sigwin = groups THEN
                LOOP
                  rc:= BM.HandleEvent( waGroups );
                  IF rc = B.wmhiNoMore THEN EXIT END;
                  CASE rc OF
                    | idGroupW0,
                      idGroupW1,
                      idGroupW2,
                      idGroupW3 :
                        id:= rc - idGroupW0;
                        rc:= I.GetAttr( I.stringaLongVal, w[id], rc );
                        rc:= I.SetAttrs( w[id], B.lgoWeight, rc, u.done );

                    | B.wmhiCloseWindow:
                       BM.WindowClose( waGroups );
                       groups:= NIL;

                  ELSE
                  END; (* CASE rc *)
                END; (* LOOP *)
              END; (* IF sigwin = groups *)

              IF sigwin = notif  THEN
                LOOP
                  CASE BM.HandleEvent( waNotif ) OF
                    | B.wmhiNoMore : EXIT;
                    | B.wmhiCloseWindow:
                       BM.WindowClose( waNotif );
                       notif:= NIL;
                  ELSE
                  END; (* CASE rc *)
                END;
              END;

              IF sigwin = info THEN
                LOOP
                  CASE BM.HandleEvent( waInfo ) OF
                    | B.wmhiNoMore : EXIT;
                    | B.wmhiCloseWindow:
                       BM.WindowClose( waInfo );
                       info:= NIL;
                  ELSE
                  END; (* CASE rc *)
                END;
              END;

              IF sigwin = image THEN
                LOOP
                  CASE BM.HandleEvent( waImage ) OF
                    | B.wmhiNoMore : EXIT;
                    | B.wmhiCloseWindow:
                       BM.WindowClose( waImage );
                       image:= NIL;
                  ELSE
                  END; (* CASE rc *)
                END;
              END;

              IF sigwin = bfill THEN
                LOOP
                  CASE BM.HandleEvent( waBfill ) OF
                    | B.wmhiNoMore : EXIT;
                    | B.wmhiCloseWindow:
                       BM.WindowClose( waBfill );
                       bfill:= NIL;
                  ELSE
                  END; (* CASE rc *)
                END;
              END;

              IF sigwin = pages THEN
                LOOP
                  CASE BM.HandleEvent( waPages ) OF
                    | B.wmhiNoMore : EXIT;
                    | B.wmhiCloseWindow:
                       BM.WindowClose( waPages );
                       pages:= NIL;
                  ELSE
                  END; (* CASE rc *)
                END;
              END;
            END; (* LOOP  sigwin:= BM.GetSignalWindow( waMain )> *)
          END; (* IF sigrec * LONGSET{SharedPort.sigBit} # LONGSET{} *)
        END; (* WHILE running *)
      ELSE
        DC.Tell( NIL, "Unable to open main window\n" );
      END; (* IF main # NIL *)
      (*
      ** Dispose of all window objects.
      **)
      IF waPages  # NIL THEN I.DisposeObject( waPages )  END;
      IF waBfill  # NIL THEN I.DisposeObject( waBfill )  END;
      IF waImage  # NIL THEN I.DisposeObject( waImage )  END;
      IF waInfo   # NIL THEN I.DisposeObject( waInfo )   END;
      IF waNotif  # NIL THEN I.DisposeObject( waNotif )  END;
      IF waGroups # NIL THEN I.DisposeObject( waGroups ) END;
      IF waMain   # NIL THEN I.DisposeObject( waMain )   END;
      (*
      ** Delete the shared message port.
      **)
      E.DeleteMsgPort( SharedPort );
    ELSE
      DC.Tell( NIL, "Unable to create a message port.\n" );
    END; (* IF SharedPort # NIL *)

  END StartDemo;


BEGIN
  waMain:= NIL; waGroups:= NIL; waNotif:= NIL;
  waInfo:= NIL; waImage:=  NIL; waBfill:= NIL;
  waPages:= NIL;
  
  B.MakeHook( BackFill, BackFillHook );
  B.MakeHook( TabHook,  TabHookFunc );
  StartDemo;

END BguiDemo.
