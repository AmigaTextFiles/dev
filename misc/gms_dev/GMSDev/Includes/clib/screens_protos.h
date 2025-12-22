#ifndef  CLIB_SCREENS_PROTOS_H
#define  CLIB_SCREENS_PROTOS_H

/*
**   $VER: screens_protos.h V1.0
**
**   C prototypes.
**
**   (C) Copyright 1996-1998 DreamWorld Productions.
**       All Rights Reserved.
*/

#ifndef  SYSTEM_TYPES_H
#include <system/types.h>
#endif

APTR AllocVideoMem(LONG Size, LONG Flags);
void AutoSwitch(void);
void BlankOn(void);
void BlankOff(void);
void FreeVideoMem(APTR MemBlock);
void ReadySwitch(struct GScreen *);
void RefreshScreen(struct GScreen *);
struct GScreen * ReturnDisplay(void);
void SetBmpOffsets(struct GScreen *, WORD BmpXOffset, WORD BmpYOffset);
void SetScrDimensions(struct GScreen *, WORD Width, WORD Height);
void SetScrOffsets(struct GScreen *, WORD ScrXOffset, WORD ScrYOffset);
void SwapBuffers(struct GScreen *);
LONG TakeDisplay(struct GScreen *);
void UpdateColour(struct GScreen *, LONG Colour, LONG Value);
LONG WaitVBL(void);
LONG WaitAVBL(void);
LONG WaitRastLine(struct GScreen *, WORD LinePosition);
LONG WaitSwitch(struct GScreen *);

/* Palette functions */

void UpdatePalette(struct GScreen *);
void ChangeColours(struct GScreen *, LONG *Colours, WORD StartColour, WORD AmtColours);
WORD ColourMorph(struct GScreen *, WORD FadeState, WORD Speed,
       LONG StartColour, LONG AmtColours, LONG SrcColour, LONG DestColour);
WORD ColourToPalette(struct GScreen *, WORD FadeState, WORD Speed,
       LONG StartColour, LONG AmtColours, APTR Palette, LONG RRGGBB);
WORD PaletteMorph(struct GScreen *, WORD FadeState, WORD Speed,
       LONG StartColour, LONG AmtColours, APTR SrcPalette, APTR DestPalette);
WORD PaletteToColour(struct GScreen *, WORD FadeState, WORD Speed,
       LONG StartColour, LONG AmtColours, APTR Palette, LONG RRGGBB);
void BlankColours(struct GScreen *);

void prvMoveBitmap(struct GScreen *);
void prvRemakeScreen(struct GScreen *);
void prvSwitchScreen(void);

#endif /* CLIB_SCREENS_PROTOS_H */

