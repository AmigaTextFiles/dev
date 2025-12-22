/***************************************
*  FIELD PASTE v1.02
*  © Copyright 1988 Timm Martin
*  All Rights Reserved
****************************************/

#include <exec/io.h>
#include <exec/types.h>
#include <console/console.h>
#include <console/fields.h>
#include <console/functions.h>
#include <toolkit/toolkit.h>

void field_paste( field, wreq )
  struct Field *field;
  struct IOStdReq *wreq;
{
  extern UBYTE field__clip[];  /* defined in field_input() */
  REG    int i;

  if (field__clip[0]) {
    cursor_jump_left( wreq, field->BufferPos );
    con_char_mult_delete( wreq, field->NumChars );
    for (i = 0; i < field->MaxChars - 1 && field__clip[i]; i++)
      *(field->Buffer + i) = field__clip[i];
    *(field->Buffer + i) = '\0';
    field->NumChars = i;
    con_put_string( wreq, field->Buffer );
    cursor_jump_left( wreq, field->NumChars );
    field->BufferPos = 0;
  }
  else
    FLASH_SCREEN;
}
