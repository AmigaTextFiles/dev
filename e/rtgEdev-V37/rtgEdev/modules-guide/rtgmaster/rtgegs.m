ShowModule v1.10 (c) 1992 $#%!
now showing: "rtgegs.m"
NOTE: don't use this output in your code, use the module instead.

(----) OBJECT rtgscreenegs
(   0)   header:PTR TO rtgscreen
(   4)   myscreen:INT
(   6)   activemap:LONG
(  10)   mapa:INT
(  12)   mapb:INT
(  14)   mapc:INT
(  16)   frontmap:INT
(  18)   bytes:LONG
(  22)   width:LONG
(  26)   type:LONG
(  30)   numbuf:LONG
(  34)   locks:INT
(  36)   rastport1:INT
(  38)   rastport2:INT
(  40)   rastport3:INT
(  42)   pointer[28]:ARRAY OF CHAR
(  70)   pointera[256]:ARRAY OF CHAR
( 326)   pointerb[1024]:ARRAY OF CHAR
(1350)   pointerc[28]:ARRAY OF CHAR
(1378)   portdata:PTR TO myport
(----) ENDOBJECT     /* SIZEOF=1382 */

(----) OBJECT myport
(   0)   port:PTR TO mp
(   4)   signal:LONG
(   8)   mousex:INT
(  10)   mousey:INT
(----) ENDOBJECT     /* SIZEOF=12 */

(----) OBJECT rtgbaseegs
(   0)   egslibbase:PTR TO lib
(   4)   pad1:INT
(   6)   seglist:LONG
(  10)   execbase:INT
(  12)   utilitybase:INT
(  14)   dosbase:INT
(  16)   egsbase:INT
(  18)   egsblitbase:INT
(  20)   gfxbase:INT
(  22)   flags:LONG
(  26)   egsgfxbase:INT
(  28)   expansionbase:INT
(----) ENDOBJECT     /* SIZEOF=30 */

