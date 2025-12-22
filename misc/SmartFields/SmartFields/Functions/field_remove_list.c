/***************************************
*  FIELD REMOVE LIST v1.02
*  © Copyright 1988 Timm Martin
*  All Rights Reserved
****************************************/

#include <console/fields.h>
#include <console/functions.h>
#include <toolkit/toolkit.h>

int field_remove_list( header, remove, count )
  struct FieldHeader *header;
  struct Field *remove;
  UINT   count;
{
  int    actual;               /* to find position in list */
  int    i;                    /* to count fields to be deleted */
  struct Field *next;          /* used to step thru lists */
  struct Field *prev;          /* field before first field to be removed */

  if (!remove || !count)       /* if no fields to remove */
    return (0);                /* indicate no remove took place */

  /* search through existing list until end or find field to be removed */
  for (actual = 1, next = header->FirstField; next && next != remove;
       actual++, next = next->NextField);

  if (!next)                   /* if reached end of list w/o finding field */
    return (0);                /* field to be removed not in list */
  prev = next->PrevField;      /* store field before one to be removed */

  /* find last field to be removed */
  /* remember: at this point, next == remove */
  for (i = 0; i < count && next; i++, next = next->NextField) {
    remove = next;
    if (remove == header->CurrentField) {
      header->CurrentField = NULL;
      cursor_invisible( header->WriteReq );
    }
  }

  if (prev)
    /* point field before removed fields to field after */
    prev->NextField = next;
  else
    /* field after removed list becomes first field */
    header->FirstField = next;

  if (next)
    /* point field after removed fields to field before */
    next->PrevField = prev;
  else
    /* field before removed list becomes final field */
    header->FinalField = prev;

  return (actual);
}
