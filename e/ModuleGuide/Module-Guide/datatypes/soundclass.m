@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "datatypes/soundclass.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT voiceheader
@{fg shine}(   0)@{fg text}   oneshothisamples:LONG
@{fg shine}(   4)@{fg text}   repeathisamples:LONG
@{fg shine}(   8)@{fg text}   samplesperhicycle:LONG
@{fg shine}(  12)@{fg text}   samplespersec:INT
@{fg shine}(  14)@{fg text}   octaves:CHAR
@{fg shine}(  15)@{fg text}   compression:CHAR
@{fg shine}(  16)@{fg text}   volume:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=20 */

CONST SDTA_SAMPLELENGTH=$800011F7,
      SDTA_DUMMY=$800011F4,
      SDTA_SIGNALTASK=$800011FB,
      SDTA_CONTINUOUS=$800011FD,
      SDTA_SIGNALBIT=$800011FC,
      ID_VHDR=$56484452,
      SDTA_VOLUME=$800011F9,
      SDTA_PERIOD=$800011F8,
      CMP_FIBDELTA=1,
      SDTA_VOICEHEADER=$800011F5,
      CMP_NONE=0,
      SDTA_CYCLES=$800011FA,
      SDTA_SAMPLE=$800011F6,
      ID_BODY=$424F4459,
      ID_8SVX=$38535658

#define SOUNDDTCLASS/0
@endnode
