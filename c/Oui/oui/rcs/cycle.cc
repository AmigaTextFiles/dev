head	1.3;
access;
symbols;
locks
	dlorre:1.3; strict;
comment	@// @;


1.3
date	98.01.13.19.58.14;	author dlorre;	state Exp;
branches;
next	1.2;

1.2
date	97.07.14.04.21.07;	author dlorre;	state Exp;
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


1.3
log
@set uses TagItems
@
text
@// $Id: cycle.cc 1.2 1997/07/14 04:21:07 dlorre Exp dlorre $
#include <exec/lists.h>
#include <libraries/gadtools.h>
#include <string.h>

#include "gadgets/cycle.h"
#include "gadgetlist.h"

#include <proto/gadtools.h>
#include <proto/utility.h>

// ========================================================================
// ==========================  CYCLE CLASS ================================
// ========================================================================

cycle::cycle(gadgetlist *gl,
             void (window::*func)(gadget *, unsigned long, unsigned short),
             TagItem *tags) :
             gadget(gl, func), labsize(1), cylabs(NULL)
{
    init(tags) ;
}
cycle::cycle(gadgetlist *gl,
             void (window::*func)(gadget *, unsigned long, unsigned short),
             ULONG tag1, ...) :
             gadget(gl, func), labsize(1), cylabs(NULL)
{
    init((TagItem *)&tag1) ;
}

void cycle::init(TagItem *tags)
{
const char *label ;

    cursel = (LONG)GetTagData(OCYCLE_Active, 0, tags) ;
    label = (const char *)GetTagData(OCYCLE_Label, NULL, tags) ;
    glist->ng->ng_Flags = GetTagData(OCYCLE_Flags, PLACETEXT_LEFT, tags) ;
    initlabs(tags) ;
    glist->ng->ng_GadgetText = (UBYTE *)label ;
    underkey(label) ;
    gad = glist->gad = CreateGadget(CYCLE_KIND, glist->gad, glist->ng,
        GTCY_Labels, cylabs ? cylabs : xlabs,
        GTCY_Active, cursel,
        GT_Underscore,  '_',
        TAG_END) ;
}

void cycle::initlabs(TagItem *tags)
{
const char **p ;
const char *cp ;
int i = 0 ;
TagItem *t, *tl ;

    labsize = 1 ;
    xlabs = NULL ;

    if (FindTagItem(OCYCLE_TextArray, tags)) {
        xlabs = p = (const char **)GetTagData(OCYCLE_TextArray, NULL, tags) ;
        cp = *p++ ;
        while (cp) {
            labsize++ ;
            cp = *p++ ;
        }
     }
    else {
        tl = tags ;
        while (t = NextTagItem(&tl)) {
            if (t->ti_Tag == OCYCLE_Text) {
                labsize++ ;
            }
        }
        cylabs = new STRPTR[labsize] ;
        tl = tags ;
        while (t = NextTagItem(&tl)) {
            if (t->ti_Tag == OCYCLE_Text) {
                cp = (const char *)GetTagData(OCYCLE_Text, NULL, t) ;
                cylabs[i] = new char[strlen(cp)+1] ;
                strcpy(cylabs[i++], cp) ;
            }
        }
        cylabs[i] = NULL ;
    }
}

void cycle::freelabs()
{
    if (cylabs) {
    int i ;
        for ( i=0 ; i<labsize; i++) if (cylabs[i]) delete cylabs[i] ;
        delete cylabs ;
        cylabs = NULL ;
    }
}

cycle::~cycle()
{
    freelabs() ;
}
void cycle::action(unsigned long classe, unsigned short code)
{
    cursel = code ;
    gadget::action(classe, code) ;
}


void cycle::keystroke(BOOL shifted)
{
    if (shifted) {
        cursel-- ;
        if (cursel < 0) cursel=labsize-2 ;
    }
    else {
        cursel++ ;
        if (cursel >= labsize-1)
            cursel = 0 ;
    }
    GT_SetGadgetAttrs(gad, w, NULL,
        GTCY_Active,    cursel,
        TAG_DONE) ;
    gadget::action(NULL, cursel) ;
}


void cycle::set(TagItem *tags)
{
    cursel = (LONG)GetTagData(OCYCLE_Active, cursel, tags) ;
    if (FindTagItem(OCYCLE_Text, tags) || FindTagItem(OCYCLE_TextArray, tags)) {
        freelabs() ;
        initlabs(tags) ;
    }
    GT_SetGadgetAttrs(gad, w, NULL,
        GTCY_Active,   cursel,
        GTCY_Labels,   cylabs ? cylabs : xlabs,
        TAG_DONE) ;
}

void cycle::set(ULONG tag1, ...)
{
    set((TagItem *)&tag1) ;
}
@


1.2
log
@*** empty log message ***
@
text
@d1 1
a1 1
// $Id$
d10 1
a15 1

d18 9
a26 4
             const char *text,
             LONG   flags,
             long active,
             const char **table) : gadget(gl, func), labsize(0), cylabs(NULL)
d28 2
a29 2
const char **p = table ;
const char *cp ;
d31 3
a33 1
    cursel = active ;
d35 11
a45 14
    cp = *p++ ;
    while (cp) {
        labsize++ ;
        cp = *p++ ;
    }

    gl->ng->ng_GadgetText = (UBYTE *)text ;
    underkey(text) ;
    gl->ng->ng_Flags = flags ;
    gad = gl->gad = CreateGadget(CYCLE_KIND, gl->gad, gl->ng,
            GTCY_Labels, table,
            GTCY_Active, active,
            GT_Underscore,  '_',
            TAG_END) ;
d48 1
a48 6
cycle::cycle(gadgetlist *gl,
             void (window::*func)(gadget *, unsigned long, unsigned short),
             const char *text,
             LONG   flags,
             long   active,
             const char *t, ...) : gadget(gl, func), labsize(1), cylabs(NULL)
d50 1
a50 1
const char **p = &t ;
d53 4
d58 2
a59 12
    cursel = active ;
    cp = *p++ ;
    while (cp) {
        labsize++ ;
        cp = *p++ ;
    }
    cylabs = new STRPTR[labsize] ;
    p = &t ;
    cp = *p++ ;
    while (cp) {
        cylabs[i] = new char[strlen(cp)+1] ;
        strcpy(cylabs[i++], cp) ;
d61 22
a83 10
    cylabs[i] = NULL ;

    gl->ng->ng_GadgetText = (UBYTE *)text ;
    underkey(text) ;
    gl->ng->ng_Flags = flags ;
    gad = gl->gad = CreateGadget(CYCLE_KIND, gl->gad, gl->ng,
        GTCY_Labels, cylabs,
        GTCY_Active, active,
        GT_Underscore,  '_',
        TAG_END) ;
d86 1
a86 1
cycle::~cycle()
d92 1
d95 5
d124 2
a125 1
void cycle::set(long active)
d127 5
a131 1
    cursel = active ;
d133 2
a134 1
        GTCY_Active,   active,
d136 5
@


1.1
log
@Initial revision
@
text
@d1 1
d9 1
a9 1
#include <cxxproto/gadtools.h>
d18 1
a18 1
             STRPTR text,
d21 1
a21 1
             STRPTR *table) : gadget(gl, func), labsize(0), cylabs(NULL)
d23 2
a24 2
STRPTR *p = table ;
STRPTR  cp ;
d34 1
a34 1
    gl->ng->ng_GadgetText = text ;
d46 1
a46 1
             STRPTR text,
d49 1
a49 1
             STRPTR t, ...) : gadget(gl, func), labsize(1), cylabs(NULL)
d51 2
a52 2
STRPTR *p = &t ;
STRPTR  cp ;
d71 1
a71 1
    gl->ng->ng_GadgetText = text ;
d83 5
a87 1
    delete [] cylabs ;
@
