@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "devices/serial.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT ioextser
@{fg shine}(   0)@{fg text}   iostd:iostd @{fg shine}(or ARRAY OF iostd)@{fg text}
@{fg shine}(  48)@{fg text}   ctlchar:LONG
@{fg shine}(  52)@{fg text}   rbuflen:LONG
@{fg shine}(  56)@{fg text}   extflags:LONG
@{fg shine}(  60)@{fg text}   baud:LONG
@{fg shine}(  64)@{fg text}   brktime:LONG
@{fg shine}(  68)@{fg text}   termarray:termarray @{fg shine}(or ARRAY OF termarray)@{fg text}
@{fg shine}(  76)@{fg text}   readlen:CHAR
@{fg shine}(  77)@{fg text}   writelen:CHAR
@{fg shine}(  78)@{fg text}   stopbits:CHAR
@{fg shine}(  79)@{fg text}   serflags:CHAR
@{fg shine}(  80)@{fg text}   status:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=82 */

@{fg shine}(----)@{fg text} OBJECT termarray
@{fg shine}(   0)@{fg text}   ta0:LONG
@{fg shine}(   4)@{fg text}   ta1:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=8 */

CONST SERF_7WIRE=4,
      SERB_7WIRE=2,
      SERERR_PARITYERR=9,
      IOSTF_XOFFWRITE=8,
      IOSTB_XOFFWRITE=3,
      IOSTF_OVERRUN=1,
      IOSTB_OVERRUN=0,
      SERERR_TIMERERR=11,
      SERF_XDISABLED=$80,
      SERB_XDISABLED=7,
      SERERR_INVPARAM=5,
      SEXTF_MARK=1,
      SEXTB_MARK=0,
      SERF_QUEUEDBRK=8,
      SERB_QUEUEDBRK=3,
      SER_DEVFINISH=11,
      SERERR_LINEERR=6,
      SDCMD_QUERY=9,
      SEXTF_MSPON=2,
      SEXTB_MSPON=1,
      SERF_SHARED=$20,
      SERB_SHARED=5,
      SERERR_BUFOVERFLOW=12,
      SERF_PARTY_ODD=2,
      SERB_PARTY_ODD=1,
      SERF_RAD_BOOGIE=16,
      SERB_RAD_BOOGIE=4,
      SERERR_DEVBUSY=1,
      SERF_EOFMODE=$40,
      SERB_EOFMODE=6,
      SERF_PARTY_ON=1,
      SERB_PARTY_ON=0,
      SDCMD_SETPARAMS=11,
      SERERR_BAUDMISMATCH=2,
      SERERR_NODSR=13,
      IOSTF_XOFFREAD=16,
      IOSTB_XOFFREAD=4,
      SERERR_BUFERR=4,
      SERERR_DETECTEDBREAK=15,
      IOSTF_WROTEBREAK=2,
      IOSTB_WROTEBREAK=1,
      IOSTF_READBREAK=4,
      IOSTB_READBREAK=2,
      SDCMD_BREAK=10,
      SER_DEFAULT_CTLCHAR=$11130000

#define SERIALNAME/0
@endnode
