// $Id: eslide.cc 1.5 1998/01/13 19:56:31 dlorre Exp $
#include <graphics/gfxmacros.h>
#include <intuition/classes.h>
#include <intuition/classusr.h>
#include <intuition/gadgetclass.h>
#include <intuition/cghooks.h>
#include <intuition/icclass.h>
#include <utility/tagitem.h>
#include <utility/hooks.h>
#include <libraries/gadtools.h>
#include <stdio.h>
#include <string.h>
#include <mydebug.h>
#include <compiler.h>

#include "gadgets/eslide.h"
#include "gadgetlist.h"
#include "window.h"
#include "screen.h"
#include "gadgets/eclass.h"

#include <proto/graphics.h>
#include <proto/intuition.h>
#include <proto/utility.h>
#include <clib/alib_protos.h>

static Class *BOOPSIeslide ;
static int InitESlide(void) ;
static void FreeESlide(void) ;

extern "C" STDARGS ULONG HookEntry() ;

// ========================================================================
// ============================  ESLIDE CLASS =============================
// ========================================================================


eslide::eslide(gadgetlist *gl,
               void (window::*func)(gadget *, unsigned long, unsigned short),
               long min,
               long max,
               long level,
               long freedom,
               const char *t,
               long flags) : gadget(gl, func)
{
int i, l1, l2 ;
BOOL underset = FALSE ;
UWORD *pens = gl->win->ws->drawinfo->dri_Pens;

    smin = min ;
    smax = max ;
    cursel = level ;
    disabled = FALSE ;

    InitESlide() ;

    if (t) {

        it1 = new IntuiText ;
        it2 = new IntuiText ;
        it3 = new IntuiText ;

        plain = new TTextAttr ;
        underline = new TTextAttr ;

        it1->FrontPen = it2->FrontPen = it3->FrontPen =
            pens[(flags&NG_HIGHLABEL)?HIGHLIGHTTEXTPEN:TEXTPEN] ;
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
    gad = gl->gad  = (Gadget *)NewObject(BOOPSIeslide, NULL,
            GA_ID,              gl->ng->ng_GadgetID,
            GA_Top,             gl->ng->ng_TopEdge,
            GA_Left,            gl->ng->ng_LeftEdge,
            GA_Width,           gl->ng->ng_Width,
            GA_Height,          gl->ng->ng_Height,

            GA_Immediate,       TRUE,
            GA_Previous,        gl->gad,
            GA_RelVerify,       TRUE,

            GA_UserData,        EGA_Level,
            PGA_Freedom,        freedom,
            GA_IntuiText,       it1 ,

            EGA_Min,            min,
            EGA_Max,            max,
            EGA_Flags,          flags,
            EGA_Level,          level,
            EGA_TextAttr,       gl->ng->ng_TextAttr,
            EGA_XPens,          gl->win->ws->xpens,
            EGA_GPen,           gl->gpen,

            TAG_DONE);

}

eslide::~eslide()
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
    FreeESlide() ;
}

void eslide::set(long level, long min, long max, short disable)
{
    if (((level == -1) || (cursel == level)) && ((min == -1) || (smin == min))
        && ((max == -1) ||(max == smax)) && (disable == disabled)) {
        // nothing to do
        return ;
    }

    if (min != -1) smin = min ;
    if (max != -1) smax = max ;
    if (cursel != -1) cursel = level ;
    disabled = disable ;

    SetGadgetAttrs(gad, w, NULL,
        (level != -1)?EGA_Level:TAG_IGNORE,  level,
        (min != -1)?EGA_Min:TAG_IGNORE,      min,
        (max != -1)?EGA_Max:TAG_IGNORE,      max,
        GA_Disabled,                        disable,
        TAG_END) ;
}

void eslide::action(unsigned long classe, unsigned short code)
{
    if (classe != IDCMP_GADGETDOWN) {
        cursel = code ;
        gadget::action(classe, code) ;
    }
}

void eslide::keystroke(BOOL shifted)
{
    if (shifted) {
        cursel-- ;
        if (cursel < smin) cursel= smax ;
    }
    else {
        cursel++ ;
        if (cursel > smax)
            cursel = smin ;
    }
    SetGadgetAttrs(gad, w, NULL,
        EGA_Level,  cursel,
        TAG_END) ;
    gadget::action(NULL, cursel) ;
}



// ========================================================================
// =============================== ESLIDE =================================
// ========================================================================

struct SlideINST {
    long        Min ;       // limits and level values
    long        Max ;
    long        Level ;
    long        Total ;

    long        Top ;
    long        DTop ;
    long        PTop ;      // Previous Top

    long        GLeft ;     // Gadget coordinates
    long        GTop ;
    long        GWidth ;
    long        GHeight ;

    long        KLeft ;     // Knob coordinates
    long        KTop ;
    long        KWidth ;
    long        KHeight ;
    long        KRight ;
    long        KBottom ;

    long        Orient ;     // indicates the orientation (HORIZ or VERT)
    long        Flags ;     // the NewGadget Flags

    BOOL        KnobHit ;   // User is moving the Knob
    BOOL        RedrawAll ; // Complete Refresh
    BOOL        Disabled ;  // for redraw check
    BOOL        Direction ;

    TextAttr    *TAttr ;  // How to display the level value
    TextFont    *Font ;
    IntuiText   *IText ;

    UWORD       *XPens ;    // rendering information
    UWORD       GPen ;
} ;

static ULONG STDARGS dispatchESlide(Class *cl, Object *o, Msg msg);

static void    NotifySlide(Class *, Object *, ULONG, long, gpInput *) ;

static ULONG   RenderESlide(Class *, Gadget *, gpRender *) ;

static void    SlideLims(SlideINST *inst, Gadget *g, GadgetInfo *gi) ;



static unsigned short ditherData[2] = {0x5555,0xAAAA};
static int ESlideCnt = 0 ;
int InitESlide(void)
{
    if (ESlideCnt) {
        ESlideCnt++ ;
    }
    else if (!(BOOPSIeslide = MakeClass(NULL, (UBYTE *)"gadgetclass", NULL,
        sizeof(SlideINST), 0))) {
        ESlideCnt = 0 ;
    }
    else {
        BOOPSIeslide->cl_Dispatcher.h_Entry = (HOOKFUNC)HookEntry ;
        BOOPSIeslide->cl_Dispatcher.h_SubEntry = (HOOKFUNC)dispatchESlide;
        BOOPSIeslide->cl_Dispatcher.h_Data = NULL ;
        ESlideCnt = 1 ;
    }
    return ESlideCnt ;
}

void FreeESlide(void)
{
    ESlideCnt-- ;
    if (!ESlideCnt)
        FreeClass(BOOPSIeslide) ;
}

ULONG SAVEDS STDARGS dispatchESlide(Class *cl, Object *o, Msg msg)
{
SlideINST *inst ;
ULONG retval = FALSE ;
Object *object ;

    GETA4 ;
    if (msg->MethodID != OM_NEW)
        inst = (SlideINST *)INST_DATA(cl, o) ;
    switch (msg->MethodID) {
    case OM_NEW:
        if (object = (Object *)DoSuperMethodA(cl, o, msg)) {
            inst = (SlideINST *)INST_DATA(cl, object) ;
            inst->KnobHit = FALSE ;
            inst->Min = (long)GetTagData(EGA_Min, 0, ((opSet *)msg)->ops_AttrList) ;
            inst->Max = (long)GetTagData(EGA_Max, 15, ((opSet *)msg)->ops_AttrList) ;
            inst->Level = (long)GetTagData(EGA_Level, 0, ((opSet *)msg)->ops_AttrList) ;
            inst->Total = inst->Max - inst->Min + 1 ;
            inst->TAttr = (TextAttr *)GetTagData(EGA_TextAttr, 0, ((opSet *)msg)->ops_AttrList) ;
            inst->XPens = (UWORD *)GetTagData(EGA_XPens, NULL, ((opSet *)msg)->ops_AttrList) ;
            inst->GPen = (UWORD)GetTagData(EGA_GPen, NULL, ((opSet *)msg)->ops_AttrList) ;
            inst->Orient = (long)GetTagData(PGA_Freedom, LORIENT_HORIZ, ((opSet *)msg)->ops_AttrList) ;
            inst->IText = (IntuiText *)GetTagData(GA_IntuiText,
                NULL,
                ((opSet *)msg)->ops_AttrList) ;
            inst->Flags = (LONG)GetTagData(EGA_Flags, PLACETEXT_LEFT,
                    ((opSet *)msg)->ops_AttrList) ;

            if (inst->TAttr)
                inst->Font = OpenFont(inst->TAttr) ;
            else
                inst->Font = NULL ;
            inst->Top = inst->Level - inst->Min ;
            inst->RedrawAll = TRUE ;
            retval = (ULONG)object ;
        }
        break ;
    case OM_DISPOSE:
        CloseFont(inst->Font) ;
        retval = DoSuperMethodA(cl, o, msg) ;
        break ;
    case GM_GOACTIVE:
        {
        gpInput *gpi = (gpInput *)msg ;
            if (gpi->gpi_IEvent) {
                ((Gadget *)o)->Flags |= GFLG_SELECTED ;
                inst->RedrawAll = FALSE ;

                // is the mouse inside the knob ?
                if (((gpi->gpi_Mouse.X + inst->GLeft) >= inst->KLeft) &&
                    ((gpi->gpi_Mouse.X + inst->GLeft) <= inst->KRight) &&
                    ((gpi->gpi_Mouse.Y + inst->GTop) >= inst->KTop) &&
                    ((gpi->gpi_Mouse.Y + inst->GTop) <= inst->KBottom)) {
                        inst->KnobHit = TRUE ;
                        inst->Direction = TRUE ;
                        if (inst->Orient & LORIENT_HORIZ)
                            inst->DTop = (gpi->gpi_Mouse.X * inst->Total) / inst->GWidth - inst->Top ;
                        else
                            inst->DTop = ( inst->Total - (gpi->gpi_Mouse.Y * inst->Total) / inst->GHeight) - inst->Top ;
                }
                else {
                    inst->Direction = FALSE ;
                    if (inst->Orient & LORIENT_HORIZ) {
                        if ((gpi->gpi_Mouse.X + inst->GLeft)<= inst->KLeft)
                            inst->Top-- ;
                        else
                            inst->Top++ ;
                    }
                    else {
                        if ((gpi->gpi_Mouse.Y + inst->GTop)<= inst->KTop)
                            inst->Top++ ;
                        else
                            inst->Top-- ;
                    }
                }
                retval = GMR_MEACTIVE ;
                RenderESlide(cl, (Gadget *)o, (gpRender *)msg) ;
                NotifySlide(cl, o, OPUF_INTERIM, inst->Level, gpi) ;
                *(gpi->gpi_Termination) = inst->Level ;
        }
        else
            retval = GMR_NOREUSE ;
        }
        break ;
    case GM_RENDER:
        inst->RedrawAll = BOOL(((gpRender *)msg)->gpr_Redraw == GREDRAW_REDRAW) ;
        retval = RenderESlide(cl, (Gadget *)o, (gpRender *)msg) ;
        break ;
    case GM_HANDLEINPUT:
        {
            gpInput *gpi = (gpInput *)msg ;
            InputEvent *ie = gpi->gpi_IEvent ;

            inst->PTop = inst->Top ;
            retval = GMR_MEACTIVE ;

            if (ie->ie_Class == IECLASS_RAWMOUSE) {
                switch (ie->ie_Code) {
                    case SELECTUP:
                        if (((gpi->gpi_Mouse).X < inst->GLeft) ||
                           ((gpi->gpi_Mouse).X > inst->GLeft + inst->GWidth) ||
                           ((gpi->gpi_Mouse).Y < inst->GTop) ||
                           ((gpi->gpi_Mouse).Y > inst->GTop + inst->GHeight) ) {
                                *(gpi->gpi_Termination) = inst->Level ;
                                retval = GMR_NOREUSE | GMR_VERIFY ;
                        }
                        else
                            retval = GMR_NOREUSE ;
                        break ;
                    case MENUDOWN:
                        retval = GMR_REUSE ;
                        NotifySlide(cl, o, 0, inst->Level, (gpInput *)msg) ;
                        break ;
                    default:
                        retval = GMR_MEACTIVE ;
                }
            }
            else if (ie->ie_Class == IECLASS_TIMER && inst->Direction) {
                if (inst->Orient & LORIENT_HORIZ)
                    inst->Top = ((gpi->gpi_Mouse.X) * inst->Total) /
                        inst->GWidth - inst->DTop ;
                else
                    inst->Top = (inst->Total-((gpi->gpi_Mouse.Y) * inst->Total) /
                        inst->GHeight) - inst->DTop ;

                if (inst->PTop != inst->Top) {
                    inst->RedrawAll = FALSE ;
                    RenderESlide(cl, (Gadget *)o, (gpRender *)msg) ;
                    NotifySlide(cl, o, OPUF_INTERIM, inst->Level, gpi) ;
                }
            }
        }
        break ;
    case GM_GOINACTIVE:
        ((Gadget *)o)-> Flags &= ~GFLG_SELECTED ;
        inst->KnobHit = FALSE ;
        inst->RedrawAll = FALSE ;
        RenderESlide(cl, (Gadget *)o, (gpRender *)msg) ;
        break ;
    case OM_GET:
        switch (((opGet *)msg)->opg_AttrID) {
        case EGA_Min:
            retval = inst->Min ;
            break ;
        case EGA_Max:
            retval = inst->Max ;
            break ;
        case EGA_Level:
            retval = inst->Level ;
            break ;
        default:
            retval = DoSuperMethodA(cl, o, msg) ;
        }
        break ;
    case OM_SET:
        retval = DoSuperMethodA(cl, o, msg) ;
        if ( FindTagItem(EGA_Min, ((opSet *)msg)->ops_AttrList) ||
            FindTagItem(EGA_Max, ((opSet *)msg)->ops_AttrList) ||
            FindTagItem(EGA_Level, ((opSet *)msg)->ops_AttrList) ) {
            RastPort *rp ;
            Gadget *g  = (Gadget *)o ;
            LONG    redraw ;

            inst->Min = (long)GetTagData(EGA_Min, inst->Min, ((opSet *)msg)->ops_AttrList) ;
            inst->Max = (long)GetTagData(EGA_Max, inst->Max, ((opSet *)msg)->ops_AttrList) ;
            inst->Level = (long)GetTagData(EGA_Level, inst->Level, ((opSet *)msg)->ops_AttrList) ;
            inst->Total = inst->Max - inst->Min + 1 ;
            inst->Top = inst->Level - inst->Min ;
            redraw = (inst->Disabled ^ (g->Flags & GFLG_DISABLED)) ? GREDRAW_REDRAW : GREDRAW_UPDATE ;
            inst->Disabled = g->Flags & GFLG_DISABLED ;

            if (rp = ObtainGIRPort( ((opSet *)msg)->ops_GInfo) ) {
                DoMethod(o, GM_RENDER, ((opSet *)msg)->ops_GInfo, rp, redraw) ;
                ReleaseGIRPort(rp) ;
            }
        }
        break ;
    default :
        retval = DoSuperMethodA(cl, o, msg) ;
        break ;
    }
    return retval ;
}


void SAVEDS NotifySlide(Class *cl, Object *o, ULONG flags, long level, gpInput *gpi)
{
static TagItem tt[3] ;

    GETA4 ;
    tt[0].ti_Tag = EGA_Level ;
    tt[0].ti_Data = level  ;

    tt[1].ti_Tag = GA_ID ;
    tt[1].ti_Data = ((Gadget *)o)->GadgetID ;

    tt[2].ti_Tag = TAG_DONE ;

    DoSuperMethod(cl, o, OM_NOTIFY, tt, gpi->gpi_GInfo, flags) ;
}

ULONG SAVEDS RenderESlide(Class *cl, Gadget *g, gpRender *msg)
{
RastPort    *rp ;
ULONG       retval = TRUE ;
UWORD       *pens = msg->gpr_GInfo->gi_DrInfo->dri_Pens ;
SlideINST   *inst = (SlideINST *)INST_DATA(cl, (Object *)g) ;
char        kbuf[8] ;
WORD        ls ;
LONG        l, t, len ; // left, top, len utilisés pour l'affichage
IntuiText   *itext ;    // affichage du label

    GETA4 ;
    if (msg->MethodID == GM_RENDER)
        rp = msg->gpr_RPort ;
    else
        rp = ObtainGIRPort(msg->gpr_GInfo) ;
    if (rp) {
        SetAPen(rp, pens[SHADOWPEN]) ;
        SetDrMd(rp, JAM1) ;
        SetFont(rp, inst->Font) ;

        WaitTOF() ;
        if (g->Flags & GFLG_DISABLED) {
            SlideLims(inst, g, msg->gpr_GInfo) ;
            SetAPen(rp, pens[BACKGROUNDPEN]) ;
            RectFill(rp,
                inst->GLeft,
                inst->GTop,
                inst->GLeft+inst->GWidth,
                inst->GTop+inst->GHeight) ;
            goto out ;
        }
        else if (inst->RedrawAll) {
            SlideLims(inst, g, msg->gpr_GInfo) ;
            SetAPen(rp, inst->XPens[GFILL_PEN]) ;
            RectFill(rp,
                inst->GLeft,
                inst->GTop,
                inst->GLeft+inst->GWidth-1,
                inst->GTop+inst->GHeight-1) ;

            SetAPen(rp, pens[SHINEPEN]) ;

            Move(rp, inst->GLeft+1, inst->GTop+inst->GHeight-1) ;
            Draw(rp, inst->GLeft+1, inst->GTop+1) ;
            Draw(rp, inst->GLeft+inst->GWidth-1, inst->GTop+1) ;
            Draw(rp, inst->GLeft+inst->GWidth-1, inst->GTop+inst->GHeight-1) ;
            Draw(rp, inst->GLeft+1, inst->GTop+inst->GHeight-1) ;

            SetAPen(rp, pens[SHADOWPEN]) ;

            Move(rp, inst->GLeft, inst->GTop) ;
            Draw(rp, inst->GLeft+inst->GWidth-2, inst->GTop) ;
            Draw(rp, inst->GLeft+inst->GWidth-2, inst->GTop+inst->GHeight-2) ;
            Draw(rp, inst->GLeft, inst->GTop+inst->GHeight-2) ;
            Draw(rp, inst->GLeft, inst->GTop) ;
            if (inst->IText) {  // Le gadget possède un label
                itext = inst->IText ;

                // recherche du dernier itext pour la longueur

                while (itext->NextText) itext = itext->NextText ;

                // Le calcul par défaut est pour PLACETEXT_IN

                len = IntuiTextLength(itext) + itext->LeftEdge ;
                t = inst->GTop + 1 +
                    (inst->GHeight - itext->ITextFont->ta_YSize -2) / 2 ;
                l = inst->GLeft + 1 + (inst->GWidth - len - 2) / 2 ;


                if (inst->Flags & PLACETEXT_RIGHT) {
                    l = inst->GLeft + inst->GWidth + 4 ;
                }
                else if (inst->Flags & PLACETEXT_ABOVE) {
                    t = inst->GTop - itext->ITextFont->ta_YSize - 4 ;
                }
                else if (inst->Flags & PLACETEXT_BELOW) {
                    t = inst->GTop + inst->GHeight + 4 ;
                }
                else if (!(inst->Flags & PLACETEXT_IN)) {  // PLACETEXT_LEFT
                    l = inst->GLeft - len - 4 ;
                }
                PrintIText(rp, inst->IText, l, t) ;
            }
        }
        else {
            SetAPen(rp, inst->XPens[GFILL_PEN]) ;
            RectFill(rp,
                inst->KLeft,
                inst->KTop,
                inst->KRight,
                inst->KBottom) ;
            SlideLims(inst, g, msg->gpr_GInfo) ;
        }
        SetAPen(rp, pens[FILLPEN]) ;

        SetAfPt(rp, ditherData, 1) ;
        RectFill(rp, inst->KLeft,
                     inst->KTop,
                     inst->KRight,
                     inst->KBottom ) ;

        SetAfPt(rp, NULL, 0 ) ; // Fin du tramage

        SetAPen(rp, pens[(g->Flags & GFLG_SELECTED)?SHADOWPEN:SHINEPEN]) ;

        Move(rp, inst->KLeft+1, inst->KBottom) ;
        Draw(rp, inst->KLeft+1, inst->KTop+1) ;
        Draw(rp, inst->KRight, inst->KTop+1) ;
        Draw(rp, inst->KRight, inst->KBottom) ;
        Draw(rp, inst->KLeft+1, inst->KBottom) ;

        SetAPen(rp, pens[(g->Flags & GFLG_SELECTED)?SHINEPEN:SHADOWPEN]) ;

        Move(rp, inst->KLeft, inst->KTop) ;
        Draw(rp, inst->KRight-1, inst->KTop) ;
        Draw(rp, inst->KRight-1, inst->KBottom-1) ;
        Draw(rp, inst->KLeft, inst->KBottom-1) ;
        Draw(rp, inst->KLeft, inst->KTop) ;

        SetAPen(rp, (g->Flags & GFLG_SELECTED) ? pens[HIGHLIGHTTEXTPEN] :
                    inst->GPen) ;


        sprintf(kbuf, "%ld", inst->Level) ;
        ls = strlen(kbuf) ;
        Move(   rp,
                inst->KLeft+(inst->KWidth - TextLength(rp, kbuf, ls))/2,
                inst->KTop+(inst->KHeight-rp->TxHeight)/2+rp->TxBaseline ) ;

        Text(rp, kbuf, ls) ;

out:
        if (msg->MethodID != GM_RENDER)
            ReleaseGIRPort(rp) ;

    }
    else
        retval = FALSE ;
    return retval ;
}


void SAVEDS SlideLims(SlideINST *inst, Gadget *g, GadgetInfo *gi)
{

    GETA4 ;
    // we must not go outside the limits

    if (inst->Top < 0)
        inst->Top = 0 ;
    else if (inst->Top >= inst->Total)
        inst->Top = inst->Total - 1 ;

    inst->Level = inst->Top + inst->Min ;

    inst->GLeft = g->LeftEdge ;
    inst->GTop = g->TopEdge ;
    inst->GWidth = g->Width  ;
    inst->GHeight = g->Height ;

    if (inst->Orient & LORIENT_HORIZ) {
        inst->KTop = inst->GTop + 2 ;
        inst->KHeight = inst->GHeight - 4 ;

        inst->KWidth = 40 ;
        if (inst->Total > 1) {
            inst->KLeft = g->LeftEdge + 2 +
            ((inst->GWidth-inst->KWidth-4) * inst->Top) / (inst->Total-1) ;
        }
        else
            inst->KLeft = g->LeftEdge+2 ;

    }
    else {
        inst->KLeft = inst->GLeft + 2 ;
        inst->KHeight = inst->TAttr->ta_YSize+4 ;

        if (inst->Total > 1) {
            inst->KTop = g->TopEdge + 2 + ((inst->GHeight-inst->KHeight-4) *
                (inst->Total-inst->Top)) / (inst->Total-1) ;
        }
        else
            inst->KTop = g->TopEdge + 2 ;

        inst->KWidth = inst->GWidth-4 ;

    }
    inst->KRight = inst->KLeft + inst->KWidth - 1 ;
    inst->KBottom = inst->KTop + inst->KHeight - 1 ;

}


