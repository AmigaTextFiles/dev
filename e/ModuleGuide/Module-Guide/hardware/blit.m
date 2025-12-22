@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "hardware/blit.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT bltnode
@{fg shine}(   0)@{fg text}   n:PTR TO bltnode
@{fg shine}(   4)@{fg text}   function:LONG
@{fg shine}(   8)@{fg text}   stat:CHAR
@{fg shine}(   9)@{fg text}   dummy:CHAR
@{fg shine}(  10)@{fg text}   blitsize:INT
@{fg shine}(  12)@{fg text}   beamsync:INT
@{fg shine}(  14)@{fg text}   cleanup:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=18 */

CONST DEST=$100,
      BC0F_DEST=$100,
      BC0B_DEST=8,
      SRCA=$800,
      BC0F_SRCA=$800,
      BC0B_SRCA=11,
      SRCB=$400,
      BC0F_SRCB=$400,
      BC0B_SRCB=10,
      SRCC=$200,
      BC0F_SRCC=$200,
      BC0B_SRCC=9,
      VSIZEBITS=10,
      HSIZEBITS=6,
      BLITREVERSE=2,
      ABC=$80,
      OCTANT1=16,
      OCTANT2=0,
      OCTANT3=8,
      OCTANT4=20,
      OCTANT5=28,
      OCTANT6=12,
      OCTANT7=4,
      OCTANT8=24,
      NANBNC=1,
      ANBNC=16,
      VSIZEMASK=$3FF,
      HSIZEMASK=$3F,
      NABC=8,
      FILL_OR=8,
      A_OR_B=$FC,
      A_XOR_C=$5A,
      A_OR_C=$FA,
      A_TO_D=$F0,
      CLEANUP=$40,
      SUD=16,
      MAXBYTESPERROW=$1000,
      MINBYTESPERROW=$80,
      MAXBYTESPERROW=$1000,
      SUL=8,
      NABNC=4,
      ABNC=$40,
      FILL_XOR=16,
      SIGNFLAG=$40,
      OVFLAG=$20,
      BSHIFTSHIFT=12,
      ASHIFTSHIFT=12,
      CLEANME=$40,
      AUL=4,
      LINEMODE=1,
      FILL_CARRYIN=4,
      ONEDOT=2,
      CLEANMEN=6,
      NANBC=2,
      ANBC=$20,
      BC1F_DESC=2
@endnode
