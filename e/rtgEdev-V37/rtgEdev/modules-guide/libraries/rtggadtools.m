ShowModule v1.10 (c) 1992 $#%!
now showing: "rtggadtools.m"
NOTE: don't use this output in your code, use the module instead.

(----) OBJECT rganchor
(   0)   rtgscreen:INT
(   2)   first:rggadget (or ARRAY OF rggadget)
(  54)   directcolor:INT
(  56)   buffer:INT
(  58)   numbuffers:LONG
(----) ENDOBJECT     /* SIZEOF=62 */

(----) OBJECT rggadget
(   0)   next:PTR TO rggadget
(   4)   leftedge:LONG
(   8)   topedge:INT
(  10)   width:LONG
(  14)   height:INT
(  16)   flags:LONG
(  20)   key:INT
(  22)   gadgetrender:INT
(  24)   selectrender:INT
(  26)   textpen:LONG
(  30)   hipen:LONG
(  34)   lopen:LONG
(  38)   hittest:INT
(  40)   downaction:INT
(  42)   backgnd:LONG
(  46)   hilite:LONG
(  50)   userdata:INT
(----) ENDOBJECT     /* SIZEOF=52 */

CONST RGG_CONTROLKEY=$80000019,
      RGG_HITTEST=$80000013,
      RGG_USERDATA=$80000014,
      RGG_LOPEN=$80000017,
      RGG_TOPEDGE=$80000008,
      RGG_LEFTEDGE=$80000007,
      RGG_SELECTRENDER=$80000003,
      RGG_BASE=$80000000,
      RGG_TEXTPEN=$80000018,
      RGG_RENDERIMAGE=$80000022,
      RGS_ENABLE=1,
      RGS_DISABLE=0,
      RGG_DOWNACTION=$80000006,
      RGG_UPACTION=$80000005,
      RGG_HIPEN=$80000016,
      RGG_RENDERTEXT=$80000001,
      RGG_HILITECOLOR=$80000021,
      RGG_BACKCOLOR=$80000020,
      RGG_HEIGHT=$80000010,
      RGG_ACTIVEKEY=$80000002,
      RGG_RENDERHOOK=$80000011,
      RGS_TOGGLE=2,
      RGG_WIDTH=$80000009,
      RGG_FLAGS=$80000015

