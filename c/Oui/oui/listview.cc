// $Id: listview.cc 1.4 1998/01/13 20:01:07 dlorre Exp dlorre $
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
