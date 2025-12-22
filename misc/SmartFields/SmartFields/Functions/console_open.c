/***************************************
*  CONSOLE OPEN v1.03
*  © Copyright 1988 Timm Martin
*  All Rights Reserved
****************************************/

#include <exec/io.h>
#include <exec/ports.h>
#include <intuition/intuition.h>
#include <console/console.h>
#include <console/functions.h>

int console_open( window, header, buffer )
  struct Window *window;
  struct ConsoleHeader *header;
  UBYTE  *buffer;
{
  struct MsgPort *CreatePort();    /* exec.library */
  struct IOStdReq *CreateStdIO();  /* exec.library */

  header->Window   = window;
  header->Buffer   = buffer;
  header->TypeMode = DEFAULT_TYPE_MODE;

  if (!(header->WritePort = CreatePort( "console.write", 0L )))
    return (CONSOLE_EXIT_WPORT);
  if (!(header->WriteReq = CreateStdIO( header->WritePort )))
    return (CONSOLE_EXIT_WREQ);
  if (!(header->ReadPort = CreatePort( "console.read", 0L )))
    return (CONSOLE_EXIT_RPORT);
  if (!(header->ReadReq = CreateStdIO( header->ReadPort )))
    return (CONSOLE_EXIT_RREQ);
  header->ConsoleError = con_open( window, header->WriteReq, header->ReadReq );
  if (header->ConsoleError)
    return (CONSOLE_EXIT_CONSOLE);

  con_read( header->ReadReq, header->Buffer );  /* "prime" the buffer */

  return (CONSOLE_OPEN_OK);
}
