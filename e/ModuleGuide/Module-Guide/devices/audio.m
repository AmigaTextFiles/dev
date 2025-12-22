@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "devices/audio.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT ioaudio
@{fg shine}(   0)@{fg text}   io:io @{fg shine}(or ARRAY OF io)@{fg text}
@{fg shine}(  32)@{fg text}   allockey:INT
@{fg shine}(  34)@{fg text}   data:PTR TO CHAR
@{fg shine}(  38)@{fg text}   length:LONG
@{fg shine}(  42)@{fg text}   period:INT
@{fg shine}(  44)@{fg text}   volume:INT
@{fg shine}(  46)@{fg text}   cycles:INT
@{fg shine}(  48)@{fg text}   writemsg:mn @{fg shine}(or ARRAY OF mn)@{fg text}
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=68 */

CONST ADCMD_SETPREC=10,
      ADALLOC_MAXPREC=$7F,
      ADALLOC_MINPREC=$FFFFFF80,
      ADIOERR_ALLOCFAILED=-11,
      ADCMD_LOCK=13,
      ADIOF_PERVOL=16,
      ADIOB_PERVOL=4,
      ADCMD_PERVOL=12,
      ADIOERR_NOALLOCATION=-10,
      ADCMD_FINISH=11,
      ADCMD_FREE=9,
      ADIOF_NOWAIT=$40,
      ADIOB_NOWAIT=6,
      ADCMD_ALLOCATE=$20,
      ADIOF_WRITEMESSAGE=$80,
      ADIOB_WRITEMESSAGE=7,
      ADHARD_CHANNELS=4,
      ADIOF_SYNCCYCLE=$20,
      ADIOB_SYNCCYCLE=5,
      ADCMD_WAITCYCLE=14,
      ADIOERR_CHANNELSTOLEN=-12

#define AUDIONAME/0
@endnode
