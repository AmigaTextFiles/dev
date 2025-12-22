// -----------------------------------------------------------------------------
// myimagegclass.c
// BOOPSI subclass of gadgetclass that can send its ID whenever it renders.
// Refreshes, centers, & scales its GA_Image attribute as well.
// 05 Jan 1994
// $Id: myimagegclass.c,v 1.39 94/01/11 02:59:42 rick Exp Locker: rick $
// -----------------------------------------------------------------------------
// No new methods
//
// Changed attributes
// GA_Image       [ISG] Changing this refreshes the gadget imagery.  Also gettable.
// GA_ID          [IS]  Nonzero will report a refresh using value.
//
// New attributes
// GA_ScaleFlags     [ISG] Various image scaling options.
// GA_ScaleRelWidth  [ISG] Width for relative scaling.
// GA_ScaleRelHeight [ISG] Height for relative scaling.
// GA_MUIRemember    [ISG] Remember packet for MUI destroy/remake actions on same object.
// -----------------------------------------------------------------------------

#include <exec/types.h>
#include <exec/memory.h>
#include <intuition/intuition.h>
#include <intuition/cghooks.h>
#include <intuition/classes.h>
#include <intuition/classusr.h>
#include <intuition/gadgetclass.h>
#include <graphics/scale.h>
#include <proto/exec.h>
#include <proto/intuition.h>
#include <proto/gadtools.h>
#include <proto/graphics.h>
#include <proto/utility.h>
#include "myimagegclass.h"

#define G(o)   ((struct Gadget *)o)
#define I(o)   ((struct Image *)o)
#define MIN(a, b)    ((a)<=(b)?(a):(b))

typedef struct
{
   SHORT relWidth, relHeight;
} MyData;

typedef struct
{
   struct Image *image;    // normally stored in GadgetRender
   ULONG flags;            // stored in UserData
   UWORD id;               // stored in GadgetID
   SHORT relWidth, relHeight;
} RememberData;

static void __interrupt NotifyGadID(Class *cl, Object *o, struct gpRender *gpr)
{
   struct TagItem tt[2];

   tt[0].ti_Tag = GA_ID;
   tt[0].ti_Data = G(o)->GadgetID;

   tt[1].ti_Tag = TAG_DONE;

   DoSuperMethod(cl, o, OM_NOTIFY, tt, gpr->gpr_GInfo, 0);
}

static void __interrupt Render(Class *cl, Object *o, struct gpRender *gpr, MyData *myd)
{
   struct Gadget *g;
   struct Image *img;

   g = G(o);  img = I(g->GadgetRender);

   if (g->GadgetID)
      NotifyGadID(cl, o, gpr);  // this is what the gadget solely exists for

   if (gpr->gpr_RPort)
   {
      EraseRect(gpr->gpr_RPort, g->LeftEdge,g->TopEdge,g->LeftEdge+g->Width-1,g->TopEdge+g->Height-1);
      if (img)
         if ((ULONG)g->UserData & (~GAFL_AspectRatio))   // Lone aspect ratio flag draws normally
         {  // scale image according to flags
            struct BitMap sBM, dBM;
            ULONG rassizeS, rassizeD;
            USHORT sWidth,sHeight, dWidth,dHeight, sx,sy;

            InitBitMap(&sBM, img->Depth, img->Width,img->Height);
            rassizeS = RASSIZE(img->Width,img->Height);

            dWidth = ((ULONG)g->UserData & GAFL_ScaleX) ? g->Width:img->Width;
            dHeight = ((ULONG)g->UserData & GAFL_ScaleY) ? g->Height:img->Height;

            if (myd->relWidth && ((ULONG)g->UserData & GAFL_RelX))
               dWidth = img->Width*dWidth/myd->relWidth;
            if (myd->relHeight && ((ULONG)g->UserData & GAFL_RelY))
               dHeight = img->Height*dHeight/myd->relHeight;

            if (((ULONG)g->UserData & GAFL_AspectRatio) && img->Width && img->Height)
            {  // fit shape into its native pixel aspect ratio
               BOOL smallAspect;
               USHORT adjW, adjH;

               smallAspect = ((((ULONG)g->UserData & GAFL_ScaleXY) == GAFL_ScaleXY)||(((ULONG)g->UserData & GAFL_RelXY) == GAFL_RelXY));

               adjW = ((ULONG)g->UserData & (GAFL_ScaleY|GAFL_RelY)) ? ScalerDiv(img->Width,dHeight,img->Height):0;
               adjH = ((ULONG)g->UserData & (GAFL_ScaleX|GAFL_RelX)) ? ScalerDiv(img->Height,dWidth,img->Width):0;

               // choose aspect that fits if x&y are scaled, otherwise choose largest aspect
               if (smallAspect?(adjW*dHeight < adjH*dWidth):(adjW*dHeight > adjH*dWidth))
                  dWidth = adjW;
               else
                  dHeight = adjH;
            }

            if (dHeight > g->Height)
            {  // Clip height here 'cause BitMapScale() works fine w/height
               sHeight = ScalerDiv(img->Height,g->Height,dHeight);
               dHeight = g->Height;
               sy = img->Height/2-sHeight/2;
            }
            else
            {
               sy = 0;  sHeight = img->Height;
            }
            if (dWidth > g->Width)
            {  // BitMapScale() doesn't work at all w/SrcX's not on word boundaries!
               // So I clip width to word boundaries so it doesn't have to scale more
               // than will fit in the display space, conserving memory.
               sWidth = ScalerDiv(img->Width,g->Width,dWidth);
               sx = (img->Width/2-sWidth/2)/16*16;
               sWidth = (img->Width/2-sx)*2;
               dWidth = ScalerDiv(dWidth, sWidth, img->Width);
            }
            else
            {
               sx = 0;  sWidth = img->Width;
            }

            rassizeD = RASSIZE(dWidth,dHeight);
            InitBitMap(&dBM, img->Depth, dWidth,dHeight);

            sBM.Planes[0] = (PLANEPTR)img->ImageData;
            if (dBM.Planes[0] = (PLANEPTR)AllocVec(rassizeD*img->Depth,MEMF_CHIP|MEMF_CLEAR))
            {
               struct BitScaleArgs bsa;
               register short i;

               for (i = 0; i < img->Depth; i++)
               {
                  sBM.Planes[i] = sBM.Planes[0] + rassizeS*i;
                  dBM.Planes[i] = dBM.Planes[0] + rassizeD*i;
               }

               bsa.bsa_SrcBitMap = &sBM;  bsa.bsa_DestBitMap = &dBM;
               bsa.bsa_SrcX = sx;  bsa.bsa_SrcY = sy;
               bsa.bsa_DestX = bsa.bsa_DestY = bsa.bsa_Flags = 0;
               bsa.bsa_XSrcFactor = bsa.bsa_SrcWidth = sWidth;
               bsa.bsa_YSrcFactor = bsa.bsa_SrcHeight = sHeight;
               bsa.bsa_XDestFactor = dWidth;
               bsa.bsa_YDestFactor = dHeight;

               BitMapScale(&bsa);   // scale it!

               // Clip width here 'cause BitMapScale() only works on word SrcX's!
               if (dWidth > g->Width)
                  BltBitMapRastPort(&dBM, dWidth/2-g->Width/2,0, gpr->gpr_RPort,
                           g->LeftEdge,g->TopEdge+g->Height/2-dHeight/2,
                           g->Width,dHeight, 0xc0);
               else
                  BltBitMapRastPort(&dBM, 0,0, gpr->gpr_RPort,
                           g->LeftEdge+g->Width/2-dWidth/2,g->TopEdge+g->Height/2-dHeight/2,
                           dWidth,dHeight, 0xc0);

               FreeVec(dBM.Planes[0]);
            }
         }
         else if ((img->Width <= g->Width) && (img->Height <= g->Height))
            DrawImage(gpr->gpr_RPort, img,
               g->LeftEdge+g->Width/2-img->Width/2,
               g->TopEdge+g->Height/2-img->Height/2);
         else
         {  // normal image w/clipping
            struct BitMap bm;
            PLANEPTR plane = (PLANEPTR)img->ImageData;
            ULONG rassize = RASSIZE(img->Width, img->Height);
            UWORD dWidth, dHeight;
            register short i;

            // wrap a bitmap around the image data
            InitBitMap(&bm, img->Depth, img->Width,img->Height);
            for (i = 0; i < img->Depth; i++, plane += rassize)
               bm.Planes[i] = plane;

            dWidth = MIN(img->Width,g->Width);  dHeight = MIN(img->Height,g->Height);

            BltBitMapRastPort(&bm, img->Width/2-dWidth/2,img->Height/2-dHeight/2, gpr->gpr_RPort,
                           g->LeftEdge+g->Width/2-dWidth/2,g->TopEdge+g->Height/2-dHeight/2,
                           dWidth,dHeight, 0xc0);
         }
   }
}

static void __interrupt SetAttributes(Class *cl, Object *o, struct opSet *ops, MyData *myd)
{
   struct RastPort *rp;
   struct TagItem *tState = ops->ops_AttrList,
                  *tag = tState;
   BOOL refresh = FALSE;

   //PrintTags(ops->ops_AttrList);

   while (tag = NextTagItem(&tState))
      switch (tag->ti_Tag)
      {
         case GA_Image:
            refresh = TRUE;  break;
         case GA_ScaleFlags:
            G(o)->UserData = (APTR)tag->ti_Data;  refresh = (BOOL)(G(o)->GadgetRender);  break;
         case GA_ScaleRelWidth:  // refresh assignments only refresh if flag is set
            myd->relWidth = tag->ti_Data;
            if (myd->relWidth < 0)  myd->relWidth = 0;
            refresh = ((ULONG)G(o)->UserData & GAFL_RelX);  break;
         case GA_ScaleRelHeight:
            myd->relHeight = tag->ti_Data;
            if (myd->relHeight < 0)  myd->relHeight = 0;
            refresh = ((ULONG)G(o)->UserData & GAFL_RelY);  break;
         case GA_MUIRemember:
         {
            RememberData *rd = (RememberData *)tag->ti_Data;

            if (rd)
            {
               G(o)->GadgetRender = rd->image;
               G(o)->UserData = (void *)rd->flags;
               G(o)->GadgetID = rd->id;
               myd->relWidth = rd->relWidth;
               myd->relHeight = rd->relHeight;

               FreeMem(rd, sizeof(RememberData));
            }
            // don't refresh on a remember 'cause will get render method anyway!
         }
      }

   if (ops->ops_GInfo && refresh && (rp = ObtainGIRPort(ops->ops_GInfo)))
   {
      DoMethod(o, GM_RENDER, ops->ops_GInfo, rp, GREDRAW_REDRAW);
      ReleaseGIRPort(rp);
   }
}

static ULONG __interrupt __saveds dispatchmyimagegclass(Class *cl, Object *o, Msg msg)
{
   MyData *myd;
   ULONG retVal = 0l;

   myd = INST_DATA(cl,o);

   switch (msg->MethodID)
   {
      case OM_NEW:
         if (o = (Object *)DoSuperMethodA(cl, o, (Msg *)msg))
         {
            SetAttributes(cl, o, (struct opSet *)msg, INST_DATA(cl,o));
            retVal = (ULONG)o;
         }
         break;
      case OM_SET:
         DoSuperMethodA(cl, o, (Msg *)msg);
         SetAttributes(cl, o, (struct opSet *)msg, myd);
         break;
      case GM_HITTEST:
         retVal = FALSE;   // gadget can't be selected
         break;
      case GM_RENDER:
         Render(cl, o, (struct gpRender *)msg, myd);
         break;
      case OM_GET:
      {
         struct opGet *opg = (struct opGet *)msg;

         switch (opg->opg_AttrID)
         {  // Primarily for MUIA_Boopsi_Remember tags
            case GA_Image:
               *(opg->opg_Storage) = (ULONG)(G(o)->GadgetRender);
               break;
            case GA_ScaleFlags:
               *(opg->opg_Storage) = (ULONG)(G(o)->UserData);
               break;
            case GA_ScaleRelWidth:
               *(opg->opg_Storage) = (ULONG)myd->relWidth;
               break;
            case GA_ScaleRelHeight:
               *(opg->opg_Storage) = (ULONG)myd->relHeight;
               break;
            case GA_MUIRemember:
            {  // special remember packet that MUI collects & saves when destroying & remaking same object
               RememberData *rd;

               if (rd = AllocMem(sizeof(RememberData),MEMF_ANY))
               {
                  rd->image = G(o)->GadgetRender;
                  rd->flags = (ULONG)G(o)->UserData;
                  rd->id = G(o)->GadgetID;
                  rd->relWidth = myd->relWidth;
                  rd->relHeight = myd->relHeight;
               }
               *(opg->opg_Storage) = (ULONG)rd;
            }
         }
      }
      default:
         retVal = (ULONG)DoSuperMethodA(cl, o, (Msg *)msg);
   }
   return(retVal);
}

void Free_myimagegclass(Class *cl)
{
   if (cl)
      FreeClass(cl);
}

Class *Init_myimagegclass(void)
{
   Class *cl;
   extern ULONG HookEntry();	/* asm-to-C interface glue	*/

   if (cl = MakeClass(NULL, GADGETCLASS, NULL,sizeof(MyData),0))
   {
      cl->cl_Dispatcher.h_Entry = HookEntry;
      cl->cl_Dispatcher.h_SubEntry = dispatchmyimagegclass;
   }

   return(cl);
}
