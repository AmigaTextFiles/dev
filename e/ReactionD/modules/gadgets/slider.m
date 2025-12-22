/*
**  $VER: slider.h 44.1 (19.10.1999)
**  Includes Release 44.1
**
**  Definitions for the slider.gadget BOOPSI class
**
**  (C) Copyright 1987-1999 Amiga, Inc.
**      All Rights Reserved
*/
/*****************************************************************************/
//MODULE 'reaction/reaction','intuition/gadgetclass'
/*****************************************************************************/
/* Additional attributes defined by the slider.gadget class
 */
#define SLIDER_Dummy      (REACTION_Dummy+$0028000)
#define SLIDER_Min        (SLIDER_Dummy+1)
/* (WORD) . */
#define SLIDER_Max        (SLIDER_Dummy+2)
/* (WORD) . */
#define SLIDER_Level      (SLIDER_Dummy+3)
/* (WORD) . */
#define SLIDER_Orientation    (SLIDER_Dummy+4)
/* (WORD) . */
#define SLIDER_DispHook       (SLIDER_Dummy+5)
/* (struct Hook *) . */
#define SLIDER_Ticks      (SLIDER_Dummy+6)
/* (LONG) . */
#define SLIDER_ShortTicks     (SLIDER_Dummy+7)
/* (BOOL) . */
#define SLIDER_TickSize       (SLIDER_Dummy+8)
/* (WORD) . */
#define SLIDER_KnobImage    (SLIDER_Dummy+9)
/* (struct Image *) . */
#define SLIDER_BodyFill       (SLIDER_Dummy+10)
/* (WORD) . */
#define SLIDER_BodyImage    (SLIDER_Dummy+11)
/* (struct Image *) . */
#define SLIDER_Gradient       (SLIDER_Dummy+12)
/* (BOOL) Gradient slider modem, defaults to false. */
#define SLIDER_PenArray       (SLIDER_Dummy+13)
/* (UWORD *) Pens for gradient slider. */
#define SLIDER_Invert       (SLIDER_Dummy+14)
/* (BOOL) Flip Min/Max positions. Defaults to false. */
#define SLIDER_KnobDelta    (SLIDER_Dummy+15)
/* (WORD) . */
/*****************************************************************************/
/* SLIDER_Orientation Modes
 */
#define SORIENT_HORIZ  FREEHORIZ
#define SORIENT_VERT  FREEVERT
#define SLIDER_HORIZONTAL  SORIENT_HORIZ
#define SLIDER_VERTICAL   SORIENT_VERT
