@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "graphics/gels.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT colltable
@{fg shine}(   0)@{fg text}   collptrs[16]:ARRAY OF LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=64 */

@{fg shine}(----)@{fg text} OBJECT dbp
@{fg shine}(   0)@{fg text}   bufy:INT
@{fg shine}(   2)@{fg text}   bufx:INT
@{fg shine}(   4)@{fg text}   bufpath:PTR TO vs
@{fg shine}(   8)@{fg text}   bufbuffer:PTR TO INT
@{fg shine}(  12)@{fg text}   bufplanes:PTR TO LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=16 */

@{fg shine}(----)@{fg text} OBJECT ao
@{fg shine}(   0)@{fg text}   nextob:PTR TO ao
@{fg shine}(   4)@{fg text}   prevob:PTR TO ao
@{fg shine}(   8)@{fg text}   clock:LONG
@{fg shine}(  12)@{fg text}   anoldy:INT
@{fg shine}(  14)@{fg text}   anoldx:INT
@{fg shine}(  16)@{fg text}   any:INT
@{fg shine}(  18)@{fg text}   anx:INT
@{fg shine}(  20)@{fg text}   yvel:INT
@{fg shine}(  22)@{fg text}   xvel:INT
@{fg shine}(  24)@{fg text}   xaccel:INT
@{fg shine}(  26)@{fg text}   yaccel:INT
@{fg shine}(  28)@{fg text}   ringytrans:INT
@{fg shine}(  30)@{fg text}   ringxtrans:INT
@{fg shine}(  32)@{fg text}   animoroutine:LONG
@{fg shine}(  36)@{fg text}   headcomp:PTR TO ac
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=40 */

@{fg shine}(----)@{fg text} OBJECT ac
@{fg shine}(   0)@{fg text}   compflags:INT
@{fg shine}(   2)@{fg text}   timer:INT
@{fg shine}(   4)@{fg text}   timeset:INT
@{fg shine}(   6)@{fg text}   nextcomp:PTR TO ac
@{fg shine}(  10)@{fg text}   prevcomp:PTR TO ac
@{fg shine}(  14)@{fg text}   nextseq:PTR TO ac
@{fg shine}(  18)@{fg text}   prevseq:PTR TO ac
@{fg shine}(  22)@{fg text}   animcroutine:LONG
@{fg shine}(  26)@{fg text}   ytrans:INT
@{fg shine}(  28)@{fg text}   xtrans:INT
@{fg shine}(  30)@{fg text}   headob:PTR TO ao
@{fg shine}(  34)@{fg text}   animbob:PTR TO bob
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=38 */

@{fg shine}(----)@{fg text} OBJECT bob
@{fg shine}(   0)@{fg text}   bobflags:INT
@{fg shine}(   2)@{fg text}   savebuffer:PTR TO INT
@{fg shine}(   6)@{fg text}   imageshadow:PTR TO INT
@{fg shine}(  10)@{fg text}   before:PTR TO bob
@{fg shine}(  14)@{fg text}   after:PTR TO bob
@{fg shine}(  18)@{fg text}   bobvsprite:PTR TO vs
@{fg shine}(  22)@{fg text}   bobcomp:PTR TO ac
@{fg shine}(  26)@{fg text}   dbuffer:PTR TO dbp
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=30 */

@{fg shine}(----)@{fg text} OBJECT vs
@{fg shine}(   0)@{fg text}   nextvsprite:PTR TO vs
@{fg shine}(   4)@{fg text}   prevvsprite:PTR TO vs
@{fg shine}(   8)@{fg text}   drawpath:PTR TO vs
@{fg shine}(  12)@{fg text}   clearpath:PTR TO vs
@{fg shine}(  16)@{fg text}   oldy:INT
@{fg shine}(  18)@{fg text}   oldx:INT
@{fg shine}(  20)@{fg text}   vsflags:INT
@{fg shine}(  22)@{fg text}   y:INT
@{fg shine}(  24)@{fg text}   x:INT
@{fg shine}(  26)@{fg text}   height:INT
@{fg shine}(  28)@{fg text}   width:INT
@{fg shine}(  30)@{fg text}   depth:INT
@{fg shine}(  32)@{fg text}   memask:INT
@{fg shine}(  34)@{fg text}   hitmask:INT
@{fg shine}(  36)@{fg text}   imagedata:PTR TO INT
@{fg shine}(  40)@{fg text}   borderline:PTR TO INT
@{fg shine}(  44)@{fg text}   collmask:PTR TO INT
@{fg shine}(  48)@{fg text}   sprcolors:PTR TO INT
@{fg shine}(  52)@{fg text}   vsbob:PTR TO bob
@{fg shine}(  56)@{fg text}   planepick:CHAR
@{fg shine}(  57)@{fg text}   planeonoff:CHAR
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=58 */

CONST BF_BOBNIX=$800,
      ANIMHALF=$20,
      VSF_VSPRITE=1,
      B2SWAP=1,
      VSF_SAVEBACK=2,
      B2NORM=0,
      VSF_BOBUPDATE=$200,
      BF_SAVEBOB=1,
      BF_BWAITING=$100,
      VSF_BACKSAVED=$100,
      BF_BOBSAWAY=$400,
      VSF_GELGONE=$400,
      BF_SAVEPRESERVE=$1000,
      VSF_VSOVERFLOW=$800,
      VSF_MUSTDRAW=8,
      B2BOBBER=2,
      RINGTRIGGER=1,
      BF_BDRAWN=$200,
      BF_BOBISCOMP=2,
      BF_OUTSTEP=$2000,
      ANFRACSIZE=6,
      VSF_OVERLAY=4,
      BUSERFLAGS=$FF,
      SUSERFLAGS=$FF

#define RemBob/1
#define InitAnimate/1
@endnode
