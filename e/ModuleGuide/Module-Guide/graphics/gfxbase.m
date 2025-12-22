@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "graphics/gfxbase.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT gfxbase
@{fg shine}(   0)@{fg text}   lib:lib @{fg shine}(or ARRAY OF lib)@{fg text}
@{fg shine}(  34)@{fg text}   actiview:PTR TO view
@{fg shine}(  38)@{fg text}   copinit:PTR TO copinit
@{fg shine}(  42)@{fg text}   cia:PTR TO LONG
@{fg shine}(  46)@{fg text}   blitter:PTR TO LONG
@{fg shine}(  50)@{fg text}   loflist:PTR TO INT
@{fg shine}(  54)@{fg text}   shflist:PTR TO INT
@{fg shine}(  58)@{fg text}   blthd:PTR TO bltnode
@{fg shine}(  62)@{fg text}   blttl:PTR TO bltnode
@{fg shine}(  66)@{fg text}   bsblthd:PTR TO bltnode
@{fg shine}(  70)@{fg text}   bsblttl:PTR TO bltnode
@{fg shine}(  74)@{fg text}   vbsrv:is @{fg shine}(or ARRAY OF is)@{fg text}
@{fg shine}(  96)@{fg text}   timsrv:is @{fg shine}(or ARRAY OF is)@{fg text}
@{fg shine}( 118)@{fg text}   bltsrv:is @{fg shine}(or ARRAY OF is)@{fg text}
@{fg shine}( 140)@{fg text}   textfonts:lh @{fg shine}(or ARRAY OF lh)@{fg text}
@{fg shine}( 154)@{fg text}   defaultfont:PTR TO textfont
@{fg shine}( 158)@{fg text}   modes:INT
@{fg shine}( 160)@{fg text}   vblank:CHAR
@{fg shine}( 161)@{fg text}   debug:CHAR
@{fg shine}( 162)@{fg text}   beamsync:INT
@{fg shine}( 164)@{fg text}   system_bplcon0:INT
@{fg shine}( 166)@{fg text}   spritereserved:CHAR
@{fg shine}( 167)@{fg text}   bytereserved:CHAR
@{fg shine}( 168)@{fg text}   flags:INT
@{fg shine}( 170)@{fg text}   blitlock:INT
@{fg shine}( 172)@{fg text}   blitnest:INT
@{fg shine}( 174)@{fg text}   blitwaitq:lh @{fg shine}(or ARRAY OF lh)@{fg text}
@{fg shine}( 188)@{fg text}   blitowner:PTR TO tc
@{fg shine}( 192)@{fg text}   tof_waitq:lh @{fg shine}(or ARRAY OF lh)@{fg text}
@{fg shine}( 206)@{fg text}   displayflags:INT
@{fg shine}( 208)@{fg text}   simplesprites:PTR TO LONG
@{fg shine}( 212)@{fg text}   maxdisplayrow:INT
@{fg shine}( 214)@{fg text}   maxdisplaycolumn:INT
@{fg shine}( 216)@{fg text}   normaldisplayrows:INT
@{fg shine}( 218)@{fg text}   normaldisplaycolumns:INT
@{fg shine}( 220)@{fg text}   normaldpmx:INT
@{fg shine}( 222)@{fg text}   normaldpmy:INT
@{fg shine}( 224)@{fg text}   lastchancememory:PTR TO ss
@{fg shine}( 228)@{fg text}   lcmptr:PTR TO INT
@{fg shine}( 232)@{fg text}   microsperline:INT
@{fg shine}( 234)@{fg text}   mindisplaycolumn:INT
@{fg shine}( 236)@{fg text}   chiprevbits0:CHAR
@{fg shine}( 237)@{fg text}   memtype:CHAR
@{fg shine}( 238)@{fg text}   crb_reserved[4]:ARRAY OF CHAR
@{fg shine}( 242)@{fg text}   monitor_id:INT
@{fg shine}( 244)@{fg text}   hedley[8]:ARRAY OF LONG
@{fg shine}( 276)@{fg text}   hedley_sprites[8]:ARRAY OF LONG
@{fg shine}( 308)@{fg text}   hedley_sprites1[8]:ARRAY OF LONG
@{fg shine}( 340)@{fg text}   hedley_count:INT
@{fg shine}( 342)@{fg text}   hedley_flags:INT
@{fg shine}( 344)@{fg text}   hedley_tmp:INT
@{fg shine}( 346)@{fg text}   hash_table:PTR TO LONG
@{fg shine}( 350)@{fg text}   current_tot_rows:INT
@{fg shine}( 352)@{fg text}   current_tot_cclks:INT
@{fg shine}( 354)@{fg text}   hedley_hint:CHAR
@{fg shine}( 355)@{fg text}   hedley_hint2:CHAR
@{fg shine}( 356)@{fg text}   nreserved[4]:ARRAY OF LONG
@{fg shine}( 372)@{fg text}   a2024_sync_raster:PTR TO LONG
@{fg shine}( 376)@{fg text}   control_delta_pal:INT
@{fg shine}( 378)@{fg text}   control_delta_ntsc:INT
@{fg shine}( 380)@{fg text}   current_monitor:PTR TO monitorspec
@{fg shine}( 384)@{fg text}   monitorlist:lh @{fg shine}(or ARRAY OF lh)@{fg text}
@{fg shine}( 398)@{fg text}   default_monitor:PTR TO monitorspec
@{fg shine}( 402)@{fg text}   monitorlistsemaphore:PTR TO ss
@{fg shine}( 406)@{fg text}   displayinfodatabase:LONG
@{fg shine}( 410)@{fg text}   topline:INT
@{fg shine}( 412)@{fg text}   activiewcprsemaphore:PTR TO ss
@{fg shine}( 416)@{fg text}   utilbase:PTR TO LONG
@{fg shine}( 420)@{fg text}   execbase:PTR TO LONG
@{fg shine}( 424)@{fg text}   bwshifts:PTR TO CHAR
@{fg shine}( 428)@{fg text}   strtfetchmasks:PTR TO INT
@{fg shine}( 432)@{fg text}   stopfetchmasks:PTR TO INT
@{fg shine}( 436)@{fg text}   overrun:PTR TO INT
@{fg shine}( 440)@{fg text}   realstops:PTR TO INT
@{fg shine}( 444)@{fg text}   spritewidth:INT
@{fg shine}( 446)@{fg text}   spritefmode:INT
@{fg shine}( 448)@{fg text}   softsprites:CHAR
@{fg shine}( 449)@{fg text}   arraywidth:CHAR
@{fg shine}( 450)@{fg text}   defaultspritewidth:INT
@{fg shine}( 452)@{fg text}   sprmovedisable:CHAR
@{fg shine}( 453)@{fg text}   wantchips:CHAR
@{fg shine}( 454)@{fg text}   boardmemtype:CHAR
@{fg shine}( 455)@{fg text}   bugs:CHAR
@{fg shine}( 456)@{fg text}   layersbase:PTR TO LONG
@{fg shine}( 460)@{fg text}   colormask:LONG
@{fg shine}( 464)@{fg text}   ivector:LONG
@{fg shine}( 468)@{fg text}   idata:LONG
@{fg shine}( 472)@{fg text}   specialcounter:LONG
@{fg shine}( 476)@{fg text}   dblist:LONG
@{fg shine}( 480)@{fg text}   monitorflags:INT
@{fg shine}( 482)@{fg text}   scandoubledsprites:CHAR
@{fg shine}( 483)@{fg text}   bp3bits:CHAR
@{fg shine}( 484)@{fg text}   monitorvblank:analogsignalinterval @{fg shine}(or ARRAY OF analogsignalinterval)@{fg text}
@{fg shine}( 488)@{fg text}   natural_monitor:PTR TO monitorspec
@{fg shine}( 492)@{fg text}   progdata:LONG
@{fg shine}( 496)@{fg text}   extsprites:CHAR
@{fg shine}( 497)@{fg text}   pad3:CHAR
@{fg shine}( 498)@{fg text}   gfxflags:INT
@{fg shine}( 500)@{fg text}   vbcounter:LONG
@{fg shine}( 504)@{fg text}   hashtablesemaphore:PTR TO ss
@{fg shine}( 508)@{fg text}   hwemul[9]:ARRAY OF LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=544 */

CONST LPEN_SWAP_FRAMES=$20,
      BUS_16=0,
      GENLOC=2,
      BANDWIDTH_2XDBL=2,
      BUS_32=1,
      DBL_CAS=2,
      NML_CAS=0,
      SETCHIPREV_BEST=-1,
      GENLOCN=1,
      BANDWIDTH_1X=0,
      NEW_DATABASE=1,
      GFXF_AA_ALICE=4,
      GFXB_AA_ALICE=2,
      GBFLAGSF_TIMER=$40,
      PAL=4,
      GFXF_HR_DENISE=2,
      GFXB_HR_DENISE=1,
      QBOWNERN=1,
      BLITMSG_FAULT=4,
      BANDWIDTH_4X=3,
      BANDWIDTH_2XNML=1,
      GFXF_AA_MLISA=16,
      GFXF_AA_LISA=8,
      GFXB_AA_MLISA=4,
      GFXB_AA_LISA=3,
      GBFLAGSF_LASTBLIT=$80,
      SETCHIPREV_AA=15,
      BLITMSG_FAULTN=2,
      GFXF_BIG_BLITS=1,
      GFXB_BIG_BLITS=0,
      NTSC=1,
      SETCHIPREV_A=1,
      QBOWNER=2,
      TODA_SAFE=8,
      SETCHIPREV_ECS=3,
      REALLY_PALN=4,
      PALN=2,
      NTSCN=0,
      REALLY_PAL=16,
      TODA_SAFEN=3,
      GFXF_HR_AGNUS=1,
      GFXB_HR_AGNUS=0,
      OWNBLITTERN=0

#define chunkytoplanarptr/0
#define GRAPHICSNAME/0
@endnode
