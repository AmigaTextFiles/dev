/* Sample class  for StormC*/

#include <clib/alib_protos.h>
#include <proto/graphics.h>
#include <proto/intuition.h>
#include <proto/utility.h>
#include <exec/libraries.h>
#include <intuition/classes.h>
#include <intuition/imageclass.h>
#include <dos/dos.h>
#include "class.h"
#include "CFfuelgi.h"
#include "CFtexti.h"
#ifdef DEBUG
 #include "debug_protos.h"
 extern APTR console;
#endif

Class *initclass(struct classbase *base)
{
  Class *cl;

  if(cl = MakeClass(CFfuelgiClassName,FRAMEICLASS,NULL,
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
    case IM_DRAW:
      return(draw(cl,o,msg));
    default:
      return(DoSuperMethodA(cl,o,msg));
  }
}

ULONG newobject(Class *cl,Object *o,Msg msg)
{
  ULONG newobj;
  struct objectdata *dt;
  struct TagItem *attrs = ((struct opSet *)msg)->ops_AttrList;
  struct TagItem tag[6];
  ULONG max,left,top,width,height;
  char *label;
  struct Image *fgim;

#ifdef DEBUG
  DLprintf(console,"New object\n");
#endif
  /* Get class attributes */
  max = GetTagData(CFFG_Max,1,attrs);
  label = (char *)GetTagData(CFFG_Label,NULL,attrs);
  left = GetTagData(IA_Left,0,attrs);
  top = GetTagData(IA_Top,0,attrs);
  width = GetTagData(IA_Width,10,attrs);
  height = GetTagData(IA_Height,10,attrs);
  /* Set suoerclass attrs */
  tag[0].ti_Tag = IA_Left; tag[0].ti_Data = left;
  tag[1].ti_Tag = IA_Top; tag[1].ti_Data = top;
  tag[2].ti_Tag = IA_Width; tag[2].ti_Data = width;
  tag[3].ti_Tag = IA_Height; tag[3].ti_Data = height;
  tag[4].ti_Tag = IA_Recessed; tag[4].ti_Data = TRUE;
  tag[5].ti_Tag = TAG_DONE;
  ((struct opSet *)msg)->ops_AttrList = tag;

  if(newobj = DoSuperMethodA(cl,o,msg))
  {
#ifdef DEBUG
  DLprintf(console,"New object created!\n");
#endif
    fgim = (struct Image *)newobj;
    dt = (struct objectdata *)INST_DATA(cl,newobj);
    dt->max = max;
    dt->flags = FGF_NEW;
    if(label)
    {
      dt->label = (struct Image *)NewObject(NULL,CFtextiClassName,
      			IA_Left, fgim->LeftEdge,
      			IA_Top, 0,
      			IA_Width, fgim->Width,
      			IA_Data, label,
      			IA_FGPen, 1,
      			CFTI_PosFlags, TIPOS_CENTER,
      			CFTI_Redraw, FALSE,
      			TAG_DONE);
    }
  }
  return(newobj);
}

ULONG dispose(Class *cl,Object *o)
{
  struct objectdata *dt = (struct objectdata *)INST_DATA(cl,o);

  if(dt->label) DisposeObject(dt->label);
  return(DoSuperMethod(cl,o,OM_DISPOSE));
}


ULONG draw(Class *cl,Object *o,Msg msg)
{
  struct objectdata *dt = (struct objectdata *)INST_DATA(cl,o);
  struct impDraw *draw = (struct impDraw *)msg;
  struct RastPort *rp = draw->imp_RPort;
  struct Image *fgim = (struct Image *)o;
  struct opSet set;
  struct TagItem tag[2];
  ULONG fillw;

  if(dt->flags&FGF_NEW)
  {
    set.MethodID = OM_SET;
    set.ops_AttrList = tag;
    set.ops_GInfo = NULL;
    tag[0].ti_Tag = IA_Top;
    tag[0].ti_Data = fgim->TopEdge+fgim->Height/2-rp->TxHeight/2-1;
    tag[1].ti_Tag = TAG_DONE;
    DoMethodA((Object *)dt->label,(Msg)&set);
    dt->flags &= ~FGF_NEW;
  }
  fillw = (draw->imp_State*fgim->Width)/dt->max;
  if(fillw>fgim->Width-2) fillw = fgim->Width-2;
  DoSuperMethodA(cl,o,msg);
  SetAPen(rp,3);
  RectFill(rp,fgim->LeftEdge+1,fgim->TopEdge+1,
  		fgim->LeftEdge+fillw, fgim->TopEdge+fgim->Height-2);
  if(dt->label)
  {
    draw->imp_State = IDS_NORMAL;
    DoMethodA((Object *)dt->label,msg);
  }
  return(0);
}
