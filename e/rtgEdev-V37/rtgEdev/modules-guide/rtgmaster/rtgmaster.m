ShowModule v1.10 (c) 1992 $#%!
now showing: "rtgmaster.m"
NOTE: don't use this output in your code, use the module instead.

(----) OBJECT rtgbobhandle
(   0)   bufsize:LONG
(   4)   rtgscreen:PTR TO rtgscreen
(   8)   refreshbuffer:INT
(  10)   bpr:LONG
(  14)   width:LONG
(  18)   height:LONG
(  22)   numsprites:INT
(  24)   maxnum:INT
(  26)   reserved:LONG
(----) ENDOBJECT     /* SIZEOF=30 */

(----) OBJECT rtglibs
(   0)   next:INT
(   2)   id:LONG
(   6)   libbase:INT
(   8)   smlist:INT
(  10)   lastsm:INT
(  12)   libversion:INT
(----) ENDOBJECT     /* SIZEOF=14 */

(----) OBJECT rtgmasterbase
(   0)   base:PTR TO lib
(   4)   pad:INT
(   6)   seglist:LONG
(  10)   dosbase:INT
(  12)   execbase:INT
(  14)   gadtoolsbase:INT
(  16)   gfxbase:INT
(  18)   intbase:INT
(  20)   utilitybase:INT
(  22)   track[8]:ARRAY OF CHAR
(  30)   libraries:PTR TO rtglibs
(  34)   firstscreenmode:INT
(  36)   linkerdb:INT
(----) ENDOBJECT     /* SIZEOF=38 */

(----) OBJECT rdcmpdata
(   0)   port:PTR TO mp
(   4)   signal:LONG
(   8)   mousex:INT
(  10)   mousey:INT
(----) ENDOBJECT     /* SIZEOF=12 */

CONST SMR_PLANARSUPPORT=$8000000A,
      SMR_CHUNKYSUPPORT=$80000009,
      SMR_DUMMY=$80000000,
      SMR_SCREEN=$8000001B,
      SMR_MAXPIXELASPECT=$8000001E,
      SMR_MINPIXELASPECT=$8000001D,
      SMR_FORCEOPEN=$80000017,
      SMR_WINDOWTOPEDGE=$8000001A,
      SMR_WINDOWLEFTEDGE=$80000019,
      SMR_TITLETEXT=$80000018,
      SMR_INITIALDEFAULTH=$80000015,
      SMR_INITIALDEFAULTW=$80000014,
      SMR_INITIALSCREENMODE=$80000013,
      SMR_PROGRAMUSESC2P=$8000000C,
      SMR_WORKBENCH=$8000001F,
      SMR_INITIALHEIGHT=$80000011,
      SMR_MAXHEIGHT=$80000004,
      SMR_MINHEIGHT=$80000003,
      SMR_CHUNKYROUNDH=$80000008,
      SMR_PLANARROUNDH=$80000006,
      SMR_BUFFERS=$8000000B,
      SMR_INITIALDEPTH=$80000012,
      SMR_CHUNKYROUNDW=$80000007,
      SMR_PLANARROUNDW=$80000005,
      SMR_INITIALWIDTH=$80000010,
      SMR_MAXWIDTH=$80000002,
      SMR_MINWIDTH=$80000001,
      SMR_PUBSCREENNAME=$8000001C,
      SMR_PREFSFILENAME=$80000016

