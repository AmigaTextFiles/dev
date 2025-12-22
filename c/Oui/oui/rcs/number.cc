head	1.3;
access;
symbols;
locks
	dlorre:1.3; strict;
comment	@// @;


1.3
date	97.07.14.04.23.01;	author dlorre;	state Exp;
branches;
next	1.2;

1.2
date	96.08.28.20.04.53;	author dlorre;	state Exp;
branches;
next	1.1;

1.1
date	96.08.22.02.05.10;	author dlorre;	state Exp;
branches;
next	;


desc
@Oui.lib -- Object User Interface
Projet créé en 1994
Auteur: Dominique Lorre
@


1.3
log
@font is now used
@
text
@// $Id$
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

@


1.2
log
@bug système : MaxChars pose des problèmes -> fixé à 15
test avant cleanup
@
text
@d1 1
d6 1
a6 2

#include <cxxproto/intuition.h>
d20 1
a20 1
               STRPTR title,
d32 1
a32 1
    gl->ng->ng_GadgetText = title ;
d36 7
a42 1
    im = (Image *)NewObject(NULL, "frameiclass",
d50 1
a50 1
    gad = gl->gad = (Gadget *)NewObject(NULL, "strgclass",
d68 1
d79 1
@


1.1
log
@Initial revision
@
text
@d28 1
a28 1
    pens = apens = gl->win->ws->xpens[BLACK_PEN] << 4 ;
d57 1
a57 1
            STRINGA_MaxChars,       max,
d70 2
a71 2
    DisposeObject(gad) ;
    DisposeObject(im) ;
@
