@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "devices/parallel.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT ioextpar
@{fg shine}(   0)@{fg text}   iostd:iostd @{fg shine}(or ARRAY OF iostd)@{fg text}
@{fg shine}(  48)@{fg text}   pextflags:LONG
@{fg shine}(  52)@{fg text}   parstatus:CHAR
@{fg shine}(  53)@{fg text}   parflags:CHAR
@{fg shine}(  54)@{fg text}   ptermarray:ioparray @{fg shine}(or ARRAY OF ioparray)@{fg text}
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=62 */

@{fg shine}(----)@{fg text} OBJECT ioparray
@{fg shine}(   0)@{fg text}   ptermarray0:LONG
@{fg shine}(   4)@{fg text}   ptermarray1:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=8 */

CONST IOPARF_ACTIVE=16,
      IOPARB_ACTIVE=4,
      IOPTF_PAPEROUT=2,
      IOPTB_PAPEROUT=1,
      IOPTF_PARSEL=4,
      IOPTB_PARSEL=2,
      PARERR_INVPARAM=3,
      PARERR_NOTOPEN=5,
      IOPTF_RWDIR=8,
      IOPTB_RWDIR=3,
      PAR_DEVFINISH=10,
      PARERR_LINEERR=4,
      PARERR_PORTRESET=6,
      PDCMD_QUERY=9,
      PARF_SHARED=$20,
      PARB_SHARED=5,
      PARERR_BUFTOOBIG=2,
      PARF_RAD_BOOGIE=8,
      PARB_RAD_BOOGIE=3,
      IOPTF_PARBUSY=1,
      IOPTB_PARBUSY=0,
      PARERR_DEVBUSY=1,
      PARF_EOFMODE=2,
      PARB_EOFMODE=1,
      PARF_ACKMODE=4,
      PARB_ACKMODE=2,
      PARF_FASTMODE=8,
      PARB_FASTMODE=3,
      PARF_SLOWMODE=16,
      PARB_SLOWMODE=4,
      PDCMD_SETPARAMS=10,
      IOPARF_QUEUED=$40,
      IOPARB_QUEUED=6,
      IOPARF_ABORT=$20,
      IOPARB_ABORT=5,
      PARERR_INITERR=7

#define PARALLELNAME/0
@endnode
