head	1.3;
access;
symbols;
locks
	dlorre:1.3; strict;
comment	@// @;


1.3
date	97.07.14.04.19.43;	author dlorre;	state Exp;
branches;
next	1.2;

1.2
date	96.08.28.19.55.41;	author dlorre;	state Exp;
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
@*** empty log message ***
@
text
@//$Id: cnumber.cc 1.2 1996/08/28 19:55:41 dlorre Exp dlorre $
#include <graphics/gfxmacros.h>
#include <intuition/intuition.h>
#include <intuition/classes.h>
#include <intuition/classusr.h>
#include <intuition/imageclass.h>
#include <intuition/gadgetclass.h>
#include <intuition/icclass.h>
#include <intuition/cghooks.h>
#include <libraries/gadtools.h>

#include <string.h>
#include <stdio.h>
#include <mydebug.h>

#include "screen.h"
#include "window.h"
#include "gadgets/cnumber.h"
#include "gadgets/eclass.h"
#include "gadgetlist.h"

#include <proto/exec.h>
#include <proto/graphics.h>
#include <proto/intuition.h>
#include <proto/utility.h>
#include <clib/alib_protos.h>

IMPORT Class *BOOPSIELabel ;
IMPORT int InitELabel(void) ;
IMPORT void FreeELabel(void) ;


// ========================================================================
// ==========================  CNUMBER CLASS ==============================
// ========================================================================
cnumber::cnumber(gadgetlist *gl,
                 void (window::*func)(gadget *, unsigned long, unsigned short),
                 const char *t,
                 long val,
                 long border, long place, char style) : gadget(gl, func)
{
int i, l1, l2 ;
BOOL underset = FALSE ;
UWORD *pens = gl->win->ws->drawinfo->dri_Pens;
short gleft, gtop, gwidth, gheight ;

    gl->ng->ng_Flags = place ;
    InitELabel() ;

    gleft = gl->ng->ng_LeftEdge ;
    gtop = gl->ng->ng_TopEdge ;
    gwidth = gl->ng->ng_Width ;
    gheight = gl->ng->ng_Height ;

    if (style & BOTTOMCNUMBER)
        gtop = short(-gtop) ;
    if (style & RIGHTCNUMBER)
        gleft = short(-gleft) ;
    if (style & WIDTHCNUMBER)
        gwidth = short(-gwidth) ;
    if (style & HEIGHTCNUMBER)
        gheight = short(-gheight) ;


    if (t) {

        it1 = new IntuiText ;
        it2 = new IntuiText ;
        it3 = new IntuiText ;

        plain = new TTextAttr ;
        underline = new TTextAttr ;

        it1->FrontPen = it2->FrontPen = it3->FrontPen = gl->win->ws->drawinfo->dri_Pens[(place&NG_HIGHLABEL)?HIGHLIGHTTEXTPEN:TEXTPEN] ;
        it1->BackPen = it2->BackPen = it3->BackPen = 0 ;
        it1->DrawMode = it2->DrawMode = it3->DrawMode = JAM1 ;

        norm1 = new char[strlen(t)+1] ;
        norm2 = new char[strlen(t)+1] ;
        under = new char[2] ;

        underkey(t) ;

        CopyMem(gl->win->ws->scr->Font, plain, sizeof(struct TTextAttr)) ;
        CopyMem(gl->win->ws->scr->Font, underline, sizeof(struct TTextAttr)) ;
        underline->tta_Style |= FSF_UNDERLINED ;
        font = OpenFont((TextAttr *)underline) ;

        for (i=l1=l2=0; t[i]; i++) {
            if (t[i] == '_') {
                if (t[i+1]) under[0] = t[++i] ;
                underset = TRUE ;
            }
            else {
                if (underset) {
                    norm2[l2++] = t[i] ;
                }
                else {
                    norm1[l1++] = t[i] ;
                }
            }
        }
        norm1[l1] = '\0' ;
        norm2[l2] = '\0' ;
        under[1] = '\0' ;

        if (l1) {
            it1->IText = (UBYTE *)norm1 ;
            it1->ITextFont = (TextAttr *)plain ;
            if (underset) {
                it1->NextText = it2 ;
                it2->LeftEdge = short(IntuiTextLength(it1)) ;
                it2->IText = (UBYTE *)under ;
                it2->ITextFont = (TextAttr *)underline ;
                if (l2) {
                    it2->NextText = it3 ;
                    it3->LeftEdge = short(it2->LeftEdge + IntuiTextLength(it2)) ;
                    it3->IText = (UBYTE *)norm2 ;
                    it3->ITextFont = (TextAttr *)plain ;
                }
            }
        }
        else if (underset) {
            it1->IText = (UBYTE *)under ;
            it1->ITextFont = (TextAttr *)underline ;
            it1->NextText = it2 ;
            it2->LeftEdge = short(IntuiTextLength(it1)) ;
            it2->IText = (UBYTE *)norm2 ;
            it2->ITextFont = (TextAttr *)plain ;
        }
    }
    gad = gl->gad = (Gadget *)NewObject(BOOPSIELabel, NULL,
            GA_ID,          id,
            GA_Top,         gtop,
            GA_Left,        gleft,
            GA_Width,       gwidth,
            GA_Height,      gheight,

            (style & BOTTOMCNUMBER)?GA_RelBottom:TAG_IGNORE,   TRUE,
            (style & RIGHTCNUMBER)?GA_RelRight:TAG_IGNORE,     TRUE,
            (style & WIDTHCNUMBER)?GA_RelWidth:TAG_IGNORE,     TRUE,
            (style & HEIGHTCNUMBER)?GA_RelHeight:TAG_IGNORE,   TRUE,


            GA_Previous,    gl->gad,
            GA_IntuiText,   it1 ,
            GA_Border,      border,
            GA_Text,        val,
            EGA_Flags,      place,
            EGA_TextAttr,   gl->ng->ng_TextAttr,
            EGA_XPens,      gl->win->ws->xpens,
            EGA_GPen,       gl->gpen,
            EGA_Number,     val,

            TAG_END) ;
}

cnumber::~cnumber()
{
    if (norm1) delete norm1 ;
    if (norm2) delete norm2 ;
    if (under) delete under ;

    if (it1) delete it1 ;
    if (it2) delete it2 ;
    if (it3) delete it3 ;

    if (plain) delete plain ;
    if (underline) delete underline ;

    if (gad) DisposeObject(gad) ;
    if (font) CloseFont(font) ;
    FreeELabel() ;
}

void cnumber::set(LONG val)
{
    SetGadgetAttrs((Gadget *)gad, w, NULL,
        EGA_Number,    val,
        TAG_END) ;
}

void cnumber::keystroke(BOOL shifted)
{
    if (gfunc)
        gadget::action(NULL, 0) ;
    else
        glist->selectgadget(id+1, shifted) ;
}


@


1.2
log
@passage en gadget BOOPSI (via cstring)
@
text
@d1 1
a1 1
//$Id$
d14 1
d22 5
a26 19
#include <cxxproto/graphics.h>
#include <cxxproto/intuition.h>
#include <cclib/alib_protos.h>

extern "C" {

extern struct ExecBase *SysBase ;
void CopyMem( APTR source, APTR dest, unsigned long size );
#pragma libcall SysBase CopyMem 270 09803

extern struct Library *UtilityBase ;
struct TagItem *FindTagItem( Tag tagVal, struct TagItem *tagList );
ULONG GetTagData( Tag tagValue, unsigned long defaultVal,
        struct TagItem *tagList );
#include <pragmas/utility_pragmas.h>

void kprintf(STRPTR format, ...) ;
}

d38 1
a38 1
                 STRPTR t,
d84 2
a85 2
        CopyMem(gl->win->ws->screen->Font, plain, sizeof(struct TTextAttr)) ;
        CopyMem(gl->win->ws->screen->Font, underline, sizeof(struct TTextAttr)) ;
d108 1
a108 1
            it1->IText = norm1 ;
d113 1
a113 1
                it2->IText = under ;
d118 1
a118 1
                    it3->IText = norm2 ;
d124 1
a124 1
            it1->IText = under ;
d128 1
a128 1
            it2->IText = norm2 ;
@


1.1
log
@Initial revision
@
text
@d1 9
d12 5
d18 1
d21 4
d26 12
a37 6
extern struct Library *GadToolsBase ;
struct Gadget *CreateGadget( unsigned long kind, struct Gadget *gad,
        struct NewGadget *ng, Tag tag1, ... );
void GT_SetGadgetAttrs( struct Gadget *gad, struct Window *win,
        struct Requester *req, Tag tag1, ... );
#include <pragmas/gadtools_pragmas.h>
d41 5
a48 1

d51 1
a51 1
                 STRPTR titre,
d53 1
a53 1
                 long border, long place) : gadget(gl, func)
d55 5
a59 1
    gl->ng->ng_GadgetText = titre ;
d61 107
a167 4
    gad = gl->gad = CreateGadget(NUMBER_KIND, gl->gad, gl->ng,
            GTNM_Number, val,
            GTNM_Border, border,
            GT_Underscore,  '_',
d173 14
d189 1
a189 1
void cnumber::set(long val)
d191 3
a193 3
    GT_SetGadgetAttrs(gad, w, NULL,
        GTNM_Number, val,
        TAG_DONE) ;
a195 1

d198 7
a204 2
    glist->selectgadget(id+1, shifted) ;
}@
