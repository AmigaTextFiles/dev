head	1.4;
access;
symbols;
locks
	dlorre:1.4; strict;
comment	@// @;


1.4
date	98.01.13.20.01.07;	author dlorre;	state Exp;
branches;
next	1.3;

1.3
date	97.07.14.04.20.33;	author dlorre;	state Exp;
branches;
next	1.2;

1.2
date	96.08.28.20.04.22;	author dlorre;	state Exp;
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


1.4
log
@now uses MakeVisible
@
text
@// $Id: listview.cc 1.3 1997/07/14 04:20:33 dlorre Exp dlorre $
#include <exec/lists.h>
#include <exec/libraries.h>
#include <libraries/gadtools.h>

#include "gadgets/listview.h"
#include "gadgetlist.h"
#include "slist.h"
#include <proto/exec.h>
#include <proto/gadtools.h>
#include <clib/alib_protos.h>

// ========================================================================
// ==========================  LIST CLASS =================================
// ========================================================================

listview::listview(gadgetlist *gl,
           void (window::*func)(gadget *, unsigned long, unsigned short),
           const char *title,
           unsigned long place,
           nlist *liste,
           unsigned short top,
           unsigned short sel,
           short readonly,
           unsigned short swidth,
           Gadget *showsel) : gadget(gl, func)
{
BOOL badinit = FALSE ;
nlink_iter it(liste) ;

    underkey(title) ;
    count = 0 ;
    l = new List ;
    if (l) {
        NewList(l) ;
        while ((sl = it++) && !badinit) {
            if (n = new Node) {
                n->ln_Name = sl->label ;
                AddTail(l, n) ;
                count++ ;
            }
            else
                badinit = TRUE ;
        }
        if (badinit) {
            n = l->lh_Head ;
            while (n->ln_Succ) {
                c = n->ln_Succ ;
                Remove(n) ;
                delete n ;
                n = c ;
            }
            delete l ;
            l = NULL ;
        }
    }
    if (l) {
        if (sel != ~0) cursel = sel ; else cursel = -1 ;
        curtop = top ;
        gl->ng->ng_Flags = place ;
        gl->ng->ng_GadgetText = (UBYTE *)title ;
        gad = gl->gad = CreateGadget(LISTVIEW_KIND, gl->gad, gl->ng,
            GTLV_Labels,        l,
            GTLV_Top,           top,
            GTLV_MakeVisible,   top,
            GTLV_Selected,      sel,
            GTLV_ReadOnly,      readonly,
            GTLV_ScrollWidth,   swidth,
            GTLV_ShowSelected,  showsel,
            GT_Underscore,  '_',
            TAG_END) ;
    }
}

listview::~listview()
{
    if (l) {
        n = l->lh_Head ;
        while (n->ln_Succ) {
            c = n->ln_Succ ;
            Remove(n) ;
            delete n ;
            n = c ;
        }
        delete l ;
        l = NULL ;
    }
}

void listview::set(unsigned short top, unsigned short sel)
{
    if (top != -1) curtop = top ;
    cursel = sel ;
    GT_SetGadgetAttrs(gad, w, NULL,
        GTLV_Top,           curtop,
        GTLV_MakeVisible,   curtop,
        GTLV_Selected,      cursel,
        TAG_DONE) ;
}

void listview::reset(nlist *liste, unsigned short top, unsigned short sel)
{
BOOL badinit = FALSE ;
nlink_iter it(liste) ;

    count = 0 ;
    GT_SetGadgetAttrs(gad, w, NULL,
        GTLV_Labels,    ~0,
        TAG_DONE) ;
    if (l) {
        n = l->lh_Head ;
        while (n->ln_Succ) {
            c = n->ln_Succ ;
            Remove(n) ;
            delete n ;
            n = c ;
        }
        delete l ;
        l = NULL ;
    }
    l = new List ;
    if (l) {
        NewList(l) ;
        while ((sl = it++) && !badinit) {
            if (n = new Node) {
                n->ln_Name = sl->label ;
                AddTail(l, n) ;
                count++ ;
            }
            else
                badinit = TRUE ;
        }
        if (badinit) {
            n = l->lh_Head ;
            while (n->ln_Succ) {
                c = n->ln_Succ ;
                Remove(n) ;
                delete n ;
                n = c ;
            }
            delete l ;
            l = NULL ;
        }
    }
    if (l) {
        if (top != -1) curtop = top ;
        if (sel != ~0) cursel = sel ; else cursel = -1 ;
        GT_SetGadgetAttrs(gad, w, NULL,
            GTLV_Labels,        l,
            GTLV_Top,           top,
            GTLV_MakeVisible,   top,
            GTLV_Selected,      sel,
            TAG_DONE) ;
    }
}



void listview::keystroke(BOOL shifted)
{
    if (shifted) {
        if (cursel)
            cursel-- ;
    }
    else {
        if (cursel < count-1)
            cursel++ ;
    }
    if (GadToolsBase->lib_Version >= 39) {
        GT_GetGadgetAttrs(gad, w, NULL,
            GTLV_Top,       &curtop,
            TAG_DONE) ;
    }
    set(curtop, cursel) ;
    gadget::action(NULL, cursel) ;
}
void listview::action(unsigned long classe, unsigned short code)
{
    cursel = code ;
    gadget::action(classe, code) ;
}
@


1.3
log
@*** empty log message ***
@
text
@d1 1
a1 1
// $Id: listview.cc 1.2 1996/08/28 20:04:22 dlorre Exp dlorre $
d65 1
d93 1
a93 1
    if (sel != -1) cursel = sel ;
d95 3
a97 2
        GTLV_Top,       top,
        GTLV_Selected,  sel,
d149 4
a152 3
            GTLV_Labels,    l,
            GTLV_Top,       top,
            GTLV_Selected,  sel,
@


1.2
log
@bug affichage dans keystroke (count pour count-1)
@
text
@d1 1
a1 1
// $Id$
d9 3
a11 3
#include <cxxproto/exec.h>
#include <cxxproto/gadtools.h>
#include <cclib/alib_protos.h>
d19 1
a19 1
           STRPTR title,
d61 1
a61 1
        gl->ng->ng_GadgetText = title ;
@


1.1
log
@Initial revision
@
text
@d1 1
d3 1
d9 3
a11 15

extern "C" {
extern struct ExecBase *SysBase;
void AddTail( struct List *list, struct Node *node );
void Remove( struct Node *node );
#include <pragmas/exec_pragmas.h>

extern struct Library *GadToolsBase ;
struct Gadget *CreateGadget( unsigned long kind, struct Gadget *gad,
        struct NewGadget *ng, Tag tag1, ... );
void GT_SetGadgetAttrs( struct Gadget *gad, struct Window *win,
        struct Requester *req, Tag tag1, ... );
#include <pragmas/gadtools_pragmas.h>
void NewList( struct List *list );
}
d163 1
a163 1
        if (cursel < count)
d165 5
@
