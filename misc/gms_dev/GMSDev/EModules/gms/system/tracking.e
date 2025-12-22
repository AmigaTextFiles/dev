/*
**  $VER: tracking.e V1.0
**
**  (C) Copyright 1996-1998 DreamWorld Productions.
**      All Rights Reserved
*/

OPT MODULE
OPT EXPORT
OPT PREPROCESS

MODULE 'gms/dpkernel/dpkernel','gms/system/register'

/*****************************************************************************
** Resource numbers.
*/

CONST RES_EMPTY    = 0,
      RES_MEMORY   = 1,   /* Memory allocation, lowest level resource type */
      RES_COMPLEX  = 2,   /* Complex allocation - (hardware and software) */
      RES_CUSTOM   = 3,   /* Software allocation of a customised type */
      RES_HARDWARE = 4    /* Hardware allocation */

/*****************************************************************************
** This structure is used only within the kernel.
*/

OBJECT track
  next    :PTR TO track  /* Next in the chain */
  id      :INT           /* ID number of this resource (see above) */
  key     :LONG          /* Unique key for the resource */
  address :LONG          /* Address of object to free */
  routine :LONG          /* ROUTINE */
ENDOBJECT

