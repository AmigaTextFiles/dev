/* Sample class  for StormC*/

#include <clib/alib_protos.h>
#include <proto/intuition.h>
#include <proto/utility.h>
#include <exec/libraries.h>
#include <intuition/icclass.h>
#include <intuition/classes.h>
#include <dos/dos.h>
#include "class.h"
#include "CFlist.h"
#include "CFscroller.h"
#include "CFgroupg.h"
#include "CFlistview.h"
#ifdef DEBUG
 #include "debug_protos.h"
 extern APTR console;
#endif

Class *initclass(struct classbase *base)
{
  Class *cl;

  if(cl = MakeClass(CFlistviewClassName,GROUPGCLASS,NULL,
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
    case GM_RENDER:
      return(render(cl,o,msg));
    default:
      return(DoSuperMethodA(cl,o,msg));
  }
}


ULONG newobject(Class *cl,Object *o,Msg msg)
{
  struct opSet *set = (struct opSet *)msg;//,gset;
  struct Gadget *gad;
  struct objectdata *dt;
  struct TagItem *attrs = set->ops_AttrList;//,tags[5];
  ULONG width,height,top,read,sel,dri;
  struct List *labels;
  struct Node *label;
  WORD count = 0;

#ifdef DEBUG
  DLprintf(console,"Newobject called\n");
#endif
  if(!(dri = GetTagData(GA_DrawInfo,0,attrs))) goto error;
  width = GetTagData(GA_Width,50,attrs);
  height = GetTagData(GA_Height,40,attrs);
  labels = (struct List *)GetTagData(CFLV_Labels,NULL,attrs);
  top = GetTagData(CFLV_Top,0,attrs);
  read = GetTagData(CFLV_ReadOnly,0,attrs);
  sel = GetTagData(CFLV_Selected,0,attrs);
/*
  gset.MethodID = OM_NEW;
  gset.ops_AttrList = tags;
  gset.ops_GInfo = NULL;
  tags[0].ti_Tag = GA_Left; tags[0].ti_Data = GetTagData(GA_Left,0,attrs);
  tags[1].ti_Tag = GA_Top; tags[1].ti_Data = GetTagData(GA_Top,0,attrs);
  tags[2].ti_Tag = TAG_DONE;
*/
  if(gad = (struct Gadget *)DoSuperMethodA(cl,o,msg))
  {
#ifdef DEBUG
  DLprintf(console,"Groupgadget object created\n");
#endif
    dt = (struct objectdata *)INST_DATA(cl,gad);
    dt->lcnt = 0;
    /* Listview always sends IDCMP_GADGETUP messages */
    gad->Activation |= GACT_RELVERIFY;
    if(labels)
    {
      label = labels->lh_Head;
      while(label->ln_Succ)
      {
        dt->lcnt++;
        label = label->ln_Succ;
      }
    }
    if(dt->list = (struct Gadget *)NewObject(NULL,CFlistClassName,
    		GA_Left, 0, GA_Top, 0,
    		GA_Width, width-18, GA_Height, height,
    		CFL_Labels, labels,
    		CFL_Top, top,
    		CFL_ReadOnly, read,
    		CFL_Selected, sel,
    		TAG_DONE))
    {
#ifdef DEBUG
  DLprintf(console,"CFlist object created\n");
#endif
      dt->tagmap[0].ti_Tag = CFSC_Top; dt->tagmap[0].ti_Data = CFL_Top;
      dt->tagmap[1].ti_Tag = TAG_DONE;
      if(dt->scrl = (struct Gadget *)NewObject(NULL,CFscrollerClassName,
    		GA_Left, width-18, GA_Top, 0,
    		GA_Height, height,
    		GA_DrawInfo, dri,
    		CFSC_Freedom, FREEVERT,
    		CFSC_Top, top, CFSC_Visible, 0, CFSC_Total, dt->lcnt,
    		CFSC_Size, SIZE_MEDRES,
    		GA_ID, GID_SCRL,
    		ICA_TARGET, dt->list,
    		ICA_MAP, dt->tagmap,
    		TAG_DONE))
      {
#ifdef DEBUG
  DLprintf(console,"CFscroller object created\n");
#endif
        DoMethod((Object *)gad,OM_ADDMEMBER,dt->list);
        DoMethod((Object *)gad,OM_ADDMEMBER,dt->scrl);
#ifdef DEBUG
  DLprintf(console,"Gadget created - returning\n");
#endif
        return((ULONG)gad);
      }
      DisposeObject(dt->list);
    }
    DoMethod((Object *)gad,OM_DISPOSE)
  }
  error:
#ifdef DEBUG
  DLprintf(console,"Error!!\n");
#endif
  return(NULL);
}
/*
ULONG update(Class *cl,Object *o,Msg msg)
{
  struct opUpdate *upd = (struct opUpdate *)msg;
  struct objectdata *dt = (struct objectdata *)INST_DATA(cl,o);
  struct TagItem *attrs = upd->opu_AttrList;
  ULONG gid;

  attr


}
*/

ULONG render(Class *cl,Object *o,Msg msg)
{
  struct gpRender *rend = (struct gpRender *)msg;
  struct objectdata *dt = (struct objectdata *)INST_DATA(cl,o);
  struct opGet get;
  struct opSet set;
  struct TagItem tag[3];
  ULONG vis;

  if(rend->gpr_Redraw&GREDRAW_REDRAW)
  {
    DoMethodA((Object *)dt->list,msg);
    get.MethodID = OM_GET;
    get.opg_AttrID = CFL_Visible;
    get.opg_Storage = &vis;
    DoMethodA((Object *)dt->list,(Msg)&get);
    set.MethodID = OM_SET;
    set.ops_AttrList = tag;
    set.ops_GInfo = NULL;
    tag[0].ti_Tag = CFSC_Visible; tag[0].ti_Data = vis;
    tag[1].ti_Tag = TAG_DONE;
    DoMethodA((Object *)dt->scrl,(Msg)&set);
    DoMethodA((Object *)dt->scrl,msg);
    return(1);
  }
  return(DoSuperMethodA(cl,o,msg));
}