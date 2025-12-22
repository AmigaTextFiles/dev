/***************************************
*  CONSOLE INPUT v1.23
*  © Copyright 1988 Timm Martin
*  All Rights Reserved
****************************************/

#include <exec/io.h>
#include <exec/types.h>
#include <console/console.h>
#include <console/functions.h>

int console_input( header )
  struct ConsoleHeader *header;
{
  ULONG actual;      /* actual number of characters read from console */
  UBYTE hold;        /* temporary character storage */
  int   where;       /* character in buffer being examined */

  actual = con_read( header->ReadReq, header->Buffer );
  if (!actual)
    return (0);  /* no characters read */
  else
    where = 0;   /* start at beginning of buffer */

  /* if read printable character */
  if ((header->Buffer[where] >= 0x20 && header->Buffer[where] <= 0x7E) ||
      (header->Buffer[where] >= 0xA0 && header->Buffer[where] <= 0xFF))
    /* if input is masked */
    if (header->Mask) {
      /* if acceptable input character */
        if ((header->Mask->Element[header->Buffer[where]>>5]) &
            (MASK_ENABLE << (header->Buffer[where] % 32 )))
          return (header->Buffer[where]);
        else
          return (0);
    }
    else
      return (header->Buffer[where]);

  else if (header->Buffer[where] == BACKSPACE_CODE)
    return (CON_BACKSPACE);
  else if (header->Buffer[where] == RETURN_CODE)
    return (CON_RETURN);
  else if (header->Buffer[where] == DELETE_CODE)
    return (CON_DELETE);
  else if (header->Buffer[where] == TAB_CODE)
    return (CON_TAB);
  else if (header->Buffer[where] == ESCAPE_CODE)
    return (CON_ESCAPE);

  else if ((hold = header->Buffer[where] | CONTROL_CODE) >= ' ' && hold <= '~')
    return (CON_CONTROL + hold);              /* return control key */

  else if (header->Buffer[where] == CSI) {

    if (actual == 1)
      return (CON_ALT_ESCAPE);

    if (header->Buffer[++where] >= '0' && header->Buffer[where] <= '9') {
      if (header->Buffer[where+1] == '~')
        /* function keys F1-F10 */
        return (CON_F + header->Buffer[where] - '0' + 1);
      else if (header->Buffer[where+1] >= '0' &&
               header->Buffer[where+1] <= '9' &&
               header->Buffer[where+2] == '~')
        /* shifted F1-F10 */
        return (CON_SHIFT_F + header->Buffer[where+1] - '0' + 1);
    }   /* if receiving function key input */

    else {
      switch (header->Buffer[where]) {
        case 'A': return (CON_CURSOR_UP); break;
        case 'B': return (CON_CURSOR_DOWN); break;
        case 'C': return (CON_CURSOR_RIGHT); break;
        case 'D': return (CON_CURSOR_LEFT); break;
        case ' ': if (header->Buffer[++where] == '@')
                    return (CON_SHIFT_RIGHT);
                  else if (header->Buffer[where] == 'A')
                    return (CON_SHIFT_LEFT);
                  break;
        case 'T': return (CON_SHIFT_UP); break;
        case 'S': return (CON_SHIFT_DOWN); break;
        case '?': if (header->Buffer[++where] == '~')
                    return (CON_HELP);
                  break;
        case 'Z': return (CON_SHIFT_TAB); break;
      } /* switch */
    }   /* else not function keys */
  }     /* else header->Buffer == <CSI> */

  return (0);  /* unrecognizable character */
}
