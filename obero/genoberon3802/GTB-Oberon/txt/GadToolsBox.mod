(* ------------------------------------------------------------------------
  :Program.       GadToolsBox
  :Contents.      Interface to Jan van den Baard's Library
  :Author.        Kai Bolay [kai]
  :Address.       Snail-Mail:              E-Mail:
  :Address.       Hoffmannstraﬂe 168       UUCP: kai@amokle.stgt.sub.org
  :Address.       D-7250 Leonberg 1        FIDO: 2:2407/106.3
  :History.       v1.0 [kai] 13-Feb-93 (translated from C)
  :History.       v1.1 [kai] 28-Feb-93 (fixed reserved-Bug GadToolsConfig)
  :History.       v1.1 [kai] 28-Feb-93 (windowFlags now LONGSET)
  :History.       v1.2 [kai] 29-Feb-93 (FreeWindows now uses VAR parameter)
  :Copyright.     FD
  :Language.      Oberon
  :Translator.    AMIGA OBERON v3.01d
------------------------------------------------------------------------ *)
MODULE GadToolsBox;

(* using..
forms.h      (Release: 1.0, Revision: 38.10)
prefs.h      (Release: 1.0, Revision: 38.3)
gtxbase.h    (Release: 1.0, Revision: 38.3)
gui.h        (Release: 1.0, Revision: 38.6)
hotkey.h     (Release: 1.0, Revision: 38.5)
textclass.h  (Release: 1.0, Revision: 38.5)
gtx_protos.h (Release: 1.0, Revision: 38.8)
gtx_lib.fd   (Release: ?.?, Revision: 38.8)
*)

IMPORT
  e: Exec, g: Graphics, d: Dos, I: Intuition, gt: GadTools, u: Utility,
  nf: NoFragLib,
  y: SYSTEM;

CONST
  (* GadToolsBox FORM identifiers *)
  idGXMN* = y.VAL (LONGINT, "GXMN");
  idGXTX* = y.VAL (LONGINT, "GXTX");
  idGXBX* = y.VAL (LONGINT, "GXBX");
  idGXGA* = y.VAL (LONGINT, "GXGA");
  idGXWD* = y.VAL (LONGINT, "GXWD");
  idGXUI* = y.VAL (LONGINT, "GXUI");

  (* GadToolsBox chunk identifiers. *)
  idMEDA* = y.VAL (LONGINT, "MEDA");
  idITXT* = y.VAL (LONGINT, "ITXT");
  idBBOX* = y.VAL (LONGINT, "BBOX");
  idGADA* = y.VAL (LONGINT, "GADA");
  idWDDA* = y.VAL (LONGINT, "WDDA");
  idGGUI* = y.VAL (LONGINT, "GGUI");

  idVERS* = y.VAL (LONGINT, "VERS");

  (* Version (ID_VERS) chunk... *)
TYPE
  VERSIONPtr* = UNTRACED POINTER TO VERSION;
  VERSION* = STRUCT
    version*: INTEGER;
    flags*: SET;
    reserved: ARRAY 4 OF LONGINT;
  END;

  (* NewMenu (ID_MEDA) chunk... *)
CONST
  MaxMenuTitle* = 80;
  MaxMenuLabel* = 34;
  MaxShortcut* = 2;

  MenuVersion* = 0;
TYPE
  MENUDATAPtr* =  UNTRACED POINTER TO MENUDATA;
  MENUDATA* = STRUCT
    newMenu*: gt.NewMenu;
    title*: ARRAY MaxMenuTitle OF CHAR;
    label*: ARRAY MaxMenuLabel OF CHAR;
    shortCut*: ARRAY MaxShortcut OF CHAR;
    flags*: SET;
  END;

  (* IntuiText (ID_ITXT) chunk... *)
CONST
  MaxTextLength* = 80;
  ITxtVersion* = 0;
TYPE
  ITEXTDATAPtr* = UNTRACED POINTER TO ITEXTDATA;
  ITEXTDATA* = STRUCT
    iText*: I.IntuiText;
    text*: ARRAY MaxTextLength OF CHAR;
  END;

  (* BevelBox (ID_BBOX) chunk... *)
CONST
  BBoxVersion* = 0;
TYPE
  BBOXDATAPtr* = UNTRACED POINTER TO BBOXDATA;
  BBOXDATA* = STRUCT
    left*: INTEGER;
    top*: INTEGER;
    width*: INTEGER;
    height*: INTEGER;
    flags*: SET;
  END;
CONST
  (* BevelBox flag bits *)
  recessed* = 0;
  dropBox* = 1;

  (* NewGadget (ID_GADA) chunk... *)
CONST
  MaxGadgetText* = 80;
  MaxGadgetLabel* = 34;

  GadgetVersion* = 0;
TYPE
  GADGETDATAPtr* = UNTRACED POINTER TO GADGETDATA;
  GADGETDATA* = STRUCT
    newGadget*: gt.NewGadget;
    gadgetText*: ARRAY MaxGadgetText OF CHAR;
    gadgetLabel*: ARRAY MaxGadgetLabel OF CHAR;
    flags*: SET;
    kind*: INTEGER;
    numTags*: INTEGER;
    reserved: ARRAY 4 OF LONGINT;
  END;
  (* NewGadget flag bits *)
CONST
  IsLocked* = 5;
  NeedLock* = 6;

  (* Window (ID_WDDA) chunk... *)
CONST
  MaxWindowName   * = 34;
  MaxWindowTitle  * = 80;
  MaxWdScreenTitle* = 80;

  WindowVersion   * =  0;
TYPE
  WINDOWDATAPtr* = UNTRACED POINTER TO WINDOWDATA;
  WINDOWDATA* = STRUCT
    name*: ARRAY MaxWindowName OF CHAR;
    title*: ARRAY MaxWindowTitle OF CHAR;
    screenTitle*: ARRAY MaxWdScreenTitle OF CHAR;
    numTags*: INTEGER;
    idCountFrom*: INTEGER;
    idcmp*: LONGSET;
    windowFlags*: LONGSET;
    tagFlags*: LONGSET;
    innerWidth*: INTEGER;
    innerHeight*: INTEGER;
    showTitle*: BOOLEAN;
    mouseQueue*: INTEGER;
    rptQueue*: INTEGER;
    flags*: SET;
    leftBorder*: INTEGER;
    topBorder*: INTEGER;
    reserved: ARRAY 10 OF SHORTINT;
  END;
CONST
  (* Window tag flag bits *)
  InnerWidth     * = 0;
  InnerHeight    * = 1;
  Zoom           * = 2;
  MouseQueue     * = 3;
  RptQueue       * = 4;
  AutoAdjust     * = 5;
  DefaultZoom    * = 6;
  FallBack       * = 7;

  (* GUI (ID_GGUI) chunk... *)
CONST
  MaxScreenTitle* = 80;
  FontNameLength* = 128;
  MaxColorSpec* = 33;
  MaxDriPens* = 10;
  MaxMoreDriPens* = 10;

  GuiVersion* = 0;
TYPE
  GUIDATAPtr* = UNTRACED POINTER TO GUIDATA;
  GUIDATA* = STRUCT
    flags0*: LONGSET;
    screenTitle*: ARRAY MaxScreenTitle OF CHAR;
    left*: INTEGER;
    top*: INTEGER;
    width*: INTEGER;
    height*: INTEGER;
    depth*: INTEGER;
    displayID*: LONGINT;
    overscan*: INTEGER;
    driPens*: ARRAY MaxDriPens OF INTEGER;
    colors*: ARRAY MaxColorSpec OF I.ColorSpec;
    fontName*: ARRAY FontNameLength OF CHAR;
    font*: g.TextAttr;
    moreDriPens*: ARRAY MaxMoreDriPens OF INTEGER;
    reserved: ARRAY 5 OF LONGINT;
    flags1*: LONGSET;
    stdScreenWidth*: INTEGER;
    stdScreenHeight*: INTEGER;
    activeKind*: INTEGER;
    lastProject*: INTEGER;
    gridX*: INTEGER;
    gridY*: INTEGER;
    offX*: INTEGER;
    offY*: INTEGER;
    reserved1: ARRAY 7 OF INTEGER;
  END;
CONST
  (* GUI gui_Flags0 flag bits *)
  AutoScroll* = 0;
  Workbench * = 1;
  Public    * = 2;
  Custom    * = 3;

CONST
  GTBConfigSave* = "ENVARC:GadToolsBox/GadToolsBox.prefs";
  GTBConfigUse * = "ENV:GadToolsBox/GadToolsBox.prefs";

  GTBConfigVErsion* =   0;
  MaxUserName     * =  64;
  MaxIconPath     * = 128;

  idGTCO          * =  y.VAL (LONGINT, "GTCO");

TYPE
  GadToolsConfigPtr* = UNTRACED POINTER TO GadToolsConfig;
  GadToolsConfig* = STRUCT
    configFlags0*: LONGSET;
    configFlags1*: LONGSET;
    crunchBuffer*: INTEGER;
    crunchType*: INTEGER;
    userName*: ARRAY MaxUserName OF CHAR;
    iconPath*: ARRAY MaxIconPath OF CHAR;
    reserved: ARRAY 4 OF LONGINT;
  END;

  (* flag definitions for gtc_ConfigFlags0 *)
CONST
  Coordinates* =     0;
  WriteIcon* =       1;
  GZZAdjust* =       2;
  Crunch* =          3;
  CloseWBench* =     4;
  Password* =        5;
  Overwrite* =       6;
  ASLFReq* =         7;
  FontAdapt* =       8;

CONST
  GenOpenFont * = 1;
  SysFont *= 2;

CONST
  GTXName* = "gadtoolsbox.library";
  GTXVersion* = 38;

TYPE
  GTXBasePtr* = UNTRACED POINTER TO GTXBase;
  GTXBase* = STRUCT (libNode*: e.Library)
    (*
    ** These library bases may be extracted from this structure
    ** for your own usage as long as the GTXBase pointer remains
    ** valid.
    **)
    dosBase*: d.DosLibraryPtr;
    intuitionBase*: I.IntuitionBasePtr;
    gfxBase*: g.GfxBasePtr;
    gadToolsBase*: e.LibraryPtr;
    utilityBase*: e.LibraryPtr;
    iffParseBase*: e.LibraryPtr;
    consoleDevice*: e.DevicePtr;
    noFragBase*: e.LibraryPtr;
    (*
    ** The next library pointer is not guaranteed to
    ** be valid! Please check this pointer *before* using
    ** it.
    **)
    ppBase*: e.LibraryPtr;
  END;

TYPE
  ExtNewGadgetPtr* = UNTRACED POINTER TO ExtNewGadget;
  ExtGadgetListPtr* = UNTRACED POINTER TO ExtGadgetList;
  ExtGadgetList* = STRUCT (dummy: e.CommonList)
    head*:     ExtNewGadgetPtr;
    tailPred*: ExtNewGadgetPtr;
    tail*:     ExtNewGadgetPtr;
  END;
  ExtNewGadget* = STRUCT (dummy: e.CommonNode)
    succ*: ExtNewGadgetPtr;
    prev*: ExtNewGadgetPtr;
    tags*: u.TagItemPtr;
    reserved0: ARRAY 4 OF SHORTINT;
    newGadget*: gt.NewGadget;
    gadgetLabel*: ARRAY MaxGadgetLabel OF CHAR;
    gadgetText*: ARRAY MaxGadgetText OF CHAR;
    flags*: LONGSET;
    kind*: INTEGER;
    reserved1: ARRAY 138 OF SHORTINT;
  END;

TYPE
  ExtNewMenuPtr* = UNTRACED POINTER TO ExtNewMenu;
  ExtMenuListPtr* = UNTRACED POINTER TO ExtMenuList;
  ExtMenuList* = STRUCT  (dummy: e.CommonList)
    head*:     ExtNewMenuPtr;
    tailPred*: ExtNewMenuPtr;
    tail*:     ExtNewMenuPtr;
  END;
  ExtNewMenu* = STRUCT (dummy: e.CommonNode)
    succ*: ExtNewMenuPtr;
    prev*: ExtNewMenuPtr;
    reserved0: ARRAY 6 OF SHORTINT;
    newMenu*: gt.NewMenu;
    menuTitle*: ARRAY MaxMenuTitle OF CHAR;
    menuLabel*: ARRAY MaxMenuLabel OF CHAR;
    reserved1: ARRAY 4 OF SHORTINT;
    items*: ExtMenuListPtr;
    reserved2: ARRAY 2 OF SHORTINT;
    commKey*: ARRAY MaxShortcut OF CHAR;
    reserved3: ARRAY 2 OF SHORTINT;
  END;


TYPE
  BevelBoxPtr* = UNTRACED POINTER TO BevelBox;
  BevelListPtr* = UNTRACED POINTER TO BevelList;
  BevelList* = STRUCT  (dummy: e.CommonList)
    head*:     BevelBoxPtr;
    tailPred*: BevelBoxPtr;
    tail*:     BevelBoxPtr;
  END;
  BevelBox* = STRUCT (dummy: e.CommonNode)
    succ*: BevelBoxPtr;
    prev*: BevelBoxPtr;
    reserved0: ARRAY 4 OF SHORTINT;
    left*: INTEGER;
    top*: INTEGER;
    width*: INTEGER;
    height*: INTEGER;
    reserved1: ARRAY 32 OF SHORTINT;
    flags*: SET;
  END;

TYPE
  ProjectWindowPtr* = UNTRACED POINTER TO ProjectWindow;
  WindowListPtr* = UNTRACED POINTER TO WindowList;
  WindowList* = STRUCT (dummy: e.CommonList)
    head*:     ProjectWindowPtr;
    tailPred*: ProjectWindowPtr;
    tail*:     ProjectWindowPtr;
  END;
  ProjectWindow* = STRUCT (dummy: e.CommonNode)
    succ*: ProjectWindowPtr;
    prev*: ProjectWindowPtr;
    reserved0: ARRAY 6 OF SHORTINT;
    name*: ARRAY MaxWindowName OF CHAR;
    countIDFrom*: INTEGER;
    tags*: u.TagItemPtr;
    leftBorder*: INTEGER;
    topBorder*: INTEGER;
    windowTitle*: ARRAY MaxWindowTitle OF CHAR;
    screenTitle*: ARRAY MaxWdScreenTitle OF CHAR;
    reserved2: ARRAY 192 OF SHORTINT;
    idcmp*: LONGSET;
    windowFlags*: LONGSET;
    windowText*: I.IntuiTextPtr;
    gadgets*: ExtGadgetList;
    menus*: ExtMenuList;
    boxes*: BevelList;
    tagFlags*: LONGSET;
    innerWidth*: INTEGER;
    innerHeight*: INTEGER;
    showTitle*: BOOLEAN;
    reserved3: ARRAY 6 OF SHORTINT;
    mouseQueue*: INTEGER;
    rptQueue*: INTEGER;
    flags*: INTEGER;
  END;

  (* tags for the GTX_LoadGUI() routine *)
CONST
  rgTagBase* = u.user+512;

  rgGUI          * = rgTagBase+1;
  rgConfig       * = rgTagBase+2;
  rgCConfig      * = rgTagBase+3;
  rgAsmConfig    * = rgTagBase+4;
  rgLibGen       * = rgTagBase+5;
  rgWindowList   * = rgTagBase+6;
  rgValid        * = rgTagBase+7;
  rgPasswordEntry* = rgTagBase+8;

  vlfGUI         * = 0;
  vlfConfig      * = 1;
  vlfCConfig     * = 2;
  vlfAsmConfig   * = 3;
  vlfLibGen      * = 4;
  vlfWindowList  * = 5;

  ErrorNoMem     * = 1;
  ErrorOpen      * = 2;
  ErrorRead      * = 3;
  ErrorWrite     * = 4;
  ErrorParse     * = 5;
  ErrorPacker    * = 6;
  ErrorPPLib     * = 7;
  ErrorNotGUIFile* = 8;


(* A _very_ important handle *)
TYPE
  HotKeyHandle* = y.ADDRESS;

CONST
  (* Flags for the HKH_SetRepeat tag *)
  srbMX           * = 0;
  srbCycle        * = 1;
  srbSlider       * = 2;
  srbScroller     * = 3;
  srbListView     * = 4;
  srbPalette      * = 5;

  (* tags for the hotkey system *)
  hkhTagBase        * = u.user+256;
  hkhKeyMap         * = hkhTagBase+1;
  hkhUseNewButton   * = hkhTagBase+2;
  hkhNewText        * = hkhTagBase+3;
  hkhSetRepeat      * = hkhTagBase+4;

  txTagBase         * = u.user+1;
  txtxtAttr         * = txTagBase+1;
  txStyle           * = txTagBase+2;
  txForceTextPen    * = txTagBase+3;
  txUnderscore      * = txTagBase+4;
  txFlags           * = txTagBase+5;
  txText            * = txTagBase+6;
  txNoBox           * = txTagBase+7;

VAR
  base*: GTXBasePtr;

PROCEDURE TagInArray* {base, -30} (Tag{0}: u.Tag; TagList{8}: ARRAY OF u.TagItem): BOOLEAN;
PROCEDURE SetTagData* {base, -36} (Tag{0}: u.Tag; Data{1}: LONGINT; TagList{8}: ARRAY OF u.TagItem): LONGINT;
PROCEDURE GetNode* {base, -42} (List{8}: e.CommonList; NodeNum{0}: LONGINT): e.CommonNodePtr;
PROCEDURE GetNodeNumber* {base, -48} (List{8}: e.CommonList; Node{9}: e.CommonNode): LONGINT;
PROCEDURE CountNodes* {base, -54} (List{8}: e.CommonList): LONGINT;
PROCEDURE MoveNode* {base, -60} (List{8}: e.CommonList; Node{9}: e.CommonNode; Direction{0}: LONGINT): LONGINT;
PROCEDURE IFFErrToStr* {base, -66} (Error{0}, SkipEndOf{1}: LONGINT): e.STRPTR;
PROCEDURE GetHandleA* {base, -72} (TagList{8}: ARRAY OF u.TagItem): HotKeyHandle;
PROCEDURE GetHandle* {base, -72} (Tags{8}..: u.Tag): HotKeyHandle;
PROCEDURE FreeHandle* {base, -78} (Handle{8}: HotKeyHandle);
PROCEDURE RefreshWindow* {base, -84} (Handle{8}: HotKeyHandle; Window{9}: I.WindowPtr; Requester{10}: I.RequesterPtr);
PROCEDURE CreateGadgetA* {base, -90} (Handle{8}: HotKeyHandle; kind{0}: LONGINT; Pred{9}: I.GadgetPtr; NewGadget{10}: gt.NewGadget; TagList{11}: ARRAY OF u.TagItem): I.GadgetPtr;
PROCEDURE CreateGadget* {base, -90} (Handle{8}: HotKeyHandle; kind{0}: LONGINT; Pred{9}: I.GadgetPtr; NewGadget{10}: gt.NewGadget; Tags{11}..: u.Tag): I.GadgetPtr;
PROCEDURE RawToVanilla* {base, -96} (Handle{8}: HotKeyHandle; Code{0}, Qualifier{1}: LONGINT): LONGINT;
PROCEDURE GetIMsg* {base, -102} (Handle{8}: HotKeyHandle; Port{9}: e.MsgPortPtr): I.IntuiMessagePtr;
PROCEDURE ReplyIMsg* {base, -108} (Handle{8}: HotKeyHandle; IMsg{9}: I.IntuiMessagePtr);
PROCEDURE SetGadgetAttrsA* {base, -114} (Handle{8}: HotKeyHandle; Gadget{9}: I.GadgetPtr; TagList{10}: ARRAY OF u.TagItem);
PROCEDURE SetGadgetAttrs* {base, -114} (Handle{8}: HotKeyHandle; Gadget{9}: I.GadgetPtr; Tags{10}..: u.Tag);
PROCEDURE DetachLabels* {base, -120} (Handle{8}: HotKeyHandle; Gadget{9}: I.GadgetPtr);
PROCEDURE DrawBox* {base, -126} (RPort{9}: g.RastPortPtr; Left{0}, Top{1}, Width{2}, Height{3}: LONGINT; dri{9}: I.DrawInfoPtr; State{4}: LONGINT);
PROCEDURE InitTextClass* {base, -132} (): I.IClassPtr;
PROCEDURE InitGetFileClass* {base, -138} (): I.IClassPtr;
PROCEDURE SetHandleAttrsA* {base, -144} (Handle{8}: HotKeyHandle; TagList{9}: ARRAY OF u.TagItem);
PROCEDURE SetHandleAttrs* {base, -144} (Handle{8}: HotKeyHandle; Tags{9}..: u.Tag);
PROCEDURE BeginRefresh* {base, -150} (Handle{8}: HotKeyHandle);
PROCEDURE EndRefresh* {base, -156} (Handle{8}: HotKeyHandle; All{0}: I.LONGBOOL);
PROCEDURE FreeWindows* {base, -228} (Chain{8}: nf.MemoryChainPtr; VAR Windows{9}: WindowList);
PROCEDURE LoadGUIA* {base, -234} (Chain{8}: nf.MemoryChainPtr; name{9}: ARRAY OF CHAR; TagList{10}: ARRAY OF u.TagItem): LONGINT;
PROCEDURE LoadGUI* {base, -234} (Chain{8}: nf.MemoryChainPtr; name{9}: ARRAY OF CHAR; Tags{10}..: u.Tag): LONGINT;

BEGIN
  base :=  e.OpenLibrary (GTXName, GTXVersion);
  IF base = NIL THEN
    y.SETREG (0, I.DisplayAlert (I.recoveryAlert, "\x00\x64\x14Unable to open gadtoolsbox.library\o\o", 50));
    HALT (20);
  END;
CLOSE
  IF base # NIL THEN
    e.CloseLibrary (base); base :=  NIL;
  END;
END GadToolsBox.
