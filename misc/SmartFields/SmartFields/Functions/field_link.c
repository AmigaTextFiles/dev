/***************************************
*  FIELD LINK v1.11
*  © Copyright 1988 Timm Martin
*  All Rights Reserved
****************************************/

#include <exec/io.h>
#include <exec/types.h>
#include <console/fields.h>
#include <console/functions.h>

struct Field *field_link( final )
  struct Field *final;
{
  struct Field *prev;       /* for stepping thru list */
  struct Field *next;       /* prev->NextField */

  if (!final)
    return (NULL);          /* error checking */

  final->NextField = NULL;  /* just to make sure */
  next = final;             /* start at end of list */
  prev = final->PrevField;
  while (prev) {
    prev->NextField = next; /* point previous field to next field */
    next = prev;            /* store next field */
    prev = prev->PrevField; /* get previous field */
  }
  return (next);
}
