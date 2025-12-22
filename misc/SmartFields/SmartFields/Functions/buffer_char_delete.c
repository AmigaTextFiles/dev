/***************************************
*  BUFFER CHARacter DELETE v1.11
*  © Copyright 1988 Timm Martin
*  All Rights Reserved
****************************************/

#include <console/fields.h>
#include <console/functions.h>
#include <toolkit/toolkit.h>

void buffer_char_delete( field )
  struct Field *field;
{
  REG int i;

  for (i = field->BufferPos; i < field->NumChars; i++)
    *(field->Buffer + i) = *(field->Buffer + i + 1);
  *(field->Buffer + i) = '\0';
}
