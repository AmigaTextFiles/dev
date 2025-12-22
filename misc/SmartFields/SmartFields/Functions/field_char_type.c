/***************************************
*  FIELD CHAR TYPE v1.11
*  © Copyright 1988 Timm Martin
*  All Rights Reserved
****************************************/

#include <exec/io.h>
#include <exec/types.h>
#include <console/console.h>
#include <console/fields.h>
#include <console/functions.h>

void field_char_type( field, wreq, character, mode )
  struct Field *field;
  struct IOStdReq *wreq;
  UBYTE  character;
  int    mode;
{
  if (mode == INSERT_TYPE_MODE) {
    if (field->NumChars + 1 < field->MaxChars) {
      buffer_char_insert( field );
      *(field->Buffer + field->BufferPos) = character;
      con_char_insert( wreq );
      con_put_char( wreq, character );
      field->NumChars++;
      if (field->BufferPos + 2 < field->MaxChars)
        field->BufferPos++;
      else
        cursor_left( wreq );
    }
    else
      FLASH_SCREEN;
  }
  else {  /* TYPEOVER_TYPE_MODE assumed */
    *(field->Buffer + field->BufferPos) = character;
    con_put_char( wreq, character );
    if (field->BufferPos == field->NumChars) {
      field->NumChars++;
      *(field->Buffer + field->NumChars) = '\0';
    }
    if (field->BufferPos + 2 < field->MaxChars)
      field->BufferPos++;
    else
      cursor_left( wreq );
  }
}
