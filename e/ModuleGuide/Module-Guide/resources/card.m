@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "resources/card.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT amigaxip
@{fg shine}(   0)@{fg text}   code:CHAR
@{fg shine}(   1)@{fg text}   link:CHAR
@{fg shine}(   2)@{fg text}   xiploc[4]:ARRAY OF CHAR
@{fg shine}(   6)@{fg text}   xipflags:CHAR
@{fg shine}(   7)@{fg text}   xipresrv:CHAR
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=8 */

@{fg shine}(----)@{fg text} OBJECT cardmemorymap
@{fg shine}(   0)@{fg text}   commonmemory:PTR TO CHAR
@{fg shine}(   4)@{fg text}   attributememory:PTR TO CHAR
@{fg shine}(   8)@{fg text}   iomemory:PTR TO CHAR
@{fg shine}(  12)@{fg text}   commonmemsize:LONG
@{fg shine}(  16)@{fg text}   attributememsize:LONG
@{fg shine}(  20)@{fg text}   iomemsize:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=24 */

@{fg shine}(----)@{fg text} OBJECT devicetdata
@{fg shine}(   0)@{fg text}   dtsize:LONG
@{fg shine}(   4)@{fg text}   dtspeed:LONG
@{fg shine}(   8)@{fg text}   dttype:CHAR
@{fg shine}(   9)@{fg text}   dtflags:CHAR
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=10 */

@{fg shine}(----)@{fg text} OBJECT cardhandle
@{fg shine}(   0)@{fg text}   cardnode:ln @{fg shine}(or ARRAY OF ln)@{fg text}
@{fg shine}(  14)@{fg text}   cardremoved:PTR TO is
@{fg shine}(  18)@{fg text}   cardinserted:PTR TO is
@{fg shine}(  22)@{fg text}   cardstatus:PTR TO is
@{fg shine}(  26)@{fg text}   cardflags:CHAR
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=28 */

CONST CARDF_RESETREMOVE=1,
      CARDB_RESETREMOVE=0,
      CISTPL_AMIGAXIP=$91,
      CARD_INTB_DA=4,
      CARD_STATUSB_DA=4,
      CARDF_POSTSTATUS=8,
      CARDB_POSTSTATUS=3,
      CARD_VOLTAGE_12V=2,
      CARD_INTB_SC=5,
      CARD_STATUSB_SC=5,
      CARD_DISABLEF_WP=8,
      CARD_STATUSF_WR=8,
      CARD_VOLTAGE_5V=1,
      CARDF_IFAVAILABLE=2,
      CARDB_IFAVAILABLE=1,
      CARD_STATUSF_CCDET=$40,
      CARD_STATUSB_CCDET=6,
      CARD_INTF_BSY=4,
      CARD_INTB_BSY=2,
      CARD_STATUSF_BSY=4,
      CARD_STATUSB_BSY=2,
      CARD_ENABLEF_DIGAUDIO=2,
      CARD_ENABLEB_DIGAUDIO=1,
      CARDF_DELAYOWNERSHIP=4,
      CARDB_DELAYOWNERSHIP=2,
      CARD_INTF_BVD1=$20,
      CARD_INTB_BVD1=5,
      CARD_STATUSF_BVD1=$20,
      CARD_STATUSB_BVD1=5,
      CARDF_REMOVEHANDLE=1,
      CARDB_REMOVEHANDLE=0,
      CARD_INTF_BVD2=16,
      CARD_INTB_BVD2=4,
      CARD_STATUSF_BVD2=16,
      CARD_STATUSB_BVD2=4,
      CARD_DISABLEB_WP=3,
      CARD_STATUSB_WR=3,
      CARD_INTF_IRQ=4,
      CARD_INTB_IRQ=2,
      CARD_STATUSF_IRQ=4,
      CARD_STATUSB_IRQ=2,
      CARD_INTF_DA=16,
      CARD_STATUSF_DA=16,
      CARD_INTF_SETCLR=$80,
      CARD_INTB_SETCLR=7,
      XIPFLAGF_AUTORUN=1,
      XIPFLAGB_AUTORUN=0,
      CARD_INTF_SC=$20,
      CARD_STATUSF_SC=$20,
      CARD_VOLTAGE_0V=0,
      CARD_INTERFACE_AMIGA_0=0

#define CARDRESNAME/0
@endnode
