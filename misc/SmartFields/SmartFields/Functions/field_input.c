/***************************************
*  FIELD INPUT v1.35
*  © Copyright 1988 Timm Martin
*  All Rights Reserved
****************************************/

#include <exec/io.h>
#include <exec/types.h>
#include <intuition/intuition.h>
#include <console/console.h>
#include <console/fields.h>
#include <console/functions.h>
#include <toolkit/toolkit.h>

#define CURRENT_FIELD header->CurrentField,header->WriteReq

UBYTE field__clip[FIELD_CLIP_SIZE];

int field_input( header )
  struct FieldHeader *header;
{
  ULONG actual;      /* actual number of characters read from console */
  UBYTE hold;        /* temporary character storage */
  REG   int where;   /* char in buffer being examined */

  if (!(actual = con_read( header->ReadReq, header->Buffer )))
    return (0);

  if (!header->CurrentField)
    return (FIELD_NO_CURRENT);

  /* check if entire input field is in the window */
  if (header->Window->Width  <= header->CurrentField->Right ||
      header->Window->Height <= header->CurrentField->Bottom) {
    FLASH_SCREEN;
    return (FIELD_OFF);
  }

  where  = 0;
  while (where < actual) {

    /* if read a printable character */
    if ((header->Buffer[where] >= 0x20 && header->Buffer[where] <= 0x7E) ||
        (header->Buffer[where] >= 0xA0 && header->Buffer[where] <= 0xFF)) {
      /* if field input is masked */
      if (header->CurrentField->Mask) {
        /* if acceptable input character */
        if ((header->CurrentField->Mask->Element[header->Buffer[where]>>5]) &
            (MASK_ENABLE << (header->Buffer[where] % 32)))
          field_char_type( CURRENT_FIELD, header->Buffer[where], header->TypeMode );
        else
          FLASH_SCREEN;
      }
      else
        field_char_type( CURRENT_FIELD, header->Buffer[where], header->TypeMode );
    }

    else if (header->Buffer[where] == BACKSPACE_CODE)
      field_char_backspace( CURRENT_FIELD );

    else if (header->Buffer[where] == RETURN_CODE)
      return (FIELD_RETURN);

    else if (header->Buffer[where] == DELETE_CODE)
      field_char_delete( CURRENT_FIELD );

    else if (header->Buffer[where] == TAB_CODE)
      field_tab_forward( CURRENT_FIELD );

    else if (header->Buffer[where] == ESCAPE_CODE)
      return (FIELD_ESCAPE);

    /* if control key pressed */
    else if ((hold = header->Buffer[where] | CONTROL_CODE) >= ' ' && hold <= '~') {
      switch (hold) {
        case 'x': field_delete( CURRENT_FIELD ); break;
        case 'r': field_restore( CURRENT_FIELD ); break;
        case 'd': field_dup( CURRENT_FIELD ); break;
        case 'f': field_delete_forward( CURRENT_FIELD ); break;
        case 'b': field_delete_backward( CURRENT_FIELD ); break;
        case 't': header->TypeMode = TYPEOVER_TYPE_MODE; break;
        case 'n': header->TypeMode = INSERT_TYPE_MODE; break;
        case 'k': field_cut( CURRENT_FIELD ); break;
        case 'o': field_copy( CURRENT_FIELD ); break;
        case 'p': field_paste( CURRENT_FIELD ); break;
      } /* switch control key */
    }   /* else if control key */

    else if (header->Buffer[where] == CSI) {

      if (header->Buffer[++where] >= '0' && header->Buffer[where] <= '9') {
        /* function keys 1-10 */
        if (header->Buffer[where+1] == '~')
          return (CON_F + header->Buffer[where++] - '0' + 1);
        /* shifted F1-F10 */
        else if (header->Buffer[where+1] >= '0' &&
                 header->Buffer[where+1] <= '9' &&
                 header->Buffer[where+2] == '~') {
            return (CON_SHIFT_F + header->Buffer[where+1] - '0' + 1);
            where += 2;
        } /* else if shifted function key */
      }   /* if receiving function key input */

      else {
        switch (header->Buffer[where]) {
          case 'A': return (FIELD_PREVIOUS); break;
          case 'B': return (FIELD_NEXT); break;
          case 'C': field_cursor_right( CURRENT_FIELD ); break;
          case 'D': field_cursor_left( CURRENT_FIELD ); break;
          case ' ': if (header->Buffer[++where] == '@')
                      field_right( CURRENT_FIELD );
                    else if (header->Buffer[where] == 'A')
                      field_left( CURRENT_FIELD );
                    break;
          case 'T': return (FIELD_FIRST); break;
          case 'S': return (FIELD_FINAL); break;
          case '?': if (header->Buffer[++where] == '~')
                      return (FIELD_HELP);
                    break;
          case 'Z': field_tab_backward( CURRENT_FIELD ); break;
        } /* switch */
      }   /* else not function keys */
    }     /* else buffer == <CSI> */

    where++;
  } /* while have not exhausted buffer */

  return (FIELD_SWALLOW);
  /* input swallowed into field; no response required from calling program */
}
