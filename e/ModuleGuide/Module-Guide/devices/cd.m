@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "devices/cd.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT qcode
@{fg shine}(   0)@{fg text}   ctladr:CHAR
@{fg shine}(   1)@{fg text}   track:CHAR
@{fg shine}(   2)@{fg text}   index:CHAR
@{fg shine}(   3)@{fg text}   zero:CHAR
@{fg shine}(   4)@{fg text}   trackposition:lsnmsf @{fg shine}(or ARRAY OF lsnmsf)@{fg text}
@{fg shine}(   8)@{fg text}   diskposition:lsnmsf @{fg shine}(or ARRAY OF lsnmsf)@{fg text}
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=12 */

@{fg shine}(----)@{fg text} OBJECT cdtoc
@{fg shine}(   0)@{fg text}   summary:tocsummary @{fg shine}(or ARRAY OF tocsummary)@{fg text}
@{fg shine}(   0)@{fg text}   entry:tocentry @{fg shine}(or ARRAY OF tocentry)@{fg text}
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=6 */

@{fg shine}(----)@{fg text} OBJECT tocentry
@{fg shine}(   0)@{fg text}   ctladr:CHAR
@{fg shine}(   1)@{fg text}   track:CHAR
@{fg shine}(   2)@{fg text}   position:lsnmsf @{fg shine}(or ARRAY OF lsnmsf)@{fg text}
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=6 */

@{fg shine}(----)@{fg text} OBJECT tocsummary
@{fg shine}(   0)@{fg text}   firsttrack:CHAR
@{fg shine}(   1)@{fg text}   lasttrack:CHAR
@{fg shine}(   2)@{fg text}   leadout:lsnmsf @{fg shine}(or ARRAY OF lsnmsf)@{fg text}
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=6 */

@{fg shine}(----)@{fg text} OBJECT cdxl
@{fg shine}(   0)@{fg text}   node:mln @{fg shine}(or ARRAY OF mln)@{fg text}
@{fg shine}(   8)@{fg text}   buffer:PTR TO CHAR
@{fg shine}(  12)@{fg text}   length:LONG
@{fg shine}(  16)@{fg text}   actual:LONG
@{fg shine}(  20)@{fg text}   intdata:LONG
@{fg shine}(  24)@{fg text}   intcode:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=28 */

@{fg shine}(----)@{fg text} OBJECT lsnmsf
@{fg shine}(   0)@{fg text}   lsn:LONG
@{fg shine}(   0)@{fg text}   msf:rmsf @{fg shine}(or ARRAY OF rmsf)@{fg text}
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=4 */

@{fg shine}(----)@{fg text} OBJECT rmsf
@{fg shine}(   0)@{fg text}   reserved:CHAR
@{fg shine}(   1)@{fg text}   minute:CHAR
@{fg shine}(   2)@{fg text}   second:CHAR
@{fg shine}(   3)@{fg text}   frame:CHAR
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=4 */

@{fg shine}(----)@{fg text} OBJECT cdinfo
@{fg shine}(   0)@{fg text}   playspeed:INT
@{fg shine}(   2)@{fg text}   readspeed:INT
@{fg shine}(   4)@{fg text}   readxlspeed:INT
@{fg shine}(   6)@{fg text}   sectorsize:INT
@{fg shine}(   8)@{fg text}   xlecc:INT
@{fg shine}(  10)@{fg text}   ejectreset:INT
@{fg shine}(  12)@{fg text}   reserved1[4]:ARRAY OF INT
@{fg shine}(  20)@{fg text}   maxspeed:INT
@{fg shine}(  22)@{fg text}   audioprecision:INT
@{fg shine}(  24)@{fg text}   status:INT
@{fg shine}(  26)@{fg text}   reserved2[4]:ARRAY OF INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=34 */

CONST CDERR_BADDATATYPE=$24,
      CDERR_BADDRIVETYPE=$21,
      CD_GETDRIVETYPE=18,
      CDERR_BADLENGTH=-4,
      CD_REMOVE=12,
      CDERR_SELFTEST=-7,
      CD_WRITE=3,
      CD_CHANGENUM=13,
      ADR_UPC=2,
      CD_FLUSH=8,
      CDMODE_NORMAL=0,
      CD_PLAYTRACK=$25,
      CD_START=7,
      CDERR_BADSECHDR=27,
      CDERR_NOSECHDR=21,
      CTL_COPY=$20,
      CD_PAUSE=$28,
      CD_FORMAT=11,
      CD_PROTSTATUS=15,
      ADR_HYBRID=5,
      CD_PLAYLSN=$27,
      CTL_DATA=$40,
      CDERR_NOMEM=31,
      CDSTSF_SPIN=4,
      CDSTSB_SPIN=2,
      CDERR_INVALIDSTATE=$25,
      CDERR_BADSECID=23,
      CD_CHANGESTATE=14,
      CD_UPDATE=4,
      CDERR_BADADDRESS=-5,
      CDERR_OPENFAIL=-1,
      TAGCD_READXLSPEED=3,
      TAGCD_READSPEED=2,
      TAGCD_PLAYSPEED=1,
      CTLADR_ADRMASK=15,
      CTL_COPYMASK=$20,
      CTL_CTLMASK=$D0,
      CTLADR_CTLMASK=$F0,
      CTL_4AUD=$80,
      CDSTSF_CDROM=16,
      CDSTSB_CDROM=4,
      CDERR_ABORTED=-2,
      CD_STOP=6,
      CDSTSF_PAUSED=$40,
      CDSTSF_PLAYING=$20,
      CDSTSB_PAUSED=6,
      CDSTSB_PLAYING=5,
      CD_EJECT=23,
      CDMODE_FFWD=1,
      CDSTSF_SEARCH=$80,
      CDSTSB_SEARCH=7,
      CD_SEARCH=$29,
      CDERR_BADHDRSUM=24,
      CD_PLAYMSF=$26,
      ADR_POSITION=1,
      CDSTSF_DIRECTION=$100,
      CDSTSB_DIRECTION=8,
      CD_CLEAR=5,
      TAGCD_EJECTRESET=6,
      CDERR_POSTRESET=$23,
      CD_RESET=1,
      CDERR_TOOFEWSECS=26,
      CTL_2AUD=0,
      TAGCD_XLECC=5,
      CTL_4AUDEMPH=$90,
      CTL_2AUDEMPH=16,
      CDERR_SEEKERROR=30,
      CD_QCODELSN=$2B,
      CD_SEEK=10,
      CD_GETNUMTRACKS=19,
      CDSTSF_TOC=8,
      CDSTSB_TOC=3,
      CDERR_NOTSPECIFIED=20,
      CDMODE_FREV=2,
      CD_INFO=$20,
      CD_GETGEOMETRY=22,
      CD_ATTENUATE=$2C,
      CDERR_WRITEPROT=28,
      CDERR_UNITBUSY=-6,
      CD_MOTOR=9,
      CDERR_BADUNITNUM=$20,
      CD_QCODEMSF=$2A,
      CD_TOCLSN=$23,
      CDERR_BADSECPREAMBLE=22,
      CD_REMFRAMEINT=$2E,
      CD_ADDFRAMEINT=$2D,
      CD_REMCHANGEINT=21,
      CD_ADDCHANGEINT=20,
      CDERR_BADSECSUM=25,
      CDERR_PHASE=$2A,
      CD_READ=2,
      CDERR_NOCMD=-3,
      CDSTSF_CLOSED=1,
      CDSTSB_CLOSED=0,
      CDSTSF_DISK=2,
      CDSTSB_DISK=1,
      CDERR_NODISK=29,
      CD_TOCMSF=$22,
      CDERR_DRIVEINUSE=$22,
      ADR_ISRC=3,
      CD_READXL=$24,
      TAGCD_SECTORSIZE=4,
      CD_CONFIG=$21,
      CDERR_NOBOARD=$32
@endnode
