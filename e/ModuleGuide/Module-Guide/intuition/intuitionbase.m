@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "intuition/intuitionbase.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT intuitionbase
@{fg shine}(   0)@{fg text}   libnode:lib @{fg shine}(or ARRAY OF lib)@{fg text}
@{fg shine}(  34)@{fg text}   viewlord:view @{fg shine}(or ARRAY OF view)@{fg text}
@{fg shine}(  52)@{fg text}   activewindow:PTR TO window
@{fg shine}(  56)@{fg text}   activescreen:PTR TO screen
@{fg shine}(  60)@{fg text}   firstscreen:PTR TO screen
@{fg shine}(  64)@{fg text}   flags:LONG
@{fg shine}(  68)@{fg text}   mousey:INT
@{fg shine}(  70)@{fg text}   mousex:INT
@{fg shine}(  72)@{fg text}   seconds:LONG
@{fg shine}(  76)@{fg text}   micros:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=80 */

CONST EVENTMAX=10,
      LOWRESPICK=1,
      HIRESPICK=0,
      SDRAGGADGET=7,
      SDOWNBACKGADGET=6,
      SUPFRONTGADGET=5,
      DRAGGADGET=4,
      CLOSEGADGET=3,
      SIZEGADGET=2,
      DOWNBACKGADGET=1,
      UPFRONTGADGET=0,
      LOWRESGADGET=1,
      HIRESGADGET=0,
      GADGETCOUNT=8,
      RESCOUNT=2,
      DMODECOUNT=2
@endnode
