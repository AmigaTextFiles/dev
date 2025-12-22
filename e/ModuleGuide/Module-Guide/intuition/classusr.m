@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "intuition/classusr.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT opremmember
@{fg shine}(   0)@{fg text}   methodid:LONG
@{fg shine}(   4)@{fg text}   object:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=8 */

@{fg shine}(----)@{fg text} OBJECT opaddmember
@{fg shine}(   0)@{fg text}   methodid:LONG
@{fg shine}(   4)@{fg text}   object:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=8 */

@{fg shine}(----)@{fg text} OBJECT opmember
@{fg shine}(   0)@{fg text}   methodid:LONG
@{fg shine}(   4)@{fg text}   object:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=8 */

@{fg shine}(----)@{fg text} OBJECT opaddtail
@{fg shine}(   0)@{fg text}   methodid:LONG
@{fg shine}(   4)@{fg text}   list:PTR TO lh
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=8 */

@{fg shine}(----)@{fg text} OBJECT opget
@{fg shine}(   0)@{fg text}   methodid:LONG
@{fg shine}(   4)@{fg text}   attrid:LONG
@{fg shine}(   8)@{fg text}   storage:PTR TO LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=12 */

@{fg shine}(----)@{fg text} OBJECT opnotify
@{fg shine}(   0)@{fg text}   methodid:LONG
@{fg shine}(   4)@{fg text}   attrlist:PTR TO tagitem
@{fg shine}(   8)@{fg text}   ginfo:PTR TO gadgetinfo
@{fg shine}(  12)@{fg text}   flags:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=16 */

@{fg shine}(----)@{fg text} OBJECT opupdate
@{fg shine}(   0)@{fg text}   methodid:LONG
@{fg shine}(   4)@{fg text}   attrlist:PTR TO tagitem
@{fg shine}(   8)@{fg text}   ginfo:PTR TO gadgetinfo
@{fg shine}(  12)@{fg text}   flags:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=16 */

@{fg shine}(----)@{fg text} OBJECT opset
@{fg shine}(   0)@{fg text}   methodid:LONG
@{fg shine}(   4)@{fg text}   attrlist:PTR TO tagitem
@{fg shine}(   8)@{fg text}   ginfo:PTR TO gadgetinfo
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=12 */

@{fg shine}(----)@{fg text} OBJECT opnew
@{fg shine}(   0)@{fg text}   methodid:LONG
@{fg shine}(   4)@{fg text}   attrlist:PTR TO tagitem
@{fg shine}(   8)@{fg text}   ginfo:PTR TO gadgetinfo
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=12 */

@{fg shine}(----)@{fg text} OBJECT msg
@{fg shine}(   0)@{fg text}   methodid:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=4 */

CONST OM_REMOVE=$106,
      OM_DISPOSE=$102,
      OM_UPDATE=$108,
      OM_GET=$104,
      OM_ADDTAIL=$105,
      OPUF_INTERIM=1,
      OPUB_INTERIM=0,
      OM_NEW=$101,
      OM_REMMEMBER=$10A,
      OM_ADDMEMBER=$109,
      OM_SET=$103,
      OM_NOTIFY=$107

#define POINTERCLASS/0
#define ITEXTICLASS/0
#define MODELCLASS/0
#define ICCLASS/0
#define GROUPGCLASS/0
#define FRBUTTONCLASS/0
#define BUTTONGCLASS/0
#define STRGCLASS/0
#define PROPGCLASS/0
#define GADGETCLASS/0
#define FILLRECTCLASS/0
#define SYSICLASS/0
#define FRAMEICLASS/0
#define IMAGECLASS/0
#define ROOTCLASS/0
@endnode
