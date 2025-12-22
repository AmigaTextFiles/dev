(*
(*  Amiga Oberon Interface Module:
**  $VER: Prefs.mod 40.15 (28.12.93) Oberon 3.0
**
**      (C) Copyright 1991-1992 Commodore-Amiga, Inc.
**          All Rights Reserved
**
**      (C) Copyright Oberon Interface 1993 by hartmut Goebel
*)          All Rights Reserved
*)

MODULE Prefs;

IMPORT SYSTEM *,
       g * := Graphics,
       I * := Intuition,
       Timer *;

TYPE
  PrefHeaderPtr       *= UNTRACED POINTER TO PrefHeader;
  FontPrefsPtr        *= UNTRACED POINTER TO FontPrefs;
  IControlPrefsPtr    *= UNTRACED POINTER TO IControlPrefs;
  InputPrefsPtr       *= UNTRACED POINTER TO InputPrefs;
  CountryPrefsPtr     *= UNTRACED POINTER TO CountryPrefs;
  LocalePrefsPtr      *= UNTRACED POINTER TO LocalePrefs;
  OverscanPrefsPtr    *= UNTRACED POINTER TO OverscanPrefs;
  PalettePrefsPtr     *= UNTRACED POINTER TO PalettePrefs;
  PointerPrefsPtr     *= UNTRACED POINTER TO PointerPrefs;
  RGBTablePtr         *= UNTRACED POINTER TO RGBTable;
  PrinterGfxPrefsPtr  *= UNTRACED POINTER TO PrinterGfxPrefs;
  PrinterPSPrefsPtr   *= UNTRACED POINTER TO PrinterPSPrefs;
  PrinterTxtPrefsPtr  *= UNTRACED POINTER TO PrinterTxtPrefs;
  PrinterUnitPrefsPtr *= UNTRACED POINTER TO PrinterUnitPrefs;
  ScreenModePrefsPtr  *= UNTRACED POINTER TO ScreenModePrefs;
  SerialPrefsPtr      *= UNTRACED POINTER TO SerialPrefs;
  SoundPrefsPtr       *= UNTRACED POINTER TO SoundPrefs;
  WBPatternPrefsPtr   *= UNTRACED POINTER TO WBPatternPrefs;

(*****************************************************************************)

CONST
  idPREF      * = SYSTEM.VAL(LONGINT,'PREF');
  idPRHD      * = SYSTEM.VAL(LONGINT,'PRHD');

TYPE
  PrefHeader  * = STRUCT
    version * : SHORTINT;   (* version of following data *)
    type    * : SHORTINT;   (* type of following data    *)
    flags   * : LONGSET;    (* always set to 0 for now   *)
  END;

(*****************************************************************************)

CONST
  idFONT      * = SYSTEM.VAL(LONGINT,'FONT');

  fontNameSize * = 128;

TYPE
  FontPrefs   * = STRUCT
    reserved  * : ARRAY 3 OF LONGINT;
    reserved2 * : INTEGER;
    type      * : INTEGER;
    frontPen  * : SHORTINT;
    backPen   * : SHORTINT;
    drawMode  * : SHORTINT;
    textAttr  * : g.TextAttr;
    name      * : ARRAY fontNameSize OF CHAR;
  END;

CONST
(* constants for FontPrefs.fp_Type *)
  wbFont      * = 0;
  sysFont     * = 1;
  screenFont  * = 2;


(*****************************************************************************)

  idICTL      * = SYSTEM.VAL(LONGINT,'ICTL');

TYPE
  IControlPrefs * = STRUCT
    reserved    * : ARRAY 4 OF LONGINT; (* System reserved      *)
    timeOut     * : INTEGER;    (* Verify timeout               *)
    metaDrag    * : INTEGER;    (* Meta drag mouse event        *)
    flags       * : LONGSET;    (* IControl flags (see below)   *)
    wBtoFront   * : CHAR;       (* CKey: WB to front            *)
    frontToBack * : CHAR;       (* CKey: front screen to back   *)
    reqTrue     * : CHAR;       (* CKey: Requester TRUE         *)
    reqFalse    * : CHAR;       (* CKey: Requester FALSE        *)
  END;

CONST
(* flags for IControlPrefs.ic_Flags *)
  coerceColors * = 0;
  coerceLace   * = 1;
  strGadFilter * = 2;
  menuSnap     * = 3;
  modePromote  * = 4;


(*****************************************************************************)


  idINPT      * = SYSTEM.VAL(LONGINT,'INPT');

TYPE
  InputPrefs  * = STRUCT
    keymap       * : ARRAY 16 OF CHAR;
    pointerTicks * : INTEGER;
    doubleClick  * : Timer.TimeVal;
    keyRptDelay  * : Timer.TimeVal;
    keyRptSpeed  * : Timer.TimeVal;
    mouseAccel   * : INTEGER;
  END;


(*****************************************************************************)

CONST
  idLCLE      * = SYSTEM.VAL(LONGINT,'LCLE') ;
  idCTRY      * = SYSTEM.VAL(LONGINT,'CTRY') ;

TYPE
  CountryPrefs * = STRUCT
    reserved              * : ARRAY 4 OF LONGINT;
    countryCode           * : LONGINT;
    telephoneCode         * : LONGINT;
    measuringSystem       * : SHORTINT;

    dateTimeFormat        * : ARRAY 80 OF CHAR;
    dateFormat            * : ARRAY 40 OF CHAR;
    timeFormat            * : ARRAY 40 OF CHAR;

    shortDateTimeFormat   * : ARRAY 80 OF CHAR;
    shortDateFormat       * : ARRAY 40 OF CHAR;
    shortTimeFormat       * : ARRAY 40 OF CHAR;

    (* for numeric values *)
    decimalPoint          * : ARRAY 10 OF CHAR;
    groupSeparator        * : ARRAY 10 OF CHAR;
    fracGroupSeparator    * : ARRAY 10 OF CHAR;
    grouping              * : ARRAY 10 OF SHORTINT;
    fracGrouping          * : ARRAY 10 OF SHORTINT;

    (* for monetary values *)
    monDecimalPoint       * : ARRAY 10 OF CHAR;
    monGroupSeparator     * : ARRAY 10 OF CHAR;
    monFracGroupSeparator * : ARRAY 10 OF CHAR;
    monGrouping           * : ARRAY 10 OF SHORTINT;
    monFracGrouping       * : ARRAY 10 OF SHORTINT;
    monFracDigits         * : SHORTINT;
    monIntFracDigits      * : SHORTINT;

    (* for currency symbols *)
    monCS                 * : ARRAY 10 OF CHAR;
    monSmallCS            * : ARRAY 10 OF CHAR;
    monIntCS              * : ARRAY 10 OF CHAR;

    (* for positive monetary values *)
    monPositiveSign       * : ARRAY 10 OF CHAR;
    monPositiveSpaceSep   * : SHORTINT;
    monPositiveSignPos    * : SHORTINT;
    monPositiveCSPos      * : SHORTINT;

    (* for negative monetary values *)
    monNegativeSign       * : ARRAY 10 OF CHAR;
    monNegativeSpaceSep   * : SHORTINT;
    monNegativeSignPos    * : SHORTINT;
    monNegativeCSPos      * : SHORTINT;

    calendarType          * : SHORTINT;
  END;


  LocalePrefs * = STRUCT
    reserved           * : ARRAY 4 OF LONGINT;
    countryName        * : ARRAY 32 OF CHAR;
    preferredLanguages * : ARRAY 10,30 OF CHAR;
    gmtOffset          * : LONGINT;
    flags              * : LONGSET;
    countryData        * : CountryPrefs;
  END;


(*****************************************************************************)

CONST
  idOSCN      * = SYSTEM.VAL(LONGINT,'OSCN');

  oscanMagic  * = 0FEDCBA89H;

TYPE
  OverscanPrefs * = STRUCT
    reserved  * : LONGINT;
    magic     * : LONGINT;
    hStart    * : INTEGER;
    hStop     * : INTEGER;
    vStart    * : INTEGER;
    vStop     * : INTEGER;
    displayID * : LONGINT;
    viewPos   * : g.Point;
    text      * : g.Point;
    standard  * : g.Rectangle;
  END;

(* os_HStart, os_HStop, os_VStart, os_VStop can only be looked at if
 * os_Magic equals OSCAN_MAGIC. If os_Magic is set to any other value,
 * these four fields are undefined
 *)


(*****************************************************************************)

CONST
  idPALT      * = SYSTEM.VAL(LONGINT,'PALT');

TYPE
  PalettePrefs * = STRUCT
    reserved      * : ARRAY 4 OF LONGINT;      (* System reserved                *)
    pap4colorPens * : ARRAY 32 OF INTEGER;
    pap8colorPens * : ARRAY 32 OF INTEGER;
    colors        * : ARRAY 32 OF I.ColorSpec; (* Used as full 16-bit RGB values *)
  END;


(*****************************************************************************)

CONST
  idPNTR      * = SYSTEM.VAL(LONGINT,'PNTR');

TYPE
  PointerPrefs * = STRUCT
    reserved  * : ARRAY 4 OF LONGINT;
    which     * : INTEGER;            (* 0=NORMAL, 1=BUSY *)
    size      * : INTEGER;            (* see <intuition/pointerclass.h> *)
    width     * : INTEGER;            (* Width in pixels *)
    height    * : INTEGER;            (* Height in pixels *)
    depth     * : INTEGER;            (* Depth *)
    ySize     * : INTEGER;            (* YSize *)
    x *, y    * : INTEGER;            (* Hotspot *)

    (* Color Table:  numEntries = (1 << pp_Depth) - 1 *)

    (* Data follows *)
  END;

CONST
(* constants for PointerPrefs.pp_Which *)
  normal      * = 0;
  busy        * = 1;

(*****************************************************************************)

TYPE
  RGBTable    * = STRUCT
    red   * : SHORTINT;
    green * : SHORTINT;
    blue  * : SHORTINT;
  END;

(*****************************************************************************)

CONST
  idPGFX      * = SYSTEM.VAL(LONGINT,'PGFX') ;

TYPE
  PrinterGfxPrefs * = STRUCT
    reserved       * : ARRAY 4 OF LONGINT;
    aspect         * : INTEGER;
    shade          * : INTEGER;
    image          * : INTEGER;
    threshold      * : INTEGER;
    colorCorrect   * : SHORTINT;
    dimensions     * : SHORTINT;
    dithering      * : SHORTINT;
    graphicFlags   * : SET;
    printDensity   * : SHORTINT;   (* Print density 1 - 7 *)
    printMaxWidth  * : INTEGER;
    printMaxHeight * : INTEGER;
    printXOffset   * : SHORTINT;
    printYOffset   * : SHORTINT;
  END;

CONST
(* constants for PrinterGfxPrefs.pg_Aspect *)
  horizontal  * = 0;
  vertical    * = 1;

(* constants for PrinterGfxPrefs.pg_Shade *)
  psBW        * = 0;
  greyScale   * = 1;
  color       * = 2;
  greyScale2  * = 3;

(* constants for PrinterGfxPrefs.pg_Image *)
  positive    * = 0;
  negative    * = 1;

(* flags for PrinterGfxPrefs.pg_ColorCorrect *)
  red         * = 1;         (* color correct red shades   *)
  green       * = 2;         (* color correct green shades *)
  blue        * = 3;         (* color correct blue shades  *)

(* constants for PrinterGfxPrefs.pg_Dimensions *)
  ignore      * = 0;         (* ignore max width/height settings *)
  bounded     * = 1;         (* use max w/h as boundaries        *)
  absolute    * = 2;         (* use max w/h as absolutes         *)
  pixel       * = 3;         (* use max w/h as prt pixels        *)
  multiply    * = 4;         (* use max w/h as multipliers       *)

(* constants for PrinterGfxPrefs.pg_Dithering *)
  ordered     * = 0;         (* ordered dithering *)
  halftone    * = 1;         (* halftone dithering        *)
  floyd       * = 2;         (* Floyd-Steinberg dithering *)

(* flags for PrinterGfxPrefs.pg_GraphicsFlags *)
  centerImage    * = 0;      (* center image on paper *)
  integerScaling * = 1;      (* force integer scaling *)
  antiAlias      * = 2;      (* anti-alias image      *)


(*****************************************************************************)


  idPSPD      * = SYSTEM.VAL(LONGINT,'PSPD') ;

TYPE
  PrinterPSPrefs * = STRUCT
    reserved       * : ARRAY 4 OF LONGINT;  (* System reserved *)

    (* Global printing attributes *)
    driverMode     * : SHORTINT;
    paperFormat    * : SHORTINT;
    reserved1      * : ARRAY 2 OF SHORTINT;
    copies         * : LONGINT;
    paperWidth     * : LONGINT;
    paperHeight    * : LONGINT;
    horizontalDPI  * : LONGINT;
    verticalDPI    * : LONGINT;

    (* Text Options *)
    font           * : SHORTINT;
    pitch          * : SHORTINT;
    orientation    * : SHORTINT;
    tab            * : SHORTINT;
    reserved2      * : ARRAY 8 OF SHORTINT;

    (* Text Dimensions *)
    leftMargin     * : LONGINT;
    rightMargin    * : LONGINT;
    topMargin      * : LONGINT;
    bottomMargin   * : LONGINT;
    fontPointSize  * : LONGINT;
    leading        * : LONGINT;
    reserved3      * : ARRAY 8 OF SHORTINT;

    (* Graphics Options *)
    leftEdge       * : LONGINT;
    topEdge        * : LONGINT;
    width          * : LONGINT;
    height         * : LONGINT;
    image          * : SHORTINT;
    shading        * : SHORTINT;
    dithering      * : SHORTINT;
    reserved4      * : ARRAY 9 OF SHORTINT;

    (* Graphics Scaling *)
    aspect         * : SHORTINT;
    scalingType    * : SHORTINT;
    reserved5      * : SHORTINT;
    centering      * : SHORTINT;
    reserved6      * : ARRAY 8 OF SHORTINT;
  END;

CONST
(* All measurements are in Millipoints which is 1/1000 of a point, or
 * in other words 1/72000 of an inch
 *)

(* constants for PrinterPSPrefs.ps_DriverMode *)
  postscript  * = 0;
  passThrough * = 1;

(* constants for PrinterPSPrefs.ps_PaperFormat *)
  usLetter    * = 0;
  usLegal     * = 1;
  a4          * = 2;
  custom      * = 3;

(* constants for PrinterPSPrefs.ps_Font *)
  courier      * = 0;
  times        * = 1;
  helvetica    * = 2;
  helvNarrow   * = 3;
  avantgarde   * = 4;
  bookman      * = 5;
  newCent      * = 6;
  palatino     * = 7;
  zapfChancery * = 8;

(* constants for PrinterPSPrefs.ps_Pitch *)
  pitchNormal     * = 0;
  pitchCompressed * = 1;
  pitchExpanded   * = 2;

(* constants for PrinterPSPrefs.ps_Orientation *)
  portrait     * = 0;
  landscape    * = 1;

(* constants for PrinterPSPrefs.ps_Tab *)
  tab4         * = 0;
  tab8         * = 1;
  tabQuart     * = 2;
  tabHalf      * = 3;
  tabInch      * = 4;

(* constants for PrinterPSPrefs.ps_Image *)
  (* positive  * = 0; *) (* same values as for printergfx *)
  (* negative  * = 1; *)

(* constants for PrinterPSPrefs.ps_Shading *)
  shadBW        * = 0;
  shadGreyScale * = 1;
  shadColor     * = 2;

(* constants for PrinterPSPrefs.ps_Dithering *)
  default    * = 0;
  dotty      * = 1;
  vert       * = 2;
  horiz      * = 3;
  diag       * = 4;

(* constants for PrinterPSPrefs.ps_Aspect *)
  aspHoriz    * = 0;
  aspVert     * = 1;

(* constants for PrinterPSPrefs.ps_ScalingType *)
  aspectAsIs  * = 0;
  aspectWide  * = 1;
  aspectTall  * = 2;
  aspectBoth  * = 3;
  fitsWide    * = 4;
  fitsTall    * = 5;
  fitsBoth    * = 6;

(* constants for PrinterPSPrefs.ps_Centering *)
  centNone    * = 0;
  centHoriz   * = 1;
  centVert    * = 2;
  centBoth    * = 3;


(*****************************************************************************)


  idPTXT      * = SYSTEM.VAL(LONGINT,'PTXT') ;
  idPUNT      * = SYSTEM.VAL(LONGINT,'PUNT') ;


  driverNameSize * = 30;   (* filename size     *)
  deviceNameSize * = 32;   (* .device name size *)

TYPE
  PrinterTxtPrefs * = STRUCT
    reserved    * : ARRAY 4 OF LONGINT;    (* System reserved            *)
    driver      * : ARRAY driverNameSize OF SHORTINT; (* printer driver filename *)
    port        * : SHORTINT;              (* printer port connection    *)

    paperType   * : INTEGER;
    paperSize   * : INTEGER;
    paperLength * : INTEGER;               (* Paper length in # of lines *)

    pitch       * : INTEGER;
    spacing     * : INTEGER;
    leftMargin  * : INTEGER;               (* Left margin                *)
    rightMargin * : INTEGER;               (* Right margin               *)
    quality     * : INTEGER;
  END;

CONST
(* constants for PrinterTxtPrefs.pt_Port *)
  parallel    * = 0;
  serial      * = 1;

(* constants for PrinterTxtPrefs.pt_PaperType *)
  fanfold     * = 0;
  single      * = 1;

(* constants for PrinterTxtPrefs.pt_PaperSize *)
  psUSLetter  * = 0;
  psUSLegal   * = 1;
  psNTractor  * = 2;
  psWTractor  * = 3;
  psCustom    * = 4;
  psEuroA0    * = 5;      (* European size A0: 841 x 1189 *)
  psEuroA1    * = 6;      (* European size A1: 594 x 841  *)
  psEuroA2    * = 7;      (* European size A2: 420 x 594  *)
  psEuroA3    * = 8;      (* European size A3: 297 x 420  *)
  psEuroA4    * = 9;      (* European size A4: 210 x 297  *)
  psEuroA5    * = 10;     (* European size A5: 148 x 210  *)
  psEuroA6    * = 11;     (* European size A6: 105 x 148  *)
  psEuroA7    * = 12;     (* European size A7: 74 x 105   *)
  psEuroA8    * = 13;     (* European size A8: 52 x 74    *)

(* constants for PrinterTxtPrefs.pt_PrintPitch *)
  pica        * = 0;
  elite       * = 1;
  fine        * = 2;

(* constants for PrinterTxtPrefs.pt_PrintSpacing *)
  sixLPI      * = 0;
  eightLPI    * = 1;

(* constants for PrinterTxtPrefs.pt_PrintQuality *)
  draft       * = 0;
  letter      * = 1;

TYPE
  PrinterUnitPrefs * = STRUCT
    reserved        * : ARRAY 4 OF LONGINT;  (* System reserved              *)
    unitNum         * : LONGINT;             (* Unit number for OpenDevice() *)
    openDeviceFlags * : LONGSET;             (* Flags for OpenDevice()       *)
    deviceName      * : ARRAY deviceNameSize OF SHORTINT;  (* Name for OpenDevice() *)
  END;


(*****************************************************************************)

CONST
  idSCRM      * = SYSTEM.VAL(LONGINT,'SCRM') ;

TYPE
  ScreenModePrefs * = STRUCT
    reserved   * : ARRAY 4 OF LONGINT;
    displayID  * : LONGINT;
    width      * : INTEGER;
    height     * : INTEGER;
    depth      * : INTEGER;
    control    * : INTEGER;
  END;

CONST
(* flags for ScreenModePrefs.smp_Control *)
  autoScroll  * = 1;


(*****************************************************************************)


  idSERL      * = SYSTEM.VAL(LONGINT,'SERL') ;

TYPE
  SerialPrefs * = STRUCT
    reserved        * : ARRAY 3 OF LONGINT; (* System reserved           *)
    unit0Map        * : LONGINT;     (* What unit 0 really refers to     *)
    baudRate        * : LONGINT;     (* Baud rate                        *)

    inputBuffer     * : LONGINT;     (* Input buffer: 0 - 65536          *)
    outputBuffer    * : LONGINT;     (* Future: Output: 0 - 65536        *)

    inputHandshake  * : SHORTINT;    (* Input handshaking                *)
    outputHandshake * : SHORTINT;    (* Future: Output handshaking       *)

    parity          * : SHORTINT;    (* Parity                           *)
    bitsPerChar     * : SHORTINT;    (* I/O bits per character           *)
    stopBits        * : SHORTINT;    (* Stop bits                        *)
  END;

CONST
(* constants for SerialPrefs.sp_Parity *)
  parityNone  * = 0;
  parityEven  * = 1;
  parityOdd   * = 2;
  parityMark  * = 3;        (* Future enhancement *)
  paritySpace * = 4;        (* Future enhancement *)

(* constants for SerialPrefs.sp_Input/OutputHandshaking *)
  hshakeXON   * = 0;
  hshakeRTS   * = 1;
  hshakeNone  * = 2;


(*****************************************************************************)


  idSOND      * = SYSTEM.VAL(LONGINT,'SOND') ;

TYPE
  SoundPrefs  * = STRUCT
    reserved      * : ARRAY 4 OF LONGINT;(* System reserved            *)
    displayQueue  * : BOOLEAN;           (* Flash the display?         *)
    audioQueue    * : BOOLEAN;           (* Make some sound?           *)
    audioType     * : INTEGER;           (* Type of sound, see below   *)
    audioVolume   * : INTEGER;           (* Volume of sound, 0..64     *)
    audioPeriod   * : INTEGER;           (* Period of sound, 127..2500 *)
    audioDuration * : INTEGER;           (* Length of simple beep      *)
    audioFileName * : ARRAY 256 OF CHAR; (* Filename of 8SVX file      *)
  END;

CONST
(* constants for SoundPrefs.sop_AudioType *)
  beep        * = 0;      (* simple beep sound *)
  sample      * = 1;      (* sampled sound     *)


(*****************************************************************************)

  idPTRN      * = SYSTEM.VAL(LONGINT,'PTRN');

TYPE
  WBPatternPrefs * = STRUCT
    reserved    * : ARRAY 4 OF LONGINT;
    which       * : INTEGER;    (* Which pattern is it *)
    flags       * : SET;
    revision    * : SHORTINT;   (* Must be set to zero *)
    depth       * : SHORTINT;   (* Depth of pattern *)
    dataLength  * : INTEGER;    (* Length of following data *)
  END;

CONST
(* constants for WBPatternPrefs.wbp_Which *)
  root        * = 0;
  drawer      * = 1;
  screen      * = 2;

(* wbp_Flags values *)
  pattern     * = 0; (* Data contains a pattern *)
  noRemap     * = 4; (* Don't remap the pattern *)

(* wbp_Depth values *)
  maxDepth    * = 3;       (*  max depth supported (8 colors) *)
  defPatDepth * = 2;       (*  depth of default patterns *)

(*  Pattern width & height: *)
  patWidth    * = 16;
  patHeight   * = 16;

END Prefs.

