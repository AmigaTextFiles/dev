ShowModule v1.10 (c) 1992 $#%!
now showing: "rtgsublibs.m"
NOTE: don't use this output in your code, use the module instead.

(----) OBJECT rtgscreen
(   0)   libbase:LONG
(   4)   libversion:INT
(   6)   pad1:INT
(   8)   graphicsboard:LONG
(  12)   reserved[20]:ARRAY OF CHAR
(  32)   mousex:LONG
(  36)   mousey:LONG
(  40)   c2pcode:INT
(  42)   c2pdata:INT
(  44)   c2pcurr:LONG
(  48)   c2pname[30]:ARRAY OF CHAR
(----) ENDOBJECT     /* SIZEOF=78 */

(----) OBJECT screenreqlist
(   0)   srnode:PTR TO ln
(   4)   req:PTR TO screenreq
(----) ENDOBJECT     /* SIZEOF=8 */

(----) OBJECT screenreq
(   0)   screenmode:PTR TO screenmode
(   4)   width:LONG
(   8)   height:LONG
(  12)   depth:INT
(  14)   overscan:INT
(  16)   flags:INT
(----) ENDOBJECT     /* SIZEOF=18 */

(----) OBJECT screenmode
(   0)   scrnode:PTR TO ln
(   4)   name[32]:ARRAY OF CHAR
(  36)   description[32]:ARRAY OF CHAR
(  68)   graphicsboard:LONG
(  72)   modeid:LONG
(  76)   reserved[8]:ARRAY OF CHAR
(  84)   minwidth:LONG
(  88)   maxwidth:LONG
(  92)   minheight:LONG
(  96)   maxheight:LONG
( 100)   default:PTR TO rtgdimensioninfo
( 104)   textoverscan:PTR TO rtgdimensioninfo
( 108)   standardoverscan:PTR TO rtgdimensioninfo
( 112)   maxoverscan:PTR TO rtgdimensioninfo
( 116)   chunkysupport:LONG
( 120)   planarsupport:LONG
( 124)   pixelaspect:LONG
( 128)   vertscan:LONG
( 132)   horscan:LONG
( 136)   pixelclock:LONG
( 140)   vertblank:LONG
( 144)   buffers:LONG
( 148)   bitsred:INT
( 150)   bitsgreen:INT
( 152)   bitsblue:INT
(----) ENDOBJECT     /* SIZEOF=154 */

(----) OBJECT rtgdimensioninfo
(   0)   width:LONG
(   4)   height:LONG
(----) ENDOBJECT     /* SIZEOF=8 */

CONST RGB24=2,
      GRD_DDIRECT=6,
      RTG_ZBUFFER=$80000007,
      RTG_DELTAMOVE=$8000000B,
      RTG_MOUSEMOVE=$8000000A,
      GRD_RGBPORT=4,
      RTG_PLANARSUPPORT=$80000006,
      RTG_CHUNKYSUPPORT=$80000005,
      ARGB32=1,
      GRD_PCI=8,
      BGR15PC=$1000,
      RGB15PC=$800,
      LUT8=$200,
      GRD_DUMMY=$80000000,
      RTG_DUMMY=$80000000,
      RTG_USE3D=$80000008,
      GRD_CHUNKY=2,
      GRD_COLORSPACE=$80000004,
      GRD_CUSTOM=3,
      RTG_INTERLEAVED=$80000002,
      BGR16PC=$4000,
      RGB16PC=$2000,
      GRD_3DCHIPSET=$8000000B,
      BGR15=$80,
      GRD_RGBPC=3,
      BGR16=$40,
      RTG_DRAGGABLE=$80000003,
      RTG_CHANGECOLORS=$8000000D,
      GRD_MOUSEX=$80000008,
      BGR24=$20,
      GRD_MOUSEY=$80000009,
      GRD_BGR=2,
      ABGR32=16,
      PLANAR1=1,
      PLANAR2=2,
      PLANAR3=4,
      GRD_BYTESPERROW=$80000007,
      PLANAR4=8,
      PLANAR5=16,
      PLANAR6=$20,
      PLANAR7=$40,
      PLANAR8=$80,
      GRD_Z2=2,
      GRD_Z3=1,
      GRD_GVP=5,
      RTG_EXCLUSIVE=$80000004,
      GRD_PALETTE=0,
      RTG_WORKBENCH=$80000009,
      GRD_HEIGHT=$80000002,
      GRD_BUSSYSTEM=$8000000A,
      GRD_PLANATI=1,
      GRD_BGRPC=4,
      GRD_GRAFFITI=8,
      GRAFFITI=$400,
      GRD_HICOL15=3,
      GRD_HICOL16=4,
      GRD_RGB=1,
      BGRA32=$8000,
      RGBA32=$100,
      RTG_BUFFERS=$80000001,
      SQ_MAXOVERSCAN=3,
      SQ_STANDARDOVERSCAN=2,
      SQ_TEXTOVERSCAN=1,
      SQ_NOOVERSCAN=0,
      GRD_TRUECOL24=5,
      GRD_DEPTH=$80000005,
      GRD_TRUECOL32=7,
      GRD_WIDTH=$80000001,
      GRD_TRUECOL32B=9,
      RGB15=8,
      GRD_TRUECOL24P=6,
      GRD_ATEO=7,
      RGB16=4,
      GRD_PLANAR=0,
      GRD_PLANESIZE=$80000006,
      GRD_PIXELLAYOUT=$80000003,
      RTG_PUBSCREENNAME=$8000000C

#define PLANAR2I/0
#define SQ_EHB/0
#define PLANAR3I/0
#define PLANAR4I/0
#define PLANAR5I/0
#define PLANAREHB/0
#define PLANAR6I/0
#define PLANAR7I/0
#define PLANAR8I/0
#define SQ_DEFAULTX/0
#define SQ_DEFAULTY/0
#define SQ_CHUNKYMODE/0
#define SQ_WORKBENCH/0
#define PLANAREHBI/0
#define PLANAR1I/0

