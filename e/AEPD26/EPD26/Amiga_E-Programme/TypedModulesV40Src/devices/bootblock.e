OPT MODULE
OPT EXPORT

MODULE 'graphics/gfx'

OBJECT region
  bounds:rectangle
  regionrectangle:PTR TO regionrectangle
ENDOBJECT     /* SIZEOF=12 */

OBJECT regionrectangle
  next:PT