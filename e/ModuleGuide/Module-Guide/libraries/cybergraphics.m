@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "libraries/cybergraphics.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT cybermodenode
@{fg shine}(   0)@{fg text}   node:PTR TO LONG
@{fg shine}(   4)@{fg text}   modetext[32]:ARRAY OF CHAR
@{fg shine}(  36)@{fg text}   displayid:LONG
@{fg shine}(  40)@{fg text}   width:LONG
@{fg shine}(  44)@{fg text}   height:LONG
@{fg shine}(  48)@{fg text}   depth:LONG
@{fg shine}(  52)@{fg text}   displaytaglist:PTR TO LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=56 */

CONST PIXFMT_RGB24=9,
      CYBRMATTR_BPPIX=$80000002,
      CYBRIDATTR_BPPIX=$80000005,
      CYBRMREQ_CModelArray=$80040006,
      PIXFMT_ARGB32=11,
      PIXFMT_RGB15PC=3,
      PIXFMT_BGR15PC=4,
      CYBRMREQ_MinHeight=$80040004,
      CYBRMREQ_MaxHeight=$80040005,
      CYBRBIDTG_NominalHeight=$80050002,
      PIXFMT_LUT8=0,
      CYBRMREQ_MinDepth=$80040000,
      CYBRMREQ_MaxDepth=$80040001,
      CYBRBIDTG_Depth=$80050000,
      CYBRMATTR_PIXFMT=$80000004,
      CYBRIDATTR_PIXFMT=$80000001,
      RECTFMT_RGBA=1,
      CYBRMREQ_WinTitle=$80040014,
      PIXFMT_RGB16PC=7,
      PIXFMT_BGR16PC=8,
      CYBRMREQ_MinWidth=$80040002,
      CYBRMREQ_MaxWidth=$80040003,
      CYBRBIDTG_NominalWidth=$80050001,
      PIXFMT_BGR15=2,
      PIXFMT_BGR16=6,
      CYBRMATTR_XMOD=$80000001,
      CYBRMATTR_DISPADR=$80000003,
      PIXFMT_BGR24=10,
      CYBRBIDTG_TB=$80050000,
      CYBRMREQ_Screen=$8004001E,
      RECTFMT_ARGB=2,
      CYBRMATTR_HEIGHT=$80000006,
      CYBRIDATTR_HEIGHT=$80000003,
      CYBRBIDTG_MonitorID=$80050003,
      RECTFMT_RGB=0,
      PIXFMT_BGRA32=12,
      CYBRMATTR_DEPTH=$80000007,
      CYBRIDATTR_DEPTH=$80000004,
      CYBRMREQ_OKText=$80040015,
      CYBRMREQ_CancelText=$80040016,
      CYBRMATTR_WIDTH=$80000005,
      CYBRIDATTR_WIDTH=$80000002,
      PIXFMT_RGB15=1,
      PIXFMT_RGB16=5,
      CYBRMREQ_TB=$80040000
@endnode
