@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "prefs/printerps.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT printerpsprefs
@{fg shine}(   0)@{fg text}   reserved[4]:ARRAY OF LONG
@{fg shine}(  16)@{fg text}   drivermode:CHAR
@{fg shine}(  17)@{fg text}   paperformat:CHAR
@{fg shine}(  18)@{fg text}   reserved1[2]:ARRAY OF CHAR
@{fg shine}(  20)@{fg text}   copies:LONG
@{fg shine}(  24)@{fg text}   paperwidth:LONG
@{fg shine}(  28)@{fg text}   paperheight:LONG
@{fg shine}(  32)@{fg text}   horizontaldpi:LONG
@{fg shine}(  36)@{fg text}   verticaldpi:LONG
@{fg shine}(  40)@{fg text}   font:CHAR
@{fg shine}(  41)@{fg text}   pitch:CHAR
@{fg shine}(  42)@{fg text}   orientation:CHAR
@{fg shine}(  43)@{fg text}   tab:CHAR
@{fg shine}(  44)@{fg text}   reserved2[8]:ARRAY OF CHAR
@{fg shine}(  52)@{fg text}   leftmargin:LONG
@{fg shine}(  56)@{fg text}   rightmargin:LONG
@{fg shine}(  60)@{fg text}   topmargin:LONG
@{fg shine}(  64)@{fg text}   bottommargin:LONG
@{fg shine}(  68)@{fg text}   fontpointsize:LONG
@{fg shine}(  72)@{fg text}   leading:LONG
@{fg shine}(  76)@{fg text}   reserved3[8]:ARRAY OF CHAR
@{fg shine}(  84)@{fg text}   leftedge:LONG
@{fg shine}(  88)@{fg text}   topedge:LONG
@{fg shine}(  92)@{fg text}   width:LONG
@{fg shine}(  96)@{fg text}   height:LONG
@{fg shine}( 100)@{fg text}   image:CHAR
@{fg shine}( 101)@{fg text}   shading:CHAR
@{fg shine}( 102)@{fg text}   dithering:CHAR
@{fg shine}( 103)@{fg text}   reserved4a:CHAR
@{fg shine}( 104)@{fg text}   reserved4[8]:ARRAY OF CHAR
@{fg shine}( 112)@{fg text}   aspect:CHAR
@{fg shine}( 113)@{fg text}   scalingtype:CHAR
@{fg shine}( 114)@{fg text}   reserved5:CHAR
@{fg shine}( 115)@{fg text}   centering:CHAR
@{fg shine}( 116)@{fg text}   reserved6[8]:ARRAY OF CHAR
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=124 */

CONST FONT_COURIER=0,
      CENT_HORIZ=1,
      ASP_HORIZ=0,
      DITH_HORIZ=3,
      ST_ASPECT_ASIS=0,
      TAB_HALF=3,
      FONT_NEWCENT=6,
      IM_NEGATIVE=1,
      IM_POSITIVE=0,
      PITCH_NORMAL=0,
      ID_POST=$50535044,
      PF_USLETTER=0,
      PITCH_EXPANDED=2,
      DITH_DOTTY=1,
      FONT_PALATINO=7,
      PF_CUSTOM=3,
      FONT_TIMES=1,
      TAB_INCH=4,
      FONT_AVANTGARDE=4,
      ST_FITS_TALL=5,
      ST_ASPECT_TALL=2,
      DM_PASSTHROUGH=1,
      DITH_DIAG=4,
      DITH_DEFAULT=0,
      ORIENT_LANDSCAPE=1,
      PITCH_COMPRESSED=1,
      PF_USLEGAL=1,
      PF_A4=2,
      FONT_HELV_NARROW=3,
      TAB_QUART=2,
      SHAD_COLOR=2,
      FONT_ZAPFCHANCERY=8,
      FONT_HELVETICA=2,
      ORIENT_PORTRAIT=0,
      CENT_NONE=0,
      TAB_4=0,
      TAB_8=1,
      CENT_VERT=2,
      ASP_VERT=1,
      DITH_VERT=2,
      FONT_BOOKMAN=5,
      DM_POSTSCRIPT=0,
      SHAD_BW=0,
      ST_FITS_WIDE=4,
      ST_ASPECT_WIDE=1,
      CENT_BOTH=3,
      ST_FITS_BOTH=6,
      ST_ASPECT_BOTH=3,
      SHAD_GREYSCALE=1
@endnode
