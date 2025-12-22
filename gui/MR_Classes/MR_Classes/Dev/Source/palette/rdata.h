#ifndef RDATA_H
#define RDATA_H

#ifndef CLASSES_REQUESTERS_PALETTE_H
#include <classes/requesters/palette.h>
#endif

struct RData 
{
  struct  MyHook IDCMPHook;
  Object  *Win_Object,
          *Model,
          *G_Palette,
          *G_Red,
          *G_Green,
          *G_Blue,
          *G_Copy,
          *G_Swap,
          *G_Spread,
          *G_Reset,
          *G_Undo,
          *G_OK,
          *G_Cancel;

  struct Window *Window;

/* pr_ are tag related */
  ULONG   pr_Flags;

  LONG    pr_InitialLeftEdge,
          pr_InitialTopEdge,
          pr_InitialWidth,
          pr_InitialHeight;
  

  struct  Screen *pr_Screen;
  struct  Window *pr_Window;
  struct  TextAttr *pr_TextAttr;
  
  STRPTR  pr_Title;
  
  BYTE    pr_RedBits, pr_GreenBits, pr_BlueBits;
  BYTE    Pad0;
  
  ULONG   pr_Colors;
  
  struct  prRGB pr_InitialPalette[256];
  struct  prRGB pr_UndoPalette   [256];
  struct  prRGB pr_WorkPalette   [256];
}

#endif /* RDATA_H */
