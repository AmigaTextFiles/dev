#ifndef GADGETS_DRAGGADGET_H
#define GADGETS_DRAGGADGET_H TRUE
/*
**  $VER: draggadget.h 0.2 (21.4.96)
**
**  Definitions for BOOPSI draggadget objects
**
**  (c) Copyright 1996 Joerg Kollmann
**  All Rights Reserved
**
*/

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef EXEC_LIBRARIES_H
#include <exec/libraries.h>
#endif

#ifndef INTUITION_CLASSUSR_H
#include <intuition/classusr.h>
#endif

#ifndef INTUITION_INTUITION_H
#include <intuition/intuition.h>
#endif

#ifndef UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif

/*********************************************************************/

struct DragInfo {
  WORD            type;       /* still unused */
  APTR            reserved1;
  struct {
    WORD          X;          /* rel. to RastPort of gadget */
    WORD          Y;
  } mouse;
  APTR            reserved2;
};

/*****************************************************************************/

#define DGA_Dummy   (TAG_USER+0x5000000)

#define DGA_ExtSelect   (DGA_Dummy+1)  /* BOOL, default FALSE, Applicability: (I)
        * with this attribute set to TRUE, the gadget image stays selected
        * after dropping. */

#define DGA_Screen      (DGA_Dummy+3)  /* Screen/Window of Dragobject, mutually */
#define DGA_Window      (DGA_Dummy+4)  /* exclusive. Applicability: (I) */

/*****************************************************************************/

struct DClassLibrary {
  struct Library    dcl_Lib;
  UWORD             dcl_Pad;
  struct IClass    *dcl_DragClass;    /* Class pointer for draggadget objects */
  struct IClass    *dcl_DragGroup;    /* unused for now */
};

#endif /* GADGETS_DRAGGADGET_H */
