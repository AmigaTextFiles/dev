(* ==================================================================== *)
(*

  :Program.     Triton.MOD
  :Contents.    interface to Stefan Zeiger's triton.library

  :Copyright.   This module is C 1994 by Peter Fröhlich & Volker Stolz.
  :Copyright.   It may be distributed freely as long as it remains unchanged.

  :Author.      Peter Fröhlich [phf]
  :Address.     Peter Fröhlich, Ebenböckstraße 19, D-81241 München
  :Address.     Z-NETZ: p.froehlich@amc.insider.sub.de 

  :Author.      Volker Stolz [vs]
  :Address.     Volker Stolz, Kückstraße 54, D-52499 Baesweiler
  :Address.     Vok@TinDrum.tng.oche.de

  :Language.    Oberon (revised)
  :Translator.  Amiga Oberon V3.11d

  :History.     V0.1 [phf] 01-May-1994 first release to S. Zeiger

  :History.     V0.2 [vs]  April 1995
                - changed the Window-Flags prefixes from "wi" to "wf"
                - new features implemented from C-source
                - changed the Menu-Flags prefixes from "mn" to "mf"
  :History.     V0.3 [vs] 06-May-1995
                - updated for Triton-Release V1.3

  :Remark.      The interface currently supports only direct use
  :Remark.      of the library, ie. the infamous C macros have not
  :Remark.      been ported yet.
  :Remark.         Note that the interface does not AmigaOberon's
  :Remark.      LONGSET since this would result in cumbersome casts
  :Remark.      in the taglists.
  :Remark.         Remember to ensure "Triton.base # NIL" before
  :Remark.      calling procedures of the module.

*)
(* ==================================================================== *)

MODULE Triton;

IMPORT
  E* := Exec, S* := SYSTEM, U* := Utility, W* := Workbench,
  I* := Intuition, GT* := GadTools, G* := Graphics, IE* := InputEvent;

CONST
  tritonName* = "triton.library";
  triton10Version* = 1;
  triton11Version* = 2;
  triton12Version* = 3;
  triton13Version* = 4;

TYPE
  MessagePtr*    = UNTRACED POINTER TO Message;
  AppPtr*        = UNTRACED POINTER TO App;
  DimensionsPtr* = UNTRACED POINTER TO Dimensions;
  ProjectPtr*    = UNTRACED POINTER TO Project;

  DisplayObjectPtr* = UNTRACED POINTER TO STRUCT END;

(* --- The Triton message --- *)

  Message* = STRUCT
    project-   : ProjectPtr; (* The project which triggered the message       *)
    id-        : E.ULONG;    (* The object's ID (where appropriate)           *)
    class-     : E.ULONG;    (* The Triton message class                      *)
    data-      : E.ULONG;    (* The class-specific data                       *)
    code-      : E.ULONG;    (* \ Currently only used                         *)
    qualifier- : E.ULONG;    (* / by TRMS_KEYPRESSED                          *)
    seconds-   : E.ULONG;    (* \ Copy of system clock time (Only where       *)
    micros-    : E.ULONG;    (* / available! If not set, trm_Seconds is NULL) *)
    app-       : AppPtr;     (* The project's application                     *)
  END;

(* --- The Application Structure --- *)

  App* = STRUCT (* This structure is mostly PRIVATE! *)
    memPool     : E.ADDRESS;       (* The memory pool             *)
    bitMask-    : E.LONGBITS;      (* Bits to Wait() for PUBLIC ! *)
    name-       : E.STRPTR;        (* Unique name           "     *)
    longName-   : E.STRPTR;        (* User-readable name    "     *)
    info-       : E.STRPTR;        (* Info string           "     *)
    version-    : E.STRPTR;        (* Version               "     *)
    release-    : E.STRPTR;        (* Release               "     *)
    date-       : E.STRPTR;        (* Compilation date      "     *)
    appPort     : E.MsgPortPtr;    (* AppMessage port             *)
    idcmpPort   : E.MsgPortPtr;    (* IDCMP message port          *)
    prefs       : E.ADDRESS;       (* Pointer to Triton app prefs *)
    lastProject : ProjectPtr;      (* Used for menu item linking  *)
    inputEvent  : IE.InputEventPtr (* Used for RAWKEY conversion  *)
  END;

(* --- The Dimensions Structure --- *)

  Dimensions* = STRUCT
    left*     : E.UWORD;            (* Left                  *)
    top*      : E.UWORD;            (* Top                   *)
    width*    : E.UWORD;            (* Width                 *)
    height*   : E.UWORD;            (* Height                *)
    left2*    : E.UWORD;            (* Left                  *)
    top2*     : E.UWORD;            (* Top                   *)
    width2*   : E.UWORD;            (* Width                 *)
    height2*  : E.UWORD;            (* Height                *)
    zoomed*   : E.BOOL;             (* Window zoomed?        *)
    reserved* : ARRAY 3 OF E.UWORD; (* For future expansions *)
  END;

(* --- The Project Structure --- *)

  Project* = STRUCT (* This structure is PRIVATE! *)
    app                  : AppPtr;            (* Our application *)
    screen               : I.ScreenPtr;       (* Our screen, always valid *)
    lockedPubScreen      : I.ScreenPtr;       (* Only valid if we're using a PubScreen *)
    window               : I.WindowPtr;       (* The window *)
    id                   : E.ULONG;           (* The window ID *)
    appWindow            : W.AppWindowPtr;    (* AppWindow for icon dropping *)
    idcmpFlags           : E.ULONG;           (* The IDCMP flags *)
    flags                : E.ULONG;           (* Triton window flags *)
    newMenu              : GT.NewMenuPtr;     (* The newmenu stucture built by Triton *)
    newMenuSize          : E.ULONG;           (* The number of menu items in the list *)
    menu                 : I.MenuPtr;         (* The menu structure *)
    nextSelect           : E.UWORD;           (* The next selected menu item    *)
    visualInfo           : E.ADDRESS;         (* The VisualInfo of our window *)
    drawInfo             : I.DrawInfoPtr;     (* The DrawInfo of the screen *)
    dimensions           : DimensionsPtr;     (* User-supplied dimensions *)
    windowStdHeight      : E.ULONG;           (* The standard height of the window *)
    leftBorder           : E.ULONG;           (* The width of the left window border *)
    rightBorder          : E.ULONG;           (* The width of the right window border *)
    topBorder            : E.ULONG;           (* The height of the top window border *)
    bottomBorder         : E.ULONG;           (* The height of the bottom window border *)
    innerWidth           : E.ULONG;           (* The inner width of the window *)
    innerHeight          : E.ULONG;           (* The inner height of the window *)
    zipDimensions        : ARRAY 4 OF E.WORD; (* The dimensions for the zipped window *)
    aspectFixing         : E.UWORD;           (* Pixel aspect correction factor *)
    objectList           : E.MinList;         (* The list of display objects *)
    menuList             : E.MinList;         (* The list of menus *)
    idList               : E.MinList;         (* The ID linking list (menus & objects) *)
    memPool              : E.ADDRESS;         (* The memory pool for the lists *)
    hasObjects           : E.BOOL;            (* Do we have display objects ? *)
    propAttr             : G.TextAttrPtr;     (* The proportional font attributes *)
    fixedWidthAttr       : G.TextAttrPtr;     (* The fixed-width font attributes *)
    propFont             : G.TextFontPtr;     (* The proportional font *)
    fixedWidthFont       : G.TextFontPtr;     (* The fixed-width font *)
    openedPropFont       : E.BOOL;            (* \ Have we opened the fonts ? *)
    openedFixedWidthFont : E.BOOL;            (* / *)
    totalPropFontHeight  : E.UWORD;           (* Height of prop font incl. underscore *)
    backfillType         : E.ULONG;           (* The backfill type *)
    backfillHook         : U.HookPtr;         (* The backfill hook *)
    gadToolsGadgetList   : I.GadgetPtr;       (* List of GadTools gadgets *)
    prevGadget           : I.GadgetPtr;       (* Previous GadTools gadget *)
    newGadget            : GT.NewGadgetPtr;   (* GadTools NewGadget *)
    invisibleRequest     : I.RequesterPtr;    (* The invisible blocking requester *)
    isUserLocked         : E.BOOL;            (* Project locked by the user? *)
    currentID            : E.ULONG;           (* The currently keyboard-selected ID *)
    isCancelDown         : E.BOOL;            (* Cancellation key pressed? *)
    isShortcutDown       : E.BOOL;            (* Shortcut key pressed? *)
    underscore           : E.UBYTE;           (* The underscore character *)
    escClose             : E.BOOL;            (* Close window on Esc ? *)
    delZip               : E.BOOL;            (* Zip window on Del ? *)
    pubScreenFallBack    : E.BOOL;            (* Fall back onto default public screen ? *)
    fontFallBack         : E.BOOL;            (* Fall back to topaz.8 ? *)
    oldWidth             : E.UWORD;           (* Old window width *)
    oldHeight            : E.UWORD;           (* Old window height *)
    quickHelpWindow      : I.WindowPtr;       (* The QuickHelp window *)
    quickHelpObject      : DisplayObjectPtr;  (* Object for which help is popped up *)
    ticksPassed          : E.ULONG;           (* IntuiTicks passed since last MouseMove *)
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
  omActivate* = 23;

(* --- Tags for OpenProject() --- *)

(* Window *)
  wiTitle*              = (U.user+1);  (* STRPTR: The window title *)
  wiFlags*              = (U.user+2);  (* See below for window flags *)
  wiUnderscore*         = (U.user+3);  (* POINTER TO CHAR: The underscore for menu and gadget shortcuts *)
  wiPosition*           = (U.user+4);  (* Window position, see below *)
  wiCustomScreen*       = (U.user+5);  (* ScreenPtr *)
  wiPubScreen*          = (U.user+6);  (* ScreenPtr, must have been locked! *)
  wiPubScreenName*      = (U.user+7);  (* STRPTR, Triton is doing the locking *)
  wiPropFontAttr*       = (U.user+8);  (* TextAttrPtr: The proportional font *)
  wiFixedWidthFontAttr* = (U.user+9);  (* TextAttrPtr: The fixed-width font *)
  wiBackfill*           = (U.user+10); (* The backfill type, see below *)
  wiID*                 = (U.user+11); (* ULONG: The window ID *)
  wiDimensions*         = (U.user+12); (* DimensionsPtr *)
  wiScreenTitle*        = (U.user+13); (* STRPTR : The screen title *)
  wiQuickHelp*          = (U.user+14); (* BOOL: Quick help active? *)

(* Menus *)
  mnTitle* = (U.user+101); (* STRPTR: Menu *)
  mnItem*  = (U.user+102); (* STRPTR: Menu item *)
  mnSub*   = (U.user+103); (* STRPTR: Menu subitem *)
  mnFlags* = (U.user+104); (* See below for flags *)

(* General object attributes *)
  atID*        = (U.user+150); (* The object's/menu's ID *)
  atFlags*     = (U.user+151); (* The object's flags *)
  atValue*     = (U.user+152); (* The object's value *)
  atText*      = (U.user+153); (* The object's text *)
  atDisabled*  = (U.user+154); (* Disabled object? *)
  atBackfill*  = (U.user+155); (* Backfill pattern *)
  atMinWidth*  = (U.user+156); (* Minimum width *)
  atMinHeight* = (U.user+157); (* Minimum height *)

  user* = (U.user+800); (* Add something to get your own IDs *)

(* --- Window flags --- *)

  wfBackDrop*        = 000000001H; (* Create a backdrop borderless window *)
  wfNoDragBar*       = 000000002H; (* Don't use a dragbar *)
  wfNoDepthGadget*   = 000000004H; (* Don't use a depth-gadget *)
  wfNoCloseGadget*   = 000000008H; (* Don't use a close-gadget *)
  wfNoActivate*      = 000000010H; (* Don't activate window *)
  wfNoEscClose*      = 000000020H; (* Don't send closeWindow when Esc is pressed *)
  wfNoPScrFallback*  = 000000040H; (* Don't fall back onto default PubScreen *)
  wfNoZipGadget*     = 000000080H; (* Don't use a zip-gadget *)
  wfZipCenterTop*    = 000000100H; (* Center the zipped window on the title bar *)
  wfNoMinTextWidth*  = 000000200H; (* Minimum window width not according to title text *)
  wfNoSizeGadget*    = 000000400H; (* Don't use a sizing-gadget *)
  wfNoFontFallback*  = 000000800H; (* Don't fall back to topaz.8 *)
  wfNoDelZip*        = 000001000H; (* Don't zip the window when Del is pressed *)
  wfSimpleRefresh*   = 000002000H; (* *** OBSOLETE *** (V3+) *)
  wfZipToCurrentPos* = 000004000H; (* Will zip the window at the current position (OS3.0+) *)
  wfAppWindow*       = 000008000H; (* Create an AppWindow without using class_dropbox *)
  wfActivateStrGad*  = 000010000H; (* Activate the first string gadget after opening the window *)
  wfHelp*            = 000020000H; (* Pressing <Help> will create a msHelp message *)
  wfSystemAction*    = 000040000H; (* System status messages will be sent (V4) *)

(* --- Menu flags --- *)

  mfCheckIt*  = 000000001H; (* Leave space for a checkmark *)
  mfChecked*  = 000000002H; (* Check the item (includes TRMF_CHECKIT) *)
  mfDisabled* = 000000004H; (* Ghost the menu/item *)

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
  ofRaised*     = 000000001H; (* Raised object *)
  ofHoriz*      = 000000002H; (* Horizontal object \ Works automatically *)
  ofVert*       = 000000004H; (* Vertical object   / in groups *)
  ofRightAlign* = 000000008H; (* Align object to the right border if available *)

(* Text flags *)
  txNoUnderscore* = 000000100H; (* Don't interpret underscores *)
  txHighlight*    = 000000200H; (* Highlight text *)
  tx3D*           = 000000400H; (* 3D design *)
  txBold*         = 000000800H; (* Softstyle 'bold' *)
  txTitle*        = 000001000H; (* A title (e.g. of a group) *)
  txSelected      = 000002000H; (* PRIVATE! *)

(* --- Menu entries --- *)

  menuBarLabel* = -1; (* A barlabel instead of text *)

(* --- Tags for CreateApp() --- *)

  caName*     = (U.user+1);
  caLongName* = (U.user+2);
  caInfo*     = (U.user+3);
  caVersion*  = (U.user+4);
  caRelease*  = (U.user+5);
  caDate*     = (U.user+6);

(* --- Tags for EasyRequest() --- *)

  ezReqPos*      = (U.user+1);
  ezLockProject* = (U.user+2);
  ezReturn*      = (U.user+3);
  ezTitle*       = (U.user+4);
  ezActivate*    = (U.user+5);

(* --- Default classes, attributes and flags --- *)

(* Tag bases *)
  tgOAT = (U.user+400H);
  tgOBJ = (U.user+100H);
  tgPAT = U.user;

(* Display object *)
  obDisplayObject*   = (tgOBJ+3CH);  (* A basic display object *)
  doQuickHelpString* = (tgOAT+1E3H);

(* Classes *)
  obButton*   = (U.user+305); (* A BOOPSI button gadget *)
  obCheckBox* = (U.user+303); (* A checkbox gadget *)
  obCycle*    = (U.user+310); (* A cycle gadget *)
  obDropBox*  = (U.user+312); (* An icon drop box *)
  obScroller* = (U.user+309); (* A scroller gadget *)
  obFrameBox* = (U.user+306); (* A framing box *)
  grHoriz*    = (U.user+201); (* Horizontal group, see below for types *)
  grVert*     = (U.user+202); (* Vertical group, see below for types *)
  grEnd*      = (U.user+203); (* End of a group *)
  obLine*     = (U.user+301); (* A simple line *)
  obPalette*  = (U.user+307); (* A palette gadget *)
  obSlider*   = (U.user+308); (* A slider gadget *)
  obSpace*    = (U.user+901); (* The spaces class *)
  obString*   = (U.user+311); (* A string gadget *)
  obText*     = (U.user+304); (* A line of text *)
  obListview* = (U.user+313); (* A listview gadget *)
  obProgress* = (U.user+314); (* A progress indicator *)
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
  scTotal*   = (U.user+1504);
  scVisible* = (U.user+1505);

(* Slider *)
  slMin* = (U.user+1502);
  slMax* = (U.user+1503);

(* Space *)
  stNone*   = 1; (* No space *)
  stSmall*  = 2; (* Small space *)
  stNormal* = 3; (* Normal space (default) *)
  stBig*    = 4; (* Big space *)

(* Listview *)
  lvTop*          = (U.user+1506);
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
  stInvisible*         = 10000H; (* A password gadget -> invisible typing *)
  stNoReturnBroadCast* = 20000H; (* <Return> keys will not be broadcast to the window *)

VAR
  base- : E.LibraryPtr;
  supportApp : AppPtr;

(* --- Main system --- *)

PROCEDURE OpenProject*       {base,-30}  (app{9}: AppPtr; taglist{8}: ARRAY OF U.TagItem): ProjectPtr;
PROCEDURE CloseProject*      {base,-36}  (project{8}: ProjectPtr);
PROCEDURE FirstOccurance*    {base,-42}  (ch{0}: E.UBYTE; str{8}: E.STRPTR): E.LONG;
PROCEDURE NumOccurances*     {base,-48}  (ch{0}: E.UBYTE; str{8}: E.STRPTR): E.LONG;
PROCEDURE GetErrorString*    {base,-54}  (num{0}: E.UWORD): E.STRPTR;
PROCEDURE CloseWindowSafely* {base,-126} (win{8}: I.WindowPtr);
PROCEDURE GetMsg*            {base,-108} (app{9}: AppPtr): MessagePtr;
PROCEDURE ReplyMsg*          {base,-114} (msg{9}: MessagePtr);
PROCEDURE Wait*              {base,-120} (app{9}: AppPtr; otherbits{0}: E.ULONG): E.ULONG;
PROCEDURE SetAttribute*      {base,-60}  (prj{8}: ProjectPtr; id{0}: E.ULONG; attribute{1}: E.ULONG; value{2}: E.ULONG);
PROCEDURE GetAttribute*      {base,-66}  (prj{8}: ProjectPtr; id{0}: E.ULONG; attribute{1}: E.ULONG): E.ULONG;
PROCEDURE LockProject*       {base,-72}  (prj{8}: ProjectPtr);
PROCEDURE UnlockProject*     {base,-78}  (prj{8}: ProjectPtr);
PROCEDURE AutoRequest*       {base,-84}  (app{9}: AppPtr; lockproject{8}: ProjectPtr; requestTRWindowTags{10}: ARRAY OF U.TagItem): E.ULONG;
PROCEDURE EasyRequest*       {base,-90}  (app{9}: AppPtr; bodyfmt{10}: E.STRPTR; gadfmt{11}: E.STRPTR; taglist{8}: ARRAY OF U.TagItem): E.ULONG;
PROCEDURE CreateApp*         {base,-96}  (apptags{9}: ARRAY OF U.TagItem): AppPtr;
PROCEDURE DeleteApp*         {base,-102} (app{9}: AppPtr);

PROCEDURE GetLastError*      {base,-132} (app{9} : AppPtr) : E.UWORD;
PROCEDURE LockScreen*        {base,-138} (prj{8} : ProjectPtr) : I.ScreenPtr;
PROCEDURE UnlockScreen*      {base,-144} (scr{8} : I.ScreenPtr);
PROCEDURE ObtainWindow*      {base,-150} (prj{8} : ProjectPtr) : I.WindowPtr;
PROCEDURE ReleaseWindow*     {base,-156} (win{8} : I.WindowPtr);

PROCEDURE SendMessage*       {base,-162} (prj{8} : ProjectPtr; id{0} : E.ULONG; msgID{1} : MessagePtr) : E.ULONG;

(* --- Support library --- *)

(* OpenTriton() and CloseTriton() are obsolete under Oberon *)

PROCEDURE OpenProjectTags* {base,-30} (app{9}: AppPtr; tag{8}..: U.Tag): ProjectPtr;
PROCEDURE AutoRequestTags* {base,-84} (app{9}: AppPtr; lockproject{8}: ProjectPtr; tag{10}..: U.Tag): E.ULONG;
PROCEDURE EasyRequestTags* {base,-90} (app{9}: AppPtr; bodyfmt{10}: E.STRPTR; gadfmt{11}: E.STRPTR; tag{8}..: U.Tag): E.ULONG;

(* --- extensions by [phf] --- *)

PROCEDURE CreateAppTags* {base,-96}  (apptags{9}..: U.Tag): AppPtr;

(* --- get everything rolling --- *)

BEGIN

  (* supportApp is not used currently *)
  supportApp := NIL;

  (* I'm not sure about the version. [phf] *)
  base := E.OpenLibrary (tritonName, 0);

CLOSE

  IF (base # NIL) THEN E.CloseLibrary (base) END;

END Triton.
