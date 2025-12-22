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
  gzzmousex:INT
  gzzmousey:INT
  gzzwidth:INT
  gzzheight:INT
  extdata:PTR TO CHAR
  userdata:PTR TO CHAR
  wlayer:PTR TO layer
  ifont:PTR TO textfont
  moreflags:LONG
ENDOBJECT     /* SIZEOF=136 */

CONST WFLG_SIZEGADGET=1,
      WFLG_DRAGBAR=2,
      WFLG_DEPTHGADGET=4,
      WFLG_CLOSEGADGET=8,
      WFLG_SIZEBRIGHT=16,
      WFLG_SIZEBBOTTOM=$20,
      WFLG_REFRESHBITS=$C0,
      WFLG_SMART_REFRESH=0,
      WFLG_SIMPLE_REFRESH=$40,
      WFLG_SUPER_BITMAP=$80,
      WFLG_OTHER_REFRESH=$C0,
      WFLG_BACKDROP=$100,
      WFLG_REPORTMOUSE=$200,
      WFLG_GIMMEZEROZERO=$400,
      WFLG_BORDERLESS=$800,
      WFLG_ACTIVATE=$1000,
      WFLG_RMBTRAP=$10000,
      WFLG_NOCAREREFRESH=$20000,
      WFLG_NW_EXTENDED=$40000,
      WFLG_NEWLOOKMENUS=$200000,
      WFLG_WINDOWACTIVE=$2000,
      WFLG_INREQUEST=$4000,
      WFLG_MENUSTATE=$8000,
      WFLG_WINDOWREFRESH=$1000000,
      WFLG_WBENCHWINDOW=$2000000,
      WFLG_WINDOWTICKED=$4000000,
      WFLG_VISITOR=$8000000,
      WFLG_ZOOMED=$10000000,
      WFLG_HASZOOM=$20000000,
      SUPER_UNUSED=$FCFC0000,
      DEFAULTMOUSEQUEUE=5

OBJECT nw
  leftedge:INT
  topedge:INT
  width:INT
  height:INT
  detailpen:CHAR
  blockpen:CHAR
  idcmpflags:LONG
  flags:LONG
  firstgadget:PTR TO gadget
  checkmark:PTR TO image
  title:PTR TO CHAR
  screen:PTR TO screen
  bitmap:PTR TO bitmap
  minwidth:INT
  minheight:INT
  maxwidth:INT  -> This is unsigned
  maxheight:INT  -> This is unsigned
  type:INT  -> This is unsigned
ENDOBJECT     /* SIZEOF=48 */

OBJECT extnewwindow
  leftedge:INT
  topedge:INT
  width:INT
  height:INT
  detailpen:CHAR
  blockpen:CHAR
  idcmpflags:LONG
  flags:LONG
  firstgadget:PTR TO gadget
  checkmark:PTR TO image
  title:PTR TO CHAR
  screen:PTR TO screen
  bitmap:PTR TO bitmap
  minwidth:INT
  minheight:INT
  maxwidth:INT  -> This is unsigned
  maxheight:INT  -> This is unsigned
  type:INT  -> This is unsigned
  extension:PTR TO tagitem
ENDOBJECT     /* SIZEOF=52 */

CONST WA_LEFT=$80000064,
      WA_TOP=$80000065,
      WA_WIDTH=$80000066,
      WA_HEIGHT=$80000067,
      WA_DETAILPEN=$80000068,
      WA_BLOCKPEN=$80000069,
      WA_IDCMP=$8000006A,
      WA_FLAGS=$8000006B,
      WA_GADGETS=$8000006C,
      WA_CHECKMARK=$8000006D,
      WA_TITLE=$8000006E,
      WA_SCREENTITLE=$8000006F,
      WA_CUSTOMSCREEN=$80000070,
