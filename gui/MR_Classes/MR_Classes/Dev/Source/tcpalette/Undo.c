#define DEBUG
#include <debug.h>

#include "private.h"
#include "protos.h"

#include <string.h>

LONG i_StoreUndoIfNeeded(Class *C, struct Gadget *Gad, Msg M)
{
  struct GadData *gdata;
  
  gdata=INST_DATA(C, Gad);
  
  if(gdata->UndoPen != gdata->ActivePen)
  {
    //DKP("Changing Undopen\n");
    gdata->UndoPenSaved=0;
    gdata->UndoPen=gdata->ActivePen;
    gdata->UndoPenRGB=gdata->Palette[gdata->ActivePen];
  }
  
  if(memcmp(&gdata->Palette[gdata->ActivePen], &gdata->UndoPenRGB, sizeof(gdata->UndoPenRGB)) &&
     (gdata->UndoPenSaved==0))
  {
    //DKP("Adding Undo\n");
    gdata->UndoPenSaved=1;
    i_AddUndo(gdata, gdata->ActivePen, &gdata->UndoPenRGB, 0);
    i_NotifyUndo(C,Gad,M,0);
  }
  return(1);
}


LONG i_AddUndo(struct GadData *gdata, ULONG Pen, struct TCPaletteRGB *RGB, ULONG Linked)
{
  UBYTE x;

  //DKP("i_AddUndo Pen=%ld Linked=%ld\n",Pen,Linked);

  x=gdata->UndoStart;

  gdata->UndoStart++;
  
  if(gdata->UndoLength<255)
  {
    gdata->UndoLength++;
  }

  if(RGB)    
    gdata->UndoPalette[x]=*RGB;
  else
    gdata->UndoPalette[x]=gdata->Palette[Pen];
    
  gdata->UndoLinked[x]=Linked;
  gdata->UndoPenNumber[x]=Pen;
  
  return(1);
}

LONG i_GetUndo(Class *C, struct Gadget *Gad, Msg M)
{
  struct GadData *gdata;
  UBYTE x,go;
  
  gdata=INST_DATA(C, Gad);

  gdata->UndoPen=-1;

  if(gdata->UndoLength)
  {
    x=gdata->UndoStart-1;
    do 
    {
      go=gdata->UndoLinked[x];
      gdata->Palette[gdata->UndoPenNumber[x]]=gdata->UndoPalette[x];
      gdata->UndoLinked[x]=0;
      gdata->UndoLength--;
      x--;
    } while(go);
    gdata->UndoStart=x+1;
  }
  
  i_NotifyUndo(C,Gad,M,0);  
  
  return(1);
}
