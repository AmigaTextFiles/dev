// $Id: button.cc 1.2 1997/07/14 04:22:27 dlorre Exp dlorre $

#include <libraries/gadtools.h>

#include "gadgets/button.h"
#include "gadgetlist.h"

#include <proto/gadtools.h>

// ========================================================================
// ==========================  BUTTON CLASS ===============================
// ========================================================================

button::button(gadgetlist *gl,
               void (window::*func)(gadget *, unsigned long, unsigned short),
               const char *t) : gadget(gl, func)
{
    gl->ng->ng_GadgetText = (UBYTE *)t ;
    gl->ng->ng_Flags = PLACETEXT_IN ;

    gad = gl->gad = CreateGadget(BUTTON_KIND, gl->gad, gl->ng,
            GT_Underscore,  '_',
            TAG_END) ;
}

button::button(gadgetlist *gl,
               void (window::*func)(gadget *, unsigned long, unsigned short),
               const char *t, BOOL def) : gadget(gl, func)
{
    gl->ng->ng_GadgetText = (UBYTE *)t ;
    gl->ng->ng_Flags = PLACETEXT_IN ;
    if (def) gl->setdefault(TRUE) ;

    gad = gl->gad = CreateGadget(BUTTON_KIND, gl->gad, gl->ng,
            GT_Underscore,  '_',
            TAG_END) ;

    if (def) gl->setdefault(FALSE) ;
}



