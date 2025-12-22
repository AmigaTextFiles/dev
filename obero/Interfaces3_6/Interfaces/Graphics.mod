(*
(*
**  Amiga Oberon Interface Module:
**  $VER: Graphics.mod 40.15 (12.1.95) Oberon 3.6
**
**   © 1993 by Fridtjof Siebert
**   updated for V39, V40 by hartmut Goebel
*)
*)

MODULE Graphics;

IMPORT
  e * := Exec,
  u * := Utility,
  h * := Hardware,
  SYSTEM *;

TYPE
  RectanglePtr            * = UNTRACED POINTER TO Rectangle;
  Rect32Ptr               * = UNTRACED POINTER TO Rect32;
  PointPtr                * = UNTRACED POINTER TO Point;
  BitMapPtr               * = UNTRACED POINTER TO BitMap;
  LayerPtr                * = UNTRACED POINTER TO Layer;
  ClipRectPtr             * = UNTRACED POINTER TO ClipRect;
  CopInsPtr               * = UNTRACED POINTER TO CopIns;
  CopInsCLPtr             * = UNTRACED POINTER TO CopInsCL;
  CprlistPtr              * = UNTRACED POINTER TO Cprlist;
  CopListDummyPtr         * = UNTRACED POINTER TO CopListDummy;
  CopListPtr              * = UNTRACED POINTER TO CopList;
  CopList13Ptr            * = UNTRACED POINTER TO CopList13;
  UCopListPtr             * = UNTRACED POINTER TO UCopList;
  CopinitPtr              * = UNTRACED POINTER TO Copinit;
  ExtendedNodePtr         * = UNTRACED POINTER TO ExtendedNode;
  MonitorSpecPtr          * = UNTRACED POINTER TO MonitorSpec;
  AnalogSignalIntervalPtr * = UNTRACED POINTER TO AnalogSignalInterval;
  SpecialMonitorPtr       * = UNTRACED POINTER TO SpecialMonitor;
  QueryHeaderPtr          * = UNTRACED POINTER TO QueryHeader;
  DisplayInfoPtr          * = UNTRACED POINTER TO DisplayInfo;
  DimensionInfoPtr        * = UNTRACED POINTER TO DimensionInfo;
  MonitorInfoPtr          * = UNTRACED POINTER TO MonitorInfo;
  NameInfoPtr             * = UNTRACED POINTER TO NameInfo;
  VSpritePtr              * = UNTRACED POINTER TO VSprite;
  BobPtr                  * = UNTRACED POINTER TO Bob;
  AnimCompPtr             * = UNTRACED POINTER TO AnimComp;
  AnimObPtr               * = UNTRACED POINTER TO AnimOb;
  DBufPacketPtr           * = UNTRACED POINTER TO DBufPacket;
  CollTablePtr            * = UNTRACED POINTER TO CollTable;
  IsrvstrPtr              * = UNTRACED POINTER TO Isrvstr;
  LayerInfoPtr            * = UNTRACED POINTER TO LayerInfo;
  AreaInfoPtr             * = UNTRACED POINTER TO AreaInfo;
  TmpRasPtr               * = UNTRACED POINTER TO TmpRas;
  GelsInfoPtr             * = UNTRACED POINTER TO GelsInfo;
  RastPortPtr             * = UNTRACED POINTER TO RastPort;
  RegionRectanglePtr      * = UNTRACED POINTER TO RegionRectangle;
  RegionPtr               * = UNTRACED POINTER TO Region;
  BitScaleArgsPtr         * = UNTRACED POINTER TO BitScaleArgs;
  SimpleSpritePtr         * = UNTRACED POINTER TO SimpleSprite;
  TextAttrPtr             * = UNTRACED POINTER TO TextAttr;
  TTextAttrPtr            * = UNTRACED POINTER TO TTextAttr;
  TextFontPtr             * = UNTRACED POINTER TO TextFont;
  TextFontExtensionPtr    * = UNTRACED POINTER TO TextFontExtension;
  ColorFontColorsPtr      * = UNTRACED POINTER TO ColorFontColors;
  ColorTextFontPtr        * = UNTRACED POINTER TO ColorTextFont;
  TextextentPtr           * = UNTRACED POINTER TO Textextent;
  ViewPortPtr             * = UNTRACED POINTER TO ViewPort;
  ViewPtr                 * = UNTRACED POINTER TO View;
  ViewExtraPtr            * = UNTRACED POINTER TO ViewExtra;
  ViewPortExtraPtr        * = UNTRACED POINTER TO ViewPortExtra;
  RasInfoPtr              * = UNTRACED POINTER TO RasInfo;
  ColorMapPtr             * = UNTRACED POINTER TO ColorMap;
  GfxBasePtr              * = UNTRACED POINTER TO GfxBase;
  VecInfoPtr              * = UNTRACED POINTER TO VecInfo;
  ExtSpritePtr            * = UNTRACED POINTER TO ExtSprite;
  PaletteExtraPtr         * = UNTRACED POINTER TO PaletteExtra;
  DBufInfoPtr             * = UNTRACED POINTER TO DBufInfo;

  Rectangle * = STRUCT
    minX*, minY* : INTEGER;
    maxX*, maxY* : INTEGER;
  END;

  Rect32 * = STRUCT
    minX*, minY* : LONGINT;
    maxX*, maxY* : LONGINT;
  END;

  Point * = STRUCT
    x*,y*: INTEGER;
  END;

  PLANEPTR * = e.APTR;

  BitMap * = STRUCT
    bytesPerRow *: INTEGER;
    rows        *: INTEGER;
    flags       *: e.BYTE;
    depth       *: SHORTINT;
    pad         *: INTEGER;
    planes      *: ARRAY 8 OF PLANEPTR;
  END;

CONST
(* flags for AllocBitMap, etc. *)
  bmbClear       * = 0;
  bmbDisplayable * = 1;
  bmbInterleaved * = 2;
  bmbStandard    * = 3;
  bmbMinplanes   * = 4;

(* the following are for GetBitMapAttr() *)
  bmaHeight * = 0;
  bmaDepth  * = 4;
  bmaWidth  * = 8;
  bmaFlags  * = 12;

TYPE
  Layer * = STRUCT
    front-, back -: LayerPtr;
    clipRect     -: ClipRectPtr;       (* read by roms to find first cliprect *)
    rp           -: RastPortPtr;
    bounds       -: Rectangle;
    reserved     -: ARRAY 4 OF e.BYTE;
    priority     -: INTEGER;           (* system use only *)
    flags        -: SET;               (* obscured ?, Virtual BitMap? *)
    superBitMap  -: BitMapPtr;
    superClipRect -: ClipRectPtr;      (* super bitmap cliprects if VBitMap != 0*)
                                       (* else damage cliprect list for refresh *)
    window       -: e.APTR;            (* reserved for user interface use *)
    scrollX-,scrollY-: INTEGER;
    cr-,cr2-,crnew -: ClipRectPtr;     (* used by dedice *)
    superSaveClipRects -: ClipRectPtr; (* preallocated cr's *)
    cliprects    -: ClipRectPtr;       (* system use during refresh *)
    layerInfo    -: LayerInfoPtr;      (* points to head of the list *)
    lock         -: e.SignalSemaphore;
    backFill     -: u.HookPtr;
    reserved1    -: LONGINT;
    clipRegion   -: RegionPtr;
    saveClipRects -: RegionPtr;        (* used to back out when in trouble*)
    width-,height-: INTEGER;           (* system use *)
    reserved2    -: ARRAY 18 OF e.BYTE;
    (* this must stay here *)
    damageList   -: RegionPtr;         (* list of rectangles to refresh through *)
  END;

  ClipRect * = STRUCT
    next     *: ClipRectPtr;   (* roms used to find next ClipRect *)
    prev     *: ClipRectPtr;   (* ignored by roms, used by windowlib *)
    lobs     *: LayerPtr;      (* ignored by roms, used by windowlib *)
    bitMap   *: BitMapPtr;
    bounds   *: Rectangle;     (* set up by windowlib, used by roms *)
    p1*,p2   *: ClipRectPtr;   (* system reserved *)
    reserved *: LONGINT;       (* system use *)
    flags    *: LONGSET;       (* only exists in layer allocation *)
                               (* MUST be multiple of 8 bytes to buffer *)
  END;


CONST
(* internal cliprect flags *)
  needsNoConcealedRasters * = 1;
  needsNoLayerBlitDamage  * = 2;

(* defines for code values for getcode *)
  isLessX * = 1;
  isLessY * = 2;
  isGrtrX * = 4;
  isGrtrY * = 8;


(* These bit descriptors are used by the GEL collide routines.
 *  These bits are set in the hitMask and meMask variables of
 *  a GEL to describe whether or not these types of collisions
 *  can affect the GEL.  BNDRY_HIT is described further below;
 *  this bit is permanently assigned as the boundary-hit flag.
 *  The other bit GEL_HIT is meant only as a default to cover
 *  any GEL hitting any other; the user may redefine this bit.
 *)
  borderHit * = 0;

(* These bit descriptors are used by the GEL boundry hit routines.
 *  When the user's boundry-hit routine is called (via the argument
 *  set by a call to SetCollision) the first argument passed to
 *  the user's routine is the address of the GEL involved in the
 *  boundry-hit, and the second argument has the appropriate bit(s)
 *  set to describe which boundry was surpassed
 *)
  topHit    * = 1;
  bottomHit * = 2;
  leftHit   * = 4;
  rightHit  * = 8;


(* Copper: *)
(* graphics copper list intstruction definitions *)

  move  * = 0;     (* pseude opcode for move #XXXX,dir *)
  wait  * = 1;     (* pseudo opcode for wait y,x *)
  next  * = 2;     (* continue processing with next buffer *)
  ntLof * = 15;    (* copper instruction only for short frames *)
  ntSht * = 14;    (* copper instruction only for long frames *)
  ntSys * = 13;    (* copper user instruction only *)

TYPE

  CopIns * = STRUCT
    opCode   *: INTEGER; (* 0 = move, 1 = wait *)
    destAddr *: INTEGER; (* vertical beam wait OR
                          * destination address of copper move *)
    destData *: INTEGER; (* beam wait position OR
                          * destination immediate data to send *)
  END;

  CopInsCL * = STRUCT
    opCode  *: INTEGER; (* should be 2 = next *)
    nxtList *: CopListDummyPtr;
  END;

(* structure of cprlist that points to list that hardware actually executes *)
  Cprlist * = STRUCT
    next     *: CprlistPtr;
    start    *: e.APTR;     (* start of copper list *)
    maxCount *: INTEGER;    (* number of long instructions *)
  END;

  CopListDummy * = STRUCT END;

  CopList * = STRUCT (dummy *: CopListDummy)
    next      *: CopListPtr; (* next block for this copper list *)
    copList   *: CopListPtr; (* system use *)
    viewPort  *: ViewPortPtr;(* system use *)
    copIns    *: CopInsPtr;  (* start of this block *)
    copPtr    *: CopInsPtr;  (* intermediate ptr *)
    copLStart *: e.APTR;     (* mrgcop fills this in for Long Frame*)
    copSStart *: e.APTR;     (* mrgcop fills this in for Short Frame*)
    count     *: INTEGER;    (* intermediate counter *)
    maxCount  *: INTEGER;    (* max # of copins for this block *)
    dyOffset  *: INTEGER;    (* offset this copper list vertical waits *)
    slRepeat  *: INTEGER;;
    flags     *: SET;
  END;

  CopList13 * = STRUCT (dummy *: CopListDummy)
    next      *: CopList13Ptr; (* next block for this copper list *)
    copList   *: CopList13Ptr; (* system use *)
    viewPort  *: ViewPortPtr;  (* system use *)
    copIns    *: CopInsPtr; (* start of this block *)
    copPtr    *: CopInsPtr; (* intermediate ptr *)
    copLStart *: e.APTR;    (* mrgcop fills this in for Long Frame*)
    copSStart *: e.APTR;    (* mrgcop fills this in for Short Frame*)
    count     *: INTEGER;   (* intermediate counter *)
    maxCount  *: INTEGER;   (* max # of copins for this block *)
    dyOffset  *: INTEGER;   (* offset this copper list vertical waits *)
    cop2Start *: e.APTR;
    cop3Start *: e.APTR;
    cop4Start *: e.APTR;
    cop5Start *: e.APTR;
    slRepeat  *: INTEGER;;
    flags     *: SET;
  END;


CONST
(* These CopList->Flags are private *)
  exactLine  = 1;
  halfLine   = 2;

TYPE
  UCopList * = STRUCT
    next         *: UCopListPtr;
    firstCopList *: CopListDummyPtr; (* head node of this copper list *)
    copList      *: CopListDummyPtr; (* node in use *)
  END;

(* Private graphics data structure. This structure has changed in the past,
 * and will continue to change in the future. Do Not Touch!
 *)

  Copinit  = STRUCT
    vsyncHblank *: ARRAY 2 OF INTEGER;
    diagstart   *: ARRAY 12 OF INTEGER; (* copper list for first bitplane *)
    fm0         *: ARRAY 2 OF INTEGER;
    diwstart    *: ARRAY 10 OF INTEGER;
    bplcon2     *: ARRAY 2 OF INTEGER;
    sprfix      *: ARRAY (2*8) OF INTEGER;
    sprstrtup   *: ARRAY (2*8*2) OF INTEGER;
    wait14      *: ARRAY 2 OF INTEGER;
    normHblank  *: ARRAY 2 OF INTEGER;
    jump        *: ARRAY 2 OF INTEGER;
    waitForever *: ARRAY 6 OF INTEGER;
    sprstop     *: ARRAY 8 OF INTEGER;
  END;

CONST

(* bplcon0 defines *)
  mode640  * = 15;
  plnCntMsk * = {0..2};    (* how many bit planes? *)
                           (* 0 = none, 1->6 = 1->6, 7 = reserved *)
  plnCntShft * = 12;       (* bits to shift for bplcon0 *)
  pf2pri * = 6;            (* bplcon2 bit *)
  colorOn * = 9;           (* disable color burst *)
  dblpf * = 10;
  holdnmodify * = 11;
  interlace * = 2;         (* interlace mode for 400 *)

(* bplcon1 defines *)
  fineScroll      * = {0..3};
  fineScrollShift * = 4;
  fineScrollMask  * = {0..3};

(* display window start and stop defines *)
  horizPos * = {0..6};   (* horizontal start/stop *)
  vrtclPos * = {0..8};   (* vertical start/stop *)
  vrtclPosShift * = 7;

(* Data fetch start/stop horizontal position *)
  dftchMask * = {0..7};

(* vposr bits *)
  vposrlof  * = {15};


TYPE
  ExtendedNode * = STRUCT (node *: e.Node)
    subsystem *: SHORTINT;
    subtype   *: SHORTINT;
    library   *: LONGINT;
    init      *: e.PROC;
  END;

CONST
  ssGraphics * = 2;

  viewExtraType       * = 1;
  viewPortExtraType   * = 2;
  specialMonitorType  * = 3;
  monitorSpecType     * = 4;

TYPE
  MonitorSpec * = STRUCT (node *: ExtendedNode)
    flags        *: SET;
    ratioh       *: LONGINT;
    ratiow       *: LONGINT;
    totalRows    *: INTEGER;
    totalColorclocks       *: INTEGER;
    deniseMaxDisplayColumn *: INTEGER;
    beamCon0     *: INTEGER;
    minRow       *: INTEGER;
    special      *: SpecialMonitorPtr;
    openCount    *: INTEGER;
    transform    *: e.PROC;
    translate    *: e.PROC;
    scale        *: e.PROC;
    xoffset      *: INTEGER;
    yoffset      *: INTEGER;
    legalView    *: Rectangle;
    maxoscan     *: e.PROC;       (* maximum legal overscan *)
    videoscan    *: e.PROC;       (* video display overscan *)
    deniseMinDisplayColumn *: INTEGER;
    displayCompatible      *: LONGINT;
    displayInfoDataBase    *: e.List;
    displayInfoDataBaseSemaphore *: e.SignalSemaphore;
    mrgCop       *: e.PROC;
    loadView     *: e.PROC;
    killView     *: e.PROC;
  END;

CONST

  toMonitor       * = 0;
  fromMonitor     * = 1;
  standardXOffset * = 9;
  standardYOffset * = 0;

  msbRequestNTSC     * = 0;
  msbRequestPAL      * = 1;
  msbRequestSpecial  * = 2;
  msbRequestA2024    * = 3;
  msbDoubleSprites   * = 4;

(* obsolete, v37 compatible definitions follow *)
  requestNTSC     * = 1;  (* note: this are SET-values! [hG] *)
  requestPAL      * = 2;
  requestSpecial  * = 4;
  requestA2024    * = 8;

  defaultMonitorName     * = "default.monitor";
  ntscMonitorName        * = "ntsc.monitor";
  palMonitorName         * = "pal.monitor";
  standardMonitorMask    * = requestNTSC + requestPAL;

  standardNTSCRows       * = 262;
  standardPALRows        * = 312;
  standardColorClocks    * = 226;
  standardDeniseMax      * = 455;
  standardDeniseMin      * = 93;
  standardNTSCBeamCon    * = {};
  standardPALBeamCon     * = {h.displayPal};

  specialBeamCon * = {h.varVBlank,h.loLDis,h.varVSync,h.varHSync,h.varBeam,
                      h.csBlank,h.vSyncTrue};

  minNTSCRow     * = 21;
  minPALRow      * = 29;
  standardViewX  * = 81H;
  standardViewY  * = 2CH;
  standardHBStrt * = 06H;
  standardHSStrt * = 0BH;
  standardHSStop * = 1CH;
  standardHBStop * = 2CH;
  standardVBStrt * = 0122H;
  standardVSStrt * = 02A6H;
  standardVSStop * = 03AAH;
  standardVBStop * = 1066H;

  vgaColorClocks * = standardColorClocks DIV 2;
  vgaTotalRows   * = standardNTSCRows * 2;
  vgaDeniseMin   * = 59;
  minvgaRow      * = 29;
  vgaHBStrt      * = 08H;
  vgaHSStrt      * = 0EH;
  vgaHSStop      * = 1CH;
  vgaHBStop      * = 1EH;
  vgaVBStrt      * = 0000H;
  vgaVSStrt      * = 0153H;
  vgaVSStop      * = 0235H;
  vgaVBStop      * = 0CCDH;

  vgaMonitorName * = "vga.monitor";

(* NOTE: VGA70 definitions are obsolete - a VGA70 monitor has never been
 * implemented.
 *)
  vga70ColorClocks * = standardColorClocks DIV 2;
  vga70TotalRows  * = 449;
  vga70DeniseMin  * = 59;
  minvga70Row     * = 35;
  vga70HBStrt     * = 08H;
  vga70HSStrt     * = 0EH;
  vga70HSStop     * = 1CH;
  vga70HBStop     * = 1EH;
  vga70VBStrt     * = 0000H;
  vga70VSStrt     * = 02A6H;
  vga70VSStop     * = 0388H;
  vga70VBStop     * = 0F73H;

  vga70BeamCon     * = specialBeamCon / {h.vSyncTrue};
  vga70MonitorName * = "vga70.monitor";

  broadcastHBStrt  * = 01H;
  broadcastHSStrt  * = 06H;
  broadcastHSStop  * = 17H;
  broadcastHBStop  * = 27H;
  broadcastVBStrt  * = 0000H;
  broadcastVSStrt  * = 02A6H;
  broadcastVSStop  * = 054CH;
  broadcastVBStop  * = 1C40H;
  broadcastBeamCon * = {h.loLDis,h.csBlank};
  ratioFixedPart   * = 4;
  rationUnity      * = ASH(1,ratioFixedPart);

TYPE

  AnalogSignalInterval * = STRUCT
    start     *: INTEGER;
    stop      *: INTEGER;
  END;

  SpecialMonitor * = STRUCT (node *: ExtendedNode)
    flags     *: SET;
    doMonitor *: e.PROC;
    reserved1 *: e.PROC;
    reserved2 *: e.PROC;
    reserved3 *: e.PROC;
    hblank    *: AnalogSignalInterval;
    vblank    *: AnalogSignalInterval;
    hsync     *: AnalogSignalInterval;
    vsync     *: AnalogSignalInterval;
  END;


(* the "public" handle to a DisplayInfoRecord *)

  DisplayInfoHandle * = e.APTR;

CONST

(* datachunk type identifiers *)

  dtagDisp  * = 80000000H;
  dtagDims  * = 80001000H;
  dtagMntr  * = 80002000H;
  dtagName  * = 80003000H;
  dtagVec   * = 80004000H;   (* internal use only *)

TYPE

  QueryHeader * = STRUCT
    structID  *: LONGINT;    (* datachunk type identifier *)
    displayID *: LONGINT;    (* copy of display record key   *)
    skipID    *: LONGINT;    (* TAG_SKIP -- see tagitems.h *)
    length    *: LONGINT;    (* length of local data in double-longwords *)
  END;

  DisplayInfo * = STRUCT (header *: QueryHeader)
    notAvailable  *: INTEGER;  (* if NULL available, else see defines *)
    propertyFlags *: LONGSET;  (* Properties of this mode see defines *)
    resolution    *: Point;    (* ticks-per-pixel X/Y                 *)
    pixelSpeed    *: INTEGER;  (* aproximation in nanoseconds         *)
    numStdSprites *: INTEGER;  (* number of standard amiga sprites    *)
    paletteRange  *: INTEGER;  (* OBSOLETE - use Red/Green/Blue bits instead *)
    spriteResolution *: Point; (* std sprite ticks-per-pixel X/Y    *)
    pad           *: ARRAY 4 OF e.BYTE;
    redBits       *: e.UBYTE;  (* number of Red bits this display supports (V39) *)
    greenBits     *: e.UBYTE;  (* number of Green bits this display supports (V39) *)
    blueBits      *: e.UBYTE;  (* number of Blue bits this display supports (V39) *)
    pad2          *: ARRAY 5 OF e.UBYTE;  (* find some use for this. *)
    reserved      *: ARRAY 2 OF LONGINT;  (* terminator *)
  END;

CONST

(* availability *)

  availNoChips        * = 0001H;
  availNoMonitor      * = 0002H;
  availNotWithGenlock * = 0004H;

(* mode properties *)

  isLace           * = 0;
  isDualPF         * = 1;
  isPF2pri         * = 2;
  isHAM            * = 3;
  isECS            * = 4;  (*      note: ECS modes (SHIRES, VGA, and **
                           **      PRODUCTIVITY) do not support      **
                           **      attached sprites.                 **
                           *)
  isAA             * = 16; (* AA modes - may only be available
                           ** if machine has correct memory
                           ** type to support required
                           ** bandwidth - check availability.
                           ** (V39)
                           *)
  isPAL            * = 5;
  isSprites        * = 6;
  isGenlock        * = 7;
  isWB             * = 8;
  isDraggable      * = 9;
  isPanelled       * = 10;
  isBeamSync       * = 11;
  isExtraHalfBrite * = 12;

(* The following DIPF_IS_... flags are new for V39 *)
  isSpritesAtt      * = 13; (* supports attached sprites *)
  isSpritesChngRes  * = 14; (* supports variable sprite resolution *)
  isSpritesBorder   * = 15; (* sprite can be displayed in the border *)
  isScandbl         * = 17; (* scan doubled *)
  isSpritesChngBase * = 18; (* can change the sprite base color *)
  isSpritesChngPri  * = 19; (* can change the sprite priority
                            ** with respect to the playfield(s).
                            *)
  isDbuffer         * = 20; (* can support double buffering *)
  isProgbeam        * = 21; (* is a programmed beam-sync mode *)
  isForeign         * = 31; (* this mode is not native to the Amiga *)


TYPE

  DimensionInfo * = STRUCT (header *: QueryHeader)
    maxDepth        *: INTEGER;   (* log2( max number of colors ) *)
    minRasterWidth  *: INTEGER;   (* minimum width in pixels      *)
    minRasterHeight *: INTEGER;   (* minimum height in pixels     *)
    maxRasterWidth  *: INTEGER;   (* maximum width in pixels      *)
    maxRasterHeight *: INTEGER;   (* maximum height in pixels     *)
    nominal      *: Rectangle;    (* "standard" dimensions        *)
    maxOScan     *: Rectangle;    (* fixed, hardware dependant    *)
    videoOScan   *: Rectangle;    (* fixed, hardware dependant    *)
    txtOScan     *: Rectangle;    (* editable via preferences     *)
    stdOScan     *: Rectangle;    (* editable via preferences     *)
    pad          *: ARRAY 14 OF e.BYTE;
    reserved     *: ARRAY 2 OF LONGINT;  (* terminator *)
  END;

  MonitorInfo * = STRUCT (header *: QueryHeader)
    mspc           *: MonitorSpecPtr; (* pointer to monitor specification  *)
    viewPosition   *: Point;          (* editable via preferences          *)
    viewResolution *: Point;          (* standard monitor ticks-per-pixel  *)
    viewPositionRange *: Rectangle;   (* fixed, hardware dependant         *)
    totalRows         *: INTEGER;     (* display height in scanlines       *)
    totalColorClocks  *: INTEGER;     (* scanline width in 280 ns units    *)
    minRow        *: INTEGER;         (* absolute minimum active scanline  *)
    compatibility *: INTEGER;         (* how this coexists with others     *)
    pad           *: ARRAY 32 OF e.BYTE;
    mouseTicks    *: Point;
    defaultViewPosition *: Point;     (* original, never changes *)
    preferredModeID     *: LONGINT;   (* for Preferences *)
    reserved      *: ARRAY 2 OF LONGINT;  (* terminator *)
  END;

(******************************************************************************)

TYPE
(* The following VecInfo structure is PRIVATE, for our use only
 * Touch these, and burn! (V39)
 *)
  VecInfo  = STRUCT
     header   : QueryHeader;
     vec      : e.APTR;
     data     : e.APTR;
     type     : INTEGER;
     pad      : ARRAY 3 OF INTEGER;
     reserved : ARRAY 2 OF LONGINT;
  END;

CONST

(* monitor compatibility *)

  mCompatMixed  * =  0;       (* can share display with other mCompatMixed *)
  mCompatSelf   * =  1;       (* can share only within same monitor *)
  mCompatNobody * = -1;       (* only one viewport at a time *)

  displayNameLen * = 32;

TYPE

  NameInfo * = STRUCT (header *: QueryHeader)
    name     *: ARRAY displayNameLen OF CHAR;
    reserved *: ARRAY 2 OF LONGINT;          (* terminator *)
  END;

CONST

(* DisplayInfoRecord identifiers *)

  invalidID * = -1;

(* With all the new modes that are available under V38 and V39, it is highly
 * recommended that you use either the asl.library screenmode requester,
 * and/or the V39 graphics.library function BestModeIDA().
 *
 * DO NOT interpret the any of the bits in the ModeID for its meaning. For
 * example, do not interpret bit 3 (0x4) as meaning the ModeID is interlaced.
 * Instead, use GetDisplayInfoData() with DTAG_DISP, and examine the DIPF_...
 * flags to determine a ModeID's characteristics. The only exception to
 * this rule is that bit 7 (0x80) will always mean the ModeID is
 * ExtraHalfBright, and bit 11 (0x800) will always mean the ModeID is HAM.
 *)

(* normal identifiers *)

  monitorIDMask * = 0FFFF1000H;

  defaultMonitorID  * = 00000000H;
  ntscMonitorID     * = 00011000H;
  palMonitorID      * = 00021000H;

(* the following 22 composite keys are for Modes on the default Monitor
 * ntsc & pal "flavors" of these particular keys may be made by or'ing
 * the ntsc or pal MONITOR_ID with the desired MODE_KEY...
 * For example, to specifically open a PAL HAM interlaced ViewPort
 * (or intuition screen), you would use the modeid of
 * (PAL_MONITOR_ID | HAMLACE_KEY)
 *)

  loresKey                      * = 00000000H;
  hiresKey                      * = 00008000H;
  superKey                      * = 00008020H;
  hamKey                        * = 00000800H;
  loresLaceKey                  * = 00000004H;
  hiresLaceKey                  * = 00008004H;
  superLaceKey                  * = 00008024H;
  hamLaceKey                    * = 00000804H;
  loresDPFKey                   * = 00000400H;
  hiresDPFKey                   * = 00008400H;
  superDPFKey                   * = 00008420H;
  loresLaceDPFKey               * = 00000404H;
  hiresLaceDPFKey               * = 00008404H;
  superLaceDPFKey               * = 00008424H;
  loresDPF2Key                  * = 00000440H;
  hiresDPF2Key                  * = 00008440H;
  superDPF2Key                  * = 00008460H;
  loresLaceDPF2Key              * = 00000444H;
  hiresLaceDPF2Key              * = 00008444H;
  superLaceDPF2Key              * = 00008464H;
  extraHalfBriteKey             * = 00000080H;
  extraHalfBriteLaceKey         * = 00000084H;
(* New for AA ChipSet (V39) *)
  hiresHAMKey                   * = 000008800H;
  superHAMKey                   * = 000008820H;
  hiresEHBKey                   * = 000008080H;
  superEHBKey                   * = 0000080A0H;
  hiresHAMLaceKey               * = 000008804H;
  superHAMLaceKey               * = 000008824H;
  hiresEHBLaceKey               * = 000008084H;
  superEHBLaceKey               * = 0000080A4H;
(* Added for V40 - may be useful modes for some games or animations. *)
  loresSDblKey                  * = 000000008H;
  loresHAMSDblKey               * = 000000808H;
  loresEHBSDblKey               * = 000000088H;
  hiresHAMSDblKey               * = 000008808H;

(* VGA identifiers *)

  vgaMonitorID                  * = 00031000H;

  vgaExtraLoresKey              * = 00031004H;
  vgaLoresKey                   * = 00039004H;
  vgaProductKey                 * = 00039024H;
  vgaHAMKey                     * = 00031804H;
  vgaExtraLoresLaceKey          * = 00031005H;
  vgaLoresLaceKey               * = 00039005H;
  vgaProductLaceKey             * = 00039025H;
  vgaHAMLaceKey                 * = 00031805H;
  vgaExtraLoresDPFKey           * = 00031404H;
  vgaLoresDPFKey                * = 00039404H;
  vgaProductDPFKey              * = 00039424H;
  vgaExtraLoresLaceDPFKey       * = 00031405H;
  vgaLoresLaceDPFKey            * = 00039405H;
  vgaProductLaceDPFKey          * = 00039425H;
  vgaExtraLoresDPF2Key          * = 00031444H;
  vgaLoresDPF2Key               * = 00039444H;
  vgaProductDPF2Key             * = 00039464H;
  vgaExtraLoresLaceDPF2Key      * = 00031445H;
  vgaLoresLaceDPF2Key           * = 00039445H;
  vgaProductLaceDPF2Key         * = 00039465H;
  vgaExtraHalfBriteKey          * = 00031084H;
  vgaExtraHalfBriteLaceKey      * = 00031085H;
(* New for AA ChipSet (V39) *)
  vgaProductHAMKey              * = 000039824H;
  vgaLoresHAMKey                * = 000039804H;
  vgaExtraLoresHAMKey           * = vgaHAMKey;
  vgaProductHAMLaceKey          * = 000039825H;
  vgaLoresHAMLaceKey            * = 000039805H;
  vgaExtraLoresHAMLaceKey       * = vgaHAMLaceKey;
  vgaExtraLoresEHBKey           * = vgaExtraHalfBriteKey;
  vgaExtraLoresEHBLaceKey       * = vgaExtraHalfBriteLaceKey;
  vgaLoresEHBKey                * = 000039084H;
  vgaLoresEHBLaceKey            * = 000039085H;
  vgaEHBKey                     * = 0000390A4H;
  vgaEHBLaceKey                 * = 0000390A5H;
(* These ModeIDs are the scandoubled equivalents of the above, with the
 * exception of the DualPlayfield modes, as AA does not allow for scandoubling
 * dualplayfield.
 *)
  vgaExtraLoresDblKey           * = 000031000H;
  vgaLoresDblKey                * = 000039000H;
  vgaProductDblKey              * = 000039020H;
  vgaExtraLoresHAMDblKey        * = 000031800H;
  vgaLoresHAMDblKey             * = 000039800H;
  vgaProductHAMDblKey           * = 000039820H;
  vgaExtraLoresEHBDblKey        * = 000031080H;
  vgaLoresEHBDblKey             * = 000039080H;
  vgaProductEHBDblKey           * = 0000390A0H;

(* a2024 identifiers *)

  a2024MonitorID                * = 00041000H;

  a2024tenHertzKey              * = 00041000H;
  a2024fifteenHertzKey          * = 00049000H;

(* prototype identifiers (private ) *)

  protoMonitorID                  = 00051000H;

(* These monitors and modes were added for the V38 release. *)

  euro72MonitorId               * = 000061000H;

  euro72ExtraLoresKey           * = 000061004H;
  euro72LoresKey                * = 000069004H;
  euro72ProductKey              * = 000069024H;
  euro72HAMKey                  * = 000061804H;
  euro72ExtraLoresLaceKey       * = 000061005H;
  euro72LoresLaceKey            * = 000069005H;
  euro72ProductLaceKey          * = 000069025H;
  euro72HAMLaceKey              * = 000061805H;
  euro72ExtraLoresDPFKey        * = 000061404H;
  euro72LoresDPFKey             * = 000069404H;
  euro72ProductDPFKey           * = 000069424H;
  euro72ExtraLoresLaceDPFKey    * = 000061405H;
  euro72LoresLaceDPFKey         * = 000069405H;
  euro72ProductLaceDPFKey       * = 000069425H;
  euro72ExtraLoresDPF2Key       * = 000061444H;
  euro72LoresDPF2Key            * = 000069444H;
  euro72ProductDPF2Key          * = 000069464H;
  euro72ExtraLoresLaceDPF2Key   * = 000061445H;
  euro72LoresLaceDPF2Key        * = 000069445H;
  euro72ProductLaceDPF2Key      * = 000069465H;
  euro72ExtraHalfBriteKey       * = 000061084H;
  euro72ExtraHalfBriteLaceKey   * = 000061085H;
(* New AA modes (V39) *)
  euro72ProductHAMKey           * = 000069824H;
  euro72ProductHAMLaceKey       * = 000069825H;
  euro72LoresHAMKey             * = 000069804H;
  euro72LoresHAMLaceKey         * = 000069805H;
  euro72ExtraLoresHAMKey        * = euro72HAMKey;
  euro72ExtraLoresHAMLaceKey    * = euro72HAMLaceKey;
  euro72ExtraLoresEHBKey        * = euro72ExtraHalfBriteKey;
  euro72ExtraLoresEHBLaceKey    * = euro72ExtraHalfBriteLaceKey;
  euro72LoresEHBKey             * = 000069084H;
  euro72LoresEHBLaceKey         * = 000069085H;
  euro72EHBKey                  * = 0000690A4H;
  euro72EHBLaceKey              * = 0000690A5H;
(* These ModeIDs are the scandoubled equivalents of the above, with the
 * exception of the DualPlayfield modes, as AA does not allow for scandoubling
 * dualplayfield.
 *)
  euro72ExtraLoresDblKey        * = 000061000H;
  euro72LoresDblKey             * = 000069000H;
  euro72ProductDblKey           * = 000069020H;
  euro72ExtraLoresHAMDblKey     * = 000061800H;
  euro72LoresHAMDblKey          * = 000069800H;
  euro72ProductHAMDblKey        * = 000069820H;
  euro72ExtraLoresEHBDblKey     * = 000061080H;
  euro72LoresEHBDblKey          * = 000069080H;
  euro72ProductEHBDblKey        * = 0000690A0H;


  euro36MonitorId               * = 000071000H;


(* Euro36 modeids can be ORed with the default modeids a la NTSC and PAL.
 * For example, Euro36 SuperHires is
 * (EURO36_MONITOR_ID | SUPER_KEY)
 *)

  super72MonitorId              * = 000081000H;

(* Super72 modeids can be ORed with the default modeids a la NTSC and PAL.
 * For example, Super72 SuperHiresLace (800x600) is
 * (SUPER72_MONITOR_ID | SUPERLACE_KEY).
 * The following scandoubled Modes are the exception:
 *)
  super72LoresDblKey            * = 000081008H;
  super72HiresDblKey            * = 000089008H;
  super72SuperDblKey            * = 000089028H;
  super72LoresHAMDblKey         * = 000081808H;
  super72HiresHAMDblKey         * = 000089808H;
  super72SuperHAMDblKey         * = 000089828H;
  super72LoresEHBDblKey         * = 000081088H;
  super72HiresEHBDblKey         * = 000089088H;
  super72SuperEHBDblKey         * = 0000890A8H;


(* These monitors and modes were added for the V39 release. *)

  dblNTSCMonitorId              * = 000091000H;

  dblNTSCLoresKey               * = 000091000H;
  dblNTSCLoresffKey             * = 000091004H;
  dblNTSCLoresHAMKey            * = 000091800H;
  dblNTSCLoresHAMffKey          * = 000091804H;
  dblNTSCLoresEHBKey            * = 000091080H;
  dblNTSCLoresEHBffKey          * = 000091084H;
  dblNTSCLoresLaceKey           * = 000091005H;
  dblNTSCLoresHAMLaceKey        * = 000091805H;
  dblNTSCLoresEHBLaceKey        * = 000091085H;
  dblNTSCLoresDPFKey            * = 000091400H;
  dblNTSCLoresDPFFFKey          * = 000091404H;
  dblNTSCLoresDPFLaceKey        * = 000091405H;
  dblNTSCLoresDPF2Key           * = 000091440H;
  dblNTSCLoresDPF2FFKey         * = 000091444H;
  dblNTSCLoresDPF2LaceKey       * = 000091445H;
  dblNTSCHiresKey               * = 000099000H;
  dblNTSCHiresffKey             * = 000099004H;
  dblNTSCHiresHAMKey            * = 000099800H;
  dblNTSCHiresHAMffKey          * = 000099804H;
  dblNTSCHiresLaceKey           * = 000099005H;
  dblNTSCHiresHAMLaceKey        * = 000099805H;
  dblNTSCHiresEHBKey            * = 000099080H;
  dblNTSCHiresEHBffKey          * = 000099084H;
  dblNTSCHiresEHBLaceKey        * = 000099085H;
  dblNTSCHiresDPFKey            * = 000099400H;
  dblNTSCHiresDPFFFKey          * = 000099404H;
  dblNTSCHiresDPFLaceKey        * = 000099405H;
  dblNTSCHiresDPF2Key           * = 000099440H;
  dblNTSCHiresDPF2FFKey         * = 000099444H;
  dblNTSCHiresDPF2LaceKey       * = 000099445H;
  dblNTSCExtraLoresKey          * = 000091200H;
  dblNTSCExtraLoresHAMKey       * = 000091A00H;
  dblNTSCExtraLoresEHBKey       * = 000091280H;
  dblNTSCExtraLoresDPFKey       * = 000091600H;
  dblNTSCExtraLoresDPF2Key      * = 000091640H;
  dblNTSCExtraLoresFFKey        * = 000091204H;
  dblNTSCExtraLoresHAMFFKey     * = 000091A04H;
  dblNTSCExtraLoresEHBFFKey     * = 000091284H;
  dblNTSCExtraLoresDPFFFKey     * = 000091604H;
  dblNTSCExtraLoresDPF2FFKey    * = 000091644H;
  dblNTSCExtraLoresLaceKey      * = 000091205H;
  dblNTSCExtraLoresHAMLaceKey   * = 000091A05H;
  dblNTSCExtraLoresEHBLaceKey   * = 000091285H;
  dblNTSCExtraLoresDPFLaceKey   * = 000091605H;
  dblNTSCExtraLoresDPF2LaceKey  * = 000091645H;

  dblPALMonitorId               * = 0000A1000H;

  dblPALLoresKey                * = 0000A1000H;
  dblPALLoresFFKey              * = 0000A1004H;
  dblPALLoresHAMKey             * = 0000A1800H;
  dblPALLoresHAMFFKey           * = 0000A1804H;
  dblPALLoresEHBKey             * = 0000A1080H;
  dblPALLoresEHBFFKey           * = 0000A1084H;
  dblPALLoresLaceKey            * = 0000A1005H;
  dblPALLoresHAMLaceKey         * = 0000A1805H;
  dblPALLoresEHBLaceKey         * = 0000A1085H;
  dblPALLoresDPFKey             * = 0000A1400H;
  dblPALLoresDPFFFKey           * = 0000A1404H;
  dblPALLoresDPFLaceKey         * = 0000A1405H;
  dblPALLoresDPF2Key            * = 0000A1440H;
  dblPALLoresDPF2FFKey          * = 0000A1444H;
  dblPALLoresDPF2LaceKey        * = 0000A1445H;
  dblPALHiresKey                * = 0000A9000H;
  dblPALHiresFFKey              * = 0000A9004H;
  dblPALHiresHAMKey             * = 0000A9800H;
  dblPALHiresHAMFFKey           * = 0000A9804H;
  dblPALHiresLaceKey            * = 0000A9005H;
  dblPALHiresHAMLaceKey         * = 0000A9805H;
  dblPALHiresEHBKey             * = 0000A9080H;
  dblPALHiresEHBFFKey           * = 0000A9084H;
  dblPALHiresEHBLaceKey         * = 0000A9085H;
  dblPALHiresDPFKey             * = 0000A9400H;
  dblPALHiresDPFFFKey           * = 0000A9404H;
  dblPALHiresDPFLaceKey         * = 0000A9405H;
  dblPALHiresDPF2Key            * = 0000A9440H;
  dblPALHiresDPF2FFKey          * = 0000A9444H;
  dblPALHiresDPF2LaceKey        * = 0000A9445H;
  dblPALExtraLoresKey           * = 0000A1200H;
  dblPALExtraLoresHAMKey        * = 0000A1A00H;
  dblPALExtraLoresEHBKey        * = 0000A1280H;
  dblPALExtraLoresDPFKey        * = 0000A1600H;
  dblPALExtraLoresDPF2Key       * = 0000A1640H;
  dblPALExtraLoresFFKey         * = 0000A1204H;
  dblPALExtraLoresHAMFFKey      * = 0000A1A04H;
  dblPALExtraLoresEHBFFKey      * = 0000A1284H;
  dblPALExtraLoresDPFFFKey      * = 0000A1604H;
  dblPALExtraLoresDPF2FFKey     * = 0000A1644H;
  dblPALExtraLoresLaceKey       * = 0000A1205H;
  dblPALExtraLoresHAMLaceKey    * = 0000A1A05H;
  dblPALExtraLoresEHBLaceKey    * = 0000A1285H;
  dblPALExtraLoresDPFLaceKey    * = 0000A1605H;
  dblPALExtraLoresDPF2LaceKey   * = 0000A1645H;

(* Use these tags for passing to BestModeID() (V39) *)

  specialFlags * = LONGSET{isDualPF, isPF2pri, isHAM, isExtraHalfBrite};

  bidTagDipfMustHave     * = 080000001H;  (* mask of the DIPF_ flags the ModeID must have *)
                                          (* Default - NULL *)
  bidTagDipfMustNotHave  * = 080000002H;  (* mask of the DIPF_ flags the ModeID must not have *)
                                          (* Default - SPECIAL_FLAGS *)
  bidTagViewPort         * = 080000003H;  (* ViewPort for which a ModeID is sought. *)
                                          (* Default - NULL *)
  bidTagNominalWidth     * = 080000004H;  (* \ together make the aspect ratio and *)
  bidTagNominalHeight    * = 080000005H;  (* / override the vp->Width/Height. *)
                                          (* Default - SourceID NominalDimensionInfo,
                                           * or vp->DWidth/Height, or (640 * 200),
                                           * in that preferred order.
                                           *)
  bidTagDesiredWidth     * = 080000006H;  (* \ Nominal Width and Height of the *)
  bidTagDesiredHeight    * = 080000007H;  (* / returned ModeID. *)
                                          (* Default - same as Nominal *)
  bidTagDepth            * = 080000008H;  (* ModeID must support this depth. *)
                                          (* Default - vp->RasInfo->BitMap->Depth or 1 *)
  bidTagMonitorID        * = 080000009H;  (* ModeID must use this monitor. *)
                                          (* Default - use best monitor available *)
  bidTagSourceID         * = 08000000AH;  (* instead of a ViewPort. *)
                                (* Default - VPModeID(vp) if BIDTAG_ViewPort is
                                 * specified, else leave the DIPFMustHave and
                                 * DIPFMustNotHave values untouched.
                                 *)
  bidTagRedBits          * = 08000000BH;  (* \                            *)
  bidTagBlueBits         * = 08000000CH;  (* } Match up from the database *)
  bidTagGreenBits        * = 08000000DH;  (* /                            *)
                                          (* Default - 4 *)
  bidTagGfxPrivate         = 08000000EH;  (* Private *)


(* VSprite flags *)
(* user-set VSprite flags: *)
  sUserFlags* = {0..7}; (* mask of all user-settable VSprite-flags *)
  vsprite   * = 0;      (* set if VSprite, clear if Bob *)
  saveBack  * = 1;      (* set if background is to be saved/restored *)
  overlay   * = 2;      (* set to mask image of Bob onto background *)
  mustDraw  * = 3;      (* set if VSprite absolutely must be drawn *)
(* system-set VSprite flags: *)
  backSaved * = 8;      (* this Bob's background has been saved *)
  bobUpdate * = 9;      (* temporary flag, useless to outside world *)
  gelGone   * = 10;     (* set if gel is completely clipped (offscreen) *)
  vsOverflow* = 11;     (* VSprite overflow (if MUSTDRAW set we draw!) *)

(* Bob flags *)
(* these are the user flag bits *)
  bUserFlags * = {0..7};(* mask of all user-settable Bob-flags *)
  saveBob     * = 0;    (* set to not erase Bob *)
  bobIsComp   * = 1;    (* set to identify Bob as AnimComp *)
(* these are the system flag bits *)
  bWaiting    * = 8;    (* set while Bob is waiting on 'after' *)
  bDrawn      * = 9;    (* set when Bob is drawn this DrawG pass*)
  bobsAway    * = 10;   (* set to initiate removal of Bob *)
  bobNix      * = 11;   (* set when Bob is completely removed *)
  savePreserve * = 12;  (* for back-restore during double-buffer*)
  outStep     * = 13;   (* for double-clearing if double-buffer *)

(* defines for the animation procedures *)
  anfracsize  * = 6;
  animhalf    * = 0020H;
  ringTrigger * = 0001H;


TYPE

(* UserStuff definitions
 *  the user can define these to be a single variable or a sub-structure
 *  if undefined by the user, the system turns these into innocuous variables
 *  see the manual for a thorough definition of the UserStuff definitions
 *
 *)
  VUserStuff * = INTEGER;

  BUserStuff * = INTEGER;

  AUserStuff * = INTEGER;



(*********************** GEL STRUCTURES ***********************************)

  VSprite * = STRUCT

(* --------------------- SYSTEM VARIABLES ------------------------------- *)
(* GEL linked list forward/backward pointers sorted by y,x value *)
    nextVSprite *: VSpritePtr;
    prevVSprite *: VSpritePtr;

(* GEL draw list constructed in the order the Bobs are actually drawn, then
 *  list is copied to clear list
 *  must be here in VSprite for system boundary detection
 *)
    drawPath    *: VSpritePtr;   (* pointer of overlay drawing *)
    clearPath   *: VSpritePtr;   (* pointer for overlay clearing *)

(* the VSprite positions are defined in (y,x) order to make sorting
 *  sorting easier, since (y,x) as a long integer
 *)
    oldY *, oldX *: INTEGER;     (* previous position *)

(* --------------------- COMMON VARIABLES --------------------------------- *)
    flags        *: SET;       (* VSprite flags *)


(* --------------------- USER VARIABLES ----------------------------------- *)
(* the VSprite positions are defined in (y,x) order to make sorting
 *  sorting easier, since (y,x) as a long integer
 *)
    y * ,x *    : INTEGER;       (* screen position *)

    height     *: INTEGER;
    width      *: INTEGER;       (* number of words per row of image data *)
    depth      *: INTEGER;       (* number of planes of data *)

    meMask     *: SET;           (* which types can collide with this VSprite*)
    hitMask    *: SET;           (* which types this VSprite can collide with*)

    imageData  *: e.APTR;        (* pointer to VSprite image *)

(* borderLine is the one-dimensional logical OR of all
 *  the VSprite bits, used for fast collision detection of edge
 *)
    borderLine *: e.APTR;        (* logical OR of all VSprite bits *)
    collMask   *: e.APTR;        (* similar to above except this is a matrix *)

(* pointer to this VSprite's color definitions (not used by Bobs) *)
    sprColors  *: e.APTR;

    vsBob      *: BobPtr;        (* points home if this VSprite is part of
                                    a Bob *)

(* planePick flag:  set bit selects a plane from image, clear bit selects
 *  use of shadow mask for that plane
 * OnOff flag: if using shadow mask to fill plane, this bit (corresponding
 *  to bit in planePick) describes whether to fill with 0's or 1's
 * There are two uses for these flags:
 *      - if this is the VSprite of a Bob, these flags describe how the Bob
 *        is to be drawn into memory
 *      - if this is a simple VSprite and the user intends on setting the
 *        MUSTDRAW flag of the VSprite, these flags must be set too to describe
 *        which color registers the user wants for the image
 *)
    planePick  *: SHORTSET;
    planeOnOff *: SHORTSET;

    vUserExt   *: VUserStuff;    (* user definable:  see note above *)
  END;

  Bob * = STRUCT
(* blitter-objects *)

(* --------------------- SYSTEM VARIABLES --------------------------------- *)

(* --------------------- COMMON VARIABLES --------------------------------- *)
    flags       *: SET;     (* general purpose flags (see definitions below) *)

(* --------------------- USER VARIABLES ----------------------------------- *)
    saveBuffer  *: e.APTR;  (* pointer to the buffer for background save *)

(* used by Bobs for "cookie-cutting" and multi-plane masking *)
    imageShadow *: e.APTR;

(* pointer to BOBs for sequenced drawing of Bobs
 *  for correct overlaying of multiple component animations
 *)
    before      *: BobPtr;        (* draw this Bob before Bob pointed to by before *)
    after       *: BobPtr;        (* draw this Bob after Bob pointed to by after *)

    bobVSprite  *: VSpritePtr;    (* this Bob's VSprite definition *)

    bobComp     *: AnimCompPtr;   (* pointer to this Bob's AnimComp def *)

    dBuffer     *: DBufPacketPtr; (* pointer to this Bob's dBuf packet *)

    bUserExt    *: BUserStuff;    (* Bob user extension *)
  END;

  AnimComp * = STRUCT

(* --------------------- SYSTEM VARIABLES --------------------------------- *)

(* --------------------- COMMON VARIABLES --------------------------------- *)
    flags       *: SET;           (* AnimComp flags for system & user *)

(* timer defines how long to keep this component active:
 *  if set non-zero, timer decrements to zero then switches to nextSeq
 *  if set to zero, AnimComp never switches
 *)
    timer       *: INTEGER;

(* --------------------- USER VARIABLES ----------------------------------- *)
(* initial value for timer when the AnimComp is activated by the system *)
    timeSet      *: INTEGER;

(* pointer to next and previous components of animation object *)
    nextComp     *: AnimCompPtr;
    prevComp     *: AnimCompPtr;

(* pointer to component component definition of next image in sequence *)
    nextSeq      *: AnimCompPtr;
    prevSeq      *: AnimCompPtr;

    animCRoutine *: e.PROC;    (* address of special animation procedure *)

    yTrans       *: INTEGER;   (* initial y translation (if this is a component) *)
    xTrans       *: INTEGER;   (* initial x translation (if this is a component) *)

    headOb       *: AnimObPtr;

    animBob      *: BobPtr;
  END;

  AnimOb * = STRUCT

(* --------------------- SYSTEM VARIABLES --------------------------------- *)
    nextOb *, prevOb *: AnimObPtr;

(* number of calls to Animate this AnimOb has endured *)
    clock        *: LONGINT;

    anOldY *, anOldX *: INTEGER;            (* old y,x coordinates *)

(* --------------------- COMMON VARIABLES --------------------------------- *)
    anY *, anX  *: INTEGER;                 (* y,x coordinates of the AnimOb *)

(* --------------------- USER VARIABLES ----------------------------------- *)
    yVel *, xVel *    : INTEGER;            (* velocities of this object *)
    yAccel *, xAccel *: INTEGER;            (* accelerations of this object *)

    ringYTrans *, ringXTrans *: INTEGER;    (* ring translation values *)

    animoRoutine *: e.PROC;                 (* address of special animation
                                               procedure *)

    headComp     *: AnimCompPtr;            (* pointer to first component *)

    aUserExt     *: AUserStuff;             (* AnimOb user extension *)
  END;


(* dBufPacket defines the values needed to be saved across buffer to buffer
 *  when in double-buffer mode
 *)
  DBufPacket * = STRUCT
    bufY *, bufX *: INTEGER;      (* save the other buffers screen coordinates *)
    bufPath      *: VSpritePtr;   (* carry the draw path over the gap *)

(* these pointers must be filled in by the user *)
(* pointer to other buffer's background save buffer *)
    bufBuffer    *: e.APTR;
  END;


CONST

(* ************************************************************************ *)

  b2Norm    * = 0;
  b2Swap    * = 1;
  b2Bobber  * = 2;

(* ************************************************************************ *)

TYPE

(* a structure to contain the 16 collision procedure addresses *)
  CollTable * = STRUCT
    collPtrs *: ARRAY 16 OF e.APTR;
  END;

(* structure used by AddTOFTask *)
  Isrvstr * = STRUCT (node *: e.Node)
    iptr  *: IsrvstrPtr;   (* passed to srvr by os *)
    code  *: e.PROC;
    ccode *: e.PROC;
    carg  *: LONGINT;
  END;

CONST

(* Layers *)

  layerSimple        * =  0;
  layerSmart         * =  1;
  layerSuper         * =  2;
  layerUpdating      * =  4;
  layerBackdrop      * =  6;
  layerRefresh       * =  7;
  layerIRefresh      * =  9;
  layerIRefresh2     * = 10;
  layerClipRectsLost * =  8;  (* during BeginUpdate *)
                              (* or during layerop *)
                              (* this happens if out of memory *)
  lmnRegion * = -1;           (* removed in V39 includes *)

TYPE

  LayerInfo * = STRUCT
    layer * : LayerPtr;
    lp      : LayerPtr;             (* !!PRIVATE!! *)
    obs   * : ClipRectPtr;
    freeClipRects   : ClipRectPtr;  (* !!PRIVATE!! *)
    privateReserve1 : LONGINT;      (* !!PRIVATE!! *)
    privateReserve2 : LONGINT;      (* !!PRIVATE!! *)
    lock  : e.SignalSemaphore;      (* !!PRIVATE!! *)
    head  : e.MinList;              (* !!PRIVATE!! *)
    privateReserve3 : INTEGER;      (* !!PRIVATE!! *)
    privateReserve4 : e.APTR;       (* !!PRIVATE!! *)
    flags * : SET;
    count   : SHORTINT;             (* !!PRIVATE!! *)
    lockLayersCount : SHORTINT;     (* !!PRIVATE!! *)
    privateReserve5 : INTEGER;      (* !!PRIVATE!! *)
    blankHook : e.APTR;             (* !!PRIVATE!! *)
    extra     : e.APTR;             (* !!PRIVATE!! *)
  END;

CONST
  newLayerInfoCalled * = 1;
  alertLayersNoMem   * = 83010000H;  (* removed in V39 includes *)

(*
 * LAYERS_NOBACKFILL is the value needed to get no backfill hook
 * LAYERS_BACKFILL is the value needed to get the default backfill hook
 *)
  noBackFill * = SYSTEM.VAL(u.HookPtr,1);
  backFill   * = SYSTEM.VAL(u.HookPtr,0);

TYPE

  AreaInfo * = STRUCT
    vctrTbl  *: e.APTR;          (* ptr to start of vector table *)
    vctrPtr  *: e.APTR;          (* ptr to current vertex *)
    flagTbl  *: e.APTR;          (* ptr to start of vector flag table *)
    flagPtr  *: e.APTR;          (* ptrs to areafill flags *)
    count    *: INTEGER;         (* number of vertices in list *)
    maxCount *: INTEGER;         (* AreaMove/Draw will not allow Count>MaxCount*)
    firstX *, firstY *: INTEGER; (* first point for this polygon *)
  END;

  TmpRas * = STRUCT
    rasPtr *: e.APTR;
    size   *: LONGINT;
  END;

(* unoptimized for 32bit alignment of pointers *)
  GelsInfo * = STRUCT
    sprRsrvd      *: SHORTINT;     (* flag of which sprites to reserve from
                                      vsprite system *)
    flags         *: e.BYTE;       (* system use only *)
    gelHead       *,
    gelTail       *: VSpritePtr;   (* dummy vSprites for list management*)
    (* pointer to array of 8 WORDS for sprite available lines *)
    nextLine      *: e.APTR;
    (* pointer to array of 8 pointers for color-last-assigned to vSprites *)
    lastColor     *: e.APTR;
    collHandler   *: CollTablePtr; (* addresses of collision routines *)
    leftmost      *,
    rightmost     *,
    topmost       *,
    bottommost    *: INTEGER;
    firstBlissObj *, lastBlissObj *: e.APTR; (* system use only *)
  END;

  RastPort * = STRUCT
    layer      *: LayerPtr;
    bitMap     *: BitMapPtr;
    areaPtrn   *: e.APTR;       (* ptr to areafill pattern *)
    tmpRas     *: TmpRasPtr;
    areaInfo   *: AreaInfoPtr;
    gelsInfo   *: GelsInfoPtr;
    mask       *: SHORTSET;     (* write mask for this raster *)
    fgPen      *: SHORTINT;     (* foreground pen for this raster *)
    bgPen      *: SHORTINT;     (* background pen  *)
    aOlPen     *: SHORTINT;     (* areafill outline pen *)
    drawMode   *: SHORTSET;     (* drawing mode for fill, lines, and text *)
    areaPtSz   *: SHORTINT;     (* 2^n words for areafill pattern *)
    linPatCnt  *: SHORTINT;     (* current line drawing pattern preshift *)
    dummy      *: e.BYTE;
    flags      *: SET;          (* miscellaneous control bits *)
    linePtrn   *: INTEGER;      (* 16 bits for textured lines *)
    x * , y    *: INTEGER;      (* current pen position *)
    minterms   *: ARRAY 8 OF e.BYTE;
    penWidth   *: INTEGER;
    penHeight  *: INTEGER;
    font       *: TextFontPtr;  (* current font address *)
    algoStyle  *: SHORTSET;     (* the algorithmically generated style *)
    txFlags    *: SHORTSET;     (* text specific flags *)
    txHeight   *: INTEGER;      (* text height *)
    txWidth    *: INTEGER;      (* text nominal width *)
    txBaseline *: INTEGER;      (* text baseline *)
    txSpacing  *: INTEGER;      (* text spacing (per character) *)
    user       *: e.APTR;
    longreserved *: ARRAY 2 OF LONGINT;
    wordreserved *: ARRAY 7 OF INTEGER; (* used to be a node *)
    reserved     *: ARRAY 8 OF e.BYTE;  (* for future use *)
  END;

CONST

(* drawing modes *)
  jam1        * = SHORTSET{};  (* jam 1 color into raster *)
  jam2        * = SHORTSET{0}; (* jam 2 colors into raster *)
  complement  * = 1;           (* XOR bits into raster *)
  inversvid   * = 2;           (* inverse video for drawing modes *)

(* these are the flag bits for RastPort flags *)
  firstDot    * = 0;      (* draw the first dot of this line ? *)
  oneDot      * = 1;      (* use one dot mode for drawing lines *)
  dBuffer     * = 2;      (* flag set when RastPorts are double-buffered *)

             (* only used for bobs *)

  areaOutline * = 3;      (* used by areafiller *)
  noCrossFill * = 5;      (* areafills have no crossovers *)

(* there is only one style of clipping: raster clipping *)
(* this preserves the continuity of jaggies regardless of clip window *)
(* When drawing into a RastPort, if the ptr to ClipRect is nil then there *)
(* is no clipping done, this is dangerous but useful for speed *)

TYPE

  RegionRectangle * = STRUCT
    next *, prev *: RegionRectanglePtr;
    bounds       *: Rectangle;
  END;

  Region * = STRUCT (bounds *: Rectangle)
    regionRectangle *: RegionRectanglePtr;
  END;


  BitScaleArgs * = STRUCT
    srcX         *, srcY        *: INTEGER; (* source origin *)
    srcWidth     *, srcHeight   *: INTEGER; (* source size *)
    xSrcFactor   *, ySrcFactor  *: INTEGER; (* scale factor denominators *)
    destX        *, destY       *: INTEGER; (* destination origin *)
    destWidth    *, destHeight  *: INTEGER; (* destination size result *)
    xDestFactor  *, yDestFactor *: INTEGER; (* scale factor numerators *)
    srcBitMap    *: BitMapPtr;              (* source BitMap *)
    destBitMap   *: BitMapPtr;              (* destination BitMap *)
    flags        *: LONGSET;                (* reserved.  Must be zero! *)
    xdda *, ydda *: INTEGER;                (* reserved *)
    reserved1    *: LONGINT;
    reserved2    *: LONGINT;
  END;

CONST

  spriteAttached * = 80H;

TYPE

  SimpleSprite * = STRUCT
    posctldata *: e.APTR;
    height     *: INTEGER;
    x *, y *    : INTEGER;    (* current position *)
    num        *: INTEGER;
  END;

  ExtSprite * = STRUCT (simpleSprite *: SimpleSprite)
                            (* conventional simple sprite structure *)
    wordwidth *: INTEGER;   (* graphics use only, subject to change *)
    flags     *: SET;       (* graphics use only, subject to change *)
  END;


CONST
(* tags for AllocSpriteData() *)
  spriteaWidth         * =  081000000H;
  spriteaXreplication  * =  081000002H;
  spriteaYreplication  * =  081000004H;
  spriteaOutputheight  * =  081000006H;
  spriteaAttached      * =  081000008H;
  spriteaOlddataformat * =  08100000AH; (* MUST pass in outputheight if using this tag *)

(* tags for GetExtSprite() *)
  gstagSpriteNum  * = 082000020H;
  gstagAttached   * = 082000022H;
  gstagSoftsprite * = 082000024H;

(* tags valid for either GetExtSprite or ChangeExtSprite *)
  gstagScandoubled * = 083000000H;  (* request "NTSC-Like" height if possible. *)

CONST

(*------ Font Styles ------------------------------------------------*)
  normal      * = SHORTSET{};  (* normal text (no style bits set) *)
  normalFont  * = SHORTSET{};  (* prehistoric synonym             *)
  underlined  * = 0;       (* underlined (under baseline) *)
  bold        * = 1;       (* bold face text (ORed w/ shifted) *)
  italic      * = 2;       (* italic (slanted 1:2 right) *)
  extended    * = 3;       (* extended face (wider than normal) *)

  colorFont   * = 6;       (* this uses ColorTextFont structure *)
  tagged      * = 7;       (* the TextAttr is really an TTextAttr, *)

(*------ Font Flags -------------------------------------------------*)
  romFont     * = 0;       (* font is in rom *)
  diskFont    * = 1;       (* font is from diskfont.library *)
  revPath     * = 2;       (* designed path is reversed (e.g. left) *)
  tallDot     * = 3;       (* designed for hires non-interlaced *)
  wideDot     * = 4;       (* designed for lores interlaced *)
  proportional * = 5;      (* character sizes can vary from nominal *)
  designed    * = 6;       (* size explicitly designed, not constructed *)
                           (* note: if you do not set this bit in your *)
                           (* textattr, then a font may be constructed *)
                           (* for you by scaling an existing rom or disk *)
                           (* font (under V36 and above). *)
    (* bit 7 is always clear for fonts on the graphics font list *)
  removed     * = 7;       (* the font has been removed *)

TYPE

(****** TextAttr node, matches text attributes in RastPort **********)
  TextAttr * = STRUCT
    name   *: e.LSTRPTR;     (* name of the font *)
    ySize  *: INTEGER;       (* height of the font *)
    style  *: SHORTSET;      (* intrinsic font style *)
    flags  *: SHORTSET;      (* font preferences and flags *)
  END;

  TTextAttr * = STRUCT
    name   *: e.LSTRPTR;     (* name of the font *)
    ySize  *: INTEGER;       (* height of the font *)
    style  *: SHORTSET;      (* intrinsic font style *)
    flags  *: SHORTSET;      (* font preferences and flags *)
    tags   *: u.TagListPtr;  (* extended attributes *)
  END;

CONST

(****** Text Tags ***************************************************)
  deviceDPI   * = 1+u.user;    (* Tag value is Point union: *)
                               (* Hi word XDPI, Lo word YDPI *)

  maxFontMatchweight * = 32767;  (* perfect match from WeighTAMatch *)

TYPE

(****** TextFonts node **********************************************)
  TextFont * = STRUCT (message *: e.Message)
                          (* reply message for font removal *)
                          (* font name in LN        \    used in this *)
    ySize     *: INTEGER; (* font height            |    order to best *)
    style     *: SHORTSET;(* font style             |    match a font *)
    flags     *: SHORTSET;(* preferences and flags  /    request. *)
    xSize     *: INTEGER; (* nominal font width *)
    baseline  *: INTEGER; (* distance from the top of char to baseline *)
    boldSmear *: INTEGER; (* smear to affect a bold enhancement *)

    accessors *: INTEGER; (* access count *)

    loChar    *: CHAR;    (* the first character described here *)
    hiChar    *: CHAR;    (* the last character described here *)
    charData  *: e.APTR;  (* the bit character data *)

    modulo    *: INTEGER; (* the row modulo for the strike font data *)
    charLoc   *: e.APTR;  (* ptr to location data for the strike font *)
                          (*   2 words: bit offset then size *)
    charSpace *: e.APTR;  (* ptr to words of proportional spacing data *)
    charKern  *: e.APTR;  (* ptr to words of kerning data *)
  END;

CONST

(*----- TextFontExtension.flags0 (partial definition) ----------------------------*)
  noRemFont * = 0;        (* disallow RemFont for this font *)

TYPE

  TextFontExtension * = STRUCT     (* this structure is read-only *)
    matchWord     -: INTEGER;      (* a magic cookie for the extension *)
    flags0        -: SHORTSET;     (* (system private flags) *)
    flags1         : SHORTSET;     (* (system private flags) *)
    backPtr       -: TextFontPtr;  (* validation of compilation *)
    origReplyPort -: e.MsgPortPtr; (* original value in tf_Extension *)
    tags          -: u.TagListPtr; (* Text Tags for the font *)
    oFontPatchS    : e.APTR;       (* (system private use) *)
    oFontPatchK    : e.APTR;       (* (system private use) *)
    (* this space is reserved for future expansion *)
  END;

CONST

(****** ColorTextFont node ******************************************)
(*----- ColorTextFont.flags ----------------------------------------*)
  ctColorMask  * = {0..3}; (* mask to get to following color styles *)
  ctColorFont  * = 0;      (* color map contains designer's colors *)
  ctGreyFont   * = 1;      (* color map describes even-stepped *)
                           (* brightnesses from low to high *)
  ctAntiAlias  * = 2;      (* zero background thru fully saturated char *)

  ctMapColor   * = 0;      (* map ctf_FgColor to the rp_FgPen if it's *)
                           (* is a valid color within ctf_Low..ctf_High *)

TYPE

(*----- ColorFontColors --------------------------------------------*)
  ColorFontColors * = STRUCT
    reserved   *: INTEGER;   (* *must* be zero *)
    count      *: INTEGER;   (* number of entries in cfc_ColorTable *)
    colorTable *: e.APTR;    (* 4 bit per component color map packed xRGB *)
  END;

(*----- ColorTextFont ----------------------------------------------*)
  ColorTextFont * = STRUCT (tf *: TextFont)
    flags        *: SET;      (* extended flags *)
    depth        *: SHORTINT; (* number of bit planes *)
    fgColor      *: SHORTINT; (* color that is remapped to FgPen *)
    low          *: SHORTINT; (* lowest color represented here *)
    high         *: SHORTINT; (* highest color represented here *)
    planePick    *: SHORTSET; (* PlanePick ala Images *)
    planeOnOff   *: SHORTSET; (* PlaneOnOff ala Images *)
    colorFontColors *: ColorFontColorsPtr; (* colors for font *)
    charData     *: ARRAY 8 OF e.APTR; (*pointers to bit planes ala tf_CharData *)
  END;

(****** TextExtent node *********************************************)
  Textextent * = STRUCT
    width   *: INTEGER;    (* same as TextLength *)
    height  *: INTEGER;    (* same as tf_YSize *)
    extent  *: Rectangle;  (* relative to CP *)
  END;

CONST

  vtagEndCM              * = 00000000H;
  vtagChromaKeyClr       * = 80000000H;
  vtagChromaKeySet       * = 80000001H;
  vtagBitPlaneKeyClr     * = 80000002H;
  vtagBitPlaneKeySet     * = 80000003H;
  vtagBorderBlankClr     * = 80000004H;
  vtagBorderBlankSet     * = 80000005H;
  vtagBorderNoTransClr   * = 80000006H;
  vtagBorderNoTransSet   * = 80000007H;
  vtagChromaPenClr       * = 80000008H;
  vtagChromaPenSet       * = 80000009H;
  vtagChromaPlaneSet     * = 8000000AH;
  vtagAttachCMSet        * = 8000000BH;
  vtagNextBufCM          * = 8000000CH;
  vtagBatchCMClr         * = 8000000DH;
  vtagBatchCMSet         * = 8000000EH;
  vtagNormalDispGet      * = 8000000FH;
  vtagNormalDisplSet     * = 80000010H;
  vtagCoerceDispGet      * = 80000011H;
  vtagCoerceDispSet      * = 80000012H;
  vtagViewPortExtraGet   * = 80000013H;
  vtagViewPortExtraSet   * = 80000014H;
  vtagChromaKeyGet       * = 80000015H;
  vtagBitPlaneKeyGet     * = 80000016H;
  vtagBorderBlankGet     * = 80000017H;
  vtagBorderNoTransGet   * = 80000018H;
  vtagChromaPenGet       * = 80000019H;
  vtagChromaPlaneGet     * = 8000001AH;
  vtagAttachCMGet        * = 8000001BH;
  vtagBatchCMGet         * = 8000001CH;
  vtagBatchItemsGet      * = 8000001DH;
  vtagBatchItemsSet      * = 8000001EH;
  vtagBatchItemsAdd      * = 8000001FH;
  vtagVPModeIDGet        * = 80000020H;
  vtagVPMoedIDSet        * = 80000021H;
  vtagVPModeIDClr        * = 80000022H;
  vtagUserClipGet        * = 80000023H;
  vtagUserClipSet        * = 80000024H;
  vtagUserClipClr        * = 80000025H;
(* the following tags are V39 specific. They will be ignored (returing error -3) by
      earlier versions *)
  vtagPf1BaseGet         * = 080000026H;
  vtagPf2BaseGet         * = 080000027H;
  vtagSpEvenBaseGet      * = 080000028H;
  vtagSpOddBaseGet       * = 080000029H;
  vtagPf1BaseSet         * = 08000002AH;
  vtagPf2BaseSet         * = 08000002BH;
  vtagSpEvenBaseSet      * = 08000002CH;
  vtagSpOddBaseSet       * = 08000002DH;
  vtagBorderSpriteGet    * = 08000002EH;
  vtagBorderSpriteSet    * = 08000002FH;
  vtagBorderSpriteClr    * = 080000030H;
  vtagSpriteResnSet      * = 080000031H;
  vtagSpriteResnGet      * = 080000032H;
  vtagPf1ToSpritePriSet  * = 080000033H;
  vtagPf1ToSpritePriGet  * = 080000034H;
  vtagPf2ToSpritePriSet  * = 080000035H;
  vtagPf2ToSpritePriGet  * = 080000036H;
  vtagImmediate          * = 080000037H;
  vtagFullPaletteSet     * = 080000038H;
  vtagFullPaletteGet     * = 080000039H;
  vtagFullPaletteClr     * = 08000003AH;
  vtagDefSpriteResnSet   * = 08000003BH;
  vtagDefSpriteResnGet   * = 08000003CH;

(* all the following tags follow the new, rational standard for videocontrol tags:
 * VC_xxx,state         set the state of attribute 'xxx' to value 'state'
 * VC_xxx_QUERY,&var    get the state of attribute 'xxx' and store it into the longword
 *                      pointed to by &var.
 *
 * The following are new for V40:
 *)

  vcIntermediateCLUpdate        * = 080000080H;
        (* default=true. When set graphics will update the intermediate copper
         * lists on color changes, etc. When false, it won't, and will be faster.
         *)
  vcIntermediateCLUpdateQuery   * = 080000081H;

  vcNoColorPaletteLoad          * = 080000082H;
        (* default = false. When set, graphics will only load color 0
         * for this ViewPort, and so the ViewPort's colors will come
         * from the previous ViewPort's.
         *
         * NB - Using this tag and VTAG_FULLPALETTE_SET together is undefined.
         *)
  vcNoColorPaletteLoadQuery     * = 080000083H;

  vcDualPFDisable               * = 080000084H;
        (* default = false. When this flag is set, the dual-pf bit
           in Dual-Playfield screens will be turned off. Even bitplanes
           will still come from the first BitMap and odd bitplanes
           from the second BitMap, and both R[xy]Offsets will be
           considered. This can be used (with appropriate palette
           selection) for cross-fades between differently scrolling
           images.
           When this flag is turned on, colors will be loaded for
           the viewport as if it were a single viewport of depth
           depth1+depth2 *)
  vcDualPFDisableQuery          * = 080000085H;


TYPE

  ViewPort * = STRUCT
    next     *: ViewPortPtr;
    colorMap *: ColorMapPtr;     (* table of colors for this viewport *)
                 (* if this is nil, MakeVPort assumes default values *)
    dspIns   *: CopListDummyPtr; (* user by MakeVPort() *)
    sprIns   *: CopListDummyPtr; (* used by sprite stuff *)
    clrIns   *: CopListDummyPtr; (* used by sprite stuff *)
    uCopIns  *: UCopListPtr;     (* User copper list *)
    dWidth   *, dHeight  *: INTEGER;
    dxOffset *, dyOffset *: INTEGER;
    modes    *: SET;
    spritePriorities *: SHORTINT;
    extendedModes *: SHORTINT;
    rasInfo       *: RasInfoPtr;
  END;


  View * = STRUCT
    viewPort   *: ViewPortPtr;
    lofCprList *: CprlistPtr;  (* used for interlaced and noninterlaced *)
    shfCprList *: CprlistPtr;  (* only used during interlace *)
    dyOffset   *, dxOffset *: INTEGER;   (* for complete View positioning *)
                               (* offsets are +- adjustments to standard #s *)
    modes      *: SET;         (* such as INTERLACE, GENLOC *)
  END;

(* these structures are obtained via GfxNew *)
(* and disposed by GfxFree *)
  ViewExtra * = STRUCT (n *: ExtendedNode)
    view    *: ViewPtr;        (* backwards link *)
    monitor *: MonitorSpecPtr; (* monitors for this view *)
    topLine *: INTEGER;
  END;

(* this structure is obtained via GfxNew *)
(* and disposed by GfxFree *)
  ViewPortExtra * = STRUCT (n *: ExtendedNode)
    viewPort    *: ViewPortPtr;   (* backwards link *)
    displayClip *: Rectangle;  (* hmakeVPort display clipping information *)
    (* These are added for V39 *)
    vecTable     : e.APTR;       (* Private *)
    driverData  *: ARRAY 2 OF e.APTR;
    flags       *: SET;
    origin      *: ARRAY 2 OF Point; (* First visible point relative to the DClip.
                                      * One for each possible playfield.
                                      *)
    cop1ptr      : LONGINT;        (* private *)
    cop2ptr      : LONGINT;        (* private *)
  END;

CONST
(* defines used for Modes in IVPargs *)

  genLockVideo    * = 1;
  lace            * = 2;
  doubleScan      * = 3;
  superHires      * = 5;
  pfba            * = 6;
  extraHalfbrite  * = 7;
  genlockAudio    * = 8;
  dualpf          * = 10;
  ham             * = 11;
  extendedMode    * = 12;
  vpHide          * = 13;
  sprites         * = 14;
  hires           * = 15;

(* ViewPort *)
(* All these VPXF_ flags are private *)
  vpxbFreeMe        = 0;       (* private *)
  vpxbLast          = 1;
  vpxbStraddles256  = 4;
  vpxbStraddles512  = 5;

  extendVStruct * = 12;   (* unused bit in Modes field of View *)

  a2024     * = 6;   (* VP?_ fields internal only *)
  tenHz     * = 4;   (* may be wrong [hG] *)

(* old definition from 2.04 includes [hG]
  a2024     * = 6;
  agnus     * = 5;
  tenHz     * = 5;
*)
TYPE

  RasInfo * = STRUCT (* used by callers to and InitDspC() *)
    next     *: RasInfoPtr;          (* used for dualpf *)
    bitMap   *: BitMapPtr;
    rxOffset *, ryOffset *: INTEGER; (* scroll offsets in this BitMap *)
  END;

  ColorMap * = STRUCT
    flags        *: SHORTSET;
    type         *: SHORTINT;
    count        *: INTEGER;
    colorTable   *: e.APTR;
    vpe          *: ViewPortExtraPtr;
    lowColorBits *: e.APTR;         (* was: transparencyBits *)
    transparencyPlane *: SHORTINT;
    spriteResolution  *: e.UBYTE;
    spriteResDefault  *: e.UBYTE;   (* what resolution you get when
                                     * you have set SPRITERESN_DEFAULT *)
    auxFlags     *: SHORTSET;
    vp           *: ViewPortPtr;
    normalDisplayInfo *: DisplayInfoPtr;
    coerceDisplayInfo *: DisplayInfoPtr;
    cmBatchItems *: u.TagListPtr;
    vpModeID     *: LONGINT;
    palExtra     *: PaletteExtraPtr;
    spriteBaseEven *: INTEGER;
    spriteBaseOdd  *: INTEGER;
    bp0base      *: INTEGER;
    bp1base      *: INTEGER;
  END;

CONST

(* if Type == 0 then ColorMap is V1.2/V1.3 compatible *)
(* if Type != 0 then ColorMap is V38     compatible *)
(* the system will never create other than V39 type colormaps when running V39 *)

  colorMapTypeV12     * = 0;
  colorMapTypeV14     * = 1;
  colorMapTypeV36     * = colorMapTypeV14;      (* use this definition *)
  colormapTypeV39     * = 2;

(* Flags variable *)
  colorMapTransparency    * = 0;
  colorPlaneTransparency  * = 1;
  borderBlanking          * = 2;
  boderNoTransparency     * = 3;
  videoControlBatch       * = 4;
  userCopperClip          * = 5;
  borderSprites           * = 6;

  resnEcs     * =  0;
(* ^140ns, except in 35ns viewport, where it is 70ns. *)
  resn140ns   * =  1;
  resn70ns    * =  2;
  resn35ns    * =  3;
  resnDefault * = -1;

(* AuxFlags : *)
  fullPalette      * = 0;
  noIntermedUpdate * = 1;
  noColorLoad      * = 2;
  dualPFDisable    * = 3;

TYPE
  PaletteExtra * = STRUCT             (* structure may be extended so watch out! *)
    semaphore    *: e.SignalSemaphore;(* shared semaphore for arbitration     *)
    firstFree     : INTEGER;          (* *private*                            *)
    nFree        *: INTEGER;          (* number of free colors                *)
    firstShared   : INTEGER;          (* *private*                            *)
    nShared       : INTEGER;          (* *private*                            *)
    refCnt        : e.APTR;           (* *private*                            *)
    allocList     : e.APTR;           (* *private*                            *)
    viewPort     *: ViewPortPtr;      (* back pointer to viewport             *)
    sharableColors *: INTEGER;        (* the number of sharable colors.       *)
  END;

CONST
(* flags values for ObtainPen *)
  penbExclusive  * = 0;
  penbNoSetcolor * = 1;

(* precision values for ObtainBestPen : *)
  precisionExact * = -1;
  precisionImage * =  0;
  precisionIcon  * = 16;
  precisionGui   * = 32;


(* tags for ObtainBestPen: *)
  obpPrecision * = 084000000H;
  obpFailIfBad * = 084000001H;

(* From V39, MakeVPort() will return an error if there is not enough memory,
 * or the requested mode cannot be opened with the requested depth with the
 * given bitmap (for higher bandwidth alignments).
 *)

  mvpOk        * = 0;   (* you want to see this one *)
  mvpNoMem     * = 1;   (* insufficient memory for intermediate workspace *)
  mvpNoVPE     * = 2;   (* ViewPort does not have a ViewPortExtra, and
                         * insufficient memory to allocate a temporary one.
                         *)
  mvpNoDspIns  * = 3;   (* insufficient memory for intermidiate copper
                         * instructions.
                         *)
  mvpNoDisplay * = 4;   (* BitMap data is misaligned for this viewport's
                         * mode and depth - see AllocBitMap().
                         *)
  mvpOffBottom   = 5;   (* PRIVATE - you will never see this. *)

(* From V39, MrgCop() will return an error if there is not enough memory,
 * or for some reason MrgCop() did not need to make any copper lists.
 *)

  mcopOk    * = 0;  (* you want to see this one *)
  mcopNoMem * = 1;  (* insufficient memory to allocate the system
                     * copper lists.
                     *)
  mcopNop   * = 2;  (* MrgCop() did not merge any copper lists
                     * (eg, no ViewPorts in the list, or all marked as
                     * hidden).
                     *)

TYPE
  DBufInfo * = STRUCT
    link1       *: e.APTR;
    count1      *: LONGINT;
    safeMessage *: e.Message; (* replied to when safe to write to old bitmap *)
    userData1   *: e.APTR;    (* first user data *)

    link2       *: e.APTR;
    count2      *: LONGINT;
    dispMessage *: e.Message; (* replied to when new bitmap has been displayed at least
                                 once *)
    userData2   *: e.APTR;    (* second user data *)
    matchLong   *: LONGINT;
    copPtr1     *: e.APTR;
    copPtr2     *: e.APTR;
    copPtr3     *: e.APTR;
    beamPos1    *: INTEGER;
    beamPos2    *: INTEGER;
  END;


TYPE
  GfxBase * = STRUCT (libNode *: e.Library)
    actiView *: ViewPtr;
    copinit  *: CopinitPtr;    (* ptr to copper start up list *)
    cia      *: e.APTR;        (* for 8520 resource use *)
    blitter  *: e.APTR;        (* for future blitter resource use *)
    loFlist  *: e.APTR;
    shFlist  *: e.APTR;
    blthd    *, blttl  *: h.BltnodePtr;
    bsblthd  *,bsblttl *: h.BltnodePtr;
    vbsrv    *, timsrv *, bltsrv *: e.Interrupt;
    textFonts   *: e.List;
    defaultFont *: TextFontPtr;
    modes       *: SET;        (* copy of current first bplcon0 *)
    vBlank    *: e.BYTE;
    debug     *: e.BYTE;
    beamSync  *: INTEGER;
    bplcon0   *: SET;          (* it is ored into each bplcon0 for display *)
    spriteReserved *: e.BYTE;
    bytereserved *: e.BYTE;
    flags     *: SET;
    blitLock  *: INTEGER;
    blitNest  *: INTEGER;

    blitWaitQ *: e.List;
    blitOwner *: e.TaskPtr;
    waitQ     *: e.List;
    displayFlags *: SET;    (* NTSC PAL GENLOC etc*)
                            (* flags initialized at power on *)
    simpleSprites *: e.APTR;
    maxDisplayRow *: INTEGER;          (* hardware stuff, do not use *)
    maxDisplayColumn  *: INTEGER;      (* hardware stuff, do not use *)
    normalDisplayRows *: INTEGER;
    normalDisplayColumns *: INTEGER;
    (* the following are for standard non interlace, 1/2 wb width *)
    normalDPMX   *: INTEGER;             (* Dots per meter on display *)
    normalDPMY   *: INTEGER;             (* Dots per meter on display *)
    lastChanceMemory *: e.SignalSemaphorePtr;
    lcMptr        *: e.APTR;
    microsPerLine *: INTEGER;          (* 256 time usec/line *)
    minDisplayColumn *: INTEGER;
    chipRevBits0 *: SHORTSET;
    memType      *:  e.BYTE;
    reserved     *: ARRAY 4 OF e.BYTE;
    monitorID    *: INTEGER;
    hedley         *: ARRAY 8 OF LONGINT;
    hedleySprites  *: ARRAY 8 OF LONGINT;  (* sprite ptrs for intuition mouse *)
    hedleySprites1 *: ARRAY 8 OF LONGINT;  (* sprite ptrs for intuition mouse *)
    hedleyCount  *: INTEGER;
    hedleyFlags  *: SET;
    hedleyTmp    *: INTEGER;
    hashTable    *: e.APTR;
    currentTotRows  *: INTEGER;
    currentTotCclks *: INTEGER;
    hedleyHint   *: e.BYTE;
    hedleyHint2  *: e.BYTE;
    nreserved    *: ARRAY 4 OF LONGINT;
    a2024SyncRaster  *: e.APTR;
    controlDeltaPAL  *: INTEGER;
    controlDeltaNTSC *: INTEGER;
    currentMonitor *: MonitorSpecPtr;
    monitorList    *: e.List;
    defaultMonitor *: MonitorSpecPtr;
    monitorListSemaphore *: e.SignalSemaphorePtr;
    displayInfoDataBase  *: e.APTR;
    topLine      *: INTEGER;
    actiViewCprSemaphore *: e.SignalSemaphorePtr;
    utilBase     *: e.LibraryPtr;           (* for hook and tag utilities   *)
    execBase     *: e.LibraryPtr;           (* to link with rom.lib *)
    bwshifts     *: e.APTR;   (* to UBYTE; *)
    strtFetchMasks *: e.APTR; (* to UWORD *)
    stopFetchMasks *: e.APTR; (* to UWORD *)
    overrun      *: e.APTR;   (* to UWORD *)
    realStops    *: e.APTR;   (* to WORD  *)
    spriteWidth  *: INTEGER;  (* current width (in words) of sprites *)
    spriteFMode  *: INTEGER;  (* current sprite fmode bits    *)
    softSprites  *: e.BYTE;   (* bit mask of size change knowledgeable sprites *)
    arraywidth   *: e.BYTE;
    defaultSpriteWidth *: INTEGER;  (* what width intuition wants *)
    sprMoveDisable *: e.BYTE;
    wantChips    *: e.UBYTE;
    boardMemType *: e.UBYTE;
    bugs         *: e.UBYTE;
    layersBase   *: e.APTR;   (* to LONGINT *)
    colorMask    *: LONGINT;
    iVector      *: e.APTR;
    iData        *: e.APTR;
    specialCounter *: LONGINT; (* special for double buffering *)
    dbList       *: e.APTR;
    monitorFlags *: INTEGER;
    scanDoubledSprites *: e.UBYTE;
    bp3Bits        *: e.UBYTE;
    monitorVBlank  *: AnalogSignalInterval;
    naturalMonitor *: MonitorSpecPtr;
    progData     *: e.APTR;
    extSprites   *: e.UBYTE;
    pad3         *: SHORTINT;
    gfxFlags     *: SET;
    vbCounter    *: LONGINT;
    hashTableSemaphore *: e.SignalSemaphorePtr;
    hwEmul       *: UNTRACED POINTER TO ARRAY 9 OF LONGINT;
  END;

  (* chunkyToPlanarPtr = hwEmul[0]    Macro!!*)

CONST
(* Values for GfxBase->DisplayFlags *)
  ntsc           * = 0;
  genloc         * = 1;
  pal            * = 2;
  todaSafe       * = 3;
  reallyPal      * = 16;        (* what is actual crystal frequency
                                 (as opposed to what bootmenu set the agnus to)?
                                 (V39) *)
  lpenSwapFrames * = 32;        (* LightPen software could set this bit if the
                                 * "lpen-with-interlace" fix put in for V39
                                 * does not work. This is true of a number of
                                 * Agnus chips.
                                 * (V40).
                                 *)

  blitMsgFault * = 4;

(* bits defs for ChipRevBits *)
  bigBlits  * = 0;
  hrAgnus   * = 0;
  hrDenise  * = 1;
  aaAlice   * = 2;
  aaLisa    * = 3;
  aaMLisa   * = 4;       (* internal use only. *)

(* Pass ONE of these to SetChipRev() *)
  chipRevA    * = LONGSET{hrAgnus};
  chipRevECS  * = LONGSET{hrAgnus, hrDenise};
  chipRevAA   * = LONGSET{aaAlice, aaLisa} + chipRevECS;
  chipRevBest * = LONGSET{0..31};

(* memory type *)
  bus16  * = 0;
  nmlCAS * = 0;
  bus32  * = 1;
  dblCAS * = 2;
  bandwidth1x    * =  LONGSET{bus16, nmlCAS};
  bandwidth2xNml * =  LONGSET{bus32};
  bandwidth2xDbl * =  LONGSET{dblCAS};
  bandwidth4x    * =  LONGSET{bus32, dblCAS};

(* GfxFlags (private) *)
  newDatabase    = 1;

  graphicsName * = "graphics.library";

(*------- coerce -------------*)

(* These flags are passed (in combination) to CoerceMode() to determine the
 * type of coercion required.
 *)

(* Ensure that the mode coerced to can display just as many colors as the
 * ViewPort being coerced.
 *)
  preserveColors * = 0;

(* Ensure that the mode coerced to is not interlaced. *)
  avoidFlicker   * = 1;

(* Coercion should ignore monitor compatibility issues. *)
  ignoreMCompat  * = 2;


  bidTagCoerce     = 1;  (* Private *)

(*------- rpattr -------------*)

  rpFont       * = 080000000H;   (* get/set font *)
  rpAPen       * = 080000002H;   (* get/set apen *)
  rpBPen       * = 080000003H;   (* get/set bpen *)
  rpDrMd       * = 080000004H;   (* get/set draw mode *)
  rpOutlinePen * = 080000005H;   (* get/set outline pen *)
  rpWriteMask  * = 080000006H;   (* get/set WriteMask *)
  rpMaxPen     * = 080000007H;   (* get/set maxpen *)

  rpDrawBounds * = 080000008H;   (* get only rastport draw bounds. pass &rect *)


VAR
  gfx *, base *: GfxBasePtr;  (* synonyms *)


(*------ BitMap primitives ------*)
PROCEDURE BltBitMap      *{gfx,- 30}(srcBitMap{8}    : BitMapPtr;
                                     xSrc{0}         : INTEGER;
                                     ySrc{1}         : INTEGER;
                                     destBitMap{9}   : BitMapPtr;
                                     xDest{2}        : INTEGER;
                                     yDest{3}        : INTEGER;
                                     xSize{4}        : INTEGER;
                                     ySize{5}        : INTEGER;
                                     minterm{6}      : e.BYTE;
                                     mask{7}         : SHORTSET;
                                     tempA{10}       : PLANEPTR): LONGINT;
PROCEDURE BltTemplate    *{gfx,- 36}(source{8}       : PLANEPTR;
                                     xSrc{0}         : INTEGER;
                                     srcMod{1}       : INTEGER;
                                     destRP{9}       : RastPortPtr;
                                     xDest{2}        : INTEGER;
                                     yDest{3}        : INTEGER;
                                     xSize{4}        : INTEGER;
                                     ySize{5}        : INTEGER);
(*------ Text routines ------*)
PROCEDURE ClearEOL       *{gfx,- 42}(rp{9}           : RastPortPtr);
PROCEDURE ClearScreen    *{gfx,- 48}(rp{9}           : RastPortPtr);
PROCEDURE TextLength     *{gfx,- 54}(rp{9}           : RastPortPtr;
                                     string{8}       : ARRAY OF CHAR;
                                     count{0}        : LONGINT): INTEGER;
PROCEDURE Text           *{gfx,- 60}(rp{9}           : RastPortPtr;
                                     string{8}       : ARRAY OF CHAR;
                                     count{0}        : LONGINT);
PROCEDURE SetFont        *{gfx,- 66}(rp{9}           : RastPortPtr;
                                     textFont{8}     : TextFontPtr);
PROCEDURE OpenFont       *{gfx,- 72}(textAttr{8}     : TextAttr): TextFontPtr;
PROCEDURE CloseFont      *{gfx,- 78}(textFont{9}     : TextFontPtr);
PROCEDURE AskSoftStyle   *{gfx,- 84}(rp{9}           : RastPortPtr): SHORTSET;
PROCEDURE SetSoftStyle   *{gfx,- 90}(rp{9}           : RastPortPtr;
                                     style{0}        : SHORTSET;
                                     enable{1}       : SHORTSET): SHORTSET;
(*------        Gels routines ------*)
PROCEDURE AddBob         *{gfx,- 96}(bob{8}          : BobPtr;
                                     rp{9}           : RastPortPtr);
PROCEDURE AddVSprite     *{gfx,-102}(vSprite{8}      : VSpritePtr;
                                     rp{9}           : RastPortPtr);
PROCEDURE DoCollision    *{gfx,-108}(rp{9}           : RastPortPtr);
PROCEDURE DrawGList      *{gfx,-114}(rp{9}           : RastPortPtr;
                                     vp{8}           : ViewPortPtr);
PROCEDURE InitGels       *{gfx,-120}(head{8}         : VSpritePtr;
                                     tail{9}         : VSpritePtr;
                                     gelsInfo{10}    : GelsInfoPtr);
PROCEDURE InitMasks      *{gfx,-126}(vSprite{8}      : VSpritePtr);
PROCEDURE RemIBob        *{gfx,-132}(bob{8}          : BobPtr;
                                     rp{9}           : RastPortPtr;
                                     vp{10}          : ViewPortPtr);
PROCEDURE RemVSprite     *{gfx,-138}(vSprite{8}      : VSpritePtr);
PROCEDURE SetCollision   *{gfx,-144}(num{0}          : LONGINT;
                                     routine{8}      : e.PROC;
                                     gelsInfo{9}     : GelsInfoPtr);
PROCEDURE SortGList      *{gfx,-150}(rp{9}           : RastPortPtr);
PROCEDURE AddAnimOb      *{gfx,-156}(anOb{8}         : AnimObPtr;
                                     VAR anKey{9}    : AnimObPtr;
                                     rp{10}          : RastPortPtr);
PROCEDURE Animate        *{gfx,-162}(VAR anKey{8}    : AnimObPtr;
                                     rp{9}           : RastPortPtr);
PROCEDURE GetGBuffers    *{gfx,-168}(anOb{8}         : AnimObPtr;
                                     rp{9}           : RastPortPtr;
                                     flag{0}         : BOOLEAN): BOOLEAN;
PROCEDURE InitGMasks     *{gfx,-174}(animOb{8}       : AnimObPtr);
(*------        General graphics routines ------*)
PROCEDURE DrawEllipse    *{gfx,-180}(rp{9}           : RastPortPtr;
                                     xCenter{0}      : INTEGER;
                                     yCenter{1}      : INTEGER;
                                     a{2}            : INTEGER;
                                     b{3}            : INTEGER);
PROCEDURE AreaEllipse    *{gfx,-186}(rp{9}           : RastPortPtr;
                                     xCenter{0}      : INTEGER;
                                     yCenter{1}      : INTEGER;
                                     a{2}            : INTEGER;
                                     b{3}            : INTEGER): BOOLEAN;
PROCEDURE LoadRGB4       *{gfx,-192}(vp{8}           : ViewPortPtr;
                                     colors{9}       : ARRAY OF INTEGER;
                                     count{0}        : LONGINT);
PROCEDURE InitRastPort   *{gfx,-198}(VAR rp{9}       : RastPort);
PROCEDURE InitVPort      *{gfx,-204}(VAR vp{8}       : ViewPort);
PROCEDURE OldMrgCop      *{gfx,-210}(view{9}         : ViewPtr);
PROCEDURE MrgCop         *{gfx,-210}(view{9}         : ViewPtr): LONGINT;
PROCEDURE MakeVPort      *{gfx,-216}(view{8}         : ViewPtr;
                                     vp{9}           : ViewPortPtr): LONGINT;
PROCEDURE LoadView       *{gfx,-222}(view{9}         : ViewPtr);
PROCEDURE WaitBlit       *{gfx,-228}();
PROCEDURE SetRast        *{gfx,-234}(rp{9}           : RastPortPtr;
                                     pen{0}          : INTEGER);
PROCEDURE Move           *{gfx,-240}(rp{9}           : RastPortPtr;
                                     x{0}            : INTEGER;
                                     y{1}            : INTEGER);
PROCEDURE Draw           *{gfx,-246}(rp{9}           : RastPortPtr;
                                     x{0}            : INTEGER;
                                     y{1}            : INTEGER);
PROCEDURE AreaMove       *{gfx,-252}(rp{9}           : RastPortPtr;
                                     x{0}            : INTEGER;
                                     y{1}            : INTEGER): BOOLEAN;
PROCEDURE AreaDraw       *{gfx,-258}(rp{9}           : RastPortPtr;
                                     x{0}            : INTEGER;
                                     y{1}            : INTEGER): BOOLEAN;
PROCEDURE AreaEnd        *{gfx,-264}(rp{9}           : RastPortPtr): BOOLEAN;
PROCEDURE WaitTOF        *{gfx,-270}();
PROCEDURE QBlit          *{gfx,-276}(blit{9}         : h.BltnodePtr);
PROCEDURE InitArea       *{gfx,-282}(VAR areaInfo{8} : AreaInfo;
                                     vectorBuffer{9} : e.APTR;
                                     maxVectors{0}   : LONGINT);
PROCEDURE SetRGB4        *{gfx,-288}(vp{8}           : ViewPortPtr;
                                     index{0}        : INTEGER;
                                     red{1}          : INTEGER;
                                     green{2}        : INTEGER;
                                     blue{3}         : INTEGER);
PROCEDURE QBSBlit        *{gfx,-294}(blit{9}         : h.BltnodePtr);
PROCEDURE BltClear       *{gfx,-300}(memBlock{9}     : PLANEPTR;
                                     byteCount{0}    : LONGINT;
                                     flags{1}        : LONGSET);
PROCEDURE RectFill       *{gfx,-306}(rp{9}           : RastPortPtr;
                                     xMin{0}         : INTEGER;
                                     yMin{1}         : INTEGER;
                                     xMax{2}         : INTEGER;
                                     yMax{3}         : INTEGER);
PROCEDURE BltPattern     *{gfx,-312}(rp{9}           : RastPortPtr;
                                     mask{8}         : PLANEPTR;
                                     xMin{0}         : INTEGER;
                                     yMin{1}         : INTEGER;
                                     xMax{2}         : INTEGER;
                                     yMax{3}         : INTEGER;
                                     bytecnt{4}      : INTEGER);
PROCEDURE ReadPixel      *{gfx,-318}(rp{9}           : RastPortPtr;
                                     x{0}            : INTEGER;
                                     y{1}            : INTEGER): LONGINT;
PROCEDURE WritePixel     *{gfx,-324}(rp{9}           : RastPortPtr;
                                     x{0}            : INTEGER;
                                     y{1}            : INTEGER): BOOLEAN;
PROCEDURE Flood          *{gfx,-330}(rp{9}           : RastPortPtr;
                                     mode{2}         : LONGINT;
                                     x{0}            : INTEGER;
                                     y{1}            : INTEGER): BOOLEAN;
PROCEDURE PolyDraw       *{gfx,-336}(rp{9}           : RastPortPtr;
                                     count{0}        : INTEGER;
                                     polyTable{8}    : ARRAY OF Point);
PROCEDURE PolyDrawList   *{gfx,-336}(rp{9}           : RastPortPtr;
                                     count{0}        : INTEGER;
                                     coors{8}..      : INTEGER);
PROCEDURE SetAPen        *{gfx,-342}(rp{9}           : RastPortPtr;
                                     pen{0}          : INTEGER);
PROCEDURE SetBPen        *{gfx,-348}(rp{9}           : RastPortPtr;
                                     pen{0}          : INTEGER);
PROCEDURE SetDrMd        *{gfx,-354}(rp{9}           : RastPortPtr;
                                     drawMode{0}     : SHORTSET);
PROCEDURE InitView       *{gfx,-360}(VAR view{9}     : View);
PROCEDURE CBump          *{gfx,-366}(copList{9}      : UCopListPtr);
PROCEDURE CMove          *{gfx,-372}(copList{9}      : UCopListPtr;
                                     destination{0}  : e.APTR;
                                     data{1}         : INTEGER);
PROCEDURE CWait          *{gfx,-378}(copList{9}      : UCopListPtr;
                                     v{0}            : INTEGER;
                                     h{1}            : INTEGER);
PROCEDURE VBeamPos       *{gfx,-384}(): LONGINT;
PROCEDURE InitBitMap     *{gfx,-390}(VAR bitMap{8}   : BitMap;
                                     depth{0}        : INTEGER;
                                     width{1}        : INTEGER;
                                     height{2}       : INTEGER);
PROCEDURE ScrollRaster   *{gfx,-396}(rp{9}           : RastPortPtr;
                                     x{0}            : INTEGER;
                                     y{1}            : INTEGER;
                                     xMin{2}         : INTEGER;
                                     yMin{3}         : INTEGER;
                                     xMax{4}         : INTEGER;
                                     yMax{5}         : INTEGER);
PROCEDURE WaitBOVP       *{gfx,-402}(vp{8}           : ViewPortPtr);
PROCEDURE GetSprite      *{gfx,-408}(VAR sprite{8}   : SimpleSprite;
                                     num{0}          : INTEGER): INTEGER;
PROCEDURE FreeSprite     *{gfx,-414}(num{0}          : INTEGER);
PROCEDURE ChangeSprite   *{gfx,-420}(vp{8}           : ViewPortPtr;
                                     VAR sprite{9}   : SimpleSprite;
                                     newData{10}     : PLANEPTR);
PROCEDURE MoveSprite     *{gfx,-426}(vo{8}           : ViewPortPtr;
                                     VAR sprite{9}   : SimpleSprite;
                                     x{0}            : INTEGER;
                                     y{1}            : INTEGER);
PROCEDURE LockLayerRom   *{gfx,-432}(layer{13}       : LayerPtr);
PROCEDURE UnlockLayerRom *{gfx,-438}(layer{13}       : LayerPtr);
PROCEDURE SyncSBitMap    *{gfx,-444}(layer{8}        : LayerPtr);
PROCEDURE CopySBitMap    *{gfx,-450}(layer{8}        : LayerPtr);
PROCEDURE OwnBlitter     *{gfx,-456}();
PROCEDURE DisownBlitter  *{gfx,-462}();
PROCEDURE InitTmpRas     *{gfx,-468}(VAR tmpras{8}   : TmpRas;
                                     buffer{9}       : PLANEPTR;
                                     size{0}         : LONGINT);
PROCEDURE AskFont        *{gfx,-474}(rp{9}           : RastPortPtr;
                                     textAttr{8}     : TextAttr);
PROCEDURE AddFont        *{gfx,-480}(textfont{9}     : TextFontPtr);
PROCEDURE RemFont        *{gfx,-486}(textfont{9}     : TextFontPtr);
PROCEDURE AllocRaster    *{gfx,-492}(width{0}        : INTEGER;
                                     height{1}       : INTEGER): PLANEPTR;
PROCEDURE FreeRaster     *{gfx,-498}(p{8}            : PLANEPTR;
                                     width{0}        : INTEGER;
                                     height{1}       : INTEGER);
PROCEDURE AndRectRegion  *{gfx,-504}(region{8}       : RegionPtr;
                                     rectangle{9}    : Rectangle);
PROCEDURE OrRectRegion   *{gfx,-510}(region{8}       : RegionPtr;
                                     rectangle{9}    : Rectangle): BOOLEAN;
PROCEDURE NewRegion      *{gfx,-516}(): RegionPtr;
PROCEDURE ClearRectRegion*{gfx,-522}(region{8}       : RegionPtr;
                                     rectangle{9}    : Rectangle): BOOLEAN;
PROCEDURE ClearRegion    *{gfx,-528}(region{8}       : RegionPtr);
PROCEDURE DisposeRegion  *{gfx,-534}(region{8}       : RegionPtr);
PROCEDURE FreeVPortCopLists*{gfx,-540}(vp{8}         : ViewPortPtr);
PROCEDURE FreeCopList    *{gfx,-546}(copList{8}      : CopListDummyPtr);
PROCEDURE ClipBlit       *{gfx,-552}(srcRP{8}        : RastPortPtr;
                                     xSrc{0}         : INTEGER;
                                     ySrc{1}         : INTEGER;
                                     destRP{9}       : RastPortPtr;
                                     xDest{2}        : INTEGER;
                                     yDest{3}        : INTEGER;
                                     xSize{4}        : INTEGER;
                                     ySize{5}        : INTEGER;
                                     minterm{6}      : e.BYTE);
PROCEDURE XorRectRegion  *{gfx,-558}(region{8}       : RegionPtr;
                                     rectangle{9}    : Rectangle): BOOLEAN;
PROCEDURE FreeCprList    *{gfx,-564}(cprlist{8}      : CprlistPtr);
PROCEDURE GetColorMap    *{gfx,-570}(entries{0}      : LONGINT): ColorMapPtr;
PROCEDURE FreeColorMap   *{gfx,-576}(colorMap{8}     : ColorMapPtr);
PROCEDURE GetRGB4        *{gfx,-582}(colorMap{8}     : ColorMapPtr;
                                     entry{0}        : LONGINT): INTEGER;
PROCEDURE ScrollVPort    *{gfx,-588}(vp{8}           : ViewPortPtr);
PROCEDURE UCopperListInit*{gfx,-594}(uCopList{8}     : UCopListPtr;
                                     n{0}            : LONGINT): CopListDummyPtr;
PROCEDURE FreeGBuffers   *{gfx,-600}(anOb{8}         : AnimObPtr;
                                     rp{9}           : RastPortPtr;
                                     flag{0}         : BOOLEAN);
PROCEDURE BltBitMapRastPort*{gfx,-606}(srcBitMap{8}  : BitMapPtr;
                                     xSrc{0}         : INTEGER;
                                     ySrc{1}         : INTEGER;
                                     destRP{9}       : RastPortPtr;
                                     xDest{2}        : INTEGER;
                                     yDest{3}        : INTEGER;
                                     xSize{4}        : INTEGER;
                                     ySize{5}        : INTEGER;
                                     minterm{6}      : e.BYTE);
PROCEDURE OrRegionRegion *{gfx,-612}(srcRegion{8}    : RegionPtr;
                                     destRegion{9}   : RegionPtr): BOOLEAN;
PROCEDURE XorRegionRegion*{gfx,-618}(srcRegion{8}    : RegionPtr;
                                     destRegion{9}   : RegionPtr): BOOLEAN;
PROCEDURE AndRegionRegion*{gfx,-624}(srcRegion{8}    : RegionPtr;
                                     destRegion{9}   : RegionPtr): BOOLEAN;
PROCEDURE SetRGB4CM      *{gfx,-630}(colorMap{8}     : ColorMapPtr;
                                     index{0}        : INTEGER;
                                     red{1}          : INTEGER;
                                     green{2}        : INTEGER;
                                     blue{3}         : INTEGER);
PROCEDURE BltMaskBitMapRastPort*{gfx,-636}(srcBitMap{8}  : BitMapPtr;
                                     xSrc{0}         : INTEGER;
                                     ySrc{1}         : INTEGER;
                                     destRP{9}       : RastPortPtr;
                                     xDest{2}        : INTEGER;
                                     yDest{3}        : INTEGER;
                                     xSize{4}        : INTEGER;
                                     ySize{5}        : INTEGER;
                                     minterm{6}      : e.BYTE;
                                     bltMask{10}     : PLANEPTR);
PROCEDURE AttemptLockLayerRom*{gfx,-654}(layer{13}   : LayerPtr): BOOLEAN;
(* ---   functions in V36 or higher (Release 2.0)    --- *)
(* --- REMEMBER: You are to check the version BEFORE you use this ! --- *)

PROCEDURE GfxNew         *{gfx,-660}(gfxNodeType{0}  : LONGINT): ExtendedNodePtr;
PROCEDURE GfxFree        *{gfx,-666}(gfxNodePtr{8}   : ExtendedNodePtr);
PROCEDURE GfxAssociate   *{gfx,-672}(associateNode{8}: ExtendedNodePtr;
                                     gfxNodePtr{9}   : ExtendedNodePtr);
PROCEDURE BitMapScale    *{gfx,-678}(bitScaleArgs{8} : BitScaleArgsPtr);
PROCEDURE ScalerDiv      *{gfx,-684}(factor{0}       : LONGINT;
                                     numerator{1}    : LONGINT;
                                     denominator{2}  : LONGINT): INTEGER;
PROCEDURE TextExtent     *{gfx,-690}(rp{9}           : RastPortPtr;
                                     string{8}       : ARRAY OF CHAR;
                                     count{0}        : LONGINT;
                                     VAR textExt{10} : Textextent);
PROCEDURE TextFit        *{gfx,-696}(rp{9}           : RastPortPtr;
                                     string{8}       : ARRAY OF CHAR;
                                     strLen{0}       : LONGINT;
                                     textExtent{10}  : TextextentPtr;
                                     constrainingExtent{11} : TextextentPtr;
                                     strDirection{1} : LONGINT;
                                     constrainingBitWidth{2} : LONGINT;
                                     constrainingBitHeight{3} : LONGINT): LONGINT;
PROCEDURE GfxLookUp      *{gfx,-702}(associateNode{8}: ExtendedNodePtr): e.APTR;
PROCEDURE VideoControlA  *{gfx,-708}(colorMap{8}     : ColorMapPtr;
                                     tagarray{9}     : ARRAY OF u.TagItem): BOOLEAN;
PROCEDURE VideoControl   *{gfx,-708}(colorMap{8}     : ColorMapPtr;
                                     tags{9}..       : u.Tag): BOOLEAN;
PROCEDURE OpenMonitor    *{gfx,-714}(monitorName{9}  : ARRAY OF CHAR;
                                     displayID{0}    : LONGINT): MonitorSpecPtr;
PROCEDURE CloseMonitor   *{gfx,-720}(monitorSpec{8}  : MonitorSpecPtr): BOOLEAN;
PROCEDURE FindDisplayInfo*{gfx,-726}(displayID{0}    : LONGINT): DisplayInfoHandle;
PROCEDURE NextDisplayInfo*{gfx,-732}(displayID{0}    : LONGINT): LONGINT;
PROCEDURE AddDisplayInfo *{gfx,-738};
PROCEDURE AddDisplayInfoData*{gfx,-744};
PROCEDURE SetDisplayInfoData*{gfx,-750}(handle{8}    : DisplayInfoHandle;
                                        buf{9}       : ARRAY OF e.BYTE;
                                        size{0}      : LONGINT;
                                        tagID{1}     : LONGINT;
                                        displayID{2} : LONGINT): LONGINT;
PROCEDURE GetDisplayInfoData*{gfx,-756}(handle{8}    : DisplayInfoHandle;
                                        VAR buf{9}   : ARRAY OF e.BYTE;
                                        size{0}      : LONGINT;
                                        tagID{1}     : LONGINT;
                                        displayID{2} : LONGINT): LONGINT;
PROCEDURE FontExtent     *{gfx,-762}(font{8}         : TextFontPtr;
                                     fontExtent{9}   : TextFontExtensionPtr);
PROCEDURE ReadPixelLine8 *{gfx,-768}(rp{8}           : RastPortPtr;
                                     xstart{0}       : INTEGER;
                                     ystart{1}       : INTEGER;
                                     width{2}        : INTEGER;
                                     VAR array{10}   : ARRAY OF e.BYTE;
                                     tempRP{9}       : RastPortPtr): LONGINT;
PROCEDURE WritePixelLine8*{gfx,-774}(rp{8}           : RastPortPtr;
                                     xstart{0}       : INTEGER;
                                     ystart{1}       : INTEGER;
                                     width{2}        : INTEGER;
                                     array{10}       : ARRAY OF e.BYTE;
                                     tempRP{9}       : RastPortPtr): LONGINT;
PROCEDURE ReadPixelArray8*{gfx,-780}(rp{8}           : RastPortPtr;
                                     xstart{0}       : INTEGER;
                                     ystart{1}       : INTEGER;
                                     xstop{2}        : INTEGER;
                                     ystop{3}        : INTEGER;
                                     VAR array{10}   : ARRAY OF e.BYTE;
                                     tempRP{9}       : RastPortPtr): LONGINT;
PROCEDURE WritePixelArray8*{gfx,-786}(rp{8}           : RastPortPtr;
                                     xstart{0}       : INTEGER;
                                     ystart{1}       : INTEGER;
                                     xstop{2}        : INTEGER;
                                     ystop{3}        : INTEGER;
                                     array{10}       : ARRAY OF e.BYTE;
                                     tempRP{9}       : RastPortPtr): LONGINT;
PROCEDURE GetVPModeID    *{gfx,-792}(vp{8}           : ViewPortPtr): LONGINT;
PROCEDURE ModeNotAvailable*{gfx,-798}(modeID{0}      : LONGINT): LONGINT;
PROCEDURE WeighTAMatchA  *{gfx,-804}(reqTextAttr{8}  : TextAttr;
                                     VAR targetTextAttr{9} : TextAttr;
                                     targetTags{10}  : ARRAY OF u.TagItem): INTEGER;
PROCEDURE WeighTAMatch   *{gfx,-804}(reqTextAttr{8} : TextAttr;
                                      VAR targetTextAttr{9} : TextAttr;
                                      targetTags{10}..      : u.Tag): INTEGER;
PROCEDURE EraseRect      *{gfx,-810}(rp{9}           : RastPortPtr;
                                     xMin{0}         : INTEGER;
                                     yMin{1}         : INTEGER;
                                     xMax{2}         : INTEGER;
                                     yMax{3}         : INTEGER);
PROCEDURE ExtendFontA    *{gfx,-816}(font{8}         : TextFontPtr;
                                     fontTags{9}     : ARRAY OF u.TagItem): BOOLEAN;
PROCEDURE ExtendFont     *{gfx,-816}(font{8}         : TextFontPtr;
                                     fontTags{9}..   : u.Tag): BOOLEAN;
PROCEDURE StripFont      *{gfx,-822}(font{8}         : TextFontPtr);

(*--- functions in V39 or higher (Release 3) ---*)
PROCEDURE CalcIVG        *{gfx,-033CH}(v{8}          : ViewPtr;
                                       vp{8}         : ViewPortPtr): INTEGER;
PROCEDURE AttachPalExtra *{gfx,-0342H}(cm{8}         : ColorMapPtr;
                                       vp{9}         : ViewPortPtr): LONGINT;
PROCEDURE ObtainBestPenA *{gfx,-0348H}(cm{8}         : ColorMapPtr;
                                       r{1}          : LONGINT;
                                       g{2}          : LONGINT;
                                       b{3}          : LONGINT;
                                       tags{9}       : ARRAY OF u.TagItem): LONGINT;
PROCEDURE ObtainBestPen *{gfx,-0348H}(cm{8}          : ColorMapPtr;
                                       r{1}          : LONGINT;
                                       g{2}          : LONGINT;
                                       b{3}          : LONGINT;
                                       tag1Type{9}.. : u.Tag): LONGINT;
PROCEDURE SetRGB32       *{gfx,-0354H}(vp{8}         : ViewPortPtr;
                                       n{0}          : LONGINT;
                                       r{1}          : LONGINT;
                                       g{2}          : LONGINT;
                                       b{3}          : LONGINT);
PROCEDURE GetAPen        *{gfx,-035AH}(rp{8}         : RastPortPtr): LONGINT;
PROCEDURE GetBPen        *{gfx,-0360H}(rp{8}         : RastPortPtr): LONGINT;
PROCEDURE GetDrMd        *{gfx,-0366H}(rp{8}         : RastPortPtr): LONGSET;
PROCEDURE GetOPen        *{gfx,-036CH}(rp{8}         : RastPortPtr): LONGINT;
(* synonym for consistency with SetOutlinePen *)
PROCEDURE GetOutlinePen  *{gfx,-036CH}(rp{8}         : RastPortPtr): LONGINT;
PROCEDURE LoadRGB32      *{gfx,-0372H}(vp{8}         : ViewPortPtr;
                                       VAR table{9}  : ARRAY OF LONGINT);
PROCEDURE SetChipRev     *{gfx,-0378H}(want{0}       : LONGSET): LONGSET;
PROCEDURE SetABPenDrMd   *{gfx,-037EH}(rp{9}         : RastPortPtr;
                                       apen{0}       : LONGINT;
                                       bpen{1}       : LONGINT;
                                       drawmode{2}   : SHORTSET);
PROCEDURE GetRGB32       *{gfx,-0384H}(cm{8}         : ColorMapPtr;
                                       firstcolor{0} : LONGINT;
                                       ncolors{1}    : LONGINT;
                                       VAR table{9}  : ARRAY OF LONGINT);
PROCEDURE AllocBitMap    *{gfx,-0396H}(sizex{0}      : LONGINT;
                                       sizey{1}      : LONGINT;
                                       depth{2}      : LONGINT;
                                       flags{3}      : LONGSET;
                                       friendBitmap{8}: BitMapPtr): BitMapPtr;
PROCEDURE FreeBitMap     *{gfx,-039CH}(bm{8}         : BitMapPtr);
PROCEDURE GetExtSpriteA  *{gfx,-03A2H}(ss{10}        : ExtSpritePtr;
                                       tags{9}       : ARRAY OF u.TagItem): LONGINT;
PROCEDURE GetExtSprite   *{gfx,-03A2H}(ss{10}        : ExtSpritePtr;
                                       tag1Type{9}.. : u.Tag): LONGINT;
PROCEDURE CoerceMode     *{gfx,-03A8H}(vp{8}         : ViewPortPtr;
                                       monitorid{0}  : LONGINT;
                                       flags{7}      : LONGINT): LONGINT;
PROCEDURE ChangeVPBitMap *{gfx,-03AEH}(vp{8}         : ViewPortPtr;
                                       bm{9}         : BitMapPtr;
                                       db{10}        : DBufInfoPtr);
PROCEDURE ReleasePen     *{gfx,-03B4H}(cm{8}         : ColorMapPtr;
                                       n{0}          : LONGINT);
PROCEDURE ObtainPen      *{gfx,-03BAH}(cm{8}         : ColorMapPtr;
                                       n{0}          : LONGINT;
                                       r{1}          : LONGINT;
                                       g{2}          : LONGINT;
                                       b{3}          : LONGINT;
                                       f{4}          : LONGSET): LONGINT;
PROCEDURE GetBitMapAttr  *{gfx,-03C0H}(bm{8}         : BitMapPtr;
                                       attrnum{1}    : LONGINT): LONGINT;
PROCEDURE AllocDBufInfo  *{gfx,-03C6H}(vp{8}         : ViewPortPtr): DBufInfoPtr;
PROCEDURE FreeDBufInfo   *{gfx,-03CCH}(dbi{9}        : DBufInfoPtr);
PROCEDURE SetOutlinePen  *{gfx,-03D2H}(rp{8}         : RastPortPtr;
                                       pen{0}        : LONGINT): LONGINT;
PROCEDURE SetWriteMask   *{gfx,-03D8H}(rp{8}         : RastPortPtr;
                                       msk{0}        : LONGSET): BOOLEAN;
PROCEDURE SetMaxPen      *{gfx,-03DEH}(rp{8}         : RastPortPtr;
                                       maxpen{0}     : LONGINT);
PROCEDURE SetRGB32CM     *{gfx,-03E4H}(cm{8}         : ColorMapPtr;
                                       n{0}          : LONGINT;
                                       r{1}          : LONGINT;
                                       g{2}          : LONGINT;
                                       b{3}          : LONGINT);
PROCEDURE ScrollRasterBF *{gfx,-03EAH}(rp{9}         : RastPortPtr;
                                       dx{0}         : LONGINT;
                                       dy{1}         : LONGINT;
                                       xMin{2}       : LONGINT;
                                       yMin{3}       : LONGINT;
                                       xMax{4}       : LONGINT;
                                       yMax{5}       : LONGINT);
PROCEDURE FindColor      *{gfx,-03F0H}(cm{11}        : ColorMapPtr;
                                       r{1}          : LONGINT;
                                       g{2}          : LONGINT;
                                       b{3}          : LONGINT;
                                       maxcolor{4}   : LONGINT): LONGINT;
PROCEDURE AllocSpriteDataA*{gfx,-03FCH}(bm{10}       : BitMapPtr;
                                       tags{9}       : ARRAY OF u.TagItem): ExtSpritePtr;
PROCEDURE AllocSpriteData*{gfx,-03FCH}(bm{10}        : BitMapPtr;
                                       tag1Type{9}.. : u.Tag): ExtSpritePtr;
PROCEDURE ChangeExtSpriteA*{gfx,-0402H}(vp{8}        : ViewPortPtr;
                                       oldsprite{9}  : ExtSpritePtr;
                                       newsprite{10} : ExtSpritePtr;
                                       tags{11}      : ARRAY OF u.TagItem): BOOLEAN;
PROCEDURE ChangeExtSprite*{gfx,-402H}(vp{8}          : ViewPortPtr;
                                       oldsprite{9}  : ExtSpritePtr;
                                       newsprite{10} : ExtSpritePtr;
                                       tag1Type{11}..: u.Tag): BOOLEAN;
PROCEDURE FreeSpriteData *{gfx,-0408H}(sp{10}        : ExtSpritePtr);
PROCEDURE SetRPAttrsA    *{gfx,-040EH}(rp{8}         : RastPortPtr;
                                       tags{9}       : ARRAY OF u.TagItem);
PROCEDURE SetRPAttrs     *{gfx,-040EH}(rp{8}         : RastPortPtr;
                                        tag1Type{9}..: u.Tag);
PROCEDURE GetRPAttrsA    *{gfx,-0414H}(rp{8}         : RastPortPtr;
                                       tags{9}       : ARRAY OF u.TagItem);
PROCEDURE GetRPAttrs     *{gfx,-0414H}(rp{8}         : RastPortPtr;
                                       tag1Type{9}.. : u.Tag);
PROCEDURE BestModeIDA    *{gfx,-041AH}(tags{8}       : ARRAY OF u.TagItem): LONGINT;
PROCEDURE BestModeID     *{gfx,-041AH}(tag1Type{8}.. : u.Tag): LONGINT;
(*--- functions in V40 or higher (Release 3.1) ---*)
PROCEDURE WriteChunkyPixels*{gfx,-420H}(rp{8}        : RastPortPtr;
                                       xStart{0}     : LONGINT;
                                       yStart{1}     : LONGINT;
                                       xStop{2}      : LONGINT;
                                       yStop{3}      : LONGINT;
                                       array{9}      : ARRAY OF e.BYTE;
                                       bytesPerRow{5}: LONGINT);

(* $OvflChk- $RangeChk- $StackChk- $NilChk- $ReturnChk- $CaseChk- *)

(* This macro is obsolete as of V39. AllocBitMap() should be used for allocating
   bitmap data, since it knows about the machine's particular alignment
   restrictions.
*)
PROCEDURE RASSIZE * (w{0}, h{1}: INTEGER): LONGINT;
BEGIN RETURN (LONG(w)+15) DIV 16 * 2 * h; END RASSIZE;

(* ************************************************************************ *)

(* these are GEL functions that are currently simple enough to exist as a
 *  definition.  It should not be assumed that this will always be the case
 *)

PROCEDURE InitAnimate * (VAR anKey{8}: AnimObPtr);
BEGIN anKey := NIL; END InitAnimate;

PROCEDURE RemBob * (b{8}: BobPtr);
BEGIN INCL(b.flags,bobsAway); END RemBob;

PROCEDURE OnDisplay*;  BEGIN h.custom.dmacon := {h.dmaSet,h.raster} END OnDisplay;

PROCEDURE OffDisplay*; BEGIN h.custom.dmacon :=          {h.raster} END OffDisplay;

PROCEDURE OnSprite*;   BEGIN h.custom.dmacon := {h.dmaSet,h.sprite} END OnSprite;

PROCEDURE OffSprite*;  BEGIN h.custom.dmacon :=          {h.sprite} END OffSprite;

PROCEDURE OnVBlank*;   BEGIN h.custom.intena := {h.dmaSet,h.vertb } END OnVBlank;

PROCEDURE OffVBlank*;  BEGIN h.custom.intena :=          {h.vertb } END OffVBlank;

PROCEDURE SetOPen*(w{8}: RastPortPtr; c{0}: e.BYTE);
BEGIN w.aOlPen := c; INCL(w.flags,areaOutline); END SetOPen;

PROCEDURE SetDrPt*(w{8}: RastPortPtr; p{0}: INTEGER);
BEGIN w.linePtrn := p; INCL(w.flags,firstDot); w.linPatCnt := 15; END SetDrPt;

PROCEDURE SetWrMsk*(w{8}: RastPortPtr; m{8}: SHORTSET);
BEGIN w.mask := m END SetWrMsk;

(* the SafeSetxxx macros are backwards (pre V39 graphics) compatible versions *)
(* using these macros will make your code do the right thing under V39 AND V37 *)

PROCEDURE SafeSetOutlinePen * (w{8}: RastPortPtr; c{0}: e.BYTE);
BEGIN
  IF gfx.libNode.version<39 THEN w.aOlPen := c; INCL(w.flags,areaOutline);
  ELSIF SetOutlinePen(w,ORD(c)) = 0 THEN END;
END SafeSetOutlinePen;


PROCEDURE SafeSetWriteMask * (w{8}: RastPortPtr; m{0}: SHORTSET);
  PROCEDURE MySetWriteMask{gfx,-03D8H}(rp{8}: RastPortPtr; msk{0}: SHORTSET);
BEGIN
  IF gfx.libNode.version<39 THEN w.mask := m;
  ELSE MySetWriteMask(w,m); END;
END SafeSetWriteMask;

PROCEDURE SetAfPt*(w{8}: RastPortPtr; p{9}: e.ADDRESS; n{0}: e.BYTE);
BEGIN w.areaPtrn := p; w.areaPtSz := n; END SetAfPt;

PROCEDURE BndryOff*(w{8}: RastPortPtr);
BEGIN EXCL(w.flags,areaOutline) END BndryOff;

PROCEDURE CINIT*(c{8}: UCopListPtr; n{0}: LONGINT);
BEGIN IF UCopperListInit(c,n)=NIL THEN END END CINIT;

PROCEDURE CMOVE*(c{9}: UCopListPtr; a{0}: e.ADDRESS; b{1}: INTEGER);
BEGIN CMove(c,a,b); CBump(c) END CMOVE;

PROCEDURE CWAIT*(c{9}: UCopListPtr; a{0},b{1}: INTEGER);
BEGIN CWait(c,a,b); CBump(c) END CWAIT;

PROCEDURE CEND*(c{9}: UCopListPtr);
BEGIN CWAIT(c,10000,255) END CEND;

PROCEDURE DrawCircle*(rp{9}: RastPortPtr; cx{0},cy{1}: INTEGER; r{2}: INTEGER);
BEGIN DrawEllipse(rp,cx,cy,r,r); END DrawCircle;

PROCEDURE AreaCircle*(rp{9}: RastPortPtr; cx{0},cy{1}: INTEGER; r{2}: INTEGER): BOOLEAN;
BEGIN RETURN AreaEllipse(rp,cx,cy,r,r); END AreaCircle;

(*-------------------------------------------------------------------------*)

BEGIN
  gfx :=  e.OpenLibrary(graphicsName,33);
  IF gfx = NIL THEN HALT(20) END;
  base := gfx;

CLOSE
  IF gfx#NIL THEN e.CloseLibrary(gfx) END;

END Graphics.

