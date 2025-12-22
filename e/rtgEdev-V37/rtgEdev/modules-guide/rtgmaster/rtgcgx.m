ShowModule v1.10 (c) 1992 $#%!
now showing: "rtgcgx.m"
NOTE: don't use this output in your code, use the module instead.

(----) OBJECT rtgscreencgx
(   0)   header:PTR TO rtgscreen
(   4)   myscreen:INT
(   6)   activemap:LONG
(  10)   mapa:INT
(  12)   mapb:INT
(  14)   mapc:INT
(  16)   frontmap:INT
(  18)   bytes:LONG
(  22)   width:LONG
(  26)   height:INT
(  28)   numbuf:LONG
(  32)   locks:INT
(  34)   modeid:LONG
(  38)   realmapa:PTR TO bitmap
(  42)   tags[6]:ARRAY OF CHAR
(  48)   offa:LONG
(  52)   offb:LONG
(  56)   offc:LONG
(  60)   mywindow:PTR TO window
(  64)   portdata:PTR TO myport
(  68)   bpr:LONG
(  72)   dbi:PTR TO dbufinfo
(  76)   safetowrite:LONG
(  80)   safetodisp:LONG
(  84)   special:LONG
(  88)   srcmode:LONG
(  92)   tempras:INT
(  94)   tempbm:INT
(  96)   wbcolors:INT
(  98)   colchanged:LONG
( 102)   ccol:LONG
( 106)   colarray1:INT
( 108)   colarray2:INT
(----) ENDOBJECT     /* SIZEOF=110 */

(----) OBJECT myport
(   0)   port:PTR TO mp
(   4)   signal:LONG
(   8)   mousex:INT
(  10)   mousey:INT
(----) ENDOBJECT     /* SIZEOF=12 */

(----) OBJECT rtgbasecgx
(   0)   cgxlibbase:PTR TO lib
(   4)   pad1:INT
(   6)   seglist:LONG
(  10)   execbase:INT
(  12)   utilitybase:INT
(  14)   dosbase:INT
(  16)   cgxbase:INT
(  18)   gfxbase:INT
(  20)   intbase:INT
(  22)   flags:LONG
(  26)   expansionbase:INT
(  28)   diskfontbase:INT
(  30)   linkerdb:INT
(----) ENDOBJECT     /* SIZEOF=32 */

