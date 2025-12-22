 { Only V39+ }

{  Interface definitions for DataType objects.      }

{$I "Include:Utility/TagItem.i"}
{$I "Include:Intuition/Intuition.i"}
{$I "Include:Devices/Printer.i"}
{$I "Include:Devices/PrtBase.i"}

const
{***************************************************************************}

  DATATYPESCLASS        =  "datatypesclass";

{***************************************************************************}

  DTA_Dummy             =  (TAG_USER+$1000);

{ Generic attributes }
  DTA_TextAttr          =  (DTA_Dummy+10);
        { (struct TextAttr *) Pointer to the default TextAttr to use for
         * the text within the object. }

  DTA_TopVert           =  (DTA_Dummy+11);
        { (LONG) Current top vertical unit }

  DTA_VisibleVert       =  (DTA_Dummy+12);
        { (LONG) Number of visible vertical units }

  DTA_TotalVert         =  (DTA_Dummy+13);
        { (LONG) Total number of vertical units }

  DTA_VertUnit          =  (DTA_Dummy+14);
        { (LONG) Number of pixels per vertical unit }

  DTA_TopHoriz          =  (DTA_Dummy+15);
        { (LONG) Current top horizontal unit }

  DTA_VisibleHoriz      =  (DTA_Dummy+16);
        { (LONG)  Number of visible horizontal units }

  DTA_TotalHoriz        =  (DTA_Dummy+17);
        { (LONG) Total number of horizontal units }

  DTA_HorizUnit         =  (DTA_Dummy+18);
        { (LONG) Number of pixels per horizontal unit }

  DTA_NodeName          =  (DTA_Dummy+19);
        { (UBYTE *) Name of the current element within the object. }

  DTA_Title             =  (DTA_Dummy+20);
        { (UBYTE *) Title of the object. }

  DTA_TriggerMethods    =  (DTA_Dummy+21);
        { (struct DTMethod *) Pointer to a NULL terminated array of
         * supported trigger methods. }

  DTA_Data              =  (DTA_Dummy+22);
        { (APTR) Object specific data. }

  DTA_TextFont          =  (DTA_Dummy+23);
        { (struct TextFont *) Default font to use for text within the
         * object. }

  DTA_Methods           =  (DTA_Dummy+24);
        { (ULONG *) Pointer to a ~0 terminated array of supported
         * methods. }

  DTA_PrinterStatus     =  (DTA_Dummy+25);
        { (LONG) Printer error message.  Error numbers are defined in
         * <devices/printer.h> }

  DTA_PrinterProc       =  (DTA_Dummy+26);
        { PRIVATE (struct Process *) Pointer to the print process. }

  DTA_LayoutProc        =  (DTA_Dummy+27);
        { PRIVATE (struct Process *) Pointer to the layout process. }

  DTA_Busy              =  (DTA_Dummy+28);
        { Used to turn the applications' busy pointer off and on }

  DTA_Sync              =  (DTA_Dummy+29);
        { Used to indicate that new information has been loaded into
         * an object.  This is for models that cache the DTA_TopVert-
         * like tags }

  DTA_BaseName          =  (DTA_Dummy+30);
        { The base name of the class }

  DTA_GroupID           =  (DTA_Dummy+31);
        { Group that the object must belong in }

  DTA_ErrorLevel        =  (DTA_Dummy+32);
        { Error level }

  DTA_ErrorNumber       =  (DTA_Dummy+33);
        { datatypes.library error number }

  DTA_ErrorString       =  (DTA_Dummy+34);
        { Argument for datatypes.library error }

  DTA_Conductor         =  (DTA_Dummy+35);
        { New for V40. (UBYTE *) specifies the name of the
         * realtime.library conductor.  Defaults to "Main". }

  DTA_ControlPanel      =  (DTA_Dummy+36);
        { New for V40. (BOOL) Indicate whether a control panel should be
         * embedded within the object (in the animation datatype, for
         * example).  Defaults to TRUE. }

  DTA_Immediate         =  (DTA_Dummy+37);
        { New for V40. (BOOL) Indicate whether the object should
         * immediately begin playing.  Defaults to FALSE. }

  DTA_Repeat            =  (DTA_Dummy+38);
        { New for V40. (BOOL) Indicate that the object should repeat
         * playing.  Defaults to FALSE. }


{ DTObject attributes }
  DTA_Name              =  (DTA_Dummy+100);
  DTA_SourceType        =  (DTA_Dummy+101);
  DTA_Handle            =  (DTA_Dummy+102);
  DTA_DataType          =  (DTA_Dummy+103);
  DTA_Domain            =  (DTA_Dummy+104);

{ DON'T USE THE FOLLOWING FOUR TAGS.  USE THE CORRESPONDING TAGS IN
 * <intuition/gadgetclass.h> }
  DTA_Left              =  (DTA_Dummy+105);
  DTA_Top               =  (DTA_Dummy+106);
  DTA_Width             =  (DTA_Dummy+107);
  DTA_Height            =  (DTA_Dummy+108);

  DTA_ObjName           =  (DTA_Dummy+109);
  DTA_ObjAuthor         =  (DTA_Dummy+110);
  DTA_ObjAnnotation     =  (DTA_Dummy+111);
  DTA_ObjCopyright      =  (DTA_Dummy+112);
  DTA_ObjVersion        =  (DTA_Dummy+113);
  DTA_ObjectID          =  (DTA_Dummy+114);
  DTA_UserData          =  (DTA_Dummy+115);
  DTA_FrameInfo         =  (DTA_Dummy+116);

{ DON'T USE THE FOLLOWING FOUR TAGS.  USE THE CORRESPONDING TAGS IN
 * <intuition/gadgetclass.h> }
  DTA_RelRight          =  (DTA_Dummy+117);
  DTA_RelBottom         =  (DTA_Dummy+118);
  DTA_RelWidth          =  (DTA_Dummy+119);
  DTA_RelHeight         =  (DTA_Dummy+120);

  DTA_SelectDomain      =  (DTA_Dummy+121);
  DTA_TotalPVert        =  (DTA_Dummy+122);
  DTA_TotalPHoriz       =  (DTA_Dummy+123);
  DTA_NominalVert       =  (DTA_Dummy+124);
  DTA_NominalHoriz      =  (DTA_Dummy+125);

{ Printing attributes }
  DTA_DestCols          =  (DTA_Dummy+400);
        { (LONG) Destination X width }

  DTA_DestRows          =  (DTA_Dummy+401);
        { (LONG) Destination Y height }

  DTA_Special           =  (DTA_Dummy+402);
        { (UWORD) Option flags }

  DTA_RastPort          =  (DTA_Dummy+403);
        { (struct RastPort *) RastPort to use when printing. (V40) }

  DTA_ARexxPortName     =  (DTA_Dummy+404);
        { (STRPTR) Pointer to base name for ARexx port (V40) }


{***************************************************************************}

  DTST_RAM              =  1;
  DTST_FILE             =  2;
  DTST_CLIPBOARD        =  3;
  DTST_HOTLINK          =  4;

{***************************************************************************}

{ Attached to the Gadget.SpecialInfo field of the gadget.  Don't access directly,
 * use the Get/Set calls instead.
 }
Type
 DTSpecialInfo = Record
    si_Lock            : SignalSemaphore;       { Locked while in DoAsyncLayout() }
    si_Flags,

    si_TopVert,    { Top row (in units) }
    si_VisVert,    { Number of visible rows (in units) }
    si_TotVert,    { Total number of rows (in units) }
    si_OTopVert,   { Previous top (in units) }
    si_VertUnit,   { Number of pixels in vertical unit }

    si_TopHoriz,   { Top column (in units) }
    si_VisHoriz,   { Number of visible columns (in units) }
    si_TotHoriz,   { Total number of columns (in units) }
    si_OTopHoriz,  { Previous top (in units) }
    si_HorizUnit  : Integer;  { Number of pixels in horizontal unit }
 end;
 DTSpecialInfoPtr = ^DTSpecialInfo;


const
{ Object is in layout processing }
  DTSIF_LAYOUT         =   1;

{ Object needs to be layed out }
  DTSIF_NEWSIZE        =   2;

  DTSIF_DRAGGING       =   4;
  DTSIF_DRAGSELECT     =   8;

  DTSIF_HIGHLIGHT      =   16;

{ Object is being printed }
  DTSIF_PRINTING       =   32;

{ Object is in layout process }
  DTSIF_LAYOUTPROC     =   64;

{***************************************************************************}

Type
 DTMethod = Record
    dtm_Label,
    dtm_Command  : String;
    dtm_Method   : Integer;
 end;
 DTMethodPtr = ^DTMethod;

{***************************************************************************}

Const
  DTM_Dummy             =  ($600);

{ Inquire what environment an object requires }
  DTM_FRAMEBOX          =  ($601);

{ Same as GM_LAYOUT except guaranteed to be on a process already }
  DTM_PROCLAYOUT        =  ($602);

{ Layout that is occurring on a process }
  DTM_ASYNCLAYOUT       =  ($603);

{ When a RemoveDTObject() is called }
  DTM_REMOVEDTOBJECT    =  ($604);

  DTM_SELECT            =  ($605);
  DTM_CLEARSELECTED     =  ($606);

  DTM_COPY              =  ($607);
  DTM_PRINT             =  ($608);
  DTM_ABORTPRINT        =  ($609);

  DTM_NEWMEMBER         =  ($610);
  DTM_DISPOSEMEMBER     =  ($611);

  DTM_GOTO              =  ($630);
  DTM_TRIGGER           =  ($631);

  DTM_OBTAINDRAWINFO    =  ($640);
  DTM_DRAW              =  ($641);
  DTM_RELEASEDRAWINFO   =  ($642);

  DTM_WRITE             =  ($650);

{ Used to ask the object about itself }
Type
 fri_Dimensions_Struct = Record
  Width,
  Height,
  Depth  : Integer;
 end;

 FrameInfo = Record
    fri_PropertyFlags    : Integer;             { DisplayInfo (graphics/displayinfo.h) }
    fri_Resolution       : Point;               { DisplayInfo }

    fri_RedBits,
    fri_GreenBits,
    fri_BlueBits         : Byte;

    fri_Dimensions       : fri_Dimensions_Struct;

    fri_Screen           : ScreenPtr;
    fri_ColorMap         : ColorMapPtr;

    fri_Flags            : Integer;
 end;
 FrameInfoPtr = ^FrameInfo;

const
  FIF_SCALABLE    = $1;
  FIF_SCROLLABLE  = $2;
  FIF_REMAPPABLE  = $4;

{ DTM_REMOVEDTOBJECT, DTM_CLEARSELECTED, DTM_COPY, DTM_ABORTPRINT }
Type
 dtGeneral = Record
    MethodID   : Integer;
    dtg_GInfo  : GadgetInfoPtr;
 end;
 dtGeneralPtr = ^dtGeneral;

{ DTM_SELECT }
 dtSelect = Record
    MethodID  : Integer;
    dts_GInfo : GadgetInfoPtr;
    dts_Select : Rectangle;
 end;
 dtSelectPtr = ^dtSelect;

{ DTM_FRAMEBOX }
 dtFrameBox = Record
    MethodID             : Integer;
    dtf_GInfo            : GadgetInfoPtr;
    dtf_ContentsInfo,     { Input }
    dtf_FrameInfo        : FrameInfoPtr;         { Output }
    dtf_SizeFrameInfo,
    dtf_FrameFlags       : Integer;
 end;
 dtFrameBoxPtr = ^dtFrameBox;

{ DTM_GOTO }
 dtGoto = Record
    MethodID             : Integer;
    dtg_GInfo            : GadgetInfoPtr;
    dtg_NodeName         : String;          { Node to goto }
    dtg_AttrList         : Address;         { Additional attributes }
 end;
 dtGotoPtr = ^dtGoto;

{ DTM_TRIGGER }
 dtTrigger = Record
    MethodID             : Integer;
    dtt_GInfo            : GadgetInfoPtr;
    dtt_Function         : Integer;
    dtt_Data             : Address;
 end;
 dtTriggerPtr = ^dtTrigger;

const
  STM_PAUSE             =  1 ;
  STM_PLAY              =  2 ;
  STM_CONTENTS          =  3 ;
  STM_INDEX             =  4 ;
  STM_RETRACE           =  5 ;
  STM_BROWSE_PREV       =  6 ;
  STM_BROWSE_NEXT       =  7 ;

  STM_NEXT_FIELD        =  8 ;
  STM_PREV_FIELD        =  9 ;
  STM_ACTIVATE_FIELD    =  10;

  STM_COMMAND           =  11;

{ New for V40 }
  STM_REWIND            =  12;
  STM_FASTFORWARD       =  13;
  STM_STOP              =  14;
  STM_RESUME            =  15;
  STM_LOCATE            =  16;

Type
{ Printer IO request }
 printerIO = Record
    ios    : IOStdReq;
    iodrp  : IODRPReq;
    iopc   : IOPrtCmdReq;
 end;
 printerIOPtr = ^printerIO;

{ DTM_PRINT }
 dtPrint = Record
    MethodID             : Integer;
    dtp_GInfo            : GadgetInfoPtr;       { Gadget information }
    dtp_PIO              : printerIOPtr;        { Printer IO request }
    dtp_AttrList         : Address;             { Additional attributes }
 end;
 dtPrintPtr = ^dtPrint;

{ DTM_DRAW }
 dtDraw = Record
    MethodID             : Integer;
    dtd_RPort            : RastPortPtr;
    dtd_Left,
    dtd_Top,
    dtd_Width,
    dtd_Height,
    dtd_TopHoriz,
    dtd_TopVert          : Integer;
    dtd_AttrList         : Address;          { Additional attributes }
 end;
 dtDrawPtr = ^dtDraw;

{ DTM_WRITE }
 dtWrite = Record
    MethodID             : Integer;
    dtw_GInfo            : GadgetInfoPtr;       { Gadget information }
    dtw_FileHandle       : Address;             { File handle to write to }
    dtw_Mode             : Integer;
    dtw_AttrList         : Address;             { Additional attributes }
 end;
 dtWritePtr = ^dtWrite;

const
{ Save data as IFF data }
  DTWM_IFF       = 0;

{ Save data as local data format }
  DTWM_RAW       = 1;

