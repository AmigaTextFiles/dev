/***************************************
*  FIELD DUPlicate v1.12
*  © Copyright 1988 Timm Martin
*  All Rights Reserved
****************************************/

#include <exec/io.h>
#include <exec/types.h>
#include <console/console.h>
#include <console/fields.h>
#include <console/functions.h>

void field_dup( field, wreq )
  struct Field *field;
  struct IOStdReq *wreq;
{
  int  dup_length;              /* to save length of DupBuffer */
  void strcpy();                /* standard C library */
  int  strlen();                /* standard C library */

  if (field->DupBuffer) {
    dup_length = strlen( field->DupBuffer );
    if (dup_length) {
      cursor_jump_left( wreq, field->BufferPos );
      con_char_mult_delete( wreq, field->NumChars );
      strcpy( field->Buffer, field->DupBuffer );
      field->NumChars = dup_length;
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
