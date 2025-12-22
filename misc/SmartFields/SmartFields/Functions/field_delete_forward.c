/***************************************
*  FIELD DELETE FORWARD v1.11
*  © Copyright 1988 Timm Martin
*  All Rights Reserved
****************************************/

#include <exec/io.h>
#include <exec/types.h>
#include <console/console.h>
#include <console/fields.h>
#include <console/functions.h>
#include <toolkit/toolkit.h>

void field_delete_forward( field, wreq )
  struct Field *field;
  struct IOStdReq *wreq;
{
  REG int i;

  if (field->BufferPos < field->NumChars) {
    con_char_mult_delete( wreq, field->NumChars - field->BufferPos );
    for (i = field->BufferPos; i < field->NumChars; i++)
      *(field->Buffer + i) = '\0';
    field->NumChars = field->BufferPos;
  }
  else
    FLASH_SCREEN;
}
