head	1.2;
access;
symbols;
locks
	dlorre:1.2; strict;
comment	@// @;


1.2
date	97.07.14.04.22.08;	author dlorre;	state Exp;
branches;
next	1.1;

1.1
date	96.08.22.02.05.10;	author dlorre;	state Exp;
branches;
next	;


desc
@Oui.lib -- Object User Interface
Projet créé en 1994
Auteur: Dominique Lorre
@


1.2
log
@index() renamed as indexof()
@
text
@// list.cc
// Date de création : 15/07/94
// Auteur : Dominique Lorre

#include <exec/types.h>
#include <string.h>

#include <proto/dos.h>
#include <mydebug.h>

#include "slist.h"


// =========================================================================
// ========================== SLINK CLASS ==================================
// =========================================================================

long slink::type() const
{
    return 0 ;
}   // info for selection

slink::~slink()
{
}

long slink::indexof()
{
long n = 0 ;
slink *c ;
    c = this ;
    while (c) {
        n++ ;
        c = c->pred ;
    }
    return n-1 ;
}

// =========================================================================
// ========================== SLIST CLASS ==================================
// =========================================================================

slist::~slist()
{
    free() ;
}

void slist::free()
{
slink *n, *c ;

    n = head ;
    while (n) {
        c = n->succ ;
        delete n ;
        n = c ;
    }
    init() ;
}

void slist::addhead(slink *p)
{
    if (head) {
        head->pred = p ;
        p->succ = head ;
    }
    else {
        tail = p ;
        p->succ = NULL ;
    }
    head = p ;
    p->pred = NULL ;
}

void slist::addtail(slink *p)
{
    if (tail) {
        tail->succ = p ;
        p->pred = tail ;
    }
    else {
        head = p ;
        p->pred = NULL ;
    }
    tail = p ;
    p->succ = NULL ;
}

void slist::insert(slink *c, slink *p)
{
    if (!p)
        addhead(c) ;
    else if (p == tail)
        addtail(c) ;
    else  {
        c->succ = p->succ ;
        c->pred = p ;
        p->succ->pred = c ;
        p->succ = c ;
    }
}


void slist::remove(slink *c)
{
    if (c->succ) {                      // le node a un successeur
        if (c->pred) {                  // et un prédécesseur
            c->succ->pred = c->pred ;   // -> ni en tête, ni en fin de liste
            c->pred->succ = c->succ ;
        }
        else {                          // pas de prédécesseur :
            head = c->succ ;            // tête de liste
            c->succ->pred = NULL ;
        }
    }
    else {                              // pas de successeur :
        if (c->pred) {                  // un prédécesseur :
            tail = c->pred ;            // queue de liste
            c->pred->succ = NULL ;
        }
        else if ((c == tail) && (c == head)) {  // ni de prédécesseur
            tail = head = NULL ;            // liste vide
        }                                   // autre cas : le node a été remplacé
    }
}

slink * slist::get(long ind)
{
slink *c ;
long n = 0 ;
    c = head ;
    while (c && n<ind) {
        c = c->succ ;
        n++ ;
    }
    return c ;
}

void slist::replace(slink *anc, slink *nouv)
{
    nouv->succ = anc->succ ;
    nouv->pred = anc->pred ;
    if (nouv->succ)  nouv->succ->pred = nouv ;
    if (nouv->pred)  nouv->pred->succ = nouv ;
    if (anc == head) head = nouv ;
    if (anc == tail) tail = nouv ;
    anc->succ = NULL ;
    anc->pred = NULL ;
}



long slist::count()
{
slink *c = head ;
long n = 0 ;
    while (c) {
        n++ ;
        c = c->succ ;
    }
    return n ;
}

// =========================================================================
// ========================== NLIST CLASS ==================================
// =========================================================================

nlink *nlist::findname(STRPTR name)
{
nlink *c = first() ;

    while (c && strcmp(c->label, name))
        c = c->next() ;
    return c ;
}

void nlist::enqueue(nlink *node)
{
nlink *c = first() ;

    while (c && (stricmp(c->label, node->label) < 0)) {
        c = c->next() ;
    }
    if (!c)
        addtail(node) ;
    else
        insert(node, c->prev()) ;
}
@


1.1
log
@Initial revision
@
text
@d8 2
a9 9
extern "C" {
extern struct DosLibrary *DOSBase ;
void Delay( long timeout );
LONG Printf( STRPTR format, ... );
#include <pragmas/dos_pragmas.h>

VOID kprintf(STRPTR format, ...) ;
}

d27 1
a27 1
long slink::index()
@
