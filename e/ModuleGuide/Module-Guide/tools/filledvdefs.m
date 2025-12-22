@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "tools/filledvdefs.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT matrix
@{fg shine}(   0)@{fg text}   matdata[10]:ARRAY OF INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=20 */

@{fg shine}(----)@{fg text} OBJECT face
@{fg shine}(   0)@{fg text}   cross0:INT
@{fg shine}(   2)@{fg text}   cross1:INT
@{fg shine}(   4)@{fg text}   cross2:INT
@{fg shine}(   6)@{fg text}   colour:INT
@{fg shine}(   8)@{fg text}   facelist:PTR TO INT
@{fg shine}(  12)@{fg text}   pad00:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=16 */

@{fg shine}(----)@{fg text} OBJECT vobject
@{fg shine}(   0)@{fg text}   next:LONG
@{fg shine}(   4)@{fg text}   prev:LONG
@{fg shine}(   8)@{fg text}   ax:INT
@{fg shine}(  10)@{fg text}   ay:INT
@{fg shine}(  12)@{fg text}   az:INT
@{fg shine}(  14)@{fg text}   px:INT
@{fg shine}(  16)@{fg text}   py:INT
@{fg shine}(  18)@{fg text}   pz:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=20 */

@{fg shine}(----)@{fg text} OBJECT position
@{fg shine}(   0)@{fg text}   ax:INT
@{fg shine}(   2)@{fg text}   ay:INT
@{fg shine}(   4)@{fg text}   az:INT
@{fg shine}(   6)@{fg text}   px:INT
@{fg shine}(   8)@{fg text}   py:INT
@{fg shine}(  10)@{fg text}   pz:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=12 */

CONST PCF_ZCLIP=1
@endnode
