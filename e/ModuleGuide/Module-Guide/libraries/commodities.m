@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "libraries/commodities.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT inputxpression
@{fg shine}(   0)@{fg text}   version:CHAR
@{fg shine}(   1)@{fg text}   class:CHAR
@{fg shine}(   2)@{fg text}   code:INT
@{fg shine}(   4)@{fg text}   codemask:INT
@{fg shine}(   6)@{fg text}   qualifier:INT
@{fg shine}(   8)@{fg text}   qualmask:INT
@{fg shine}(  10)@{fg text}   qualsame:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=12 */

@{fg shine}(----)@{fg text} OBJECT newbroker
@{fg shine}(   0)@{fg text}   version:CHAR
@{fg shine}(   1)@{fg text}   reserve1:CHAR
@{fg shine}(   2)@{fg text}   name:PTR TO CHAR
@{fg shine}(   6)@{fg text}   title:PTR TO CHAR
@{fg shine}(  10)@{fg text}   descr:PTR TO CHAR
@{fg shine}(  14)@{fg text}   unique:INT
@{fg shine}(  16)@{fg text}   flags:INT
@{fg shine}(  18)@{fg text}   pri:CHAR
@{fg shine}(  19)@{fg text}   reserve2:CHAR
@{fg shine}(  20)@{fg text}   port:PTR TO mp
@{fg shine}(  24)@{fg text}   reservedchannel:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=26 */

CONST CXCMD_KILL=23,
      COERR_BADTYPE=8,
      CXCMD_DISAPPEAR=21,
      CXCMD_APPEAR=19,
      CX_INVALID=0,
      CX_BROKER=6,
      COERR_ISNULL=1,
      CBD_DESCRLEN=$28,
      IXSYM_ALTMASK=$30,
      IXSYM_CAPSMASK=7,
      IXSYM_SHIFTMASK=3,
      CXM_IEVENT=$20,
      CX_CUSTOM=8,
      COF_SHOW_HIDE=4,
      CXCMD_ENABLE=17,
      CXCMD_DISABLE=15,
      IXSYM_ALT=4,
      CX_SIGNAL=4,
      CX_ZERO=9,
      CBD_TITLELEN=$28,
      CBD_NAMELEN=24,
      CBERR_SYSERR=1,
      IXSYM_CAPS=2,
      IXSYM_SHIFT=1,
      CXM_COMMAND=$40,
      CXCMD_LIST_CHG=27,
      CXCMD_UNIQUE=25,
      NBU_UNIQUE=1,
      NBU_DUPLICATE=0,
      CBERR_OK=0,
      IX_NORMALQUALS=$7FFF,
      COERR_BADFILTER=4,
      CX_TYPEFILTER=2,
      CX_FILTER=1,
      CX_TRANSLATE=5,
      CBERR_DUP=2,
      CX_DEBUG=7,
      COERR_NULLATTACH=2,
      NBU_NOTIFY=2,
      CBERR_VERSION=3,
      IX_VERSION=2,
      NB_VERSION=5,
      CX_SEND=3

#define NULL_IX/1
#define CxFilter/1
#define CxTranslate/1
#define CxDebug/1
#define CxCustom/2
#define CxSender/2
#define CxSignal/2
@endnode
