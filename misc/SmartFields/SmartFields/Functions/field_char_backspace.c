/***************************************
*  FIELD CHARacter BACKSPACE v1.11
*  © Copyright 1988 Timm Martin
*  All Rights Reserved
****************************************/

#include <exec/io.h>
#include <exec/types.h>
#include <console/console.h>
#include <console/fields.h>
#include <console/functions.h>

void field_char_backspace( field, wreq )
  struct Field *field;
  struct IOStdReq *wreq;
{
  if (field->BufferPos) {
    field->BufferPos--;
    field->NumChars--;
    buffer_char_delete( field );
    con_char_backspace( wreq );
  }
  else
    FLASH_SCREEN;
}
