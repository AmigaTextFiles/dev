@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "devices/clipboard.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT cliphookmsg
@{fg shine}(   0)@{fg text}   type:LONG
@{fg shine}(   4)@{fg text}   changecmd:LONG
@{fg shine}(   8)@{fg text}   clipid:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=12 */

@{fg shine}(----)@{fg text} OBJECT satisfymsg
@{fg shine}(   0)@{fg text}   msg:mn @{fg shine}(or ARRAY OF mn)@{fg text}
@{fg shine}(  20)@{fg text}   unit:INT
@{fg shine}(  22)@{fg text}   clipid:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=26 */

@{fg shine}(----)@{fg text} OBJECT ioclipreq
@{fg shine}(   0)@{fg text}   message:mn @{fg shine}(or ARRAY OF mn)@{fg text}
@{fg shine}(  20)@{fg text}   device:PTR TO dd
@{fg shine}(  24)@{fg text}   unit:PTR TO clipboardunitpartial
@{fg shine}(  28)@{fg text}   command:INT
@{fg shine}(  30)@{fg text}   flags:CHAR
@{fg shine}(  31)@{fg text}   error:CHAR
@{fg shine}(  32)@{fg text}   actual:LONG
@{fg shine}(  36)@{fg text}   length:LONG
@{fg shine}(  40)@{fg text}   data:PTR TO CHAR
@{fg shine}(  44)@{fg text}   offset:LONG
@{fg shine}(  48)@{fg text}   clipid:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=52 */

@{fg shine}(----)@{fg text} OBJECT clipboardunitpartial
@{fg shine}(   0)@{fg text}   node:ln @{fg shine}(or ARRAY OF ln)@{fg text}
@{fg shine}(  14)@{fg text}   unitnum:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=18 */

CONST CBD_POST=9,
      CBERR_OBSOLETEID=1,
      CBD_CURRENTWRITEID=11,
      DEVICES_CLIPBOARD_I=1,
      CBD_CURRENTREADID=10,
      CBD_CHANGEHOOK=12,
      PRIMARY_CLIP=0
@endnode
