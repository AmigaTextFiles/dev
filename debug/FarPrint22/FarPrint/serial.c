/* $Revision Header *** Header built automatically - do not edit! ***********
 *
 *	(C) Copyright 1992 by Torsten Jürgeleit
 *
 *	Name .....: serial.c
 *	Created ..: Monday 27-Apr-92 11:32:48
 *	Revision .: 0
 *
 *	Date        Author                 Comment
 *	=========   ====================   ====================
 *	27-Apr-92   Torsten Jürgeleit      Created this file!
 *
 ****************************************************************************
 *
 *	Functions for serial device
 *
 * $Revision Header ********************************************************/

	/* Includes */

#include "includes.h"
#include "defines.h"
#include "imports.h"
#include "protos.h"

	/* Open serial device */

   SHORT
open_serial(struct FarData  *fd)
{
   struct IOExtSer  *sio = fd->fd_SerReq;
   struct IOStdReq  *io = &sio->IOSer;
   SHORT status = STATUS_NORMAL;

   /* Init io request and open serial device */
   sio->io_SerFlags = SERIAL_OPEN_FLAGS;
   io->io_Command   = 0;
   if (OpenDevice(SERIALNAME, SERIAL_UNIT, (struct IORequest *)sio, 0L)) {
      status = ERROR_NO_SERIAL;
   } else {

      /* Set parameters for serial device */
      sio->io_TermArray.TermArray0 = SERIAL_TERM0_CHARS;
      sio->io_TermArray.TermArray1 = SERIAL_TERM1_CHARS;
      sio->io_SerFlags            |= SERIAL_SETPARAMS_FLAGS;
      io->io_Command               = SDCMD_SETPARAMS;
      if (DoIO((struct IORequest *)io)) {
	 status = ERROR_SERIAL_IO_FAILED;
      } else {

	 /* Init and send serial io request for read */
	 io->io_Command = CMD_READ;
	 io->io_Data    = (APTR)&fd->fd_SerBuffer[0];
	 io->io_Length  = SERIAL_BUFFER_SIZE;
	 SendIO((struct IORequest *)io);

	 /* Finally indicate that serial device opened sucessfully */
	 fd->fd_Flags |= FARPRINT_FLAG_SERIAL;
      }
   }
   return(show_error(fd, status));
}
	/* Close serial device */

   VOID
close_serial(struct FarData  *fd)
{
   if (fd->fd_Flags & FARPRINT_FLAG_SERIAL) {
      struct IORequest  *io = (struct IORequest *)fd->fd_SerReq;

      abort_serial(fd);
      CloseDevice(io);
      fd->fd_Flags &= ~FARPRINT_FLAG_SERIAL;
   }
}
	/* Abort pending serial io */

   VOID
abort_serial(struct FarData  *fd)
{
   struct IORequest  *io = (struct IORequest *)fd->fd_SerReq;

   if (!CheckIO(io)) {
      AbortIO(io);
      WaitIO(io);
      Remove((struct Node *)io);
   }
}
	/* Perform action appropriate to given serial request */

   SHORT
perform_serial_request(struct FarData  *fd, struct IOExtSer  *sio)
{
   struct IOStdReq  *io = &sio->IOSer;
   SHORT status = STATUS_NORMAL;

   /* First check if error occured */
   if (io->io_Error) {
      if (io->io_Error != SerErr_BufOverflow) {
	 status = ERROR_SERIAL_IO_FAILED;
      }
   } else {
      ULONG len = io->io_Actual;

      /* Mark end of text and add it to list */
      if (len && len <= SERIAL_BUFFER_SIZE) {
	 BYTE *text = &fd->fd_SerBuffer[0];

	 *(text + len - 1) = '\0';
	 status = add_text(fd, text);
      }
   }
   return(show_error(fd, status));
}
