#ifndef EDATA_H
#define EDATA_H

#ifndef EXEC_NODES_H
#include <exec/nodes.h>
#endif

#ifndef INTUITION_CLASSUSR_H
#include <intuition/classusr.h>
#endif

#include <classes/requesters/palette.h>

struct IDCMP_Hook
{
  struct Hook H; // h_Data is LibBase
  struct EData *EData;
};



struct EData
{
  struct Node eNode;
  
  Object  *ScreenObject;
  struct  Window *Window; // requester window
  Object  *Win_Object, // window object
          *Model,
          *G_Palette,
          *G_Red,
          *G_Green,
          *G_Blue,
          *G_RedText,
          *G_GreenText,
          *G_BlueText,
          *G_Copy,
          *G_Swap,
          *G_Spread,
          *G_Reset,
          *G_Undo,
          *G_OK,
          *G_Cancel;



  /* IDCMP Handler*/
  struct IDCMP_Hook IDCMPHook;

/* pr_ are tag related */
  ULONG   pr_Flags;

  LONG    pr_InitialLeftEdge,
          pr_InitialTopEdge,
          pr_InitialWidth,
          pr_InitialHeight;
  

  struct  Screen *pr_Screen;
  struct  Window *pr_Window;
  STRPTR  pr_PubScreenName;
  struct  TextAttr *pr_TextAttr;
  
  STRPTR  pr_TitleText;
  
  BYTE    pr_RedBits, pr_GreenBits, pr_BlueBits;
  
  ULONG   pr_Colors;
  
  struct  prRGB pr_InitialPalette[256];
  struct  prRGB UndoPalette   [256];
  struct  prRGB WorkPalette   [256];

  STRPTR  pr_PositiveText,
          pr_NegativeText;
          
  ULONG  CopyMode, SpreadMode, SwapMode; 
};

#define PRFLAG_USER_LEFTEDGE  (1<<0)
#define PRFLAG_USER_TOPEDGE  (1<<1)
#define PRFLAG_USER_WIDTH  (1<<2)
#define PRFLAG_USER_HEIGHT  (1<<3)
#define PRFLAG_USER_REDBITS  (1<<4)
#define PRFLAG_USER_GREENBITS  (1<<5)
#define PRFLAG_USER_BLUEBITS  (1<<6)

#endif /* EDATA_H */
