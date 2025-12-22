ISABLE=3,
      CMAB_DUALPF_DISABLE=8

OBJECT paletteextra
  semaphore:ss
  firstfree:INT  -> This is unsigned
  nfree:INT  -> This is unsigned
  firstshared:INT  -> This is unsigned
  nshared:INT  -> This is unsigned
  refcnt:LONG
  alloclist:LONG
  viewport:PTR TO viewport
  sharablecolors:INT  -> This is unsigned
ENDOBJECT     /* SIZEOF=68 */

CONST PRECISION_EXACT=-1,
      PRECISION_IMAGE=0,
      PRECISION_ICON=16,
      PRECISION_GUI=$20,
      OBP_PRECISION=$84000000,
      OBP_FAILIFBAD=$84000001,
      PEN_EXCLUSIVE=1,
      PEN_NO_SETCOLOR=2,
      PENF_EXCLUSIVE=1,
      PENF_NO_SETCOLOR=2,
      PENB_EXCLUSIVE=0,
      PENB_NO_SETCOLOR=1

OBJECT viewport
  next:PTR TO viewport
  colormap:PTR TO colormap
  dspins:PTR TO coplist
  sprins:PTR TO coplist
  clrins:PTR TO coplist
  ucopins:PTR TO ucoplist
  dwidth:INT
  dheight:INT
  dxoffset:INT
  dyoffset:INT
  modes:INT  -> This is unsigned
  spritepriorities:CHAR
  extendedmodes:CHAR
  rasinfo:PTR TO rasinfo
ENDOBJECT     /* SIZEOF=40 */

OBJECT view
  viewport:PTR TO viewport
  lofcprlist:PTR TO cprlist
  shfcprlist:PTR TO cprlist
  dyoffset:INT
  dxoffset:INT
  modes:INT  -> This is unsigned
ENDOBJECT     /* SIZEOF=18 */

OBJECT viewextra
  xln:xln
  view:PTR TO view
  monitor:PTR TO monitorspec
  topline:INT  -> This is unsigned
ENDOBJECT     /* SIZEOF=34 */

OBJECT viewportextra
  xln:xln
  viewport:PTR TO viewport
  displayclip:rectangle
  vectable:LONG
  driverdata[2]:ARRAY OF LONG
  flags:INT  -> This is unsigned
  origin[2]:ARRAY OF tpoint
  cop1ptr:LONG
  cop2ptr:LONG
ENDOBJECT     /* SIZEOF=58 */

CONST VPXB_FREE_ME=0,
      VPXF_FREE_ME=1,
      VPXB_VP_LAST=1,
      VPXF_VP_LAST=2,
      VPXB_STRADDLES_256=4,
      VPXF_STRADDLES_256=16,
      VPXB_STRADDLES_512=5,
      VPXF_STRADDLES_512=$20

OBJECT rasinfo
  next:PTR TO rasinfo
  bitmap:PTR TO bitmap
  rxoffset:INT
  ryoffset:INT
ENDOBJECT     /* SIZEOF=12 */

CONST MVP_OK=0,
      MVP_NO_MEM=1,
      MVP_NO_VPE=2,
      MVP_NO_DSPINS=3,
      MVP_NO_DISPLAY=4,
      MVP_OFF_BOTTOM=5,
      MCOP_OK=0,
      MCOP_NO_MEM=1,
      MCOP_NOP=2

OBJECT dbufinfo
  link1:LONG
  count1:LONG
  safemessage:mn
  userdata1:LONG
  link2:LONG
  count2:LONG
  dispmessage:mn
  userdata2:LONG
  matchlong:LONG
  copptr1:LONG
  copptr2:LONG
  copptr3:LON