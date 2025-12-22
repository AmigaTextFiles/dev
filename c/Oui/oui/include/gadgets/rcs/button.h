head	1.2;
access;
symbols;
locks
	dlorre:1.2; strict;
comment	@ * @;


1.2
date	97.07.14.04.26.11;	author dlorre;	state Exp;
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
@#ifndef CLASS_BUTTON_H
#define CLASS_BUTTON_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
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

#ifndef CLASS_SLIST_H
class slist ;
class slink ;
#endif

// ========================================================================
// ==========================  BUTTON CLASS ===============================
// ========================================================================

class button : public gadget
{
    STRPTR text ;
public:
    button(gadgetlist *gl,
           void (window::*func)(gadget *, unsigned long, unsigned short),
           const char *t) ;
    button(gadgetlist *gl,
           void (window::*func)(gadget *, unsigned long, unsigned short),
           const char *t, BOOL def) ;
};
#endif
@


1.1
log
@Initial revision
@
text
@d35 1
a35 1
           STRPTR t) ;
d38 1
a38 1
           STRPTR t, BOOL def) ;
@
