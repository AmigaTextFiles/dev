#define DEBUG
#include <debug.h>

#include "private.h"
#include "protos.h"

// GM_LAYOUT
ULONG __saveds gad_Layout(Class *C, struct Gadget *Gad, struct gpLayout *layout)
{
  struct GadData *gdata;
  LONG rows,cols,l,topedge,leftedge,width,height;
  BOOL swap=0;
  
  
  float cfloat,aspect;

  gdata=INST_DATA(C, Gad);

//  DKP("GM_LAYOUT\n");
// GadgetInfo
  SetAttrs(gdata->Bevel, IA_Left,       Gad->LeftEdge,
                         IA_Top,        Gad->TopEdge,
                         IA_Width,      Gad->Width,
                         IA_Height,     Gad->Height,
                         BEVEL_ColorMap,layout->gpl_GInfo->gi_Screen->ViewPort.ColorMap,
                         TAG_DONE);

  GetAttr(BEVEL_InnerTop,     gdata->Bevel, &topedge);
  GetAttr(BEVEL_InnerLeft,    gdata->Bevel, &leftedge);
  GetAttr(BEVEL_InnerWidth,   gdata->Bevel, &width);
  GetAttr(BEVEL_InnerHeight,  gdata->Bevel, &height);

  if(width>0 && height>0)
  {
    aspect=((float)height / (float)width);
    
    if(aspect<1)
    { 
      aspect=((float)width / (float)height);
      swap=1;
    }
    
//    DKP("  aspect %ld\n",(ULONG)(aspect*1000));
    
    rows=sqrt(gdata->Pens * aspect) + .5;

    if(rows<1) rows=1;
    if(rows>gdata->Pens) rows=gdata->Pens;
    
//    DKP("  rows=%ld\n",rows);
    
    cfloat=gdata->Pens / rows;
    cols=cfloat;
    
    while(rows>1 && (cfloat * rows)!=gdata->Pens)
    {
      rows--;
      cfloat=gdata->Pens / rows;
      cols=cfloat;
//      DKP("   testing - rows %ld cfloat %lf cols=%ld\n",rows, cfloat, cols);
    }

//    DKP("  cols=%ld\n",cols);
  
    if(swap)
    {
      gdata->Rows = cols;
      gdata->Cols = rows;
      
      rows=gdata->Rows;
      cols=gdata->Cols;      
    }    
    else
    {
      gdata->Rows = rows;
      gdata->Cols = cols;
    }

    for(l=0;l<=rows;l++)
    {
      gdata->Row[l]=(LONG)height * l / (rows) + topedge;
    }

    for(l=0;l<=cols;l++)
    {
      gdata->Col[l]=(LONG)width * l / (cols)  + leftedge;
    }
  }
  else
  {
    gdata->Rows=gdata->Cols=0;
  }
  
  if(layout->gpl_Initial)
  {
    i_Notify(C,Gad,layout,0);
  }
  
  return(1);
}
