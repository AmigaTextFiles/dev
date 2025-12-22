@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "intuition/screens.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT screenbuffer
@{fg shine}(   0)@{fg text}   bitmap:PTR TO bitmap
@{fg shine}(   4)@{fg text}   dbufinfo:PTR TO dbufinfo
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=8 */

@{fg shine}(----)@{fg text} OBJECT pubscreennode
@{fg shine}(   0)@{fg text}   ln:ln @{fg shine}(or ARRAY OF ln)@{fg text}
@{fg shine}(  14)@{fg text}   screen:PTR TO screen
@{fg shine}(  18)@{fg text}   flags:INT
@{fg shine}(  20)@{fg text}   size:INT
@{fg shine}(  22)@{fg text}   visitorcount:INT
@{fg shine}(  24)@{fg text}   sigtask:PTR TO tc
@{fg shine}(  28)@{fg text}   sigbit:CHAR
@{fg shine}(  29)@{fg text}   pad1:CHAR
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=30 */

@{fg shine}(----)@{fg text} OBJECT extnewscreen
@{fg shine}(   0)@{fg text}   leftedge:INT
@{fg shine}(   2)@{fg text}   topedge:INT
@{fg shine}(   4)@{fg text}   width:INT
@{fg shine}(   6)@{fg text}   height:INT
@{fg shine}(   8)@{fg text}   depth:INT
@{fg shine}(  10)@{fg text}   detailpen:CHAR
@{fg shine}(  11)@{fg text}   blockpen:CHAR
@{fg shine}(  12)@{fg text}   viewmodes:INT
@{fg shine}(  14)@{fg text}   type:INT
@{fg shine}(  16)@{fg text}   font:PTR TO textattr
@{fg shine}(  20)@{fg text}   defaulttitle:PTR TO CHAR
@{fg shine}(  24)@{fg text}   gadgets:PTR TO gadget
@{fg shine}(  28)@{fg text}   custombitmap:PTR TO bitmap
@{fg shine}(  32)@{fg text}   extension:PTR TO tagitem
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=36 */

@{fg shine}(----)@{fg text} OBJECT ns
@{fg shine}(   0)@{fg text}   leftedge:INT
@{fg shine}(   2)@{fg text}   topedge:INT
@{fg shine}(   4)@{fg text}   width:INT
@{fg shine}(   6)@{fg text}   height:INT
@{fg shine}(   8)@{fg text}   depth:INT
@{fg shine}(  10)@{fg text}   detailpen:CHAR
@{fg shine}(  11)@{fg text}   blockpen:CHAR
@{fg shine}(  12)@{fg text}   viewmodes:INT
@{fg shine}(  14)@{fg text}   type:INT
@{fg shine}(  16)@{fg text}   font:PTR TO textattr
@{fg shine}(  20)@{fg text}   defaulttitle:PTR TO CHAR
@{fg shine}(  24)@{fg text}   gadgets:PTR TO gadget
@{fg shine}(  28)@{fg text}   custombitmap:PTR TO bitmap
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=32 */

@{fg shine}(----)@{fg text} OBJECT screen
@{fg shine}(   0)@{fg text}   nextscreen:PTR TO screen
@{fg shine}(   4)@{fg text}   firstwindow:PTR TO window
@{fg shine}(   8)@{fg text}   leftedge:INT
@{fg shine}(  10)@{fg text}   topedge:INT
@{fg shine}(  12)@{fg text}   width:INT
@{fg shine}(  14)@{fg text}   height:INT
@{fg shine}(  16)@{fg text}   mousey:INT
@{fg shine}(  18)@{fg text}   mousex:INT
@{fg shine}(  20)@{fg text}   flags:INT
@{fg shine}(  22)@{fg text}   title:PTR TO CHAR
@{fg shine}(  26)@{fg text}   defaulttitle:PTR TO CHAR
@{fg shine}(  30)@{fg text}   barheight:CHAR
@{fg shine}(  31)@{fg text}   barvborder:CHAR
@{fg shine}(  32)@{fg text}   barhborder:CHAR
@{fg shine}(  33)@{fg text}   menuvborder:CHAR
@{fg shine}(  34)@{fg text}   menuhborder:CHAR
@{fg shine}(  35)@{fg text}   wbortop:CHAR
@{fg shine}(  36)@{fg text}   wborleft:CHAR
@{fg shine}(  37)@{fg text}   wborright:CHAR
@{fg shine}(  38)@{fg text}   wborbottom:CHAR
@{fg shine}(  40)@{fg text}   font:PTR TO textattr
@{fg shine}(  44)@{fg text}   viewport:viewport @{fg shine}(or ARRAY OF viewport)@{fg text}
@{fg shine}(  84)@{fg text}   rastport:rastport @{fg shine}(or ARRAY OF rastport)@{fg text}
@{fg shine}( 184)@{fg text}   bitmap:bitmap @{fg shine}(or ARRAY OF bitmap)@{fg text}
@{fg shine}( 224)@{fg text}   layerinfo:layer_info @{fg shine}(or ARRAY OF layer_info)@{fg text}
@{fg shine}( 326)@{fg text}   firstgadget:PTR TO gadget
@{fg shine}( 330)@{fg text}   detailpen:CHAR
@{fg shine}( 331)@{fg text}   blockpen:CHAR
@{fg shine}( 332)@{fg text}   savecolor0:INT
@{fg shine}( 334)@{fg text}   barlayer:PTR TO layer
@{fg shine}( 338)@{fg text}   extdata:PTR TO CHAR
@{fg shine}( 342)@{fg text}   userdata:PTR TO CHAR
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=346 */

@{fg shine}(----)@{fg text} OBJECT drawinfo
@{fg shine}(   0)@{fg text}   version:INT
@{fg shine}(   2)@{fg text}   numpens:INT
@{fg shine}(   4)@{fg text}   pens:PTR TO INT
@{fg shine}(   8)@{fg text}   font:PTR TO textfont
@{fg shine}(  12)@{fg text}   depth:INT
@{fg shine}(  14)@{fg text}   resolutionx:INT
@{fg shine}(  16)@{fg text}   resolutiony:INT
@{fg shine}(  18)@{fg text}   flags:LONG
@{fg shine}(  22)@{fg text}   checkmark:PTR TO image
@{fg shine}(  26)@{fg text}   amigakey:PTR TO image
@{fg shine}(  30)@{fg text}   longreserved[5]:ARRAY OF LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=50 */

CONST SA_SYSFONT=$8000002C,
      SA_FONT=$8000002B,
      SA_DETAILPEN=$80000026,
      BARDETAILPEN=9,
      FILLPEN=5,
      DETAILPEN=0,
      SA_COLORMAPENTRIES=$8000003C,
      SA_TYPE=$8000002D,
      SCREENTYPE=15,
      PSNF_PRIVATE=1,
      OSCAN_STANDARD=2,
      SPOS_RELATIVE=0,
      SA_DUMMY=$80000020,
      SDEPTH_TOBACK=1,
      POPPUBSCREEN=2,
      CUSTOMSCREEN=15,
      PUBLICSCREEN=2,
      WBENCHSCREEN=1,
      SA_ERRORCODE=$8000002A,
      SA_PUBTASK=$80000031,
      SA_AUTOSCROLL=$80000039,
      AUTOSCROLL=$4000,
      SPOS_ABSOLUTE=1,
      OSERR_NOMEM=3,
      OSERR_ATTACHFAIL=8,
      NS_EXTENDED=$1000,
      SA_DISPLAYID=$80000032,
      SA_MINIMIZEISG=$80000049,
      SA_QUIET=$80000038,
      SCREENQUIET=$100,
      SA_VIDEOCONTROL=$80000044,
      SDEPTH_INFAMILY=2,
      SA_INTERLEAVED=$80000042,
      HIGHLIGHTTEXTPEN=8,
      BACKGROUNDPEN=7,
      FILLTEXTPEN=6,
      TEXTPEN=2,
      OSERR_NOCHIPS=2,
      PEN_C0=$FEFF,
      PEN_C1=$FEFE,
      PEN_C2=$FEFD,
      PEN_C3=$FEFC,
      SDEPTH_TOFRONT=0,
      OSERR_NOTAVAILABLE=9,
      SA_DRAGGABLE=$8000003E,
      SA_PUBSIG=$80000030,
      SA_COLORS=$80000029,
      SPOS_FORCEDRAG=4,
      BARTRIMPEN=11,
      OSCAN_TEXT=1,
      SA_OBSOLETE1=$80000035,
      PENSHARED=$400,
      SA_SHOWTITLE=$80000036,
      SA_TITLE=$80000028,
      SHOWTITLE=16,
      SHANGHAI=1,
      SHADOWPEN=4,
      SA_BLOCKPEN=$80000027,
      BARBLOCKPEN=10,
      BLOCKPEN=1,
      OSERR_NOCHIPMEM=4,
      BEEPING=$20,
      SA_COLORS32=$80000043,
      SA_PARENT=$8000003D,
      SA_EXCLUSIVE=$8000003F,
      SA_TOP=$80000022,
      SPOS_MAKEVISIBLE=2,
      SA_FULLPALETTE=$8000003B,
      OSERR_UNKNOWNMODE=6,
      SA_LIKEWORKBENCH=$80000047,
      SA_HEIGHT=$80000024,
      STDSCREENHEIGHT=-1,
      SA_RESERVED=$80000048,
      SHINEPEN=3,
      SA_BACKCHILD=$80000046,
      SA_FRONTCHILD=$80000045,
      OSERR_PUBNOTUNIQUE=5,
      SA_LEFT=$80000021,
      SDEPTH_CHILDONLY=2,
      OSERR_NOMONITOR=1,
      SA_SHAREPENS=$80000040,
      SA_PENS=$8000003A,
      NUMDRIPENS=12,
      OSCAN_VIDEO=4,
      SA_OVERSCAN=$80000034,
      SCREENHIRES=$200,
      SA_DEPTH=$80000025,
      SA_BEHIND=$80000037,
      SCREENBEHIND=$80,
      DRIB_NEWLOOK=0,
      DRIF_NEWLOOK=1,
      SA_WIDTH=$80000023,
      STDSCREENWIDTH=-1,
      OSCAN_MAX=3,
      SA_DCLIP=$80000033,
      SA_BACKFILL=$80000041,
      DRI_VERSION=2,
      SB_COPY_BITMAP=2,
      SB_SCREEN_BITMAP=1,
      SA_BITMAP=$8000002E,
      CUSTOMBITMAP=$40,
      OSERR_TOODEEP=7,
      MAXPUBSCREENNAME=$8B,
      SA_PUBNAME=$8000002F
@endnode
