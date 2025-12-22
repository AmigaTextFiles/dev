#ifndef MOB_PROTOS_H
#define MOB_PROTOS_H

#include <exec/types.h>
#include <intuition/classes.h>
#include <intuition/gadgetclass.h>

ULONG gad_Domain(Class *C,  struct Gadget *Gad,struct gpDomain *D);
ULONG __saveds gad_SetAttrs(Class *C, struct Gadget *Gad, struct opSet *Set);
ULONG __saveds gad_GetAttr(Class *C, struct Gadget *Gad, struct opGet *Get);
ULONG __saveds gad_Render(Class *C, struct Gadget *Gad, struct gpRender *Render, ULONG update);
ULONG __saveds gad_HandleInput(Class *C, struct Gadget *Gad, struct gpInput *Input);
ULONG __saveds gad_Layout(Class *C, struct Gadget *Gad, struct gpLayout *layout);
void i_RenderColorBox(Class *C, struct Gadget *Gad, struct GadgetInfo *gi, struct RastPort *rp, ULONG Pen);

ULONG i_Notify(Class *C, struct Gadget *Gad, Msg M, ULONG Flags);
ULONG i_NotifyUndo(Class *C, struct Gadget *Gad, Msg M, ULONG Flags);

LONG i_StoreUndoIfNeeded(Class *C, struct Gadget *Gad, Msg M);
LONG i_AddUndo(struct GadData *gdata, ULONG Pen, struct TCPaletteRGB *RGB, ULONG Linked);
LONG i_GetUndo(Class *C, struct Gadget *Gad, Msg M);

#define  PACKRGB(RGB) ((RGB.R & 0xff000000) >> 8) | \
                      ((RGB.G & 0xff000000) >> 16) | \
                      ((RGB.B & 0xff000000) >> 24)


#endif /* MOB_PROTOS_H */
