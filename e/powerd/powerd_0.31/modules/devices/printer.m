MODULE 'exec/devices','intuition/intuition','utility/tagitem','prefs/printergfx','prefs/printertxt'
#define PRD_RAWWRITE    (CMD_NONSTD+0)
#define PRD_PRTCOMMAND    (CMD_NONSTD+1)
#define PRD_DUMPRPORT     (CMD_NONSTD+2)
#define PRD_QUERY     (CMD_NONSTD+3)
#define PRD_RESETPREFS    (CMD_NONSTD+4)
#define PRD_LOADPREFS     (CMD_NONSTD+5)
#define PRD_USEPREFS    (CMD_NONSTD+6)
#define PRD_SAVEPREFS     (CMD_NONSTD+7)
#define PRD_READPREFS     (CMD_NONSTD+8)
#define PRD_WRITEPREFS    (CMD_NONSTD+9)
#define PRD_EDITPREFS     (CMD_NONSTD+10)
#define PRD_SETERRHOOK    (CMD_NONSTD+11)
#define PRD_DUMPRPORTTAGS   (CMD_NONSTD+12)
#define aRIS  0
#define aRIN  1
#define aIND  2
#define aNEL  3
#define aRI   4
#define aSGR0   5
#define aSGR3   6
#define aSGR23  7
#define aSGR4   8
#define aSGR24  9
#define aSGR1   10
#define aSGR22  11
#define aSFC  12
#define aSBC  13
#define aSHORP0   14
#define aSHORP2   15
#define aSHORP1   16
#define aSHORP4   17
#define aSHORP3   18
#define aSHORP6   19
#define aSHORP5   20
#define aDEN6   21
#define aDEN5   22
#define aDEN4   23
#define aDEN3   24
#define aDEN2   25
#define aDEN1   26
#define aSUS2   27
#define aSUS1   28
#define aSUS4   29
#define aSUS3   30
#define aSUS0   31
#define aPLU  32
#define aPLD  33
#define aFNT0   34
#define aFNT1   35
#define aFNT2   36
#define aFNT3   37
#define aFNT4   38
#define aFNT5   39
#define aFNT6   40
#define aFNT7   41
#define aFNT8   42
#define aFNT9   43
#define aFNT10  44
#define aPROP2  45
#define aPROP1  46
#define aPROP0  47
#define aTSS  48
#define aJFY5   49
#define aJFY7   50
#define aJFY6   51
#define aJFY0   52
#define aJFY3   53
#define aJFY1   54
#define aVERP0  55
#define aVERP1  56
#define aSLPP   57
#define aPERF   58
#define aPERF0  59
#define aLMS  60
#define aRMS  61
#define aTMS  62
#define aBMS  63
#define aSTBM   64
#define aSLRM   65
#define aCAM  66
#define aHTS  67
#define aVTS  68
#define aTBC0   69
#define aTBC3   70
#define aTBC1   71
#define aTBC4   72
#define aTBCALL   73
#define aTBSALL   74
#define aEXTEND   75
#define aRAW  76
OBJECT IOPrtCmdReq
  Message:Message,
  Device:PTR TO Device,
  Unit:PTR TO Unit,
  Command:UWORD,
  Flags:UBYTE,
  Error:BYTE,
  PrtCommand:UWORD,
  Parm0:UBYTE,
  Parm1:UBYTE,
  Parm2:UBYTE,
  Parm3:UBYTE

OBJECT IODRPReq
  Message:Message,
  Device:PTR TO Device,
  Unit:PTR TO Unit,
  Command:UWORD,
  Flags:UBYTE,
  Error:BYTE,
  RastPort:PTR TO RastPort,
  ColorMap:PTR TO ColorMap,
  Modes:ULONG,
  SrcX:UWORD,
  SrcY:UWORD,
  SrcWidth:UWORD,
  SrcHeight:UWORD,
  DestCols:LONG,
  DestRows:LONG,
  Special:UWORD

OBJECT IODRPTagsReq
  Message:Message,
  Device:PTR TO Device,
  Unit:PTR TO Unit,
  Command:UWORD,
  Flags:UBYTE,
  Error:BYTE,
  RastPort:PTR TO RastPort,
  ColorMap:PTR TO ColorMap,
  Modes:ULONG,
  SrcX:UWORD,
  SrcY:UWORD,
  SrcWidth:UWORD,
  SrcHeight:UWORD,
  DestCols:LONG,
  DestRows:LONG,
  Special:UWORD,
  TagList:PTR TO TagItem

#define SPECIAL_MILCOLS     $0001 
#define SPECIAL_MILROWS     $0002 
#define SPECIAL_FULLCOLS  $0004 
#define SPECIAL_FULLROWS  $0008 
#define SPECIAL_FRACCOLS  $0010 
#define SPECIAL_FRACROWS  $0020 
#define SPECIAL_CENTER    $0040 
#define SPECIAL_ASPECT    $0080 
#define SPECIAL_DENSITY1  $0100 
#define SPECIAL_DENSITY2  $0200 
#define SPECIAL_DENSITY3  $0300 
#define SPECIAL_DENSITY4  $0400 
#define SPECIAL_DENSITY5  $0500 
#define SPECIAL_DENSITY6  $0600 
#define SPECIAL_DENSITY7  $0700 
#define SPECIAL_NOFORMFEED  $0800 
#define SPECIAL_TRUSTME     $1000 
#define SPECIAL_NOPRINT     $2000 
#define PDERR_NOERR     0
#define PDERR_CANCEL    1
#define PDERR_NOTGRAPHICS   2
#define PDERR_INVERTHAM     3
#define PDERR_BADDIMENSION  4
#define PDERR_DIMENSIONOVFLOW   5
#define PDERR_INTERNALMEMORY  6
#define PDERR_BUFFERMEMORY  7
#define PDERR_TOOKCONTROL   8
#define PDERR_BADPREFERENCES  9
#define PDERR_LASTSTANDARD  31
#define PDERR_FIRSTCUSTOM   32
#define PDERR_LASTCUSTOM  126
#define SPECIAL_DENSITYMASK   $0700 
#define SPECIAL_DIMENSIONSMASK  \
 (SPECIAL_MILCOLS|SPECIAL_MILROWS|SPECIAL_FULLCOLS|SPECIAL_FULLROWS\
 |SPECIAL_FRACCOLS|SPECIAL_FRACROWS|SPECIAL_ASPECT)
#define DRPA_Dummy  (TAG_USER + $60000)
#define DRPA_ICCProfile     (DRPA_Dummy+1)
#define DRPA_ICCName    (DRPA_Dummy+2)
#define DRPA_NoColCorrect   (DRPA_Dummy+3)
#define DRPA_SourceHook    (DRPA_Dummy+4)
OBJECT DRPSourceMsg
  x:LONG,
  y:LONG,
  width:LONG,
  height:LONG,
  buf:PTR TO ULONG

#define DRPA_AspectX       (DRPA_Dummy+5)
#define DRPA_AspectY       (DRPA_Dummy+6)
#define PPRA_Dummy  (TAG_USER + $70000)
OBJECT IOPrtPrefsReq
  Message:Message,
  Device:PTR TO Device,
  Unit:PTR TO Unit,
  Command:UWORD,
  Flags:UBYTE,
  Error:BYTE,
  TagList:PTR TO TagItem

#define PPRA_Window   (PPRA_Dummy+1)
#define PPRA_Screen   (PPRA_Dummy+2)
#define PPRA_PubScreen  (PPRA_Dummy+3)
#define PDHOOK_NONE   ((struct Hook *) NULL)
#define PDHOOK_STD  ((struct Hook *) 1)
OBJECT IOPrtErrReq
  Message:Message,
  Device:PTR TO Device,
  Unit:PTR TO Unit,
  Command:UWORD,
  Flags:UBYTE,
  Error:BYTE,
  Hook:PTR TO Hook

OBJECT PrtErrMsg
  Version:ULONG,
  ErrorLevel:ULONG,
  Window:PTR TO Window,
  ES:PTR TO EasyStruct,
  IDCMP:PTR TO ULONG,
  ArgList:PTR

#define PDHOOK_VERSION  1
OBJECT IOPrefsReq
  Message:Message,
  Device:PTR TO Device,
  Unit:PTR TO Unit,
  Command:UWORD,
  Flags:UBYTE,
  Error:BYTE,
  TxtPrefs:PTR TO PrinterTxtPrefs,
  UnitPrefs:PTR TO PrinterUnitPrefs,
  DevUnitPrefs:PTR TO PrinterDeviceUnitPrefs,
  GfxPrefs:PTR TO PrinterGfxPrefs
