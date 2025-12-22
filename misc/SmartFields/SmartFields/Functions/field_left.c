/***************************************
*  FIELD LEFT v1.11
*  © Copyright 1988 Timm Martin
*  All Rights Reserved
****************************************/

#include <exec/io.h>
#include <exec/types.h>
#include <console/console.h>
#include <console/fields.h>
#include <console/functions.h>

void field_left( field, wreq )
  struct Field *field;
  struct IOStdReq *wreq;
{
  if (field->BufferPos) {
    cursor_jump_left( wreq, field->BufferPos );
    field->BufferPos = 0;
  }
  else
    FLASH_SCREEN;
}
