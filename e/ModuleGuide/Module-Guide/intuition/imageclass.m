@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "intuition/imageclass.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT imphitframe
@{fg shine}(   0)@{fg text}   methodid:LONG
@{fg shine}(   4)@{fg text}   pointx:INT
@{fg shine}(   6)@{fg text}   pointy:INT
@{fg shine}(   8)@{fg text}   dimensionswidth:INT
@{fg shine}(  10)@{fg text}   dimensionsheight:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=12 */

@{fg shine}(----)@{fg text} OBJECT imphittest
@{fg shine}(   0)@{fg text}   methodid:LONG
@{fg shine}(   4)@{fg text}   pointx:INT
@{fg shine}(   6)@{fg text}   pointy:INT
@{fg shine}(   8)@{fg text}   dimensionswidth:INT
@{fg shine}(  10)@{fg text}   dimensionsheight:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=12 */

@{fg shine}(----)@{fg text} OBJECT imperaseframe
@{fg shine}(   0)@{fg text}   methodid:LONG
@{fg shine}(   4)@{fg text}   rport:PTR TO rastport
@{fg shine}(   8)@{fg text}   offsetx:INT
@{fg shine}(  10)@{fg text}   offsety:INT
@{fg shine}(  12)@{fg text}   dimensionswidth:INT
@{fg shine}(  14)@{fg text}   dimensionsheight:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=16 */

@{fg shine}(----)@{fg text} OBJECT imperase
@{fg shine}(   0)@{fg text}   methodid:LONG
@{fg shine}(   4)@{fg text}   rport:PTR TO rastport
@{fg shine}(   8)@{fg text}   offsetx:INT
@{fg shine}(  10)@{fg text}   offsety:INT
@{fg shine}(  12)@{fg text}   dimensionswidth:INT
@{fg shine}(  14)@{fg text}   dimensionsheight:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=16 */

@{fg shine}(----)@{fg text} OBJECT impdrawframe
@{fg shine}(   0)@{fg text}   methodid:LONG
@{fg shine}(   4)@{fg text}   rport:PTR TO rastport
@{fg shine}(   8)@{fg text}   offsetx:INT
@{fg shine}(  10)@{fg text}   offsety:INT
@{fg shine}(  12)@{fg text}   state:LONG
@{fg shine}(  16)@{fg text}   drinfo:PTR TO drawinfo
@{fg shine}(  20)@{fg text}   dimensionswidth:INT
@{fg shine}(  22)@{fg text}   dimensionsheight:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=24 */

@{fg shine}(----)@{fg text} OBJECT impdraw
@{fg shine}(   0)@{fg text}   methodid:LONG
@{fg shine}(   4)@{fg text}   rport:PTR TO rastport
@{fg shine}(   8)@{fg text}   offsetx:INT
@{fg shine}(  10)@{fg text}   offsety:INT
@{fg shine}(  12)@{fg text}   state:LONG
@{fg shine}(  16)@{fg text}   drinfo:PTR TO drawinfo
@{fg shine}(  20)@{fg text}   dimensionswidth:INT
@{fg shine}(  22)@{fg text}   dimensionsheight:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=24 */

@{fg shine}(----)@{fg text} OBJECT impframebox
@{fg shine}(   0)@{fg text}   methodid:LONG
@{fg shine}(   4)@{fg text}   contentsbox:PTR TO ibox
@{fg shine}(   8)@{fg text}   framebox:PTR TO ibox
@{fg shine}(  12)@{fg text}   drinfo:PTR TO drawinfo
@{fg shine}(  16)@{fg text}   frameflags:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=20 */

CONST SYSISIZE_LOWRES=1,
      SYSIA_REFERENCEFONT=$80020019,
      IA_FONT=$80020013,
      IA_FRAMETYPE=$8002001B,
      IM_MOVE=$205,
      IM_HITTEST=$203,
      AMIGAKEY=17,
      IDS_INACTIVENORMAL=5,
      IDS_NORMAL=0,
      IDS_INDETERMINANT=4,
      IDS_INACTIVEDISABLED=7,
      IDS_DISABLED=2,
      IA_DATA=$80020007,
      FRAME_ICONDROPBOX=3,
      SYSIA_WHICH=$8002000D,
      IM_ERASE=$204,
      IA_HIGHLIGHTPEN=$8002000A,
      IM_FRAMEBOX=$207,
      MXIMAGE=15,
      CHECKIMAGE=14,
      DOWNIMAGE=13,
      RIGHTIMAGE=12,
      UPIMAGE=11,
      LEFTIMAGE=10,
      SDEPTHIMAGE=5,
      CLOSEIMAGE=3,
      SIZEIMAGE=2,
      ZOOMIMAGE=1,
      DEPTHIMAGE=0,
      IA_SUPPORTSDISABLE=$8002001A,
      IA_RESOLUTION=$8002000F,
      MENUCHECK=16,
      IM_DRAW=$202,
      FRAME_DEFAULT=0,
      IA_RECESSED=$80020015,
      FRAMEF_SPECIFY=1,
      FRAMEB_SPECIFY=0,
      IA_SHADOWPEN=$80020009,
      IA_BGPEN=$80020006,
      IA_FGPEN=$80020005,
      IMAGE_ATTRIBUTES=$80020000,
      SYSIA_DRAWINFO=$80020018,
      IM_ERASEFRAME=$209,
      IM_HITFRAME=$208,
      IM_DRAWFRAME=$206,
      IA_TOP=$80020002,
      IDS_BUSY=3,
      IA_MODE=$80020012,
      IDS_INACTIVESELECTED=6,
      IDS_SELECTED=1,
      FRAME_BUTTON=1,
      IA_HEIGHT=$80020004,
      IDS_INDETERMINATE=4,
      SYSISIZE_MEDRES=0,
      IA_LEFT=$80020001,
      IA_EDGESONLY=$80020017,
      SYSIA_PENS=$8002000E,
      IA_PENS=$8002000E,
      SYSISIZE_HIRES=2,
      SYSIA_DEPTH=$8002000C,
      CUSTOMIMAGEDEPTH=-1,
      FRAME_RIDGE=2,
      IA_LINEWIDTH=$80020008,
      IA_WIDTH=$80020003,
      IA_DOUBLEEMBOSS=$80020016,
      IA_OUTLINE=$80020014,
      IA_APATTERN=$80020010,
      SYSIA_SIZE=$8002000B,
      IA_APATSIZE=$80020011

#define IM_BGPEN/1
#define IM_FGPEN/1
#define IM_BOX/1
#define GADGET_BOX/1
@endnode
