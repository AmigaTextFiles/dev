@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "libraries/amigaguide.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT opexpungenode
@{fg shine}(   0)@{fg text}   methodid:LONG
@{fg shine}(   4)@{fg text}   attrs:PTR TO tagitem
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=8 */

@{fg shine}(----)@{fg text} OBJECT opnodeio
@{fg shine}(   0)@{fg text}   methodid:LONG
@{fg shine}(   4)@{fg text}   attrs:PTR TO tagitem
@{fg shine}(   8)@{fg text}   node:PTR TO CHAR
@{fg shine}(  12)@{fg text}   filename:PTR TO CHAR
@{fg shine}(  16)@{fg text}   docbuffer:PTR TO CHAR
@{fg shine}(  20)@{fg text}   bufflen:LONG
@{fg shine}(  24)@{fg text}   flags:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=28 */

@{fg shine}(----)@{fg text} OBJECT opfindhost
@{fg shine}(   0)@{fg text}   methodid:LONG
@{fg shine}(   4)@{fg text}   attrs:PTR TO tagitem
@{fg shine}(   8)@{fg text}   node:PTR TO CHAR
@{fg shine}(  12)@{fg text}   toc:PTR TO CHAR
@{fg shine}(  16)@{fg text}   title:PTR TO CHAR
@{fg shine}(  20)@{fg text}   next:PTR TO CHAR
@{fg shine}(  24)@{fg text}   prev:PTR TO CHAR
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=28 */

@{fg shine}(----)@{fg text} OBJECT amigaguidehost
@{fg shine}(   0)@{fg text}   dispatcher:hook @{fg shine}(or ARRAY OF hook)@{fg text}
@{fg shine}(  20)@{fg text}   reserved:LONG
@{fg shine}(  24)@{fg text}   flags:LONG
@{fg shine}(  28)@{fg text}   usecnt:LONG
@{fg shine}(  32)@{fg text}   systemdata:LONG
@{fg shine}(  36)@{fg text}   userdata:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=40 */

@{fg shine}(----)@{fg text} OBJECT xref
@{fg shine}(   0)@{fg text}   node:ln @{fg shine}(or ARRAY OF ln)@{fg text}
@{fg shine}(  14)@{fg text}   pad:INT
@{fg shine}(  16)@{fg text}   df:LONG
@{fg shine}(  20)@{fg text}   file:PTR TO CHAR
@{fg shine}(  24)@{fg text}   name:PTR TO CHAR
@{fg shine}(  28)@{fg text}   line:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=32 */

@{fg shine}(----)@{fg text} OBJECT newamigaguide
@{fg shine}(   0)@{fg text}   lock:LONG
@{fg shine}(   4)@{fg text}   name:PTR TO CHAR
@{fg shine}(   8)@{fg text}   screen:PTR TO screen
@{fg shine}(  12)@{fg text}   pubscreen:PTR TO CHAR
@{fg shine}(  16)@{fg text}   hostport:PTR TO CHAR
@{fg shine}(  20)@{fg text}   clientport:PTR TO CHAR
@{fg shine}(  24)@{fg text}   basename:PTR TO CHAR
@{fg shine}(  28)@{fg text}   flags:LONG
@{fg shine}(  32)@{fg text}   context:PTR TO LONG
@{fg shine}(  36)@{fg text}   node:PTR TO CHAR
@{fg shine}(  40)@{fg text}   line:LONG
@{fg shine}(  44)@{fg text}   extens:PTR TO tagitem
@{fg shine}(  48)@{fg text}   client:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=52 */

@{fg shine}(----)@{fg text} OBJECT amigaguidemsg
@{fg shine}(   0)@{fg text}   msg:mn @{fg shine}(or ARRAY OF mn)@{fg text}
@{fg shine}(  20)@{fg text}   type:LONG
@{fg shine}(  24)@{fg text}   data:LONG
@{fg shine}(  28)@{fg text}   dsize:LONG
@{fg shine}(  32)@{fg text}   dtype:LONG
@{fg shine}(  36)@{fg text}   pri_ret:LONG
@{fg shine}(  40)@{fg text}   sec_ret:LONG
@{fg shine}(  44)@{fg text}   system1:LONG
@{fg shine}(  48)@{fg text}   system2:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=52 */

CONST HTF_NOACTIVATE=$20,
      AGA_ACTIVATE=$80000003,
      HTERR_CANT_CREATE_PORT=$6C,
      AGA_AREXXPORT=$80000009,
      APSH_TOOL_ID=$2AF8,
      XR_DEFINE=8,
      HTNA_HELPGROUP=$80000005,
      AGA_HELPGROUP=$80000005,
      HM_CLOSENODE=3,
      HM_OPENNODE=2,
      HM_FINDNODE=1,
      HTERR_CANT_OPEN_NODE=$67,
      HTERR_CANT_FIND_NODE=$66,
      HTF_CACHE_NODE=4,
      AGA_WORKNODE=$8000000C,
      HTNF_DONE=$40,
      HTNA_DUMMY=$80000000,
      AGA_DUMMY=$80000000,
      TOOLCMDID=$2B02,
      XR_TYPEDEF=7,
      HTNA_SCREEN=$80000001,
      TOOLCMDREPLYID=$2B03,
      HTNA_RECTANGLE=$80000003,
      SHUTDOWNMSGID=$2AFC,
      STARTUPMSGID=$2AF9,
      SHUTDOWNTOOLID=$2B04,
      INACTIVETOOLID=$2B00,
      ACTIVETOOLID=$2AFF,
      DEACTIVATETOOLID=$2AFE,
      ACTIVATETOOLID=$2AFD,
      LOGOUTTOOLID=$2AFB,
      LOGINTOOLID=$2AFA,
      HTH_OPEN=0,
      XR_MACRO=4,
      XR_FIELD=6,
      HTFC_SYSGADS=$80000000,
      HTERR_CANT_OPEN_DATABASE=$65,
      HTF_LOAD_INDEX=1,
      HTF_LOAD_ALL=2,
      HTNF_CLEAN=$20,
      XR_FUNCTION=1,
      HTF_CACHE_DB=8,
      XR_GENERIC=0,
      HTNF_ASCII=8,
      HTH_CLOSE=1,
      XR_STRUCT=5,
      AGA_CONTEXT=$80000004,
      AGA_WORKPATH=$8000000B,
      AGA_PATH=$80000001,
      HTNF_RESERVED1=2,
      AGA_RESERVED1=$80000006,
      HTNF_RESERVED2=4,
      AGA_RESERVED2=$80000007,
      HTNF_RESERVED3=16,
      AGA_RESERVED3=$80000008,
      AGA_XREFLIST=$80000002,
      TOOLSTATUSID=$2B01,
      XR_COMMAND=2,
      HTERR_INVALID_COMMAND=$69,
      HTERR_KEYWORD_NOT_FOUND=$71,
      HTF_UNIQUE=16,
      HTERR_CANT_COMPLETE=$6A,
      HTNA_PENS=$80000002,
      HTERR_NOT_ENOUGH_MEMORY=$64,
      HTERR_PORT_CLOSED=$6B,
      HTNF_KEEP=1,
      HTERR_CANT_OPEN_WINDOW=$68,
      XR_INCLUDE=3,
      AGA_AREXXPORTNAME=$8000000A,
      HM_EXPUNGE=10
@endnode
