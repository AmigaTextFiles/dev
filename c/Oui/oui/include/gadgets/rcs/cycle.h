head	1.2;
access;
symbols;
locks
	dlorre:1.2; strict;
comment	@ * @;


1.2
date	97.07.14.04.26.36;	author dlorre;	state Exp;
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
#ifndef CLASS_CYCLE_H
#define CLASS_CYCLE_H

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

// ========================================================================
// ==========================  CYCLE CLASS ================================
// ========================================================================

class cycle : public gadget
{
    STRPTR  *cylabs ;
    short   labsize ;
public:
    short   cursel ;

    cycle(gadgetlist *gl,
          void (window::*func)(gadget *, unsigned long, unsigned short),
          const char *text,
          LONG      flags,
          long active, const char** table) ;
    cycle(gadgetlist *gl,
          void (window::*func)(gadget *, unsigned long, unsigned short),
          const char *text,
          LONG      flags,
          long active, const char *t, ...) ;
     ~cycle() ;
    void action(unsigned long, unsigned short) ;
    void keystroke(BOOL shifted) ;
    void set(long active) ;
};
#endif
@


1.1
log
@Initial revision
@
text
@d1 1
d34 1
a34 1
          STRPTR    text,
d36 1
a36 1
          long active, STRPTR *table) ;
d39 1
a39 1
          STRPTR    text,
d41 1
a41 1
          long active, STRPTR t, ...) ;
@
