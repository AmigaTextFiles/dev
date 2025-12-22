head	1.2;
access;
symbols;
locks
	dlorre:1.2; strict;
comment	@ * @;


1.2
date	97.07.14.04.27.22;	author dlorre;	state Exp;
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
#ifndef CLASS_SCROLLER_H
#define CLASS_SCROLLER_H

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
// ==========================  SCROLLER CLASS =============================
// ========================================================================


class scroller : public gadget
{
public:
    scroller(gadgetlist *gl,
             void (window::*func)(gadget *, unsigned long, unsigned short),
             long top, long view, long total,
             unsigned short arrows=TRUE) ;
};


#endif
@


1.1
log
@Initial revision
@
text
@d1 1
@
