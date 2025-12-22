include "inc/utility/tagitem.inc";
include "inc/datatypes/datatypes.inc";
include "inc/intuition/intuition.inc";
include "inc/devices/printer.inc";
include "inc/devices/prtbase.inc";

def DATATYPESCLASS = "datatypesclass";

def DTA_Dummy = (TAG_USER+$1000);

def DTA_TextAttr = (DTA_Dummy+10);
def DTA_TopVert = (DTA_Dummy+11);
def DTA_VisibleVert = (DTA_Dummy+12);
def DTA_TotalVert = (DTA_Dummy+13);
def DTA_VertUnit = (DTA_Dummy+14);
def DTA_TopHoriz = (DTA_Dummy+15);
def DTA_VisibleHoriz = (DTA_Dummy+16);
def DTA_TotalHoriz = (DTA_Dummy+17);
def DTA_HorizUnit = (DTA_Dummy+18);
def DTA_NodeName = (DTA_Dummy+19);
def DTA_Title = (DTA_Dummy+20);
def DTA_TriggerMethods = (DTA_Dummy+21);
def DTA_Data = (DTA_Dummy+22);
def DTA_TextFont = (DTA_Dummy+23);
def DTA_Methods = (DTA_Dummy+24);
def DTA_PrinterStatus = (DTA_Dummy+25);
def DTA_PrinterProc = (DTA_Dummy+26);
def DTA_LayoutProc = (DTA_Dummy+27);
def DTA_Busy = (DTA_Dummy+28);
def DTA_Sync = (DTA_Dummy+29);
def DTA_BaseName = (DTA_Dummy+30);
def DTA_GroupID = (DTA_Dummy+31);
def DTA_ErrorLevel = (DTA_Dummy+32);
def DTA_ErrorNumber = (DTA_Dummy+33);
def DTA_ErrorString = (DTA_Dummy+34);
def DTA_Conductor = (DTA_Dummy+35);
def DTA_ControlPanel = (DTA_Dummy+36);
def DTA_Immediate = (DTA_Dummy+37);
def DTA_Repeat = (DTA_Dummy+38);

def DTA_Name = (DTA_Dummy+100);
def DTA_SourceType = (DTA_Dummy+101);
def DTA_Handle = (DTA_Dummy+102);
def DTA_DataType = (DTA_Dummy+103);
def DTA_Domain = (DTA_Dummy+104);

def DTA_Left = (DTA_Dummy+105);
def DTA_Top = (DTA_Dummy+106);
def DTA_Width = (DTA_Dummy+107);
def DTA_Height = (DTA_Dummy+108);

def DTA_ObjName = (DTA_Dummy+109);
def DTA_ObjAuthor = (DTA_Dummy+110);
def DTA_ObjAnnotation = (DTA_Dummy+111);
def DTA_ObjCopyright = (DTA_Dummy+112);
def DTA_ObjVersion = (DTA_Dummy+113);
def DTA_ObjectID = (DTA_Dummy+114);
def DTA_UserData = (DTA_Dummy+115);
def DTA_FrameInfo = (DTA_Dummy+116);

def DTA_RelRight = (DTA_Dummy+117);
def DTA_RelBottom = (DTA_Dummy+118);
def DTA_RelWidth = (DTA_Dummy+119);
def DTA_RelHeight = (DTA_Dummy+120);

def DTA_SelectDomain = (DTA_Dummy+121);
def DTA_TotalPVert = (DTA_Dummy+122);
def DTA_TotalPHoriz = (DTA_Dummy+123);
def DTA_NominalVert = (DTA_Dummy+124);
def DTA_NominalHoriz = (DTA_Dummy+125);

def DTA_DestCols = (DTA_Dummy+400);
def DTA_DestRows = (DTA_Dummy+401);
def DTA_Special = (DTA_Dummy+402);
def DTA_RastPort = (DTA_Dummy+403);
def DTA_ARexxPortName = (DTA_Dummy+404);

def DTST_RAM = 1;
def DTST_FILE = 2;
def DTST_CLIPBOARD = 3;
def DTST_HOTLINK = 4;

struct DTSpecialInfo is
  si_Lock:SignalSemaphore;
  si_Flags:ulong;
  si_TopVert:long;
  si_VisVert:long;
  si_TotVert:long;
  si_OTopVert:long;
  si_VertUnit:long;
  si_TopHoriz:long;
  si_VisHoriz:long;
  si_TotHoriz:long;
  si_OTopHoriz:long;
  si_HorizUnit:long;
;

def DTSIF_LAYOUT = (1<<0);
def DTSIF_NEWSIZE = (1<<1);
def DTSIF_DRAGGING = (1<<2);
def DTSIF_DRAGSELECT = (1<<3);
def DTSIF_HIGHLIGHT = (1<<4);
def DTSIF_PRINTING = (1<<5);
def DTSIF_LAYOUTPROC = (1<<6);

struct DTMethod is
  dtm_Label:ulong;
  dtm_Command:ulong;
  dtm_Method:ulong;
;

def DTM_Dummy = ($600);

def DTM_FRAMEBOX = ($601);
def DTM_PROCLAYOUT = ($602);
def DTM_ASYNCLAYOUT = ($603);
def DTM_REMOVEDTOBJECT = ($604);
def DTM_SELECT = ($605);
def DTM_CLEARSELECTED = ($606);
def DTM_COPY = ($607);
def DTM_PRINT = ($608);
def DTM_ABORTPRINT = ($609);
def DTM_NEWMEMBER = ($610);
def DTM_DISPOSEMEMBER = ($611);
def DTM_GOTO = ($630);
def DTM_TRIGGER = ($631);
def DTM_OBTAINDRAWINFO = ($640);
def DTM_DRAW = ($641);
def DTM_RELEASEDRAWINFO = ($642);
def DTM_WRITE = ($650);

struct FrameInfo is
  fri_PropertyFlags:ulong;
  fri_Resolution:Point;
  fri_RedBits:ubyte;
  fri_GreenBits:ubyte;
  fri_BlueBits:ubyte;

  fri_Dimensions:struct is
    Width:ulong;
    Height:ulong;
    Depth:ulong;
  ;
  fri_Screen:ulong;
  fri_ColorMap:ulong;
  fri_Flags:ulong;
;

def FIF_SCALABLE = $1;
def FIF_SCROLLABLE = $2;
def FIF_REMAPPABLE = $4;

struct dtGeneral is
  MethodID:ulong;
  dtg_GInfo:ulong;
;

struct dtSelect is
  MethodID:ulong;
  dts_GInfo:ulong;
  dts_Select:Rectangle;
;

struct dtFrameBox is
  MethodID:ulong;
  dtf_GInfo:ulong;
  dtf_ContentsInfo:ulong;
  dtf_FrameInfo:ulong;
  dtf_SizeFrameInfo:ulong;
  dtf_FrameFlags:ulong;
;

def FRAMEF_SPECIFY = (1<<0);

struct dtGoto is
  MethodID:ulong;
  dtg_GInfo:ulong;
  dtg_NodeName:ulong;
  dtg_AttrList:ulong;
;

struct dtTrigger is
  MethodID:ulong;
  dtt_GInfo:ulong;
  dtt_Function:ulong;
  dtt_Data:ulong;
;

def STM_PAUSE = 1;
def STM_PLAY = 2;
def STM_CONTENTS = 3;
def STM_INDEX = 4;
def STM_RETRACE = 5;
def STM_BROWSE_PREV = 6;
def STM_BROWSE_NEXT = 7;

def STM_NEXT_FIELD = 8;
def STM_PREV_FIELD = 9;
def STM_ACTIVATE_FIELD = 10;

def STM_COMMAND = 11;

def STM_REWIND = 12;
def STM_FASTFORWARD = 13;
def STM_STOP = 14;
def STM_RESUME = 15;
def STM_LOCATE = 16;

union printerIO is
  ios:IOStdReq;
  iodrp:IODRPReq;
  iopc:IOPrtCmdReq;
;

struct dtPrint is
  MethodID:ulong;
  dtp_GInfo:ulong;
  dtp_PIO:ulong;
  dtp_AttrList:ulong;
;

struct dtDraw is
  MethodID:ulong;
  dtd_RPort:ulong;
  dtd_Left:long;
  dtd_Top:long;
  dtd_Width:long;
  dtd_Height:long;
  dtd_TopHoriz:long;
  dtd_TopVert:long;
  dtd_AttrList:ulong;
;

struct dtWrite is
  MethodID:ulong;
  dtw_GInfo:ulong;
  dtw_FileHandle:long;
  dtw_Mode:ulong;
  dtw_AttrList:ulong;
;

def DTWM_IFF = 0;
def DTWM_RAW = 1;

