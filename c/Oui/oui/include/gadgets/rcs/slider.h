head	1.2;
access;
symbols;
locks
	dlorre:1.2; strict;
comment	@ * @;


1.2
date	97.07.14.04.27.25;	author dlorre;	state Exp;
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
#ifndef CLASS_SLIDER_H
#define CLASS_SLIDER_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef INTUITION_GADGETCLASS_H
#define LORIENT_HORIZ   1
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
// ==========================  SLIDER CLASS ===============================
// ========================================================================

class slider : public gadget
{
    long vmin ;
    long vmax ;
public:
    long cursel ;
    slider(gadgetlist *gl,
           void (window::*func)(gadget *, unsigned long, unsigned short),
           long min, long max, long level,
           long freedom=LORIENT_HORIZ,
           const char *text=NULL,
           const char *lformat=NULL,
           unsigned short mlen=0,
           long tplace=PLACETEXT_LEFT,
           long lplace=PLACETEXT_LEFT,
           long (*fdisp)(Gadget *, unsigned short)=NULL) ;
    void set(long level, long min=-1, long max=-1) ;
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
d43 2
a44 2
           STRPTR text=NULL,
           STRPTR lformat=NULL,
@
