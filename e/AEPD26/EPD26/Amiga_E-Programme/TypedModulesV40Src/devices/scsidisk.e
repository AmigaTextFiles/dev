OPT MODULE
OPT EXPORT

OBJECT bltnode
  n:PTR TO bltnode
  function:LONG
  stat:CHAR
  dummy:CHAR
  blitsize:INT
  beamsync:INT
  cleanup:LONG
ENDOBJECT     /* SIZEOF=18 */

CONST CLEANMEN=6,
      CLEANME=$40,
      CLEANUP=$40,
      HSIZEBITS=6,
      VSIZEBITS=10,
      HSIZEMASK=$3F,
      VSIZEMASK=$3FF,
      MAXBYTESPERROW=$1000,
      MINBYTESPERROW=$80,
      MAXBYTESPERROW=$1000,
      ABC=$80,
      ABNC=$40,
      ANBC=$20,
      ANBNC=16,
      NABC=8,
      NABNC=4,
      NANBC=2,
      NANBNC=1,
      BC0B_DEST=8,
      BC0B_SRCC=9,
      BC0B_SRCB=10,
      BC0B_SRCA=11,
      BC0F_DEST=$100,
      BC0F_SRCC=$200,
      BC0F_SRCB=$400,
      BC0F_SRCA=$800,
      BC1F_DESC=2,
      DEST=$100,
      SRCC=$200,
      SRCB=$400,
      SRCA=$800,
      ASHIFT