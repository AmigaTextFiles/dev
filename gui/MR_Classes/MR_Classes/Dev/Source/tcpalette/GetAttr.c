#define DEBUG
#include <debug.h>

#include "private.h"
#include "protos.h"

ULONG Expand(ULONG Value, ULONG Precision);

ULONG __saveds gad_GetAttr(Class *C, struct Gadget *Gad, struct opGet *Get)
{
  ULONG retval=1;
  struct GadData *gdata;
  ULONG *data;

  gdata=INST_DATA(C, Gad);

//  DKP("SetAttrs()\n");
  
  data=Get->opg_Storage;
  
  switch(Get->opg_AttrID)
  {
    case TCPALETTE_SelectedColor:
      *data=(ULONG)gdata->ActivePen;
      break;
      
    case TCPALETTE_RGBPalette:
      {
        ULONG l;
        struct TCPaletteRGB *rgb;
        
        rgb=(APTR)data;
        
        for(l=0;l<gdata->Pens;l++)
        {
          rgb[l]=gdata->Palette[l];
        }
      }
      break;
      
     case TCPALETTE_LRGBPalette:
      {
        ULONG l;
        
        for(l=0;l<gdata->Pens;l++)
        {
          data[l]=PACKRGB(gdata->Palette[l]);
        }
      }
      break;
      
    case TCPALETTE_SelectedRGB:
      {  
        struct TCPaletteRGB *rgb;
        
        rgb=(APTR)data;
        
        *rgb=gdata->Palette[gdata->ActivePen];
      }
      break;
      
    case TCPALETTE_SelectedLRGB:
      { 
        data[0]=PACKRGB(gdata->Palette[gdata->ActivePen]);
      }
      break;
      
     case TCPALETTE_NumColors:
      *data=gdata->Pens;
      break;
      
    case TCPALETTE_ShowSelected:
      *data=gdata->ShowSelected;
      break;
      
    case TCPALETTE_SelectedRed:
      *data=gdata->Palette[gdata->ActivePen].R>>(32-gdata->Precision);
      break;
      
    case TCPALETTE_SelectedGreen:
      *data=gdata->Palette[gdata->ActivePen].G>>(32-gdata->Precision);
      break;        

    case TCPALETTE_SelectedBlue:
      *data=gdata->Palette[gdata->ActivePen].B>>(32-gdata->Precision);
      break;
      
    case TCPALETTE_Precision:
      *data=gdata->Precision;
      break;

    case TCPALETTE_Orientation:
      *data=gdata->Orientation;
      break;
      
    case TCPALETTE_NoUndo:
      *data=(gdata->UndoLength?0:1); // returns 0 if there is undo
      break;
      
    default:
      retval=DoSuperMethodA(C, (APTR)Gad, (APTR)Get);
  }

  return(retval);
}

