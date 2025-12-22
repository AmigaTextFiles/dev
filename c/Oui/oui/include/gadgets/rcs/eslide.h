head	1.3;
access;
symbols;
locks
	dlorre:1.3; strict;
comment	@ * @;


1.3
date	97.07.14.04.26.54;	author dlorre;	state Exp;
branches;
next	1.2;

1.2
date	96.08.28.20.08.57;	author dlorre;	state Exp;
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


1.3
log
@*** empty log message ***
@
text
@// $Id$
#ifndef CLASS_ESLIDE_H
#define CLASS_ESLIDE_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#if !defined( PLACETEXT_LEFT )
#define PLACETEXT_LEFT  0x0001  /* Right-align text on left side */
#endif

#ifndef INTUITION_GADGETCLASS_H
#define LORIENT_HORIZ   1
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
// ============================  ESLIDE CLASS =============================
// ========================================================================


class eslide : public gadget
{
    int cursel ;
    int smin ;
    int smax ;
    STRPTR      norm1 ;
    STRPTR      norm2 ;
    STRPTR      under ;

    IntuiText   *it1 ;
    IntuiText   *it2 ;
    IntuiText   *it3 ;

    TextFont    *font ;
    TTextAttr   *underline ;
    TTextAttr   *plain ;
public:
    eslide(gadgetlist *gl,
               void (window::*func)(gadget *, unsigned long, unsigned short),
               long min,
               long max,
               long level,
               long freedom=LORIENT_HORIZ,
               const char *t=NULL,
               long flags=PLACETEXT_LEFT) ;
    ~eslide() ;
    void set(long level, long min=-1, long max=-1, short disable=FALSE) ;
    void action(unsigned long classe, unsigned short code) ;
    void keystroke(BOOL shifted) ;
};

#endif
@


1.2
log
@support orientation verticale
@
text
@d1 1
d9 4
d39 11
d56 3
a58 1
               long freedom=LORIENT_HORIZ) ;
@


1.1
log
@Initial revision
@
text
@d8 4
d39 2
a40 1
               long level) ;
@
