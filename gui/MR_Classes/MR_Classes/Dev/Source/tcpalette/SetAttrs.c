#define DEBUG
#include <debug.h>

#include "private.h"
#include "protos.h"

ULONG Expand(ULONG Value, ULONG Precision);


ULONG Redraw[]={0, GREDRAW_UPDATE, GREDRAW_REDRAW};

ULONG __saveds gad_SetAttrs(Class *C, struct Gadget *Gad, struct opSet *Set)
{
  struct TagItem *tag,*tstate;
  ULONG retval=0,data;
  struct GadData *gdata;
  ULONG redraw=0, update=0;
  

  gdata=INST_DATA(C, Gad);

//  DKP("SetAttrs()\n");
  
  ProcessTagList(Set->ops_AttrList,tag,tstate)
  {
    data=tag->ti_Data;
    switch(tag->ti_Tag)
    {
      case TCPALETTE_SelectedColor:
        data=min(data,gdata->Pens);
        data=max(0,data);
        gdata->ActivePen=data;
        update=1;
        
        break;
        
      case TCPALETTE_RGBPalette:
        {
          ULONG l;
          struct TCPaletteRGB *rgb;
          
          rgb=(APTR)data;
          
          gdata->UndoLength=0;
          gdata->UndoPen=-1;
          
          for(l=0;l<gdata->Pens;l++)
          {
            gdata->Palette[l]=rgb[l];
          }
          redraw=1;
        }
        break;

      case TCPALETTE_LRGBPalette:
        {
          ULONG l;
          struct TCPaletteLRGB *rgb;
          
          rgb=(APTR)data;
          
          gdata->UndoLength=0;
          gdata->UndoPen=-1;

          for(l=0;l<gdata->Pens;l++)
          {
            gdata->Palette[l].R=rgb[l].R * 0x01010101;
            gdata->Palette[l].G=rgb[l].G * 0x01010101;
            gdata->Palette[l].B=rgb[l].B * 0x01010101;
          }
          redraw=1;
        }
        break;


      case TCPALETTE_SelectedRGB:
          i_StoreUndoIfNeeded(C, Gad, (Msg)Set);
          gdata->Palette[gdata->ActivePen]=*((struct TCPaletteRGB *)data);
          update=1;
        break;
        
      case TCPALETTE_SelectedLRGB:
        { 
          struct TCPaletteLRGB *rgb;


          i_StoreUndoIfNeeded(C, Gad, (Msg)Set);
          rgb=(APTR)&data;
          
          gdata->Palette[gdata->ActivePen].R=rgb->R * 0x01010101;
          gdata->Palette[gdata->ActivePen].G=rgb->G * 0x01010101;
          gdata->Palette[gdata->ActivePen].B=rgb->B * 0x01010101;
          update=1;
        }
        break;

      case TCPALETTE_NumColors:
        gdata->Pens=min(data,256);
        gdata->Pens=max(1,gdata->Pens);
        redraw=1;
        break;
        
      case TCPALETTE_ShowSelected:
        gdata->ShowSelected=(data?1:0);
        update=1;
        break;
        
      case TCPALETTE_SelectedRed:
        i_StoreUndoIfNeeded(C, Gad, (Msg)Set);
        gdata->Palette[gdata->ActivePen].R=Expand(data, gdata->Precision);
        update=1;
        break;
      case TCPALETTE_SelectedGreen:
        i_StoreUndoIfNeeded(C, Gad, (Msg)Set);
        gdata->Palette[gdata->ActivePen].G=Expand(data, gdata->Precision);
        update=1;
        break;        
      case TCPALETTE_SelectedBlue:
        i_StoreUndoIfNeeded(C, Gad, (Msg)Set);
        gdata->Palette[gdata->ActivePen].B=Expand(data, gdata->Precision);
        update=1;
        break;
      case TCPALETTE_Precision:
        gdata->Precision=data;
        break;
      
      case TCPALETTE_Orientation:
        gdata->Orientation=data;
        break;
        
      case TCPALETTE_EditMode:
        gdata->EditMode=data;
        gdata->EMPen=gdata->ActivePen;
        update=1;
        break;
      
      case TCPALETTE_Undo:
        i_GetUndo(C, Gad, (Msg)Set);
        redraw=1;
        break;
      
      case GA_Disabled:
        gdata->Disabled=data;
        redraw=1;
        break;
    }
  }
  
  if(redraw | update)
  {
    struct RastPort *rp;
          
    if(rp=ObtainGIRPort(Set->ops_GInfo))
    {
      DoMethod((Object *)Gad,GM_RENDER,Set->ops_GInfo,rp,(redraw?GREDRAW_REDRAW:GREDRAW_UPDATE));
      ReleaseGIRPort(rp);
    }
    
    if(redraw)
    {
      i_Notify(C,Gad,(Msg)Set,0);
    }
  }
  
  return(retval);
}

ULONG Expand(ULONG Value, ULONG Precision)
{
  ULONG rv=0;
  LONG l;

  Value&=((1<<Precision)-1);
  Value<<=(32-Precision);
  for(l=0;l<32;l+=Precision)
  {
    rv=Value | (rv >> Precision);
  }
  rv=Value | (rv >> Precision);

  return(rv);
}
