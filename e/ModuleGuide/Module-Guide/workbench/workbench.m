@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "workbench/workbench.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT appmenuitem
@{fg shine}(   0)@{fg text}   private:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=4 */

@{fg shine}(----)@{fg text} OBJECT appicon
@{fg shine}(   0)@{fg text}   private:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=4 */

@{fg shine}(----)@{fg text} OBJECT appwindow
@{fg shine}(   0)@{fg text}   private:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=4 */

@{fg shine}(----)@{fg text} OBJECT appmessage
@{fg shine}(   0)@{fg text}   message:mn @{fg shine}(or ARRAY OF mn)@{fg text}
@{fg shine}(  20)@{fg text}   type:INT
@{fg shine}(  22)@{fg text}   userdata:LONG
@{fg shine}(  26)@{fg text}   id:LONG
@{fg shine}(  30)@{fg text}   numargs:LONG
@{fg shine}(  34)@{fg text}   arglist:PTR TO wbarg
@{fg shine}(  38)@{fg text}   version:INT
@{fg shine}(  40)@{fg text}   class:INT
@{fg shine}(  42)@{fg text}   mousex:INT
@{fg shine}(  44)@{fg text}   mousey:INT
@{fg shine}(  46)@{fg text}   seconds:LONG
@{fg shine}(  50)@{fg text}   micros:LONG
@{fg shine}(  54)@{fg text}   reserved[8]:ARRAY OF LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=86 */

@{fg shine}(----)@{fg text} OBJECT freelist
@{fg shine}(   0)@{fg text}   numfree:INT
@{fg shine}(   2)@{fg text}   memlist:lh @{fg shine}(or ARRAY OF lh)@{fg text}
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=16 */

@{fg shine}(----)@{fg text} OBJECT diskobject
@{fg shine}(   0)@{fg text}   magic:INT
@{fg shine}(   2)@{fg text}   version:INT
@{fg shine}(   4)@{fg text}   gadget:gadget @{fg shine}(or ARRAY OF gadget)@{fg text}
@{fg shine}(  48)@{fg text}   type:CHAR
@{fg shine}(  49)@{fg text}   pad_byte:CHAR
@{fg shine}(  50)@{fg text}   defaulttool:PTR TO CHAR
@{fg shine}(  54)@{fg text}   tooltypes:PTR TO LONG
@{fg shine}(  58)@{fg text}   currentx:LONG
@{fg shine}(  62)@{fg text}   currenty:LONG
@{fg shine}(  66)@{fg text}   drawerdata:PTR TO drawerdata
@{fg shine}(  70)@{fg text}   toolwindow:PTR TO CHAR
@{fg shine}(  74)@{fg text}   stacksize:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=78 */

@{fg shine}(----)@{fg text} OBJECT drawerdata
@{fg shine}(   0)@{fg text}   newwindow:nw @{fg shine}(or ARRAY OF nw)@{fg text}
@{fg shine}(  48)@{fg text}   currentx:LONG
@{fg shine}(  52)@{fg text}   currenty:LONG
@{fg shine}(  56)@{fg text}   flags:LONG
@{fg shine}(  60)@{fg text}   viewmodes:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=62 */

@{fg shine}(----)@{fg text} OBJECT olddrawerdata
@{fg shine}(   0)@{fg text}   newwindow:nw @{fg shine}(or ARRAY OF nw)@{fg text}
@{fg shine}(  48)@{fg text}   currentx:LONG
@{fg shine}(  52)@{fg text}   currenty:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=56 */

CONST AMTYPE_APPICON=8,
      WBAPPICON=8,
      AMTYPE_APPMENUITEM=9,
      WBTOOL=3,
      WB_DISKREVISIONMASK=$FF,
      WBPROJECT=4,
      NO_ICON_POSITION=$80000000,
      WBGARBAGE=5,
      WB_DISKMAGIC=$E310,
      WBDEVICE=6,
      WBKICK=7,
      WBDRAWER=2,
      AMTYPE_APPWINDOW=7,
      WBDISK=1,
      WORKBENCH_WORKBENCH_I=1,
      AM_VERSION=1,
      GADGBACKFILL=1,
      GFLG_GADGBACKFILL=1,
      WB_DISKREVISION=1,
      WB_DISKVERSION=1,
      DRAWERDATAFILESIZE=$3E,
      OLDDRAWERDATAFILESIZE=$38

#define WORKBENCH_NAME/0
@endnode
