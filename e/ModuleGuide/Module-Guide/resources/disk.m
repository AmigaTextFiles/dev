@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "resources/disk.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT discresource
@{fg shine}(   0)@{fg text}   lib:lib @{fg shine}(or ARRAY OF lib)@{fg text}
@{fg shine}(  34)@{fg text}   current:PTR TO discresourceunit
@{fg shine}(  38)@{fg text}   flags:CHAR
@{fg shine}(  39)@{fg text}   pad:CHAR
@{fg shine}(  40)@{fg text}   syslib:PTR TO lib
@{fg shine}(  44)@{fg text}   ciaresource:PTR TO lib
@{fg shine}(  48)@{fg text}   unitid[4]:ARRAY OF LONG
@{fg shine}(  64)@{fg text}   waiting:lh @{fg shine}(or ARRAY OF lh)@{fg text}
@{fg shine}(  78)@{fg text}   discblock:is @{fg shine}(or ARRAY OF is)@{fg text}
@{fg shine}( 100)@{fg text}   discsync:is @{fg shine}(or ARRAY OF is)@{fg text}
@{fg shine}( 122)@{fg text}   index:is @{fg shine}(or ARRAY OF is)@{fg text}
@{fg shine}( 144)@{fg text}   currtask:PTR TO tc
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=148 */

@{fg shine}(----)@{fg text} OBJECT discresourceunit
@{fg shine}(   0)@{fg text}   mn:mn @{fg shine}(or ARRAY OF mn)@{fg text}
@{fg shine}(  20)@{fg text}   discblock:is @{fg shine}(or ARRAY OF is)@{fg text}
@{fg shine}(  42)@{fg text}   discsync:is @{fg shine}(or ARRAY OF is)@{fg text}
@{fg shine}(  64)@{fg text}   index:is @{fg shine}(or ARRAY OF is)@{fg text}
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=86 */

CONST DRT_AMIGA=0,
      DRF_ACTIVE=$80,
      DRB_ACTIVE=7,
      DRF_ALLOC0=1,
      DRB_ALLOC0=0,
      DRF_ALLOC1=2,
      DRB_ALLOC1=1,
      DRF_ALLOC2=4,
      DRB_ALLOC2=2,
      DRF_ALLOC3=8,
      DRB_ALLOC3=3,
      DR_GIVEUNIT=-24,
      DR_GETUNIT=-18,
      DR_FREEUNIT=-12,
      DR_ALLOCUNIT=-6,
      DR_READUNITID=$FFFFFFDC,
      DR_GETUNITID=-30,
      DSKDMAOFF=$4000,
      DRT_37422D2S=$55555555,
      DRT_EMPTY=-1,
      DR_LASTCOMM=$FFFFFFDC,
      DRT_150RPM=$AAAAAAAA

#define DISKNAME/0
@endnode
