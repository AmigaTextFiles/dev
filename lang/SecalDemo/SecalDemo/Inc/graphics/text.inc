include "inc/exec/ports.inc";
include "inc/graphics/gfx.inc";
include "inc/utility/tagitem.inc";

def FS_NORMAL = 0;
def FSB_UNDERLINED = 0;
def FSF_UNDERLINED = $01;
def FSB_BOLD = 1;
def FSF_BOLD = $02;
def FSB_ITALIC = 2;
def FSF_ITALIC = $04;
def FSB_EXTENDED = 3;
def FSF_EXTENDED = $08;

def FSB_COLORFONT = 6;
def FSF_COLORFONT = $40;
def FSB_TAGGED = 7;
def FSF_TAGGED = $80;

def FPB_ROMFONT = 0;
def FPF_ROMFONT = $01;
def FPB_DISKFONT = 1;
def FPF_DISKFONT = $02;
def FPB_REVPATH = 2;
def FPF_REVPATH = $04;
def FPB_TALLDOT = 3;
def FPF_TALLDOT = $08;
def FPB_WIDEDOT = 4;
def FPF_WIDEDOT = $10;
def FPB_PROPORTIONAL = 5;
def FPF_PROPORTIONAL = $20;
def FPB_DESIGNED = 6;
def FPF_DESIGNED = $40;
def FPB_REMOVED = 7;
def FPF_REMOVED = (1<<7);

struct TextAttr is
  ta_Name:ulong;
  ta_YSize:uword;
  ta_Style:ubyte;
  ta_Flags:ubyte;
;

struct TTextAttr is
  tta_Name:ulong;
  tta_YSize:uword;
  tta_Style:ubyte;
  tta_Flags:ubyte;
  tta_Tags:ulong;
;

def TA_DeviceDPI = (1|TAG_USER);
def MAXFONTMATCHWEIGHT = 32767;

struct TextFont is
  tf_Message:Message;
  tf_YSize:uword;
  tf_Style:ubyte;
  tf_Flags:ubyte;
  tf_XSize:uword;
  tf_Baseline:uword;
  tf_BoldSmear:uword;
  tf_Accessors:uword;
  tf_LoChar:ubyte;
  tf_HiChar:ubyte;
  tf_CharData:ulong;
  tf_Modulo:uword;
  tf_CharLoc:ulong;
  tf_CharSpace:ulong;
  tf_CharKern:ulong;
;

def tf_Extension = tf_Message.mn_ReplyPort;

def TE0B_NOREMFONT = 0;
def TE0F_NOREMFONT = $01;

struct TextFontExtension is
  tfe_MatchWord:uword;
  tfe_Flags0:ubyte;
  tfe_Flags1:ubyte;
  tfe_BackPtr:ulong;
  tfe_OrigReplyPort:ulong;
  tfe_Tags:ulong;
  tfe_OFontPatchS:ulong;
  tfe_OFontPatchK:ulong;
;

def CT_COLORMASK = $000f;
def CT_COLORFONT = $0001;
def CT_GREYFONT = $0002;
def CT_ANTIALIAS = $0004;

def CTB_MAPCOLOR = 0;
def CTF_MAPCOLOR = $0001;

struct ColorFontColors is
  cfc_Reserved:uword;
  cfc_Count:uword;
  cfc_ColorTable:ulong;
;

struct ColorTextFont is
  ctf_TF:TextFont;
  ctf_Flags:uword;
  ctf_Depth:ubyte;
  ctf_FgColor:ubyte;
  ctf_Low:ubyte;
  ctf_High:ubyte;
  ctf_PlanePick:ubyte;
  ctf_PlaneOnOff:ubyte;
  ctf_ColorFontColors:ulong;
  ctf_CharData[8]:ulong;
;

struct TextExtent is
  te_Width:uword;
  te_Height:uword;
  te_Extent:Rectangle;
;

