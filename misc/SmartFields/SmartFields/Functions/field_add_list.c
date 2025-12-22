/***************************************
*  FIELD ADD LIST v1.02
*  © Copyright Timm Martin
*  All Rights Reserved
****************************************/

#include <console/fields.h>
#include <console/functions.h>
#include <toolkit/toolkit.h>

int field_add_list( header, position, add, count )
  struct FieldHeader *header;
  UINT   position;
  struct Field *add;
  UINT   count;
{
  int    actual;
  int    i;
  struct Field *next;
  struct Field *prev;

  if (!add || !count)          /* if no fields to add */
    return (0);                /* indicate no add took place */

  prev = NULL;                 /* in case no existing fields */
  next = header->FirstField;   /* start at top of list */

  /* search through existing list until end or find desired add position */
  for (actual = 1; actual < position && next; actual++) {
    prev = next;               /* store previous field */
    next = next->NextField;    /* get next field in existing list */
  }

  if (prev)                    /* in case adding in position 1 */
    prev->NextField = add;     /* point previous field to first field added */
  else
    header->FirstField = add;  /* added field becomes first field */
  add->PrevField = prev;       /* point first to be added back to prev field */

  /* add field list until end or number desired was added */
  for (i = 0; i < count && add; i++) {
    prev = add;                /* store previous field */
    add  = add->NextField;     /* get next field in add list */
  }

  prev->NextField = next;      /* point last field added to next field */
  if (next)                    /* in case added to end of existing list */
    next->PrevField = prev;    /* point next field back to last added field */
  else
    header->FinalField = prev; /* last field added becomes final field */

  return (actual);
}
