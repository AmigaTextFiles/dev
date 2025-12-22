ShowModule v1.10 (c) 1992 $#%!
now showing: "ppc.m"
NOTE: don't use this output in your code, use the module instead.

(----) OBJECT taskhookmsg_set
(   0)   methodid:LONG
(   4)   version:LONG
(   8)   tags:PTR TO tagitem
(----) ENDOBJECT     /* SIZEOF=12 */

(----) OBJECT taskhookmsg_get
(   0)   methodid:LONG
(   4)   version:LONG
(   8)   tags:PTR TO tagitem
(----) ENDOBJECT     /* SIZEOF=12 */

(----) OBJECT taskhookmsg_delete
(   0)   methodid:LONG
(   4)   version:LONG
(----) ENDOBJECT     /* SIZEOF=8 */

(----) OBJECT taskhookmsg_create
(   0)   methodid:LONG
(   4)   version:LONG
(   8)   elfobject:CHAR
(  10)   tags:PTR TO tagitem
(----) ENDOBJECT     /* SIZEOF=14 */

CONST PPCINFOTAG_CPUPLL=$8001F008,
      CPU_603e=6,
      CPU_603p=7,
      CPU_604e=9,
      PPCINFOTAG_CPUREV=$8001F004,
      PPCINFOTAG_CPUCLOCK=$8001F003,
      PPCINFOTAG_CPU=$8001F001,
      PPCTASKHOOKMETHOD_GET=2,
      PPCINFOTAG_Dummy=$8001F000,
      PPCTASKHOOKMETHOD_CREATE=0,
      PPCTASKHOOKMETHOD_DELETE=1,
      PPCINFOTAG_CPUCOUNT=$8001F002,
      PPCINFOTAG_REMTASKHOOK=$8001F007,
      PPCINFOTAG_TASKHOOK=$8001F006,
      PPCINFOTAG_EXCEPTIONHOOK=$8001F005,
      PPCTASKHOOKMETHOD_SET=3,
      CPU_602=5,
      CPU_603=3,
      CPU_604=4

