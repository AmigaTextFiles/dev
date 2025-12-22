@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "intuition/preferences.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT preferences
@{fg shine}(   0)@{fg text}   fontheight:CHAR
@{fg shine}(   1)@{fg text}   printerport:CHAR
@{fg shine}(   2)@{fg text}   baudrate:INT
@{fg shine}(   4)@{fg text}   keyrptspeed:timeval @{fg shine}(or ARRAY OF timeval)@{fg text}
@{fg shine}(  12)@{fg text}   keyrptdelay:timeval @{fg shine}(or ARRAY OF timeval)@{fg text}
@{fg shine}(  20)@{fg text}   doubleclick:timeval @{fg shine}(or ARRAY OF timeval)@{fg text}
@{fg shine}(  28)@{fg text}   pointermatrix[36]:ARRAY OF INT
@{fg shine}( 100)@{fg text}   xoffset:CHAR
@{fg shine}( 101)@{fg text}   yoffset:CHAR
@{fg shine}( 102)@{fg text}   color17:INT
@{fg shine}( 104)@{fg text}   color18:INT
@{fg shine}( 106)@{fg text}   color19:INT
@{fg shine}( 108)@{fg text}   pointerticks:INT
@{fg shine}( 110)@{fg text}   color0:INT
@{fg shine}( 112)@{fg text}   color1:INT
@{fg shine}( 114)@{fg text}   color2:INT
@{fg shine}( 116)@{fg text}   color3:INT
@{fg shine}( 118)@{fg text}   viewxoffset:CHAR
@{fg shine}( 119)@{fg text}   viewyoffset:CHAR
@{fg shine}( 120)@{fg text}   viewinitx:INT
@{fg shine}( 122)@{fg text}   viewinity:INT
@{fg shine}( 124)@{fg text}   enablecli:INT
@{fg shine}( 126)@{fg text}   printertype:INT
@{fg shine}( 128)@{fg text}   printerfilename[30]:ARRAY OF CHAR
@{fg shine}( 158)@{fg text}   printpitch:INT
@{fg shine}( 160)@{fg text}   printquality:INT
@{fg shine}( 162)@{fg text}   printspacing:INT
@{fg shine}( 164)@{fg text}   printleftmargin:INT
@{fg shine}( 166)@{fg text}   printrightmargin:INT
@{fg shine}( 168)@{fg text}   printimage:INT
@{fg shine}( 170)@{fg text}   printaspect:INT
@{fg shine}( 172)@{fg text}   printshade:INT
@{fg shine}( 174)@{fg text}   printthreshold:INT
@{fg shine}( 176)@{fg text}   papersize:INT
@{fg shine}( 178)@{fg text}   paperlength:INT
@{fg shine}( 180)@{fg text}   papertype:INT
@{fg shine}( 182)@{fg text}   serrwbits:CHAR
@{fg shine}( 183)@{fg text}   serstopbuf:CHAR
@{fg shine}( 184)@{fg text}   serparshk:CHAR
@{fg shine}( 185)@{fg text}   lacewb:CHAR
@{fg shine}( 186)@{fg text}   pad[12]:ARRAY OF CHAR
@{fg shine}( 198)@{fg text}   prtdevname[16]:ARRAY OF CHAR
@{fg shine}( 214)@{fg text}   defaultprtunit:CHAR
@{fg shine}( 215)@{fg text}   defaultserunit:CHAR
@{fg shine}( 216)@{fg text}   rowsizechange:CHAR
@{fg shine}( 217)@{fg text}   columnsizechange:CHAR
@{fg shine}( 218)@{fg text}   printflags:INT
@{fg shine}( 220)@{fg text}   printmaxwidth:INT
@{fg shine}( 222)@{fg text}   printmaxheight:INT
@{fg shine}( 224)@{fg text}   printdensity:CHAR
@{fg shine}( 225)@{fg text}   printxoffset:CHAR
@{fg shine}( 226)@{fg text}   wb_width:INT
@{fg shine}( 228)@{fg text}   wb_height:INT
@{fg shine}( 230)@{fg text}   wb_depth:CHAR
@{fg shine}( 231)@{fg text}   ext_size:CHAR
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=232 */

CONST SPARITY_EVEN=1,
      TOPAZ_EIGHTY=8,
      ASPECT_HORIZ=0,
      IMAGE_NEGATIVE=1,
      IMAGE_POSITIVE=0,
      FINE=$800,
      BAUD_9600=5,
      MOUSE_ACCEL=$8000,
      DIAB_ADV_D25=5,
      CORRECT_GREEN=2,
      SHSHAKE_BITS=15,
      SPARITY_BITS=$F0,
      SBUFSIZE_BITS=15,
      SSTOP_BITS=$F0,
      SWRITE_BITS=15,
      SREAD_BITS=$F0,
      US_LETTER=0,
      LETTER=$100,
      SINGLE=$80,
      SPARITY_MARK=3,
      DIAB_630=4,
      HP_LASERJET=11,
      ANTI_ALIAS=$800,
      MULTIPLY_DIMENSIONS=$80,
      PIXEL_DIMENSIONS=$40,
      ABSOLUTE_DIMENSIONS=$20,
      BOUNDED_DIMENSIONS=16,
      IGNORE_DIMENSIONS=0,
      BAUD_19200=6,
      SPARITY_SPACE=4,
      SBUF_2048=2,
      TOPAZ_SIXTY=9,
      DITHERING_MASK=$600,
      DIMENSIONS_MASK=$F0,
      CORRECT_RGB_MASK=7,
      DIAB_C_150=6,
      CUSTOM=$40,
      W_TRACTOR=$30,
      N_TRACTOR=$20,
      SHADE_BW=0,
      BAUD_300=1,
      CENTER_IMAGE=8,
      CORRECT_BLUE=4,
      DRAFT=0,
      SBUF_8000=4,
      SCREEN_DRAG=$4000,
      FLOYD_DITHERING=$400,
      HALFTONE_DITHERING=$200,
      ORDERED_DITHERING=0,
      BAUD_4800=4,
      SBUF_4096=3,
      US_LEGAL=16,
      SHSHAKE_XON=0,
      SPARITY_ODD=2,
      CBM_MPS1000=3,
      SHADE_COLOR=2,
      SBUF_16000=5,
      EURO_A0=$50,
      EURO_A1=$60,
      EURO_A2=$70,
      EURO_A3=$80,
      EURO_A4=$90,
      EURO_A5=$A0,
      ELITE=$400,
      EPSON_JX_80=8,
      EURO_A6=$B0,
      EURO_A7=$C0,
      CORRECT_RED=1,
      EURO_A8=$D0,
      HP_LASERJET_PLUS=12,
      SHSHAKE_NONE=2,
      SPARITY_NONE=0,
      GREY_SCALE2=$1000,
      SBUF_1024=1,
      SERIAL_PRINTER=1,
      PARALLEL_PRINTER=0,
      LW_RESERVED=1,
      BROTHER_15XL=2,
      FANFOLD=0,
      BAUD_2400=3,
      EIGHT_LPI=$200,
      SIX_LPI=0,
      ASPECT_VERT=1,
      BAUD_MIDI=7,
      SHSHAKE_RTS=1,
      SBUF_512=0,
      EPSON=7,
      LACEWB=1,
      QUME_LP_20=10,
      ALPHA_P_101=1,
      OKIMATE_20=9,
      BAUD_1200=2,
      INTEGER_SCALING=$100,
      PICA=0,
      POINTERSIZE=$24,
      DEVNAME_SIZE=16,
      FILENAME_SIZE=30,
      SHADE_GREYSCALE=1,
      BAUD_110=0,
      CUSTOM_NAME=0
@endnode
