/***************************************
*  MASK CHARacterS v1.11
*  © Copyright 1988 Timm Martin
*  All Rights Reserved
****************************************/

#include <exec/types.h>
#include <console/fields.h>
#include <console/functions.h>

void mask_chars( mask, string, set )
  struct FieldMask *mask;
  UBYTE  *string;
  ULONG   set;
{
  if (set)
    while (*string) {
      mask->Element[*string>>5] |= MASK_ENABLE << (*string % 32);
      string++;
    }
  else
    while (*string) {
      mask->Element[*string>>5] &= ~(MASK_ENABLE << (*string % 32));
      string++;
    }
}
