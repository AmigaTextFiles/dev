/* Sample class  for StormC*/

#include <clib/alib_protos.h>
#include <proto/intuition.h>
#include <proto/utility.h>
#include <exec/libraries.h>
#include <intuition/classes.h>
#include <intuition/gadgetclass.h>
#include <intuition/imageclass.h>
#include <dos/dos.h>
#include "class.h"
#include "CFlist.h"
#include "CFtexti.h"
#ifdef DEBUG
 #include "debug_protos.h"
 extern APTR console;
#endif

Class *initclass(struct classbase *base)
{
  Class *cl;

  if(cl = MakeClass(CFlistClassName,GADGETCLASS,NULL,
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
    case OM_GET:
      return(getattrs(cl,o,msg));
    case OM_SET:
    case OM_UPDATE:
      return(setattrs(cl,o,msg));
    case GM_HITTEST:
      return(GMR_GADGETHIT);
    case GM_GOACTIVE:
      return(GMR_MEACTIVE);//activate(cl,o,msg));
    case GM_HANDLEINPUT:
      return(handleinput(cl,o,msg));
    case GM_GOINACTIVE:
      return(NULL);//return(inactivate(cl,o,msg));
    case GM_RENDER:
      return(render(cl,o,msg));
    default:
      return(DoSuperMethodA(cl,o,msg));
  }
}

ULONG newobject(Class *cl,Object *o,Msg msg)
{
  struct TagItem *intags = ((struct opSet *)msg)->ops_AttrList;
  struct Gadget *lst;
  struct Node *nd;
  ULONG bor;
  Tag filter[] = {GA_Highlight,GA_Border,TAG_DONE};

  bor = GetTagData(GA_Border,TRUE,intags);
  FilterTagItems(intags,filter,TAGFILTER_NOT);
  if(lst = (struct Gadget *)DoSuperMethodA(cl,o,msg))
  {
    struct objectdata *dt = (struct objectdata *)INST_DATA(cl,lst);

    dt->lcnt = 0;
    /* List always sends IDCMP_GADGETUP */
    lst->Activation |= GACT_RELVERIFY;
    if(dt->labels = (struct List *)GetTagData(CFL_Labels,NULL,intags))
    {
      nd = dt->labels->lh_Head;
      do
      {
        dt->lcnt++;
        nd = nd->ln_Succ;
      }
      while(nd->ln_Succ);
    }
    dt->top = GetTagData(CFL_Top,NULL,intags);
    dt->sel = GetTagData(CFL_Selected,~0L,intags);
    if(!(dt->labimg = (struct Image *)NewObject(NULL,CFtextiClassName,
    		IA_Left, lst->LeftEdge+2, IA_Top, lst->TopEdge+2,
    		IA_Width, lst->Width-4,
    		IA_Data, NULL,
    		TAG_DONE))) goto error;
    dt->labimg->NextImage = NULL;
    if(GetTagData(CFL_ReadOnly,FALSE,intags)) dt->flags = LIST_READONLY;
    if(bor)
    {
      if(!(dt->border = (struct Image *)NewObject(NULL,FRAMEICLASS,
      		IA_Left, lst->LeftEdge, IA_Top, lst->TopEdge,
      		IA_Width, lst->Width, IA_Height, lst->Height,
      		IA_FrameType, FRAME_BUTTON,
      		IA_EdgesOnly, TRUE,
      		TAG_DONE))) goto error;
    }
    else dt->border = NULL;
    return((ULONG)lst);
  }
  error:
  DoMethod((Object *)lst,OM_DISPOSE);
  return(NULL);
}

ULONG dispose(Class *cl,Object *o)
{
  struct objectdata *dt = (struct objectdata *)INST_DATA(cl,o);

  if(dt->border) DisposeObject((Object *)dt->border);
  if(dt->labimg) DisposeObject((Object *)dt->labimg);
  DoSuperMethod(cl,o,OM_DISPOSE);
  return(NULL);
}

ULONG getattrs(Class *cl,Object *o,Msg msg)
{
  struct opGet *get = (struct opGet *)msg;
  struct objectdata *dt = (struct objectdata *)INST_DATA(cl,o);

  if(get->opg_AttrID == CFL_Visible)
  {
    *(get->opg_Storage) = dt->vis;
    return((ULONG)dt->vis);
  }
  return(DoSuperMethodA(cl,o,msg));
}

ULONG setattrs(Class *cl,Object *o,Msg msg)
{
  struct opSet *set = (struct opSet *)msg,imgset;
  struct TagItem *attrs = set->ops_AttrList,*attr,tag[5];
  struct objectdata *dt = (struct objectdata *)INST_DATA(cl,o);
  ULONG count = 0;

  if(attr = FindTagItem(GA_Left,attrs))
  {
    tag[count].ti_Tag = IA_Left; tag[count].ti_Data = attr->ti_Data;
    count++;
  }
  if(attr = FindTagItem(GA_Top,attrs))
  {
    tag[count].ti_Tag = IA_Top; tag[count].ti_Data = attr->ti_Data;
    count++;
  }
  if(count)
  {
    tag[count].ti_Tag = TAG_DONE;
    imgset.MethodID = OM_SET;
    imgset.ops_AttrList = tag;
    imgset.ops_GInfo = NULL;
    DoMethodA((Object *)dt->border,(Msg)&imgset);
    count = 0;
    if(tag[count].ti_Tag == IA_Left) tag[count++].ti_Data += 2;
    if(tag[count].ti_Tag == IA_Top) tag[count++].ti_Data += 2;
    DoMethodA((Object *)dt->labimg,(Msg)&imgset);
  }
  if(attr = FindTagItem(CFL_Top,attrs))
  {
    struct opUpdate *upd = (struct opUpdate *)msg;
    struct gpRender rend;

    dt->top = attr->ti_Data;
    if(set->MethodID==OM_UPDATE&&upd->opu_Flags&OPUF_INTERIM)
    {
      rend.MethodID = GM_RENDER;
      rend.gpr_GInfo = set->ops_GInfo;
      rend.gpr_RPort = ObtainGIRPort(set->ops_GInfo);
      rend.gpr_Redraw = GREDRAW_REDRAW;
      DoMethodA(o,(Msg)&rend);
      ReleaseGIRPort(rend.gpr_RPort);
    }
  }
  return(DoSuperMethodA(cl,o,msg));
}


ULONG activate(Class *cl,Object *o,Msg msg)
{
  return(GMR_MEACTIVE);
}

ULONG handleinput(Class *cl,Object *o,Msg msg)
{
  struct gpInput *input = (struct gpInput *)msg;
  struct objectdata *dt = (struct objectdata *)INST_DATA(cl,o);
  struct Gadget *lst = (struct Gadget *)o;
  struct gpRender rend;
  WORD my = input->gpi_Mouse.Y,rely = my-2,pos;

  if(input->gpi_IEvent->ie_Class == IECLASS_RAWMOUSE)
  {
    if(rely<0) rely = 0;
    if(rely>=dt->labimg->Height*dt->vis) rely = dt->labimg->Height*dt->vis-1;
    pos = rely/dt->labimg->Height+dt->top;
    if(pos!=dt->sel)
    {
      dt->nsel = pos;
      dt->flags |= LIST_CHANGED;
      rend.MethodID = GM_RENDER;
      rend.gpr_GInfo = input->gpi_GInfo;
      rend.gpr_RPort = ObtainGIRPort(input->gpi_GInfo);
      rend.gpr_Redraw = GREDRAW_UPDATE;
      DoMethodA(o,(Msg)&rend);
      ReleaseGIRPort(rend.gpr_RPort);
    }
    if(input->gpi_IEvent->ie_Code == SELECTUP)
    {
      if(dt->flags&LIST_CHANGED)
      {
        *(input->gpi_Termination) = dt->sel;
        dt->flags &=~LIST_CHANGED;
        return(GMR_NOREUSE|GMR_VERIFY);
      }
      else return(GMR_NOREUSE);
    }
  }
  return(GMR_MEACTIVE);
}

ULONG inactivate(Class *cl,Object *o,Msg msg)
{
  return(NULL);
}

ULONG render(Class *cl,Object *o,Msg msg)
{
  struct objectdata *dt = (struct objectdata *)INST_DATA(cl,o);
  struct gpRender *rend = (struct gpRender *)msg;
  struct impDraw draw;
  struct opSet set;
  struct TagItem tag[5];
  struct Gadget *lst = (struct Gadget *)o;
  struct Node *node;
  ULONG index = 0;

  draw.MethodID = IM_DRAW;
  draw.imp_RPort = rend->gpr_RPort;
  draw.imp_Offset.X = 0; draw.imp_Offset.Y = 0;
  draw.imp_DrInfo = rend->gpr_GInfo->gi_DrInfo;
  set.MethodID = OM_SET;
  set.ops_GInfo = NULL;
  set.ops_AttrList = tag;
  tag[0].ti_Tag = IA_Data; tag[0].ti_Data = NULL;
  tag[1].ti_Tag = TAG_DONE;
  if(rend->gpr_Redraw==GREDRAW_REDRAW)
  {
    /* First redraw border */
    if(dt->flags&LIST_READONLY) draw.imp_State = IDS_SELECTED;
    else draw.imp_State = IDS_NORMAL;
    DoMethodA((Object *)dt->border,(Msg)&draw);
    /* Set and draw labimg to initialize it's Height attribute */
    DoMethodA((Object *)dt->labimg,(Msg)&set);
    DoMethodA((Object *)dt->labimg,(Msg)&draw);
    /* Calculate max number of visible labels */
    dt->vis = (lst->Height-4)/dt->labimg->Height;
    /* Unattractive but effective way to adjust top value */
    while(dt->lcnt-dt->top<dt->vis&&dt->top>0) dt->top--;
    /* Find first label node */
    node = dt->labels->lh_Head;
    index = 0;
    while(index++<dt->top) node = node->ln_Succ;
    /* Draw all labels */
    index = 0;
    do
    {
      tag[0].ti_Data = (ULONG)node->ln_Name;
      DoMethodA((Object *)dt->labimg,(Msg)&set);
      if(index+dt->top==dt->sel) draw.imp_State = IDS_SELECTED;
      else draw.imp_State = IDS_NORMAL;
      DoMethodA((Object *)dt->labimg,(Msg)&draw);
      draw.imp_Offset.Y += dt->labimg->Height;
      index++;
      node = node->ln_Succ;
    }
    while(node->ln_Succ&&index<dt->vis);
    /* Adjust number of visible labels so handleinput dowsn't draw empty labels */
    if(index<dt->vis) dt->vis = index;
  }
  else
  {
#ifdef DEBUG
  DLprintf(console,"Render update\n");
#endif
    /* Because of set/update dt->sel can be outside visible area
       and should not be drawn */
    if(dt->sel-dt->top>=0&&dt->sel-dt->top<dt->vis)
    {
      /* Find and set label text */
      index = 0;
      node = dt->labels->lh_Head;
      while(index++<dt->sel) node = node->ln_Succ;
      tag[0].ti_Data = (ULONG)node->ln_Name;
      DoMethodA((Object *)dt->labimg,(Msg)&set);
      /* Draw old select label */
      draw.imp_Offset.Y = (dt->sel-dt->top)*dt->labimg->Height;
      draw.imp_State = IDS_NORMAL;
      DoMethodA((Object *)dt->labimg,(Msg)&draw);
    }
    /* Find and set label text */
    index = 0;
    node = dt->labels->lh_Head;
    while(index++<dt->nsel) node = node->ln_Succ;
    tag[0].ti_Data = (ULONG)node->ln_Name;
    DoMethodA((Object *)dt->labimg,(Msg)&set);
    /* Draw new select label */
    draw.imp_Offset.Y = (dt->nsel-dt->top)*dt->labimg->Height;
    draw.imp_State = IDS_SELECTED;
    DoMethodA((Object *)dt->labimg,(Msg)&draw);
    dt->sel = dt->nsel; dt->nsel = NULL;
  }
  return(1);
}








