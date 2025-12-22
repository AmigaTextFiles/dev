head	1.4;
access;
symbols;
locks
	dlorre:1.4; strict;
comment	@// @;


1.4
date	98.04.08.15.09.56;	author dlorre;	state Exp;
branches;
next	1.3;

1.3
date	97.07.14.04.20.28;	author dlorre;	state Exp;
branches;
next	1.2;

1.2
date	96.08.28.19.58.57;	author dlorre;	state Exp;
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
@size adjusted
@
text
@// $Id: cstring.cc 1.3 1997/07/14 04:20:28 dlorre Exp $
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
#include "gadgets/cstring.h"
#include "gadgets/eclass.h"
#include "gadgetlist.h"

#include <proto/exec.h>
#include <proto/graphics.h>
#include <proto/intuition.h>
#include <proto/utility.h>
#include <clib/alib_protos.h>
#include <compiler.h>

Class *BOOPSIELabel ;
int InitELabel(void) ;
void FreeELabel(void) ;

extern "C" STDARGS ULONG HookEntry() ;

// ========================================================================
// ==========================  CSTRING CLASS ==============================
// ========================================================================


cstring::cstring(gadgetlist *gl,
                 void (window::*func)(gadget *, unsigned long, unsigned short),
                 const char *t,
                 const char *text,
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

    if (style & BOTTOMCSTRING)
        gtop = short(-gtop) ;
    if (style & RIGHTCSTRING)
        gleft = short(-gleft) ;
    if (style & WIDTHCSTRING)
        gwidth = short(-gwidth) ;
    if (style & HEIGHTCSTRING)
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

            (style & BOTTOMCSTRING)?GA_RelBottom:TAG_IGNORE,   TRUE,
            (style & RIGHTCSTRING)?GA_RelRight:TAG_IGNORE,     TRUE,
            (style & WIDTHCSTRING)?GA_RelWidth:TAG_IGNORE,     TRUE,
            (style & HEIGHTCSTRING)?GA_RelHeight:TAG_IGNORE,   TRUE,

            GA_Previous,    gl->gad,
            GA_IntuiText,   it1 ,
            GA_Border,      border,
            GA_Text,        text,
            EGA_Flags,      place,
            EGA_TextAttr,   gl->ng->ng_TextAttr,
            EGA_XPens,      gl->win->ws->xpens,
            EGA_GPen,       gl->gpen,

            TAG_END) ;
}

cstring::~cstring()
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

void cstring::set(const char *text)
{
    SetGadgetAttrs((Gadget *)gad, w, NULL,
        GA_Text,    text,
        TAG_END) ;
}

void cstring::keystroke(BOOL shifted)
{
    if (gfunc)
        gadget::action(NULL, 0) ;
    else
        glist->selectgadget(id+1, shifted) ;
}


// ========================================================================
// =============================== ELabel =================================
// ========================================================================

struct ELabelINST {
    IntuiText   *IText ;
    TextFont    *TFont ;
    STRPTR      Text ;
    LONG        Val ;
    LONG        Flags ;
    BOOL        Border ;
    UWORD       *XPens ;
    UWORD       GPen ;
    WORD        LeftEdge ;
    WORD        TopEdge ;
    WORD        Width ;
    WORD        Height ;
    BOOL        Drawable ;
    BOOL        IsNum ;
    BOOL        DrawAll ;
} ;

static ULONG STDARGS dispatchELabel(Class *cl, Object *o, Msg msg);
static ULONG   RenderELabel(Class *, Gadget *, gpRender *) ;

void  SetLims(ELabelINST *inst, Gadget *g, GadgetInfo *gi) ;
static unsigned short ditherData[2] = {0x5555,0xAAAA};

static int ELabelCnt = 0 ;
int InitELabel(void)
{
    if (ELabelCnt) {
        ELabelCnt++ ;
    }
    else if (!(BOOPSIELabel = MakeClass(NULL, (UBYTE *)GADGETCLASS, NULL,
        sizeof(ELabelINST), 0))) {
        ELabelCnt = 0 ;
    }
    else {
        BOOPSIELabel->cl_Dispatcher.h_Entry = (HOOKFUNC)HookEntry ;
        BOOPSIELabel->cl_Dispatcher.h_SubEntry = (HOOKFUNC)dispatchELabel;
        ELabelCnt = 1 ;
    }
    return ELabelCnt ;
}

void FreeELabel(void)
{
    ELabelCnt-- ;
    if (!ELabelCnt)
        FreeClass(BOOPSIELabel) ;
}

ULONG SAVEDS STDARGS dispatchELabel(  Class *cl, Object *o, Msg msg)
{
ELabelINST  *inst ;
ULONG       retval = FALSE ;
Object      *object ;
TTextAttr   *ta ;

    GETA4 ;
    switch (msg->MethodID) {
    case OM_NEW:
        if (object = (Object *)DoSuperMethodA(cl, o, msg)) {
            Gadget *g = (Gadget *)object ;
            inst = (ELabelINST *)INST_DATA(cl, object) ;
            inst->IText = (IntuiText *)GetTagData(GA_IntuiText,
                NULL,
                ((opSet *)msg)->ops_AttrList) ;
            inst->Flags = (LONG)GetTagData(EGA_Flags, PLACETEXT_LEFT,
                    ((opSet *)msg)->ops_AttrList) ;
            inst->Text = (STRPTR)GetTagData(GA_Text, NULL,
                    ((opSet *)msg)->ops_AttrList) ;
            inst->Border = (BOOL)GetTagData(GA_Border, FALSE,
                    ((opSet *)msg)->ops_AttrList) ;
            inst->XPens = (UWORD *)GetTagData(EGA_XPens, NULL,
                    ((opSet *)msg)->ops_AttrList) ;

            inst->GPen = (UWORD)GetTagData(EGA_GPen, NULL,
                    ((opSet *)msg)->ops_AttrList) ;

            inst->IsNum = BOOL(FindTagItem(EGA_Number,
                                     ((opSet *)msg)->ops_AttrList) != NULL) ;
            if (inst->IsNum)
                inst->Val = (LONG)GetTagData(EGA_Number, NULL,
                    ((opSet *)msg)->ops_AttrList) ;

            inst->DrawAll = TRUE ;

            if (g->Flags & GFLG_RELRIGHT)
                g->LeftEdge = (short)GetTagData(GA_Left, g->LeftEdge, ((opSet *)msg)->ops_AttrList) ;
            if (g->Flags & GFLG_RELHEIGHT)
                g->Height = (short)GetTagData(GA_Height, g->Height, ((opSet *)msg)->ops_AttrList) ;
            if (g->Flags & GFLG_RELWIDTH)
                g->Width = (short)GetTagData(GA_Width, g->Width, ((opSet *)msg)->ops_AttrList) ;
            if (g->Flags & GFLG_RELBOTTOM)
                g->TopEdge = (short)GetTagData(GA_Top, g->TopEdge, ((opSet *)msg)->ops_AttrList) ;

            ta = (TTextAttr *)GetTagData(EGA_TextAttr, NULL,
                    ((opSet *)msg)->ops_AttrList) ;

            if (ta) {
                inst->TFont = OpenFont((TextAttr *)ta) ;
            }
            retval = (ULONG)object ;
        }
        break ;
    case OM_DISPOSE:
        inst = (ELabelINST *)INST_DATA(cl, o) ;
        if (inst->TFont) CloseFont(inst->TFont) ;
        retval = DoSuperMethodA(cl, o, msg) ;
        break ;
    case OM_SET:
        retval = DoSuperMethodA(cl, o, msg) ;
        if ( FindTagItem(GA_Text, ((opSet *)msg)->ops_AttrList) ||
             FindTagItem(EGA_Number, ((opSet *)msg)->ops_AttrList) ) {
            RastPort *rp ;
            Gadget *g  = (Gadget *)o ;

            inst = (ELabelINST *)INST_DATA(cl, o) ;
            inst->Text = (STRPTR)GetTagData(GA_Text, (ULONG)inst->Text, ((opSet *)msg)->ops_AttrList) ;
            inst->Val = (LONG)GetTagData(EGA_Number, (ULONG)inst->Val, ((opSet *)msg)->ops_AttrList) ;
            inst->DrawAll = FALSE ;

            if (rp = ObtainGIRPort( ((opSet *)msg)->ops_GInfo) ) {

                DoMethod(o, GM_RENDER, ((opSet *)msg)->ops_GInfo, rp, GREDRAW_REDRAW) ;
                ReleaseGIRPort(rp) ;
            }
            inst->DrawAll = TRUE ;
        }
        break ;
    case GM_RENDER:
        retval = RenderELabel(cl, (Gadget *)o, (gpRender *)msg) ;
        break ;
    default :
        retval = DoSuperMethodA(cl, o, msg) ;
        break ;
    }
    return retval ;
}


ULONG SAVEDS RenderELabel(Class *cl, Gadget *g, gpRender *msg)
{
RastPort            *rp ;       // RastPort où le gadget est affiché
ULONG               retval ;    // Code de retour
UWORD               *pens ;     // pinceaux de l'écran
UWORD               tpen ;      // couleur du texte
ELabelINST          *inst ;     // pointeur sur les données
IntuiText           *itext ;    // affichage du label
LONG                l, t, len ; // left, top, len utilisés pour l'affichage
struct TextExtent   te ;        // Calcul de la largeur du texte


    GETA4 ;
    // Initialisations

    // Affectation du RastPort selon la méthode d'appel

    if (msg->MethodID == GM_RENDER)
        rp = msg->gpr_RPort ;
    else
        rp = ObtainGIRPort(msg->gpr_GInfo) ;

    if (rp) {

        retval = TRUE ;
        pens = msg->gpr_GInfo->gi_DrInfo->dri_Pens ;
        inst = (ELabelINST *)INST_DATA(cl, (Object *)g) ;

        tpen = inst->GPen ;
        WaitTOF() ;
        if (inst->DrawAll) {
            EraseRect(rp, inst->LeftEdge, inst->TopEdge,
                inst->LeftEdge+inst->Width-1, inst->TopEdge+inst->Height-1) ;
        }
        else {
            SetAPen(rp, (inst->Border)?inst->XPens[GFILL_PEN]:pens[BACKGROUNDPEN]) ;
            RectFill(rp, inst->LeftEdge+2, inst->TopEdge+2,
                inst->LeftEdge+inst->Width-3, inst->TopEdge+inst->Height-3) ;
        }
        SetLims(inst, g, msg->gpr_GInfo) ;  // Calcul des limites
        if (!inst->Drawable) {
            retval = FALSE ;
            goto out ;
        }

        SetDrMd(rp, JAM2) ;
        SetAPen(rp, pens[TEXTPEN]) ;
        SetBPen(rp, (inst->Border)?inst->XPens[GFILL_PEN]:pens[BACKGROUNDPEN]) ;

        if (inst->Border && inst->DrawAll) {
            SetAPen(rp, inst->XPens[GFILL_PEN]) ;
            RectFill(rp, inst->LeftEdge+1, inst->TopEdge+1,
                inst->LeftEdge+inst->Width-2, inst->TopEdge+inst->Height-2) ;

            SetAPen(rp, pens[SHINEPEN]) ;

            Move(rp, inst->LeftEdge+1, inst->TopEdge+inst->Height-1) ;
            Draw(rp, inst->LeftEdge+1, inst->TopEdge+1) ;
            Draw(rp, inst->LeftEdge+inst->Width-1, inst->TopEdge+1) ;
            Draw(rp, inst->LeftEdge+inst->Width-1, inst->TopEdge+inst->Height-1) ;
            Draw(rp, inst->LeftEdge, inst->TopEdge+inst->Height-1) ;

            SetAPen(rp, pens[SHADOWPEN]) ;

            Move(rp, inst->LeftEdge, inst->TopEdge) ;
            Draw(rp, inst->LeftEdge+inst->Width-2, inst->TopEdge) ;
            Draw(rp, inst->LeftEdge+inst->Width-2, inst->TopEdge+inst->Height-2) ;
            Draw(rp, inst->LeftEdge, inst->TopEdge+inst->Height-2) ;
            Draw(rp, inst->LeftEdge, inst->TopEdge) ;
        }


        if (inst->IText) {  // Le gagdet possède un label
            itext = inst->IText ;

            // recherche du dernier itext pour la longueur

            while (itext->NextText) itext = itext->NextText ;

            // Le calcul par défaut est pour PLACETEXT_IN

            len = IntuiTextLength(itext) + itext->LeftEdge ;
            t = inst->TopEdge + 1 +
                (inst->Height - itext->ITextFont->ta_YSize -2) / 2 ;
            l = inst->LeftEdge + 1 + (inst->Width - len - 2) / 2 ;


            if (inst->Flags & PLACETEXT_RIGHT) {
                l = inst->LeftEdge + inst->Width + 4 ;
            }
            else if (inst->Flags & PLACETEXT_ABOVE) {
                t = inst->TopEdge - itext->ITextFont->ta_YSize - 4 ;
            }
            else if (inst->Flags & PLACETEXT_BELOW) {
                t = inst->TopEdge + inst->Height + 4 ;
            }
            else if (!(inst->Flags & PLACETEXT_IN)) {  // PLACETEXT_LEFT
                l = inst->LeftEdge - len - 4 ;
            }
            PrintIText(rp, inst->IText, l, t) ;
        }
        if (inst->IsNum) {
        char text[20] ;
            sprintf(text, "%ld", inst->Val) ;
            SetAPen(rp, tpen) ; // Couleur du pinceau

            if (inst->TFont) SetFont(rp, inst->TFont) ;


            len = (long)TextFit(rp, text,
                strlen(text), &te, NULL, 1,
                 inst->Width-4, inst->Height-2) ;


            l = inst->LeftEdge + (inst->Width - te.te_Width) / 2 ;
            t = inst->TopEdge + (inst->Height -
                    te.te_Extent.MinY - te.te_Extent.MaxY) / 2 ;

            Move(rp, l, t) ;
            Text(rp, text, len) ;
        }
        else if (inst->Text) {   // Le gadget contient un texte

            SetAPen(rp, tpen) ; // Couleur du pinceau

            if (inst->TFont) SetFont(rp, inst->TFont) ;

            len = (long)TextFit(rp, inst->Text,
                strlen(inst->Text), &te, NULL, 1,
                 inst->Width-4, inst->Height-2) ;

            if (inst->Width > te.te_Width)
                l = inst->LeftEdge + (inst->Width - te.te_Width) / 2 ;
            else
                l = inst->LeftEdge+2 ;
            t = inst->TopEdge + (inst->Height -
                    te.te_Extent.MinY - te.te_Extent.MaxY) / 2 ;

            Move(rp, l, t) ;
            Text(rp, inst->Text, len) ;
        }
out:
        if (msg->MethodID != GM_RENDER)
            ReleaseGIRPort(rp) ;
    }
    else
        retval = FALSE ;
    return retval ;
}


void SAVEDS SetLims(ELabelINST *inst, Gadget *g, GadgetInfo *gi)
{
long GLeft, GTop, GWidth, GHeight ;

    GETA4 ;
    GLeft = g->LeftEdge ;
    GTop = g->TopEdge ;
    GWidth = g->Width  ;
    GHeight = g->Height ;

    if (g->Flags & GFLG_RELRIGHT) {
        GLeft = gi->gi_Window->Width - 1 ;
        GLeft += g->LeftEdge ;
    }

    if (g->Flags & GFLG_RELHEIGHT) {
        GHeight = gi->gi_Window->Height ;
        GHeight += g->Height ;
    }

    if (g->Flags & GFLG_RELBOTTOM) {
        GTop = gi->gi_Window->Height - 1 ;
        GTop += g->TopEdge ;
    }

    if (g->Flags & GFLG_RELWIDTH) {
        GWidth = gi->gi_Window->Width ;
        GWidth += g->Width ;
    }
    inst->Drawable = BOOL(GLeft >= 0 && GTop >= 0 &&
        GWidth > 4 &&
        GHeight > 4) ;
    if (inst->Drawable) {
        inst->LeftEdge = GLeft ;
        inst->TopEdge = GTop ;
        inst->Width = GWidth ;
        inst->Height = GHeight ;
    }

}
@


1.3
log
@*** empty log message ***
@
text
@d1 1
a1 1
// $Id: cstring.cc 1.2 1996/08/28 19:58:57 dlorre Exp dlorre $
d468 4
a471 1
            l = inst->LeftEdge + (inst->Width - te.te_Width) / 2 ;
@


1.2
log
@changement look + ajout support pour cnumber
@
text
@d1 1
a1 1
// $Id$
d14 1
d22 6
a27 18
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
d33 2
d42 2
a43 2
                 STRPTR t,
                 STRPTR text,
d88 2
a89 2
        CopyMem(gl->win->ws->screen->Font, plain, sizeof(struct TTextAttr)) ;
        CopyMem(gl->win->ws->screen->Font, underline, sizeof(struct TTextAttr)) ;
d112 1
a112 1
            it1->IText = norm1 ;
d117 1
a117 1
                it2->IText = under ;
d122 1
a122 1
                    it3->IText = norm2 ;
d128 1
a128 1
            it1->IText = under ;
d132 1
a132 1
            it2->IText = norm2 ;
a147 1

d178 1
a178 1
void cstring::set(STRPTR text)
d200 1
a200 1
    TextFont    *TextFont ;
d213 1
d216 2
a217 2
static ULONG __asm dispatchELabel(register __a0 Class *cl,
    register __a2 Object *o, register __a1 Msg msg);
a218 1
static ULONG   RenderELabel(Class *, Gadget *, gpRender *) ;
d228 1
a228 1
    else if (!(BOOPSIELabel = MakeClass(NULL, GADGETCLASS, NULL,
d233 2
a234 1
        BOOPSIELabel->cl_Dispatcher.h_Entry = (HOOKFUNC)dispatchELabel;
d247 1
a247 3
ULONG __saveds __asm dispatchELabel(   register __a0 Class *cl,
                                        register __a2 Object *o,
                                        register __a1 Msg msg)
d254 1
d281 2
d296 1
a296 1
                inst->TextFont = OpenFont((TextAttr *)ta) ;
d303 1
a303 1
        if (inst->TextFont) CloseFont(inst->TextFont) ;
d316 1
d323 1
d337 1
a337 1
ULONG __saveds RenderELabel(Class *cl, Gadget *g, gpRender *msg)
d349 1
a351 1

a365 1

d367 9
a375 2

        EraseRect(rp, inst->LeftEdge, inst->TopEdge, inst->LeftEdge+inst->Width-1, inst->TopEdge+inst->Height-1) ;
d386 1
a386 1
        if (inst->Border) {
d389 1
a389 1
                inst->LeftEdge+inst->Width-1, inst->TopEdge+inst->Height-1) ;
d395 3
a397 3
            Draw(rp, inst->LeftEdge+inst->Width, inst->TopEdge+1) ;
            Draw(rp, inst->LeftEdge+inst->Width, inst->TopEdge+inst->Height) ;
            Draw(rp, inst->LeftEdge, inst->TopEdge+inst->Height) ;
d402 3
a404 3
            Draw(rp, inst->LeftEdge+inst->Width-1, inst->TopEdge) ;
            Draw(rp, inst->LeftEdge+inst->Width-1, inst->TopEdge+inst->Height-1) ;
            Draw(rp, inst->LeftEdge, inst->TopEdge+inst->Height-1) ;
d443 1
a443 1
            if (inst->TextFont) SetFont(rp, inst->TextFont) ;
d462 1
a462 2
            if (inst->TextFont) SetFont(rp, inst->TextFont) ;

a467 1

d485 1
a485 1
void __saveds SetLims(ELabelINST *inst, Gadget *g, GadgetInfo *gi)
d489 1
d496 1
a496 1
        GLeft = gi->gi_Window->Width ;
d506 1
a506 1
        GTop = gi->gi_Window->Height ;
@


1.1
log
@Initial revision
@
text
@d1 1
d40 3
a42 3
static Class *BOOPSIELabel ;
static int InitELabel(void) ;
static void FreeELabel(void) ;
d212 1
d222 1
d285 6
d316 2
a317 1
        if ( FindTagItem(GA_Text, ((opSet *)msg)->ops_AttrList)) {
d323 1
d393 5
a397 3
            Move(rp, inst->LeftEdge, inst->TopEdge+inst->Height-1) ;
            Draw(rp, inst->LeftEdge+inst->Width-1, inst->TopEdge+inst->Height-1) ;
            Draw(rp, inst->LeftEdge+inst->Width-1, inst->TopEdge) ;
d399 1
a399 1
            SetAPen(rp, pens[TEXTPEN]) ;
d401 5
a405 5
            Move(rp, inst->LeftEdge+1, inst->TopEdge+1) ;
            Draw(rp, inst->LeftEdge+1, inst->TopEdge+inst->Height-2) ;
            Draw(rp, inst->LeftEdge+inst->Width-2, inst->TopEdge+inst->Height-2) ;
            Draw(rp, inst->LeftEdge+inst->Width-2, inst->TopEdge+1) ;
            Draw(rp, inst->LeftEdge+1, inst->TopEdge+1) ;
d438 21
a458 1
        if (inst->Text) {   // Le gadget contient un texte
a489 1
long KWidth, KHeight ;
@
