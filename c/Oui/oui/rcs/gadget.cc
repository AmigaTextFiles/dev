head	1.3;
access;
symbols;
locks
	dlorre:1.3; strict;
comment	@// @;


1.3
date	97.09.17.08.15.46;	author dlorre;	state Exp;
branches;
next	1.2;

1.2
date	97.07.14.04.22.49;	author dlorre;	state Exp;
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
@case miscmatch
@
text
@// $Id: gadget.cc 1.2 1997/07/14 04:22:49 dlorre Exp dlorre $
#include <libraries/gadtools.h>

#include "gadgets/gadget.h"
#include "gadgetlist.h"
#include <ctype.h>
#include <mydebug.h>

// ========================================================================
// ==========================  GADGET CLASS ===============================
// ========================================================================


gadget::gadget(gadgetlist *gl,
               void (window::*func)(gadget *, unsigned long, unsigned short)
               ) : glist(gl), gfunc(func), gad(NULL)
{
    gl->ng->ng_LeftEdge = gl->left ;
    gl->ng->ng_TopEdge = gl->top ;
    gl->ng->ng_Width = gl->width ;
    gl->ng->ng_Height = gl->height ;
    id = gl->ng->ng_GadgetID = gl->count ;
    gl->gtab[gl->count] = this ;
    gl->count++ ;
    w = gl->wp ;
    key = '\0' ;
}

void gadget::action(unsigned long classe, unsigned short code)
{
    if (gfunc) (glist->win->*gfunc)(this, classe, code) ;
}

void gadget::select(BOOL sel)
{
}

void gadget::keystroke(BOOL shifted)
{
}

void gadget::underkey(const char *s)
{
int i ;

    key = '\0' ;
    if (s && *s) {
        for (i=1 ; s[i] ; i++) {
            if (s[i-1] == '_' ) {
                key = tolower(s[i]) ;
                break ;
            }
        }
    }
}

@


1.2
log
@*** empty log message ***
@
text
@d1 1
a1 1
// $Id$
d50 1
a50 1
                key = toupper(s[i]) ;
@


1.1
log
@Initial revision
@
text
@d1 1
d6 2
a28 5
void gadget::setfunc(void (window::*func)(gadget *, unsigned long, unsigned short))
{
    gfunc = func ;
}

a37 1

d42 1
a42 1
void gadget::underkey(STRPTR s)
d50 2
a51 1
                key = char(s[i] | 0x20) ;
d56 1
@
