/* Sample class  for StormC*/

//#include <proto/alib.h>
#include <proto/exec.h>
#include <proto/intuition.h>
#include <proto/graphics.h>
#include <proto/utility.h>
#include <exec/libraries.h>
#include <exec/memory.h>
#include <graphics/gfxmacros.h>
#include <intuition/classes.h>
#include <dos/dos.h>
#include "class.h"
#include "CFglyphi.h"
#ifdef DEBUG
 #include "debug_protos.h"
 extern APTR console;
#endif

Class *initclass(struct classbase *base)
{
  Class *cl;

  if(cl = MakeClass(CFglyphiClassName,IMAGECLASS,NULL,
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
    case IM_DRAW:
      return(draw(cl,o,msg));
    default:
      return(DoSuperMethodA(cl,o,msg));
  }
}

ULONG newobject(Class *cl,Object *o,Msg msg)
{
  ULONG newobj,index = 0;
  struct Image *img;
  struct objectdata *dt;
  struct TagItem *attrs = ((struct opSet *)msg)->ops_AttrList;


  if(newobj = DoSuperMethodA(cl,o,msg))
  {
    dt = (struct objectdata *)INST_DATA(((Class *)o),newobj);
    dt->gtype = GetTagData(CFGI_Type,GLYPH_PDARROW,attrs);
    img = (struct Image *)newobj;
    if(dt->rasbuf = AllocRaster(img->Width,img->Height))
    {
      InitTmpRas(&(dt->tr),dt->rasbuf,img->Width*img->Height/8);
      while(index<MAXVECTORS) dt->vecbuf[index++] = 0;
      InitArea(&(dt->ai),dt->vecbuf,MAXVECTORS);
      return(newobj);
    }
    DoSuperMethod((Class *)o,(Object *)newobj,OM_DISPOSE);
  }
  return(NULL);
}

ULONG dispose(Class *cl,Object *o)
{
  struct objectdata *dt = (struct objectdata *)INST_DATA(cl,o);
  struct Image *img = (struct Image *)o;

  FreeRaster(dt->rasbuf,img->Width,img->Height);
  DoSuperMethod(cl,o,OM_DISPOSE);
  return(NULL);
}

ULONG setattrs(Class *cl,Object *o,Msg msg)
{
  struct opSet *set = (struct opSet *)msg;
  struct TagItem *attrs = set->ops_AttrList;
  struct objectdata *dt = (struct objectdata *)INST_DATA(cl,o);
  struct Image *img = (struct Image *)o;
  ULONG width,height;

  width = GetTagData(IA_Width,NULL,attrs);
  height = GetTagData(IA_Height,NULL,attrs);
  if(width||height)
  {
    FreeRaster(dt->rasbuf,img->Width,img->Height);
    dt->rasbuf = AllocRaster(width,height);
    InitTmpRas(&(dt->tr),dt->rasbuf,width*height/8);
  }
  return(DoSuperMethodA(cl,o,msg));
}


ULONG draw(Class *cl,Object *o,Msg msg)
{
  struct impDraw *draw = (struct impDraw *)msg;
  struct objectdata *dt = (struct objectdata *)INST_DATA(cl,o);
  struct Image *img = (struct Image *)o;
  struct RastPort *rp = draw->imp_RPort;
  UBYTE fgpen = 1,bgpen = 0;
  UWORD *pens = NULL;
  WORD x,y;

  if(draw->imp_DrInfo)
  {
    pens = draw->imp_DrInfo->dri_Pens;
    fgpen = pens[SHINEPEN];
    bgpen = pens[SHADOWPEN];
  }
  switch(dt->gtype)
  {
    case GLYPH_PDARROW:
      rp->AreaInfo = &(dt->ai);
      rp->TmpRas = &(dt->tr);
      SetDrMd(rp,JAM1);
      SetAPen(rp,fgpen);
      SetOPen(rp,bgpen);
      x = img->LeftEdge+draw->imp_Offset.X+img->Width/6;
      y = img->TopEdge+draw->imp_Offset.Y+img->Height/5+1;
      AreaMove(rp,x,y);
      x += img->Width/6*2;
      y += img->Height/5*3;
      AreaDraw(rp,x,y);
      x += img->Width/6*2;
      y = img->TopEdge+draw->imp_Offset.Y+img->Height/5+1;
      AreaDraw(rp,x,y);
      AreaEnd(rp);
      break;
    case GLYPH_TREEMORE:
      SetDrPt(rp,0xcccc);
      Move(rp,img->LeftEdge+img->Width/2,img->TopEdge);
      Draw(rp,img->LeftEdge+img->Width/2,img->TopEdge+img->Height-1);
      Move(rp,img->LeftEdge+img->Width/2,img->TopEdge+img->Height/2);
      Draw(rp,img->LeftEdge+img->Width-1,img->TopEdge+img->Height/2);
      SetDrPt(rp,0xffff);
      break;
    case GLYPH_TREEDONE:
      SetDrPt(rp,0xcccc);
      Move(rp,img->LeftEdge+img->Width/2,img->TopEdge);
      Draw(rp,img->LeftEdge+img->Width/2,img->TopEdge+img->Height/2);
      Draw(rp,img->LeftEdge+img->Width-1,img->TopEdge+img->Height/2);
      SetDrPt(rp,0xffff);
      break;
    case GLYPH_TREEMSUB:
      SetDrPt(rp,0xcccc);
      /* Draw 'more'*/
      Move(rp,img->LeftEdge+img->Width/2,img->TopEdge);
      Draw(rp,img->LeftEdge+img->Width/2,img->TopEdge+img->Height-1);
      Move(rp,img->LeftEdge+img->Width/2,img->TopEdge+img->Height/2);
      Draw(rp,img->LeftEdge+img->Width-1,img->TopEdge+img->Height/2);
      /* Draw box */
      Move(rp,img->LeftEdge+img->Width/4,img->TopEdge+img->Height/4);
      Draw(rp,img->LeftEdge+(img->Width*3)/4,img->TopEdge+img->Height/4);
      Draw(rp,img->LeftEdge+(img->Width*3)/4,img->TopEdge+(img->Height*3)/4);
      Draw(rp,img->LeftEdge+img->Width/4,img->TopEdge+(img->Height*3)/4);
      Draw(rp,img->LeftEdge+img->Width/4,img->TopEdge+img->Height/4);
      SetDrPt(rp,0xffff);
      break;
    case GLYPH_TREEDSUB:
      SetDrPt(rp,0xcccc);
      /* Draw 'done' */
      Move(rp,img->LeftEdge+img->Width/2,img->TopEdge);
      Draw(rp,img->LeftEdge+img->Width/2,img->TopEdge+img->Height/2);
      Draw(rp,img->LeftEdge+img->Width-1,img->TopEdge+img->Height/2);
      /* Draw box */
      Move(rp,img->LeftEdge+img->Width/4,img->TopEdge+img->Height/4);
      Draw(rp,img->LeftEdge+(img->Width*3)/4,img->TopEdge+img->Height/4);
      Draw(rp,img->LeftEdge+(img->Width*3)/4,img->TopEdge+(img->Height*3)/4);
      Draw(rp,img->LeftEdge+img->Width/4,img->TopEdge+(img->Height*3)/4);
      Draw(rp,img->LeftEdge+img->Width/4,img->TopEdge+img->Height/4);
      SetDrPt(rp,0xffff);
      break;
  }

  return(0);
}

