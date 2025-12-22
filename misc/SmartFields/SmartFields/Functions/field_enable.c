/***************************************
*  FIELD ENABLE v1.01
*  © Copyright 1988 Timm Martin
*  All Rights Reserved
****************************************/

#include <console/fields.h>
#include <console/functions.h>

void field_enable( field )
  struct Field *field;
{
  field->Enabled = FIELD_ENABLED;
}
