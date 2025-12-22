TYP_GADGET0002=2,
      GTYP_PROPGADGET=3,
      GTYP_STRGADGET=4,
      GTYP_CUSTOMGADGET=5,
      GTYP_GTYPEMASK=7,
      GTYP_SYSTYPEMASK=$F0,
      GTYP_WDEPTH=$40,
      GTYP_SDEPTH=$50,
      GTYP_WZOOM=$60,
      GTYP_SUNUSED=$70,
      GMORE_BOUNDS=1,
      GMORE_GADGETHELP=2,
      GMORE_SCROLLRASTER=4

OBJECT boolinfo
  flags:INT  -> This is unsigned
  mask:PTR TO INT  -> Target is unsigned
  reserved:LONG
ENDOBJECT     /* SIZEOF=10 */

CONST BOOLMASK=1

OBJECT propinfo
  flags:INT  -> This is unsigned
  horizpot:INT  -> This is unsigned
  vertpot:INT  -> This is unsigned
  horizbody:INT  -> This is unsigned
  vertbody:INT  -> This is unsigned
  cwidth:INT  -> This is unsigned
  cheight:INT  -> This is unsigned
  hpotres:INT  -> This is unsigned
  vpotres:INT  -> This is unsigned
  leftborder:INT  -> This is unsigned
  topborder:INT  -> This is unsigned
ENDOBJECT     /* SIZEOF=22 */

CONST AUTOKNOB=1,
      FREEHORIZ=2,
      FREEVERT=4,
      PROPBORDERLESS=8,
      KNOBHIT=$100,
      PROPNEWLOOK=16,
      KNOBHMIN=6,
      KNOBVMIN=4,
      MAXBODY=$FFFF,
      MAXPOT=$FFFF

OBJECT stringinfo
  buffer:PTR TO CHAR
  undobuffer:PTR TO CHAR
  bufferpos:INT
  maxchars:INT
  disppos:INT
  undopos:INT
  numchars:INT
  dispcount:INT
  cleft:INT
  ctop:INT
  extension:PTR TO stringextend
  longint:LONG
  altkeymap:PTR TO keymap
ENDOBJECT     /* SIZEOF=36 */

OBJECT intuitext
  frontpen:CHAR
  backpen:CHAR
  drawmode:CHAR
  leftedge:INT
  topedge:INT
  itextfont:PTR TO textattr
  itext:PTR TO CHAR
  nexttext:PTR TO intuitext
ENDOBJECT     /* SIZEOF=20 */

OBJECT border
  leftedge:INT
  topedge:INT
  frontpen:CHAR
  backpen:CHAR
  drawmode:CHAR
  count:CHAR  -> This is signed
  xy:PTR TO INT
  nextborder:PTR TO border
ENDOBJECT     /* SIZEOF=16 */

OBJECT image
  leftedge:INT
  topedge:INT
  width:INT
  height:INT
  depth:INT
  imagedata:PTR TO INT  -> Target is unsigned
  planepick:CHAR
  planeonoff:CHAR
  nextimage:PTR TO image
ENDOBJECT     /* SIZEOF=20 */

OBJECT intuimessage
  execmessage:mn
  class:LONG
  code:INT  -> This is unsigned
  qualifier:INT  -> This is unsigned
  iaddress:LONG
  mousex:INT
  mousey:INT
  seconds:LONG
  micros:LONG
  idcmpwindow:PTR TO window
  speciallink:PTR TO intuimessage
ENDOBJECT     /* SIZEOF=52 */

OBJECT extintuimessage
  intuimessage:intuimessage
  tabletdata:PTR TO tabletdata
ENDOBJECT     /* SIZEOF=NONE !!! */

CONST IDCMP_SIZEVERIFY=1,
      IDCMP_NEWSIZE=2,
      IDCMP_REFRESHWINDOW=4,
      IDCMP_MOUSEBUTTONS=8,
      IDCMP_MOUSEMOVE=16,
      IDCMP_GADGETDOWN=$20,
      IDCMP_GADGETUP=$40,
      IDCMP_REQSET=$80,
      IDCMP_MENUPICK=$100,
      IDCMP_CLOSEWINDOW=$200,
      IDCMP_RAWKEY=$400,
      IDCMP_REQVERIFY=$800,
      IDCMP_REQCLEAR=$1000,
      IDCMP_MENUVERIFY=$2000,
      IDCMP_NEWPREFS=$4000,
      IDCMP_DISKINSERTED=$8000,
      IDCMP_DISKREMOVED=$10000,
      IDCMP_WBENCHMESSAGE=$20000,
      IDCMP_ACTIVEWINDOW=$40000,
      IDCMP_INACTIVEWINDOW=$80000,
      IDCMP_DELTAMOVE=$100000,
      IDCMP_VANILLAKEY=$200000,
      IDCMP_INTUITICKS=$400000,
      IDCMP_IDCMPUPDATE=$800000,
      IDCMP_MENUHELP=$1000000,
      IDCMP_CHANGEWINDOW=$2000000,
      IDCMP_GADGETHELP=$4000000,
      IDCMP_LONELYMESSAGE=$80000000,
      CWCODE_MOVESIZE=0,
      CWCODE_DEPTH=1,
      MENUHOT=1,
      MENUCANCEL=2,
      MENUWAITING=3,
      OKOK=1,
      OKABORT=4,
      OKCANCEL=2,
      WBENCHOPEN=1,
      WBENCHCLOSE=2

OBJECT ibox
  left:INT
  top:INT
  width:INT
  height:INT
ENDOBJECT     /* SIZEOF=8 */

OBJECT window
  nextwindow:PTR TO window
  leftedge:INT
  topedge:INT
  width:INT
  height:INT
  mousey:INT
  mousex:INT
  minwidth:INT
  minheight:INT
  maxwidth:INT  -> This is unsigned
  maxheight:INT  -> This is unsigned
  flags:LONG
  menustrip:PTR TO menu
  title:PTR TO CHAR
  firstrequest:PTR TO requester
  dmrequest:PTR TO requester
  reqcount:INT
  wscreen:PTR TO screen
  rport:PTR TO rastport
  borderleft:CHAR  -> This is signed
  bordertop:CHAR  -> This is signed
  borderright:CHAR  -> This is signed
  borderbottom:CHAR  -> This is signed
  borderrport:PTR TO rastport
  firstgadget:PTR TO gadget
  parent:PTR TO window
  descendant:PTR TO window
  pointer:PTR TO INT  -> Target is unsigned
  ptrheight:CHAR  -> This is signed
  ptrwidth:CHAR  -> This is signed
  xoffset:CHAR  -> This is signed
  yoffset:CHAR  -> This is signed
  idcmpflags:LONG
  userport:PTR TO mp
  windowport:PTR TO mp
  messagekey:PTR TO intuimessage
  detailpen:CHAR
  blockpen:CHAR
  checkmark:PTR TO image
  screentitle:PTR TO CHAR
  gzzmousex