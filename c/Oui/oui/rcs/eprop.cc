head	1.2;
access;
symbols;
locks
	dlorre:1.2; strict;
comment	@// @;


1.2
date	97.07.14.04.19.32;	author dlorre;	state Exp;
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


1.2
log
@*** empty log message ***
@
text
@// $Id$

#include <exec/lists.h>
#include <graphics/gfxmacros.h>
#include <intuition/classes.h>
#include <intuition/classusr.h>
#include <intuition/gadgetclass.h>
#include <intuition/imageclass.h>
#include <intuition/cghooks.h>
#include <intuition/icclass.h>
#include <utility/tagitem.h>
#include <utility/hooks.h>
#include <libraries/gadtools.h>
#include <mydebug.h>

#include "gadgets/eprop.h"
#include "gadgets/eclass.h"

#include "gadgetlist.h"
#include "screen.h"
#include "window.h"

#include <proto/graphics.h>
#include <proto/intuition.h>
#include <proto/utility.h>
#include <clib/alib_protos.h>
#include <compiler.h>

extern "C" STDARGS ULONG HookEntry() ;

static Class *BOOPSIeprop ;
static int InitEProp(void) ;
static void FreeEProp(void) ;

// ========================================================================
// =============================  EPROP CLASS =============================
// ========================================================================


eprop::eprop(gadgetlist *gl,
             void (window::*func)(gadget *, unsigned long, unsigned short),
             long top,
             long view,
             long total,
             long freedom,
             char style) : gadget(gl, func)
{
short gleft, gtop, gwidth, gheight ;

    InitEProp() ;

    gleft = gl->ng->ng_LeftEdge ;
    gtop = gl->ng->ng_TopEdge ;
    gwidth = gl->ng->ng_Width ;
    gheight = gl->ng->ng_Height ;

    if (style & BOTTOMPROP)
        gtop = short(-gtop) ;
    if (style & RIGHTPROP)
        gleft = short(-gleft) ;
    if (style & WIDTHPROP)
        gwidth = short(-gwidth) ;
    if (style & HEIGHTPROP)
        gheight = short(-gheight) ;

    gad = gl->gad = (Gadget *)NewObject(BOOPSIeprop, NULL,
            GA_Top,             gtop,
            GA_Left,            gleft,
            GA_Width,           gwidth,
            GA_Height,          gheight,
            GA_ID,              id,

            (style & BOTTOMPROP)?GA_BottomBorder:TAG_IGNORE,TRUE,
            (style & RIGHTPROP)?GA_RightBorder:TAG_IGNORE,  TRUE,
            (style & BOTTOMPROP)?GA_RelBottom:TAG_IGNORE,   TRUE,
            (style & RIGHTPROP)?GA_RelRight:TAG_IGNORE,     TRUE,
            (style & WIDTHPROP)?GA_RelWidth:TAG_IGNORE,     TRUE,
            (style & HEIGHTPROP)?GA_RelHeight:TAG_IGNORE,   TRUE,

            GA_Immediate,       TRUE,
            GA_FollowMouse,     TRUE,
            GA_RelVerify,       TRUE,

            GA_Previous,        gl->gad,
            GA_UserData,        PGA_Top,

            ICA_TARGET,         ICTARGET_IDCMP,

            PGA_Top,            top,
            PGA_Total,          total,
            PGA_Visible,        view,
            PGA_Freedom,        freedom,
            EGA_window,         gl->win,
            TAG_END) ;
}

eprop::~eprop()
{
    DisposeObject(gad) ;
    FreeEProp() ;
}


void eprop::set(long top, long view, long total)
{
    SetGadgetAttrs(gad, w, NULL,
        (top != -1)?PGA_Top:TAG_IGNORE,         top,
        (total != -1)?PGA_Total:TAG_IGNORE,     total,
        (view != -1)?PGA_Visible:TAG_IGNORE,    view,
        TAG_END) ;
}

void eprop::action(unsigned long classe, unsigned short code)
{
    if (classe != IDCMP_GADGETDOWN) {
        gadget::action(classe, code) ;
    }
}

// ========================================================================
// =============================== EPROP ==================================
// ========================================================================

struct PropINST {

    long    Top ;
    long    Total ;
    long    Visible ;

    long    KLeft ;         // knob coords
    long    KTop ;
    long    KRight ;
    long    KBottom ;

    long    PropLeft ;      // prop coords
    long    PropTop ;
    long    PropWidth ;
    long    PropHeight ;

    long    IncLeft ;       // inc button coords
    long    IncTop ;

    long    DecLeft ;       // dec button coords
    long    DecTop ;

    long    ButWidth ;
    long    ButHeight ;

    long    DTop ;
    long    PTop ;          // previous top

    long    Flags ;

    BOOL    KnobHit ;
    BOOL    DecHit ;
    BOOL    IncHit ;

    BOOL    Drawable ;      // ok to redraw

    BOOL    RedrawAll ;
    BOOL    RedrawInc ;
    BOOL    RedrawDec ;
    BOOL    RedrawBody ;
    WORD    Direction ;     // Knob move=1, Inc=2, Dec=3

    window  *win ;

    struct  Image *arrowInc ;
    struct  Image *arrowDec ;
} ;

static ULONG STDARGS dispatchEProp(Class *cl, Object *o, Msg msg);

static ULONG   RenderEProp(Class *, Gadget *, gpRender *) ;

static void NotifyTop(Class *, Object *, ULONG, long, gpInput *) ;

static void    SetLims(PropINST *inst, Gadget *g, GadgetInfo *gi) ;

static void    CheckTop(PropINST *inst) ;


static unsigned short ditherData[2] = {0x5555,0xAAAA};
static int EPropCnt = 0 ;

int InitEProp(void)
{
    if (EPropCnt) {
        EPropCnt++ ;
    }
    else if (!(BOOPSIeprop = MakeClass(NULL, (UBYTE *)"gadgetclass", NULL,
        sizeof(PropINST), 0))) {
        EPropCnt = 0 ;
    }
    else {
        BOOPSIeprop->cl_Dispatcher.h_Entry = (HOOKFUNC)HookEntry ;
        BOOPSIeprop->cl_Dispatcher.h_SubEntry = (HOOKFUNC)dispatchEProp;
        BOOPSIeprop->cl_Dispatcher.h_Data = NULL ;
        EPropCnt = 1 ;
    }
    return EPropCnt ;
}

void FreeEProp(void)
{
    EPropCnt-- ;
    if (!EPropCnt) {
        FreeClass(BOOPSIeprop) ;
    }
}


ULONG SAVEDS STDARGS dispatchEProp(Class *cl,
                           Object *o,
                           Msg msg)
{
PropINST *inst ;
ULONG retval = FALSE ;
Object *object ;

    GETA4 ;
    switch (msg->MethodID) {
    case OM_NEW:
        if (object = (Object *)DoSuperMethodA(cl, o, msg)) {
            Gadget *g = (Gadget *)object ;
            screen *s ;

            inst = (PropINST *)INST_DATA(cl, object) ;
            inst->KnobHit = inst->DecHit = inst->IncHit = FALSE ;
            inst->Top = (long)GetTagData(PGA_Top, 0, ((opSet *)msg)->ops_AttrList ) ;
            inst->Total = (long)GetTagData(PGA_Total, 0, ((opSet *)msg)->ops_AttrList) ;
            inst->Visible = (long)GetTagData(PGA_Visible, 0, ((opSet *)msg)->ops_AttrList) ;
            inst->Flags = (long)GetTagData(PGA_Freedom, LORIENT_VERT, ((opSet *)msg)->ops_AttrList) ;
            inst->win = (window *)GetTagData(EGA_window, NULL, ((opSet *)msg)->ops_AttrList) ;
            inst->RedrawAll = TRUE ;


            if (g->Flags & GFLG_RELRIGHT)
                g->LeftEdge = (short)GetTagData(GA_Left, g->LeftEdge, ((opSet *)msg)->ops_AttrList) ;
            if (g->Flags & GFLG_RELHEIGHT)
                g->Height = (short)GetTagData(GA_Height, g->Height, ((opSet *)msg)->ops_AttrList) ;
            if (g->Flags & GFLG_RELWIDTH)
                g->Width = (short)GetTagData(GA_Width, g->Width, ((opSet *)msg)->ops_AttrList) ;
            if (g->Flags & GFLG_RELBOTTOM)
                g->TopEdge = (short)GetTagData(GA_Top, g->TopEdge, ((opSet *)msg)->ops_AttrList) ;

            s = inst->win->ws ;

            inst->arrowInc = (Image *)NewObject(NULL, (UBYTE *)"sysiclass",
                IA_Left,        0,
                IA_Top,         0,
                SYSIA_DrawInfo, s->drawinfo,
                SYSIA_Which,    (inst->Flags & LORIENT_VERT)?DOWNIMAGE:RIGHTIMAGE,
                SYSIA_Size,     (s->scr->ViewPort.Modes & HIRES)?SYSISIZE_MEDRES:SYSISIZE_LOWRES,
                TAG_DONE) ;

            inst->arrowDec = (Image *)NewObject(NULL, (UBYTE *)"sysiclass",
                IA_Left,        0,
                IA_Top,         0,
                SYSIA_DrawInfo, s->drawinfo,
                SYSIA_Which,    (inst->Flags & LORIENT_VERT)?UPIMAGE:LEFTIMAGE,
                SYSIA_Size,     (s->scr->ViewPort.Modes & HIRES)?SYSISIZE_MEDRES:SYSISIZE_LOWRES,
                TAG_DONE) ;

            inst->ButWidth = inst->arrowInc->Width ;
            inst->ButHeight = inst->arrowInc->Height ;

            retval = (ULONG)object ;
        }

        break ;
    case OM_DISPOSE:
        inst = (PropINST *)INST_DATA(cl, o) ;
        DisposeObject(inst->arrowInc) ;
        DisposeObject(inst->arrowDec) ;
        retval = DoSuperMethodA(cl, o, msg) ;
        break ;
    case GM_HITTEST:
        retval = DoSuperMethodA(cl, o, msg) ;
        break ;
    case GM_GOACTIVE:
        {
        gpInput *gpi = (gpInput *)msg ;
        WORD mx = gpi->gpi_Mouse.X ;
        WORD my = gpi->gpi_Mouse.Y ;
            inst = (PropINST *)INST_DATA(cl, o) ;
            if (gpi->gpi_IEvent) {
                ((Gadget *)o)->Flags |= GFLG_SELECTED ;
                inst->RedrawAll = FALSE ;
                if (((mx + inst->PropLeft) >= inst->KLeft) &&
                    ((mx + inst->PropLeft) <= inst->KRight) &&
                    ((my + inst->PropTop) >= inst->KTop) &&
                    ((my + inst->PropTop) <= inst->KBottom)) {
                        inst->KnobHit = TRUE ;
                        inst->Direction = 1 ;
                        if (inst->Flags & LORIENT_VERT) {
                            inst->DTop = (my * inst->Total) / inst->PropHeight - inst->Top ;
                        }
                        else {
                            inst->DTop = (mx * inst->Total) / inst->PropWidth - inst->Top ;
                        }
                }
                else if ((inst->Flags & LORIENT_VERT) &&
                        ((my + inst->PropTop) >= inst->IncTop) &&
                        ((my + inst->PropTop) <= (inst->IncTop+inst->ButHeight))) {
                        inst->IncHit = TRUE ;
                        inst->RedrawInc = TRUE ;
                        inst->Direction = 2 ;
                }
                else if ((inst->Flags & LORIENT_VERT) &&
                        ((my + inst->PropTop) >= inst->DecTop) &&
                        ((my + inst->PropTop) <= (inst->DecTop+inst->ButHeight))) {
                        inst->DecHit = TRUE ;
                        inst->RedrawDec = TRUE ;
                        inst->Direction = 3 ;
                }
                else if ((inst->Flags & LORIENT_HORIZ) &&
                        ((mx + inst->PropLeft) >= inst->IncLeft) &&
                        ((mx + inst->PropLeft) <= (inst->IncLeft+inst->ButWidth))) {
                        inst->IncHit = TRUE ;
                        inst->RedrawInc = TRUE ;
                        inst->Direction = 2 ;
                }
                else if ((inst->Flags & LORIENT_HORIZ) &&
                        ((mx + inst->PropLeft) >= inst->DecLeft) &&
                        ((mx + inst->PropLeft) <= (inst->DecLeft+inst->ButWidth))) {
                        inst->DecHit = TRUE ;
                        inst->RedrawDec = TRUE ;
                        inst->Direction = 3 ;
                }
                else {
                    inst->Direction = 0 ;
                    if (inst->Flags & LORIENT_VERT)
                        if ((my + inst->PropTop)<= inst->KTop)
                            inst->Top -= inst->Visible ;
                        else
                            inst->Top += inst->Visible ;
                    else
                        if ((mx + inst->PropLeft)<= inst->KLeft)
                            inst->Top -= inst->Visible ;
                        else
                            inst->Top += inst->Visible ;

                    CheckTop(inst) ;

                }
                NotifyTop(cl, o, OPUF_INTERIM, inst->Top, gpi) ;
                retval = GMR_MEACTIVE ;
                *(gpi->gpi_Termination) = inst->Top ;
                RenderEProp(cl, (Gadget *)o, (gpRender *)msg) ;
            }
            else
                retval = GMR_NOREUSE ;
        }
        break ;

    case GM_RENDER:
        retval = RenderEProp(cl, (Gadget *)o, (gpRender *)msg) ;
        break ;
    case GM_HANDLEINPUT:
        {
            gpInput *gpi = (gpInput *)msg ;
            InputEvent *ie = gpi->gpi_IEvent ;
            WORD mx = gpi->gpi_Mouse.X ;
            WORD my = gpi->gpi_Mouse.Y ;

            inst = (PropINST *)INST_DATA(cl, o) ;
            inst->PTop = inst->Top ;
            retval = GMR_MEACTIVE  ;

            if (ie->ie_Class == IECLASS_RAWMOUSE) {
                switch (ie->ie_Code) {
                    case SELECTUP:
                        *(gpi->gpi_Termination) = inst->Top ;
                        retval = GMR_NOREUSE | GMR_VERIFY ;
                        break ;
                    case MENUDOWN:
                        retval = GMR_REUSE ;
                        NotifyTop(cl, o, 0, inst->Top, (gpInput *)msg) ;
                        break ;
                    default:
                        retval = GMR_MEACTIVE ;
                }
            }
            else if ((ie->ie_Class == IECLASS_TIMER ||
                ie->ie_Class == IECLASS_POINTERPOS)
                && inst->Direction) {
                switch (inst->Direction) {
                case 1:
                    if (inst->Flags & LORIENT_VERT) {
                        inst->Top = (my * inst->Total) / inst->PropHeight - inst->DTop ;
                    }
                    else {
                        inst->Top = (mx * inst->Total) / inst->PropWidth - inst->DTop ;
                    }
                    break ;
                case 2:
                    inst->Top++ ;
                    break ;
                case 3:
                    inst->Top-- ;
                    break ;
                }
                CheckTop(inst) ;
                if (inst->PTop != inst->Top) {
                    RenderEProp(cl, (Gadget *)o, (gpRender *)msg) ;
                    inst->RedrawInc = inst->RedrawDec = FALSE ;
                    NotifyTop(cl, o, OPUF_INTERIM, inst->Top, gpi) ;
                }
            }
        }
        break ;
    case GM_GOINACTIVE:
        ((Gadget *)o)-> Flags &= ~GFLG_SELECTED ;
        inst = (PropINST *)INST_DATA(cl, o) ;
        inst->KnobHit = inst->IncHit = inst->DecHit = FALSE ;
        inst->RedrawAll = TRUE ;
        inst->RedrawInc = inst->RedrawDec = FALSE ;
        inst->RedrawBody = FALSE ;
        RenderEProp(cl, (Gadget *)o, (gpRender *)msg) ;
        break ;
    case OM_GET:
        inst = (PropINST *)INST_DATA(cl, o) ;
        switch (((opGet *)msg)->opg_AttrID) {
        case PGA_Top:
            retval = inst->Top ;
            break ;
        case PGA_Total:
            retval = inst->Total ;
            break ;
        case PGA_Visible:
            retval = inst->Visible ;
            break ;
        default:
            retval = DoSuperMethodA(cl, o, msg) ;
        }
        break ;
    case OM_SET:
        if ( FindTagItem(PGA_Top, ((opSet *)msg)->ops_AttrList) ||
            FindTagItem(PGA_Total, ((opSet *)msg)->ops_AttrList) ||
            FindTagItem(PGA_Visible, ((opSet *)msg)->ops_AttrList) ) {
            RastPort *rp ;
            Gadget *g  = (Gadget *)o ;

            inst = (PropINST *)INST_DATA(cl, o) ;
            inst->Top = (long)GetTagData(PGA_Top, inst->Top, ((opSet *)msg)->ops_AttrList) ;
            inst->Total = (long)GetTagData(PGA_Total, inst->Total, ((opSet *)msg)->ops_AttrList) ;
            inst->Visible = (long)GetTagData(PGA_Visible, inst->Visible, ((opSet *)msg)->ops_AttrList) ;

            CheckTop(inst) ;

            SetLims(inst, g, ((opSet *)msg)->ops_GInfo) ;
            inst->RedrawAll = FALSE ;
            inst->RedrawBody = TRUE ;

            if (rp = ObtainGIRPort( ((opSet *)msg)->ops_GInfo) ) {

                DoMethod(o, GM_RENDER, ((opSet *)msg)->ops_GInfo, rp, GREDRAW_REDRAW) ;
                ReleaseGIRPort(rp) ;
            }
            inst->RedrawBody = FALSE ;
            inst->RedrawAll = TRUE ;
        }
        else
            retval = DoSuperMethodA(cl, o, msg) ;
        break ;
    default :
        retval = DoSuperMethodA(cl, o, msg) ;
        break ;
    }
    return retval ;
}

void SAVEDS CheckTop(PropINST *inst)
{
    GETA4 ;
    if (inst->Top < 0)
        inst->Top = 0 ;
    else if (inst->Visible <= inst->Total) {
        if ((inst->Top + inst->Visible) > (inst->Total+1)) {
            inst->Top = inst->Total - inst->Visible + 1 ;
        }
    }
    else if (inst->Visible > inst->Total)
        inst->Top = 0 ;
//    else if (inst->Top >= inst->Total)
//        inst->Top = inst->Total - 1 ;
}

void SAVEDS NotifyTop(Class *cl, Object *o, ULONG flags, long top, gpInput *gpi)
{
static TagItem tt[3] ;

    GETA4 ;
    tt[0].ti_Tag = PGA_Top ;
    tt[0].ti_Data = top  ;

    tt[1].ti_Tag = GA_ID ;
    tt[1].ti_Data = ((Gadget *)o)->GadgetID ;

    tt[2].ti_Tag = TAG_DONE ;

    DoSuperMethod(cl, o, OM_NOTIFY, tt, gpi->gpi_GInfo, flags) ;
}

ULONG SAVEDS RenderEProp(Class *cl, Gadget *g, gpRender *msg)
{
RastPort *rp ;
ULONG retval = TRUE ;
UWORD *pens = msg->gpr_GInfo->gi_DrInfo->dri_Pens ;
PropINST *inst = (PropINST *)INST_DATA(cl, (Object *)g) ;

    GETA4 ;
    // Obtention du rastport

    if (msg->MethodID == GM_RENDER)
        rp = msg->gpr_RPort ;
    else
        rp = ObtainGIRPort(msg->gpr_GInfo) ;

    if (rp) {
        UWORD shine, shadow ;
        long  flag ;

        SetAPen(rp, pens[SHADOWPEN]) ;
        SetBPen(rp, 0) ;
        SetDrMd(rp, JAM2) ;
        SetAfPt(rp, ditherData, 1) ;

        // Redessiner tout ou bien tout sauf partie +/- ?

        if (inst->RedrawAll || inst->RedrawBody) {
            SetLims(inst, g, msg->gpr_GInfo) ;  // Calcul des limites

            if (!inst->Drawable) {
                retval = FALSE ;
                goto out ;
            }
            RectFill(rp,            // Effacer tout le corps du Gadget
                inst->PropLeft,
                inst->PropTop,
                inst->PropLeft+inst->PropWidth-1,
                inst->PropTop+inst->PropHeight-1) ;
        }
        else {                      // Effacer le knob
            RectFill(rp,
                inst->KLeft,
                inst->KTop,
                inst->KRight,
                inst->KBottom) ;
            SetLims(inst, g, msg->gpr_GInfo) ;  // Calcul des limites
            if (!inst->Drawable) {
                retval = FALSE ;
                goto out ;
            }
        }
        SetAfPt(rp, NULL, 0 ) ; // Fin du tramage

        // Choix des pinceaux suivant activation du Knob
        if (inst->KnobHit) {
            shine = pens[SHADOWPEN] ;
            shadow = pens[SHINEPEN] ;
        }
        else {
            shine = pens[SHINEPEN] ;
            shadow = pens[SHADOWPEN] ;
        }

        SetAPen(rp, pens[HIGHLIGHTTEXTPEN]) ;    // Activer le tramage
        SetAfPt(rp, ditherData, 1) ;

        RectFill(rp, inst->KLeft,     // Dessiner le Knob
                     inst->KTop,
                     inst->KRight,
                     inst->KBottom) ;

        SetAfPt(rp, NULL, 0 ) ;         // Fin du tramage

        // Contours du knob

        SetAPen(rp, shadow) ;
        Move(rp, inst->KLeft+1, inst->KBottom) ;
        Draw(rp, inst->KRight, inst->KBottom) ;
        Draw(rp, inst->KRight, inst->KTop+1) ;

        SetAPen(rp, shine) ;
        Move(rp, inst->KLeft, inst->KBottom-1) ;
        Draw(rp, inst->KLeft, inst->KTop) ;
        Draw(rp, inst->KRight-1, inst->KTop) ;

        if (msg->gpr_GInfo->gi_Window->Flags & WFLG_WINDOWACTIVE) {
            flag = 0 ;
        }
        else {
            flag = IDS_INACTIVENORMAL ;
        }

        // Partie [-]

        if (inst->RedrawDec || inst->RedrawAll) {
            DrawImageState( rp, inst->arrowDec,
                inst->DecLeft, inst->DecTop,
                inst->DecHit?flag+IDS_SELECTED:flag+IDS_NORMAL, inst->win->ws->drawinfo);
        }

        // Partie [+]

        if (inst->RedrawInc || inst->RedrawAll) {
            DrawImageState( rp, inst->arrowInc,
                inst->IncLeft, inst->IncTop,
                inst->IncHit?flag+IDS_SELECTED:flag+IDS_NORMAL, inst->win->ws->drawinfo);

        }

out:
        if (msg->MethodID != GM_RENDER) // Restitution du RastPort
            ReleaseGIRPort(rp) ;
    }
    else
        retval = FALSE ;
    return retval ;
}


void SAVEDS SetLims(PropINST *inst, Gadget *g, GadgetInfo *gi)
{
long GLeft, GTop, GWidth, GHeight ;
long KWidth, KHeight ;

    GETA4 ;
    GLeft = g->LeftEdge ;
    GTop = g->TopEdge ;
    GWidth = g->Width  ;
    GHeight = g->Height ;

    if (g->Flags & GFLG_RELRIGHT) {
        GLeft = gi->gi_Window->Width ;
        GLeft += g->LeftEdge ;
    }

    if (g->Flags & GFLG_RELHEIGHT) {
        GHeight = gi->gi_Window->Height ;
        GHeight += g->Height ;
    }

    if (g->Flags & GFLG_RELBOTTOM) {
        GTop = gi->gi_Window->Height ;
        GTop += g->TopEdge ;
    }

    if (g->Flags & GFLG_RELWIDTH) {
        GWidth = gi->gi_Window->Width ;
        GWidth += g->Width ;
    }

    if (g->Activation & GACT_BOTTOMBORDER) {
        GTop-- ;
    }
    if (g->Activation & GACT_RIGHTBORDER) {
        GLeft-- ;
    }

    if (inst->Flags & LORIENT_VERT)
        inst->Drawable = short((GWidth > 4) && (GHeight > inst->ButHeight*2+8) &&
        (gi->gi_Window->Width > (GWidth+gi->gi_Window->BorderLeft))) ;
    else
        inst->Drawable = short((GWidth > inst->ButWidth*2+8) && (GHeight > 4) &&
        (gi->gi_Window->Height > (GHeight+gi->gi_Window->BorderTop))) ;

    inst->PropLeft = GLeft  ;
    inst->PropTop = GTop ;

    if (inst->Flags & LORIENT_VERT) {
        inst->PropLeft += 2 ;
        inst->PropWidth = GWidth  - 4 ;
        inst->PropHeight = GHeight - inst->ButHeight*2 ;
        inst->DecLeft = inst->IncLeft = GLeft ;
        inst->DecTop = inst->PropTop + inst->PropHeight ;
        inst->IncTop = inst->DecTop + inst->ButHeight ;
    }
    else {
        inst->PropTop += 2 ;
        inst->PropHeight = GHeight - 4 ;
        inst->PropWidth = GWidth - inst->ButWidth*2 ;
        inst->DecTop = inst->IncTop = GTop ;
        inst->DecLeft = inst->PropLeft + inst->PropWidth ;
        inst->IncLeft = inst->DecLeft + inst->ButWidth ;
    }

    inst->KLeft = inst->PropLeft ;
    inst->KTop = inst->PropTop ;
    KWidth = inst->PropWidth  ;
    KHeight = inst->PropHeight   ;

    if ((inst->Flags & LORIENT_HORIZ) && (inst->Total >= inst->Visible)) {
        inst->KLeft += (inst->PropWidth * inst->Top) / (inst->Total+1) ;
        KWidth *= inst->Visible ;
        KWidth /= (inst->Total+1) ;
        if (KWidth < 8) {
            KWidth = 8 ;
            if (inst->KLeft > (inst->DecLeft - 8))
                inst->KLeft = inst->DecLeft - 8 ;
        }
    }
    else if ((inst->Flags & LORIENT_VERT) && (inst->Total >= inst->Visible)) {
        inst->KTop += (inst->PropHeight * inst->Top) / (inst->Total+1) ;
        KHeight *= inst->Visible ;
        KHeight /= (inst->Total+1) ;
        if (KHeight < 8) {
            KHeight = 8 ;
            if (inst->KTop > (inst->DecTop - 8))
                inst->KTop = inst->DecTop - 8 ;
        }
    }

    inst->KRight = inst->KLeft + KWidth -1;
    inst->KBottom = inst->KTop + KHeight -1;
}
@


1.1
log
@Initial revision
@
text
@d1 2
d14 1
d23 5
a27 2
#include <cxxproto/graphics.h>
#include <cxxproto/intuition.h>
d29 1
a29 14
extern "C"
{
extern struct Library *UtilityBase ;
struct TagItem *FindTagItem( Tag tagVal, struct TagItem *tagList );
ULONG GetTagData( Tag tagValue, unsigned long defaultVal,
        struct TagItem *tagList );
#include <pragmas/utility_pragmas.h>

ULONG DoMethod( Object *obj, unsigned long MethodID, ... );
ULONG DoSuperMethodA( struct IClass *cl, Object *obj, Msg message );
ULONG DoSuperMethod( struct IClass *cl, Object *obj, unsigned long MethodID,
        ... );
void kprintf(STRPTR format, ...) ;
}
d172 1
a172 2
static ULONG __asm dispatchEProp(register __a0 Class *cl,
    register __a2 Object *o, register __a1 Msg msg);
d191 1
a191 1
    else if (!(BOOPSIeprop = MakeClass(NULL, "gadgetclass", NULL,
d196 3
a198 1
        BOOPSIeprop->cl_Dispatcher.h_Entry = (HOOKFUNC)dispatchEProp;
d213 3
a215 3
ULONG __saveds __asm dispatchEProp(register __a0 Class *cl,
                                   register __a2 Object *o,
                                   register __a1 Msg msg)
d220 2
d249 1
a249 1
            inst->arrowInc = (Image *)NewObject(NULL, "sysiclass",
d254 1
a254 1
                SYSIA_Size,     (s->screen->ViewPort.Modes & HIRES)?SYSISIZE_MEDRES:SYSISIZE_LOWRES,
d257 1
a257 1
            inst->arrowDec = (Image *)NewObject(NULL, "sysiclass",
d262 1
a262 1
                SYSIA_Size,     (s->screen->ViewPort.Modes & HIRES)?SYSISIZE_MEDRES:SYSISIZE_LOWRES,
d474 1
a474 1
void __saveds CheckTop(PropINST *inst)
d476 1
d490 1
a490 1
void __saveds NotifyTop(Class *cl, Object *o, ULONG flags, long top, gpInput *gpi)
d494 1
d506 1
a506 1
ULONG __saveds RenderEProp(Class *cl, Gadget *g, gpRender *msg)
d513 1
d625 1
a625 1
void __saveds SetLims(PropINST *inst, Gadget *g, GadgetInfo *gi)
d630 1
@
