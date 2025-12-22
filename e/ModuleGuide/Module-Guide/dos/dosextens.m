@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "dos/dosextens.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT filelock
@{fg shine}(   0)@{fg text}   link:LONG
@{fg shine}(   4)@{fg text}   key:LONG
@{fg shine}(   8)@{fg text}   access:LONG
@{fg shine}(  12)@{fg text}   task:PTR TO mp
@{fg shine}(  16)@{fg text}   volume:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=20 */

@{fg shine}(----)@{fg text} OBJECT devproc
@{fg shine}(   0)@{fg text}   port:PTR TO mp
@{fg shine}(   4)@{fg text}   lock:LONG
@{fg shine}(   8)@{fg text}   flags:LONG
@{fg shine}(  12)@{fg text}   devnode:PTR TO doslist
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=16 */

@{fg shine}(----)@{fg text} OBJECT assignlist
@{fg shine}(   0)@{fg text}   next:PTR TO assignlist
@{fg shine}(   4)@{fg text}   lock:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=8 */

@{fg shine}(----)@{fg text} OBJECT doslist
@{fg shine}(   0)@{fg text}   next:LONG
@{fg shine}(   4)@{fg text}   type:LONG
@{fg shine}(   8)@{fg text}   task:PTR TO mp
@{fg shine}(  12)@{fg text}   lock:LONG
@{fg shine}(  16)@{fg text}   volumedate:datestamp @{fg shine}(or ARRAY OF datestamp)@{fg text}
@{fg shine}(  16)@{fg text}   handler:PTR TO CHAR
@{fg shine}(  16)@{fg text}   assignname:PTR TO CHAR
@{fg shine}(  20)@{fg text}   stacksize:LONG
@{fg shine}(  20)@{fg text}   list:PTR TO assignlist
@{fg shine}(  24)@{fg text}   priority:LONG
@{fg shine}(  28)@{fg text}   locklist:LONG
@{fg shine}(  28)@{fg text}   startup:LONG
@{fg shine}(  32)@{fg text}   disktype:LONG
@{fg shine}(  32)@{fg text}   seglist:LONG
@{fg shine}(  36)@{fg text}   globvec:LONG
@{fg shine}(  40)@{fg text}   name:PTR TO CHAR
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=44 */

@{fg shine}(----)@{fg text} OBJECT devinfo
@{fg shine}(   0)@{fg text}   next:LONG
@{fg shine}(   4)@{fg text}   type:LONG
@{fg shine}(   8)@{fg text}   task:LONG
@{fg shine}(  12)@{fg text}   lock:LONG
@{fg shine}(  16)@{fg text}   handler:PTR TO CHAR
@{fg shine}(  20)@{fg text}   stacksize:LONG
@{fg shine}(  24)@{fg text}   priority:LONG
@{fg shine}(  28)@{fg text}   startup:LONG
@{fg shine}(  32)@{fg text}   seglist:LONG
@{fg shine}(  36)@{fg text}   globvec:LONG
@{fg shine}(  40)@{fg text}   name:PTR TO CHAR
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=44 */

@{fg shine}(----)@{fg text} OBJECT devlist
@{fg shine}(   0)@{fg text}   next:LONG
@{fg shine}(   4)@{fg text}   type:LONG
@{fg shine}(   8)@{fg text}   task:PTR TO mp
@{fg shine}(  12)@{fg text}   lock:LONG
@{fg shine}(  16)@{fg text}   volumedate:datestamp @{fg shine}(or ARRAY OF datestamp)@{fg text}
@{fg shine}(  28)@{fg text}   locklist:LONG
@{fg shine}(  32)@{fg text}   disktype:LONG
@{fg shine}(  36)@{fg text}   unused:LONG
@{fg shine}(  40)@{fg text}   name:PTR TO CHAR
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=44 */

@{fg shine}(----)@{fg text} OBJECT commandlineinterface
@{fg shine}(   0)@{fg text}   result2:LONG
@{fg shine}(   4)@{fg text}   setname:PTR TO CHAR
@{fg shine}(   8)@{fg text}   commanddir:LONG
@{fg shine}(  12)@{fg text}   returncode:LONG
@{fg shine}(  16)@{fg text}   commandname:PTR TO CHAR
@{fg shine}(  20)@{fg text}   faillevel:LONG
@{fg shine}(  24)@{fg text}   prompt:PTR TO CHAR
@{fg shine}(  28)@{fg text}   standardinput:LONG
@{fg shine}(  32)@{fg text}   currentinput:LONG
@{fg shine}(  36)@{fg text}   commandfile:PTR TO CHAR
@{fg shine}(  40)@{fg text}   interactive:LONG
@{fg shine}(  44)@{fg text}   background:LONG
@{fg shine}(  48)@{fg text}   currentoutput:LONG
@{fg shine}(  52)@{fg text}   defaultstack:LONG
@{fg shine}(  56)@{fg text}   standardoutput:LONG
@{fg shine}(  60)@{fg text}   module:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=64 */

@{fg shine}(----)@{fg text} OBJECT segment
@{fg shine}(   0)@{fg text}   next:LONG
@{fg shine}(   4)@{fg text}   uc:LONG
@{fg shine}(   8)@{fg text}   seg:LONG
@{fg shine}(  12)@{fg text}   name[4]:ARRAY OF CHAR
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=16 */

@{fg shine}(----)@{fg text} OBJECT dosinfo
@{fg shine}(   0)@{fg text}   mcname:LONG
@{fg shine}(   4)@{fg text}   devinfo:LONG
@{fg shine}(   8)@{fg text}   devices:LONG
@{fg shine}(  12)@{fg text}   handlers:LONG
@{fg shine}(  16)@{fg text}   nethand:LONG
@{fg shine}(  20)@{fg text}   devlock:ss @{fg shine}(or ARRAY OF ss)@{fg text}
@{fg shine}(  66)@{fg text}   entrylock:ss @{fg shine}(or ARRAY OF ss)@{fg text}
@{fg shine}( 112)@{fg text}   deletelock:ss @{fg shine}(or ARRAY OF ss)@{fg text}
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=158 */

@{fg shine}(----)@{fg text} OBJECT cliproclist
@{fg shine}(   0)@{fg text}   node:mln @{fg shine}(or ARRAY OF mln)@{fg text}
@{fg shine}(   8)@{fg text}   first:LONG
@{fg shine}(  12)@{fg text}   array:PTR TO LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=16 */

@{fg shine}(----)@{fg text} OBJECT rootnode
@{fg shine}(   0)@{fg text}   taskarray:LONG
@{fg shine}(   4)@{fg text}   consolesegment:LONG
@{fg shine}(   8)@{fg text}   time:datestamp @{fg shine}(or ARRAY OF datestamp)@{fg text}
@{fg shine}(  20)@{fg text}   restartseg:LONG
@{fg shine}(  24)@{fg text}   info:LONG
@{fg shine}(  28)@{fg text}   filehandlersegment:LONG
@{fg shine}(  32)@{fg text}   clilist:mlh @{fg shine}(or ARRAY OF mlh)@{fg text}
@{fg shine}(  44)@{fg text}   bootproc:PTR TO mp
@{fg shine}(  48)@{fg text}   shellsegment:LONG
@{fg shine}(  52)@{fg text}   flags:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=56 */

@{fg shine}(----)@{fg text} OBJECT doslibrary
@{fg shine}(   0)@{fg text}   lib:lib @{fg shine}(or ARRAY OF lib)@{fg text}
@{fg shine}(  34)@{fg text}   root:PTR TO rootnode
@{fg shine}(  38)@{fg text}   gv:LONG
@{fg shine}(  42)@{fg text}   a2:LONG
@{fg shine}(  46)@{fg text}   a5:LONG
@{fg shine}(  50)@{fg text}   a6:LONG
@{fg shine}(  54)@{fg text}   errors:PTR TO errorstring
@{fg shine}(  58)@{fg text}   timereq:PTR TO timerequest
@{fg shine}(  62)@{fg text}   utilitybase:PTR TO lib
@{fg shine}(  66)@{fg text}   intuitionbase:PTR TO lib
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=70 */

@{fg shine}(----)@{fg text} OBJECT errorstring
@{fg shine}(   0)@{fg text}   nums:PTR TO LONG
@{fg shine}(   4)@{fg text}   strings:PTR TO CHAR
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=8 */

@{fg shine}(----)@{fg text} OBJECT standardpacket
@{fg shine}(   0)@{fg text}   msg:mn @{fg shine}(or ARRAY OF mn)@{fg text}
@{fg shine}(  20)@{fg text}   pkt:dospacket @{fg shine}(or ARRAY OF dospacket)@{fg text}
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=68 */

@{fg shine}(----)@{fg text} OBJECT dospacket
@{fg shine}(   0)@{fg text}   link:PTR TO mn
@{fg shine}(   4)@{fg text}   port:PTR TO mp
@{fg shine}(   8)@{fg text}   action:LONG
@{fg shine}(   8)@{fg text}   type:LONG
@{fg shine}(  12)@{fg text}   status:LONG
@{fg shine}(  12)@{fg text}   res1:LONG
@{fg shine}(  16)@{fg text}   status2:LONG
@{fg shine}(  16)@{fg text}   res2:LONG
@{fg shine}(  20)@{fg text}   bufaddr:LONG
@{fg shine}(  20)@{fg text}   arg1:LONG
@{fg shine}(  24)@{fg text}   arg2:LONG
@{fg shine}(  28)@{fg text}   arg3:LONG
@{fg shine}(  32)@{fg text}   arg4:LONG
@{fg shine}(  36)@{fg text}   arg5:LONG
@{fg shine}(  40)@{fg text}   arg6:LONG
@{fg shine}(  44)@{fg text}   arg7:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=48 */

@{fg shine}(----)@{fg text} OBJECT filehandle
@{fg shine}(   0)@{fg text}   link:PTR TO mn
@{fg shine}(   4)@{fg text}   interactive:PTR TO mp
@{fg shine}(   8)@{fg text}   type:PTR TO mp
@{fg shine}(  12)@{fg text}   buf:LONG
@{fg shine}(  16)@{fg text}   pos:LONG
@{fg shine}(  20)@{fg text}   end:LONG
@{fg shine}(  24)@{fg text}   funcs:LONG
@{fg shine}(  28)@{fg text}   func2:LONG
@{fg shine}(  32)@{fg text}   func3:LONG
@{fg shine}(  36)@{fg text}   args:LONG
@{fg shine}(  40)@{fg text}   arg2:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=44 */

@{fg shine}(----)@{fg text} OBJECT process
@{fg shine}(   0)@{fg text}   task:tc @{fg shine}(or ARRAY OF tc)@{fg text}
@{fg shine}(  92)@{fg text}   msgport:mp @{fg shine}(or ARRAY OF mp)@{fg text}
@{fg shine}( 126)@{fg text}   pad:INT
@{fg shine}( 128)@{fg text}   seglist:LONG
@{fg shine}( 132)@{fg text}   stacksize:LONG
@{fg shine}( 136)@{fg text}   globvec:LONG
@{fg shine}( 140)@{fg text}   tasknum:LONG
@{fg shine}( 144)@{fg text}   stackbase:LONG
@{fg shine}( 148)@{fg text}   result2:LONG
@{fg shine}( 152)@{fg text}   currentdir:LONG
@{fg shine}( 156)@{fg text}   cis:LONG
@{fg shine}( 160)@{fg text}   cos:LONG
@{fg shine}( 164)@{fg text}   consoletask:LONG
@{fg shine}( 168)@{fg text}   filesystemtask:LONG
@{fg shine}( 172)@{fg text}   cli:LONG
@{fg shine}( 176)@{fg text}   returnaddr:LONG
@{fg shine}( 180)@{fg text}   pktwait:LONG
@{fg shine}( 184)@{fg text}   windowptr:LONG
@{fg shine}( 188)@{fg text}   homedir:LONG
@{fg shine}( 192)@{fg text}   flags:LONG
@{fg shine}( 196)@{fg text}   exitcode:LONG
@{fg shine}( 200)@{fg text}   exitdata:LONG
@{fg shine}( 204)@{fg text}   arguments:PTR TO CHAR
@{fg shine}( 208)@{fg text}   localvars:mlh @{fg shine}(or ARRAY OF mlh)@{fg text}
@{fg shine}( 220)@{fg text}   shellprivate:LONG
@{fg shine}( 224)@{fg text}   ces:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=228 */

CONST ACTION_CREATE_DIR=22,
      ACTION_COPY_DIR=19,
      ACTION_DISK_TYPE=$20,
      DLT_PRIVATE=-1,
      RUN_EXECUTE=-1,
      ACTION_FINDINPUT=$3ED,
      PRF_CLOSEINPUT=8,
      PRB_CLOSEINPUT=3,
      LDF_WRITE=2,
      LDB_WRITE=1,
      ACTION_WRITE=$57,
      ACTION_FLUSH=27,
      ACTION_PARENT_FH=$407,
      REPORT_TASK=1,
      ACTION_FORMAT=$3FC,
      CMD_DISABLED=$FFFFFC19,
      ACTION_FINDUPDATE=$3EC,
      ACTION_SET_DATE=$22,
      ACTION_FREE_RECORD=$7D9,
      ACTION_LOCK_RECORD=$7D8,
      REPORT_LOCK=2,
      DVPF_UNLOCK=1,
      DVPB_UNLOCK=0,
      ACTION_FH_FROM_LOCK=$402,
      ACTION_SAME_LOCK=$28,
      ACTION_FREE_LOCK=15,
      ACTION_GET_BLOCK=2,
      PRF_FREECLI=4,
      PRB_FREECLI=2,
      ST_USERDIR=2,
      PRF_FREECURRDIR=2,
      PRB_FREECURRDIR=1,
      DLT_NONBINDING=4,
      ACTION_EVENT=6,
      ACTION_EXAMINE_OBJECT=23,
      ACTION_RENAME_OBJECT=17,
      ACTION_DELETE_OBJECT=16,
      ACTION_LOCATE_OBJECT=8,
      ACTION_COPY_DIR_FH=$406,
      ACTION_EXAMINE_ALL_END=$40B,
      ACTION_END=$3EF,
      CMD_INTERNAL=-2,
      ACTION_TIMER=30,
      ACTION_DISK_CHANGE=$21,
      RUN_SYSTEM_ASYNCH=-3,
      LDF_ALL=28,
      ACTION_EXAMINE_ALL=$409,
      ACTION_WRITE_RETURN=$3EA,
      ACTION_READ_RETURN=$3E9,
      ACTION_CHANGE_SIGNAL=$3E3,
      REPORT_VOLUME=3,
      DLT_VOLUME=2,
      ACTION_CURRENT_VOLUME=7,
      ST_ROOT=1,
      DLT_DEVICE=0,
      RNF_WILDSTAR=$1000000,
      RNB_WILDSTAR=24,
      ABORT_DISK_ERROR=$128,
      ACTION_MORE_CACHE=18,
      ACTION_SEEK=$3F0,
      ACTION_FINDOUTPUT=$3EE,
      PRF_CLOSEOUTPUT=16,
      PRB_CLOSEOUTPUT=4,
      DVPF_ASSIGN=2,
      DVPB_ASSIGN=1,
      ACTION_EXAMINE_FH=$40A,
      ACTION_STARTUP=0,
      REPORT_INSERT=4,
      ACTION_SET_COMMENT=28,
      PRF_FREESEGLIST=1,
      PRB_FREESEGLIST=0,
      ACTION_INFO=26,
      ACTION_DISK_INFO=25,
      LDF_DEVICES=4,
      LDB_DEVICES=2,
      ACTION_PARENT=29,
      ABORT_BUSY=$120,
      PRF_FREEARGS=$20,
      PRB_FREEARGS=5,
      ACTION_CHANGE_MODE=$404,
      ACTION_SCREEN_MODE=$3E2,
      LDF_VOLUMES=8,
      LDB_VOLUMES=3,
      ACTION_NIL=0,
      ACTION_INHIBIT=31,
      DLT_DIRECTORY=1,
      LDF_ENTRY=$20,
      LDB_ENTRY=5,
      ACTION_SET_OWNER=$40C,
      RUN_SYSTEM=-2,
      CMD_SYSTEM=-1,
      ACTION_IS_FILESYSTEM=$403,
      LDF_DELETE=$40,
      LDB_DELETE=6,
      LDF_READ=1,
      LDB_READ=0,
      RNF_PRIVATE1=2,
      RNB_PRIVATE1=1,
      ACTION_READ=$52,
      REPORT_STREAM=0,
      ACTION_WRITE_PROTECT=$3FF,
      ACTION_SET_PROTECT=21,
      ACTION_SERIALIZE_DISK=$1068,
      ACTION_RENAME_DISK=9,
      ACTION_SET_MAP=4,
      DLT_LATE=3,
      ACTION_WAIT_CHAR=20,
      ST_PIPEFILE=-5,
      ST_LINKFILE=-4,
      ST_FILE=-3,
      LDF_ASSIGNS=16,
      LDB_ASSIGNS=4,
      ACTION_REMOVE_NOTIFY=$1002,
      ACTION_ADD_NOTIFY=$1001,
      ACTION_DIE=5,
      ACTION_SET_FILE_SIZE=$3FE,
      ST_LINKDIR=4,
      ACTION_EXAMINE_NEXT=24,
      ST_SOFTLINK=3,
      ACTION_READ_LINK=$400,
      ACTION_MAKE_LINK=$3FD
@endnode
