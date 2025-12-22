@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "datatypes/datatypes.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT toolnode
@{fg shine}(   0)@{fg text}   node:ln @{fg shine}(or ARRAY OF ln)@{fg text}
@{fg shine}(  14)@{fg text}   tool:tool @{fg shine}(or ARRAY OF tool)@{fg text}
@{fg shine}(  22)@{fg text}   length:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=26 */

@{fg shine}(----)@{fg text} OBJECT datatype
@{fg shine}(   0)@{fg text}   node1:ln @{fg shine}(or ARRAY OF ln)@{fg text}
@{fg shine}(  14)@{fg text}   node2:ln @{fg shine}(or ARRAY OF ln)@{fg text}
@{fg shine}(  28)@{fg text}   header:PTR TO datatypeheader
@{fg shine}(  32)@{fg text}   toollist:lh @{fg shine}(or ARRAY OF lh)@{fg text}
@{fg shine}(  46)@{fg text}   functionname:PTR TO CHAR
@{fg shine}(  50)@{fg text}   attrlist:PTR TO tagitem
@{fg shine}(  54)@{fg text}   length:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=58 */

@{fg shine}(----)@{fg text} OBJECT tool
@{fg shine}(   0)@{fg text}   which:INT
@{fg shine}(   2)@{fg text}   flags:INT
@{fg shine}(   4)@{fg text}   program:PTR TO CHAR
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=8 */

@{fg shine}(----)@{fg text} OBJECT dthookcontext
@{fg shine}(   0)@{fg text}   sysbase:PTR TO lib
@{fg shine}(   4)@{fg text}   dosbase:PTR TO lib
@{fg shine}(   8)@{fg text}   iffparsebase:PTR TO lib
@{fg shine}(  12)@{fg text}   utilitybase:PTR TO lib
@{fg shine}(  16)@{fg text}   lock:LONG
@{fg shine}(  20)@{fg text}   fib:PTR TO fileinfoblock
@{fg shine}(  24)@{fg text}   filehandle:LONG
@{fg shine}(  28)@{fg text}   iff:PTR TO iffhandle
@{fg shine}(  32)@{fg text}   buffer:PTR TO CHAR
@{fg shine}(  36)@{fg text}   bufferlength:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=40 */

@{fg shine}(----)@{fg text} OBJECT datatypeheader
@{fg shine}(   0)@{fg text}   name:PTR TO CHAR
@{fg shine}(   4)@{fg text}   basename:PTR TO CHAR
@{fg shine}(   8)@{fg text}   pattern:PTR TO CHAR
@{fg shine}(  12)@{fg text}   mask:PTR TO INT
@{fg shine}(  16)@{fg text}   groupid:LONG
@{fg shine}(  20)@{fg text}   id:LONG
@{fg shine}(  24)@{fg text}   masklen:INT
@{fg shine}(  26)@{fg text}   pad:INT
@{fg shine}(  28)@{fg text}   flags:INT
@{fg shine}(  30)@{fg text}   priority:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=32 */

CONST DTERROR_UNKNOWN_DATATYPE=$7D0,
      ID_CODE=$44544344,
      DTERROR_INVALID_DATA=$7D8,
      DTERROR_NOT_ENOUGH_DATA=$7D7,
      ID_TOOL=$4454544C,
      DTF_SYSTEM1=$1000,
      DTERROR_COULDNT_OPEN=$7D2,
      TF_LAUNCH_MASK=15,
      DTF_TYPE_MASK=15,
      ID_TAGS=$44545447,
      GID_PICTURE=$70696374,
      ID_DTHD=$44544844,
      GID_ANIMATION=$616E696D,
      DTF_ASCII=1,
      GID_TEXT=$74657874,
      TW_PRINT=4,
      TW_EDIT=3,
      TW_MAIL=5,
      GID_INSTRUMENT=$696E7374,
      GID_DOCUMENT=$646F6375,
      TW_INFO=1,
      GID_MUSIC=$6D757369,
      DTF_BINARY=0,
      ID_DTYP=$44545950,
      TF_WORKBENCH=2,
      DTERROR_RESERVED=$7D5,
      DTF_CASE=16,
      GID_SOUND=$736F756E,
      GID_SYSTEM=$73797374,
      TW_BROWSE=2,
      GID_MOVIE=$6D6F7669,
      DTF_IFF=2,
      DTMSG_TYPE_OFFSET=$834,
      DTERROR_COULDNT_SEND_MESSAGE=$7D3,
      TF_SHELL=1,
      DTF_MISC=3,
      DTERROR_COULDNT_SAVE=$7D1,
      DTERROR_UNKNOWN_COMPRESSION=$7D6,
      TNSIZE=26,
      DTNSIZE=$3A,
      TF_RX=3,
      DTHSIZE=$20,
      DTERROR_COULDNT_OPEN_CLIPBOARD=$7D4,
      ID_NAME=$4E414D45
@endnode
