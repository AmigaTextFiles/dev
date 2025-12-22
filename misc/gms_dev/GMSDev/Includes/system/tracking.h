#ifndef SYSTEM_TRACKING_H
#define SYSTEM_TRACKING_H 1

/*
**  $VER: tracking.h V1.2
**
**  (C) Copyright 1996-1998 DreamWorld Productions.
**      All Rights Reserved
*/

#ifndef DPKERNEL_H
#include <dpkernel/dpkernel.h>
#endif

/*****************************************************************************
** Resource numbers.
*/

#define RES_EMPTY    0
#define RES_MEMORY   1   /* Memory allocation, lowest level resource type */
#define RES_COMPLEX  2   /* Complex allocation - (hardware and software) */
#define RES_CUSTOM   3   /* Software allocation of a customised type */
#define RES_HARDWARE 4   /* Hardware allocation */

/*****************************************************************************
** This structure is used only within the kernel.
*/

struct Track {
  struct Track *Next;  /* Next in the chain */
  WORD   ID;           /* ID number of this resource (see above) */
  LONG   Key;          /* Unique key for the resource */
  APTR   Address;      /* Address of object to free */
  LIBPTR void (*Routine)(mreg(__d0) APTR Address, mreg(__d1) LONG Key);
};

#endif /* SYSTEM_TRACKING_H */
