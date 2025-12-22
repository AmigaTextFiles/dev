/*****************************************************************************

 GUI support

 *****************************************************************************/

OPT MODULE
OPT EXPORT

-> Screen Info

SET SCRI_LORES

-> Gadgets
SET SCROLL_NOIDCMP,      -> Don't send IDCMPUPDATE messages
    SCROLL_VERT,         -> Vertical scroller
    SCROLL_HORIZ         -> Horizontal scroller

ENUM  GAD_VERT_SCROLLER=2,      -> Vertical scroller
      GAD_VERT_ARROW_UP,
      GAD_VERT_ARROW_DOWN,

      GAD_HORIZ_SCROLLER,       -> Horizontal scroller
      GAD_HORIZ_ARROW_LEFT,
      GAD_HORIZ_ARROW_RIGHT
