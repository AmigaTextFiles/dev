include "inc/exec/nodes.inc";
include "inc/exec/lists.inc";
include "inc/graphics/text.inc";

def MAXFONTPATH = 256;

struct FontContents is
  fc_FileName[256]:byte;
  fc_YSize:uword;
  fc_Style:ubyte;
  fc_Flags:ubyte;
;

struct TFontContents is
  tfc_FileName[256-2]:byte;
  tfc_TagCount:uword;
  tfc_YSize:uword;
  tfc_Style:ubyte;
  tfc_Flags:ubyte;
;

def FCH_ID = $0f00;
def TFCH_ID = $0f02;
def OFCH_ID = $0f03;

struct FontContentsHeader is
  fch_FileID:uword;
  fch_NumEntries:uword;
;

def DFH_ID = $0f80;
def MAXFONTNAME = 32;

struct DiskFontHeader is
  dfh_DF:Node;
  dfh_FileID:uword;
  dfh_Revision:uword;
  dfh_Segment:long;
  dfh_Name[32]:byte;
  dfh_TF:TextFont;
;

def dfh_TagList = dfh_Segment;

def AFB_MEMORY = 0;
def AFF_MEMORY = $0001;
def AFB_DISK = 1;
def AFF_DISK = $0002;
def AFB_SCALED = 2;
def AFF_SCALED = $0004;
def AFB_BITMAP = 3;
def AFF_BITMAP = $0008;

def AFB_TAGGED = 16;
def AFF_TAGGED = $10000;

struct AvailFonts is
  af_Type:uword;
  af_Attr:TextAttr;
;

struct TAvailFonts is
  taf_Type:uword;
  taf_Attr:TTextAttr;
;

struct AvailFontsHeader is
  afh_NumEntries:uword;
;

