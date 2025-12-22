(*
(*  Amiga Oberon Interface Module:
**  $VER: Datatypes.mod 40.15 (28.12.93) Oberon 3.0
**
**      (C) Copyright 1991-1992 Commodore-Amiga, Inc.
**          All Rights Reserved
**
**      (C) Copyright Oberon Interface 1993 by hartmut Goebel
*)          All Rights Reserved
*)

MODULE Datatypes;

IMPORT
  d  *:= Dos,
  e  *:= Exec,
  g  *:= Graphics,
  I  *:= Intuition,
  IFF*:= IFFParse,
  prt*:= Printer,
  Rx *:= Rexx,
  u  *:= Utility,
  y  *:=SYSTEM;

TYPE
  DataTypeHeaderPtr *= UNTRACED POINTER TO DataTypeHeader;
  HookContextPtr    *= UNTRACED POINTER TO HookContext;
  ToolPtr           *= UNTRACED POINTER TO Tool;
  DataTypePtr       *= UNTRACED POINTER TO DataType;
  ToolNodePtr       *= UNTRACED POINTER TO ToolNode;
  SpecialInfoPtr    *= UNTRACED POINTER TO SpecialInfo;
  MethodPtr         *= UNTRACED POINTER TO Method;
  FrameInfoPtr      *= UNTRACED POINTER TO FrameInfo;
  BitMapHeaderPtr   *= UNTRACED POINTER TO BitMapHeader;
  ColorRegisterPtr  *= UNTRACED POINTER TO ColorRegister;
  VoiceHeaderPtr    *= UNTRACED POINTER TO VoiceHeader;
  LinePtr           *= UNTRACED POINTER TO Line;

  LIntArrayPtr      *= UNTRACED POINTER TO ARRAY 10000H OF LONGINT;

(*****************************************************************************)

CONST
  idDTYP *= y.VAL(LONGINT,"DTYP");
  idDTHD *= y.VAL(LONGINT,"DTHD");

TYPE
  MaskPtr *= UNTRACED POINTER TO INTEGER;
    (* I suppose the INTEGER realy is STRUCT b: BOOLEAN; c: BYTE END; *)

  DataTypeHeader *= STRUCT
    name     *: e.LSTRPTR; (* Descriptive name of the data type *)
    baseName *: e.LSTRPTR; (* Base name of the data type *)
    pattern  *: e.LSTRPTR; (* Match pattern for file name. *)
    mask     *: MaskPtr;   (* Comparision mask *)
    groupID  *: LONGINT;   (* Group that the DataType is in *)
    id       *: LONGINT;   (* ID for DataType (same as IFF FORM type) *)
    maskLen  *: INTEGER;   (* Length of comparision mask *)
    pad      *: INTEGER;   (* Unused at present (must be 0) *)
    flags    *: SET;       (* Flags *)
    priority *: INTEGER;   (* Priority *)
  END;

CONST
  hSize *= SIZE(DataTypeHeader);

(* Basic type *)
  typeMaskSet *= y.VAL(SET,000FH);
  typeMask *=  000FH;
  binary   *=  0000H;
  ascii    *=  0001H;
  iff      *=  0002H;
  misc     *=  0003H;

  case     *=  0010H;  (* Set if case is important *)
  system1  *=  1000H;  (* Reserved for system use *)

(*****************************************************************************
 *
 * GROUP ID and ID
 *
 * This is used for filtering out objects that you don't want.  For
 * example, you could make a filter for the ASL file requester so
 * that it only showed the files that were pictures, or even to
 * narrow it down to only show files that were ILBM pictures.
 *
 * Note that the Group ID's are in lower case, and always the first
 * four characters of the word.
 *
 * For ID's; If it is an IFF file, then the ID is the same as the
 * FORM type.  If it isn't an IFF file, then the ID would be the
 * first four characters of name for the file type.
 *
 *****************************************************************************)

CONST
  system     *= y.VAL(LONGINT,"syst");  (* System file, such as; directory,
                                    executable, library, device, font, etc. *)
  text       *= y.VAL(LONGINT,"text");  (* Formatted or unformatted text *)
  document   *= y.VAL(LONGINT,"docu");  (* Formatted text with graphics or other DataTypes *)
  sound      *= y.VAL(LONGINT,"soun");  (* Sound *)
  instrument *= y.VAL(LONGINT,"inst");  (* Musical instruments used for musical scores *)
  music      *= y.VAL(LONGINT,"musi");  (* Musical score *)
  picture    *= y.VAL(LONGINT,"pict");  (* Still picture *)
  animation  *= y.VAL(LONGINT,"anim");  (* Animated picture *)
  movie      *= y.VAL(LONGINT,"movi");  (* Animation with audio track *)

(*****************************************************************************)

(* A code chunk contains an embedded executable that can be loaded
 * with InternalLoadSeg. *)
  idCode *= y.VAL(LONGINT,"DTCD");

TYPE
(* DataTypes comparision hook context (Read-Only).  This is the
 * argument that is passed to a custom comparision routine. *)
  HookContext *= STRUCT
    (* Libraries that are already opened for your use *)
    sysBase      -: e.ExecBasePtr;
    dosBase      -: d.DosLibraryPtr;
    iffParseBase -: e.LibraryPtr;
    utilityBase  -: u.UtilityBasePtr;

    (* File context *)
    lock         -: d.FileLockPtr;      (* Lock on the file *)
    fib          -: d.FileInfoBlockPtr; (* Pointer to a FileInfoBlock *)
    fileHandle   -: d.FileHandlePtr;    (* Pointer to the file handle (may be NULL) *)
    iff          -: IFF.IFFHandlePtr;   (* Pointer to an IFFHandle (may be NULL) *)
    buffer       -: e.LSTRPTR;          (* Buffer *)
    bufferLength -: LONGINT;            (* Length of the buffer *)
  END;

(*****************************************************************************)

CONST
  idTool *= y.VAL(LONGINT,"DTTL");

TYPE
  Tool *= STRUCT
    which   *: INTEGER;   (* Which tool is this *)
    flags   *: SET;       (* Flags *)
    program *: e.LSTRPTR; (* Application to use *)
  END;

CONST
  tSize *= SIZE(Tool);

(* defines for tn_Which *)
  info    *= 1;
  browse  *= 2;
  edit    *= 3;
  print   *= 4;
  mail    *= 5;

(* defines for tn_Flags *)
  launchMaskSet *= y.VAL(SET,000FH);
  launchMask *= 000FH;
  shell      *= 0001H;
  workbench  *= 0002H;
  rx         *= 0003H;

(*****************************************************************************)

  idTags  *= y.VAL(LONGINT,"DTTG");

(*****************************************************************************)

TYPE
  DataType *= STRUCT
    node1        *: e.Node;            (* Reserved for system use *)
    node2        *: e.Node;            (* Reserved for system use *)
    Header       *: DataTypeHeaderPtr; (* Pointer to the DataTypeHeader *)
    toolList     *: e.List;            (* List of tool nodes *)
    functionName *: e.LSTRPTR;         (* Name of comparision routine *)
    attrList     *: u.TagListPtr;      (* Object creation tags *)
    length       *: LONGINT;           (* Length of the memory block *)
  END;

CONST
  nSize *= SIZE(DataType);

(*****************************************************************************)

TYPE
  ToolNode *= STRUCT
    node   *: e.Node;   (* Embedded node *)
    tool   *: Tool;     (* Embedded tool *)
    Length *: LONGINT;  (* Length of the memory block *)
  END;

CONST
  tnSize *= SIZE(ToolNode);

(*****************************************************************************)

  idNAME *= y.VAL(LONGINT,"NAME");

(*****************************************************************************)

(* text ID's *)
  errorUnknownDatatype      *= 2000;
  errorCouldntSave          *= 2001;
  errorCouldntOpen          *= 2002;
  errorCouldntSendMessage   *= 2003;

(* new for V40 *)
  errorCouldntOpenClipboard *= 2004;
  errorReserved             *= 2005;
  errorUnknownCompression   *= 2006;
  errorNotEnoughData        *= 2007;
  errorInvalidData          *= 2008;

(* Offset for types *)
  msgTypeOffset             *= 2100;

(*****************************************************************************)

  datatypesClass *= "datatypesclass";

(*****************************************************************************)

  aDummy         *= u.user + 1000H;

(* Generic attributes *)
  textAttr       *= aDummy + 10;
      (* (struct TextAttr * ) Pointer to the default TextAttr to use for
       * the text within the object. *)

  topVert        *= aDummy + 11;
      (* (LONG) Current top vertical unit *)

  visibleVert    *= aDummy + 12;
      (* (LONG) Number of visible vertical units *)

  totalVert      *= aDummy + 13;
      (* (LONG) Total number of vertical units *)

  vertUnit       *= aDummy + 14;
      (* (LONG) Number of pixels per vertical unit *)

  topHoriz       *= aDummy + 15;
      (* (LONG) Current top horizontal unit *)

  visibleHoriz   *= aDummy + 16;
      (* (LONG)  Number of visible horizontal units *)

  totalHoriz     *= aDummy + 17;
      (* (LONG) Total number of horizontal units *)

  horizUnit      *= aDummy + 18;
      (* (LONG) Number of pixels per horizontal unit *)

  nodeName       *= aDummy + 19;
      (* (UBYTE * ) Name of the current element within the object. *)

  title          *= aDummy + 20;
      (* (UBYTE * ) Title of the object. *)

  triggerMethods *= aDummy + 21;
      (* (struct DTMethod * ) Pointer to a NULL terminated array of
       * supported trigger methods. *)

  data           *= aDummy + 22;
      (* (APTR) Object specific data. *)

  textFont       *= aDummy + 23;
      (* (struct TextFont * ) Default font to use for text within the
       * object. *)

  methods        *= aDummy + 24;
      (* (ULONG * ) Pointer to a ~0 terminated array of supported
       * methods. *)

  printerStatus  *= aDummy + 25;
      (* (LONG) Printer error message.  Error numbers are defined in
       * <devices/printer.h> *)

  printerProc    *= aDummy + 26;
      (* PRIVATE (struct Process * ) Pointer to the print process. *)

  layoutProc     *= aDummy + 27;
      (* PRIVATE (struct Process * ) Pointer to the layout process. *)

  busy           *= aDummy + 28;
        (* Used to turn the applications' busy pointer off and on *)

  sync           *= aDummy + 29;
        (* Used to indicate that new information has been loaded into
         * an object.  This is for models that cache the DTA_TopVert-
         * like tags *)

  baseName       *= aDummy + 30;  (* The base name of the class *)
  groupID        *= aDummy + 31;  (* Group that the object must belong in *)
  errorLevel     *= aDummy + 32;  (* Error level *)
  errorNumber    *= aDummy + 33;  (* datatypes.library error number *)

  errorString    *= aDummy + 34;  (* Argument for datatypes.library error *)

  conductor      *= aDummy + 35;
      (* New for V40. (UBYTE * ) specifies the name of the
       * realtime.library conductor.  Defaults to "Main". *)

  controlPanel   *= aDummy + 36;
      (* New for V40. (BOOL) Indicate whether a control panel should be
       * embedded within the object (in the animation datatype, for
       * example).  Defaults to TRUE. *)

  immediate      *= aDummy + 37;
      (* New for V40. (BOOL) Indicate whether the object should
       * immediately begin playing.  Defaults to FALSE. *)

  repeat         *= aDummy + 38;
      (* New for V40. (BOOL) Indicate that the object should repeat
       * playing.  Defaults to FALSE. *)


(* DTObject attributes *)
  name           *= aDummy + 100;
  sourceType     *= aDummy + 101;
  handle         *= aDummy + 102;
  dataType       *= aDummy + 103;
  domain         *= aDummy + 104;

(* DON'T USE THE FOLLOWING FOUR TAGS.  USE THE CORRESPONDING TAGS IN
 * <intuition/gadgetclass.h> *)
  left           *= aDummy + 105;
  top            *= aDummy + 106;
  width          *= aDummy + 107;
  height         *= aDummy + 108;

  objName        *= aDummy + 109;
  objAuthor      *= aDummy + 110;
  objAnnotation  *= aDummy + 111;
  objCopyright   *= aDummy + 112;
  objVersion     *= aDummy + 113;
  objectID       *= aDummy + 114;
  userData       *= aDummy + 115;
  frameInfo      *= aDummy + 116;

(* DON'T USE THE FOLLOWING FOUR TAGS.  USE THE CORRESPONDING TAGS IN
 * <intuition/gadgetclass.h> *)
  relRight       *= aDummy + 117;
  relBottom      *= aDummy + 118;
  relWidth       *= aDummy + 119;
  relHeight      *= aDummy + 120;

  selectDomain   *= aDummy + 121;
  totalPVert     *= aDummy + 122;
  totalPHoriz    *= aDummy + 123;
  nominalVert    *= aDummy + 124;
  nominalHoriz   *= aDummy + 125;

(* Printing attributes *)
  destCols       *= aDummy + 400;
      (* (LONG) Destination X width *)

  destRows       *= aDummy + 401;
      (* (LONG) Destination Y height *)

  special        *= aDummy + 402;
      (* (UWORD) Option flags *)

  rastPort       *= aDummy + 403;
      (* (struct RastPort * ) RastPort to use when printing. (V40) *)

  arexxPortName  *= aDummy + 404;
      (* (LSTRPTR) Pointer to base name for ARexx port (V40) *)


(*****************************************************************************)

  stRam       *= 1;
  stFile      *= 2;
  stClipboard *= 3;
  stHotlink   *= 4;

(*****************************************************************************)

TYPE
(* Attached to the Gadget.SpecialInfo field of the gadget.  Don't access directly,
 * use the Get/Set calls instead.
 *)
  SpecialInfo *= STRUCT
    lock      *: e.SignalSemaphore; (* Locked while in DoAsyncLayout() *)
    flags     *: LONGSET;

    topVert   *: LONGINT; (* Top row (in units) *)
    visVert   *: LONGINT; (* Number of visible rows (in units) *)
    totVert   *: LONGINT; (* Total number of rows (in units) *)
    oTopVert  *: LONGINT; (* Previous top (in units) *)
    vertUnit  *: LONGINT; (* Number of pixels in vertical unit *)

    topHoriz  *: LONGINT; (* Top column (in units) *)
    visHoriz  *: LONGINT; (* Number of visible columns (in units) *)
    totHoriz  *: LONGINT; (* Total number of columns (in units) *)
    oTopHoriz *: LONGINT; (* Previous top (in units) *)
    horizUnit *: LONGINT; (* Number of pixels in horizontal unit *)
  END;

CONST
  layout        *= 0;  (* Object is in layout processing *)
  newsize       *= 1;  (* Object needs to be layed out *)
  dragging      *= 2;
  dragSelect    *= 3;
  highLight     *= 4;
  printing      *= 5;  (* Object is being printed *)
  sifLayoutProc *= 6;  (* Object is in layout process *)

(*****************************************************************************)

TYPE
  Method *= STRUCT
    label   *: e.LSTRPTR;
    command *: e.LSTRPTR;
    method  *: LONGINT;
  END;

(*****************************************************************************)

CONST
  mDummy           *= 600H;
  mFrameBox        *= 601H; (* Inquire what environment an object requires *)
  mProcLayout      *= 602H; (* Same as GM_LAYOUT except guaranteed to be on a process already *)
  mAsyncLayout     *= 603H; (* Layout that is occurring on a process *)
  mRemoveObject    *= 604H; (* When a RemoveDTObject() is called *)

  mSelect          *= 605H;
  mClearSelected   *= 606H;

  mCopy            *= 607H;
  mPrint           *= 608H;
  mAbortPrint      *= 609H;

  mNewMember       *= 610H;
  mDisposeMember   *= 611H;

  mGoto            *= 630H;
  mTrigger         *= 631H;

  mObtainDrawInfo  *= 640H;
  mDraw            *= 641H;
  mReleaseDrawInfo *= 642H;

  mWrite           *= 650H;

(* Used to ask the object about itself *)
TYPE
  Dimensions *= STRUCT (* used by the following struct *)
    width  *: LONGINT;
    height *: LONGINT;
    depth  *: LONGINT;
  END;

  FrameInfo *= STRUCT
    propertyFlags *: LONGINT; (* DisplayInfo (graphics/displayinfo.h) *)
    resolution    *: g.Point; (* DisplayInfo *)

    redBits   *: e.UBYTE;
    greenBits *: e.UBYTE;
    blueBits  *: e.UBYTE;

    dimensions *: Dimensions;

    screen    *: I.ScreenPtr;
    colorMap  *: g.ColorMapPtr;

    flags     *: LONGSET;
  END;

CONST
  scalable    *= 1;
  scrollable  *= 2;
  remappable  *= 4;

TYPE
(* DTM_REMOVEDTOBJECT, DTM_CLEARSELECTED, DTM_COPY, DTM_ABORTPRINT *)
  General *= STRUCT (msg *: I.Msg)
    gInfo *: I.GadgetInfoPtr;
  END;

(* DTM_SELECT *)
  Select *= STRUCT (msg *: I.Msg)
    gInfo  *: I.GadgetInfoPtr;
    select *: g.Rectangle;
  END;

(* DTM_FRAMEBOX *)
  FrameBox *= STRUCT (msg *: I.Msg)
    gInfo         *: I.GadgetInfoPtr;
    contentsInfo  *: FrameInfoPtr; (* Input *)
    frameInfo     *: FrameInfoPtr; (* Output *)
    sizeFrameInfo *: LONGINT;
    frameFlags    *: LONGSET;
  END;

CONST
(* FrameBox.flags *)
  framefSpecify *= 0;  (* Make do with the dimensions of FrameBox provided. *)

TYPE
(* DTM_GOTO *)
  Goto *= STRUCT (msg *: I.Msg)
    gInfo    *: I.GadgetInfoPtr;
    nodeName *: e.LSTRPTR;     (* Node to goto *)
    attrList *: u.TagListPtr;  (* Additional attributes *)
  END;

(* DTM_TRIGGER *)
  Trigger *= STRUCT (msg *: I.Msg)
    gInfo    *: I.GadgetInfoPtr;
    function *: LONGINT;
    data     *: e.APTR;
  END;

CONST
  pause      *= 1;
  play       *= 2;
  contents   *= 3;
  index      *= 4;
  retrace    *= 5;
  browsePrev *= 6;
  browseNext *= 7;

  nextField      *= 8;
  prevField      *= 9;
  activateField  *= 10;

  command        *= 11;

(* New for V40 *)
  rewind      *= 12;
  fastForward *= 13;
  stop        *= 14;
  resume      *= 15;
  locate      *= 16;

TYPE
(* DTM_PRINT *)
(* one for each Printer IO request type *)
  PrintStd *= STRUCT (msg *: I.Msg)
    gInfo    *: I.GadgetInfoPtr; (* Gadget information *)
    ios      *: e.IOStdReqPtr;   (* Printer IO request *)
    attrList *: u.TagListPtr;    (* Additional attributes *)
  END;

  PrintDRP *= STRUCT (msg *: I.Msg)
    gInfo    *: I.GadgetInfoPtr; (* Gadget information *)
    iodrp    *: prt.IODRPReqPtr; (* Printer IO request *)
    attrList *: u.TagListPtr;    (* Additional attributes *)
  END;

  PrintPrtCmd *= STRUCT (msg *: I.Msg)
    gInfo    *: I.GadgetInfoPtr;    (* Gadget information *)
    iopc     *: prt.IOPrtCmdReqPtr; (* Printer IO request *)
    attrList *: u.TagListPtr;       (* Additional attributes *)
  END;


TYPE
(* DTM_DRAW *)
  Draw *= STRUCT (msg *: I.Msg)
    rPort    *: g.RastPortPtr;
    left     *: LONGINT;
    top      *: LONGINT;
    width    *: LONGINT;
    height   *: LONGINT;
    topHoriz *: LONGINT;
    topVert  *: LONGINT;
    attrList *: u.TagListPtr;  (* Additional attributes *)
  END;

(* DTM_WRITE *)
  Write *= STRUCT (msg *: I.Msg)
    gInfo      *: I.GadgetInfoPtr;   (* Gadget information *)
    fileHandle *: d.FileHandlePtr;        (* File handle to write to *)
    mode       *: LONGINT;
    attrList   *: u.TagListPtr;  (* Additional attributes *)
  END;

CONST
  wmIff *= 0;    (* Save data as IFF data *)
  wmRaw *= 1;    (* Save data as local data format *)

(*****************************************************************************)

  pictureDTClass *= "picture.datatype";

(*****************************************************************************)

(* Picture attributes *)
  modeID        *= aDummy + 200;  (* Mode ID of the picture *)
  bitMapHeader  *= aDummy + 201;
  bitMap        *= aDummy + 202;
        (* Pointer to a class-allocated bitmap, that will end
         * up being freed by picture.class when DisposeDTObject()
         * is called *)

  colorRegisters*= aDummy + 203;
  cRegs         *= aDummy + 204;
  gRegs         *= aDummy + 205;
  colorTable    *= aDummy + 206;
  colorTable2   *= aDummy + 207;
  allocated     *= aDummy + 208;
  numColors     *= aDummy + 209;
  numAlloc      *= aDummy + 210;

  remap         *= aDummy + 211; (* Boolean : Remap picture (defaults to TRUE) *)
  screen        *= aDummy + 212; (* Screen to remap to *)

  freeSourceBitMap *= aDummy + 213; (* Boolean : Free the source bitmap after remapping *)
  grab             *= aDummy + 214; (* Pointer to a Point structure *)
  destBitMap       *= aDummy + 215; (* Pointer to the destination (remapped) bitmap *)

  classBitMap      *= aDummy + 216;
        (* Pointer to class-allocated bitmap, that will end
         * up being freed by the class after DisposeDTObject()
         * is called *)

  numSparse        *= aDummy + 217;
        (* (UWORD) Number of colors used for sparse remapping *)

  sparseTable      *= aDummy + 218;
        (* (UBYTE * ) Pointer to a table of pen numbers indicating
         * which colors should be used when remapping the image.
         * This array must contain as many entries as there
         * are colors specified with PaNumSparse *)

(*****************************************************************************)

(*  Masking techniques  *)
  hasNone             *= 0;
  hasMask             *= 1;
  hasTransparentColor *= 2;
  hasLasso            *= 3;
  hasAlpha            *= 4;

(*  Compression techniques  *)
  mpNone     *= 0;
  mpByteRun1 *= 1;
  mpByteRun2 *= 2;

TYPE
(*  Bitmap header (BMHD) structure  *)
  BitMapHeader *= STRUCT
    width       *: INTEGER; (* Width in pixels *)
    height      *: INTEGER; (* Height in pixels *)
    left        *: INTEGER; (* Left position *)
    top         *: INTEGER; (* Top position *)
    depth       *: e.UBYTE; (* Number of planes *)
    masking     *: e.UBYTE; (* Masking type *)
    compression *: e.UBYTE; (* Compression type *)
    pad         *: e.UBYTE;
    transparent *: INTEGER; (* Transparent color *)
    xAspect     *: e.UBYTE;
    yAspect     *: e.UBYTE;
    pageWidth   *: INTEGER;
    pageHeight  *: INTEGER;
  END;

(*****************************************************************************)

(*  Color register structure *)
  ColorRegister *= STRUCT
    red *, green *, blue *: e.UBYTE;
  END;

(*****************************************************************************)

CONST
(* IFF types that may be in pictures *)
  idILBM *= y.VAL(LONGINT,"ILBM");
  idBMHD *= y.VAL(LONGINT,"BMHD");
  idBODY *= y.VAL(LONGINT,"BODY");
  idCMAP *= y.VAL(LONGINT,"CMAP");
  idCRNG *= y.VAL(LONGINT,"CRNG");
  idGRAB *= y.VAL(LONGINT,"GRAB");
  idSPRT *= y.VAL(LONGINT,"SPRT");
  idDEST *= y.VAL(LONGINT,"DEST");
  idCAMG *= y.VAL(LONGINT,"CAMG");

(*****************************************************************************)

  soundDTClass *= "sound.datatype";

(*****************************************************************************)

(* Sound attributes *)
  sdtaDummy    *= aDummy + 500;
  voiceHeader  *= sdtaDummy + 1;
  sample       *= sdtaDummy + 2;
   (* (UBYTE * ) Sample data *)

  sampleLength *= sdtaDummy + 3;
   (* (ULONG) Length of the sample data in UBYTEs *)

  period       *= sdtaDummy + 4;
    (* (UWORD) Period *)

  volume       *= sdtaDummy + 5;
    (* (UWORD) Volume.        Range from 0 to 64 *)

  cycles       *= sdtaDummy + 6;

(* The following tags are new for V40 *)
  signalTask   *= sdtaDummy + 7;
    (* (struct Task * ) Task to signal when sound is complete or
      next buffer needed. *)

  signalBit    *= sdtaDummy + 8;
    (* (BYTE) Signal bit to use on completion or -1 to disable *)

  continuous   *= sdtaDummy + 9;
    (* (ULONG) Playing a continuous stream of data.  Defaults to FALSE. *)

(*****************************************************************************)

  cmpNone     *= 0;
  cmpFibDelta *= 1;

TYPE
  VoiceHeader *= STRUCT
    oneShotHiSamples  *: LONGINT;
    repeatHiSamples   *: LONGINT;
    samplesPerHiCycle *: LONGINT;
    samplesPerSec     *: INTEGER;
    octaves           *: e.UBYTE;
    compression       *: e.UBYTE;
    volume            *: LONGINT;
  END;

(*****************************************************************************)

CONST
(* IFF types *)
  id8SVX *= y.VAL(LONGINT,"8SVX");
  idVHDR *= y.VAL(LONGINT,"VHDR");
  (* idBODY *= y.VAL(LONGINT,"BODY"); *)

(*****************************************************************************)

  textDTClass *= "text.datatype";

(*****************************************************************************)

(* Text attributes *)
  buffer        *= aDummy + 300;
  bufferLen     *= aDummy + 301;
  lineList      *= aDummy + 302;
  wordSelect    *= aDummy + 303;
  wordDelim     *= aDummy + 304;
  wordWrap      *= aDummy + 305;
     (* Boolean. Should the text be word wrapped.  Defaults to false. *)

(*****************************************************************************)

TYPE
(* There is one Line structure for every line of text in our document.  *)
  Line *= STRUCT
    link    *: e.MinNode; (* to link the lines together *)
    text    *: e.LSTRPTR; (* pointer to the text for this line *)
    textLen *: LONGINT;   (* the character length of the text for this line *)
    xOffset *: INTEGER;   (* where in the line the text starts *)
    yOffset *: INTEGER;   (* line the text is on *)
    width   *: INTEGER;   (* Width of line in pixels *)
    height  *: INTEGER;   (* Height of line in pixels *)
    flags   *: SET;       (* info on the line *)
    fgPen   *: e.BYTE;    (* foreground pen *)
    bgPen   *: e.BYTE;    (* background pen *)
    style   *: LONGINT;   (* Font style *)
    data    *: e.APTR;    (* Link data... *)
  END;

(*****************************************************************************)

CONST
(* Line.flags *)
  lf       *= 0; (* Line Feed *)
  link     *= 1; (* Segment is a link *)
  object   *= 2; (* ln_Data is a pointer to an DataTypes object *)
  selected *= 3; (* Object is selected *)

(*****************************************************************************)

(* IFF types that may be text *)
  idFTXT *= y.VAL(LONGINT,"FTXT");
  idCHRS *= y.VAL(LONGINT,"CHRS");

(*****************************************************************************)

  animationDtClass  *= "animation.datatype";

(*****************************************************************************)

(* Animation attributes *)
  adtaDummy           *= aDummy + 600;
  adtaModeID          *= modeID;
  adtaKeyFrame        *= bitMap;
        (* (BitMapPtr) Key frame (first frame) bitmap *)

  adtaColorRegisters  *= colorRegisters;
  adtaCRegs           *= cRegs;
  adtaGRegs           *= gRegs;
  adtaColorTable      *= colorTable;
  adtaColorTable2     *= colorTable2;
  adtaAllocated       *= allocated;
  adtaNumColors       *= numColors;
  adtaNumAlloc        *= numAlloc;

  adtaRemap           *= remap;
        (* (BOOL) : Remap animation (defaults to TRUE) *)

  adtaScreen          *= screen;
        (* (ScreenPtr) Screen to remap to *)

  adtaNumSparse       *= numSparse;
        (* (INTEGER) Number of colors used for sparse remapping *)

  adtaSparseTable     *= sparseTable;
        (* (SHORTINT * ) Pointer to a table of pen numbers indicating
         * which colors should be used when remapping the image.
         * This array must contain as many entries as there
         * are colors specified with ADTA_NumSparse *)

  adtaWidth           *= adtaDummy + 1;
  adtaHeight          *= adtaDummy + 2;
  adtaDepth           *= adtaDummy + 3;
  adtaFrames          *= adtaDummy + 4;
        (* (LONGINT) Number of frames in the animation *)

  adtaFrame           *= adtaDummy + 5;
        (* (LONGINT) Current frame *)

  adtaFramesPerSecond *= adtaDummy + 6;
        (* (LONGINT) Frames per second *)

  adtaFrameIncrement  *= adtaDummy + 7;
        (* (LONG) Amount to change frame by when fast forwarding or
         * rewinding.  Defaults to 10. *)

(* Sound attributes *)
  adtaSample          *= sample;
  adtaSampleLength    *= sampleLength;
  adtaPeriod          *= period;
  adtaVolume          *= volume;
  adtaCycles          *= cycles;

(*****************************************************************************)

  idANIM              *= y.VAL(LONGINT,"ANIM");
  idANHD              *= y.VAL(LONGINT,"ANHD");
  idDLTA              *= y.VAL(LONGINT,"DLTA");

(*****************************************************************************)
TYPE
(*  Required ANHD structure describes an ANIM frame *)
  AnimHeader *= STRUCT;
    operation    *: SHORTINT;  (*  The compression method:
                                    0  set directly (normal ILBM BODY),
                                    1  XOR ILBM mode,
                                    2  Long Delta mode,
                                    3  Short Delta mode,
                                    4  Generalized short/long Delta mode,
                                    5  Byte Vertical Delta mode
                                    6  Stereo op 5 (third party)
                                   74  (ascii 'J') reserved for Eric Graham's
                                       compression technique (details to be
                                       released later). *)
    mask         *: SHORTSET;  (* (XOR mode only - plane mask where each
                                   bit is set =1 if there is data and =0
                                   if not.) *)

    width        *: INTEGER;   (* (XOR mode only - width and height of the *)
    height       *: INTEGER;   (* area represented by the BODY to eliminate
                                  unnecessary un-changed data) *)


    left         *: INTEGER;   (* (XOR mode only - position of rectangular *)
    top          *: INTEGER;   (* area representd by the BODY) *)


    absTime      *: LONGINT;   (* Timing for a frame relative to the time
                                  the first frame was displayed, in
                                  jiffies (1/60 sec) *)

    relTime      *: LONGINT;   (* Timing for frame relative to time
                                  previous frame was displayed - in
                                  jiffies (1/60 sec) *)

    interleave   *: SHORTINT;  (* Indicates how may frames back this data is to
                                  modify.  0 defaults to indicate two frames back
                                  (for double buffering). n indicates n frames back.
                                  The main intent here is to allow values
                                  of 1 for special applications where
                                  frame data would modify the immediately
                                  previous frame. *)

    pad0         *: SHORTINT;  (* Pad byte, not used at present. *)

    flags        *: LONGINT;   (* 32 option bits used by options=4 and 5.
                                  At present only 6 are identified, but the
                                  rest are set =0 so they can be used to
                                  implement future ideas.  These are defined
                                  for option 4 only at this point.  It is
                                  recommended that all bits be set =0 for
                                  option 5 and that any bit settings
                                  used in the future (such as for XOR mode)
                                  be compatible with the option 4
                                  bit settings.   Player code should check
                                  undefined bits in options 4 and 5 to assure
                                  they are zero.

                                  The six bits for current use are:

                                   bit #       set =0                  set =1
                                   ===============================================
                                   0           short data              long data
                                   1           set                     XOR
                                   2           separate info           one info list
                                               for each plane          for all planes
                                   3           not RLC                 RLC (run length coded)
                                   4           horizontal              vertical
                                   5           short info offsets      long info offsets
                               *)

    pad *: ARRAY 16 OF SHORTINT; (* This is a pad for future use for future
                                    compression modes. *)
  END;

(*****************************************************************************)
CONST

  adtmDummy           *= 0700H;

  adtmLoadFrame       *= 0701H;
    (* Used to load a frame of the animation *)

  adtmUnloadFrame     *= 0702H;
    (* Used to unload a frame of the animation *)

  adtmStart           *= 0703H;
    (* Used to start the animation *)

  adtmPause           *= 0704H;
    (* Used to pause the animation (don't reset the timer) *)

  adtmStop            *= 0705H;
    (* Used to stop the animation *)

  adtmLocate          *= 0706H;
    (* Used to locate a frame in the animation (as set by a slider...) *)

(*****************************************************************************)
TYPE

(* ADTM_LOADFRAME, ADTM_UNLOADFRAME *)
  ADTFrame *= STRUCT (msg *: I.Msg)
    timeStamp    *: LONGINT;       (* Timestamp of frame to load *)

    (* The following fields are filled in by the ADTM_LOADFRAME method, *)
    (* and are read-only for any other methods. *)

    frame        *: LONGINT;       (* Frame number *)
    duration     *: LONGINT;       (* Duration of frame *)

    bitMap       *: g.BitMapPtr;   (* Loaded BitMap *)
    cMap         *: g.ColorMapPtr; (* Colormap, if changed *)

    sample       *: e.APTR;        (* Sound data *)
    sampleLength *: LONGINT;
    period       *: LONGINT;

    userData     *: e.APTR;        (* Used by load frame for extra data *)
  END;


(* ADTM_START, ADTM_PAUSE, ADTM_STOP, ADTM_LOCATE *)
  ADTStart *= STRUCT (msg *: I.Msg)
    frame        *: LONGINT;       (* Frame # to start at *)
  END;

(*****************************************************************************)
CONST

  datatypesName *= "datatypes.library";

VAR
  base *: e.LibraryPtr;

(*--- functions in V40 or higher (Release 3.1) ---*)

(* Public entries *)

PROCEDURE ObtainDataTypeA     *{base,-024H}(type{0}   : LONGINT;
                                            handle{8} : e.APTR;
                                            attrs{9}  : ARRAY OF u.TagItem): DataTypePtr;
PROCEDURE ObtainDataType      *{base,-024H}(type{0}   : LONGINT;
                                            handle{8} : e.APTR;
                                            tag1{9}.. : u.Tag): DataTypePtr;
PROCEDURE ReleaseDataType     *{base,-02AH}(dt{8}     : DataTypePtr);
PROCEDURE NewDTObjectA        *{base,-030H}(name{0}   : ARRAY OF CHAR;
                                            attrs{8}  : ARRAY OF u.TagItem): I.ObjectPtr;
PROCEDURE NewDTObject         *{base,-030H}(name{0}   : ARRAY OF CHAR;
                                            tag1{8}.. : u.Tag): I.ObjectPtr;
PROCEDURE DisposeDTObject     *{base,-036H}(obj{8}    : I.ObjectPtr);
PROCEDURE SetDTAttrsA         *{base,-03CH}(obj{8}    : I.ObjectPtr;
                                            win{9}    : I.WindowPtr;
                                            req{10}   : I.RequesterPtr;
                                            attrs{11} : ARRAY OF u.TagItem): LONGINT;
PROCEDURE SetDTAttrs          *{base,-03CH}(obj{8}    : I.ObjectPtr;
                                            win{9}    : I.WindowPtr;
                                            req{10}   : I.RequesterPtr;
                                            tag1{11}..: u.Tag): LONGINT;
PROCEDURE GetDTAttrsA         *{base,-042H}(obj{8}    : I.ObjectPtr;
                                            attrs{10} : ARRAY OF u.TagItem):LONGINT;
PROCEDURE GetDTAttrs          *{base,-042H}(o{8}      : I.ObjectPtr;
                                            tag1{10}..: u.Tag): LONGINT;
PROCEDURE AddDTObject         *{base,-048H}(win{8}    : I.WindowPtr;
                                            req{9}    : I.RequesterPtr;
                                            obj{10}   : I.ObjectPtr;
                                            pos{0}    : LONGINT): LONGINT;
PROCEDURE RefreshDTObjectA    *{base,-04EH}(obj{8}    : I.ObjectPtr;
                                            win{9}    : I.WindowPtr;
                                            req{10}   : I.RequesterPtr;
                                            attrs{11} : ARRAY OF u.TagItem): LONGINT;
PROCEDURE RefreshDTObject     *{base,-04EH}(obj{8}    : I.ObjectPtr;
                                            win{9}    : I.WindowPtr;
                                            req{10}   : I.RequesterPtr;
                                            tag1{11}..: u.Tag): LONGINT;
PROCEDURE DoAsyncLayout       *{base,-054H}(obj{8}    : I.ObjectPtr;
                                            gpl{9}    : I.LayoutPtr);
PROCEDURE DoDTMethodA         *{base,-05AH}(obj{8}    : I.ObjectPtr;
                                            win{9}    : I.WindowPtr;
                                            req{10}   : I.RequesterPtr;
                                            msg{11}   : I.Msg): LONGINT;
PROCEDURE DoDTMethod          *{base,-05AH}(obj{8}    : I.ObjectPtr;
                                            win{9}    : I.WindowPtr;
                                            req{10}   : I.RequesterPtr;
                                            msg{11}   : I.Msg): LONGINT;
PROCEDURE RemoveDTObject      *{base,-060H}(win{8}    : I.WindowPtr;
                                            obj{9}    : I.ObjectPtr): LONGINT;
PROCEDURE GetDTMethods        *{base,-066H}(object{8} : I.ObjectPtr): LIntArrayPtr;
PROCEDURE GetDTTriggerMethods *{base,-06CH}(object{8} : I.ObjectPtr): MethodPtr;
PROCEDURE PrintDTObjectA      *{base,-072H}(obj{8}    : I.ObjectPtr;
                                            win{9}    : I.WindowPtr;
                                            req{10}   : I.RequesterPtr;
                                            msg{11}   : I.Msg): BOOLEAN;
PROCEDURE PrintDTObject       *{base,-072H}(obj{8}    : I.ObjectPtr;
                                            win{9}    : I.WindowPtr;
                                            req{10}   : I.RequesterPtr;
                                            data{11}..: e.ADDRESS): BOOLEAN;
(**)
PROCEDURE GetDTString         *{base,-08AH}(id{0}: LONGINT): e.LSTRPTR;

BEGIN
  base := e.OpenLibrary(datatypesName,39);
CLOSE
  IF base # NIL THEN e.CloseLibrary(base); END;

END Datatypes.
