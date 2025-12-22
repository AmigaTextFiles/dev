head	1.2;
access;
symbols;
locks
	dlorre:1.2; strict;
comment	@// @;


1.2
date	97.07.14.04.23.32;	author dlorre;	state Exp;
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


1.2
log
@*** empty log message ***
@
text
@// $Id$

#include <exec/lists.h>
#include <libraries/gadtools.h>

#include "gadgets/scroller.h"
#include "gadgetlist.h"

#include <proto/gadtools.h>

// ========================================================================
// ==========================  SCROLLER CLASS =============================
// ========================================================================


scroller::scroller(gadgetlist *gl,
                   void (window::*func)(gadget *, unsigned long, unsigned short),
                   long top, long view, long total,
                   unsigned short arrows) : gadget(gl, func)
{
   gad = gl->gad = CreateGadget(SCROLLER_KIND, gl->gad, gl->ng,
            GTSC_Top,   top,
            GTSC_Total, total,
            GTSC_Visible,   view,
            GTSC_Arrows,    arrows,
            GT_Underscore,  '_',
            TAG_END) ;
}


@


1.1
log
@Initial revision
@
text
@d1 2
d9 1
a9 6
extern "C" {
extern struct Library *GadToolsBase ;
struct Gadget *CreateGadget( unsigned long kind, struct Gadget *gad,
        struct NewGadget *ng, Tag tag1, ... );
#include <pragmas/gadtools_pragmas.h>
}
@
