#define DEBUG
#include <debug.h>

#include "private.h"
#include "protos.h"


ULONG __saveds gad_Render(Class *C, struct Gadget *Gad, struct gpRender *Render, ULONG update)
{
  struct GadData *gdata;
  struct RastPort *rp;
  LONG l,left,top,width,height,right,bottom;
  ULONG retval=1;

  gdata=INST_DATA(C, Gad);

  if(Render->MethodID==GM_RENDER)
  {
    rp=Render->gpr_RPort;
    update=Render->gpr_Redraw;
  }
  else
  {
    rp = ObtainGIRPort(Render->gpr_GInfo);
  }

  if(rp)
  {
    if(update == GREDRAW_UPDATE)
    {
      if(gdata->ActivePen != gdata->LastActivePen)
      {
        i_RenderColorBox(C, Gad, Render->gpr_GInfo, rp,gdata->LastActivePen);

        gdata->LastActivePen=gdata->ActivePen;
      }
      i_RenderColorBox(C, Gad, Render->gpr_GInfo, rp,gdata->ActivePen);
    }
    else
    {
      SetDrMd(rp,JAM1);
      SetDrPt(rp,65535);
      
      left   =Gad->LeftEdge;
      top    =Gad->TopEdge;
      width  =Gad->Width;
      height =Gad->Height;
      
      right =left + width  -1;
      bottom=top  + height -1;
      
      SetAPen(rp,0);
      SetBPen(rp,1);
      SetDrMd(rp,JAM2);

      DrawImage(rp,gdata->Bevel,0,0);
/*  
      SetAttrs(gdata->Pattern,PAT_RastPort,    rp,
                              PAT_DitherAmt,   gdata->ActivePen * 256,
                              TAG_DONE);
  */
//      RectFill(rp,left,top,right,bottom);      
      for(l=0;l<gdata->Pens;l++)
      {
        i_RenderColorBox(C, Gad, Render->gpr_GInfo,rp,l);
      }
    }
    
    if (Render->MethodID != GM_RENDER)
      ReleaseGIRPort(rp);  
  }
  return(retval);
}

void i_RenderColorBox(Class *C, struct Gadget *Gad, struct GadgetInfo *gi, struct RastPort *rp, ULONG Pen)
{
  struct DrawInfo *di;
  struct GadData *gdata;
  ULONG row,col,
          left,top,
          width,height,
          bottom,right;

  gdata=INST_DATA(C, Gad);
  
  di=gi->gi_DrInfo;
  
  col=Pen % gdata->Cols;
  row=Pen / gdata->Cols;
  
  left    =gdata->Col[col];
  right   =gdata->Col[col+1]-1;
  width   =right-left;
  top     =gdata->Row[row];
  bottom  =gdata->Row[row+1]-1;
  height  =bottom-top;

#define SIZE (0)
  
  
  if(Pen==gdata->ActivePen && (((Gad->Flags & GFLG_SELECTED) && gdata->MouseMode) || gdata->ShowSelected))
  {
    if(gdata->EditMode)
    {
//      SetDrPt(rp,0x0f0f);
      
/*      SetAPen(rp, di->dri_Pens[BACKGROUNDPEN]);

      Move(rp,left,   bottom);
      Draw(rp,left,   top);
      Draw(rp,right,  top);
      Draw(rp,right,  bottom);
      Draw(rp,left,   bottom);
      
      Move(rp,left+1,   bottom-1);
      Draw(rp,left+1,   top+1);
      Draw(rp,right-1,  top+1);
      Draw(rp,right-1,  bottom-1);
      Draw(rp,left+1,   bottom-1);
*/
      SetDrPt(rp,0xF0F0);
    }

    SetDrMd(rp,JAM2);

    SetBPen(rp, di->dri_Pens[BACKGROUNDPEN]);
    
    SetAPen(rp, di->dri_Pens[SHADOWPEN]);
    Move(rp,left,bottom);
    Draw(rp,left,top);
    Draw(rp,right,top);
    
    SetAPen(rp, di->dri_Pens[SHINEPEN]);
    Draw(rp,right,bottom);
    Draw(rp,left,bottom);
    
    SetAPen(rp, di->dri_Pens[SHADOWPEN]);
    Move(rp,left+1,bottom-1);
    Draw(rp,left+1,top+1);
    Draw(rp,right-1,top+1);
    
    SetAPen(rp, di->dri_Pens[SHINEPEN]);
    Draw(rp,right-1,  bottom-1);
    Draw(rp,left+1,   bottom-1);

    SetDrPt(rp,0xFfff);

    SetAPen(rp, di->dri_Pens[BACKGROUNDPEN]);
    Move(rp,left+2,bottom-2);
    Draw(rp,left+2,top+2);
    Draw(rp,right-2,top+2);
    Draw(rp,right-2,  bottom-2);
    Draw(rp,left+2,   bottom-2);



    top+=3;
    left+=3;
    right-=3;
    bottom-=3;
  }
  else
  {
    SetAPen(rp, di->dri_Pens[BACKGROUNDPEN]);
    Move(rp,left,bottom);
    Draw(rp,left,top);
    Draw(rp,right,top);
    Draw(rp,right,bottom);
    Draw(rp,left,bottom);
/*

    Move(rp,left+1,bottom-1);
    Draw(rp,left+1,top+1);
    Draw(rp,right-1,top+1);
    Draw(rp,right-1,  bottom-1);
    Draw(rp,left+1,   bottom-1);*/

    top+=1;
    left+=1;
    right-=1;
    bottom-=1;
  }

  width   =right-left+1;
  height  =bottom-top+1;
  
  if(CyberGfxBase && GetBitMapAttr(gi->gi_Screen->RastPort.BitMap, BMA_DEPTH )>8)
  {
    ULONG argb;
    
    argb= ((gdata->Palette[Pen].R & 0xff000000) >> 8) |
          ((gdata->Palette[Pen].G & 0xff000000) >> 16) |
          ((gdata->Palette[Pen].B & 0xff000000) >> 24);

    
    FillPixelArray(rp, left, top, width, height, argb);
  }
  else
  {
    ULONG p;
    p=FindColor(gi->gi_Screen->ViewPort.ColorMap, 
                        gdata->Palette[Pen].R,
                        gdata->Palette[Pen].G,
                        gdata->Palette[Pen].B,
                        -1);
    
    SetAPen(rp, p);
    RectFill(rp,left, top, right, bottom);
  }

  if(gdata->Disabled)
  {
    gui_GhostRect(rp, gi->gi_DrInfo->dri_Pens[TEXTPEN], left, top, right, bottom);
  }
  
  /*  
  SetAttrs(gdata->Pattern,PAT_RastPort,    rp,
                          PAT_DitherAmt,   gdata->ActivePen * 256,
                          TAG_DONE);
*/

}

