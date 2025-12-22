// $Id: imgbut.cc 1.4 1998/04/08 15:10:37 dlorre Exp $
#include <intuition/classes.h>
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

#include "screen.h"
#include "window.h"
#include "gadgets/imgbut.h"
#include "gadgets/eclass.h"
#include "gadgetlist.h"
#include "renderim.h"

#include <proto/intuition.h>
#include <proto/utility.h>
#include <clib/alib_protos.h>
#include <mydebug.h>
#include <compiler.h>

// imgbut est désormais héritée de FButton

IMPORT int InitFButton(void) ;
IMPORT void FreeFButton(void) ;
IMPORT Class *BOOPSIfbutton ;

static int InitRenderIm(void) ;
static void FreeRenderIm(void) ;
Class *renderim ;

extern "C" ULONG STDARGS HookEntry() ;

// ========================================================================
// ============================  IMGBUT CLASS =============================
// ========================================================================


imgbut::imgbut(gadgetlist *gl,
               void (window::*func)(gadget *, unsigned long, unsigned short),
               Image *image,
               Image *box) : gadget(gl, func)
{
    InitFButton() ;

    gad = gl->gad = (Gadget *)NewObject(BOOPSIfbutton, NULL,
            GA_ID,          gl->ng->ng_GadgetID,
            GA_Left,        gl->ng->ng_LeftEdge,
            GA_Top,         gl->ng->ng_TopEdge,
            GA_Width,       gl->ng->ng_Width,
            GA_Height,      gl->ng->ng_Height,
            GA_RelVerify,   TRUE,
            GA_Previous,    gl->gad,
            GA_Image,       box,
            GA_LabelImage,  image,
            EGA_XPens,      gl->win->ws->xpens,
            TAG_END) ;

}

imgbut::~imgbut()
{
    DisposeObject(gad) ;
    FreeFButton() ;
}

void imgbut::select(BOOL sel)
{
    SetGadgetAttrs(gad, w, NULL,
        GA_Selected,    sel,
        TAG_END) ;
    RefreshGList(gad, w, NULL, 1);
}


void imgbut::set(Image* image)
{
    SetGadgetAttrs(gad, w, NULL,
        GA_LabelImage,    image,
        TAG_END) ;
}

// ========================================================================
// ========================== RENDER IMAGE ================================
// ========================================================================

struct RenderImageData {
    Image *ri_TStyle[9] ;
    Image ri_DefaultImage ;
};

static ULONG STDARGS DispatchRenderImage(Class *cl, Object *o, Msg msg);

static int ImCnt = 0 ;

extern "C" {
int _STI_4000_InitRenderIm(void)
{
int retval = 0 ;

    if (!(renderim = MakeClass(NULL, (UBYTE *)"imageclass", NULL,
        sizeof(RenderImageData), 0))) {
        retval = 1 ;
    }
    else {
        renderim->cl_Dispatcher.h_Entry = (HOOKFUNC)HookEntry ;
        renderim->cl_Dispatcher.h_SubEntry = (HOOKFUNC)DispatchRenderImage;
        renderim->cl_Dispatcher.h_Data = NULL ;
    }
#if defined( __GNUG__ )
    if (retval) exit(20) ;
#else
    return retval ;
#endif
}

void _STD_4000_FreeRenderIm(void)
{
    FreeClass(renderim) ;
}
}

ULONG SAVEDS STDARGS DispatchRenderImage(Class *cl, Object *o, Msg msg)
{
RenderImageData *ird;
impDraw *imd;
APTR    retval = NULL;
unsigned long i ;

    GETA4 ;
    switch (msg->MethodID) {
    case OM_NEW:
        if (retval = (APTR)DoSuperMethodA(cl, o, msg)) {
            ird = (RenderImageData *)INST_DATA(cl, retval);

            ird->ri_DefaultImage.LeftEdge = (short)GetTagData(IA_Left, 0,
                ((opSet *)msg)->ops_AttrList);
            ird->ri_DefaultImage.TopEdge = (short)GetTagData(IA_Top, 0,
                ((opSet *)msg)->ops_AttrList);
            ird->ri_DefaultImage.Width = (short)GetTagData(IA_Width, 0,
                ((opSet *)msg)->ops_AttrList);
            ird->ri_DefaultImage.Height = (short)GetTagData(IA_Height, 0,
                ((opSet *)msg)->ops_AttrList);

            ird->ri_DefaultImage.Depth = 1 ;
            ird->ri_DefaultImage.ImageData = NULL ;
            ird->ri_DefaultImage.PlanePick = 7 ;
            ird->ri_DefaultImage.PlaneOnOff = 0 ;
            ird->ri_DefaultImage.NextImage = NULL ;

            for (i=IRD_Normal; i<= IRD_SelectedDisabled; i++)
                ird->ri_TStyle[i-IRD_Normal] = (Image *)GetTagData(i,
                    (ULONG)&ird->ri_DefaultImage,
                    ((opSet *)msg)->ops_AttrList);
        }
        break;
    case IM_DRAW:
        ird = (RenderImageData *)INST_DATA(cl, o);
        imd = (impDraw *)msg;
        if (imd->imp_State >= IDS_NORMAL &&
            imd->imp_State <= IDS_SELECTEDDISABLED) {
            DrawImage(imd->imp_RPort,
                    ird->ri_TStyle[imd->imp_State],
                    imd->imp_Offset.X, imd->imp_Offset.Y);
        }
        else
            retval = (APTR)DoSuperMethodA(cl, o, msg);
        break;
    case IM_HITTEST:
        retval = (APTR)DoSuperMethodA(cl, o, msg);
        break;
    case IM_ERASE:
        retval = (APTR)DoSuperMethodA(cl, o, msg);
        break;
    default:
         retval = (APTR)DoSuperMethodA(cl, o, msg);
    }
    return (ULONG)retval;
}


#if defined( __GNUG__ )
ADD2INIT(_STI_4000_InitRenderIm, -45);
ADD2EXIT(_STD_4000_FreeRenderIm, -45);
#endif
