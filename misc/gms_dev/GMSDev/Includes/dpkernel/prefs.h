#ifndef DPKERNEL_PREFS_H
#define DPKERNEL_PREFS_H 1

/*
**  $VER: prefs.h V2.0
**
**  GMS Preferences
**
**  (C) Copyright 1996-1998 DreamWorld Productions.
**      All Rights Reserved
*/

#ifndef DPKERNEL_H
#include <dpkernel/dpkernel.h>
#endif

/***************************************************************************
** Screen Preferences
*/

#define OCS 0
#define ECS 1
#define AGA 2
 
#define GB_NONE       0  /* Different graphics boards. */
#define GB_PICCOLO    1
#define GB_CYBERVIS64 2
#define GB_SPECTRUM   3
#define GB_PICASSO    4
#define GB_RETINA     5
#define GB_MERLIN     6
#define GB_HARLEQUIN  7
#define GB_OPALVISION 8
 
#define SCR_PAL     0    /* Type of mode promotion. */
#define SCR_NTSC    1
#define SCR_DBLPAL  2
#define SCR_DBLNTSC 3
#define SCR_VGA     4
 
#define TO_WINDOW   0    /* Screen switching method. */
#define TO_SCREEN   1

#define SCRPREFS_V1      /* SCR1 */
#define SCRPREFS_V2      /* SCR2 */
#define SCRPREFS_V3      /* SCR3 */

struct ScreenPrefs {
  LONG ID;             /* "SCR1" */
  WORD ChipSet;        /* OCS/ECS/AGA */
  WORD ModePromote;    /* None/NTSC/PAL/DBLNTSC/DBLPAL/VGA */ 
  WORD GfxBoard;       /* Gfx board setting */
  WORD TopOfScrX;      /* Top corner of screen, X */
  WORD TopOfScrY;      /* Top corner of screen, Y */
  WORD ScrSwitch;      /* Screen Switch to window or screen */
  WORD ScrWidth;       /* The width of the visible screen */
  WORD ScrHeight;      /* The height of the visible screen */
  WORD Planes;         /* The amount of planes in the screen */
  LONG Attrib;         /* Special Attributes */
  WORD ScrMode;        /* Screen mode */
  WORD ScrType;        /* ILBM/Planar/Chunky? */
  BYTE *C2PFile;       /* C2P file */
  LONG *Palette;       /* Pointer to 24 bit palette */
  WORD OwnBlitter;     /* 0 = FALSE, 1 = TRUE */
};

/***************************************************************************
** Master Preferences
*/

struct JoyKeys {
  BYTE Left;
  BYTE Right;
  BYTE Up;
  BYTE Down;
  BYTE Fire1;
  BYTE Fire2;
  BYTE Fire3;
  BYTE Fire4;
  BYTE Fire5;
  BYTE Fire6;
  BYTE Fire7;
  BYTE Fire8;
  BYTE ZIn;
  BYTE ZOut;
  WORD QualMask;       /* Qualifier Mask */
};

struct MasterPrefs {
  LONG VERSION;        /* "GEN1" */
  APTR empty;          /* */
  WORD JoyType1;       /* Type of Joystick in port 1 */
  WORD JoyType2;       /* Type of Joystick in port 2 */
  WORD JoyType3;       /* Type of Joystick in port 3 */
  WORD JoyType4;       /* Type of Joystick in port 4 */
  WORD Language;       /* Language */
  WORD UserPri;        /* User priority */
  WORD Tracking;       /* Resource tracking on/off */
  BYTE XPK[4];         /* XPK cruncher name */
  WORD ButtonTime;     /* Micro-seconds for button time-out */
  WORD MoveTime;       /* Micro-seconds for movement time-out */
  struct JoyKeys Keys[4];
};

#endif /* DPKERNEL_PREFS_H */
