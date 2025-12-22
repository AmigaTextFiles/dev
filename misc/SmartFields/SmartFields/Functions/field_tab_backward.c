/***************************************
*  FIELD TAB BACKWARD v1.11
*  © Copyright 1988 Timm Martin
*  All Rights Reserved
****************************************/

#include <exec/io.h>
#include <exec/types.h>
#include <console/console.h>
#include <console/fields.h>
#include <console/functions.h>

void field_tab_backward( field, wreq )
  struct Field *field;
  struct IOStdReq *wreq;
{
  int jump;  /* jump size */

  if (field->BufferPos) {
    if (field->BufferPos + 1 > TAB_JUMP)
      jump = TAB_JUMP;
    else
      jump = field->BufferPos;
    cursor_jump_left( wreq, jump );
    field->BufferPos -= jump;
  }
  else
    FLASH_SCREEN;
}
