/***************************************
*  FIELD CHARacter DELETE v1.11
*  © Copyright Timm Martin
*  All Rights Reserved
****************************************/

#include <exec/io.h>
#include <exec/types.h>
#include <console/console.h>
#include <console/fields.h>
#include <console/functions.h>

void field_char_delete( field, wreq )
  struct Field *field;
  struct IOStdReq *wreq;
{
  if (field->BufferPos < field->NumChars) {
    field->NumChars--;
    buffer_char_delete( field );
    con_char_delete( wreq );
  }
  else
    FLASH_SCREEN;
}
