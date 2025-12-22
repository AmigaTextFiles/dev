head	1.2;
access;
symbols;
locks
	dlorre:1.2; strict;
comment	@ * @;


1.2
date	97.07.14.04.26.26;	author dlorre;	state Exp;
branches;
next	1.1;

1.1
date	96.08.22.02.06.07;	author dlorre;	state Exp;
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
#ifndef CLASS_CHECKBOX_H
#define CLASS_CHECKBOX_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef LIBRARIES_GADTOOLS_H
#define PLACETEXT_LEFT  0x0001  /* Right-align text on left side */
#endif

#ifndef CLASS_WINDOW_H
class window ;
#endif

#ifndef CLASS_GADGETLIST_H
class gadgetlist ;
#endif

#ifndef CLASS_GADGET_H
#include "gadgets/gadget.h"
#endif

// ========================================================================
// ==========================  CHECKBOX CLASS =============================
// ========================================================================

class checkbox : public gadget
{
public:
    long cursel ;
    checkbox(gadgetlist *gl,
             void (window::*func)(gadget *, unsigned long, unsigned short),
             const char *text, long checked=FALSE, long place=PLACETEXT_LEFT, BOOL disable=FALSE) ;
    void set(long flag) ;
    void disable(BOOL flag) ;
    void action(unsigned long, unsigned short) ;
    void keystroke(BOOL shifted) ;
};


#endif
@


1.1
log
@Initial revision
@
text
@d1 1
d35 1
a35 1
             STRPTR text, long checked=FALSE, long place=PLACETEXT_LEFT, BOOL disable=FALSE) ;
@
