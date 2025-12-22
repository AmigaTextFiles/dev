(*
(*
**  Amiga Oberon Interface Module:
**  $VER: Printer.mod 40.15 (3.1.94) Oberon 3.1
**
**   © 1993 by Fridtjof Siebert
**   updated for V40 by hartmut Goebel
*)
*)

MODULE Printer;   (* $IFNOT CheckSizes $Implementation- $END *)

IMPORT e   * := Exec,
       par * := Parallel,
       ser * := Serial,
       g   * := Graphics,
       I   * := Intuition,
       t   * := Timer,
       SYSTEM;

CONST
  rawWrite    * = e.nonstd+0;
  prtCommand  * = e.nonstd+1;
  dumpRPort   * = e.nonstd+2;
  query       * = e.nonstd+3;

(* printer command definitions *)

  aRIS    * =  0;  (* ESCc  reset                    ISO *)
  aRIN    * =  1;  (* ESC#1 initialize               +++ *)
  aIND    * =  2;  (* ESCD  lf                       ISO *)
  aNEL    * =  3;  (* ESCE  return,lf                ISO *)
  aRI     * =  4;  (* ESCM  reverse lf               ISO *)

  aSGR0   * =  5;  (* ESC[0m normal char set         ISO *)
  aSGR3   * =  6;  (* ESC[3m italics on              ISO *)
  aSGR23  * =  7;  (* ESC[23m italics off            ISO *)
  aSGR4   * =  8;  (* ESC[4m underline on            ISO *)
  aSGR24  * =  9;  (* ESC[24m underline off          ISO *)
  aSGR1   * = 10;  (* ESC[1m boldface on             ISO *)
  aSGR22  * = 11;  (* ESC[22m boldface off           ISO *)
  aSFC    * = 12;  (* SGR30-39  set foreground color ISO *)
  aSBC    * = 13;  (* SGR40-49  set background color ISO *)

  aSHORP0 * = 14;  (* ESC[0w normal pitch            DEC *)
  aSHORP2 * = 15;  (* ESC[2w elite on                DEC *)
  aSHORP1 * = 16;  (* ESC[1w elite off               DEC *)
  aSHORP4 * = 17;  (* ESC[4w condensed fine on       DEC *)
  aSHORP3 * = 18;  (* ESC[3w condensed off           DEC *)
  aSHORP6 * = 19;  (* ESC[6w enlarged on             DEC *)
  aSHORP5 * = 20;  (* ESC[5w enlarged off            DEC *)

  aDEN6   * = 21;  (* ESC[6"z shadow print on        DEC (sort of) *)
  aDEN5   * = 22;  (* ESC[5"z shadow print off       DEC *)
  aDEN4   * = 23;  (* ESC[4"z doublestrike on        DEC *)
  aDEN3   * = 24;  (* ESC[3"z doublestrike off       DEC *)
  aDEN2   * = 25;  (* ESC[2"z  NLQ on                DEC *)
  aDEN1   * = 26;  (* ESC[1"z  NLQ off               DEC *)

  aSUS2   * = 27;  (* ESC[2v superscript on          +++ *)
  aSUS1   * = 28;  (* ESC[1v superscript off         +++ *)
  aSUS4   * = 29;  (* ESC[4v subscript on            +++ *)
  aSUS3   * = 30;  (* ESC[3v subscript off           +++ *)
  aSUS0   * = 31;  (* ESC[0v normalize the line      +++ *)
  aPLU    * = 32;  (* ESCL  partial line up          ISO *)
  aPLD    * = 33;  (* ESCK  partial line down        ISO *)

  aFNT0   * = 34;  (* ESC(B US char set        or Typeface  0 (default) *)
  aFNT1   * = 35;  (* ESC(R French char set    or Typeface  1 *)
  aFNT2   * = 36;  (* ESC(K German char set    or Typeface  2 *)
  aFNT3   * = 37;  (* ESC(A UK char set        or Typeface  3 *)
  aFNT4   * = 38;  (* ESC(E Danish I char set  or Typeface  4 *)
  aFNT5   * = 39;  (* ESC(H Sweden char set    or Typeface  5 *)
  aFNT6   * = 40;  (* ESC(Y Italian char set   or Typeface  6 *)
  aFNT7   * = 41;  (* ESC(Z Spanish char set   or Typeface  7 *)
  aFNT8   * = 42;  (* ESC(J Japanese char set  or Typeface  8 *)
  aFNT9   * = 43;  (* ESC(6 Norweign char set  or Typeface  9 *)
  aFNT10  * = 44;  (* ESC(C Danish II char set or Typeface 10 *)

(*
   Suggested typefaces are:

   0 - default typeface.
   1 - Line Printer or equiv.
   2 - Pica or equiv.
   3 - Elite or equiv.
   4 - Helvetica or equiv.
   5 - Times Roman or equiv.
   6 - Gothic or equiv.
   7 - Script or equiv.
   8 - Prestige or equiv.
   9 - Caslon or equiv.
  10 - Orator or equiv.
*)

  aPROP2  * = 45;  (* ESC[2p  proportional on        +++ *)
  aPROP1  * = 46;  (* ESC[1p  proportional off       +++ *)
  aPROP0  * = 47;  (* ESC[0p  proportional clear     +++ *)
  aTSS    * = 48;  (* ESC[n E set proportional offset ISO *)
  aJFY5   * = 49;  (* ESC[5 F auto left justify      ISO *)
  aJFY7   * = 50;  (* ESC[7 F auto right justify     ISO *)
  aJFY6   * = 51;  (* ESC[6 F auto full justify      ISO *)
  aJFY0   * = 52;  (* ESC[0 F auto justify off       ISO *)
  aJFY3   * = 53;  (* ESC[3 F letter space (justify) ISO (special) *)
  aJFY1   * = 54;  (* ESC[1 F word fill(auto center) ISO (special) *)

  aVERP0  * = 55;  (* ESC[0z  1/8" line spacing      +++ *)
  aVERP1  * = 56;  (* ESC[1z  1/6" line spacing      +++ *)
  aSLPP   * = 57;  (* ESC[nt  set form length n      DEC *)
  aPERF   * = 58;  (* ESC[nq  perf skip n (n>0)      +++ *)
  aPERF0  * = 59;  (* ESC[0q  perf skip off          +++ *)

  aLMS    * = 60;  (* ESC#9   Left margin set        +++ *)
  aRMS    * = 61;  (* ESC#0   Right margin set       +++ *)
  aTMS    * = 62;  (* ESC#8   Top margin set         +++ *)
  aBMS    * = 63;  (* ESC#2   Bottom marg set        +++ *)
  aSTBM   * = 64;  (* ESC[Pn1;Pn2r  T&B margins      DEC *)
  aSLRM   * = 65;  (* ESC[Pn1;Pn2s  L&R margin       DEC *)
  aCAM    * = 66;  (* ESC#3   Clear margins          +++ *)

  aHTS    * = 67;  (* ESCH    Set horiz tab          ISO *)
  aVTS    * = 68;  (* ESCJ    Set vertical tabs      ISO *)
  aTBC0   * = 69;  (* ESC[0g  Clr horiz tab          ISO *)
  aTBC3   * = 70;  (* ESC[3g  Clear all h tab        ISO *)
  aTBC1   * = 71;  (* ESC[1g  Clr vertical tabs      ISO *)
  aTBC4   * = 72;  (* ESC[4g  Clr all v tabs         ISO *)
  aTBCALL * = 73;  (* ESC#4   Clr all h & v tabs     +++ *)
  aTBSALL * = 74;  (* ESC#5   Set default tabs       +++ *)
  aEXTEND * = 75;  (* ESC[Pn"x extended commands     +++ *)

  aRAW    * = 76;      (* ESC[Pn"r     Next 'Pn' chars are raw +++ *)

TYPE
  IOPrtCmdReqPtr * = UNTRACED POINTER TO IOPrtCmdReq;
  IOPrtCmdReq * = STRUCT (message * : e.Message)
    device  *: e.DevicePtr;        (* device node pointer  *)
    unit    *: e.UnitPtr;          (* unit (driver private)*)
    command *: INTEGER;            (* device command *)
    flags   *: SHORTSET;
    error   *: SHORTINT;           (* error or warning num *)
    prtCommand * : INTEGER;        (* printer command *)
    parm0 * : e.BYTE;              (* first command parameter *)
    parm1 * : e.BYTE;              (* second command parameter *)
    parm2 * : e.BYTE;              (* third command parameter *)
    parm3 * : e.BYTE;              (* fourth command parameter *)
  END;

  IODRPReqPtr * = UNTRACED POINTER TO IODRPReq;
  IODRPReq * = STRUCT (message * : e.Message)
    device * : e.DevicePtr;        (* device node pointer  *)
    unit * : e.UnitPtr;            (* unit (driver private)*)
    command * : INTEGER;           (* device command *)
    flags * : SHORTSET;
    error * : SHORTINT;            (* error or warning num *)
    rastPort * : g.RastPortPtr;    (* raster port *)
    colorMap * : g.ColorMapPtr;    (* color map *)
    modes * : LONGSET;             (* graphics viewport modes *)
    srcX * : INTEGER;              (* source x origin *)
    srcY * : INTEGER;              (* source y origin *)
    srcWidth * : INTEGER;          (* source x width *)
    srcHeight * : INTEGER;         (* source x height *)
    destCols * : LONGINT;          (* destination x width *)
    destRows * : LONGINT;          (* destination y height *)
    special * : SET;               (* option flags *)
  END;

CONST
  milCols     * = 0;        (* DestCols specified in 1/1000" *)
  milRows     * = 1;        (* DestRows specified in 1/1000" *)
  fullCols    * = 2;        (* make DestCols maximum possible *)
  fullRows    * = 3;        (* make DestRows maximum possible *)
  fracCols    * = 4;        (* DestCols is fraction of FULLCOLS *)
  fracRows    * = 5;        (* DestRows is fraction of FULLROWS *)
  center      * = 6;        (* center image on paper *)
  aspect      * = 7;        (* ensure correct aspect ratio *)
  density1    * = {8};      (* lowest resolution (dpi) *)
  density2    * = {9};      (* next res *)
  density3    * = {8,9};    (* next res *)
  density4    * = {10};     (* next res *)
  density5    * = {8,10};   (* next res *)
  density6    * = {9,10};   (* next res *)
  density7    * = {8,9,10}; (* highest res *)
  noFormFeed  * = 11;       (* don't eject paper on gfx prints *)
  trustMe     * = 12;       (* don't reset on gfx prints *)
(*
   Compute print size, set 'io_DestCols' and 'io_DestRows' in the calling
   program's 'IODRPReq' structure and exit, DON'T PRINT.  This allows the
   calling program to see what the final print size would be in printer
   pixels.  Note that it modifies the 'io_DestCols' and 'io_DestRows'
   fields of your 'IODRPReq' structure.  Also, set the print density and
   update the 'MaxXDots', 'MaxYDots', 'XDotsInch', and 'YDotsInch' fields
   of the 'PrinterExtendedData' structure.
*)
  noPrint     * = 13;       (* see above *)

  noErr            * = 0;   (* clean exit, no errors *)
  cancel           * = 1;   (* user cancelled print *)
  notGraphics      * = 2;   (* printer cannot output graphics *)
  invertHAM        * = 3;   (* OBSOLETE *)
  badDimension     * = 4;   (* print dimensions illegal *)
  dimensionOvflow  * = 5;   (* OBSOLETE *)
  internalMemory   * = 6;   (* no memory for internal variables *)
  bufferMemory     * = 7;   (* no memory for print buffer *)
(*
   Note : this is an internal error that can be returned from the render
   function to the printer device.  It is NEVER returned to the user.
   If the printer device sees this error it converts it 'PDERR_NOERR'
   and exits gracefully.  Refer to the document on
   'How to Write a Graphics Printer Driver' for more info.
*)
  tookControl      * = 8;   (* Took control in case 0 of render *)

(* internal use *)
  densityMask      * = {8..10}; (* masks out density values *)
  dimensionMask    * = {milCols..fracRows,aspect};


  yellow    * = 0;          (* byte index for yellow *)
  magenta   * = 1;          (* byte index for magenta *)
  cyan      * = 2;          (* byte index for cyan *)
  black     * = 3;          (* byte index for black *)
  blue      * = yellow;     (* byte index for blue *)
  green     * = magenta;    (* byte index for green *)
  red       * = cyan;       (* byte index for red *)
  white     * = black;      (* byte index for white *)


TYPE
  colorEntryPtr * = UNTRACED POINTER TO colorEntry;
  colorEntry * = STRUCT
    colorByte * : ARRAY 4 OF e.BYTE;
  END;

  PrtInfoPtr * = UNTRACED POINTER TO PrtInfo;
  PrtInfo * = STRUCT
    render   : PROCEDURE(): LONGINT; (* PRIVATE - DO NOT USE! *)
    rp       : g.RastPortPtr;        (* PRIVATE - DO NOT USE! *)
    temprp   : g.RastPortPtr;        (* PRIVATE - DO NOT USE! *)
    rowBuf   : e.APTR;               (* PRIVATE - DO NOT USE! *)
    hamBuf   : e.APTR;               (* PRIVATE - DO NOT USE! *)
    colorMap   : colorEntryPtr;      (* PRIVATE - DO NOT USE! *)
    colorInt * : colorEntryPtr;      (* color intensities for entire row *)
    hamInt     : colorEntryPtr;      (* PRIVATE - DO NOT USE! *)
    dest1Int   : colorEntryPtr;      (* PRIVATE - DO NOT USE! *)
    dest2Int   : colorEntryPtr;      (* PRIVATE - DO NOT USE! *)
    scaleX  * : e.APTR;              (* array of scale values for X *)
    scaleXAlt : e.APTR;              (* PRIVATE - DO NOT USE! *)
    dmatrix * : e.APTR;              (* pointer to dither matrix *)
    topBuf    : e.APTR;              (* PRIVATE - DO NOT USE! *)
    botBuf    : e.APTR;              (* PRIVATE - DO NOT USE! *)

    rowBufSize   : INTEGER;          (* PRIVATE - DO NOT USE! *)
    hamBufSize   : INTEGER;          (* PRIVATE - DO NOT USE! *)
    colorMapSize : INTEGER;          (* PRIVATE - DO NOT USE! *)
    colorIntSize : INTEGER;          (* PRIVATE - DO NOT USE! *)
    hamIntSize   : INTEGER;          (* PRIVATE - DO NOT USE! *)
    dest1IntSize : INTEGER;          (* PRIVATE - DO NOT USE! *)
    dest2IntSize : INTEGER;          (* PRIVATE - DO NOT USE! *)
    scaleXSize   : INTEGER;          (* PRIVATE - DO NOT USE! *)
    scaleXAltSize: INTEGER;          (* PRIVATE - DO NOT USE! *)

    prefsFlags: SET;                 (* PRIVATE - DO NOT USE! *)
    special   : LONGINT;             (* PRIVATE - DO NOT USE! *)
    xstart    : INTEGER;             (* PRIVATE - DO NOT USE! *)
    ystart    : INTEGER;             (* PRIVATE - DO NOT USE! *)
    width   * : INTEGER;             (* source width (in pixels) *)
    height    : INTEGER;             (* PRIVATE - DO NOT USE! *)
    pc        : LONGINT;             (* PRIVATE - DO NOT USE! *)
    pr        : LONGINT;             (* PRIVATE - DO NOT USE! *)
    ymult     : INTEGER;             (* PRIVATE - DO NOT USE! *)
    ymod      : INTEGER;             (* PRIVATE - DO NOT USE! *)
    ety       : INTEGER;             (* PRIVATE - DO NOT USE! *)
    xpos      * : INTEGER;           (* offset to start printing picture *)
    threshold * : INTEGER;           (* threshold value (from prefs) *)
    tempwidth   : INTEGER;           (* PRIVATE - DO NOT USE! *)
    flags       : SET;               (* PRIVATE - DO NOT USE! *)
  END;

  DeviceDataPtr * = UNTRACED POINTER TO DeviceData;
  DeviceData * = STRUCT (device * : e.Library) (* standard library node *)
    segment * : e.BPTR;          (* A0 when initialized *)
    execBase * : e.LibraryPtr;   (* A6 for exec *)
    cmdVectors * : e.APTR;       (* command table for device commands *)
    cmdBytes * : e.APTR;         (* bytes describing which command queue *)
    numCommands * : INTEGER;     (* the number of commands supported *)
  END;

CONST
  oldStkSize    * = 00800H;  (* stack size for child task (OBSOLETE) *)
  stkSize       * = 01000H;  (* stack size for child task *)
  bugSize       * = 256;     (* size of internal buffers for text i/o *)
  safeSize      * = 128;     (* safety margin for text output buffer *)

TYPE
  PrinterSegmentPtr * = UNTRACED POINTER TO PrinterSegment;

  PrinterDataPtr * = UNTRACED POINTER TO PrinterData;
  PrinterData * = STRUCT (device * : DeviceData)
    unit * : e.MsgPort;                   (* the one and only unit *)
    printerSegment * : e.BPTR;            (* the printer specific segment *)
    printerType * : INTEGER;              (* the segment printer type *)
                                          (* the segment data structure *)
    segmentData * : PrinterSegmentPtr;
    printBuf * : e.APTR;                  (* the raster print buffer *)
    pWrite * : PROCEDURE(): LONGINT;      (* the write function *)
    pBothReady * : PROCEDURE(): LONGINT;  (* write function's done *)
    p0 * : par.IOExtPar;                  (* port I/O request 0 *)
    dummy0: ARRAY SIZE(ser.IOExtSer) - SIZE(par.IOExtPar) OF e.BYTE;
           (* pad missing bytes *)
    p1 * : par.IOExtPar;                  (*   and 1 for double buffering *)
    dummy1: ARRAY SIZE(ser.IOExtSer) - SIZE(par.IOExtPar) OF e.BYTE;
           (* pad missing bytes *)

    tior * : t.TimeRequest;               (* timer I/O request *)
    iorPort * : e.MsgPort;                (* and message reply port *)
    tc * : e.Task;                        (* write task *)
    oldStk * : ARRAY oldStkSize OF e.BYTE;(* and stack space (OBSOLETE) *)
    flags * : SHORTSET;                   (* device flags *)
    pad * : e.BYTE;
    preferences * : I.Preferences;        (* the latest preferences *)
    pWaitEnabled * : SHORTINT;            (* wait function switch *)
        (* new fields for V2.0 *)
    flags1 * : SHORTSET;
    stk * : ARRAY stkSize OF e.BYTE;      (* stack space *)
  END;

  PrinterDataSerPtr * = UNTRACED POINTER TO PrinterDataSer;
  PrinterDataSer * = STRUCT (device * : DeviceData)
    unit * : e.MsgPort;                   (* the one and only unit *)
    printerSegment * : e.BPTR;            (* the printer specific segment *)
    printerType * : INTEGER;              (* the segment printer type *)
                                          (* the segment data structure *)
    segmentData * : PrinterSegmentPtr;
    printBuf * : e.APTR;                  (* the raster print buffer *)
    pWrite * : PROCEDURE(): LONGINT;      (* the write function *)
    pBothReady * : PROCEDURE(): LONGINT;  (* write function's done *)
    s0 * : ser.IOExtSer;                  (* port I/O request 0 *)
    s1 * : ser.IOExtSer;                  (*   and 1 for double buffering *)
    tior * : t.TimeRequest;               (* timer I/O request *)
    iorPort * : e.MsgPort;                (* and message reply port *)
    tc * : e.Task;                        (* write task *)
    oldStk * : ARRAY oldStkSize OF e.BYTE;(* and stack space (OBSOLETE) *)
    flags * : SHORTSET;                   (* device flags *)
    pad * : e.BYTE;
    preferences * : I.Preferences;        (* the latest preferences *)
    pWaitEnabled * : SHORTINT;            (* wait function switch *)
        (* new fields for V2.0 *)
    flags1 * : SHORTSET;
    stk * : ARRAY stkSize OF e.BYTE;      (* stack space *)
  END;

CONST
(* Printer Class *)
  gfx       * = 0;       (* graphics (bit position) *)
  color     * = 1;       (* color (bit position) *)

  bwAlpha     * = SHORTSET{};           (* black&white alphanumerics *)
  bwGfx       * = SHORTSET{gfx};        (* black&white graphics *)
  colorAlpha  * = SHORTSET{color};      (* color alphanumerics *)
  colorGfx    * = SHORTSET{gfx,color};  (* color graphics *)

(* Color Class *)
  bw          * = SHORTSET{0};      (* black&white only *)
  ymc         * = SHORTSET{1};      (* yellow/magenta/cyan only *)
  ymcBW       * = SHORTSET{0,1};    (* yellow/magenta/cyan or black&white *)
  ymcb        * = 2;                (* yellow/magenta/cyan/black *)
  fourcolor   * = 2;                (* a flag for YMCB and BGRW *)
  additive    * = 3;                (* not ymcb but blue/green/red/white *)
  wb          * = SHORTSET{0,3};    (* black&white only, 0 == BLACK *)
  bgr         * = SHORTSET{1,3};    (* blue/green/red *)
  bgrWB       * = SHORTSET{0,1,3};  (* blue/green/red or black&white *)
  bgrw        * = SHORTSET{2,3};    (* blue/green/red/white *)
(*
        The picture must be scanned once for each color component, as the
        printer can only define one color at a time.  ie. If 'PCC_YMC' then
        first pass sends all 'Y' info to printer, second pass sends all 'M'
        info, and third pass sends all C info to printer.  The CalComp
        PlotMaster is an example of this type of printer.
*)
  multiPass * = 4;  (* see explanation above *)

TYPE
  PrinterExtendedDataPtr * = UNTRACED POINTER TO PrinterExtendedData;
  PrinterExtendedData * = STRUCT
    printerName * : e.LSTRPTR;           (* printer name, null terminated *)
    init * : e.PROC;                     (* called after LoadSeg *)
    expunge * : e.PROC;                  (* called before UnLoadSeg *)
    open * : PROCEDURE(): LONGINT;       (* called at OpenDevice *)
    close * : e.PROC;                    (* called at CloseDevice *)
    printerClass * : SHORTSET;           (* printer class *)
    colorClass * : SHORTSET;             (* color class *)
    maxColumns * : SHORTINT;             (* number of print columns available *)
    numCharSets * : SHORTINT;            (* number of character sets *)
    numRows * : INTEGER;                 (* number of 'pins' in print head *)
    maxXDots * : LONGINT;                (* number of dots max in a raster dump *)
    maxYDots * : LONGINT;                (* number of dots max in a raster dump *)
    xDotsInch * : INTEGER;               (* horizontal dot density *)
    yDotsInch * : INTEGER;               (* vertical dot density *)
    commands * : e.APTR;                 (* printer text command table *)
    doSpecial * : PROCEDURE(): LONGINT;  (* special command handler *)
    render * : PROCEDURE(): LONGINT;     (* raster render function *)
    timeoutSecs * : LONGINT;             (* good write timeout *)
    (* the following only exists if the segment version is >= 33 *)
    eightBitChars * : e.APTR;            (* conv. strings for the extended font *)
    printMode * : LONGINT;               (* set if text printed, otherwise 0 *)
    (* the following only exists if the segment version is >= 34 *)
    (* ptr to conversion function for all chars *)
    convFunc * : PROCEDURE(): LONGINT;
  END;

  PrinterSegment * = STRUCT
    nextSegment * : e.BPTR;      (* (actually a BPTR) *)
    runAlert * : LONGINT;         (* MOVEQ #0,D0 : RTS *)
    version * : INTEGER;  (* segment version *)
    revision * : INTEGER;         (* segment revision *)
    ped * : PrinterExtendedData;   (* printer extended data *)
  END;

(* $IF CheckSizes *)
 (* only a dummy to make sure SIZE(PrinterData) = SIZE(PrinterDataSer) *)
 PROCEDURE CheckPrinterDataSize(pd:PrinterData): PrinterDataSer;
 BEGIN RETURN SYSTEM.VAL(PrinterDataSer,pd); END CheckPrinterDataSize;
(* $END *)

END Printer.

