head	1.2;
access;
symbols;
locks
	dlorre:1.2; strict;
comment	@ * @;


1.2
date	97.07.14.04.27.12;	author dlorre;	state Exp;
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
#ifndef CLASS_NUMBER_H
#define CLASS_NUMBER_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef INTUITION_INTUITION_H
struct Image ;
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
// ==========================  NUMBER CLASS ===============================
// ========================================================================

class number : public gadget
{
    Image       *im ;
    TextFont    *gfont ;
public:
    long curval ;
    number(gadgetlist *gl,
           void (window::*func)(gadget *, unsigned long, unsigned short),
           const char *title, long val, long max=10,
           unsigned long flags=PLACETEXT_LEFT,
           unsigned long justify=0) ;
    ~number() ;
    void action(unsigned long, unsigned short) ;
    void keystroke(BOOL shifted) ;
    void set(long val) ;
};
#endif
@


1.1
log
@Initial revision
@
text
@d1 1
d31 2
a32 1
    Image   *im ;
d37 1
a37 1
           STRPTR title, long val, long max=10,
@
