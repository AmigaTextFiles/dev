include "inc/utility/tagitem.inc";
include "inc/datatypes/datatypesclass.inc";
include "inc/libraries/iffparse.inc";

def TEXTDTCLASS = "text.datatype";

def TDTA_Buffer = (DTA_Dummy+300);
def TDTA_BufferLen = (DTA_Dummy+301);
def TDTA_LineList = (DTA_Dummy+302);
def TDTA_WordSelect = (DTA_Dummy+303);
def TDTA_WordDelim = (DTA_Dummy+304);
def TDTA_WordWrap = (DTA_Dummy+305);

struct Line is
  ln_Link:MinNode;
  ln_Text:ulong;
  ln_TextLen:ulong;
  ln_XOffset:uword;
  ln_YOffset:uword;
  ln_Width:uword;
  ln_Height:uword;
  ln_Flags:uword;
  ln_FgPen:byte;
  ln_BgPen:byte;
  ln_Style:ulong;
  ln_Data:ulong;
;

def LNF_LF = (1<<0);
def LNF_LINK = (1<<1);
def LNF_OBJECT = (1<<2);
def LNF_SELECTED = (1<<3);

