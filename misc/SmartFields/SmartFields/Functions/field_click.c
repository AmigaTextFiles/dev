/***************************************
*  FIELD CLICK v1.23
*  © Copyright 1988 Timm Martin
*  All Rights Reserved
****************************************/

#include <exec/io.h>
#include <exec/types.h>
#include <graphics/text.h>
#include <intuition/intuition.h>
#include <console/fields.h>
#include <console/functions.h>

struct Field *field_click( header, mouseX, mouseY )
  struct FieldHeader *header;
  SHORT  mouseX, mouseY;
{
  struct Field *field;        /* to step thru field list */

  field = header->FirstField;
  while (field) {
    if (header->Window->Width  > field->Right  &&
        header->Window->Height > field->Bottom &&
        mouseX >= field->Left &&
        mouseY >= field->Top  &&
        mouseX <= field->Right  - header->Window->BorderRight  &&
        mouseY <= field->Bottom - header->Window->BorderBottom &&
        field->Enabled)
      {
      header->BufferPos = (mouseX - field->Left) /
                          header->Window->IFont->tf_XSize;
      if (header->BufferPos >= field->NumChars) {
        if (field->NumChars + 1 == field->MaxChars)
          header->BufferPos = field->NumChars - 1;
        else
          header->BufferPos = field->NumChars;
      }
      return (field);
    }
    field = field->NextField;
  }
  return (NULL);  /* didn't click in any field */
}
