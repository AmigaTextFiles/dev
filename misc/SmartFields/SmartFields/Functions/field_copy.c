/***************************************
*  FIELD COPY v1.01
*  © Copyright 1988 Timm Martin
*  All Rights Reserved
****************************************/

#include <exec/io.h>
#include <exec/types.h>
#include <console/console.h>
#include <console/fields.h>
#include <console/functions.h>
#include <toolkit/toolkit.h>

void field_copy( field, wreq )
  struct Field *field;
  struct IOStdReq *wreq;
{
  extern UBYTE field__clip[];  /* defined in field_input() */
  REG    int i;
  int    max;

  max = MAX( field->NumChars, FIELD_CLIP_SIZE );
  if (field->NumChars) {
    for (i = 0; i < max; i++)
      field__clip[i] = *(field->Buffer + i);
    field__clip[i] = '\0';
  }
  else
    FLASH_SCREEN;
}
