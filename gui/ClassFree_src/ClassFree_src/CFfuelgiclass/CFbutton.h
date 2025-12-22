#ifndef CFBUTTON_H
#define CFBUTTON_H
/* Public definitions for CFbuttonclass */

#define CFbuttonClassName "CFbuttongclass"

#define CFBU_Dummy        (TAG_USER + 0x3a000)
#define CFBU_Layout       (CFBU_Dummy + 0x0001)

/* Positioning flags for CFBU_Layout */

#define LAYOUT_AUTO         0
#define LAYOUT_TXTLEFT     (1L<<0)
#define LAYOUT_TXTRIGHT    (1L<<1)
#define LAYOUT_TEXT        (LAYOUT_TXTLEFT|LAYOUT_TXTRIGHT) /* Mainly internal use. */
#define LAYOUT_IMGABOVE    (1L<<2)
#define LAYOUT_IMGBELOW    (1L<<3)
#define LAYOUT_IMGLEFT     (1L<<4)
#define LAYOUT_IMGRIGHT    (1L<<5)
#define LAYOUT_IMAGE       (LAYOUT_IMGABOVE|LAYOUT_IMGBELOW|LAYOUT_IMGLEFT|LAYOUT_IMGRIGHT)
#define LAYOUT_IMGREL      (1l<<6)

#endif
