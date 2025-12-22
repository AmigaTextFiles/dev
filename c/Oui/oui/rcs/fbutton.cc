head	1.4;
access;
symbols;
locks
	dlorre:1.4; strict;
comment	@// @;


1.4
date	98.04.08.15.11.45;	author dlorre;	state Exp;
branches;
next	1.3;

1.3
date	97.07.14.04.21.01;	author dlorre;	state Exp;
branches;
next	1.2;

1.2
date	96.08.28.20.01.03;	author dlorre;	state Exp;
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
@label initialization moved to separate functions
@
text
@//$Id: fbutton.cc 1.3 1997/07/14 04:21:01 dlorre Exp dlorre $
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
#include "gadgets/fbutton.h"
#include "gadgets/eclass.h"
#include "gadgetlist.h"

#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/graphics.h>
#include <proto/intuition.h>
#include <proto/utility.h>
#include <clib/alib_protos.h>
#include <compiler.h>

static int InitBoxImage(void) ;
static void FreeBoxImage(void) ;
static struct Image *BoxImage ;


// Ces déclarations ne sont plus statiques puisque la classe devient globale

Class *BOOPSIfbutton ;
int InitFButton(void) ;
void FreeFButton(void) ;

extern "C" STDARGS ULONG HookEntry() ;


// ========================================================================
// ========================== FBUTTON CLASS ===============================
// ========================================================================

fbutton::fbutton(gadgetlist *gl,
               void (window::*func)(gadget *, unsigned long, unsigned short),
               const char *t, BOOL def, BOOL disable) : gadget(gl, func),
                                        it1(NULL), it2(NULL), it3(NULL),
                                        norm1(NULL), norm2(NULL), under(NULL),
                                        font(NULL), underline(NULL)
{
    InitBoxImage() ;
    InitFButton() ;

    if (t) {
        if (def) glist->setdefault(TRUE) ;
        initlab(t) ;
    }

    gad = gl->gad = (Gadget *)NewObject(BOOPSIfbutton, NULL,
            GA_ID,          id,
            GA_Top,         gl->ng->ng_TopEdge,
            GA_Left,        gl->ng->ng_LeftEdge,
            GA_Width,       gl->ng->ng_Width,
            GA_Height,      gl->ng->ng_Height,

            GA_Immediate,   TRUE,
            GA_RelVerify,   TRUE,

            GA_Previous,    gl->gad,
            GA_IntuiText,   it1 ,
            GA_Image,       BoxImage,

            GA_UserData,    EGA_Pulse,
            GA_Disabled,    disable,
            EGA_XPens,      gl->win->ws->xpens,

            TAG_END) ;

    if (def) gl->setdefault(FALSE) ;
}

fbutton::~fbutton()
{
    freelab() ;
    if (gad) DisposeObject(gad) ;
    FreeFButton() ;
    FreeBoxImage() ;
}

void fbutton::select(BOOL sel, BOOL disable)
{
    SetGadgetAttrs((Gadget *)gad, w, NULL,
        GA_Selected,    sel,
        GA_Disabled,    disable,
        TAG_END) ;
    RefreshGList((Gadget *)gad, w, NULL, 1);
}


void fbutton::keystroke(BOOL shifted)
{
    select(TRUE) ;
    Delay(5) ;
    select(FALSE) ;
    Delay(5) ;
    gadget::action(NULL, NULL) ;
}

void fbutton::action(unsigned long classe, unsigned short code)
{
    if (classe != IDCMP_GADGETDOWN) {
        gadget::action(classe, code) ;
    }
}


void fbutton::initlab(const char *t)
{
BOOL    underset = FALSE ;
int     i, l1, l2 ;

    if (t) {

        it1 = new IntuiText ;
        it2 = new IntuiText ;
        it3 = new IntuiText ;

        underline = new TTextAttr ;

        it1->FrontPen = it2->FrontPen = it3->FrontPen = glist->gpen ;
        it1->BackPen = it2->BackPen = it3->BackPen = 0 ;
        it1->DrawMode = it2->DrawMode = it3->DrawMode = JAM1 ;

        norm1 = new char[strlen(t)+1] ;
        norm2 = new char[strlen(t)+1] ;
        under = new char[2] ;

        underkey(t) ;

        CopyMem(glist->ng->ng_TextAttr, underline, sizeof(struct TTextAttr)) ;
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
            it1->ITextFont = glist->ng->ng_TextAttr ;
            if (underset) {
                it1->NextText = it2 ;
                it2->LeftEdge = short(IntuiTextLength(it1)) ;
                it2->IText = (UBYTE *)under ;
                it2->ITextFont = (TextAttr *)underline ;
                if (l2) {
                    it2->NextText = it3 ;
                    it3->LeftEdge = short(it2->LeftEdge + IntuiTextLength(it2)) ;
                    it3->IText = (UBYTE *)norm2 ;
                    it3->ITextFont = glist->ng->ng_TextAttr ;
                }
            }
        }
        else if (underset) {
            it1->IText = (UBYTE *)under ;
            it1->ITextFont = (TextAttr *)underline ;
            it1->NextText = it2 ;
            it2->LeftEdge = short(IntuiTextLength(it1)) ;
            it2->IText = (UBYTE *)norm2 ;
            it2->ITextFont = glist->ng->ng_TextAttr ;
        }
    }
}


void fbutton::freelab()
{
    if (norm1) delete norm1 ;
    if (norm2) delete norm2 ;
    if (under) delete under ;

    if (it1) delete it1 ;
    if (it2) delete it2 ;
    if (it3) delete it3 ;

    if (underline) delete underline ;

    if (font) CloseFont(font) ;
}


void fbutton::set(const char *text)
{
    if (text) {
    freelab() ;
    initlab(text) ;
    SetGadgetAttrs((Gadget *)gad, w, NULL,
        GA_IntuiText,    it1,
        TAG_END) ;
    }
}


static int BoxImageCnt = 0 ;
int InitBoxImage(void)
{
    if (BoxImageCnt) {
        BoxImageCnt++ ;
    }
    else if (
        BoxImage = (struct Image *)NewObject(NULL, (UBYTE *)FRAMEICLASS,
        IA_FrameType,   FRAME_BUTTON,
        IA_EdgesOnly,   TRUE,
        TAG_END)) {
        BoxImageCnt = 1 ;
    }
    else
        BoxImageCnt = 0 ;

    return (BoxImageCnt) ;
}

void FreeBoxImage(void)
{
    BoxImageCnt-- ;
    if (!BoxImageCnt) {
        // This is a DEFENSIVE programming test
        // i.e. not needed under normal conditions
        if (BoxImage) DisposeObject(BoxImage) ;
    }
}


// ========================================================================
// =============================== FBUT ===================================
// ========================================================================

#define DRAW_NONE       0
#define DRAW_IMAGE      1
#define DRAW_INTUITEXT  2
#define DRAW_TEXT       3

struct FButtonINST {
    Image       *LabelImage ;
    Image       *Img ;
    IntuiText   *IText ;
    STRPTR      Text ;
    LONG        Mode ;
    UWORD       *XPens ;
} ;

static ULONG STDARGS dispatchFButton(Class *cl, Object *o, Msg msg);

static void    NotifyFButton(Class *, Object *, ULONG, long, gpInput *) ;

static ULONG   RenderFButton(Class *, Gadget *, gpRender *) ;

static void    FButtonLims(FButtonINST *inst, Gadget *g, GadgetInfo *gi) ;

static int FButtonCnt = 0 ;

static UWORD ditherData[] = { 0x5555, 0xAAAA } ;

int InitFButton(void)
{
    if (FButtonCnt) {
        FButtonCnt++ ;
    }
    else if (!(BOOPSIfbutton = MakeClass(NULL, (UBYTE *)GADGETCLASS, NULL,
        sizeof(FButtonINST), 0))) {
        FButtonCnt = 0 ;
    }
    else {
        BOOPSIfbutton->cl_Dispatcher.h_Entry = (HOOKFUNC)HookEntry ;
        BOOPSIfbutton->cl_Dispatcher.h_SubEntry = (HOOKFUNC)dispatchFButton;
        BOOPSIfbutton->cl_Dispatcher.h_Data = NULL ;
        FButtonCnt = 1 ;
    }
    return FButtonCnt ;
}

void FreeFButton(void)
{
    FButtonCnt-- ;
    if (!FButtonCnt)
        if (BOOPSIfbutton) FreeClass(BOOPSIfbutton) ;
}

ULONG SAVEDS STDARGS dispatchFButton( Class *cl, Object *o, Msg msg)
{
FButtonINST *inst ;
ULONG       retval = FALSE ;
Object      *object ;

    GETA4 ;
    switch (msg->MethodID) {
    case OM_NEW:
        if (object = (Object *)DoSuperMethodA(cl, o, msg)) {
            inst = (FButtonINST *)INST_DATA(cl, object) ;
            if ( FindTagItem(GA_Image, ((opSet *)msg)->ops_AttrList)) {
                inst->Img = (Image *)GetTagData(GA_Image,
                    NULL,
                    ((opSet *)msg)->ops_AttrList) ;
            }
            inst->XPens = (UWORD *)GetTagData(EGA_XPens, NULL,
                    ((opSet *)msg)->ops_AttrList) ;
            if ( FindTagItem(GA_Text, ((opSet *)msg)->ops_AttrList)) {
                inst->Text = (STRPTR)GetTagData(GA_Text,
                    NULL,
                    ((opSet *)msg)->ops_AttrList) ;
                inst->Mode = DRAW_TEXT ;
            }
            else if ( FindTagItem(GA_LabelImage, ((opSet *)msg)->ops_AttrList)) {
                inst->LabelImage = (Image *)GetTagData(GA_LabelImage,
                    NULL,
                    ((opSet *)msg)->ops_AttrList) ;
                inst->Mode = DRAW_IMAGE ;
            }
            else if ( FindTagItem(GA_IntuiText, ((opSet *)msg)->ops_AttrList)) {
                inst->IText = (IntuiText *)GetTagData(GA_IntuiText,
                    NULL,
                    ((opSet *)msg)->ops_AttrList) ;
                 inst->Mode = DRAW_INTUITEXT ;
            }
            else inst->Mode = DRAW_NONE ;
            retval = (ULONG)object ;
        }
        break ;
    case GM_HITTEST:
        retval = DoSuperMethodA(cl, o, msg) ;
        break ;
    case GM_GOACTIVE:
        {
        gpInput *gpi = (gpInput *)msg ;
            if (gpi->gpi_IEvent) {
                ((Gadget *)o)->Flags |= GFLG_SELECTED ;
                RenderFButton(cl, (Gadget *)o, (gpRender *)msg) ;
                retval = GMR_MEACTIVE ;
            }
            else
                retval = GMR_NOREUSE ;
        }
        break ;
    case GM_GOINACTIVE:
        ((Gadget *)o)->Flags &= ~GFLG_SELECTED ;
        RenderFButton(cl, (Gadget *)o, (gpRender *)msg) ;
        break ;
    case GM_HANDLEINPUT:
        {
            gpInput *gpi = (gpInput *)msg ;
            InputEvent *ie = gpi->gpi_IEvent ;
            Gadget *g = (Gadget *)o ;
            retval = GMR_MEACTIVE ;

            if (ie->ie_Class == IECLASS_RAWMOUSE) {
                switch (ie->ie_Code) {
                    case SELECTUP:
                        if ( (gpi->gpi_Mouse.X < 0) ||
                           (gpi->gpi_Mouse.X > g->Width) ||
                           (gpi->gpi_Mouse.Y < 0) ||
                           (gpi->gpi_Mouse.Y > g->Height) ) {
                                retval = GMR_NOREUSE  ;
                            }
                        else {
                            NotifyFButton(cl, o, 0, 0, (gpInput *)msg) ;
                            retval = GMR_NOREUSE | GMR_VERIFY ;
                        }
                        break ;
                    case MENUDOWN:
                        retval = GMR_REUSE ;
                        break ;
                    default:
                        retval = GMR_MEACTIVE ;
                }
            }
            else if (ie->ie_Class == IECLASS_TIMER) {
                if (( (gpi->gpi_Mouse.X < 0) ||
                   (gpi->gpi_Mouse.X > g->Width) ||
                   (gpi->gpi_Mouse.Y < 0) ||
                   (gpi->gpi_Mouse.Y > g->Height) )) {
                    if (g->Flags & GFLG_SELECTED) {
                        g->Flags &= ~GFLG_SELECTED ;
                        RenderFButton(cl, g, (gpRender *)msg) ;
                    }
                }
                else {
                    if (!(g->Flags & GFLG_SELECTED)) {
                        g->Flags |= GFLG_SELECTED ;
                        NotifyFButton(cl, o, OPUF_INTERIM, 0, (gpInput *)msg) ;
                        RenderFButton(cl, g, (gpRender *)msg) ;
                    }
                }
            }
        }
        break ;
    case OM_SET:
        retval = DoSuperMethodA(cl, o, msg) ;
        if ( FindTagItem(GA_Text, ((opSet *)msg)->ops_AttrList) ||
             FindTagItem(GA_IntuiText, ((opSet *)msg)->ops_AttrList) ||
             FindTagItem(GA_LabelImage, ((opSet *)msg)->ops_AttrList) ) {
            RastPort *rp ;
            Gadget *g  = (Gadget *)o ;

            inst = (FButtonINST *)INST_DATA(cl, o) ;

            if ( FindTagItem(GA_Text, ((opSet *)msg)->ops_AttrList)) {
                inst->Text = (STRPTR)GetTagData(GA_Text,
                    (ULONG)inst->Text,
                    ((opSet *)msg)->ops_AttrList) ;
                inst->Mode = DRAW_TEXT ;
            }
            else if ( FindTagItem(GA_LabelImage, ((opSet *)msg)->ops_AttrList)) {
                inst->LabelImage = (Image *)GetTagData(GA_LabelImage,
                    (ULONG)inst->LabelImage,
                    ((opSet *)msg)->ops_AttrList) ;
                inst->Mode = DRAW_IMAGE ;
            }
            else if ( FindTagItem(GA_IntuiText, ((opSet *)msg)->ops_AttrList)) {
                inst->IText = (IntuiText *)GetTagData(GA_IntuiText,
                    (ULONG)inst->IText,
                    ((opSet *)msg)->ops_AttrList) ;
                 inst->Mode = DRAW_INTUITEXT ;
            }
            if (rp = ObtainGIRPort( ((opSet *)msg)->ops_GInfo) ) {

                DoMethod(o, GM_RENDER, ((opSet *)msg)->ops_GInfo, rp, GREDRAW_REDRAW) ;
                ReleaseGIRPort(rp) ;
            }
        }
        break ;
    case GM_RENDER:
        retval = RenderFButton(cl, (Gadget *)o, (gpRender *)msg) ;
        break ;
    default :
        retval = DoSuperMethodA(cl, o, msg) ;
        break ;
    }
    return retval ;
}


void SAVEDS NotifyFButton(Class *cl, Object *o, ULONG flags, long level, gpInput *gpi)
{
static TagItem tt[3] ;

    GETA4 ;
    tt[0].ti_Tag = EGA_Pulse ;
    tt[0].ti_Data = level  ;

    tt[1].ti_Tag = GA_ID ;
    tt[1].ti_Data = ((Gadget *)o)->GadgetID ;

    tt[2].ti_Tag = TAG_DONE ;

    DoSuperMethod(cl, o, OM_NOTIFY, tt, gpi->gpi_GInfo, flags) ;
}

ULONG SAVEDS RenderFButton(Class *cl, Gadget *g, gpRender *msg)
{
RastPort    *rp ;
ULONG       retval = TRUE ;
UWORD       *pens = msg->gpr_GInfo->gi_DrInfo->dri_Pens ;
FButtonINST *inst = (FButtonINST *)INST_DATA(cl, (Object *)g) ;
ULONG       state ;
impDraw     imp ;
IntuiText   *itext ;
LONG        l, t ;
IBox        cbox, fbox ;
impFrameBox ifb ;

    GETA4 ;
    if (msg->MethodID == GM_RENDER)
        rp = msg->gpr_RPort ;
    else
        rp = ObtainGIRPort(msg->gpr_GInfo) ;
    if (rp) {

        if (g->Flags & GFLG_SELECTED)
            state = IDS_SELECTED ;
        else if (g->Flags & GFLG_DISABLED)
            state = IDS_DISABLED ;
        else
            state = IDS_NORMAL ;

        cbox.Left = g->LeftEdge ;
        cbox.Top = g->TopEdge ;
        cbox.Width = g->Width ;
        cbox.Height = g->Height ;

        ifb.MethodID = IM_FRAMEBOX ;
        ifb.imp_ContentsBox = &cbox ;
        ifb.imp_FrameBox = &fbox ;
        ifb.imp_DrInfo = msg->gpr_GInfo->gi_DrInfo ;
        ifb.imp_FrameFlags = NULL ;
        DoMethodA((Object *)inst->Img, (Msg)&ifb) ;

        SetAPen(rp, (g->Flags & GFLG_SELECTED)?pens[FILLPEN]:inst->XPens[BUTTONFILL_PEN]) ;
        RectFill(rp, g->LeftEdge, g->TopEdge,
            g->LeftEdge+g->Width-1, g->TopEdge+g->Height-1) ;

        imp.MethodID = IM_DRAWFRAME ;
        imp.imp_RPort = rp ;
        imp.imp_Offset.X = g->LeftEdge ;
        imp.imp_Offset.Y = g->TopEdge ;
        imp.imp_State = state ;
        imp.imp_DrInfo = msg->gpr_GInfo->gi_DrInfo ;
        imp.imp_Dimensions.Width = g->Width ;
        imp.imp_Dimensions.Height = g->Height ;

        DoMethodA((Object *)inst->Img, (Msg)&imp) ;

        if (state == IDS_DISABLED) {
            SetAPen(rp, 1) ;
            SetAfPt(rp, ditherData, 1) ;
            RectFill(rp, g->LeftEdge, g->TopEdge, g->LeftEdge+g->Width-1, g->TopEdge+g->Height-1) ;
            SetAfPt(rp, NULL, 0) ;
        }

        switch (inst->Mode) {
        case DRAW_NONE:
            break ;
        case DRAW_TEXT:
            Move(rp, g->LeftEdge, g->TopEdge+rp->TxBaseline) ;
            Text(rp, inst->Text, strlen(inst->Text)) ;
            break ;
        case DRAW_INTUITEXT:
            itext = inst->IText ;
            while (itext->NextText) itext = itext->NextText ;
            l = IntuiTextLength(itext) + itext->LeftEdge ;
            l = g->LeftEdge + 1 + (g->Width - l - 2) / 2 ;
            t = g->TopEdge + 1 + (g->Height - itext->ITextFont->ta_YSize -2) / 2 ;
            PrintIText(rp, inst->IText, l, t) ;
            break ;
        case DRAW_IMAGE:
            // ne pas afficher les images trop grandes pour le gadget

            if (inst->LabelImage->Width < g->Width &&
                inst->LabelImage->Height < g->Height) {

            // Centrage de l'image
            l = g->LeftEdge + (g->Width - inst->LabelImage->Width) /  2 ;
            t = g->TopEdge + (g->Height - inst->LabelImage->Height) /  2 ;
            DrawImageState(rp,
                inst->LabelImage,
                l, t,
                state,
                msg->gpr_GInfo->gi_DrInfo) ;
            }
            break ;
        }
        if (msg->MethodID != GM_RENDER)
            ReleaseGIRPort(rp) ;

    }
    else
        retval = FALSE ;
    return retval ;
}


@


1.3
log
@*** empty log message ***
@
text
@d1 1
a1 1
//$Id$
d54 64
a117 1
BOOL    underset = FALSE ;
a118 1
int i, l1, l2 ;
d120 4
a123 2
    InitBoxImage() ;
    InitFButton() ;
d133 1
a133 1
        it1->FrontPen = it2->FrontPen = it3->FrontPen = gl->gpen ;
a141 1
        if (def) gl->setdefault(TRUE) ;
d143 1
a143 1
        CopyMem(gl->ng->ng_TextAttr, underline, sizeof(struct TTextAttr)) ;
d167 1
a167 1
            it1->ITextFont = gl->ng->ng_TextAttr ;
d177 1
a177 1
                    it3->ITextFont = gl->ng->ng_TextAttr ;
d187 1
a187 1
            it2->ITextFont = gl->ng->ng_TextAttr ;
d190 1
a191 19
    gad = gl->gad = (Gadget *)NewObject(BOOPSIfbutton, NULL,
            GA_ID,          id,
            GA_Top,         gl->ng->ng_TopEdge,
            GA_Left,        gl->ng->ng_LeftEdge,
            GA_Width,       gl->ng->ng_Width,
            GA_Height,      gl->ng->ng_Height,

            GA_Immediate,   TRUE,
            GA_RelVerify,   TRUE,

            GA_Previous,    gl->gad,
            GA_IntuiText,   it1 ,
            GA_Image,       BoxImage,

            GA_UserData,    EGA_Pulse,
            GA_Disabled,    disable,
            EGA_XPens,      gl->win->ws->xpens,

            TAG_END) ;
d193 1
a193 4
    if (def) gl->setdefault(FALSE) ;
}

fbutton::~fbutton()
a204 1
    if (gad) DisposeObject(gad) ;
a205 2
    FreeFButton() ;
    FreeBoxImage() ;
d208 2
a209 1
void fbutton::select(BOOL sel, BOOL disable)
d211 3
d215 1
a215 2
        GA_Selected,    sel,
        GA_Disabled,    disable,
a216 17
    RefreshGList((Gadget *)gad, w, NULL, 1);
}


void fbutton::keystroke(BOOL shifted)
{
    select(TRUE) ;
    Delay(5) ;
    select(FALSE) ;
    Delay(5) ;
    gadget::action(NULL, NULL) ;
}

void fbutton::action(unsigned long classe, unsigned short code)
{
    if (classe != IDCMP_GADGETDOWN) {
        gadget::action(classe, code) ;
d410 35
@


1.2
log
@affichage des images centrées (support imgbut)
@
text
@d1 1
d13 1
d15 2
d21 7
a27 25
#include <cxxproto/graphics.h>
#include <cxxproto/intuition.h>

extern "C" {

extern struct ExecBase *SysBase ;
void CopyMem( APTR source, APTR dest, unsigned long size );
#pragma libcall SysBase CopyMem 270 09803

extern struct DosLibrary *DOSBase ;
void Delay( long timeout );
#pragma libcall DOSBase Delay c6 101

extern struct Library *UtilityBase ;
struct TagItem *FindTagItem( Tag tagVal, struct TagItem *tagList );
ULONG GetTagData( Tag tagValue, unsigned long defaultVal,
        struct TagItem *tagList );
#include <pragmas/utility_pragmas.h>

ULONG DoMethodA( Object *obj, Msg msg);
ULONG DoSuperMethodA( struct IClass *cl, Object *obj, Msg message );
ULONG DoSuperMethod( struct IClass *cl, Object *obj, unsigned long MethodID,
        ... );
void kprintf(STRPTR format, ...) ;
}
d29 2
d40 2
d49 1
a49 1
               STRPTR t, BOOL def) :    gadget(gl, func),
d58 1
d103 1
a103 1
            it1->IText = norm1 ;
d108 1
a108 1
                it2->IText = under ;
d113 1
a113 1
                    it3->IText = norm2 ;
d119 1
a119 1
            it1->IText = under ;
d123 1
a123 1
            it2->IText = norm2 ;
d143 2
d166 1
d169 1
a169 1
void fbutton::select(BOOL sel)
d173 1
d196 2
a197 1
int _STI_4000_FButton(void)
d199 5
a203 1
    BoxImage = (struct Image *)NewObject(NULL, FRAMEICLASS,
d205 6
a210 1
        TAG_END);
d212 1
a212 1
    return (!BoxImage) ? 1 : 0 ;
d215 1
a215 1
void _STD_4000_FreeFButton(void)
d217 6
a222 1
    if (BoxImage) DisposeObject(BoxImage) ;
d237 1
a237 1
    Image       *Image ;
d241 1
d244 1
a244 2
static ULONG __asm dispatchFButton(register __a0 Class *cl,
    register __a2 Object *o, register __a1 Msg msg);
d253 3
d261 1
a261 1
    else if (!(BOOPSIfbutton = MakeClass(NULL, GADGETCLASS, NULL,
d266 3
a268 1
        BOOPSIfbutton->cl_Dispatcher.h_Entry = (HOOKFUNC)dispatchFButton;
d278 1
a278 1
        FreeClass(BOOPSIfbutton) ;
d281 1
a281 3
ULONG __saveds __asm dispatchFButton(   register __a0 Class *cl,
                                        register __a2 Object *o,
                                        register __a1 Msg msg)
d287 1
d293 1
a293 1
                inst->Image = (Image *)GetTagData(GA_Image,
d297 2
d399 1
a399 1
void __saveds NotifyFButton(Class *cl, Object *o, ULONG flags, long level, gpInput *gpi)
d403 1
d415 1
a415 1
ULONG __saveds RenderFButton(Class *cl, Gadget *g, gpRender *msg)
d425 2
d428 1
d442 16
d460 2
a461 2
        imp.imp_Offset.X = short(g->LeftEdge + 1) ;
        imp.imp_Offset.Y = short(g->TopEdge + 1) ;
d464 2
a465 2
        imp.imp_Dimensions.Width = short(g->Width - 1) ;
        imp.imp_Dimensions.Height = short(g->Height - 1) ;
d467 1
a467 1
        DoMethodA((Object *)inst->Image, (Msg)&imp) ;
d469 6
a474 8
        SetAPen(rp, pens[TEXTPEN]) ;
        SetDrMd(rp, JAM2) ;

        Move(rp, g->LeftEdge, g->TopEdge) ;
        Draw(rp, g->LeftEdge, g->TopEdge+g->Height) ;
        Draw(rp, g->LeftEdge+g->Width, g->TopEdge+g->Height) ;
        Draw(rp, g->LeftEdge+g->Width, g->TopEdge) ;
        Draw(rp, g->LeftEdge, g->TopEdge) ;
@


1.1
log
@Initial revision
@
text
@d45 6
a50 3
static Class *BOOPSIfbutton ;
static int InitFButton(void) ;
static void FreeFButton(void) ;
d78 1
a78 1
        it1->FrontPen = it2->FrontPen = it3->FrontPen = 1 ;
d458 8
d468 1
a468 1
                g->LeftEdge, g->TopEdge,
d471 1
@
