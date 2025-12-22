/***************************************
*  FIELD DELETE v1.11
*  © Copyright 1988 Timm Martin
*  All Rights Reserved
****************************************/

#include <exec/io.h>
#include <exec/types.h>
#include <console/console.h>
#include <console/fields.h>
#include <console/functions.h>

void field_delete( field, wreq )
  struct Field *field;
  struct IOStdReq *wreq;
{
  void strcpy();  /* standard C library */

  if (field->NumChars) {
    if (field->UndoBuffer)
      strcpy( field->UndoBuffer, field->Buffer );
    *(field->Buffer) = '\0';
    cursor_jump_left( wreq, field->BufferPos );
    con_char_mult_delete( wreq, field->NumChars );
    field->BufferPos = 0;
    field->NumChars = 0;
  }
  else
    FLASH_SCREEN;
}
