@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "devices/prtgfx.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT prtinfo
@{fg shine}(   0)@{fg text}   render:LONG
@{fg shine}(   4)@{fg text}   rp:PTR TO rastport
@{fg shine}(   8)@{fg text}   temprp:PTR TO rastport
@{fg shine}(  12)@{fg text}   rowbuf:PTR TO INT
@{fg shine}(  16)@{fg text}   hambuf:PTR TO INT
@{fg shine}(  20)@{fg text}   colormap:PTR TO colorentry
@{fg shine}(  24)@{fg text}   colorint:PTR TO colorentry
@{fg shine}(  28)@{fg text}   hamint:PTR TO colorentry
@{fg shine}(  32)@{fg text}   dest1int:PTR TO colorentry
@{fg shine}(  36)@{fg text}   dest2int:PTR TO colorentry
@{fg shine}(  40)@{fg text}   scalex:PTR TO INT
@{fg shine}(  44)@{fg text}   scalexalt:PTR TO INT
@{fg shine}(  48)@{fg text}   dmatrix:PTR TO CHAR
@{fg shine}(  52)@{fg text}   topbuf:PTR TO INT
@{fg shine}(  56)@{fg text}   botbuf:PTR TO INT
@{fg shine}(  60)@{fg text}   rowbufsize:INT
@{fg shine}(  62)@{fg text}   hambufsize:INT
@{fg shine}(  64)@{fg text}   colormapsize:INT
@{fg shine}(  66)@{fg text}   colorintsize:INT
@{fg shine}(  68)@{fg text}   hamintsize:INT
@{fg shine}(  70)@{fg text}   dest1intsize:INT
@{fg shine}(  72)@{fg text}   dest2intsize:INT
@{fg shine}(  74)@{fg text}   scalexsize:INT
@{fg shine}(  76)@{fg text}   scalexaltsize:INT
@{fg shine}(  78)@{fg text}   prefsflags:INT
@{fg shine}(  80)@{fg text}   special:LONG
@{fg shine}(  84)@{fg text}   xstart:INT
@{fg shine}(  86)@{fg text}   ystart:INT
@{fg shine}(  88)@{fg text}   width:INT
@{fg shine}(  90)@{fg text}   height:INT
@{fg shine}(  92)@{fg text}   pc:LONG
@{fg shine}(  96)@{fg text}   pr:LONG
@{fg shine}( 100)@{fg text}   ymult:INT
@{fg shine}( 102)@{fg text}   ymod:INT
@{fg shine}( 104)@{fg text}   ety:INT
@{fg shine}( 106)@{fg text}   xpos:INT
@{fg shine}( 108)@{fg text}   threshold:INT
@{fg shine}( 110)@{fg text}   tempwidth:INT
@{fg shine}( 112)@{fg text}   flags:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=114 */

@{fg shine}(----)@{fg text} OBJECT colorentry
@{fg shine}(   0)@{fg text}   colorlong:LONG
@{fg shine}(   0)@{fg text}   colorbyte[4]:ARRAY OF CHAR
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=4 */

CONST PCMGREEN=1,
      PCMYELLOW=0,
      PCMBLUE=0,
      PCMCYAN=2,
      PCMWHITE=3,
      PCMBLACK=3,
      PCMRED=2,
      PCMMAGENTA=1
@endnode
