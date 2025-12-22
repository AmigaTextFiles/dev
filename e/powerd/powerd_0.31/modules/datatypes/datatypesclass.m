MODULE 'intuition/screens'

#define DATATYPESCLASS 'datatypesclass'

CONST DTA_Dummy=$80001000,
      DTA_TextAttr=$8000100a,
      DTA_TopVert=$8000100b,
      DTA_VisibleVert=$8000100c,
      DTA_TotalVert=$8000100d,
      DTA_VertUnit=$8000100e,
      DTA_TopHoriz=$8000100f,
      DTA_VisibleHoriz=$80001010,
      DTA_TotalHoriz=$80001011,
      DTA_HorizUnit=$80001012,
      DTA_NodeName=$80001013,
      DTA_Title=$80001014,
      DTA_TriggerMethods=$80001015,
      DTA_Data=$80001016,
      DTA_TextFont=$80001017,
      DTA_Methods=$80001018,
      DTA_PrinterStatus=$80001019,
      DTA_PrinterProc=$8000101a,
      DTA_LayoutProc=$8000101b,
      DTA_Busy=$8000101c,
      DTA_Sync=$8000101d,
      DTA_BaseName=$8000101e,
      DTA_GroupID=$8000101f,
      DTA_ErrorLevel=$80001020,
      DTA_ErrorNumber=$80001021,
      DTA_ErrorString=$80001022,
      DTA_Conductor=$80001023,
      DTA_ControlPanel=$80001024,
      DTA_Immediate=$80001025,
      DTA_Repeat=$80001026,
      DTA_SourceAddress=$80001027, /* V44 tags */
      DTA_SourceSize=$80001028,
      DTA_Reserved=$80001029,
      DTA_Name=$80001064,
      DTA_SourceType=$80001065,
      DTA_Handle=$80001066,
      DTA_DataType=$80001067,
      DTA_Domain=$80001068,
      DTA_Left=$80001069,
      DTA_Top=$8000106a,
      DTA_Width=$8000106b,
      DTA_Height=$8000106c,
      DTA_ObjName=$8000106d,
      DTA_ObjAuthor=$8000106e,
      DTA_ObjAnnotation=$8000106f,
      DTA_ObjCopyright=$80001070,
      DTA_ObjVersion=$80001071,
      DTA_ObjectID=$80001072,
      DTA_UserData=$80001073,
      DTA_FrameInfo=$80001074,
      DTA_RelRight=$80001075,
      DTA_RelBottom=$80001076,
      DTA_RelWidth=$80001077,
      DTA_RelHeight=$80001078,
      DTA_SelectDomain=$80001079,
      DTA_TotalPVert=$8000107a,
      DTA_TotalPHoriz=$8000107b,
      DTA_NominalVert=$8000107c,
      DTA_NominalHoriz=$8000107d,
      DTA_DestCols=$80001190,
      DTA_DestRows=$80001191,
      DTA_Special=$80001192,  -> data for this tag is unsigned INT
      DTA_RastPort=$80001193,
      DTA_ARexxPortName=$80001194,
      DTST_RAM=1,
      DTST_FILE=2,
      DTST_CLIPBOARD=3,
      DTST_HOTLINK=4,
      DTST_MEMORY=5 /* New for V44 */

OBJECT DTSpecialInfo
  Lock:SS,
  Flags:ULONG,
  TopVert:LONG,
  VisVert:LONG,
  TotVert:LONG,
  OTopVert:LONG,
  VertUnit:LONG,
  TopHoriz:LONG,
  VisHoriz:LONG,
  TotHoriz:LONG,
  OTopHoriz:LONG,
  HorizUnit:LONG

CONST DTSIF_LAYOUT=1,
    DTSIF_NEWSIZE=2,
    DTSIF_DRAGGING=4,
    DTSIF_DRAGSELECT=8,
    DTSIF_HIGHLIGHT=16,
    DTSIF_PRINTING=$20,
    DTSIF_LAYOUTPROC=$40

OBJECT DTMethod
  Label:PTR TO UBYTE,
  Command:PTR TO UBYTE,
  Method:ULONG

CONST DTM_Dummy=$600,
    DTM_FRAMEBOX=$601,
    DTM_PROCLAYOUT=$602,
    DTM_ASYNCLAYOUT=$603,
    DTM_REMOVEDTOBJECT=$604,
    DTM_SELECT=$605,
    DTM_CLEARSELECTED=$606,
    DTM_COPY=$607,
    DTM_PRINT=$608,
    DTM_ABORTPRINT=$609,
    DTM_NEWMEMBER=$610,
    DTM_DISPOSEMEMBER=$611,
    DTM_GOTO=$630,
    DTM_TRIGGER=$631,
    DTM_OBTAINDRAWINFO=$640,
    DTM_DRAW=$641,
    DTM_RELEASEDRAWINFO=$642,
    DTM_WRITE=$650

OBJECT FrameInfo
  PropertyFlags:ULONG,
  Resolution:tPoint,
  RedBits:UBYTE,
  GreenBits:UBYTE,
  BlueBits:UBYTE,      // powerd automaticaly inserts pad byte
  Width:ULONG,
  Height:ULONG,
  Depth:ULONG,
  Screen:PTR TO Screen,
  Colormap:PTR TO ColorMap,
  Flags:ULONG

CONST FIF_SCALABLE=1,
    FIF_SCROLLABLE=2,
    FIF_REMAPPABLE=4

OBJECT dtGeneral
  MethodID:ULONG,
  GInfo:PTR TO GadgetInfo

OBJECT dtSelect
  MethodID:ULONG,
  GInfo:PTR TO GadgetInfo,
  Select:Rectangle

OBJECT dtFrameBox
  MethodID:ULONG,
  GInfo:PTR TO GadgetInfo,
  ContentsInfo:PTR TO FrameInfo,
  FrameInfo:PTR TO FrameInfo,
  SizeFrameInfo:ULONG,
  FrameFlags:ULONG

CONST FRAMEF_SPECIFY=1

OBJECT dtGoto
  MethodID:ULONG,
  GInfo:PTR TO GadgetInfo,
  NodeName:PTR TO UBYTE,
  AttrList:PTR TO TagItem

OBJECT dtTrigger
  MethodID:ULONG,
  GInfo:PTR TO GadgetInfo,
  Function:ULONG,
  Data:APTR

CONST STM_PAUSE=1,
    STM_PLAY=2,
    STM_CONTENTS=3,
    STM_INDEX=4,
    STM_RETRACE=5,
    STM_BROWSE_PREV=6,
    STM_BROWSE_NEXT=7,
    STM_NEXT_FIELD=8,
    STM_PREV_FIELD=9,
    STM_ACTIVATE_FIELD=10,
    STM_COMMAND=11,
    STM_REWIND=12,
    STM_FASTFORWARD=13,
    STM_STOP=14,
    STM_RESUME=15,
    STM_LOCATE=16

-> Um, this object was missing
OBJECT dtPrint
  MethodID:ULONG,
  GInfo:PTR TO GadgetInfo,
-> a) next is unioned with "iodrp:PTR TO iodrpreq"
-> b) next is unioned with "iopc:PTR TO ioprtcmdreq"
  IOS|IOPC|IODRP:PTR TO IOStd,
  AttrList:PTR TO TagItem

OBJECT dtDraw
  MethodID:ULONG,
  RPort:PTR TO RastPort,
  Left:LONG,
  Top:LONG,
  Width:LONG,
  Height:LONG,
  TopHoriz:LONG,
  TopVert:LONG,
  AttrList:PTR TO TagItem

OBJECT dtWrite
  MethodID:ULONG,
  GInfo:PTR TO GadgetInfo,
  FileHandle:BPTR,
  Mode:ULONG,
  AttrList:PTR TO TagItem

CONST DTWM_IFF=0,
    DTWM_RAW=1
