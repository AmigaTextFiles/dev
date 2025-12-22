head	1.3;
access;
symbols;
locks
	dlorre:1.3; strict;
comment	@// @;


1.3
date	97.09.17.08.16.41;	author dlorre;	state Exp;
branches;
next	1.2;

1.2
date	97.07.14.04.22.44;	author dlorre;	state Exp;
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
@tags used
@
text
@// $Id: radio.cc 1.2 1997/07/14 04:22:44 dlorre Exp dlorre $
#include <libraries/gadtools.h>
#include <string.h>
#include <stdio.h>

#include "gadgets/radio.h"
#include "gadgetlist.h"

#include <proto/gadtools.h>
#include <proto/utility.h>

// ========================================================================
// ==========================  RADIO CLASS ================================
// ========================================================================


radio::radio(gadgetlist *gl,
             void (window::*func)(gadget *, unsigned long, unsigned short),
             TagItem *tags) :
             gadget(gl, func), labsize(1), mxlabs(NULL)
{
    init(tags) ;
}
radio::radio(gadgetlist *gl,
             void (window::*func)(gadget *, unsigned long, unsigned short),
             ULONG tag1, ...) :
             gadget(gl, func), labsize(1), mxlabs(NULL)
{
    init((TagItem *)&tag1) ;
}

radio::~radio()
{
    if (mxlabs) {
    int i ;
        for (i=0; i<labsize; i++)
            if (mxlabs[i]) delete mxlabs[i] ;
        delete mxlabs ;
    }
}

void radio::init(TagItem *tags)
{
const char **p, **text = NULL ;
const char *cp ;
int i = 0 ;
TagItem *t, *tl ;

    cursel = (LONG)GetTagData(ORADIO_Active, 0, tags) ;
    glist->ng->ng_Flags = GetTagData(ORADIO_Flags, PLACETEXT_LEFT, tags) ;
    spacing = (LONG)GetTagData(ORADIO_Spacing, 2, tags) ;

    if (FindTagItem(ORADIO_TextArray, tags)) {
        text = p = (const char **)GetTagData(ORADIO_TextArray, NULL, tags) ;
        cp = *p++ ;
        while (cp) {
            labsize++ ;
            cp = *p++ ;
        }
     }
    else {
        tl = tags ;
        while (t = NextTagItem(&tl)) {
            if (t->ti_Tag == ORADIO_Text) {
                labsize++ ;
            }
        }
        mxlabs = new STRPTR[labsize] ;
        tl = tags ;
        while (t = NextTagItem(&tl)) {
            if (t->ti_Tag == ORADIO_Text) {
                cp = (const char *)GetTagData(ORADIO_Text, NULL, t) ;
                mxlabs[i] = new char[strlen(cp)+1] ;
                strcpy(mxlabs[i++], cp) ;
            }
        }
        mxlabs[i] = NULL ;
    }
    if ((glist->top+(labsize-1)*(glist->height+spacing) - spacing) > glist->maxh)
        glist->maxh = (WORD)glist->top + (labsize-1)*(glist->height+spacing) - spacing ;

    gad = glist->gad = CreateGadget(MX_KIND, glist->gad, glist->ng,
            GTMX_Labels,    mxlabs ? mxlabs : text,
            GTMX_Active,    cursel,
            GTMX_Spacing,   spacing,
            GTMX_Scaled,    TRUE,
            GT_Underscore,  '_',
            TAG_END) ;
}


void radio::action(unsigned long classe, unsigned short code)
{
    cursel = code ;
    curstring = mxlabs[cursel] ;
    gadget::action(classe, code) ;
}

void radio::keystroke(BOOL shifted)
{
    if (shifted) {
        cursel-- ;
        if (cursel < 0) cursel=labsize-2 ;
    }
    else {
        cursel++ ;
        if (cursel > (labsize-2))
            cursel = 0 ;
    }
    GT_SetGadgetAttrs(gad, w, NULL,
        GTMX_Active,    cursel,
        TAG_DONE) ;
    curstring = mxlabs[cursel] ;
    gadget::action(NULL, cursel) ;
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
d16 8
d26 2
a27 2
             long active, unsigned long flags, long spacing,
             const char **text) : gadget(gl, func), labsize(1), mxlabs(NULL)
d29 2
a30 2
const char **p = text ;
const char *cp ;
d32 7
a38 4
    cp = *p++ ;
    while (cp) {
        labsize++ ;
        cp = *p++ ;
a39 13
    cursel = active ;

    if ((gl->top+(labsize-1)*(gl->height+spacing) - spacing) > gl->maxh)
        gl->maxh = gl->top + (labsize-1)*(gl->height+spacing) - spacing ;

    gl->ng->ng_Flags = flags ;
    gad = gl->gad = CreateGadget(MX_KIND, gl->gad, gl->ng,
            GTMX_Labels,    text,
            GTMX_Active,    active,
            GTMX_Spacing,   spacing,
            GTMX_Scaled,    TRUE,
            GT_Underscore,  '_',
            TAG_END) ;
d42 1
a42 4
radio::radio(gadgetlist *gl,
             void (window::*func)(gadget *, unsigned long, unsigned short),
             long active, unsigned long flags, long spacing,
             const char *t, ...) : gadget(gl, func), labsize(1), mxlabs(NULL)
d44 1
a44 1
const char **p = &t ;
d47 5
d53 2
a54 3
    cp = *p++ ;
    while (cp) {
        labsize++ ;
d56 22
d79 2
a80 14
    mxlabs = new STRPTR[labsize] ;
    p = &t ;
    cp = *p++ ;
    while (cp) {
        mxlabs[i] = new char[strlen(cp)+1] ;
        strcpy(mxlabs[i++], cp) ;
        cp = *p++ ;
    }
    mxlabs[i] = NULL ;

    cursel = active ;

    if ((gl->top+(labsize-1)*(gl->height+spacing) - spacing) > gl->maxh)
        gl->maxh = gl->top + (labsize-1)*(gl->height+spacing) - spacing ;
d82 3
a84 4
    gl->ng->ng_Flags = flags ;
    gad = gl->gad = CreateGadget(MX_KIND, gl->gad, gl->ng,
            GTMX_Labels,    mxlabs,
            GTMX_Active,    active,
a90 9
radio::~radio()
{
    if (mxlabs) {
    int i ;
        for (i=0; i<labsize; i++)
            if (mxlabs[i]) delete mxlabs[i] ;
        delete mxlabs ;
    }
}
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
             STRPTR *text) : gadget(gl, func), labsize(1), mxlabs(NULL)
d20 2
a21 2
STRPTR *p = text ;
STRPTR  cp ;
d46 1
a46 1
             STRPTR t, ...) : gadget(gl, func), labsize(1), mxlabs(NULL)
d48 2
a49 2
STRPTR *p = &t ;
STRPTR  cp ;
d84 6
a89 1
    if (mxlabs) delete [] mxlabs ;
d116 1
@
