/***************************************
*  FIELD RIGHT v1.11
*  © Copyright 1988 Timm Martin
*  All Rights Reserved
****************************************/

#include <exec/io.h>
#include <exec/types.h>
#include <console/console.h>
#include <console/fields.h>
#include <console/functions.h>

void field_right( field, wreq )
  struct Field *field;
  struct IOStdReq *wreq;
{
  int  hold;                 /* temporary variable */

  if ((field->BufferPos + 2 < field->MaxChars) &&
      (field->BufferPos < field->NumChars)) {
    if (field->NumChars + 1 == field->MaxChars)
      hold = field->NumChars - 1;
    else
      hold = field->NumChars;
    cursor_jump_right( wreq, hold - field->BufferPos );
    field->BufferPos = hold;
  }
  else
    FLASH_SCREEN;
}
