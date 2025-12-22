@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "graphics/copper.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT copinit
@{fg shine}(   0)@{fg text}   vsync_hblank[2]:ARRAY OF INT
@{fg shine}(   4)@{fg text}   diagstrt[12]:ARRAY OF INT
@{fg shine}(  28)@{fg text}   fm0[2]:ARRAY OF INT
@{fg shine}(  32)@{fg text}   diwstart[10]:ARRAY OF INT
@{fg shine}(  52)@{fg text}   bplcon2[2]:ARRAY OF INT
@{fg shine}(  56)@{fg text}   sprfix[16]:ARRAY OF INT
@{fg shine}(  88)@{fg text}   sprstrtup[32]:ARRAY OF INT
@{fg shine}( 152)@{fg text}   wait14[2]:ARRAY OF INT
@{fg shine}( 156)@{fg text}   norm_hblank[2]:ARRAY OF INT
@{fg shine}( 160)@{fg text}   jump[2]:ARRAY OF INT
@{fg shine}( 164)@{fg text}   wait_forever[6]:ARRAY OF INT
@{fg shine}( 176)@{fg text}   sprstop[8]:ARRAY OF INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=192 */

@{fg shine}(----)@{fg text} OBJECT ucoplist
@{fg shine}(   0)@{fg text}   next:PTR TO ucoplist
@{fg shine}(   4)@{fg text}   firstcoplist:PTR TO coplist
@{fg shine}(   8)@{fg text}   coplist:PTR TO coplist
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=12 */

@{fg shine}(----)@{fg text} OBJECT coplist
@{fg shine}(   0)@{fg text}   next:PTR TO coplist
@{fg shine}(   4)@{fg text}   coplist_:PTR TO coplist
@{fg shine}(   8)@{fg text}   viewport_:PTR TO viewport
@{fg shine}(  12)@{fg text}   copins:PTR TO copins
@{fg shine}(  16)@{fg text}   copptr:PTR TO copins
@{fg shine}(  20)@{fg text}   coplstart:PTR TO INT
@{fg shine}(  24)@{fg text}   copsstart:PTR TO INT
@{fg shine}(  28)@{fg text}   count:INT
@{fg shine}(  30)@{fg text}   maxcount:INT
@{fg shine}(  32)@{fg text}   dyoffset:INT
@{fg shine}(  34)@{fg text}   slrepeat:INT
@{fg shine}(  36)@{fg text}   flags:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=38 */

@{fg shine}(----)@{fg text} OBJECT cprlist
@{fg shine}(   0)@{fg text}   next:PTR TO cprlist
@{fg shine}(   4)@{fg text}   start:PTR TO INT
@{fg shine}(   8)@{fg text}   maxcount:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=10 */

@{fg shine}(----)@{fg text} OBJECT copins
@{fg shine}(   0)@{fg text}   opcode:INT
@{fg shine}(   2)@{fg text}   nxtlist:PTR TO coplist
@{fg shine}(   2)@{fg text}   destaddr:INT
@{fg shine}(   2)@{fg text}   vwaitpos:INT
@{fg shine}(   4)@{fg text}   destdata:INT
@{fg shine}(   4)@{fg text}   hwaitpos:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=6 */

CONST COPPER_MOVE=0,
      CPR_NT_SHT=$4000,
      CPR_NT_SYS=$2000,
      CPR_NT_LOF=$8000,
      CPRNXTBUF=2,
      COPPER_WAIT=1,
      HALF_LINE=2,
      EXACT_LINE=1

#define DESTDATA/0
#define DESTADDR/0
#define HWAITPOS/0
#define VWAITPOS/0
@endnode
