head	1.2;
access;
symbols;
locks
	dlorre:1.2; strict;
comment	@// @;


1.2
date	97.07.14.04.22.34;	author dlorre;	state Exp;
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
}@


1.1
log
@Initial revision
@
text
@d1 2
d9 1
a9 8
extern "C" {
extern struct Library *GadToolsBase ;
struct Gadget *CreateGadget( unsigned long kind, struct Gadget *gad,
        struct NewGadget *ng, Tag tag1, ... );
void GT_SetGadgetAttrs( struct Gadget *gad, struct Window *win,
        struct Requester *req, Tag tag1, ... );
#include <pragmas/gadtools_pragmas.h>
}
d18 1
a18 1
                  STRPTR text, long checked, long place, BOOL disable) : gadget(gl, func)
d20 1
a20 1
    gl->ng->ng_GadgetText = text ;
@
