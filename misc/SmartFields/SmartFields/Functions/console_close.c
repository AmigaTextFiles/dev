/***************************************
*  CONSOLE CLOSE v1.01
*  © Copyright 1988 Timm Martin
*  All Rights Reserved
****************************************/

#include <console/console.h>
#include <console/functions.h>

void console_close( header )
  struct ConsoleHeader *header;
{
  void CloseDevice();  /* exec.library (CLOSE_CONSOLE) */
  void DeletePort();   /* exec.library */
  void DeleteStdIO();  /* exec.library */

  if (!header->ConsoleError) {
    CLOSE_CONSOLE( header->WriteReq );
    header->ConsoleError = CONSOLE_ERROR;
  }
  if (header->ReadReq) {
    DeleteStdIO( header->ReadReq );
    header->ReadReq = NULL;
  }
  if (header->ReadPort) {
    DeletePort( header->ReadPort );
    header->ReadPort = NULL;
  }
  if (header->WriteReq) {
    DeleteStdIO( header->WriteReq );
    header->WriteReq = NULL;
  }
  if (header->WritePort) {
    DeletePort( header->WritePort );
    header->WritePort = NULL;
  }
}
