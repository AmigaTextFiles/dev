VATE=$20, -> Obsolete
      FOF_PRIVATEIDCMP=$20,
      FOF_DOMSGFUNC=$40, -> Obsolete
      FOF_INTUIFUNC=$40,
      FOF_DOWILDFUNC=$80, -> Obsolete
      FOF_FILTERFUNC=$80

OBJECT screenmoderequester
  displayid:LONG
  displaywidth:LONG
  displayheight:LONG
  displaydepth:INT  -> This is unsigned
  overscantype:INT  -> This is unsigned
  autoscroll:INT
  bitmapwidth:LONG
  bitmapheight:LONG
  leftedge:INT
  topedge:INT
  width:INT
  height:INT
  infoopened:INT
  infoleftedge:INT
  infotopedge:INT
  infowidth:INT
  infoheight:INT
  userdata:LONG
ENDOBJECT     /* SIZEOF=NONE !!! */

OBJECT displaymode
  ln:ln
  dimensioninf