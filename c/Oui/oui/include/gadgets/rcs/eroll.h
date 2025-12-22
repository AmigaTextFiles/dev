head	1.1;
access;
symbols;
locks
	dlorre:1.1; strict;
comment	@ * @;


1.1
date	96.08.22.02.06.07;	author dlorre;	state Exp;
branches;
next	;


desc
@Oui.lib -- Object User Interface
Projet créé en 1994
Auteur: Dominique Lorre
@


1.1
log
@Initial revision
@
text
@#ifndef CLASS_EROLL_H
#define CLASS_EROLL_H

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
// ============================  EROLL CLASS =============================
// ========================================================================


class eroll : public gadget
{
long    cursel ;
long    rmin ;
long    rmax ;
BOOL    rfull ;
public:
    eroll(gadgetlist *gl,
               void (window::*func)(gadget *, unsigned long, unsigned short),
               long min,
               long max,
               long level,
               BOOL full=FALSE) ;
    ~eroll() ;
    void set(long level, long min=-1, long max=-1, short disable=FALSE) ;
    void action(unsigned long classe, unsigned short code) ;
    void keystroke(BOOL shifted) ;
};

#endif
@
