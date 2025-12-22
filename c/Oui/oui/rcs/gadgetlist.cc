head	1.4;
access;
symbols;
locks
	dlorre:1.4; strict;
comment	@// @;


1.4
date	97.09.17.08.16.09;	author dlorre;	state Exp;
branches;
next	1.3;

1.3
date	97.07.14.04.20.08;	author dlorre;	state Exp;
branches;
next	1.2;

1.2
date	96.08.28.20.03.22;	author dlorre;	state Exp;
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
@*** empty log message ***
@
text
@// $Id: gadgetlist.cc 1.3 1997/07/14 04:20:08 dlorre Exp dlorre $
#define INTUI_V36_NAMES_ONLY

#include <exec/types.h>
#include <exec/memory.h>

#include <graphics/gfxbase.h>
#include <libraries/gadtools.h>

#include <devices/timer.h>

#include <string.h>
#include <stdio.h>
#include <ctype.h>
#include <mydebug.h>

#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/graphics.h>
#include <proto/intuition.h>
#include <proto/gadtools.h>

#include "screen.h"
#include "window.h"
#include "gadgetlist.h"
#include "gadgets/gadget.h"

static struct EasyStruct GadgetListES = {
    sizeof(struct EasyStruct),
    0,
    (UBYTE *)"GadgetList Corrupted",
    (UBYTE *)"A window is in closing process.\n This window use %ld gadgets but %ld are declared.\nSorry, system will crash",
    (UBYTE *)"Ok"
} ;


// ========================================================================
// ==========================  GADGETLIST CLASS ===========================
// ========================================================================

gadgetlist::gadgetlist(window *w,
                      WORD gmax) :  rectangle(0, 0, 0, 0),
                                    count(0),
                                    max(gmax),
                                    win(w),
                                    bfont(NULL),
                                    initok(FALSE),
                                    glist(NULL)
{

    if (gtab = new gadget *[max]) {
        if (ng = new NewGadget) {
            if (it = new IntuiText) {
                gpen = win->ws->drawinfo->dri_Pens[TEXTPEN] ;     // Front pen
                ng->ng_VisualInfo = win->ws->vi ;
                setfont((TTextAttr *)win->ws->scr->Font) ;
                if (bfont) {
                    ng->ng_GadgetText = NULL ;
                    ng->ng_Width = width ;
                    ng->ng_Height = height ;
                    ng->ng_LeftEdge = left ;
                    ng->ng_TopEdge = top ;

                    if (gad = (Gadget *)CreateContext(&glist)) {
                        wp = win->win ;
                        initok = TRUE ;
                    }
                }

            }
        }

    }
}

gadgetlist::~gadgetlist() {

    if (max < count) {
        EasyRequest(NULL, &GadgetListES, NULL, count, max) ;
    }
    if (bfont) CloseFont(bfont) ;
    if (initok) FreeGadgets(glist) ;
    if (gtab) {
    int i ;
        for (i=0; i<count; i++) {
// uncomment the following if your window crashes on exit...
//            D(bug("freeing gtab[%ld] %lx\n", i, gtab[i])) ;
            if (gtab[i]) delete gtab[i] ;
        }
        delete gtab ;
    }
    if (ng) delete ng ;
    if (it) delete it ;
}

void gadgetlist::processgadget(LONG id, unsigned long classe, unsigned short code)
{
    gtab[id]->action(classe, code) ;
}

void gadgetlist::addgadgets()
{
    if (gad) {
        AddGList(wp, glist, -1, -1, NULL);
        RefreshGList(glist, wp, NULL, -1);
        GT_RefreshWindow(wp, NULL) ;
        win->hasgadgets = TRUE ;
    }
    else
        win->initok = FALSE ;
}

void gadgetlist::updategadgets()
{
int i ;
    wp = win->win ;
    for (i=0; i<count; i++)
        if (gtab[i])
            gtab[i]->w = wp ;
    GT_RefreshWindow(wp, NULL) ;
    win->hasgadgets = TRUE ;
}

void gadgetlist::setfont(TTextAttr *tta)
{
    CopyMem(tta, &PlainAttr, sizeof(TTextAttr)) ;
    BoldAttr = PlainAttr ;
    BoldAttr.tta_Style |= FSF_BOLD ;
    fontheight = PlainAttr.tta_YSize ;
    if (bfont) CloseFont(bfont) ;
    bfont = OpenFont((TextAttr *)&BoldAttr) ;
    setdefault(FALSE) ;
}

void gadgetlist::setdefault(BOOL bolden)
{
    it->ITextFont = ng->ng_TextAttr =
            bolden ?(TextAttr *)&BoldAttr: (TextAttr *)&PlainAttr ;
}

long gadgetlist::ltext(const char *s)
{
    it->IText = (UBYTE *)s ;
    return IntuiTextLength(it) ;
}

long gadgetlist::lmax(const char **ms)
{
long max=0, l ;

    while (*ms)
        if ((l = ltext(*ms++)) > max) max = l ;

    return max ;
}

long gadgetlist::lmax(const char *s, ...)
{
const char **ms = &s ;
    return lmax(ms) ;
}


void gadgetlist::selectgadget(LONG id, BOOL shifted)
{
    if (id < count) gtab[id]->keystroke(shifted) ;
}

void gadgetlist::parsegadgets(USHORT code)
{
int     i ;
BOOL    shifted ;

    if (code > 0x20) {
        shifted = BOOL(isupper(code)) ;
        code = tolower(code) ;
    }
    else
        shifted = FALSE ;

    for (i=0; i<count; i++) {
        if (gtab[i]->key == code) {
            gtab[i]->keystroke(shifted) ;
        }
    }
}

gadget *gadgetlist::getgadget(LONG id)
{
    return gtab[id] ;
}
@


1.3
log
@*** empty log message ***
@
text
@d1 1
a1 1
// $Id$
d14 1
d175 2
a176 2
        shifted = BOOL(!(code & 0x20)) ;
        code |= 0x20 ;
d182 1
a182 1
        if (gtab[i]->key == code)
d184 1
@


1.2
log
@*** empty log message ***
@
text
@d1 1
d14 1
d16 5
a20 12
#include <cxxproto/exec.h>
#include <cxxproto/dos.h>
#include <cxxproto/graphics.h>
#include <cxxproto/intuition.h>

extern "C" {
extern struct Library *GadToolsBase ;
struct Gadget *CreateContext( struct Gadget **glistptr );
void FreeGadgets( struct Gadget *gad );
void GT_RefreshWindow( struct Window *win, struct Requester *req );
#include <pragmas/gadtools_pragmas.h>
}
d30 3
a32 3
    "GadgetList Corrupted",
    "A window is in closing process.\n This window use %ld gadgets but %ld are declared.\nSorry, system will crash",
    "Ok"
d45 26
a70 16
                                    bfont(NULL)
{
    gpen = win->ws->drawinfo->dri_Pens[TEXTPEN] ;     // Front pen
    max = gmax ;
    gtab = new gadget *[max] ;
    ng = new NewGadget ;
    it = new IntuiText ;

    ng->ng_VisualInfo = win->ws->vi ;
    setfont((TTextAttr *)win->ws->screen->Font) ;

    ng->ng_GadgetText = NULL ;
    ng->ng_Width = width ;
    ng->ng_Height = height ;
    ng->ng_LeftEdge = left ;
    ng->ng_TopEdge = top ;
d72 1
a72 2
    gad = (struct Gadget *)CreateContext(&glist);
    wp = win->win ;
a75 1
int i;
d81 9
a89 3
    FreeGadgets(glist) ;
    for (i=0; i<count; i++) {
        delete gtab[i] ;
d91 2
a92 3
    delete [] gtab ;
    delete ng ;
    delete it ;
d140 1
a140 1
long gadgetlist::ltext(STRPTR s)
d142 1
a142 1
    it->IText = s ;
d146 1
a146 1
long gadgetlist::lmax(STRPTR *ms)
d156 1
a156 1
long gadgetlist::lmax(STRPTR s, ...)
d158 1
a158 1
STRPTR *ms = &s ;
@


1.1
log
@Initial revision
@
text
@d181 1
a181 1
}@
