// $Id: eroll.cc 1.3 1997/09/17 08:15:27 dlorre Exp $
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
#include <mydebug.h>
#include <string.h>
#include <math.h>
#if defined( __SASC__ )
#ifdef _IEEE
#include <mieeedoub.h>
#endif
#ifdef _M68881
#include <m68881.h>
#endif
#endif

#include "gadgets/eroll.h"
#include "gadgets/eclass.h"
#include "gadgetlist.h"
#include "window.h"
#include "screen.h"

#include <proto/dos.h>
#include <proto/graphics.h>
#include <proto/intuition.h>
#include <proto/utility.h>
#include <clib/alib_protos.h>
#include <compiler.h>

static Class *BOOPSIeroll ;
static int InitERoll(void) ;
static void FreeERoll(void) ;

#if !defined( PI )
#define PI  3.14159265358979323846
#endif

const double cPID4  = PI / 4.0  ;
const double cPID2  = PI / 2.0  ;
const double c3PID2  = 3.0 * PI / 2.0 ;
const double c5PID4  = 5.0 * PI / 4.0 ;
const double c7PID4  = 7.0 * PI / 4.0 ;
const double c2PI   = 2.0 * PI ;

extern "C" STDARGS ULONG HookEntry() ;

// ========================================================================
// ============================  EROLL CLASS =============================
// ========================================================================


eroll::eroll(gadgetlist *gl,
               void (window::*func)(gadget *, unsigned long, unsigned short),
               long min,
               long max,
               long level,
               BOOL full) : gadget(gl, func),
                            cursel(level), rmin(min), rmax(max), rfull(full)
{

    InitERoll() ;

    gad = gl->gad  = (Gadget *)NewObject(BOOPSIeroll, NULL,

            GA_ID,              gl->ng->ng_GadgetID,
            GA_Top,             gl->ng->ng_TopEdge,
            GA_Left,            gl->ng->ng_LeftEdge,
            GA_Width,           gl->ng->ng_Width,
            GA_Height,          gl->ng->ng_Height,

            GA_Previous,        gl->gad,

            GA_Immediate,       TRUE,
            GA_FollowMouse,     TRUE,
            GA_RelVerify,       TRUE,

            GA_UserData,        EGA_Level,

            ICA_TARGET,         ICTARGET_IDCMP,

            EGA_Min,             min,
            EGA_Max,             max,
            EGA_Level,           level,
            EGA_Full,            full,
            EGA_XPens,           gl->win->ws->xpens,

            TAG_DONE);
}

eroll::~eroll()
{
    DisposeObject(gad) ;
    FreeERoll() ;
}

void eroll::set(long level, long min, long max, short disable)
{
    SetGadgetAttrs(gad, w, NULL,
        (level != -1)?EGA_Level:TAG_IGNORE,  level,
        (min != -1)?EGA_Min:TAG_IGNORE,      min,
        (max != -1)?EGA_Max:TAG_IGNORE,      max,
        GA_Disabled,                        disable,
        TAG_END) ;
}

void eroll::action(unsigned long classe, unsigned short code)
{
    cursel = code ;
    gadget::action(classe, code) ;
}

void eroll::keystroke(BOOL shifted)
{
    if (shifted) {
        cursel-- ;
        if (cursel < rmin)
            cursel = rfull?rmax:rmin ;
    }
    else {
        cursel++ ;
        if (cursel > rmax)
            cursel = rfull?rmin:rmax ;
    }
    set(cursel) ;
    gadget::action(NULL, cursel) ;
}


// ========================================================================
// =============================== EROLL =================================
// ========================================================================

struct RollINST {
    BOOL        Full ;                  // Full display : 360° angle
    BOOL        KnobHit ;
    BOOL        RedrawAll ;

    WORD        Direction ;
    long        GLeft ;                 // Coordonnées du gadget
    long        GTop ;
    long        GWidth ;
    long        GHeight ;               // Coordonnées du gadget
    long        XRadius, YRadius ;      // Rayons
    long        CLeft, CTop ;           // Coordonnées du centre
    long        CWidth, CHeight ;
    long        KLeft, KTop ;           // Coordonnées du curseur
    long        KRight, KBottom ;
    long        KCenterX, KCenterY ;
    double       KStart ;
    long        XStartPos, YStartPos ;
    long        Total, Top ;
    long        Min, Max, Level ;
    long        DTop, PTop ;
    long        XUnity, YUnity ;
    double      angPhase ;
    double      angWidth ;
    double      angMin ;
    double      Ratio ;
    UWORD       *XPens ;
} ;

static ULONG STDARGS dispatchERoll(Class *cl, Object *o, Msg msg);

static void     NotifyRoll(Class *, Object *, ULONG, long, gpInput *) ;

static ULONG    RenderERoll(Class *, Gadget *, gpRender *) ;

static void     RollSize(RollINST *inst, Gadget *g) ;
static void     RollLims(RollINST *inst) ;

static unsigned short ditherData[2] = {0x5555,0xAAAA};
static int ERollCnt = 0 ;
int InitERoll(void)
{
    if (ERollCnt) {
        ERollCnt++ ;
    }
    else if (!(BOOPSIeroll = MakeClass(NULL, (UBYTE *)"propgclass", NULL,
        sizeof(RollINST), 0))) {
        ERollCnt = 0 ;
    }
    else {
        BOOPSIeroll->cl_Dispatcher.h_Entry = (HOOKFUNC)HookEntry ;
        BOOPSIeroll->cl_Dispatcher.h_SubEntry = (HOOKFUNC)dispatchERoll;
        BOOPSIeroll->cl_Dispatcher.h_Data = NULL ;
        ERollCnt = 1 ;
    }
    return ERollCnt ;
}

void FreeERoll(void)
{
    ERollCnt-- ;
    if (!ERollCnt)
        FreeClass(BOOPSIeroll) ;
}

ULONG SAVEDS STDARGS dispatchERoll(Class *cl, Object *o, Msg msg)
{
RollINST *inst ;
ULONG retval = FALSE ;
Object *object ;

    GETA4 ;
    switch (msg->MethodID) {
    case OM_NEW:
        if (object = (Object *)DoSuperMethodA(cl, o, msg)) {
            inst = (RollINST *)INST_DATA(cl, object) ;
            inst->KnobHit = FALSE ;
            inst->Min = (long)GetTagData(EGA_Min, 1, ((opSet *)msg)->ops_AttrList) ;
            inst->Max = (long)GetTagData(EGA_Max, 16, ((opSet *)msg)->ops_AttrList) ;
            inst->Full = (long)GetTagData(EGA_Full, FALSE, ((opSet *)msg)->ops_AttrList) ;
            inst->Level = (long)GetTagData(EGA_Level, 1, ((opSet *)msg)->ops_AttrList) ;
            inst->XPens = (UWORD *)GetTagData(EGA_XPens, NULL, ((opSet *)msg)->ops_AttrList) ;
            inst->Total = inst->Max - inst->Min + 1 ;
            inst->Top = inst->Level - inst->Min ;
            inst->RedrawAll = TRUE ;
            RollSize(inst, (Gadget *)object) ;
            retval = (ULONG)object ;
        }
        break ;
    case OM_DISPOSE:
        retval = DoSuperMethodA(cl, o, msg) ;
        break ;
    case GM_HITTEST:
        retval = DoSuperMethodA(cl, o, msg) ;
        break ;
    case GM_GOACTIVE:
        {
        gpInput *gpi = (gpInput *)msg ;
        double   alpha, xp, yp, diff ;

            inst = (RollINST *)INST_DATA(cl, o) ;
            if (gpi->gpi_IEvent) {
                ((Gadget *)o)->Flags |= GFLG_SELECTED ;
                inst->RedrawAll = FALSE ;

                xp = double(gpi->gpi_Mouse.X - inst->XRadius) ;
                yp = double(inst->YRadius - gpi->gpi_Mouse.Y) * inst->Ratio ;

                if (!xp) {
                    alpha = cPID2 ;
                    if (yp < 0)
                        alpha = -alpha ;  // -PI/2 out of lims
                }
                else
                    alpha = atan2(yp, xp) ;

                alpha += cPID4 ;
                if (alpha < 0) alpha += c2PI ;
                diff = fabs(alpha -c2PI) ;
                if (diff < 0.00001) alpha = 0 ;

                if (alpha <= inst->angMin)
                    inst->Top =  long((inst->Total * (inst->angWidth - alpha))
                        / inst->angWidth) ;

                retval = GMR_MEACTIVE ;
                RenderERoll(cl, (Gadget *)o, (gpRender *)msg) ;
                *(gpi->gpi_Termination) = inst->Level ;
                NotifyRoll(cl, o, OPUF_INTERIM, inst->Level, gpi) ;
        }
        else
            retval = GMR_NOREUSE ;
        }
        break ;
    case GM_RENDER:
        retval = RenderERoll(cl, (Gadget *)o, (gpRender *)msg) ;
        break ;
    case GM_HANDLEINPUT:
        {
            gpInput *gpi = (gpInput *)msg ;
            InputEvent *ie = gpi->gpi_IEvent ;

            inst = (RollINST *)INST_DATA(cl, o) ;
            inst->PTop = inst->Top ;
            inst->RedrawAll = FALSE ;
            retval = GMR_MEACTIVE ;

            if (ie->ie_Class == IECLASS_RAWMOUSE) {
                switch (ie->ie_Code) {
                    case SELECTUP:
                        *(gpi->gpi_Termination) = inst->Level ;
                        retval = GMR_NOREUSE | GMR_VERIFY ;
                        NotifyRoll(cl, o, 0, inst->Level, (gpInput *)msg) ;
                        break ;
                    case MENUDOWN:
                        retval = GMR_REUSE ;
                        NotifyRoll(cl, o, 0, inst->Level, (gpInput *)msg) ;
                        break ;
                    case IECODE_NOBUTTON:
                        *(gpi->gpi_Termination) = inst->Level ;
                        ie->ie_Code = inst->Level ;
                        retval = GMR_MEACTIVE  ;
                        NotifyRoll(cl, o, OPUF_INTERIM, inst->Level, gpi) ;
                        break ;
                }
            }
            else if (ie->ie_Class == IECLASS_TIMER) {
            double   alpha, xp, yp, diff ;
                xp = double(gpi->gpi_Mouse.X - inst->XRadius) ;
                yp = double(inst->YRadius - gpi->gpi_Mouse.Y) * inst->Ratio ;

                if (!xp) {
                    alpha = cPID2 ;
                    if (yp < 0)
                        alpha = - alpha ;
                }
                else
                    alpha = atan2(yp, xp) ;


                alpha += cPID4 ;
                if (alpha < 0) alpha += c2PI ;
                diff = fabs(alpha -c2PI) ;
                if (diff < 0.00001) alpha = 0 ;

                if (alpha <= inst->angMin)
                    inst->Top =  long((inst->Total * (inst->angWidth - alpha))
                        / inst->angWidth) ;

                if (inst->PTop != inst->Top) {
                    RenderERoll(cl, (Gadget *)o, (gpRender *)msg) ;
                    NotifyRoll(cl, o, OPUF_INTERIM, inst->Level, gpi) ;
                }
            }
        }
        break ;
    case GM_GOINACTIVE:
        ((Gadget *)o)-> Flags &= ~GFLG_SELECTED ;
        inst = (RollINST *)INST_DATA(cl, o) ;
        inst->KnobHit = FALSE ;
        inst->RedrawAll = TRUE ;
        RenderERoll(cl, (Gadget *)o, (gpRender *)msg) ;
        break ;
    case OM_GET:
        {
        ULONG *store = ((opGet *)msg)->opg_Storage ;

            inst = (RollINST *)INST_DATA(cl, o) ;
            switch (((opGet *)msg)->opg_AttrID) {
            case EGA_Min:
                *store = retval = inst->Min ;
                break ;
            case EGA_Max:
                *store = retval = inst->Max ;
                break ;
            case EGA_Level:
                *store = retval = inst->Level ;
                break ;
            default:
                retval = DoSuperMethodA(cl, o, msg) ;
            }
        }
        break ;
    case OM_SET:
        retval = DoSuperMethodA(cl, o, msg) ;
        if ( FindTagItem(EGA_Min, ((opSet *)msg)->ops_AttrList) ||
            FindTagItem(EGA_Max, ((opSet *)msg)->ops_AttrList) ||
            FindTagItem(EGA_Level, ((opSet *)msg)->ops_AttrList) ) {
            RastPort *rp ;
            Gadget *g  = (Gadget *)o ;

            inst = (RollINST *)INST_DATA(cl, o) ;
            inst->Min = (long)GetTagData(EGA_Min, inst->Min, ((opSet *)msg)->ops_AttrList) ;
            inst->Max = (long)GetTagData(EGA_Max, inst->Max, ((opSet *)msg)->ops_AttrList) ;
            inst->Level = (long)GetTagData(EGA_Level, inst->Level, ((opSet *)msg)->ops_AttrList) ;
            inst->Total = inst->Max - inst->Min + 1 ;
            inst->Top = inst->Level - inst->Min ;


            if (rp = ObtainGIRPort( ((opSet *)msg)->ops_GInfo) ) {
                inst->RedrawAll = FALSE ;
                DoMethod(o, GM_RENDER, ((opSet *)msg)->ops_GInfo, rp, GREDRAW_REDRAW) ;
                ReleaseGIRPort(rp) ;
                inst->RedrawAll = TRUE ;
            }
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


void SAVEDS NotifyRoll(Class *cl, Object *o, ULONG flags, long level, gpInput *gpi)
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

ULONG SAVEDS RenderERoll(Class *cl, Gadget *g, gpRender *msg)
{
RastPort    *rp ;
ULONG       retval = TRUE ;
UWORD       *pens = msg->gpr_GInfo->gi_DrInfo->dri_Pens ;
RollINST    *inst = (RollINST *)INST_DATA(cl, (Object *)g) ;
WORD        shine, shadow ;

    GETA4 ;
    if (msg->MethodID == GM_RENDER)
        rp = msg->gpr_RPort ;
    else
        rp = ObtainGIRPort(msg->gpr_GInfo) ;

    if (rp) {
        shine = (g->Flags & GFLG_SELECTED)?pens[SHINEPEN]:pens[SHADOWPEN] ;
        shadow = (g->Flags & GFLG_SELECTED)?pens[SHADOWPEN]:pens[SHINEPEN] ;
        SetDrMd(rp, JAM1) ;

        if (g->Flags & GFLG_DISABLED) {
            EraseRect(rp,
                inst->GLeft,
                inst->GTop,
                inst->GLeft+inst->GWidth,
                inst->GTop+inst->GHeight) ;
        }
        else {
            if (!inst->RedrawAll) {
                EraseRect(rp, inst->KLeft-2, inst->KTop-2, inst->KRight+1, inst->KBottom+1) ;
            }
            RollLims(inst) ;
            if (inst->RedrawAll) {
                EraseRect(rp,
                    inst->GLeft,
                    inst->GTop,
                    inst->GLeft+inst->GWidth,
                    inst->GTop+inst->GHeight) ;
                SetAPen(rp, pens[SHINEPEN]) ;
                DrawEllipse(rp, inst->CLeft, inst->CTop, inst->XRadius, inst->YRadius) ;
                SetAPen(rp, pens[SHADOWPEN]) ;
                DrawEllipse(rp, inst->CLeft-1, inst->CTop-1, inst->XRadius, inst->YRadius) ;
            }
            SetAPen(rp, shine) ;
            DrawEllipse(rp, inst->KCenterX, inst->KCenterY, inst->XUnity, inst->YUnity) ;
            SetAPen(rp, shadow) ;
            DrawEllipse(rp, inst->KCenterX-1, inst->KCenterY-1, inst->XUnity, inst->YUnity) ;
        }
        if (msg->MethodID != GM_RENDER)
            ReleaseGIRPort(rp) ;
    }
    else
        retval = FALSE ;
    return retval ;
}

void SAVEDS RollSize(RollINST *inst, Gadget *g)
{
int     i ;

    GETA4 ;
    inst->GLeft = g->LeftEdge ;
    inst->GTop = g->TopEdge ;

    inst->CWidth = inst->GWidth = g->Width  ;
    inst->CHeight = inst->GHeight = g->Height ;
    inst->CWidth -= 2 ;
    inst->CHeight -= 2 ;

    inst->XRadius = inst->CWidth/2 ;
    inst->YRadius = inst->CHeight/2 ;
    inst->Ratio = g->Width / g->Height ;

    inst->CLeft = inst->GLeft + inst->XRadius ;
    inst->CTop = inst->GTop + inst->YRadius ;

    if (inst->CWidth > inst->CHeight) {
        inst->YUnity = 1 ;
        inst->XUnity = inst->CWidth / inst->CHeight ;
    }
    else {
        inst->XUnity = 1 ;
        inst->YUnity = inst->CHeight / inst->CWidth ;
    }
    inst->angPhase = c5PID4 ;
    inst->angMin = c3PID2 ;
    if (inst->Full) {
        inst->angWidth = c2PI ;
    }
    else {
        inst->angWidth = c3PID2 ;
    }

    RollLims(inst) ;
}

void SAVEDS RollLims(RollINST *inst)
{
    GETA4 ;
    if (inst->Top < 0)
        inst->Top = 0 ;
    else if (inst->Top >= inst->Total)
        inst->Top = inst->Total - 1 ;
    inst->Level = inst->Top + inst->Min ;

    if (inst->Total)
        inst->KStart = inst->angPhase -
            (inst->Top * inst->angWidth) / inst->Total ;
    else
        inst->KStart = inst->angPhase ;

    inst->KCenterX = inst->CLeft +
        long( cos(inst->KStart) * (inst->XRadius - (inst->XUnity * 3.0)) + .5) ;

    inst->KCenterY = inst->CTop -
        long( sin(inst->KStart) * (inst->YRadius - (inst->YUnity * 3.0)) + .5) ;

    inst->KLeft = inst->KCenterX - inst->XUnity + 1 ;
    inst->KRight = inst->KCenterX + inst->XUnity - 1 ;
    inst->KTop = inst->KCenterY - inst->YUnity + 1 ;
    inst->KBottom = inst->KCenterY + inst->YUnity - 1 ;
}



