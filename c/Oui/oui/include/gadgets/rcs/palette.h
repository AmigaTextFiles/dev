head	1.2;
access;
symbols;
locks
	dlorre:1.2; strict;
comment	@ * @;


1.2
date	97.07.14.04.27.16;	author dlorre;	state Exp;
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
#ifndef CLASS_PALETTE_H
#define CLASS_PALETTE_H

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
// ===========================  PALETTE CLASS =============================
// ========================================================================

class palette : public gadget
{
    long numcolors ;
public:
    long cursel ;
    palette(gadgetlist *gl,
                void (window::*func)(gadget *, unsigned long, unsigned short),
                const char *text,
                long depth,
                long offset,
                long pen,
                long place=PLACETEXT_LEFT,
                short iwidth=10, short iheight=10) ;
    void set(long sel) ;
    void action(unsigned long classe, unsigned short code) ;
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
d36 1
a36 1
                STRPTR text,
@
