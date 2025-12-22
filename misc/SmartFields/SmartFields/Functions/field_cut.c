/***************************************
*  FIELD CUT v1.01
*  © Copyright 1988 Timm Martin
*  All Rights Reserved
****************************************/

#include <exec/io.h>
#include <exec/types.h>
#include <console/console.h>
#include <console/fields.h>
#include <console/functions.h>
#include <toolkit/toolkit.h>

void field_cut( field, wreq )
  struct Field *field;
  struct IOStdReq *wreq;
{
  if (field->NumChars) {
    field_copy( field, wreq );
    field_delete( field, wreq );
  }
  else
    FLASH_SCREEN;
}
