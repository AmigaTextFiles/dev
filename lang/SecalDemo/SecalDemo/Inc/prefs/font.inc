include "inc/exec/types.inc";
include "inc/libraries/iffparse.inc";
include "inc/graphics/text.inc";

def FONTNAMESIZE = (128);

struct FontPrefs is
  fp_Reserved[3]:long;
  fp_Reserved2:uword;
  fp_Type:uword;
  fp_FrontPen:ubyte;
  fp_BackPen:ubyte;
  fp_DrawMode:ubyte;
  fp_TextAttr:TextAttr;
  fp_Name[128]:byte;
;

def FP_WBFONT = 0;
def FP_SYSFONT = 1;
def FP_SCREENFONT = 2;

