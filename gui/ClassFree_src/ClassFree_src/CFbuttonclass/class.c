/* Sample class  for StormC*/

#include <clib/alib_protos.h>
#include <proto/graphics.h>
#include <proto/intuition.h>
#include <proto/utility.h>
#include <exec/libraries.h>
#include <intuition/classes.h>
#include <intuition/gadgetclass.h>
#include <intuition/imageclass.h>
#include <dos/dos.h>
#include <string.h>
#include "class.h"
#include "CFbutton.h"
#include "CFtexti.h"
#ifdef DEBUG
 #include "debug_protos.h"
 extern APTR console;
#endif

Class *initclass(struct classbase *base)
{
  Class *cl;

  if(cl = MakeClass(CFbuttonClassName,GADGETCLASS,NULL,
        sizeof(struct objectdata),NULL))
  {
    cl->cl_Dispatcher.h_Entry = hookEntry;
    cl->cl_Dispatcher.h_SubEntry = dispatcher;
    AddClass(cl);
  }
  base->cl = cl;

  return(cl);
}

BOOL removeclass(struct classbase *base)
{
  BOOL result;

  if(result = FreeClass(base->cl)) base->cl = NULL;

  return(result);
}

ULONG dispatcher(Class *cl,Object *o,Msg msg)
{
  switch(msg->MethodID)
  {
    case OM_NEW:
      return(newobject(cl,o,msg));
    case OM_DISPOSE:
      return(dispose(cl,o));
    case OM_SET:
      return(setattrs(cl,o,msg));
    case GM_HITTEST:
      return(GMR_GADGETHIT);
    case GM_GOACTIVE:
      return(goactive(cl,o,msg));
    case GM_HANDLEINPUT:
      return(handleinput(cl,o,msg));
    case GM_GOINACTIVE:
      return(goinactive(cl,o,msg));
    case GM_RENDER:
      return(render(cl,o,msg));
    default:
      return(DoSuperMethodA(cl,o,msg));
  }
}


ULONG newobject(Class *cl,Object *o,Msg msg)
{
  ULONG newobj;
  struct TagItem *intags = ((struct opSet *)msg)->ops_AttrList;
  ULONG hgl,bor;
  Tag filter[] = {GA_Highlight,GA_Border,TAG_DONE};

  /*  Filter out changed attributes */
  hgl = GetTagData(GA_Highlight,TRUE,intags);
  bor = GetTagData(GA_Border,TRUE,intags);
  FilterTagItems(intags,filter,TAGFILTER_NOT);

  /* Create and init object */
  if(newobj = DoSuperMethodA(cl,o,msg))
  {
    struct objectdata *dt = (struct objectdata *)INST_DATA(cl,newobj);
    struct Gadget *btn = (struct Gadget *)newobj;

    dt->redo = TRUE;
    dt->flags = NULL;
    dt->layout = GetTagData(CFBU_Layout,NULL,intags);
    if(bor) dt->flags |= F_BORDER;
    if(hgl) dt->flags |= F_HIGHLITE;

    dt->border = (struct Image *)NewObject(NULL,FRAMEICLASS,
    		IA_Left, btn->LeftEdge, IA_Top, btn->TopEdge,
    		IA_Width, btn->Width, IA_Height, btn->Height,
    		IA_FrameType, FRAME_BUTTON,
    		IA_EdgesOnly, !hgl,
    		TAG_DONE);
    dt->texti = (struct Image *)NewObject(NULL,CFtextiClassName,
    		IA_Left, btn->LeftEdge+2, IA_Top, 0,
    		IA_Width, btn->Width-4,
    		IA_Data, btn->GadgetText,
    		CFTI_PosFlags, dt->layout&(TIPOS_LEFT|TIPOS_RIGHT),
    		TAG_DONE);
    if(!(dt->border&&dt->texti))
    {
      DoMethod((Object *)btn,OM_DISPOSE);
      return(NULL);
    }
  }
  return(newobj);
}

ULONG dispose(Class *cl,Object *o)
{
  struct objectdata *dt = (struct objectdata *)INST_DATA(cl,o);

  DisposeObject(dt->border);
  DisposeObject(dt->texti);
  DoSuperMethod(cl,o,OM_DISPOSE);

  return(0);
}

ULONG setattrs(Class *cl,Object *o,Msg msg)
{
  struct opSet *set = (struct opSet *)msg;
  struct Gadget *btn = (struct Gadget *)o;
  struct objectdata *dt = (struct objectdata *)INST_DATA(cl,o);
  struct TagItem *intags = set->ops_AttrList;
  ULONG hgl,bor;
  Tag filter[] = {GA_Highlight,GA_Border,TAG_DONE};

  /*  Filter out changed attributes */
  hgl = GetTagData(GA_Highlight,dt->flags&F_HIGHLITE,intags);
  bor = GetTagData(GA_Border,dt->flags&F_BORDER,intags);
  FilterTagItems(intags,filter,TAGFILTER_NOT);

  /* Set attributes */
  DoSuperMethodA(cl,o,msg);
  dt->redo = TRUE;
  dt->layout = GetTagData(CFBU_Layout,dt->layout,intags);
  if(bor)
  {
    dt->flags |= F_BORDER;
    if(hgl) dt->flags |= F_HIGHLITE;
  }
  else dt->flags &= ~(F_BORDER|F_HIGHLITE);
  DisposeObject(dt->border);
  DisposeObject(dt->texti);
  dt->border = (struct Image *)NewObject(NULL,FRAMEICLASS,
  		IA_Left, btn->LeftEdge, IA_Top, btn->TopEdge,
  		IA_Width, btn->Width, IA_Height, btn->Height,
  		IA_FrameType, FRAME_BUTTON,
  		IA_EdgesOnly, !hgl,
  		TAG_DONE);
  dt->texti = (struct Image *)NewObject(NULL,CFtextiClassName,
  		IA_Left, btn->LeftEdge+2, IA_Top, 0,
  		IA_Width, btn->Width-4,
  		IA_Data, btn->GadgetText,
  		CFTI_PosFlags, dt->layout&(TIPOS_LEFT|TIPOS_RIGHT),
  		TAG_DONE);

  return(NULL);
}


ULONG goactive(Class *cl,Object *o,Msg msg)
{
  struct gpInput *input = (struct gpInput *)msg;
  struct Gadget *btn = (struct Gadget *)o;
  struct gpRender rend;

  if(btn->Activation&GACT_TOGGLESELECT)
  {
    if(btn->Flags&GFLG_SELECTED) btn->Flags &= ~GFLG_SELECTED;
    else btn->Flags |= GFLG_SELECTED;
  }
  else btn->Flags |= GFLG_SELECTED;
  rend.MethodID = GM_RENDER;
  rend.gpr_GInfo = input->gpi_GInfo;
  rend.gpr_RPort = ObtainGIRPort(input->gpi_GInfo);
  rend.gpr_Redraw = GREDRAW_REDRAW;
  render(cl,o,(Msg)&rend);
  ReleaseGIRPort(rend.gpr_RPort);
  if(btn->Activation&GACT_TOGGLESELECT) return(GMR_NOREUSE);
  return(GMR_MEACTIVE);
}

ULONG handleinput(Class *cl,Object *o,Msg msg)
{
  struct gpInput *input = (struct gpInput *)msg;
  struct objectdata *dt = (struct objectdata *)INST_DATA(cl,o);
  struct Gadget *btn = (struct Gadget *)o;
  struct gpRender rend;
  WORD mx = input->gpi_Mouse.X, my = input->gpi_Mouse.Y;
  UWORD code;

  code = input->gpi_IEvent->ie_Code;
  if(input->gpi_IEvent->ie_Class == IECLASS_RAWMOUSE)
  {
    if(code == MENUDOWN) return(GMR_NOREUSE); /* Gadget Aborted */
    if(mx<0||mx>btn->Width||my<0||my>btn->Height)
    {
      if(btn->Flags&GFLG_SELECTED)
      {
        btn->Flags &= ~GFLG_SELECTED;
        rend.MethodID = GM_RENDER;
        rend.gpr_GInfo = input->gpi_GInfo;
        rend.gpr_Redraw = GREDRAW_REDRAW;
        rend.gpr_RPort = ObtainGIRPort(input->gpi_GInfo);
        render(cl,o,(Msg)&rend);
        ReleaseGIRPort(rend.gpr_RPort);
      }
      if(code == SELECTUP) return(GMR_REUSE);
         /* Gadget aborted, reuse event to send IDCMP_MOUSEBUTTONS. */
    }
    else
    {
      if(!(btn->Flags&GFLG_SELECTED))
      {
        btn->Flags |= GFLG_SELECTED;
        rend.MethodID = GM_RENDER;
        rend.gpr_GInfo = input->gpi_GInfo;
        rend.gpr_Redraw = GREDRAW_REDRAW;
        rend.gpr_RPort = ObtainGIRPort(input->gpi_GInfo);
        render(cl,o,(Msg)&rend);
        ReleaseGIRPort(rend.gpr_RPort);
      }
      if(code == SELECTUP)
      {
        if(btn->Activation&GACT_RELVERIFY)
        {
          *(input->gpi_Termination) = NULL; /* Hmmm.. */
          return(GMR_NOREUSE|GMR_VERIFY);
        }
        else return(GMR_NOREUSE);
      }
    }
  } /*  if(input->gpi_IEvent->ie_Class == IECLASS_RAWMOUSE) */
  if(input->gpi_IEvent->ie_Class == IECLASS_TIMER)
  {
    if(btn->Flags&GFLG_SELECTED)
    {
      struct opUpdate upd;
      struct TagItem tag[2];

      upd.MethodID = OM_NOTIFY;
      tag[0].ti_Tag = GA_ID; tag[0].ti_Data = btn->GadgetID;
      tag[1].ti_Tag = TAG_DONE;
      upd.opu_AttrList = tag;
      upd.opu_GInfo = input->gpi_GInfo;
      upd.opu_Flags = OPUF_INTERIM;
      DoMethodA(o,(Msg)&upd);
    }
  } /* if(input->gpi_IEvent->ie_Class == IECLASS_TIMER) */


  return(GMR_MEACTIVE);
}

ULONG goinactive(Class *cl,Object *o,Msg msg)
{
  struct gpGoInactive *input = (struct gpGoInactive *)msg;
  struct Gadget *btn = (struct Gadget *)o;
  struct gpRender rend;
  struct opUpdate upd;
  struct TagItem tag[2];


  if(btn->Flags&GFLG_SELECTED&&!(btn->Activation&GACT_TOGGLESELECT))
  {
    btn->Flags &= ~GFLG_SELECTED;
    rend.MethodID = GM_RENDER;
    rend.gpr_GInfo = input->gpgi_GInfo;
    rend.gpr_RPort = ObtainGIRPort(input->gpgi_GInfo);
    rend.gpr_Redraw = GREDRAW_REDRAW;
    render(cl,o,(Msg)&rend);
    ReleaseGIRPort(rend.gpr_RPort);
    upd.MethodID = OM_NOTIFY;
    tag[0].ti_Tag = GA_ID; tag[0].ti_Data = btn->GadgetID;
    tag[1].ti_Tag = TAG_DONE;
    upd.opu_AttrList = tag;
    upd.opu_GInfo = input->gpgi_GInfo;
    upd.opu_Flags = 0;
    DoMethodA(o,(Msg)&upd);
  }
  return(NULL);
}


ULONG render(Class *cl,Object *o,Msg msg)
{
  struct gpRender *rend = (struct gpRender *)msg;
  struct Gadget *btn = (struct Gadget *)o;
  struct Image *img = (struct Image *)btn->GadgetRender;
  struct objectdata *dt = (struct objectdata *)INST_DATA(cl,o);
  struct RastPort *rp = rend->gpr_RPort;
  struct opSet set;
  struct impDraw draw;
  struct TagItem tag[5];
  UWORD *pens = rend->gpr_GInfo->gi_DrInfo->dri_Pens;

  if(dt->redo)
  {
    set.MethodID = OM_SET;
    set.ops_AttrList = tag;
    set.ops_GInfo = rend->gpr_GInfo;
    tag[0].ti_Tag = IA_Left; tag[1].ti_Tag = IA_Top;
    if(dt->layout&(LAYOUT_IMGABOVE|LAYOUT_IMGBELOW))
    {
      tag[2].ti_Tag = IA_Width; tag[2].ti_Data = btn->Width-4;
      tag[0].ti_Data = btn->LeftEdge+2;
      if(dt->layout&LAYOUT_IMGABOVE)
      {
        /* Compensation adjusted.. */
        tag[1].ti_Data = btn->TopEdge+btn->Height-rp->TxHeight-2;
        tag[3].ti_Tag = TAG_DONE;
        DoMethodA((Object *)dt->texti,(Msg)&set);
        tag[1].ti_Data = btn->TopEdge+1;
      }
      else
      {
        tag[1].ti_Data = btn->TopEdge+1;
        tag[3].ti_Tag = TAG_DONE;
        DoMethodA((Object *)dt->texti,(Msg)&set);
        /* Compensation adjusted.. */
        tag[1].ti_Data = btn->TopEdge+btn->Height-img->Height-1;
      }
      if(dt->layout&LAYOUT_IMGLEFT) ; /* Already set */
      /* Note that subtracting img->Width fixes 1/one pixelbug */
      else if(dt->layout&LAYOUT_IMGRIGHT) tag[0].ti_Data =
      	btn->LeftEdge+btn->Width-1-img->Width-1;
      else tag[0].ti_Data = btn->LeftEdge + btn->Width/2 - img->Width/2;
      tag[2].ti_Tag = TAG_DONE;
      DoMethodA((Object *)img,(Msg)&set);
    } /* if(dt->layout&(LAYOUT_IMGABOVE|LAYOUT_IMGBELOW) */
    else if(dt->layout&(LAYOUT_IMGLEFT|LAYOUT_IMGRIGHT))
    {
      tag[2].ti_Tag = IA_Width;
      tag[2].ti_Data = btn->Width-4-img->Width-2;
      tag[1].ti_Data = btn->TopEdge + btn->Height/2 - (rp->TxHeight+1)/2;
      if(dt->layout&LAYOUT_IMGLEFT)
      {
        /* Again the set width in tag[2] compensates for 1 pixelbug */
        tag[0].ti_Data = btn->LeftEdge+img->Width+3;
        tag[3].ti_Tag = TAG_DONE;
        DoMethodA((Object *)dt->texti,(Msg)&set);
        tag[0].ti_Data = btn->LeftEdge+2;
      }
      else
      {
        tag[0].ti_Data = btn->LeftEdge+3;
        tag[3].ti_Tag = TAG_DONE;
        DoMethodA((Object *)dt->texti,(Msg)&set);
        /* Subtracting img->Width compensates for pixelbug */
        tag[0].ti_Data = btn->LeftEdge+btn->Width-1-img->Width;
      }
      tag[1].ti_Data = btn->TopEdge + btn->Height/2 - img->Height/2;
      tag[2].ti_Tag = TAG_DONE;
      DoMethodA((Object *)img,(Msg)&set);
    } /* else if(dt->layout&(LAYOUT_IMGLEFT|LAYOUT_IMGRIGHT) */
    else
    {
      tag[0].ti_Tag = IA_Top;
      tag[0].ti_Data = btn->TopEdge + (btn->Height+1)/2 - (rp->TxHeight+1)/2;
      tag[1].ti_Tag = TAG_DONE;
      DoMethodA((Object *)dt->texti,(Msg)&set);
    }
    dt->redo = FALSE;
  }
  /* Render gadget */
  draw.MethodID = IM_DRAW;
  draw.imp_RPort = rp;
  draw.imp_Offset.X = 0; draw.imp_Offset.Y = 0;
  if(btn->Flags&GFLG_SELECTED)
  {
    draw.imp_State = IDS_SELECTED;
  }
  else
  {
    draw.imp_State = IDS_NORMAL;
  }
  draw.imp_DrInfo = rend->gpr_GInfo->gi_DrInfo;
  if(dt->flags&F_BORDER) DoMethodA((Object *)dt->border,(Msg)&draw);
  if(btn->GadgetRender)
  {
    if(dt->layout&LAYOUT_IMGREL)
    {
#ifdef DEBUG
  DLprintf(console,"\nLAYOUT_IMGREL flag\n");
#endif
      draw.imp_Offset.X = btn->LeftEdge; draw.imp_Offset.Y = btn->TopEdge;
    }
    DoMethodA((Object *)btn->GadgetRender,(Msg)&draw);
  }
  if(btn->Flags&GFLG_LABELSTRING)
  {
    /*
       IDS_SLECTED state highlites CFtexti objects and if highlite
       is not selected the button label should always be drawn
       with IDS_NORMAL.
    */
    if(!(dt->flags&F_HIGHLITE)) draw.imp_State = IDS_NORMAL;
    DoMethodA((Object *)dt->texti,(Msg)&draw);
  }

  return(NULL);
}
