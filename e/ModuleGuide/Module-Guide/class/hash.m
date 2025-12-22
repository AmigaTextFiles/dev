@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "e:modules/class/hash.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

/* this module contains 760 bytes of code! */

/* ... and 3 reloc entries */

@{fg shine}(----)@{fg text} OBJECT hashlink
@{fg shine}(   4)@{fg text}   data:LONG
@{fg shine}(   8)@{fg text}   len:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=12 */

@{fg shine}(----)@{fg text} OBJECT hashtable
         hashtable@{fg shine}(a)@{fg text}
         end@{fg shine}()@{fg text}
         end_links@{fg shine}(a)@{fg text}
         find@{fg shine}(a,b)@{fg text}
         add@{fg shine}(a,b,c,d)@{fg text}
         iterate@{fg shine}(a)@{fg text}
         calc_hash_spread@{fg shine}()@{fg text}
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=12 */

CONST HASH_MEDIUM=$3AD,
      HASH_NORMAL=$D3,
      HASH_HEAVIER=$3F8B,
      HASH_HEAVY=$F47
@endnode
