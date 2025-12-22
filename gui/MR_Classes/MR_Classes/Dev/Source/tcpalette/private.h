#ifndef PRIVATE_H
#define PRIVATE_H

#include <stdio.h>
#include <dos.h>
#include <math.h>
#include <tagitemmacros.h>

#include <clib/alib_protos.h>
#include <clib/extras_protos.h>

#include <proto/classes/gadgets/tcpalette.h>
#include <classes/gadgets/tcpalette.h>

#include <proto/exec.h>
#include <proto/intuition.h>
#include <proto/utility.h>
#include <proto/graphics.h>
#include <proto/keymap.h>
#include <proto/cybergraphics.h>
#include <proto/bevel.h>

#include <graphics/gfxmacros.h>
#include <graphics/gfx.h>

#include <exec/types.h>
#include <exec/memory.h>

#include <intuition/intuition.h>
#include <intuition/intuitionbase.h>
#include <intuition/screens.h>
#include <intuition/classusr.h>
#include <intuition/icclass.h>
#include <intuition/gadgetclass.h>

#include <utility/tagitem.h>

#include <gadgets/palette.h>

#include <images/bevel.h>
#include <images/mlr/patterns.h>

#define m_SUPERCLASS_ID "gadgetclass"
#define m_CLASS_ID      "tcpalette.gadget"
#define m_INST_SIZE     (sizeof(struct GadData))

#define PM_BESTPEN  0
#define PM_TCPEN    1

struct PenData
{
  WORD P1, P2;
  LONG DitherAmt;
};

struct GadData
{
  struct Image *Pattern;
  struct Image *Bevel;
  WORD   Pens;
  UBYTE  Orientation;
  UBYTE  ShowSelected;

  UBYTE   ActivePen,
          LastActivePen;
  WORD    AllocatedPens[256][2];
  WORD    Rows, 
          Cols;
  WORD    Col[257], // + Gad->Left
          Row[257]; // + Gad->Top
  struct  TCPaletteRGB Palette[256];
  BYTE    Precision;
  WORD    EditMode;
  UBYTE   EMPen;
  BYTE    MouseMode;
  BYTE    Disabled;
  WORD    UndoPen;
  UBYTE   UndoPenSaved;
  UBYTE   UndoStart;
  UBYTE   UndoLength;
  UBYTE   UndoLinked[256];
  UBYTE   UndoPenNumber[256];
  struct  TCPaletteRGB UndoPalette[256], UndoPenRGB;
};


typedef union MsgUnion
{
  ULONG  MethodID;
  struct opSet        opSet;
  struct opUpdate     opUpdate;
  struct opGet        opGet;
  struct gpHitTest    gpHitTest;
  struct gpRender     gpRender;
  struct gpInput      gpInput;
  struct gpGoInactive gpGoInactive;
  struct gpLayout     gpLayout;
} *Msgs;

/* prototypes */

ULONG __saveds __asm Dispatcher(register __a0 Class *C, 
                                register __a2 struct Gadget *Gad, 
                                register __a1 Msgs M, 
                                register __a6 struct Library *LibBase );

#endif /* SYSI2_H */
