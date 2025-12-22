/***************************************
*  MASK ENTIRE v1.11
*  © Copyright 1988 Timm Martin
*  All Rights Reserved
****************************************/

#include <exec/types.h>
#include <console/fields.h>
#include <console/functions.h>

void mask_entire( mask, set )
  struct FieldMask *mask;
  ULONG  set;
{
  int i;

  if (set)
    for (i = 0; i < MASK_ELEMENTS; i++)
      mask->Element[i] = 0xFFFFFFFFL;
  else
    for (i = 0; i < MASK_ELEMENTS; i++)
      mask->Element[i] = 0x00000000L;
}
