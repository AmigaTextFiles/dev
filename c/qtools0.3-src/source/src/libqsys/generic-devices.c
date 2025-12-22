/*
 * <one line to give the program's name and a brief idea of what it does.>
 * Copyright (C) 1998  Niels Froehling <Niels.Froehling@Informatik.Uni-Oldenburg.de>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */

#define	LIBQSYS_CORE
#include "../include/libqsys.h"

struct DisplayDimension localDim;

void SetDisplay(struct DisplayDimension *dim)
{
  localDim = *dim;
}

/* this is an offscreen-renderer */
#ifndef	OPENDISPLAY
struct DisplayDimension rootDim =
{0};								/* empty root at the beginning */

struct DisplayDimension *OpenDisplay(short int width, short int height, char depth, struct rgb *Palette)
{
  struct DisplayDimension *newDim;

  if ((newDim = (struct DisplayDimension *)tmalloc(sizeof(struct DisplayDimension)))) {
    newDim->changedOffset = TRUE;
    newDim->X = 0;
    newDim->Y = 0;
    newDim->changedSize = TRUE;
    newDim->Width = width;
    newDim->Height = height;
    newDim->changedDesktopOffset = TRUE;
    newDim->dtX = 0;
    newDim->dtY = 0;
    newDim->changedDesktopSize = TRUE;
    newDim->dtWidth = width;
    newDim->dtHeight = height;
    newDim->changedBuffer = TRUE;
    newDim->frameDepth = depth;
    newDim->frameSize = width * height;
    newDim->ID = rootDim.ID;
    newDim->nextDim = rootDim.nextDim;
    newDim->driverPrivate = 0;

    rootDim.nextDim = newDim;
    rootDim.ID++;

    if (depth <= 8)
      newDim->frameBPP = 1;					/* index based */
    else if (depth <= 16)
      newDim->frameBPP = 2;					/* 15/16 bit rgb */
    else if (depth <= 24)
      newDim->frameBPP = 3;					/* 24 bit rgb */
    else
      newDim->frameBPP = 4;					/* 32 bit argb */

    if (!(newDim->frameBuffer = (void *)tmalloc(width * height * newDim->frameBPP)))
      Error(failed_memoryunsize, "offscreen framebuffer");
#ifdef	USE_ZBUFFER
    if (!(newDim->zBuffer = (unsigned short int *)tmalloc(width * height * sizeof(unsigned short int))))
      Error(failed_memoryunsize, "offscreen zbuffer");
#endif
  }

  return newDim;
}
#endif

/* this swaps buffer if doublebuffer */
#ifndef	SWAPDISPLAY
void *SwapDisplay(struct DisplayDimension *disp, void *oldBuffer)
{
  return oldBuffer;
}
#endif

#ifndef	UPDATEDISPLAY
void *UpdateDisplay(struct DisplayDimension *disp, void *oldBuffer, short int x, short int y, short int width, short int height)
{
  return oldBuffer;
}
#endif

#ifndef	CHANGEDISPLAY
void ChangeDisplay(struct DisplayDimension *disp, short int width, short int height, char depth, struct rgb *Palette, char *Title)
{
}
#endif

/*
 * 
 */
#ifndef	CLOSEDISPLAY
void CloseDisplay(struct DisplayDimension *disp)
{
}
#endif

/*
 * 
 */
#ifndef	OPENKEYS
void OpenKeys(struct DisplayDimension *disp)
{
}
#endif

/*
 * the caller repeats through this untill it gets -1 or ESCAPE as a terminator
 * or return FALSE
 */
#ifndef	GETKEYS
bool GetKeys(struct DisplayDimension *disp, struct keyEvent *eventBuffer)
{
  eventBuffer->pressed = RAWKEY_ESCAPE;
  return TRUE;
}
#endif

/*
 * 
 */
#ifndef	CLOSEKEYS
void CloseKeys(struct DisplayDimension *disp)
{
}
#endif

/*
 * 
 */
#ifndef	OPENMOUSE
void OpenMouse(void)
{
}
#endif

/*
 * the caller repeats through this untill it gets -1
 */
#ifndef	GETMOUSE
void GetMouse(struct mouseEvent *eventBuffer)
{
  eventBuffer->pressed = RAWMOUSE_NOTHING;
  eventBuffer->mouseX = 0;
  eventBuffer->mouseY = 0;
}
#endif

/*
 * 
 */
#ifndef	CLOSEMOUSE
void CloseMouse(void)
{
}
#endif
