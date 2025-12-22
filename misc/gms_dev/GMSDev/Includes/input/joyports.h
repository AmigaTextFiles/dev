#ifndef INPUT_JOYPORTS_H
#define INPUT_JOYPORTS_H TRUE

/*
**  $VER: joyports.h
**
**  Joyport definitions.
**
**  (C) Copyright 1996-1998 DreamWorld Productions.
**      All Rights Reserved.
*/

#ifndef DPKERNEL_H
#include <dpkernel/dpkernel.h>
#endif

/*****************************************************************************
** JoyData structure, for reading from joyports.
*/

#define VER_JOYDATA  2
#define TAGS_JOYDATA ((ID_SPCTAGS<<16)|(ID_JOYDATA))

struct JoyData {
  struct Head Head;     /* [00] Standard header */
  WORD   Port;          /* [12] Port number, starts at 1 (mouse) */
  WORD   XChange;       /* [14] Change from X position */
  WORD   YChange;       /* [16] Change from Y position */
  WORD   ZChange;       /* [18] Change from Z position */
  LONG   Buttons;       /* [20] Currently pressed buttons */
  WORD   ButtonTimeOut; /* [24] Micro-seconds before button time-out */
  WORD   MoveTimeOut;   /* [26] Micro-seconds before movement time-out */
  WORD   NXLimit;       /* [28] Negative X limit */
  WORD   NYLimit;       /* [30] Negative Y limit */
  WORD   PXLimit;       /* [32] Positive X limit */
  WORD   PYLimit;       /* [34] Positive Y limit */

  /*** Private fields start now ***/

  WORD   prvType;           /* Type of device */
  LONG   prvButtonTicks;    /* Time-Out */
  LONG   prvMoveTicks;      /* Time-Out */
  struct Keyboard *prvKeys; /* Keyboard object if emulation is required */
  struct JoyKeys  *prvEmu;  /* Pointer to emulation table */
  WORD   prvOldX;
  WORD   prvOldY;
};

#define JD_FIRE1  0x00000001L  /* Standard Fire Button (1) - LMB */
#define JD_FIRE2  0x00000002L  /* Standard Fire Button (2) - RMB */
#define JD_FIRE3  0x00000004L  /* Standard Fire Button (3) - MMB */
#define JD_FIRE4  0x00000008L  /* "Start"    */
#define JD_FIRE5  0x00000010L  /* "Select"   */
#define JD_FIRE6  0x00000020L  /* Rewind  L1 */
#define JD_FIRE7  0x00000040L  /* Forward R1 */
#define JD_FIRE8  0x00000080L  /* Rewind  L2 */
#define JD_FIRE9  0x00000100L  /* Forward R2 */

#define JD_LMB    JD_FIRE1
#define JD_RMB    JD_FIRE2
#define JD_MMB    JD_FIRE3

#define JPORT_DIGITAL  -1
#define JPORT_ANALOGUE -2

#endif /* INPUT_JOYPORTS_H */
