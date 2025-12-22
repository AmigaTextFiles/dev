/*
**  $VER: scroller.h 44.1 (19.10.1999)
**  Includes Release 44.1
**
**  Definitions for the scroller.gadget BOOPSI class
**
**  (C) Copyright 1987-1999 Amiga, Inc.
**      All Rights Reserved
*/
/*****************************************************************************/
//MODULE 'reaction/reaction','intuition/gadgetclass'
/*****************************************************************************/
/* Additional attributes defined by the scroller.gadget class
 */
#define SCROLLER_Dummy      (REACTION_Dummy+$0005000)
#define SCROLLER_Top      (SCROLLER_Dummy+1)
/* (WORD) scroller Top value (Defaults to 0). */
#define SCROLLER_Visible    (SCROLLER_Dummy+2)
/* (WORD) visible part of total. */
#define SCROLLER_Total      (SCROLLER_Dummy+3)
/* (WORD) total scroller size. */
#define SCROLLER_Orientation  (SCROLLER_Dummy+4)
/* (WORD) Vertical or Horizontal mode. */
#define SCROLLER_Arrows       (SCROLLER_Dummy+5)
/* (BOOL) Render arrows. */
#define SCROLLER_Stretch    (SCROLLER_Dummy+6)
/* (BOOL) AutoExpand/Stretch Total. */
#define SCROLLER_ArrowDelta     (SCROLLER_Dummy+7)
/* (WORD) Change arrow click makes. */
#define SCROLLER_SignalTask     (SCROLLER_Dummy+10)
/* (struct Task *) Signal this Task while scroller is active */
#define SCROLLER_SignalTaskBit  (SCROLLER_Dummy+11)
/* (ULONG) Signal with this Bit. */
/*****************************************************************************/
/* SCROLLER_Orientation Modes
 */
#define SORIENT_HORIZ   FREEHORIZ
#define SORIENT_VERT  FREEVERT
#define SCROLLER_HORIZONTAL   SORIENT_HORIZ
#define SCROLLER_VERTICAL   SORIENT_VERT
