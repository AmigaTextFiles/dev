/***************************************
*  FIELD DISPLAY v1.25
*  © Copyright 1988 Timm Martin
*  All Rights Reserved
****************************************/

#include <exec/io.h>
#include <exec/types.h>
#include <intuition/intuition.h>
#include <console/fields.h>
#include <console/functions.h>
#include <toolkit/toolkit.h>

int field_display( header, first, count, place )
  struct FieldHeader *header;
  struct Field *first;
  UINT   count;
  struct Field *place;
{
  struct Field *field;        /* to step trhu field list */
  REG    UINT i = 0;          /* number of fields displayed */
  int    strlen();            /* standard C library */

  field = first;
  cursor_invisible( header->WriteReq );
  while (field && i < count) {
    if (header->Window->Width > field->Right &&
        header->Window->Height > field->Bottom) {
      cursor_place( header->WriteReq, field->Left, field->Top );
      con_graphic_rend( header->WriteReq, field->Style, field->FrontPen, field->BackPen );
      con_put_string( header->WriteReq, field->Buffer );
    }
    field->NumChars  = strlen( field->Buffer );
    field->BufferPos = 0;
    field = field->NextField;
    i++;
  }
  if (place)
    field_goto( header, place );

  return (i);
}
