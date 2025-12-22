head	1.2;
access;
symbols;
locks
	dlorre:1.2; strict;
comment	@ * @;


1.2
date	97.07.14.04.27.28;	author dlorre;	state Exp;
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
@now uses a font
@
text
@//$Id$
#ifndef CLASS_STRING_H
#define CLASS_STRING_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef INTUITION_INTUITION_H
struct Image ;
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
// ==========================  STRING CLASS ===============================
// ========================================================================

class string : public gadget
{
    Image   *im ;
    TextFont *gfont ;
public:
    long    maxsize ;
    STRPTR curstring ;
    STRPTR  buffer ;
    string(gadgetlist *gl,
           void (window::*func)(gadget *, unsigned long, unsigned short),
           const char *title=NULL,
           const char *text=NULL,
           long max=64,
           unsigned long flags=PLACETEXT_LEFT,
           unsigned long justify=0) ;
    ~string() ;
    void action(unsigned long, unsigned short) ;
    void set(STRPTR) ;
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
d38 1
d40 1
d43 2
a44 2
           STRPTR title=NULL,
           STRPTR text=NULL,
@
