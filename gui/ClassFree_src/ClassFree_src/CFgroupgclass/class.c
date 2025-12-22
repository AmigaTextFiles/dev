/* Sample class  for StormC*/

#include <clib/alib_protos.h>
#include <proto/intuition.h>
#include <exec/libraries.h>
#include <intuition/classes.h>
#include <intuition/gadgetclass.h>
#include <dos/dos.h>
#include "class.h"
#include "CFgroupg.h"
#ifdef DEBUG
 #include "debug_protos.h"
 extern APTR console;
#endif

Class *initclass(struct classbase *base)
{
  Class *cl;

  if(cl = MakeClass(CFgroupgClassName,GADGETCLASS,NULL,
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
    case OM_ADDMEMBER:
      return(addmember(cl,o,msg));
    case OM_REMMEMBER:
      return(remmember(cl,o,msg));
    case GM_HITTEST:
      return(hittest(cl,o,msg));
    case GM_GOACTIVE:
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
  struct Gadget *gad;
  struct objectdata *dt;
  struct List *list;
  ULONG obj;

  if(obj = DoSuperMethodA(cl,o,msg))
  {
    gad = (struct Gadget *)obj;
    dt = (struct objectdata *)INST_DATA(cl,obj);
    list = (struct List *)dt;

    NewList(list);
    dt->act = 0;
    gad->Width = 0; gad->Height = 0;
    return(obj);
  }
  return(NULL);
}

ULONG dispose(Class *cl,Object *o)
{
  struct List *list = INST_DATA(cl,o);
  APTR lp = list->lh_Head;
  Object *obj;

  while(obj = NextObject(&lp))
  {
    DoMethod(obj,OM_REMOVE);
    DoMethod(obj,OM_DISPOSE);
  }

  DoSuperMethod(cl,o,OM_DISPOSE);
  return(NULL);
}

ULONG addmember(Class *cl,Object *o,Msg msg)
{
  struct opMember *opm = (struct opMember *)msg;
  struct opAddTail add;
  struct Gadget *gad = (struct Gadget *)opm->opam_Object;
  struct Gadget *ggad =(struct Gadget *)o;
  WORD gx = gad->LeftEdge+gad->Width-1,gy = gad->TopEdge+gad->Height-1;

  add.MethodID = OM_ADDTAIL;
  add.opat_List = INST_DATA(cl,o);
  if(ggad->Width<gx) ggad->Width = gx;
  if(ggad->Height<gy) ggad->Height = gy;
  gad->LeftEdge += ggad->LeftEdge;
  gad->TopEdge += ggad->TopEdge;
  DoMethodA(opm->opam_Object,(Msg)&opm);
  return(1);
}

ULONG remmember(Class *cl,Object *o,Msg msg)
{
  struct opMember *opm = (struct opMember *)msg;

  DoMethod(opm->opam_Object,OM_REMOVE);
  return(1);
}


ULONG hittest(Class *cl,Object *o,Msg msg)
{
  struct gpHitTest *test = (struct gpHitTest *)msg;
  struct Gadget *gad,*ggad = (struct Gadget *)o;
  struct objectdata *dt = (struct objectdata *)INST_DATA(cl,o);
  struct List *list = (struct List *)dt;
  WORD x = test->gpht_Mouse.X ,y = test->gpht_Mouse.Y;
  ULONG result;
  APTR lp = list->lh_Head;

  while(gad = (struct Gadget *)NextObject(&lp)) /* Simple really.. :) */
  {
    test->gpht_Mouse.X = x-(gad->LeftEdge-ggad->LeftEdge);
    test->gpht_Mouse.Y = y-(gad->TopEdge-ggad->TopEdge);
    if(result = DoMethodA((Object *)gad,msg))
    {
      dt->act = gad;
      return(result);
    }
  }

  return(NULL);
}

ULONG handleinput(Class *cl,Object *o,Msg msg)
{
  struct objectdata *dt = (struct objectdata *)INST_DATA(cl,o);
  struct gpInput *in = (struct gpInput *)msg;
  struct Gadget *ggad = (struct Gadget *)o;

  in->gpi_Mouse.X -= dt->act->LeftEdge-ggad->LeftEdge;
  in->gpi_Mouse.Y -= dt->act->TopEdge-ggad->TopEdge;
  return(DoMethodA((Object *)dt->act,msg));
}


ULONG goinactive(Class *cl,Object *o,Msg msg)
{
  struct objectdata *dt = (struct objectdata *)INST_DATA(cl,o);
  ULONG result;

  result = DoMethodA((Object *)dt->act,msg);
  dt->act = NULL;
  return(result);
}


ULONG render(Class *cl,Object *o,Msg msg)
{
  struct List *list = (struct List *)INST_DATA(cl,o);
  Object *obj;
  APTR lp = list->lh_Head;

  while(obj = NextObject(&lp)) DoMethodA(obj,msg);

  return(1);
}

