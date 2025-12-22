(***************************************************************************

     $RCSfile: Triton.mod $
  Description: Interface to triton.library

   Created by: Helmuth Ritzer
    $Revision: 1.0 $
      $Author: hr $
        $Date: 1995/01/21 16:06:42 $

  This is a modified version of the interface module for
  AmigaOberon done by Peter Fröhlich.

  This release contains no translations of the C macros.

***************************************************************************
Updated by: Morten Bjergstrøm
EMail: mbjergstroem@hotmail.com
)

<* STANDARD- *>

MODULE [2] Triton;

IMPORT
  SYS := SYSTEM, Kernel, e := Exec, u := Utility, gfx := Graphics,
  i := Intuition, gt := GadTools, w := Workbench;


(*****************************************************************************)

CONST

  tritonName *  = "triton.library";


(*****************************************************************************)

TYPE
  MessagePtr*    = POINTER TO Message;
  AppPtr*        = POINTER TO App;
  DimensionsPtr* = POINTER TO Dimensions;
  ProjectPtr*    = POINTER TO Project;

  DisplayObjectPtr* = POINTER TO RECORD END;
(* --- The Triton message --- *)

  Message* = RECORD
    project-   : ProjectPtr; (* The project which triggered the message       *)
    id-        : e.ULONG;    (* The object's ID (where appropriate)           *)
    class-     : e.ULONG;    (* The Triton message class                      *)
    data-      : e.ULONG;    (* The class-specific data                       *)
    code-      : e.ULONG;    (* \ Currently only used                         *)
    qualifier- : e.ULONG;    (* / by TRMS_KEYPRESSED                          *)
    seconds-   : e.ULONG;    (* \ Copy of system clock time (Only where       *)
    micros-    : e.ULONG;    (* / available! If not set, trm_Seconds is NULL) *)
    app-       : AppPtr;     (* The project's application                     *)
  END;

(* --- The Application Structure --- *)

  App* = RECORD (* This structure is PRIVATE! *)
    memPool  : e.ADDRESS;    (* The memory pool    *)
    bitMask  : e.LONGBITS;   (* Bits to Wait() for *)
    name     : e.STRPTR;     (* Unique name        *)
    longName : e.STRPTR;     (* User-readable name *)
    info     : e.STRPTR;     (* Info string        *)
    version  : e.STRPTR;     (* Version            *)
    release  : e.STRPTR;     (* Release            *)
    date     : e.STRPTR;     (* Compilation date   *)
    appPort  : e.MsgPortPtr; (* AppMessage port    *)
    idcmpPort   : e.MsgPortPtr;    (* IDCMP message port          *)
    prefs       : e.ADDRESS;       (* Pointer to Triton app prefs *)
    lastProject : ProjectPtr;      (* Used for menu item linking  *)
    (*inputEvent  : IE.InputEventPtr*) (* Used for RAWKEY conversion  *)
  END;

(* --- The Dimensions Structure --- *)

  Dimensions* = RECORD
    left*     : e.UWORD;            (* Left                  *)
    top*      : e.UWORD;            (* Top                   *)
    width*    : e.UWORD;            (* Width                 *)
    height*   : e.UWORD;            (* Height                *)
    left2*    : e.UWORD;            (* Left                  *)
    top2*     : e.UWORD;            (* Top                   *)
    width2*   : e.UWORD;            (* Width                 *)
    height2*  : e.UWORD;            (* Height                *)
    zoomed*   : e.BOOL;             (* Window zoomed?        *)
    reserved* : ARRAY 3 OF e.UWORD; (* For future expansions *)
  END;

(* --- The Project Structure --- *)

  Project* = RECORD (* This structure is PRIVATE! *)
    app                  : AppPtr;            (* Our application *)
    screen               : i.ScreenPtr;       (* Our screen, always valid *)
    lockedPubScreen      : i.ScreenPtr;       (* Only valid if we're using a PubScreen *)
    window               : i.WindowPtr;       (* The window *)
    id                   : e.ULONG;           (* The window ID *)
    appWindow            : w.AppWindowPtr;    (* AppWindow for icon dropping *)
    idcmpFlags           : e.ULONG;           (* The IDCMP flags *)
    flags                : e.ULONG;           (* Triton window flags *)
    newMenu              : gt.NewMenuPtr;     (* The newmenu stucture built by Triton *)
    newMenuSize          : e.ULONG;           (* The number of menu items in the list *)
    menu                 : i.MenuPtr;         (* The menu structure *)
    nextSelect           : e.UWORD;           (* The next selected menu item    *)
    visualInfo           : e.ADDRESS;         (* The VisualInfo of our window *)
    drawInfo             : i.DrawInfoPtr;     (* The DrawInfo of the screen *)
    dimensions           : DimensionsPtr;     (* User-supplied dimensions *)
    windowStdHeight      : e.ULONG;           (* The standard height of the window *)
    leftBorder           : e.ULONG;           (* The width of the left window border *)
    rightBorder          : e.ULONG;           (* The width of the right window border *)
    topBorder            : e.ULONG;           (* The height of the top window border *)
    bottomBorder         : e.ULONG;           (* The height of the bottom window border *)
    innerWidth           : e.ULONG;           (* The inner width of the window *)
    innerHeight          : e.ULONG;           (* The inner height of the window *)
    zipDimensions        : ARRAY 4 OF e.WORD; (* The dimensions for the zipped window *)
    aspectFixing         : e.UWORD;           (* Pixel aspect correction factor *)
    objectList           : e.MinList;         (* The list of display objects *)
    menuList             : e.MinList;         (* The list of menus *)
    idList               : e.MinList;         (* The ID linking list (menus & objects) *)
    memPool              : e.ADDRESS;         (* The memory pool for the lists *)
    hasObjects           : e.BOOL;            (* Do we have display objects ? *)
    propAttr             : gfx.TextAttrPtr;   (* The proportional font attributes *)
    fixedWidthAttr       : gfx.TextAttrPtr;   (* The fixed-width font attributes *)
    propFont             : gfx.TextFontPtr;   (* The proportional font *)
    fixedWidthFont       : gfx.TextFontPtr;   (* The fixed-width font *)
    openedPropFont       : e.BOOL;            (* \ Have we opened the fonts ? *)
    openedFixedWidthFont : e.BOOL;            (* / *)
    totalPropFontHeight  : e.UWORD;           (* Height of prop font incl. underscore *)
    backfillType         : e.ULONG;           (* The backfill type *)
    backfillHook         : u.HookPtr;         (* The backfill hook *)
    gadToolsGadgetList   : i.GadgetPtr;       (* List of GadTools gadgets *)
    prevGadget           : i.GadgetPtr;       (* Previous GadTools gadget *)
    newGadget            : gt.NewGadgetPtr;   (* GadTools NewGadget *)
    invisibleRequest     : i.RequesterPtr;    (* The invisible blocking requester *)
    isUserLocked         : e.BOOL;            (* Project locked by the user? *)
    currentID            : e.ULONG;           (* The currently keyboard-selected ID *)
    isCancelDown         : e.BOOL;            (* Cancellation key pressed? *)
    isShortcutDown       : e.BOOL;            (* Shortcut key pressed? *)
    underscore           : e.UBYTE;           (* The underscore character *)
    escClose             : e.BOOL;            (* Close window on Esc ? *)
    delZip               : e.BOOL;            (* Zip window on Del ? *)
    pubScreenFallBack    : e.BOOL;            (* Fall back onto default public screen ? *)
    fontFallBack         : e.BOOL;            (* Fall back to topaz.8 ? *)
    oldWidth             : e.UWORD;           (* Old window width *)
    oldHeight            : e.UWORD;           (* Old window height *)
    quickHelpWindow      : i.WindowPtr;       (* The QuickHelp window *)
    quickHelpObject      : DisplayObjectPtr;  (* Object for which help is popped up *)
    ticksPassed          : e.ULONG;           (* IntuiTicks passed since last MouseMove *)
  END;

CONST

(* --- Message classes --- *)

  msCloseWindow* = 1; (* The window should be closed *)
  msError*       = 2; (* An error occured. Error code in trm_Data *)
  msNewValue*    = 3; (* Object's value has changed. New value in trm_Data *)
  msAction*      = 4; (* Object has triggered an action *)
  msIconDropped* = 5; (* Icon dropped over window (ID=0) or DropBox. AppMessage* in trm_Data *)
  msKeyPressed*  = 6; (* Key pressed. trm_Data contains ASCII code, trm_Code raw code and *)
                                    (* trm_Qualifier contains qualifiers *)
  msHelp*        = 7; (* The user requested help for specified ID *)
  msDiskInserted*= 8; (* A disk has been inserted into a drive *)
  msDiskRemoved* = 9; (* A disk has been removed from a drive *)

(* --- Triton error codes --- *)

  erOk*              = 0;  (* No error *)
  erAllocMem*        = 1;  (* Not enough memory *)
  erOpenWindow*      = 2;  (* Can't open window *)
  erWindowTooBig*    = 3;  (* Window would be too big for screen *)
  erDrawInfo*        = 4;  (* Can't get screen's DrawInfo *)
  erOpenFont*        = 5;  (* Can't open font *)
  erCreateMsgPort*   = 6;  (* Can't create message port *)
  erInstallObject*   = 7;  (* Can't create an object *)
  erCreateClass*     = 8;  (* Can't create a class *)
  erNoLockPubScreen* = 9;  (* Can't lock public screen *)
  erInvalid*         = 10; (* Invalid NewMenu structure -> probably a bug in Triton *)
  erNoMem*           = 11; (* Not enough memory for menu creation *)
  erOtherCreate*     = 12; (* Other error while creating the menus *)
  erLayout*          = 13; (* GadTools can't layout the menus *)
  erCreateContext*   = 14; (* Can't create gadget context *)
  erMaxErrorNum      = 15; (* PRIVATE! *)

(* Object messages *)
  omNew*             = 1;  (* Create object *)
  omInstall*         = 2;  (* Tell object to install itself in the window *)
  omRefresh*         = 4;  (* Refresh object *)
  omRemove*          = 6;  (* Remove object from window *)
  omDispose*         = 7;  (* Dispose an object's private data *)
  omGetAttribute*    = 8;  (* Get an object's attribute *)
  omSetAttribute*    = 9;  (* Set an object's attribute *)
  omEvent*           = 10; (* IDCMP event *)
  omDisabled*        = 11; (* Disabled object *)
  omEnabled*         = 12; (* Enabled object *)
  omKeyDown*         = 13; (* Key pressed *)
  omRepeatedKeyDown* = 14; (* Key pressed repeatedly *)
  omKeyUp*           = 15; (* Key released *)
  omKeyCancelled*    = 16; (* Key cancelled *)
  omCreateClass*     = 17; (* Create class-specific data *)
  omDisposeClass*    = 18; (* Dispose class-specific data *)
  omHit*             = 22; (* Find an object for a coordinate pair *)
  omActivate*        = 23; (* Activate an object *)

(* --- Tags for OpenWindow() --- *)

(* Window *)
  wiTitle*              = (u.user+1);  (* STRPTR: The window title *)
  wiFlags*              = (u.user+2);  (* See below for window flags *)
  wiUnderscore*         = (u.user+3);  (* POINTER TO CHAR: The underscore for menu and gadget shortcuts *)
  wiPosition*           = (u.user+4);  (* Window position, see below *)
  wiCustomScreen*       = (u.user+5);  (* ScreenPtr *)
  wiPubScreen*          = (u.user+6);  (* ScreenPtr, must have been locked! *)
  wiPubScreenName*      = (u.user+7);  (* STRPTR, Triton is doing the locking *)
  wiPropFontAttr*       = (u.user+8);  (* TextAttrPtr: The proportional font *)
  wiFixedWidthFontAttr* = (u.user+9);  (* TextAttrPtr: The fixed-width font *)
  wiBackfill*           = (u.user+10); (* The backfill type, see below *)
  wiID*                 = (u.user+11); (* ULONG: The window ID *)
  wiDimensions*         = (u.user+12); (* DimensionsPtr *)
  wiScreenTitle*        = (u.user+13); (* STRPTR : The screen title *)
  wiQuickHelp*          = (u.user+14); (* BOOL: Quick help active? *)

(* Menus *)
  mnTitle* = (u.user+101); (* STRPTR: Menu *)
  mnItem*  = (u.user+102); (* STRPTR: Menu item *)
  mnSub*   = (u.user+103); (* STRPTR: Menu subitem *)
  mnFlags* = (u.user+104); (* See below for flags *)

(* Menu attributes *)
  mfCheckIt*  = 1; (* Leave space for a checkmark *)
  mfChecked*  = 2; (* Check the item (includes TRMF_CHECKIT) *)
  mfDisabled* = 4; (* Ghost the menu/item *)

(* General object attributes *)
  atID*        = (u.user+150); (* The object's/menu's ID *)
  atFlags*     = (u.user+151); (* The object's flags *)
  atValue*     = (u.user+152); (* The object's value *)
  atText*      = (u.user+153); (* The object's text *)
  atDisabled*  = (u.user+154); (* Disabled object? *)
  atBackfill*  = (u.user+155); (* Backfill pattern *)
  atMinWidth*  = (u.user+156); (* Minimum width *)
  atMinHeight* = (u.user+157); (* Minimum height *)

  user* = (u.user+800); (* Add something to get your own IDs *)

(* Magic code *)
  magicObjBeg* = (u.user+200); (* PRIVATE! *)
  magicObjEnd* = (u.user+999); (* PRIVATE! *)
  magicSpcBeg* = (u.user+900); (* PRIVATE! *)
  magicSpcEnd* = (u.user+999); (* PRIVATE! *)

(* --- Window flags --- *)

  wiBackDrop*        = 000000001H; (* Create a backdrop borderless window *)
  wiNoDragBar*       = 000000002H; (* Don't use a dragbar *)
  wiNoDepthGadget*   = 000000004H; (* Don't use a depth-gadget *)
  wiNOCloseGadget*   = 000000008H; (* Don't use a close-gadget *)
  wiNoActivate*      = 000000010H; (* Don't activate window *)
  wiNoEscClose*      = 000000020H; (* Don't send closeWindow when Esc is pressed *)
  wiNoPScrFallback*  = 000000040H; (* Don't fall back onto default PubScreen *)
  wiNoZipGadget*     = 000000080H; (* Don't use a zip-gadget *)
  wiZipCenterTop*    = 000000100H; (* Center the zipped window on the title bar *)
  wiNoMinTextWidth*  = 000000200H; (* Minimum window width not according to title text *)
  wiNoSizeGadget*    = 000000400H; (* Don't use a sizing-gadget *)
  wiNoFontFallback*  = 000000800H; (* Don't fall back to topaz.8 *)
  wiNoDelZip*        = 000001000H; (* Don't zip the window when Del is pressed *)
  wiSimpleRefresh*   = 000002000H; (* Use simple refresh instead of smart refresh *)
  wiZipToCurrentPos* = 000004000H; (* Will zip the window at the current position (OS3.0+) *)
  wiAppWindow*       = 000008000H; (* Create an AppWindow without using class_dropbox *)
  wiActivateStrGad*  = 000010000H; (* Activate the first string gadget after opening the window *)
  wfHelp*            = 000020000H; (* Pressing <Help> will create a msHelp message *)
  wfSystemAction*    = 000040000H; (* System status messages will be sent (V4) *)


(* --- Menu flags --- *)

  mnCheckIt*  = 000000001H; (* Leave space for a checkmark *)
  mnChecked*  = 000000002H; (* Check the item (includes TRMF_CHECKIT) *)
  mnDisabled* = 000000004H; (* Ghost the menu/item *)

(* --- Window positions --- *)

  wpDefault*       = 0;    (* Let Triton choose a good position *)
  wpBelowTitlebar* = 1;    (* Left side of screen, below title bar *)
  wpCenterTop*     = 1025; (* Top of screen, centered on the title bar *)
  wpTopLeftScreen* = 1026; (* Top left corner of screen *)
  wpCenterScreen*  = 1027; (* Centered on the screen *)
  wpCenterDisplay* = 1028; (* Centered on the currently displayed clip *)
  wpMousePointer*  = 1029; (* Under the mouse pointer *)
  wpAboveCoords*   = 2049; (* Above coordinates from the dimensions struct *)
  wpBelowCoords*   = 2050; (* Below coordinates from the dimensions struct *)
  wpMagic          = 1024; (* PRIVATE! *)

(* --- Backfill types --- *)

  bfWindowBack*       = 0;  (* Window backfill colors *)
  bfRequesterBack*    = 1;  (* Requester backfill colors *)
  bfNone*             = 2;  (* No backfill (= Fill with BACKGROUNDPEN) *)
  bfShine*            = 3;  (* Fill with SHINEPEN *)
  bfShineShadow*      = 4;  (* Fill with SHINEPEN + SHADOWPEN *)
  bfShineFill*        = 5;  (* Fill with SHINEPEN + FILLPEN *)
  bfShineBackground*  = 6;  (* Fill with SHINEPEN + BACKGROUNDPEN *)
  bfShadow*           = 7;  (* Fill with SHADOWPEN *)
  bfShadowFill*       = 8;  (* Fill with SHADOWPEN + FILLPEN *)
  bfShadowBackground* = 9;  (* Fill with SHADOWPEN + BACKGROUNDPEN *)
  bfFill*             = 10; (* Fill with FILLPEN *)
  bfFillBackground*   = 11; (* Fill with FILLPEN + BACKGROUNDPEN *)

(* --- System images --- *)

  siUSButtonBack* = 10002; (* Unselected button backfill *)
  siSButtonBack*  = 10003; (* Selected button backfill   *)

(* --- Display Object flags --- *)

(* General flags *)
  ofRaised*      = 000000001H; (* Raised object *)
  ofHoriz*       = 000000002H; (* Horizontal object \ Works automatically *)
  ofVert*        = 000000004H; (* Vertical object   / in groups *)
  ofRightAlign*  = 000000008H; (* Align object to the right border if available *)
  ofGeneralMask* = 0000000FFH; (* PRIVATE! *)

(* Text flags *)
  txNoUnderscore* = 000000100H;   (* Don't interpret underscores *)
  txHighlight*    = 000000200H;   (* Highlight text *)
  tx3D*           = 000000400H;   (* 3D design *)
  txBold*         = 000000800H;   (* Softstyle 'bold' *)
  txTitle*        = 000001000H;   (* A title (e. of a group) *)
  txMultiLine*    = 000002000H;   (* A multi-line text. See TR_PrintText() autodoc clip *)
  txRightAlign*   = ofRightAlign; (* Align text to the right border *)
  txCenter*       = 000004000H;   (* Center text *)
  txSelected*     = 000008000H;   (* PRIVATE! *)

(* --- Menu entries --- *)

  menuBarLabel* = -1; (* A barlabel instead of text *)

(* --- Tags for CreateApp() --- *)

  caName*     = (u.user+1);
  caLongName* = (u.user+2);
  caInfo*     = (u.user+3);
  caVersion*  = (u.user+4);
  caRelease*  = (u.user+5);
  caDate*     = (u.user+6);

(* --- Tags for EasyRequest() --- *)

  ezReqPos*      = (u.user+1);
  ezLockProject* = (u.user+2);
  ezReturn*      = (u.user+3);
  ezTitle*       = (u.user+4);
  ezActivate*    = (u.user+5);

(* --- Default classes, attributes and flags --- *)

(* Tag bases *)
  tgOAT  = (u.user+400H);
  tgOBJ  = (u.user+100H);
  tgOAT2 = (u.user+80H);
  tgPAT  = u.user;


(* Display object *)
  obDisplayObject*   = (tgOBJ+3CH);  (* A basic display object *)
  doQuickHelpString* = (tgOAT+1E3H);

(* Classes *)
  obButton*   = (u.user+305); (* A BOOPSI button gadget *)
  obCheckBox* = (u.user+303); (* A checkbox gadget *)
  obCycle*    = (u.user+310); (* A cycle gadget *)
  obFrameBox* = (u.user+306); (* A framing box *)
  obDropBox*  = (u.user+312); (* An icon drop box *)
  grHoriz*    = (u.user+201); (* Horizontal group, see below for types *)
  grVert*     = (u.user+202); (* Vertical group, see below for types *)
  grEnd*      = (u.user+203); (* End of a group *)
  obLine*     = (u.user+301); (* A simple line *)
  obPalette*  = (u.user+307); (* A palette gadget *)
  obScroller* = (u.user+309); (* A scroller gadget *)
  obSlider*   = (u.user+308); (* A slider gadget *)
  obSpace*    = (u.user+901); (* The spaces class *)
  obString*   = (u.user+311); (* A string gadget *)
  obText*     = (u.user+304); (* A line of text *)
  obListview* = (u.user+313); (* A listview gadget *)
  obProgress* = (u.user+314); (* A progress indicator *)
  obDragItem* = (tgOBJ+3EH);  (* A draggable item *)
  obImage*    = (tgOBJ+3BH);  (* An image *)

(* Button *)
  buReturnOk*  = 000010000H; (* <Return> answers the button *)
  buEscOk*     = 000020000H; (* <Esc> answers the button *)
  buShifted*   = 000040000H; (* Shifted shortcut only *)
  buUnshifted* = 000080000H; (* Unshifted shortcut only *)
  buYResize*   = 000100000H; (* Button resizable in Y direction *)

  btText*      = 0;          (* Text button *)
  btGetFile*   = 1;          (* GetFile button *)
  btGetDrawer* = 2;          (* GetDrawer button *)
  btGetEntry*  = 3;          (* GetEntry button *)

(* Group *)
  grPropShare*  = 000000000H; (* Divide objects proportionally *)
  grEqualShare* = 000000001H; (* Divide objects equally *)
  grPropSpaces* = 000000002H; (* Divide spaces proportionally *)
  grArray*      = 000000004H; (* Top-level array group *)
  grAlign*      = 000000008H; (* Align resizeable objects in secondary dimension *)
  grCenter*     = 000000010H; (* Center unresizeable objects in secondary dimension *)
  grFixHoriz*   = 000000020H; (* Don't allow horizontal resizing *)
  grFixVert*    = 000000040H; (* Don't allow vertical resizing *)
  grIndep*      = 000000080H; (* Group is independant of surrounding array *)

(* Scroller *)
  scTotal*   = (u.user+1504);
  scVisible* = (u.user+1505);

(* Slider *)
  slMin* = (u.user+1502);
  slMax* = (u.user+1503);

(* Space *)
  stNone*   = 1; (* No space *)
  stSmall*  = 2; (* Small space *)
  stNormal* = 3; (* Normal space (default) *)
  stBig*    = 4; (* Big space *)


(* Listview *)
  lvTop*          = (u.user+1506);
  lvReadOnly*     = 000010000H;    (* A read-only list *)
  lvSelect*       = 000020000H;    (* You may select an entry *)
  lvShowSelected* = 000040000H;    (* Selected entry will be shown *)
  lvNoCursorKeys* = 000080000H;    (* Don't use arrow keys *)
  lvNoNumPadKeys* = 000100000H;    (* Don't use numeric keypad keys *)
  lvFWFont*       = 000200000H;    (* Use the fixed-width font *)
  lvNoGap*        = 000400000H;    (* Don`t leave a gap below the list *)

(* Cycle *)
  cyMX*          = 00010000H; (* Unfold the cylce gadget to a MX gadget     *)
  cyRightLabels* = 00020000H; (* Put the labels to the right of a MX gadget *)

(* Frame box *)
  fbGrouping* = 00000001H; (* A grouping box   *)
  fbFraming*  = 00000002H; (* A framing box    *)
  fbText*     = 00000004H; (* A text container *)

(* Image *)
  imBOOPSI* = 00010000H; (* Use a BOOPSI IClass image *)

(* String gadget *)
  stFilter* = tgOAT+01E4H;
  stInvisible*         = 10000H; (* A password gadget -> invisible typing *)
  stNoReturnBroadCast* = 20000H; (* <Return> keys will not be broadcast to the window *)
  stFloat*             = 40000H; (* Separators "." and "," will be accepted only once *)

VAR

  base *: e.LibraryPtr;
  supportApp : AppPtr;


(** --- Library Functions ------------------------------------------------ *)

PROCEDURE OpenProject* [base,-30]
  ( app[9]: AppPtr; tagList[8]: ARRAY OF u.TagItem )
  : ProjectPtr;
PROCEDURE OpenProjectTags* [base,-30]
  ( app[9]: AppPtr; tag[8]..: u.Tag )
  : ProjectPtr;
PROCEDURE CloseProject*      [base,-36]
  ( project[8]: ProjectPtr );
PROCEDURE FirstOccurance* [base,-42]
  ( ch[0]: e.UBYTE; str[8]: e.STRPTR )
  : e.LONG;
PROCEDURE NumOccurances* [base,-48]
  ( ch[0]: e.UBYTE; str[8]: e.STRPTR )
  : e.LONG;
PROCEDURE GetErrorString* [base,-54]
  ( num[0]: e.UWORD): e.STRPTR;
PROCEDURE CloseWindowSafely* [base,-126]
  ( win[8]: i.WindowPtr );
PROCEDURE GetMsg* [base,-108]
  ( app[9]: AppPtr )
  : MessagePtr;
PROCEDURE ReplyMsg* [base,-114]
  ( msg[9]: MessagePtr );
PROCEDURE Wait* [base,-120]
  ( app[9]: AppPtr; otherbits[0]: e.ULONG )
  : e.ULONG;
PROCEDURE SetAttribute* [base,-60]
  ( prj[8]: ProjectPtr; id[0]: e.ULONG; attr[1]: e.ULONG; value[2]: e.ULONG );
PROCEDURE GetAttribute* [base,-66]
  ( prj[8]: ProjectPtr; id[0]: e.ULONG; attr[1]: e.ULONG )
  : e.ULONG;
PROCEDURE LockProject* [base,-72]
  ( prj[8]: ProjectPtr );
PROCEDURE UnlockProject* [base,-78]
  ( prj[8]: ProjectPtr );
PROCEDURE AutoRequest* [base,-84]
  ( app[9]: AppPtr; lockProject[8]: ProjectPtr; requestTRWindowTags[10]: ARRAY OF u.TagItem )
  : e.ULONG;
PROCEDURE AutoRequestTags* [base,-84]
  ( app[9]: AppPtr; lockProject[8]: ProjectPtr; tag[10]..: u.Tag )
  : e.ULONG;
PROCEDURE EasyRequest* [base,-90]
  ( app[9]: AppPtr; bodyFmt[10]: e.STRPTR; gadFmt[11]: e.STRPTR; tagList[8]: ARRAY OF u.TagItem )
  : e.ULONG;
PROCEDURE EasyRequestTags* [base,-90]
  ( app[9]: AppPtr; bodyFmt[10]: e.STRPTR; gadFmt[11]: e.STRPTR; tag[8]..: u.Tag )
  : e.ULONG;
PROCEDURE CreateApp* [base,-96]
  ( appTags[9]: ARRAY OF u.TagItem )
  : AppPtr;
PROCEDURE DeleteApp* [base,-102]
  ( app[9]: AppPtr );
PROCEDURE CreateAppTags* [base,-96]
  ( appTags[9]..: u.Tag )
  : AppPtr;
PROCEDURE ObtainWindow* [base,-150]
  (prj[8]: ProjectPtr)
  : i.WindowPtr;
PROCEDURE ReleaseWindow* [base,-156]
  (win[8]: i.WindowPtr);
PROCEDURE SendMessage* [base,-162]
  (prj[8]: ProjectPtr; id[0]: e.ULONG; msgID[1]: MessagePtr)
  : e.ULONG;
PROCEDURE GetLastError* [base,-132]
  (app[9]: AppPtr)
  : e.UWORD;
PROCEDURE LockScreen* [base,-138]
  (prj[8]: ProjectPtr)
  : i.ScreenPtr;
PROCEDURE UnlockScreen* [base,-144]
  (scr[8]: i.ScreenPtr);
(* I'm not sure where this call belongs. [phf] *)
(*
extern BOOL                __saveds __asm  TR_AddClass(register __d0 ULONG tag, register __a0 ULONG ( *dispatcher)());
*)


(*--- Library Base variable --------------------------------------------*)

<*$LongVars-*>

(*------------------------------------*)
PROCEDURE* [0] CloseLib (VAR rc : LONGINT);

BEGIN (* CloseLib *)
  IF base # NIL THEN e.CloseLibrary (base) END
END CloseLib;

BEGIN
  (* supportApp is not used currently *)
  supportApp := NIL;

  base := e.OpenLibrary (tritonName, 0);
  IF base # NIL THEN Kernel.SetCleanup (CloseLib) END;
END Triton.
