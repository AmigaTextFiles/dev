#ifndef CLASSES_GADGETS_TCPALETTE_H
#define CLASSES_GADGETS_TCPALETTE_H

#ifndef REACTION_REACTION_MACROS_H
#include <reaction/reaction_macros.h>
#endif

#ifndef CLIB_TCPALETTE_PROTOS_H
#include <clib/classes/gadgets/tcpalette_protos.h>
#endif

/* Reaction MACROS */

#define TCPaletteObject   NewObject(TCPALETTE_GetClass(),NULL
#define TCPaletteEnd      End

/*****************************************************************************/

/* Additional attributes defined by the Palette class
 */
#define TCPALETTE_Dummy(x)			(REACTION_Dummy+0x0004000+x)

#define TCPALETTE_ShowSelected    TCPALETTE_Dummy(0)
#define TCPALETTE_SelectedColor   TCPALETTE_Dummy(1)
#define TCPALETTE_SelectedRGB     TCPALETTE_Dummy(2)
#define TCPALETTE_SelectedLRGB    TCPALETTE_Dummy(3)

#define TCPALETTE_Precision       TCPALETTE_Dummy(4) // default 8 bit.
#define TCPALETTE_SelectedRed     TCPALETTE_Dummy(5) 
#define TCPALETTE_SelectedGreen   TCPALETTE_Dummy(6)    
#define TCPALETTE_SelectedBlue    TCPALETTE_Dummy(7)

#define TCPALETTE_NumColors       TCPALETTE_Dummy(10)

#define TCPALETTE_RGBPalette      TCPALETTE_Dummy(20)
#define TCPALETTE_LRGBPalette     TCPALETTE_Dummy(21)

#define TCPALETTE_Orientation     TCPALETTE_Dummy(30) // ?
#define TCPO_NORMAL      0
#define TCPO_HORIZONTAL  1
#define TCPO_VERTICAL    2


#define TCPALETTE_EditMode        TCPALETTE_Dummy(40)
#define TCPEM_NORMAL  0
#define TCPEM_COPY    1
#define TCPEM_SWAP    2
#define TCPEM_SPREAD  3

#define TCPALETTE_Undo            TCPALETTE_Dummy(41) // Should be a method (SET/UPDATE)
#define TCPALETTE_NoUndo          TCPALETTE_Dummy(42) // Get/Notify

#define TCPALETTE_ColorLabels     TCPALETTE_Dummy(50) // (STRPTR *) Array of names, forces 

#define TCPALETTE_Top             TCPALETTE_Dummy(51)




struct TCPaletteRGB
{
  ULONG R,G,B;
};

struct TCPaletteLRGB // LONG Size
{
  UBYTE Pad,R,G,B;
};
#endif /* GADGETS_TCPALETTE_H */
