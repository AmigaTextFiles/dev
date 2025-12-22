// $Id: checkbox.cc 1.2 1997/07/14 04:22:34 dlorre Exp dlorre $

#include <intuition/gadgetclass.h>
#include <libraries/gadtools.h>

#include "gadgets/checkbox.h"
#include "gadgetlist.h"

#include <proto/gadtools.h>

// ========================================================================
// ==========================  CHECKBOX CLASS =============================
// ========================================================================


checkbox::checkbox(gadgetlist *gl,
                  void (window::*func)(gadget *, unsigned long, unsigned short),
                  const char *text, long checked, long place, BOOL disable) : gadget(gl, func)
{
    gl->ng->ng_GadgetText = (UBYTE *)text ;
    underkey(text) ;
    gl->ng->ng_Flags = place ;
    cursel = checked ;

    gad = gl->gad = CreateGadget(CHECKBOX_KIND, gl->gad, gl->ng,
            GTCB_Checked,   checked,
            GTCB_Scaled,    TRUE,
            GT_Underscore,  '_',
            GA_Disabled,    disable,
            TAG_END) ;
}

void checkbox::set(long flag)
{
    cursel = flag ;
    GT_SetGadgetAttrs(gad, w, NULL,
        GTCB_Checked,   flag,
        TAG_DONE) ;
}

void checkbox::disable(BOOL flag)
{
    GT_SetGadgetAttrs(gad, w, NULL,
        GA_Disabled,   flag,
        TAG_DONE) ;
}

void checkbox::action(unsigned long classe, unsigned short code)
{
    cursel = short(gad->Flags & GFLG_SELECTED) ;
    gadget::action(classe, code) ;
}

void checkbox::keystroke(BOOL shifted)
{
    cursel = !cursel ;
    gadget::action(NULL, cursel) ;
    GT_SetGadgetAttrs(gad, w, NULL, GTCB_Checked, cursel, TAG_DONE) ;
}