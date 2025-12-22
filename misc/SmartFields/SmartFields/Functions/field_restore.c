/***************************************
*  FIELD RESTORE v1.11
*  © Copyright 1988 Timm Martin
*  All Rights Reserved
****************************************/

#include <exec/io.h>
#include <exec/types.h>
#include <console/console.h>
#include <console/fields.h>
#include <console/functions.h>

void field_restore( field, wreq )
  struct Field *field;
  struct IOStdReq *wreq;
{
  void strcpy();                /* standard C library */
  int  strlen();                /* standard C library */
  int  undo_length;             /* to save length of undo buffer */

  if (field->UndoBuffer) {
    undo_length = strlen( field->UndoBuffer );
    if (undo_length) {
      cursor_jump_left( wreq, field->BufferPos );
      con_char_mult_delete( wreq, field->NumChars );
      strcpy( field->Buffer, field->UndoBuffer );
      field->NumChars = undo_length;
      con_put_string( wreq, field->Buffer );
      cursor_jump_left( wreq, field->NumChars );
      field->BufferPos = 0;
    }
    else
      FLASH_SCREEN;
  }
  else
    FLASH_SCREEN;
}
