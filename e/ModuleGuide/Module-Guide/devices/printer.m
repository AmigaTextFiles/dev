@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "devices/printer.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT iodrpreq
@{fg shine}(   0)@{fg text}   io:io @{fg shine}(or ARRAY OF io)@{fg text}
@{fg shine}(  32)@{fg text}   rastport:PTR TO rastport
@{fg shine}(  36)@{fg text}   colormap:PTR TO colormap
@{fg shine}(  40)@{fg text}   modes:LONG
@{fg shine}(  44)@{fg text}   srcx:INT
@{fg shine}(  46)@{fg text}   srcy:INT
@{fg shine}(  48)@{fg text}   srcwidth:INT
@{fg shine}(  50)@{fg text}   srcheight:INT
@{fg shine}(  52)@{fg text}   destcols:LONG
@{fg shine}(  56)@{fg text}   destrows:LONG
@{fg shine}(  60)@{fg text}   special:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=62 */

@{fg shine}(----)@{fg text} OBJECT ioprtcmdreq
@{fg shine}(   0)@{fg text}   io:io @{fg shine}(or ARRAY OF io)@{fg text}
@{fg shine}(  32)@{fg text}   prtcommand:INT
@{fg shine}(  34)@{fg text}   parm0:CHAR
@{fg shine}(  35)@{fg text}   parm1:CHAR
@{fg shine}(  36)@{fg text}   parm2:CHAR
@{fg shine}(  37)@{fg text}   parm3:CHAR
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=38 */

CONST AIND=2,
      ATBSALL=$4A,
      ATBCALL=$49,
      ATSS=$30,
      AJFY0=$34,
      ATBC0=$45,
      AFNT10=$2C,
      ATBC1=$47,
      AJFY2=$35,
      AJFY3=$36,
      ATBC3=$46,
      ATBC4=$48,
      AJFY5=$31,
      PRD_DUMPRPORT=11,
      PDERR_CANCEL=1,
      AJFY6=$33,
      AJFY7=$32,
      APERF0=$3B,
      PRD_RAWWRITE=9,
      SPECIAL_TRUSTME=$1000,
      SPECIAL_ASPECT=$80,
      ALMS=$3C,
      ANEL=3,
      ARAW=$4C,
      SPECIAL_FRACROWS=$20,
      SPECIAL_FULLROWS=8,
      SPECIAL_MILROWS=2,
      APERF=$3A,
      SPECIAL_DIMENSIONSMASK=$BF,
      SPECIAL_DENSITYMASK=$700,
      PDERR_TOOKCONTROL=8,
      AFNT0=$22,
      PDERR_INVERTHAM=3,
      AFNT1=$23,
      ADEN1=26,
      AFNT2=$24,
      ADEN2=25,
      AFNT3=$25,
      ADEN3=24,
      AFNT4=$26,
      ADEN4=23,
      AFNT5=$27,
      ADEN5=22,
      AFNT6=$28,
      ADEN6=21,
      AFNT7=$29,
      AFNT8=$2A,
      AFNT9=$2B,
      PDERR_NOTGRAPHICS=2,
      ATMS=$3E,
      APLD=$21,
      ASHORP0=14,
      ASHORP1=16,
      ASHORP2=15,
      ASHORP3=18,
      AEXTEND=$4B,
      ASHORP4=17,
      ASHORP5=20,
      ASHORP6=19,
      ASGR22=11,
      ASGR23=7,
      ASGR24=9,
      PRD_QUERY=12,
      APLU=$20,
      ARI=4,
      ASBC=13,
      PDERR_DIMENSIONOVFLOW=5,
      ASLPP=$39,
      SPECIAL_NOPRINT=$2000,
      ABMS=$3F,
      AVTS=$44,
      ASTBM=$40,
      AHTS=$43,
      APROP0=$2F,
      APROP1=$2E,
      APROP2=$2D,
      SPECIAL_DENSITY1=$100,
      SPECIAL_DENSITY2=$200,
      SPECIAL_DENSITY3=$300,
      SPECIAL_FRACCOLS=16,
      SPECIAL_FULLCOLS=4,
      SPECIAL_MILCOLS=1,
      ASLRM=$41,
      SPECIAL_DENSITY4=$400,
      SPECIAL_DENSITY5=$500,
      SPECIAL_DENSITY6=$600,
      SPECIAL_DENSITY7=$700,
      PRD_PRTCOMMAND=10,
      SPECIAL_CENTER=$40,
      ASFC=12,
      SPECIAL_NOFORMFEED=$800,
      ARIN=1,
      ASGR0=5,
      ASGR1=10,
      ARIS=0,
      PDERR_BUFFERMEMORY=7,
      PDERR_INTERNALMEMORY=6,
      ASGR3=6,
      AVERP0=$37,
      ASGR4=8,
      AVERP1=$38,
      ASUS0=31,
      DEVICES_PRINTER_I=1,
      ASUS1=28,
      ASUS2=27,
      ASUS3=30,
      ASUS4=29,
      PDERR_NOERR=0,
      ARMS=$3D,
      PDERR_BADDIMENSION=4,
      ACAM=$42
@endnode
