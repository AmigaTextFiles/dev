/* Sample class  for StormC*/

#include <clib/alib_protos.h>
#include <proto/exec.h>
#include <proto/intuition.h>
#include <proto/graphics.h>
#include <proto/utility.h>
#include <exec/libraries.h>
#include <intuition/classes.h>
#include <intuition/imageclass.h>
#include <intuition/gadgetclass.h>
#include <dos/dos.h>
#include "class.h"
#include "CFpumbutton.h"
#include "CFbutton.h"
#include "CFtexti.h"
#include "CFglyphi.h"
#ifdef DEBUG
 #include "debug_protos.h"
 extern APTR console;
#endif

Class *initclass(struct classbase *base)
{
  Class *cl;

  if(cl = MakeClass(CFpumbuttonClassName,CFbuttonClassName,NULL,
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
    case GM_GOACTIVE:
      return(goactive(cl,o,msg));
    case GM_HANDLEINPUT:
      return(handleinput(cl,o,msg));
    case GM_GOINACTIVE:
      return(goinactive(cl,o,msg));
    case GM_RENDER:
      DoSuperMethodA(cl,o,msg);
      return(render(cl,o,msg));
    default:
      return(DoSuperMethodA(cl,o,msg));
  }
}

ULONG newobject(Class *cl,Object *o,Msg msg)
{
  ULONG newobj,count,dri;
  struct Gadget *btn;
  struct Image *img;
  struct objectdata *dt;
  struct TagItem *intags = ((struct opSet *)msg)->ops_AttrList, addtags[10];
  UWORD *pens;

//  if(!(dri = GetTagData(GA_DrawInfo,NULL,intags))) return(NULL);
  /* Make gadget */
  if(newobj = DoSuperMethodA(cl,o,msg))
  {
    #ifdef DEBUG
    DLprintf(console,"New Object\n");
    #endif
    btn = (struct Gadget *)newobj;
    dt = (struct objectdata *)INST_DATA(((Class *)o),newobj); /* Screwed up, in OM_NEW */
    /* Adjust gadget values*/
    dt->sellist = NULL;
    dt->labels = (char **)GetTagData(CFPU_Labels,NULL,intags);
    dt->active = GetTagData(CFPU_Active,0,intags);
    count = 0;
    while(dt->labels[count]) count++;
    if(dt->active >= count) dt->active = 0;
    dt->entries = count;
    img = (struct Image *)NewObject(NULL,CFglyphiClassName,
    		IA_Top,0,IA_Left,0,IA_Width,22,IA_Height,12,
    		TAG_DONE);
    addtags[0].ti_Tag = GA_Height; addtags[0].ti_Data = 14;
    addtags[1].ti_Tag = GA_Text; addtags[1].ti_Data = (ULONG)dt->labels[dt->active];
    addtags[2].ti_Tag = GA_Image; addtags[2].ti_Data = (ULONG)img;
    addtags[3].ti_Tag = CFBU_Layout; addtags[3].ti_Data = LAYOUT_TXTLEFT|LAYOUT_IMGLEFT;
    addtags[4].ti_Tag = TAG_DONE;
    DoSuperMethod(cl,(Object *)newobj,OM_SET,addtags,NULL);
    #ifdef DEBUG
    DLprintf(console,"Attributes set, returning.\n");
    #endif
  }
  return(newobj);
}

ULONG dispose(Class *cl,Object *o)
{
  struct objectdata *dt = (struct objectdata *)INST_DATA(cl,o);

  DoSuperMethod(cl,o,OM_DISPOSE);

  return(NULL);
}


ULONG goactive(Class *cl,Object *o,Msg msg)
{
  struct gpInput *input = (struct gpInput *)msg;
  struct Gadget *btn = (struct Gadget *)o;
  struct GadgetInfo *gi = input->gpi_GInfo;
  struct RastPort *rp;
  struct objectdata *dt = (struct objectdata *)INST_DATA(cl,o);
  UWORD *pens = gi->gi_DrInfo->dri_Pens;
  struct gpRender rend;
  struct impDraw draw;
  struct Image *tmpimg;
  UWORD index;

  if(dt->actwin = OpenWindowTags(NULL,
  		WA_Left, gi->gi_Window->LeftEdge+btn->LeftEdge+20,
  		WA_Top, gi->gi_Window->TopEdge+btn->TopEdge+btn->Height,
  		WA_Width, btn->Width-20,
  		WA_Height, dt->entries*(gi->gi_Window->RPort->TxHeight+1)+4,
  		WA_CustomScreen, gi->gi_Screen,
  		WA_IDCMP, IDCMP_CHANGEWINDOW,
  		WA_Borderless, TRUE,
  		WA_SimpleRefresh, TRUE,
  		WA_Activate, FALSE,
  		TAG_DONE))
  {
// Fontchange recognition unimplemented!
//    /* In case of fontchange, change size of window acording to new font
//       height. Kind of a workaround, but there isn't really an easy way
//       to do this.. */
//    ChangeWindowBox(dt->actwin,dt->actwin->LeftEdge,dt->actwin->TopEdge,
//    		dt->actwin->Width,dt->entries*(dt->actwin->RPort->TxHeight+2)+4);
    rp = dt->actwin->RPort;
    SetRast(rp,pens[SHINEPEN]);
    SetAPen(rp,pens[SHADOWPEN]);
    Move(rp,0,0);
    Draw(rp,dt->actwin->Width-1,0);
    Move(rp,0,0);
    Draw(rp,0,dt->actwin->Height);
    Move(rp,1,0);
    Draw(rp,1,dt->actwin->Height);
    Move(rp,dt->actwin->Width-2,0);
    Draw(rp,dt->actwin->Width-2,dt->actwin->Height);
    Move(rp,dt->actwin->Width-1,0);
    Draw(rp,dt->actwin->Width-1,dt->actwin->Height);
    Move(rp,0,dt->actwin->Height-1);
    Draw(rp,dt->actwin->Width,dt->actwin->Height-1);
    DoSuperMethodA(cl,o,msg);
    rend.MethodID = GM_RENDER;
    rend.gpr_GInfo = gi;
    rend.gpr_RPort = ObtainGIRPort(gi);
    rend.gpr_Redraw = GREDRAW_REDRAW;
    render(cl,o,(Msg)&rend);
    ReleaseGIRPort(rend.gpr_RPort);
    /* Setup text images */
    dt->sellist = (struct Image *)NewObject(NULL,CFtextiClassName,
    	IA_Left, 4, IA_Top, 2,
    	IA_Width, dt->actwin->Width-8,
    	IA_Data, dt->labels[0],
    	IA_FGPen, pens[TEXTPEN], IA_BGPen, pens[SHINEPEN],
    	TAG_DONE);
    tmpimg = dt->sellist;
    index = 1;
    while(dt->labels[index])
    {
      tmpimg->NextImage = (struct Image *)NewObject(NULL,CFtextiClassName,
      		IA_Left, 4, IA_Top, index*(dt->actwin->RPort->TxHeight+1)+2,
      		IA_Width, dt->actwin->Width-8,
      		IA_Data, dt->labels[index],
    		IA_FGPen, pens[TEXTPEN], IA_BGPen, pens[SHINEPEN],
      		TAG_DONE);
      tmpimg = tmpimg->NextImage;
      index++;
    }
    tmpimg->NextImage = NULL;  /* For safetys sake */
    tmpimg = dt->sellist;
    index = 0;
    draw.MethodID = IM_DRAW;
    draw.imp_RPort = dt->actwin->RPort;
    draw.imp_Offset.X = 0; draw.imp_Offset.Y = 0;
    draw.imp_State = IDS_NORMAL;
    draw.imp_DrInfo = NULL;
    while(tmpimg)
    {
      DoMethodA((Object *)tmpimg,(Msg)&draw);
      tmpimg = tmpimg->NextImage;
      index++;
    };
    dt->selected = NULL;
    return(GMR_MEACTIVE);
  }
  return(GMR_NOREUSE);
}


ULONG handleinput(Class *cl,Object *o,Msg msg)
{
  struct gpInput *input = (struct gpInput *)msg;
  struct objectdata *dt = (struct objectdata *)INST_DATA(cl,o);
  struct Image *img;
  struct TagItem tag[5];
  struct impDraw draw;
  struct impHitTest htst;
  WORD count = 0,x,y;
  BOOL result;

  if(input->gpi_IEvent->ie_Class == IECLASS_RAWMOUSE)
  {
    htst.MethodID = IM_HITTEST;
    x = input->gpi_Mouse.X-22;
    y = input->gpi_Mouse.Y-((struct Gadget *)o)->Height;
    htst.imp_Point.X = x;
    htst.imp_Point.Y = y;
    draw.MethodID = IM_DRAW;
    draw.imp_RPort = dt->actwin->RPort;
    draw.imp_Offset.X = 0; draw.imp_Offset.Y = 0;
    draw.imp_DrInfo = NULL;
    if(x>0 && x<dt->actwin->Width && y>0 && y<dt->actwin->Height)
    {
      img = dt->sellist;
      while(img)
      {
        if(result = DoMethodA((Object *)img,(Msg)&htst))
        {
          if(img!=dt->selected)
          {
            draw.imp_State = IDS_NORMAL;
            DoMethodA((Object *)dt->selected,(Msg)&draw);
            draw.imp_State = IDS_SELECTED;
            DoMethodA((Object *)img,(Msg)&draw);
            dt->selected = img;
          }
          if(input->gpi_IEvent->ie_Code == SELECTUP)
          {
            dt->active = count;
            tag[0].ti_Tag = GA_Text; tag[0].ti_Data = (ULONG)dt->labels[dt->active];
            tag[1].ti_Tag = TAG_DONE;
            DoSuperMethod(cl,o,OM_SET,tag,NULL);
            *input->gpi_Termination = (LONG)count;
            return(GMR_NOREUSE|GMR_VERIFY);
          }
          return(GMR_MEACTIVE);
        } /* if result */
        img = img->NextImage;
        count++;
      } /* while(img) */
    } /* if not outside */
    if(input->gpi_IEvent->ie_Code == SELECTUP) return(GMR_NOREUSE);
    if(dt->selected)
    {
      draw.imp_State = IDS_NORMAL;
      DoMethodA((Object *)dt->selected,(Msg)&draw);
      dt->selected = NULL;
    }
  }
  return(GMR_MEACTIVE);
}


ULONG goinactive(Class *cl,Object *o,Msg msg)
{
  struct gpGoInactive *gin = (struct gpGoInactive *)msg;
  struct objectdata *dt = (struct objectdata *)INST_DATA(cl,o);
  struct gpRender rend;
  struct Image *tmpimg;

  CloseWindow(dt->actwin);
  DoSuperMethodA(cl,o,msg);
  rend.MethodID = GM_RENDER;
  rend.gpr_GInfo = gin->gpgi_GInfo;
  rend.gpr_RPort = ObtainGIRPort(gin->gpgi_GInfo);
  rend.gpr_Redraw = GREDRAW_REDRAW;
  render(cl,o,(Msg)&rend);
  ReleaseGIRPort(rend.gpr_RPort);
  tmpimg = dt->sellist->NextImage;
  do
  {
    DisposeObject(dt->sellist);
    dt->sellist = tmpimg;
    tmpimg = tmpimg->NextImage;
  }
  while(dt->sellist);

  return(0);
}


ULONG render(Class *cl,Object *o,Msg msg)
{
  struct Gadget *btn = (struct Gadget *)o;
  struct gpRender *rend = (struct gpRender *)msg;
  struct RastPort *rp = (struct RastPort *)rend->gpr_RPort;
  UWORD *pens = rend->gpr_GInfo->gi_DrInfo->dri_Pens;
  UWORD x = btn->LeftEdge, y = btn->TopEdge;

  x += 8; y += 4;
  SetDrMd(rp,JAM1);
  SetAPen(rp,pens[SHADOWPEN]);
  /* Draw seperator */
  x = btn->LeftEdge + 22; y = btn->TopEdge + 2; Move(rp,x,y);
  y += btn->Height - 5; Draw(rp,x,y);
  x++; Move(rp,x,y); SetAPen(rp,pens[SHINEPEN]);
  y = btn->TopEdge + 2; Draw(rp,x,y);

  return(0);
}