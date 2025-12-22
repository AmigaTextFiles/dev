// $Id: number.cc 1.3 1997/07/14 04:23:01 dlorre Exp dlorre $
#include <exec/lists.h>
#include <intuition/imageclass.h>
#include <intuition/gadgetclass.h>
#include <libraries/gadtools.h>
#include <mydebug.h>

#include "gadgets/number.h"
#include "gadgetlist.h"
#include "window.h"
#include "screen.h"


// ========================================================================
// ==========================  NUMBER CLASS ===============================
// ========================================================================

number::number(gadgetlist *gl,
               void (window::*func)(gadget *, unsigned long, unsigned short),
               const char *title,
               long val,
               long max,
               unsigned long flags,
               unsigned long justify) : gadget(gl, func)
{
long pens, apens ;

    pens = apens = gl->win->ws->xpens[BLACK_PEN] << 8 ;
    pens += gl->win->ws->xpens[WHITE_PEN] ;
    apens += gl->win->ws->xpens[GREEN_PEN] ;

    gl->ng->ng_GadgetText = (UBYTE *)title ;
    underkey(title) ;
    gl->ng->ng_Flags = flags ;

    // since the font style can be modified several times
    // in a window opening process, this is a reliable way to be sure
    // that the wanted font will be used

    gfont = OpenFont(gl->ng->ng_TextAttr) ;

    im = (Image *)NewObject(NULL, (UBYTE *)"frameiclass",
        IA_Top,             -1,
        IA_Left,            -2,
        IA_Width,           gl->ng->ng_Width,
        IA_Height,          gl->ng->ng_Height,
        IA_Recessed,        TRUE,
        TAG_DONE) ;

    gad = gl->gad = (Gadget *)NewObject(NULL, (UBYTE *)"strgclass",
            GA_Top,                 gl->ng->ng_TopEdge+1,
            GA_Left,                gl->ng->ng_LeftEdge+2,
            GA_Width,               gl->ng->ng_Width-4,
            GA_Height,              gl->ng->ng_Height-2,
            GA_ID,                  id,
            GA_Image,               im,

            GA_RelVerify,           TRUE,

            GA_Previous,            gl->gad,
            GA_TabCycle,            TRUE,

            STRINGA_MaxChars,       15,
            STRINGA_LongVal,        val,
            STRINGA_Pens,           pens,
            STRINGA_ActivePens,     apens,
            STRINGA_Justification,  justify,
            STRINGA_Font,           gfont,

            TAG_END) ;

    curval = val ;
}

number::~number()
{
    if (gad) DisposeObject(gad) ;
    if (im) DisposeObject(im) ;
    if (gfont) CloseFont(gfont) ;
}

void number::action(unsigned long classe, unsigned short code)
{
    curval = ((StringInfo *)gad->SpecialInfo)->LongInt ;
    gadget::action(classe, code) ;
}

void number::set(long val)
{
    curval = val ;
    SetGadgetAttrs(gad, w, NULL,
        STRINGA_LongVal,    val,
        TAG_END) ;

}


void number::keystroke(BOOL shifted)
{
    ActivateGadget(gad, w, NULL) ;
}

