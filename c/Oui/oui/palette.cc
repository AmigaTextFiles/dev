// $Id: palette.cc 1.3 1998/01/13 20:01:29 dlorre Exp dlorre $
#include <libraries/gadtools.h>

#include "gadgets/palette.h"
#include "gadgetlist.h"

#include <proto/gadtools.h>

// ========================================================================
// ===========================  PALETTE CLASS =============================
// ========================================================================


palette::palette(gadgetlist *gl,
                void (window::*func)(gadget *, unsigned long, unsigned short),
                const char *text,
                long depth,
                long offset,
                long pen,
                long place,
                short iwidth, short iheight) : gadget(gl, func)
{
    gl->ng->ng_Flags = place ;
    gl->ng->ng_GadgetText = (UBYTE *)text ;
    gad = gl->gad = (Gadget *)CreateGadget(PALETTE_KIND, gl->gad, gl->ng,
        GTPA_Depth, depth,
        GTPA_ColorOffset, offset,
        GTPA_Color,     pen,
        GTPA_IndicatorWidth, iwidth,
        GTPA_IndicatorHeight, iheight,
        GT_Underscore,  '_',
        TAG_END) ;
}

void palette::action(unsigned long classe, unsigned short code)
{
    cursel = code ;
    gadget::action(classe, code) ;
}

void palette::set(long sel)
{
    cursel = sel ;
    GT_SetGadgetAttrs(gad, w, NULL,
        GTPA_Color, cursel,
        TAG_DONE) ;
}

void palette::keystroke(BOOL shifted)
{
    if (shifted) {
        if (cursel) cursel-- ;
    }
    else {
        if (cursel < (numcolors-1)) cursel++ ;
    }
    gadget::action(NULL, cursel) ;
    GT_SetGadgetAttrs(gad, w, NULL,
        GTPA_Color, cursel,
        TAG_DONE) ;
}