#include <clib/extras_protos.h>
#include <graphics/rpattr.h>
#include <graphics/rastport.h>
#include <graphics/gfxmacros.h>
#include <proto/graphics.h>

static UWORD GhostPattern[2] =
{
     0x4444,
     0x1111,
};

/****** extras.lib/gui_GhostRect ******************************************
*
*   NAME
*       GhostRect -- Cover a rectangular are with 
*                    a ghosted pattern.
*
*   SYNOPSIS
*       gui_GhostRect(RP, Pen, X0, Y0, X1, Y1)
*
*       void gui_GhostRect(struct RastPort *, ULONG, 
*            WORD, WORD, WORD, WORD); 
*
*   FUNCTION
*       Covers a rectangular area with a ghosted pattern
*       using the specified pen number.
*
*   INPUTS
*       RP - Pointer to a RastPort.
*       Pen - the pen number to use for the pattern.
*       X0 - left edge 
*       Y0 - top edge
*       X1 - right edge
*       Y1 - bottom edge
*
******************************************************************************
*
*/

void gui_GhostRect(struct RastPort *RP, ULONG Pen, WORD X0, WORD Y0, WORD X1, WORD Y1)
{
  struct RastPort rp;

  rp=*RP;
  SetAPen(&rp,Pen);
  SetDrMd(&rp,JAM1);
  SetAfPt(&rp,GhostPattern,1);

  if(X1>=X0 && Y1>=Y0)
    RectFill(&rp,X0,Y0,X1,Y1);
}
