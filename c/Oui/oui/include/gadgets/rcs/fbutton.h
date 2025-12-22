head	1.3;
access;
symbols;
locks
	dlorre:1.3; strict;
comment	@ * @;


1.3
date	97.07.14.04.26.58;	author dlorre;	state Exp;
branches;
next	1.2;

1.2
date	96.08.28.20.09.15;	author dlorre;	state Exp;
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
@#ifndef CLASS_FBUTTON_H
#define CLASS_FBUTTON_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef INTUITION_INTUITION_H
struct Image ;
struct IntuiText ;
#endif

#ifndef GRAPHICS_TEXT_H
struct TTextAttr ;
struct TextFont ;
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
// ==========================  FBUTTON CLASS ==============================
// ========================================================================

class fbutton : public gadget
{
    STRPTR      text ;
    STRPTR      norm1 ;
    STRPTR      norm2 ;
    STRPTR      under ;

    IntuiText   *it1 ;
    IntuiText   *it2 ;
    IntuiText   *it3 ;

    TextFont    *font ;
    TTextAttr   *underline ;
public:
    fbutton(gadgetlist *gl,
           void (window::*func)(gadget *, unsigned long, unsigned short),
           const char *t, BOOL def=FALSE, BOOL disable=FALSE) ;
    ~fbutton() ;
    void select(BOOL sel, BOOL disable=FALSE) ;
    void keystroke(BOOL shifted) ;
    void action(unsigned long classe, unsigned short code) ;
};
#endif
@


1.2
log
@def placé à faux par défaut
@
text
@d55 1
a55 1
           STRPTR t, BOOL def=FALSE) ;
d57 1
a57 1
    void select(BOOL sel) ;
@


1.1
log
@Initial revision
@
text
@d55 1
a55 1
           STRPTR t, BOOL def) ;
@
