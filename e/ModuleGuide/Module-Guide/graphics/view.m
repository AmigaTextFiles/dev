@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "graphics/view.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT dbufinfo
@{fg shine}(   0)@{fg text}   link1:LONG
@{fg shine}(   4)@{fg text}   count1:LONG
@{fg shine}(   8)@{fg text}   safemessage:mn @{fg shine}(or ARRAY OF mn)@{fg text}
@{fg shine}(  28)@{fg text}   userdata1:LONG
@{fg shine}(  32)@{fg text}   link2:LONG
@{fg shine}(  36)@{fg text}   count2:LONG
@{fg shine}(  40)@{fg text}   dispmessage:mn @{fg shine}(or ARRAY OF mn)@{fg text}
@{fg shine}(  60)@{fg text}   userdata2:LONG
@{fg shine}(  64)@{fg text}   matchlong:LONG
@{fg shine}(  68)@{fg text}   copptr1:LONG
@{fg shine}(  72)@{fg text}   copptr2:LONG
@{fg shine}(  76)@{fg text}   copptr3:LONG
@{fg shine}(  80)@{fg text}   beampos1:INT
@{fg shine}(  82)@{fg text}   beampos2:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=84 */

@{fg shine}(----)@{fg text} OBJECT rasinfo
@{fg shine}(   0)@{fg text}   next:PTR TO rasinfo
@{fg shine}(   4)@{fg text}   bitmap:PTR TO bitmap
@{fg shine}(   8)@{fg text}   rxoffset:INT
@{fg shine}(  10)@{fg text}   ryoffset:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=12 */

@{fg shine}(----)@{fg text} OBJECT viewportextra
@{fg shine}(   0)@{fg text}   xln:xln @{fg shine}(or ARRAY OF xln)@{fg text}
@{fg shine}(  24)@{fg text}   viewport:PTR TO viewport
@{fg shine}(  28)@{fg text}   displayclip:rectangle @{fg shine}(or ARRAY OF rectangle)@{fg text}
@{fg shine}(  36)@{fg text}   vectable:LONG
@{fg shine}(  40)@{fg text}   driverdata[2]:ARRAY OF LONG
@{fg shine}(  48)@{fg text}   flags:INT
@{fg shine}(  50)@{fg text}   origin:tpoint @{fg shine}(or ARRAY OF tpoint)@{fg text}
@{fg shine}(  58)@{fg text}   cop1ptr:LONG
@{fg shine}(  62)@{fg text}   cop2ptr:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=66 */

@{fg shine}(----)@{fg text} OBJECT viewextra
@{fg shine}(   0)@{fg text}   xln:xln @{fg shine}(or ARRAY OF xln)@{fg text}
@{fg shine}(  24)@{fg text}   view:PTR TO view
@{fg shine}(  28)@{fg text}   monitor:PTR TO monitorspec
@{fg shine}(  32)@{fg text}   topline:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=34 */

@{fg shine}(----)@{fg text} OBJECT view
@{fg shine}(   0)@{fg text}   viewport:PTR TO viewport
@{fg shine}(   4)@{fg text}   lofcprlist:PTR TO cprlist
@{fg shine}(   8)@{fg text}   shfcprlist:PTR TO cprlist
@{fg shine}(  12)@{fg text}   dyoffset:INT
@{fg shine}(  14)@{fg text}   dxoffset:INT
@{fg shine}(  16)@{fg text}   modes:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=18 */

@{fg shine}(----)@{fg text} OBJECT viewport
@{fg shine}(   0)@{fg text}   next:PTR TO viewport
@{fg shine}(   4)@{fg text}   colormap:PTR TO colormap
@{fg shine}(   8)@{fg text}   dspins:PTR TO coplist
@{fg shine}(  12)@{fg text}   sprins:PTR TO coplist
@{fg shine}(  16)@{fg text}   clrins:PTR TO coplist
@{fg shine}(  20)@{fg text}   ucopins:PTR TO ucoplist
@{fg shine}(  24)@{fg text}   dwidth:INT
@{fg shine}(  26)@{fg text}   dheight:INT
@{fg shine}(  28)@{fg text}   dxoffset:INT
@{fg shine}(  30)@{fg text}   dyoffset:INT
@{fg shine}(  32)@{fg text}   modes:INT
@{fg shine}(  34)@{fg text}   spritepriorities:CHAR
@{fg shine}(  35)@{fg text}   extendedmodes:CHAR
@{fg shine}(  36)@{fg text}   rasinfo:PTR TO rasinfo
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=40 */

@{fg shine}(----)@{fg text} OBJECT paletteextra
@{fg shine}(   0)@{fg text}   semaphore:ss @{fg shine}(or ARRAY OF ss)@{fg text}
@{fg shine}(  46)@{fg text}   firstfree:INT
@{fg shine}(  48)@{fg text}   nfree:INT
@{fg shine}(  50)@{fg text}   firstshared:INT
@{fg shine}(  52)@{fg text}   nshared:INT
@{fg shine}(  54)@{fg text}   refcnt:LONG
@{fg shine}(  58)@{fg text}   alloclist:LONG
@{fg shine}(  62)@{fg text}   viewport:PTR TO viewport
@{fg shine}(  66)@{fg text}   sharablecolors:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=68 */

@{fg shine}(----)@{fg text} OBJECT colormap
@{fg shine}(   0)@{fg text}   flags:CHAR
@{fg shine}(   1)@{fg text}   type:CHAR
@{fg shine}(   2)@{fg text}   count:INT
@{fg shine}(   4)@{fg text}   colortable:LONG
@{fg shine}(   8)@{fg text}   vpe:PTR TO viewportextra
@{fg shine}(  12)@{fg text}   lowcolorbits:LONG
@{fg shine}(  16)@{fg text}   transparencyplane:CHAR
@{fg shine}(  17)@{fg text}   spriteresolution:CHAR
@{fg shine}(  18)@{fg text}   spriteresdefault:CHAR
@{fg shine}(  19)@{fg text}   auxflags:CHAR
@{fg shine}(  20)@{fg text}   vp:PTR TO viewport
@{fg shine}(  24)@{fg text}   normaldisplayinfo:LONG
@{fg shine}(  28)@{fg text}   coercedisplayinfo:LONG
@{fg shine}(  32)@{fg text}   batch_items:PTR TO tagitem
@{fg shine}(  36)@{fg text}   vpmodeid:LONG
@{fg shine}(  40)@{fg text}   palextra:PTR TO paletteextra
@{fg shine}(  44)@{fg text}   spritebase_even:INT
@{fg shine}(  46)@{fg text}   spritebase_odd:INT
@{fg shine}(  48)@{fg text}   bp_0_base:INT
@{fg shine}(  50)@{fg text}   bp_1_base:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=52 */

CONST CMAB_NO_COLOR_LOAD=2,
      CMAF_NO_COLOR_LOAD=4,
      COLORMAP_TYPE_V36=1,
      COLORMAP_TYPE_V39=2,
      V_EXTRA_HALFBRITE=$80,
      VPB_A2024=6,
      VPF_A2024=$40,
      BORDER_BLANKING=4,
      MVP_NO_DISPLAY=4,
      PRECISION_ICON=16,
      COLORMAP_TYPE_V1_2=0,
      COLORMAP_TYPE_V1_4=1,
      VPB_TENHZ=4,
      VPF_TENHZ=16,
      MCOP_NO_MEM=1,
      MVP_NO_MEM=1,
      CMAB_NO_INTERMED_UPDATE=1,
      CMAF_NO_INTERMED_UPDATE=2,
      SPRITERESN_70NS=2,
      V_HAM=$800,
      CM_TRANSPARENYPLANE=16,
      V_PFBA=$40,
      BORDER_SPRITES=$40,
      V_SPRITES=$4000,
      MVP_NO_VPE=2,
      PRECISION_IMAGE=0,
      V_VP_HIDE=$2000,
      CMAB_DUALPF_DISABLE=8,
      CMAF_DUALPF_DISABLE=3,
      EXTEND_VSTRUCT=$1000,
      CMB_BRDNTRAN=3,
      CMF_BRDNTRAN=8,
      GENLOCK_AUDIO=$100,
      SPRITERESN_DEFAULT=-1,
      PRECISION_GUI=$20,
      VPXF_STRADDLES_256=16,
      VPXB_STRADDLES_256=4,
      PENB_NO_SETCOLOR=1,
      PENF_NO_SETCOLOR=2,
      PEN_NO_SETCOLOR=2,
      V_DUALPF=$400,
      V_LACE=4,
      SPRITERESN_35NS=3,
      PRECISION_EXACT=-1,
      PENB_EXCLUSIVE=0,
      PENF_EXCLUSIVE=1,
      PEN_EXCLUSIVE=1,
      MVP_NO_DSPINS=3,
      CMAB_FULLPALETTE=0,
      CMAF_FULLPALETTE=1,
      CMB_BRDRBLNK=2,
      CMF_BRDRBLNK=4,
      V_EXTENDED_MODE=$1000,
      MVP_OFF_BOTTOM=5,
      VIDEOCONTROL_BATCH=16,
      SPRITERESN_ECS=0,
      CMB_CPTRANS=1,
      CMB_CMTRANS=0,
      CMF_CPTRANS=2,
      CMF_CMTRANS=1,
      BORDER_NOTRANSPARENCY=8,
      COLORPLANE_TRANSPARENCY=2,
      COLORMAP_TRANSPARENCY=1,
      OBP_FAILIFBAD=$84000001,
      GENLOCK_VIDEO=2,
      V_HIRES=$8000,
      V_SUPERHIRES=$20,
      V_DOUBLESCAN=8,
      VPXF_STRADDLES_512=$20,
      VPXB_STRADDLES_512=5,
      VPXF_FREE_ME=1,
      VPXB_FREE_ME=0,
      VPXF_VP_LAST=2,
      VPXB_VP_LAST=1,
      CMB_BRDRSPRT=6,
      CMF_BRDRSPRT=$40,
      USER_COPPER_CLIP=$20,
      OBP_PRECISION=$84000000,
      MCOP_NOP=2,
      MCOP_OK=0,
      MVP_OK=0,
      SPRITERESN_140NS=1
@endnode
