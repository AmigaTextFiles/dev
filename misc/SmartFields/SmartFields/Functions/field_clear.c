/***************************************
*  FIELD CLEAR v1.34
*  © Copyright 1988 Timm Martin
*  All Rights Reserved
****************************************/

#include <exec/io.h>
#include <exec/types.h>
#include <intuition/intuition.h>
#include <console/fields.h>
#include <console/functions.h>
#include <toolkit/toolkit.h>

int field_clear( header, first, count, place )
  struct FieldHeader *header;
  struct Field *first;
  UINT   count;
  struct Field *place;
{
  struct Field *field;            /* for stepping thru field list */
  int    i = 0;                   /* to count number of fields cleared */
  void   RectFill();              /* graphics.library */
  void   SetAPen();               /* graphics.library */
  void   strcpy();                /* standard C library */

  field = first;
  cursor_invisible( header->WriteReq );
  while (field && i < count) {
    SetAPen( header->Window->RPort, (long)(field->BackPen) );
    RectFill( header->Window->RPort, (long)(field->Left), (long)(field->Top),
              (long)(field->Right - header->Window->BorderRight),
              (long)(field->Bottom - header->Window->BorderBottom) );
    if (field->DupBuffer)
      strcpy( field->DupBuffer, field->Buffer );
    *(field->Buffer) = '\0';
    field->NumChars = field->BufferPos = 0;
    field = field->NextField;
    i++;
  }
  if (place)
    field_goto( header, place );

  return (i);
}
