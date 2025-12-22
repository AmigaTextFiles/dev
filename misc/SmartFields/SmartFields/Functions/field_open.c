/***************************************
*  FIELD OPEN v1.07
*  © Copyright 1988 Timm Martin
*  All Rights Reserved
****************************************/

#include <exec/io.h>
#include <exec/ports.h>
#include <intuition/intuition.h>
#include <console/console.h>
#include <console/fields.h>
#include <console/functions.h>

int field_open( window, header, initial, final, buffer )
  struct Window *window;
  struct FieldHeader *header;
  struct Field *initial;
  struct Field *final;
  UBYTE  *buffer;
{
  struct MsgPort *CreatePort();    /* exec.library */
  struct IOStdReq *CreateStdIO();  /* exec.library */

  header->Window       = window;
  header->Buffer       = buffer;
  header->TypeMode     = DEFAULT_TYPE_MODE;
  header->FirstField   = field_link( final );
  header->FinalField   = final;
  header->CurrentField = initial;

  if (!(header->WritePort = CreatePort( "field.write", 0L )))
    return (FIELD_EXIT_WPORT);
  if (!(header->WriteReq = CreateStdIO( header->WritePort )))
    return (FIELD_EXIT_WREQ);
  if (!(header->ReadPort = CreatePort( "field.read", 0L )))
    return (FIELD_EXIT_RPORT);
  if (!(header->ReadReq = CreateStdIO( header->ReadPort )))
    return (FIELD_EXIT_RREQ);
  header->ConsoleError = con_open( window, header->WriteReq, header->ReadReq );
  if (header->ConsoleError)
    return (FIELD_EXIT_CONSOLE);

  cursor_invisible( header->WriteReq );
  con_read( header->ReadReq, header->Buffer );  /* "prime" the buffer */

  return (FIELD_OPEN_OK);
}
