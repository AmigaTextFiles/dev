head	1.2;
access;
symbols;
locks
	dlorre:1.2; strict;
comment	@ * @;


1.2
date	97.07.14.04.27.08;	author dlorre;	state Exp;
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
#ifndef CLASS_LISTVIEW_H
#define CLASS_LISTVIEW_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef EXEC_NODES_H
struct Node ;
#endif

#ifndef EXEC_LISTS_H
struct List ;
#endif

#ifndef INTUITION_INTUITION_H
struct Gadget ;
struct Window ;
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

#ifndef CLASS_SLIST_H
class nlist ;
class nlink ;
#endif

// ========================================================================
// ==========================  LISTVIEW CLASS =============================
// ========================================================================

class listview : public gadget
{
    nlink *sl ;
    List *l ;
    Node *n ;
    Node *c ;
    int created ;
public:
    int count ;
    int cursel ;
    int curtop ;
    listview(gadgetlist *gl,
         void (window::*func)(gadget *, unsigned long, unsigned short),
         const char* title,
         unsigned long place,
         nlist *liste,
         unsigned short top=0,
         unsigned short sel=~0,
         short readonly=FALSE,
         unsigned short swidth=16,
         Gadget *showsel=NULL) ;

    ~listview() ;
    void set(unsigned short top, unsigned short sel=~0) ;
    void reset(nlist *liste, unsigned short top=0, unsigned short sel=~0) ;
    void keystroke(BOOL shifted) ;
    void action(unsigned long classe, unsigned short code) ;
};

#endif
@


1.1
log
@Initial revision
@
text
@d1 1
d51 2
a54 3
    int count ;

public:
d57 1
a57 1
         STRPTR title,
@
