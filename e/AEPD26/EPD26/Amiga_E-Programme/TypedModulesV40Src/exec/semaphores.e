OPT MODULE
OPT EXPORT

MODULE 'exec/nodes',
       'graphics/text'

CONST MAXFONTPATH=$100

OBJECT fc
  filename[$100]:ARRAY
  ysize:INT  -> This is unsigned
  style:CHAR
  flags:CHAR
ENDOBJECT     /* SIZEOF=260 */

OBJECT tfc
  filename[$fe]:ARRAY
  tagcount:INT  -> This is unsigned
  ysize:INT  -> This is unsigned
  style:CHAR
  flags:CHAR
ENDOBJECT     /* SIZEOF=260 */

CONST FCH_ID=$F00,
      TFCH_ID=$F02,
      OFCH_ID=$F03

OBJECT fch
  fileid:INT  -> This is unsigned
  numentries:INT  -> This is unsigned
END