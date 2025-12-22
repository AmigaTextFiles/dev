/* Sample class  for StormC*/

#include <clib/alib_protos.h>
#include <proto/intuition.h>
#include <proto/utility.h>
#include <exec/libraries.h>
#include <intuition/classes.h>
#include <intuition/icclass.h>
#include <dos/dos.h>
#include "class.h"
#include "CFscroller.h"
#include "CFbutton.h"
#ifdef DEBUG
 #include "debug_protos.h"
 extern APTR console;
#endif

Class *initclass(struct classbase *base)
{
  Class *cl;

  if(cl = MakeClass(CFscrollerClassName,GADGETCLASS,NULL,
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
    case OM_UPDATE:
      return(update(cl,o,msg));
    case GM_HITTEST:
      return(hittest(cl,o,msg));
    case GM_GOACTIVE:
//      return(handleinput(cl,o,msg));
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
  struct TagItem *attrs = ((struct opSet *)msg)->ops_AttrList;
  struct Gadget *scr;
  struct Image *decimg,*incimg;
  struct objectdata *dt;
  struct DrawInfo *dri;
  ULONG size,fdm,dec,inc,total,visible,top;
  WORD x,y,oldfill;

  if(scr = (struct Gadget *)DoSuperMethodA(cl,o,msg))
  {
    if(!(dri = (struct DrawInfo *)GetTagData(GA_DrawInfo,NULL,attrs)))
    {
      DoSuperMethod((Class *)o,(Object *)scr,OM_DISPOSE); /* o contains true  */
      return(NULL);					 /* class for OM_NEW */
    }
    dt->rep = 0;
    size = GetTagData(CFSC_Size,SIZE_MEDRES,attrs);
    fdm = GetTagData(CFSC_Freedom,FREEVERT,attrs);
    total = GetTagData(PGA_Total,1,attrs);
    visible = GetTagData(PGA_Visible,1,attrs);
    top = GetTagData(PGA_Top,0,attrs);
    if(fdm == FREEVERT)
    {
      dec = UPIMAGE;
      inc = DOWNIMAGE;
    }
    else
    {
      dec = LEFTIMAGE;
      inc = RIGHTIMAGE;
    }
    dt = INST_DATA(((Class *)o),scr);
    /* Change fill color */
    oldfill = dri->dri_Pens[FILLPEN];
    dri->dri_Pens[FILLPEN] = 0;
    decimg = (struct Image *)NewObject(NULL,SYSICLASS,
    		IA_Left, 0, IA_Top, 0,
    		SYSIA_Which, dec,
    		SYSIA_DrawInfo, dri,
    		SYSIA_Size, size,
    		TAG_DONE);
    incimg = (struct Image *)NewObject(NULL,SYSICLASS,
    		IA_Left, 0, IA_Top, 0,
    		SYSIA_Which, inc,
    		SYSIA_DrawInfo, dri,
    		SYSIA_Size, size,
    		TAG_DONE);
    dri->dri_Pens[FILLPEN] = oldfill;
    if(decimg&&incimg)
    {
      if(fdm == FREEVERT)
      {
        scr->Width = decimg->Width;
        x = scr->Width;
        y = scr->Height-decimg->Height*2;
      }
      else
      {
        x = scr->Width-decimg->Width*2;
        scr->Height = decimg->Height;
        y = scr->Height;
      }
      dt->pframe = (struct Image *)NewObject(NULL,FRAMEICLASS,
    		IA_Left, scr->LeftEdge, IA_Top, scr->TopEdge,
    		IA_Width, x, IA_Height, y,
    		IA_FrameType, FRAME_BUTTON,
    		TAG_DONE);
      dt->prop = NewObject(NULL,PROPGCLASS,
    		GA_Left, scr->LeftEdge+4, GA_Top, scr->TopEdge+2,
    		GA_Width, x-8, GA_Height, y-4,
    		PGA_Freedom, fdm, PGA_NewLook, TRUE, PGA_Borderless,TRUE,
    		PGA_Total, total, PGA_Visible, visible, PGA_Top, top,
    		ICA_TARGET, scr,
    		GA_ID, 0,
    		TAG_DONE);
      if(dt->pframe&&dt->prop)
      {
        if(fdm == FREEVERT) x = 0;
        else y = 0;
        dt->decbtn = NewObject(NULL,CFbuttonClassName,
        	GA_Left, scr->LeftEdge+x, GA_Top, scr->TopEdge+y,
        	GA_Width, decimg->Width, GA_Height, decimg->Height,
        	GA_Image, decimg, GA_Border, FALSE, GA_Highlight, FALSE,
        	CFBU_Layout, LAYOUT_IMGREL,
        	GA_ID, DECBTN,
        	ICA_TARGET, scr,
        	TAG_DONE);
        if(fdm == FREEVERT) y += decimg->Height;
        else x += decimg->Width;
        dt->incbtn = NewObject(NULL,CFbuttonClassName,
        	GA_Left, scr->LeftEdge+x, GA_Top, scr->TopEdge+y,
        	GA_Width, incimg->Width, GA_Height, incimg->Height,
        	GA_Image, incimg, GA_Border, FALSE, GA_Highlight, FALSE,
        	CFBU_Layout, LAYOUT_IMGREL,
        	GA_ID, INCBTN,
        	ICA_TARGET, scr,
        	TAG_DONE);
        if(dt->decbtn&&dt->incbtn)
        {
          return((ULONG)scr);
        }
        DisposeObject((Object *)dt->decbtn);
        dt->decbtn = NULL;
        DisposeObject((Object *)dt->incbtn);
        dt->incbtn = NULL;
      } /* if(dt->pframe&&dt->prop) */
      DisposeObject((Object *)dt->pframe);
      dt->pframe = NULL;
      DisposeObject((Object *)dt->prop);
      dt->prop = NULL;
    } /* if(decimg&&incimg) */
    DisposeObject((Object *)decimg);
    DisposeObject((Object *)incimg);
    DoMethod((Object *)scr,OM_DISPOSE);
  }
  return(NULL);
}

ULONG dispose(Class *cl,Object *o)
{
  struct objectdata *dt = INST_DATA(cl,o);
  ULONG decimg = NULL,incimg = NULL;

  if(dt->decbtn)
  {
    if(dt->decbtn->GadgetRender) DisposeObject((Object *)dt->decbtn->GadgetRender);
    DisposeObject((Object *)dt->decbtn);
  }
  if(dt->incbtn)
  {
    if(dt->incbtn->GadgetRender) DisposeObject((Object *)dt->incbtn->GadgetRender);
    DisposeObject((Object *)dt->incbtn);
  }
  DisposeObject((Object *)dt->pframe);
  DisposeObject((Object *)dt->prop);

  DoSuperMethod(cl,o,OM_DISPOSE);
  return(NULL);
}

ULONG setattrs(Class *cl,Object *o,Msg msg)
{
  struct opSet *set = (struct opSet *)msg;
  struct Gadget *scr = (struct Gadget *)o;
  struct objectdata *dt = (struct objectdata *)INST_DATA(cl,o);
  struct TagItem *attrs = set->ops_AttrList;
  Tag filter[] = {PGA_Top,PGA_Visible,PGA_Total,TAG_DONE};

  DoSuperMethodA(cl,o,msg);
  FilterTagItems(attrs,filter,TAGFILTER_AND);
  DoMethodA((Object *)dt->prop,msg);

  dt->pframe->LeftEdge = scr->LeftEdge;
  dt->pframe->TopEdge = scr->TopEdge;
  dt->prop->LeftEdge = scr->LeftEdge+4;
  dt->prop->TopEdge = scr->TopEdge+2;
  if(dt->decbtn->LeftEdge == dt->incbtn->LeftEdge)
  {
    dt->decbtn->LeftEdge = scr->LeftEdge;
    dt->incbtn->LeftEdge = scr->LeftEdge;
    dt->decbtn->TopEdge = scr->TopEdge+dt->pframe->Height;
    dt->incbtn->TopEdge = dt->decbtn->TopEdge+dt->decbtn->Height;
  }
  else
  {
    dt->decbtn->TopEdge = scr->TopEdge;
    dt->incbtn->TopEdge = scr->TopEdge;
    dt->decbtn->LeftEdge = scr->LeftEdge+dt->pframe->Width;
    dt->incbtn->LeftEdge = dt->decbtn->LeftEdge+dt->decbtn->Width;
  }

  return(NULL);
}


ULONG update(Class *cl,Object *o,Msg msg)
{
  struct opUpdate *updin = (struct opUpdate *)msg;
  struct objectdata *dt = (struct objectdata *)INST_DATA(cl,o);
  struct Gadget *scr = (struct Gadget *)o;
  struct opUpdate upd;
  struct TagItem tag[5];
  ULONG id,top,newtop;

  id = GetTagData(GA_ID,0,updin->opu_AttrList);
  DoMethod((Object *)dt->prop,OM_GET,PGA_Top,&top);
  /* An update message is used for both OM_SET and OM_NOTIFY
     since the messages are so much alike. */
  upd.MethodID = OM_SET;
  upd.opu_AttrList = tag;
  upd.opu_GInfo = updin->opu_GInfo;
  upd.opu_Flags = updin->opu_Flags;
  /*
   Only enter this if its a button update and an interrim message
   Problem: First update message must emulate the gadgetdown message
   */
  if(id>0&&updin->opu_Flags&OPUF_INTERIM)
  {
    /* Delay between first and subsequent updates */
    if(dt->rep==0||dt->rep>4)
    {
      /* Adjust propgadget */
      if(id==DECBTN) newtop = top-1;
      if(id==INCBTN) newtop = top+1;
      tag[0].ti_Tag = PGA_Top; tag[0].ti_Data = newtop;
      tag[1].ti_Tag = TAG_DONE;
      /* Prevent backwards overrun, forwards overrun is prevented
        by propgadget */
      if(newtop!=-1) DoMethodA((Object *)dt->prop,(Msg)&upd);
      /* Initial check to prevent notification messages in case of overrun */
      DoMethod((Object *)dt->prop,OM_GET,PGA_Top,&top);
      /* Delay (only nedded for dt->rep==0) */
      dt->rep++;
    }
    else
    {
      /* Delay in progress */
      dt->rep++;
      return(0);
    }
  }
  /* Only enter if interim message or message from propg */
  if(updin->opu_Flags&OPUF_INTERIM||id==0)
  {
    /* Prevent notification in case of overrun */
    if(id>0&&top!=newtop) return(0);
    /* Notify */
    upd.MethodID = OM_NOTIFY;
    tag[0].ti_Tag = PGA_Top; tag[0].ti_Data = top;
    tag[1].ti_Tag = GA_ID; tag[1].ti_Data = scr->GadgetID;
    tag[2].ti_Tag = TAG_DONE;
    DoMethodA(o,(Msg)&upd);
  }
  return(0);
}


ULONG hittest(Class *cl,Object *o,Msg msg)
{
  struct gpHitTest *test = (struct gpHitTest *)msg;
  struct Gadget *scr = (struct Gadget *)o;
  struct objectdata *dt = (struct objectdata *)INST_DATA(cl,o);
  WORD x = test->gpht_Mouse.X ,y = test->gpht_Mouse.Y ,gx,gy;

  gx = dt->prop->LeftEdge-scr->LeftEdge;
  gy = dt->prop->TopEdge-scr->TopEdge;
  if(x>=gx&&x<=gx+dt->prop->Width&&y>=gy&&y<=gy+dt->prop->Height)
  {
    /* Further tests should be aplied for more complicated gadgets */
    dt->act = (Object *)dt->prop;
    return(GMR_GADGETHIT);
  }
  gx = dt->decbtn->LeftEdge-scr->LeftEdge;
  gy = dt->decbtn->TopEdge-scr->TopEdge;
  if(x>=gx&&x<=gx+dt->decbtn->Width&&y>=gy&&y<=gy+dt->decbtn->Height)
  {
    dt->act = (Object *)dt->decbtn;
    return(GMR_GADGETHIT);
  }
  gx = dt->incbtn->LeftEdge-scr->LeftEdge;
  gy = dt->incbtn->TopEdge-scr->TopEdge;
  if(x>=gx&&x<=gx+dt->incbtn->Width&&y>=gy&&y<=gy+dt->incbtn->Height)
  {
    dt->act = (Object *)dt->incbtn;
    return(GMR_GADGETHIT);
  }
  return(0L);
}

ULONG goactive(Class *cl,Object *o,Msg msg)
{
  struct objectdata *dt = (struct objectdata *)INST_DATA(cl,o);
  struct gpInput *in = (struct gpInput *)msg;
  struct Gadget *act = (struct Gadget *)dt->act, *scr = (struct Gadget *)o;
  ULONG result;
  in->gpi_Mouse.X -= act->LeftEdge-scr->LeftEdge;
  in->gpi_Mouse.Y -= act->TopEdge-scr->TopEdge;
  result = DoMethodA(dt->act,msg);

  return(result);
}

ULONG handleinput(Class *cl,Object *o,Msg msg)
{
  struct objectdata *dt = (struct objectdata *)INST_DATA(cl,o);
  struct gpInput *in = (struct gpInput *)msg;
  struct Gadget *act = (struct Gadget *)dt->act, *scr = (struct Gadget *)o;
  ULONG result,top;

  in->gpi_Mouse.X -= act->LeftEdge-scr->LeftEdge;
  in->gpi_Mouse.Y -= act->TopEdge-scr->TopEdge;
  result = DoMethodA(dt->act,msg);
  if(result)
  {
    if(scr->Activation&GACT_RELVERIFY)
    {
      result |= GMR_VERIFY;
      DoMethod((Object *)dt->prop,OM_GET,PGA_Top,&top);
      *(in->gpi_Termination) = (LONG)top;
    }
    else
    {
      result &= ~GMR_VERIFY;
    }
  }
  return(result);
}


ULONG goinactive(Class *cl,Object *o,Msg msg)
{
  struct objectdata *dt = (struct objectdata *)INST_DATA(cl,o);
  ULONG result;

  #ifdef DEBUG
    DLprintf(console,"Goinactive request..\n");
  #endif
  result = DoMethodA(dt->act,msg);
  dt->act = NULL;
  dt->rep = 0;
  return(result);
}


ULONG render(Class *cl,Object *o,Msg msg)
{
  struct gpRender *rend = (struct gpRender *)msg;
  struct objectdata *dt = INST_DATA(cl,o);
  struct impDraw draw;

  draw.MethodID = IM_DRAW;
  draw.imp_RPort = rend->gpr_RPort;
  draw.imp_Offset.X = 0; draw.imp_Offset.Y = 0;
  draw.imp_State = IDS_NORMAL;
  draw.imp_DrInfo = rend->gpr_GInfo->gi_DrInfo;

  DoMethodA((Object *)dt->pframe,(Msg)&draw);
  DoMethodA((Object *)dt->prop,msg);
  DoMethodA((Object *)dt->decbtn,msg);
  DoMethodA((Object *)dt->incbtn,msg);

  return(1);
}