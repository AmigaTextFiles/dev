include "inc/utility/tagitem.inc";
include "inc/datatypes/datatypesclass.inc";
include "inc/libraries/iffparse.inc";

def PICTUREDTCLASS = "picture.datatype";

def PDTA_ModeID = (DTA_Dummy+200);
def PDTA_BitMapHeader = (DTA_Dummy+201);
def PDTA_BitMap = (DTA_Dummy+202);
def PDTA_ColorRegisters = (DTA_Dummy+203);
def PDTA_CRegs = (DTA_Dummy+204);
def PDTA_GRegs = (DTA_Dummy+205);
def PDTA_ColorTable = (DTA_Dummy+206);
def PDTA_ColorTable2 = (DTA_Dummy+207);
def PDTA_Allocated = (DTA_Dummy+208);
def PDTA_NumColors = (DTA_Dummy+209);
def PDTA_NumAlloc = (DTA_Dummy+210);
def PDTA_Remap = (DTA_Dummy+211);
def PDTA_Screen = (DTA_Dummy+212);
def PDTA_FreeSourceBitMap = (DTA_Dummy+213);
def PDTA_Grab = (DTA_Dummy+214);
def PDTA_DestBitMap = (DTA_Dummy+215);
def PDTA_ClassBitMap = (DTA_Dummy+216);
def PDTA_NumSparse = (DTA_Dummy+217);
def PDTA_SparseTable = (DTA_Dummy+218);

def mskNone = 0;
def mskHasMask = 1;
def mskHasTransparentColor = 2;
def mskLasso = 3;
def mskHasAlpha = 4;

def cmpNone = 0;
def cmpByteRun1 = 1;
def cmpByteRun2 = 2;

struct BitMapHeader is
  bmh_Width:uword;
  bmh_Height:uword;
  bmh_Left:word;
  bmh_Top:word;
  bmh_Depth:ubyte;
  bmh_Masking:ubyte;
  bmh_Compression:ubyte;
  bmh_Pad:ubyte;
  bmh_Transparent:uword;
  bmh_XAspect:ubyte;
  bmh_YAspect:ubyte;
  bmh_PageWidth:word;
  bmh_PageHeight:word;
;

struct ColorRegister is
  red,green,blue:ubyte;
;

