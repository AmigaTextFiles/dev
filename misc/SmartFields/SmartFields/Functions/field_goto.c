/***************************************
*  FIELD GOTO v1.32
*  © Copyright 1988 Timm Martin
*  All Rights Reserved
****************************************/

#include <exec/io.h>
#include <exec/types.h>
#include <intuition/intuition.h>
#include <console/fields.h>
#include <console/functions.h>

void field_goto( header, field )
  struct FieldHeader *header;
  struct Field *field;
{
  void strcpy();  /* standard C library */

  header->CurrentField = field;
  cursor_invisible( header->WriteReq );
  if (header->Window->Width  > field->Right &&
      header->Window->Height > field->Bottom) {
    if (field->UndoBuffer)
      strcpy( field->UndoBuffer, field->Buffer );
    cursor_place( header->WriteReq, field->Left, field->Top );
    con_graphic_rend( header->WriteReq, field->Style, field->FrontPen, field->BackPen );
    con_line_length( header->WriteReq, field->MaxChars );
    cursor_jump_right( header->WriteReq, field->BufferPos );
    cursor_visible( header->WriteReq );
  }
}
