@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "graphics/displayinfo.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT vecinfo
@{fg shine}(   0)@{fg text}   qh:qh @{fg shine}(or ARRAY OF qh)@{fg text}
@{fg shine}(  16)@{fg text}   vec:LONG
@{fg shine}(  20)@{fg text}   data:LONG
@{fg shine}(  24)@{fg text}   type:INT
@{fg shine}(  26)@{fg text}   pad[3]:ARRAY OF INT
@{fg shine}(  32)@{fg text}   reserved[2]:ARRAY OF LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=40 */

@{fg shine}(----)@{fg text} OBJECT nameinfo
@{fg shine}(   0)@{fg text}   qh:qh @{fg shine}(or ARRAY OF qh)@{fg text}
@{fg shine}(  16)@{fg text}   name[32]:ARRAY OF CHAR
@{fg shine}(  48)@{fg text}   reserved[2]:ARRAY OF LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=56 */

@{fg shine}(----)@{fg text} OBJECT monitorinfo
@{fg shine}(   0)@{fg text}   qh:qh @{fg shine}(or ARRAY OF qh)@{fg text}
@{fg shine}(  16)@{fg text}   mspc:PTR TO monitorspec
@{fg shine}(  20)@{fg text}   viewposition:tpoint @{fg shine}(or ARRAY OF tpoint)@{fg text}
@{fg shine}(  24)@{fg text}   viewresolution:tpoint @{fg shine}(or ARRAY OF tpoint)@{fg text}
@{fg shine}(  28)@{fg text}   viewpositionrange:rectangle @{fg shine}(or ARRAY OF rectangle)@{fg text}
@{fg shine}(  36)@{fg text}   totalrows:INT
@{fg shine}(  38)@{fg text}   totalcolorclocks:INT
@{fg shine}(  40)@{fg text}   minrow:INT
@{fg shine}(  42)@{fg text}   compatibility:INT
@{fg shine}(  44)@{fg text}   pad[32]:ARRAY OF CHAR
@{fg shine}(  76)@{fg text}   mousetick:tpoint @{fg shine}(or ARRAY OF tpoint)@{fg text}
@{fg shine}(  80)@{fg text}   defaultviewposition:tpoint @{fg shine}(or ARRAY OF tpoint)@{fg text}
@{fg shine}(  84)@{fg text}   preferredmodeid:LONG
@{fg shine}(  88)@{fg text}   reserved[2]:ARRAY OF LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=96 */

@{fg shine}(----)@{fg text} OBJECT dimensioninfo
@{fg shine}(   0)@{fg text}   qh:qh @{fg shine}(or ARRAY OF qh)@{fg text}
@{fg shine}(  16)@{fg text}   maxdepth:INT
@{fg shine}(  18)@{fg text}   minrasterwidth:INT
@{fg shine}(  20)@{fg text}   minrasterheight:INT
@{fg shine}(  22)@{fg text}   maxrasterwidth:INT
@{fg shine}(  24)@{fg text}   maxrasterheight:INT
@{fg shine}(  26)@{fg text}   nominal:rectangle @{fg shine}(or ARRAY OF rectangle)@{fg text}
@{fg shine}(  34)@{fg text}   maxoscan:rectangle @{fg shine}(or ARRAY OF rectangle)@{fg text}
@{fg shine}(  42)@{fg text}   videooscan:rectangle @{fg shine}(or ARRAY OF rectangle)@{fg text}
@{fg shine}(  50)@{fg text}   txtoscan:rectangle @{fg shine}(or ARRAY OF rectangle)@{fg text}
@{fg shine}(  58)@{fg text}   stdoscan:rectangle @{fg shine}(or ARRAY OF rectangle)@{fg text}
@{fg shine}(  66)@{fg text}   pad[14]:ARRAY OF CHAR
@{fg shine}(  80)@{fg text}   reserved[2]:ARRAY OF LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=88 */

@{fg shine}(----)@{fg text} OBJECT displayinfo
@{fg shine}(   0)@{fg text}   qh:qh @{fg shine}(or ARRAY OF qh)@{fg text}
@{fg shine}(  16)@{fg text}   notavailable:INT
@{fg shine}(  18)@{fg text}   propertyflags:LONG
@{fg shine}(  22)@{fg text}   resolution:tpoint @{fg shine}(or ARRAY OF tpoint)@{fg text}
@{fg shine}(  26)@{fg text}   pixelspeed:INT
@{fg shine}(  28)@{fg text}   numstdsprites:INT
@{fg shine}(  30)@{fg text}   paletterange:INT
@{fg shine}(  32)@{fg text}   spriteresolution:tpoint @{fg shine}(or ARRAY OF tpoint)@{fg text}
@{fg shine}(  36)@{fg text}   pad[4]:ARRAY OF CHAR
@{fg shine}(  40)@{fg text}   redbits:CHAR
@{fg shine}(  41)@{fg text}   greenbits:CHAR
@{fg shine}(  42)@{fg text}   bluebits:CHAR
@{fg shine}(  43)@{fg text}   pad2a:CHAR
@{fg shine}(  44)@{fg text}   pad2b[4]:ARRAY OF CHAR
@{fg shine}(  48)@{fg text}   reserved[2]:ARRAY OF LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=56 */

@{fg shine}(----)@{fg text} OBJECT qh
@{fg shine}(   0)@{fg text}   structid:LONG
@{fg shine}(   4)@{fg text}   displayid:LONG
@{fg shine}(   8)@{fg text}   skipid:LONG
@{fg shine}(  12)@{fg text}   length:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=16 */

CONST DIPF_IS_DBUFFER=$100000,
      MCOMPAT_MIXED=0,
      DIPF_IS_SCANDBL=$20000,
      DIPF_IS_EXTRAHALFBRITE=$1000,
      DIPF_IS_SPRITES_CHNG_PRI=$80000,
      DIPF_IS_SPRITES_ATT=$2000,
      DIPF_IS_GENLOCK=$80,
      DI_AVAIL_NOTWITHGENLOCK=4,
      DIPF_IS_BEAMSYNC=$800,
      DIPF_IS_HAM=8,
      DTAG_DIMS=$80001000,
      DIPF_IS_SPRITES=$40,
      DIPF_IS_SPRITES_CHNG_BASE=$40000,
      DIPF_IS_AA=$10000,
      DI_AVAIL_NOCHIPS=1,
      DIPF_IS_DRAGGABLE=$200,
      DIPF_IS_FOREIGN=$80000000,
      DIPF_IS_PF2PRI=4,
      DISPLAYNAMELEN=$20,
      DTAG_VEC=$80004000,
      DIPF_IS_DUALPF=2,
      DIPF_IS_LACE=1,
      DIPF_IS_SPRITES_CHNG_RES=$4000,
      DIPF_IS_PANELLED=$400,
      DTAG_MNTR=$80002000,
      DIPF_IS_ECS=16,
      DI_AVAIL_NOMONITOR=2,
      MCOMPAT_SELF=1,
      DIPF_IS_PROGBEAM=$200000,
      MCOMPAT_NOBODY=-1,
      DTAG_DISP=$80000000,
      DIPF_IS_PAL=$20,
      DIPF_IS_SPRITES_BORDER=$8000,
      DTAG_NAME=$80003000,
      DIPF_IS_WB=$100
@endnode
