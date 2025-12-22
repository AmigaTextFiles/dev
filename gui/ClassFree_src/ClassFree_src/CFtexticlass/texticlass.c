/* Sample class  for StormC*/

#include <clib/alib_protos.h>
#include <clib/graphics_protos.h>
#include <clib/intuition_protos.h>
#include <clib/utility_protos.h>
#include <exec/libraries.h>
#include <intuition/classes.h>
#include <intuition/imageclass.h>
#include <dos/dos.h>
#include <string.h>
#include "class.h"
#include "CFtexti.h"

Class *initclass(struct classbase *base)
{
  Class *cl;

  if(cl = MakeClass(CFtextiClassName,IMAGECLASS,NULL,
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
    {
      struct TagItem *attrs = ((struct opSet *)msg)->ops_AttrList;
      struct objectdata *dt;
      struct Image *img;
      UWORD *pens;

      if(img = (struct Image *)DoSuperMethodA(cl,o,msg))
      {
        dt = (struct objectdata *)INST_DATA(((Class *)o),img);
        dt->flags = TXIF_LAYOUT;
        if(GetTagData(IA_Outline,TRUE,attrs)) dt->flags |= TXIF_EDGES;
        if(GetTagData(CFTI_Redraw,TRUE,attrs)) dt->flags |=TXIF_REDRAW;
        dt->flags |= GetTagData(CFTI_PosFlags,TIPOS_LEFT,attrs);
      }
      return((ULONG)img);
    }
    case OM_SET:
    {
      struct objectdata *dt = (struct objectdata *)INST_DATA(cl,o);

      dt->flags |= TXIF_LAYOUT;
      return(DoSuperMethodA(cl,o,msg));
    }
    case IM_HITTEST:
    {
      struct Image *img = (struct Image *)o;
      WORD x = ((struct impHitTest *)msg)->imp_Point.X,
           y = ((struct impHitTest *)msg)->imp_Point.Y;
      /* The width/height bug strikes yet again */
      if(x<img->LeftEdge||x>(img->LeftEdge+img->Width-1)||
         y<img->TopEdge||y>(img->TopEdge+img->Height-1)) return(FALSE);
      else return(TRUE);
    }
    case IM_DRAW:
    {
      struct impDraw *id = (struct impDraw *)msg;
      struct Image *img = (struct Image *)o;
      struct objectdata *dt = (struct objectdata *)INST_DATA(cl,o);
      struct RastPort *rp = id->imp_RPort;
      char *text;
      UBYTE fgpen = img->PlanePick,bgpen = img->PlaneOnOff, tmp;
      ULONG maxlen;
      UWORD *pens;
      struct TextExtent te;

      text = (char *)img->ImageData;
      if(dt->flags&TXIF_LAYOUT)
      {
        img->Height = rp->TxHeight;
        dt->xmin = img->LeftEdge;
        dt->ymin = img->TopEdge;
        dt->txty = dt->ymin+rp->TxBaseline;
        if(dt->flags&TXIF_EDGES)
        {
          img->Height++; dt->txty++;
        }
        /* IMPORTANT! Next time remember that Width and Height
          counts pixel 0, so just adding them will make the box
          one pixel wider than it really should be.
          Remeber to subtract 1 next time!!!! Grrrr!   */
        dt->xmax = dt->xmin+img->Width-1;
        dt->ymax = dt->ymin+img->Height-1;
        dt->len = strlen(text);
        maxlen = TextFit(rp,text,dt->len,&te,NULL,1,img->Width-4,img->Height);
        if(dt->len>maxlen) dt->len = maxlen;
        if(dt->flags&TIPOS_LEFT) dt->txtx = dt->xmin+2;
        /* Again we need to adjust!! */
        else if(dt->flags&TIPOS_RIGHT) dt->txtx = dt->xmin +
        	img->Width - TextLength(rp,text,dt->len) - 2;
        /* The rounding down of / should adjust.. maybe.. */
        else dt->txtx = dt->xmin + img->Width/2 - TextLength(rp,text,dt->len)/2;
        dt->flags &= ~TXIF_LAYOUT;
      }
      if(id->imp_State&IDS_SELECTED)
      {
        tmp = fgpen;
        fgpen = bgpen;
        bgpen = tmp;
      }
      if(id->imp_DrInfo)
      {
        pens = id->imp_DrInfo->dri_Pens;
        if(id->imp_State == IDS_NORMAL)
        {
          fgpen = pens[TEXTPEN];
          bgpen = pens[BACKGROUNDPEN];
        }
        else
        {
          fgpen = pens[FILLTEXTPEN];
          bgpen = pens[FILLPEN];
        }
      }
      SetDrMd(rp,JAM1);
      SetAPen(rp,bgpen);
      if(dt->flags&TXIF_REDRAW)
      {
        BltPattern(rp,NULL,dt->xmin+id->imp_Offset.X,
        		 dt->ymin+id->imp_Offset.Y,
        		 dt->xmax+id->imp_Offset.X,
        		 dt->ymax+id->imp_Offset.Y,NULL);
      }
      SetAPen(rp,fgpen);
      Move(rp,dt->txtx+id->imp_Offset.X,dt->txty+id->imp_Offset.Y);
      Text(rp,text,dt->len);

      return(1);
    }
    default:
      return(DoSuperMethodA(cl,o,msg));
  }
}

