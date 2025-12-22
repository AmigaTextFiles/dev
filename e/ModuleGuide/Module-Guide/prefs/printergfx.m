@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "prefs/printergfx.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT printergfxprefs
@{fg shine}(   0)@{fg text}   reserved[4]:ARRAY OF LONG
@{fg shine}(  16)@{fg text}   aspect:INT
@{fg shine}(  18)@{fg text}   shade:INT
@{fg shine}(  20)@{fg text}   image:INT
@{fg shine}(  22)@{fg text}   threshold:INT
@{fg shine}(  24)@{fg text}   colorcorrect:CHAR
@{fg shine}(  25)@{fg text}   dimensions:CHAR
@{fg shine}(  26)@{fg text}   dithering:CHAR
@{fg shine}(  28)@{fg text}   graphicflags:INT
@{fg shine}(  30)@{fg text}   printdensity:CHAR
@{fg shine}(  32)@{fg text}   printmaxwidth:INT
@{fg shine}(  34)@{fg text}   printmaxheight:INT
@{fg shine}(  36)@{fg text}   printxoffset:CHAR
@{fg shine}(  37)@{fg text}   printyoffset:CHAR
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=38 */

CONST PI_NEGATIVE=1,
      PI_POSITIVE=0,
      PD_PIXEL=3,
      PD_ORDERED=0,
      PD_HALFTONE=1,
      PCCF_GREEN=2,
      PCCB_GREEN=1,
      PD_IGNORE=0,
      PD_ABSOLUTE=2,
      PD_BOUNDED=1,
      PGFF_ANTI_ALIAS=4,
      PGFB_ANTI_ALIAS=2,
      PA_VERTICAL=1,
      PGFF_CENTER_IMAGE=1,
      PGFB_CENTER_IMAGE=0,
      PA_HORIZONTAL=0,
      PCCF_BLUE=4,
      PCCB_BLUE=2,
      PS_BW=0,
      PS_COLOR=2,
      PCCF_RED=1,
      PCCB_RED=0,
      PS_GREY_SCALE2=3,
      PD_MULTIPLY=4,
      PD_FLOYD=2,
      ID_PGFX=$50474658,
      PGFF_INTEGER_SCALING=2,
      PGFB_INTEGER_SCALING=1,
      PS_GREYSCALE=1
@endnode
