/***************************************
*  FIELD DELETE BACKWARD v1.11
*  © Copyright 1988 Timm Martin
*  All Rights Reserved
****************************************/

#include <exec/io.h>
#include <exec/types.h>
#include <console/console.h>
#include <console/fields.h>
#include <console/functions.h>
#include <toolkit/toolkit.h>

void field_delete_backward( field, wreq )
  struct Field *field;
  struct IOStdReq *wreq;
{
  REG int i;

  if (field->BufferPos) {
    cursor_jump_left( wreq, field->BufferPos );
    con_char_mult_delete( wreq, field->BufferPos );
    for (i = 0; i < field->NumChars - field->BufferPos; i++)
      *(field->Buffer + i) = *(field->Buffer + i + field->BufferPos);
    for ( ; i < field->NumChars; i++)
      *(field->Buffer + i) = '\0';
    field->NumChars -= field->BufferPos;
    field->BufferPos = 0;
  }
  else
    FLASH_SCREEN;
}
