ShowModule v1.10 (c) 1992 $#%!
now showing: "rtgami.m"
NOTE: don't use this output in your code, use the module instead.

(----) OBJECT rtgscreenami
(   0)   header:PTR TO rtgscreen
(   4)   locks:INT
(   6)   screenhandle:PTR TO screen
(  10)   planesize:LONG
(  14)   dispbuf:LONG
(  18)   chipmem1:LONG
(  22)   chipmem2:LONG
(  26)   chipmem3:LONG
(  30)   bitmap1:PTR TO bitmap
(  34)   bitmap2:PTR TO bitmap
(  38)   bitmap3:PTR TO bitmap
(  42)   flags:LONG
(  46)   myrect:PTR TO rectangle
(  50)   place[52]:ARRAY OF CHAR
( 102)   rastport1:PTR TO rastport
( 106)   rastport2:PTR TO rastport
( 110)   rastport3:PTR TO rastport
( 114)   mywindow:INT
( 116)   pointer:INT
( 118)   portdata:PTR TO myport
( 122)   dbufinfo:PTR TO dbufinfo
( 126)   dispbuf1:LONG
( 130)   dispbuf2:LONG
( 134)   dispbuf3:LONG
( 138)   safetowrite:LONG
( 142)   safetodisp:LONG
( 146)   srcmode:LONG
( 150)   tempras:INT
( 152)   tempbm:INT
( 154)   wbcolors:INT
( 156)   width:LONG
( 160)   height:LONG
( 164)   colchanged:LONG
( 168)   colarray1:INT
( 170)   ccol:INT
(----) ENDOBJECT     /* SIZEOF=172 */

(----) OBJECT myport
(   0)   port:PTR TO mp
(   4)   signal:LONG
(   8)   mousex:INT
(  10)   mousey:INT
(----) ENDOBJECT     /* SIZEOF=12 */

(----) OBJECT rtgbaseami
(   0)   libbase:PTR TO lib
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
(----) ENDOBJECT     /* SIZEOF=30 */

