/***************************************
*  FIELD CURSOR RIGHT v1.11
*  © Copyright 1988 Timm Martin
*  All Rights Reserved
****************************************/

#include <exec/io.h>
#include <exec/types.h>
#include <console/console.h>
#include <console/fields.h>
#include <console/functions.h>

void field_cursor_right( field, wreq )
  struct Field *field;
  struct IOStdReq *wreq;
{
  if ((field->BufferPos + 2 < field->MaxChars) &&
      (field->BufferPos < field->NumChars)) {
    field->BufferPos++;
    cursor_right( wreq );
  }
  else
    FLASH_SCREEN;
}
