head	1.2;
access;
symbols;
locks
	dlorre:1.2; strict;
comment	@// @;


1.2
date	97.07.14.04.22.27;	author dlorre;	state Exp;
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



@


1.1
log
@Initial revision
@
text
@d1 2
d8 1
a8 6
extern "C" {
extern struct Library *GadToolsBase ;
struct Gadget *CreateGadget( unsigned long kind, struct Gadget *gad,
        struct NewGadget *ng, Tag tag1, ... );
#include <pragmas/gadtools_pragmas.h>
}
d16 1
a16 1
               STRPTR t) : gadget(gl, func)
d18 1
a18 1
    gl->ng->ng_GadgetText = t ;
d28 1
a28 1
               STRPTR t, BOOL def) : gadget(gl, func)
d30 1
a30 1
    gl->ng->ng_GadgetText = t ;
@
