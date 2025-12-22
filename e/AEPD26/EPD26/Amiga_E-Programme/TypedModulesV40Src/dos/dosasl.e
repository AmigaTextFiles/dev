intuitext
  mutualexclude:LONG
  specialinfo:LONG
  gadgetid:INT  -> This is unsigned
  userdata:LONG
ENDOBJECT     /* SIZEOF=44 */

OBJECT extgadget
  nextgadget:PTR TO extgadget
  leftedge:INT
  topedge:INT
  width:INT
  height:INT
  flags:INT  -> This is unsigned
  activation:INT  -> This is unsigned
  gadgettype:INT  -> This is unsigned
  gadgetrender:LONG
  selectrender:LONG
  gadgettext:PTR TO intuitext
  mutualexclude:LONG
  specialinfo:LONG
  gadgetid:INT  -> This is unsigned
  userdata:LONG
  moreflags:LONG
  boundsleftedge:INT
  boundstopedge:INT
  boundswidth:INT
  boundsheight:INT
ENDOBJECT     /* SIZEOF=56 */

CONST GFLG_GADGHIGHBITS=3,
      GFLG_GADGHCOMP=0,
      GFLG_GADGHBOX=1,
      GFLG_GADGHIMAGE=2,
      GFLG_GADGHNONE=3,
      GFLG_GADGIMAGE=4,
      GFLG_RELBOTTOM=8,
      GFLG_RELRIGHT=16,
      GFLG_RELWIDTH=$20,
      GFLG_RELHEIGHT=$40,
      GFLG_RELSPECIAL=$4000,
      GFLG_SELECTED=$80,
      GFLG_DISABLED=$100,
      GFLG_LABELMASK=$3000,
      GFLG_LABELITEXT=0,
      GFLG_LABELSTRING=$1000,
      GFLG_LABELIMAGE=$2000,
      GFLG_TABCYCLE=$200,
      GFLG_STRINGEXTEND=$400,
      GFLG_IMAGEDISABLE=$800,
      GFLG_EXTENDED=$8000,
      GACT_RELVERIFY=1,
      GACT_IMMEDIATE=2,
      GACT_ENDGADGET=4,
      GACT_FOLLOWMOUSE=8,
      GACT_RIGHTBORDER=16,
      GACT_LEFTBORDER=$20,
      GACT_TOPBORDER=$40,
      GACT_BOTTOMBORDER=$80,
      GACT_BORDERSNIFF=$8000