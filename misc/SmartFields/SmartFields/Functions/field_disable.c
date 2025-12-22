/***************************************
*  FIELD DISABLE v1.01
*  © Copyright 1988 Timm Martin
*  All Rights Reserved
****************************************/

#include <console/fields.h>
#include <console/functions.h>

void field_disable( header, field )
  struct FieldHeader *header;
  struct Field *field;
{
  if (field == header->CurrentField) {
    header->CurrentField = NULL;
    cursor_invisible( header->WriteReq );
  }
  field->Enabled = FIELD_DISABLED;
}
