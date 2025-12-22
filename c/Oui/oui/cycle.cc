// $Id: cycle.cc 1.3 1998/01/13 19:58:14 dlorre Exp $
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
