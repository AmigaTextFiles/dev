/***************************************
*  FIELD TAB FORWARD v1.11
*  © Copyright 1988 Timm Martin
*  All Rights Reserved
****************************************/

#include <exec/io.h>
#include <exec/types.h>
#include <console/console.h>
#include <console/fields.h>
#include <console/functions.h>

void field_tab_forward( field, wreq )
  struct Field *field;
  struct IOStdReq *wreq;
{
  int jump;  /* jump size */

  if ((field->BufferPos + 2 < field->MaxChars) &&
      (field->BufferPos < field->NumChars)) {
    if (field->NumChars + 1 == field->MaxChars) {
      if (field->BufferPos + TAB_JUMP < field->NumChars)
        jump = TAB_JUMP;
      else
        jump = field->NumChars - field->BufferPos - 1;
    }
    else {
      if (field->BufferPos + TAB_JUMP <= field->NumChars)
        jump = TAB_JUMP;
      else
        jump = field->NumChars - field->BufferPos;
    }
    cursor_jump_right( wreq, jump );
    field->BufferPos += jump;
  }
  else
    FLASH_SCREEN;
}
