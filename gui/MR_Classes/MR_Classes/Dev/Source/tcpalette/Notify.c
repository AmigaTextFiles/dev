
#define DEBUG
#include <debug.h>

#include "private.h"
#include "protos.h"

ULONG __saveds i_DoNotify(Class *C, struct Gadget *Gad, Msg M, ULONG Flags, Tag Tags, ...);

ULONG i_Notify(Class *C, struct Gadget *Gad, Msg M, ULONG Flags)
{
  struct GadData *gdata;

  gdata=INST_DATA(C, Gad);  
  
  return(i_DoNotify(C, Gad, M, Flags, 
                      GA_ID,                            Gad->GadgetID,
                      TCPALETTE_NumColors,              gdata->Pens,
                      TCPALETTE_SelectedColor,          gdata->ActivePen,
                      TCPALETTE_SelectedLRGB,           PACKRGB(gdata->Palette[gdata->ActivePen]),
                      TCPALETTE_SelectedRGB,            &gdata->Palette[gdata->ActivePen],
                      TCPALETTE_SelectedRed,            gdata->Palette[gdata->ActivePen].R>>(32-gdata->Precision),
                      TCPALETTE_SelectedGreen,          gdata->Palette[gdata->ActivePen].G>>(32-gdata->Precision),
                      TCPALETTE_SelectedBlue,           gdata->Palette[gdata->ActivePen].B>>(32-gdata->Precision),
                      TCPALETTE_EditMode,               gdata->EditMode,
                      TCPALETTE_NoUndo,                 (gdata->UndoLength?0:1),
                      TAG_DONE));
}

ULONG i_NotifyUndo(Class *C, struct Gadget *Gad, Msg M, ULONG Flags)
{
  struct GadData *gdata;

  gdata=INST_DATA(C, Gad);  
  
  return(i_DoNotify(C, Gad, M, Flags, 
                      GA_ID,                            Gad->GadgetID,
                      TCPALETTE_NoUndo,                 (gdata->UndoLength?0:1),
                      TAG_DONE));
}



ULONG __saveds i_DoNotify(Class *C, struct Gadget *Gad, Msg M, ULONG Flags, Tag Tags, ...)
{
  struct GadData *gdata;

  gdata=INST_DATA(C, Gad);

  return(DoSuperMethod(C,(APTR)Gad,OM_NOTIFY, &Tags, boopsi_GetGInfo(M), Flags));
}
