/***************************************
*  MASK ascii RANGE v1.11
*  © Copyright 1988 Timm Martin
*  All Rights Reserved
****************************************/

#include <exec/types.h>
#include <console/fields.h>
#include <console/functions.h>
#include <toolkit/toolkit.h>

void mask_range( mask, low, high, set )
  struct FieldMask *mask;
  UBYTE  low, high;
  ULONG  set;
{
  REG ULONG i;

  if (set)
    for (i = low; i <= high; i++)
      mask->Element[i>>5] |= MASK_ENABLE << (i % 32);
  else
    for (i = low; i <= high; i++)
      mask->Element[i>>5] &= ~(MASK_ENABLE << (i % 32));
}
