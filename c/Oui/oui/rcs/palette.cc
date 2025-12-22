head	1.3;
access;
symbols;
locks
	dlorre:1.3; strict;
comment	@// @;


1.3
date	98.01.13.20.01.29;	author dlorre;	state Exp;
branches;
next	1.2;

1.2
date	97.07.14.04.22.39;	author dlorre;	state Exp;
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
@changed default settings
@
text
@// $Id: palette.cc 1.2 1997/07/14 04:22:39 dlorre Exp dlorre $
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
}@


1.2
log
@*** empty log message ***
@
text
@d1 1
a1 1
// $Id$
d27 1
a27 1
        GTPA_ColorOffset, 0,
d29 2
a30 2
        GTPA_IndicatorWidth, 20,
        GTPA_IndicatorHeight, 10,
@


1.1
log
@Initial revision
@
text
@d1 1
d7 1
a7 1
#include <cxxproto/gadtools.h>
d16 1
a16 1
                STRPTR text,
d24 1
a24 1
    gl->ng->ng_GadgetText = text ;
@
