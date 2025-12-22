// $Id: radio.cc 1.3 1997/09/17 08:16:41 dlorre Exp dlorre $
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



