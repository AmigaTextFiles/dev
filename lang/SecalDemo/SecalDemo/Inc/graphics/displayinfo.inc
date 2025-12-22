include "inc/exec/types.inc";
include "inc/graphics/gfx.inc";
include "inc/graphics/monitor.inc";
include "inc/graphics/modeid.inc";
include "inc/utility/tagitem.inc";

def DTAG_DISP = $80000000;
def DTAG_DIMS = $80001000;
def DTAG_MNTR = $80002000;
def DTAG_NAME = $80003000;
def DTAG_VEC = $80004000;

struct QueryHeader is
  StructID:ulong;
  DisplayID:ulong;
  SkipID:ulong;
  Length:ulong;
;

struct DisplayInfo is
  Header:QueryHeader;
  NotAvailable:uword;
  PropertyFlags:ulong;
  Resolution:Point;
  PixelSpeed:uword;
  NumStdSprites:uword;
  PaletteRange:uword;
  SpriteResolution:Point;
  pad[4]:ubyte;
  RedBits:ubyte;
  GreenBits:ubyte;
  BlueBits:ubyte;
  pad2[5]:ubyte;
  reserved[2]:ulong;
;

def DI_AVAIL_NOCHIPS = $0001;
def DI_AVAIL_NOMONITOR = $0002;
def DI_AVAIL_NOTWITHGENLOCK = $0004;

def DIPF_IS_LACE = $00000001;
def DIPF_IS_DUALPF = $00000002;
def DIPF_IS_PF2PRI = $00000004;
def DIPF_IS_HAM = $00000008;

def DIPF_IS_ECS = $00000010;

def DIPF_IS_AA = $00010000;

def DIPF_IS_PAL = $00000020;
def DIPF_IS_SPRITES = $00000040;
def DIPF_IS_GENLOCK = $00000080;

def DIPF_IS_WB = $00000100;
def DIPF_IS_DRAGGABLE = $00000200;
def DIPF_IS_PANELLED = $00000400;
def DIPF_IS_BEAMSYNC = $00000800;

def DIPF_IS_EXTRAHALFBRITE = $00001000;

def DIPF_IS_SPRITES_ATT = $00002000;
def DIPF_IS_SPRITES_CHNG_RES = $00004000;
def DIPF_IS_SPRITES_BORDER = $00008000;
def DIPF_IS_SCANDBL = $00020000;
def DIPF_IS_SPRITES_CHNG_BASE = $00040000;

def DIPF_IS_SPRITES_CHNG_PRI = $00080000;

def DIPF_IS_DBUFFER = $00100000;
def DIPF_IS_PROGBEAM = $00200000;
def DIPF_IS_FOREIGN = $80000000;

struct DimensionInfo is
  Header:QueryHeader;
  MaxDepth:uword;
  MinRasterWidth:uword;
  MinRasterHeight:uword;
  MaxRasterWidth:uword;
  MaxRasterHeight:uword;
  Nominal:Rectangle;
  MaxOScan:Rectangle;
  VideoOScan:Rectangle;
  TxtOScan:Rectangle;
  StdOScan:Rectangle;
  pad[14]:ubyte;
  reserved[2]:ulong;
;

struct MonitorInfo is
  Header:QueryHeader;
  Mspc:ulong;
  ViewPosition:Point;
  ViewResolution:Point;
  ViewPositionRange:Rectangle;
  TotalRows:uword;
  TotalColorClocks:uword;
  MinRow:uword;
  Compatibility:word;
  pad[32]:ubyte;
  MouseTicks:Point;
  DefaultViewPosition:Point;
  PreferredModeID:ulong;
  reserved[2]:ulong;
;

def MCOMPAT_MIXED = 0;
def MCOMPAT_SELF = 1;
def MCOMPAT_NOBODY = -1;

def DISPLAYNAMELEN = 32;

struct NameInfo is
  Header:QueryHeader;
  Name[32]:ubyte;
  reserved[2]:ulong;
;

struct VecInfo is
  Header:QueryHeader;
  Vec:ulong;
  Data:ulong;
  Type:uword;
  pad[3]:uword;
  reserved[2]:ulong;
;

