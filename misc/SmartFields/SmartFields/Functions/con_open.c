/***************************************
*  CONsole OPEN v1.13
*  © Copyright Timm Martin
*  All Rights Reserved
****************************************/

#include <exec/io.h>
#include <exec/types.h>
#include <intuition/intuition.h>
#include <console/functions.h>

long con_open( window, wreq, rreq )
  struct Window *window;
  struct IOStdReq *wreq;
  struct IOStdReq *rreq;
{
  long error;         /* error in opening console */
  long OpenDevice();  /* exec.library */

  wreq->io_Data    = (APTR)window;
  wreq->io_Length  = sizeof(*window);
  error = OpenDevice( "console.device", 0L, wreq, NULL );
  rreq->io_Device  = wreq->io_Device;
  rreq->io_Unit    = wreq->io_Unit;

  return (error);
}
