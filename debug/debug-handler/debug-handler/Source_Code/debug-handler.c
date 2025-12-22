/*
 * $Id$
 *
 * :ts=4
 *
 * "debug-handler"
 *
 * Copyright (C) 2004 by Olaf Barthel <olsen@sourcery.han.de>
 * All Rights Reserved
 *
 * Freely distributable
 */

#include <dos/dosextens.h>
#include <dos/filehandler.h>

#include <libraries/iffparse.h>

#include <resources/filesysres.h>

#include <clib/alib_protos.h>
#include <clib/debug_protos.h>

/****************************************************************************/

#define __NOLIBBASE__
#include <proto/exec.h>
#include <proto/dos.h>

/****************************************************************************/

#include <string.h>

/****************************************************************************/

#define NOT !
#define OK (0)

/****************************************************************************/

const char version_tag[] = "$VER: debug-handler 51.1 (16.7.2004)\r\n";

/****************************************************************************/

void
_start(void)
{
	struct Library *SysBase = *(struct Library **)4;
	struct Library *DOSBase;
	struct Process * this_process = (struct Process *)FindTask(NULL);
	struct MsgPort * process_port = &this_process->pr_MsgPort;
	struct DeviceNode *device_node;
	struct Message * message;
	struct DosPacket *packet;
	struct MsgPort * reply_port;
	LONG result,error;
	ULONG num_open_files = 0;
	BOOL done = FALSE;

	/* We need Kickstart 2.04 or something better. */
	DOSBase = OpenLibrary("dos.library",37);
	if(DOSBase == NULL)
	{
		/* For some reasons dos.library didn't open. So we'll have
		   to return the startup message indicating failure. */
		WaitPort(process_port);
		message = GetMsg(process_port);

		/* This is the startup message. */
		packet = (struct DosPacket *)message->mn_Node.ln_Name;

		/* Indicate failure. */
		packet->dp_Res1 = DOSFALSE;
		packet->dp_Res2 = ERROR_INVALID_RESIDENT_LIBRARY;

		goto out;
	}

	/* Wait for the startup message. */
	packet = WaitPkt();

	/* This file system's device node is stored in argument #3. */
	device_node = (struct DeviceNode *)BADDR(packet->dp_Arg3);

	/* Install this process' MsgPort so that we stay the only
	   file system of this type. */
	device_node->dn_Task = process_port;

	/* Return the startup packet (done below) indicating success. */
	result	= DOSTRUE;
	error	= OK;

	do
	{
		/* Return the previous packet. */
		ReplyPkt(packet,result,error);

		/* Wait for the next packet to arrive and pick it up. */
		packet = WaitPkt();

		/* Use defaults for the packet return codes. */
		result	= DOSFALSE;
		error	= OK;

		switch(packet->dp_Type)
		{
			/* This is not a file system. */
			case ACTION_IS_FILESYSTEM:

				result = DOSFALSE;
				break;

			/* Open a new I/O stream? */
			case ACTION_FINDINPUT:
			case ACTION_FINDOUTPUT:
			case ACTION_FINDUPDATE:

				/* We have one more customer. */
				num_open_files++;

				result = DOSTRUE;
				break;

			/* You can't read from the debug stream. */
			case ACTION_READ:

				result = 0;
				break;

			/* Everything you send to this file system will come
			   out on the default debug output interface. */
			case ACTION_WRITE:

				/* Do we have anything to send? */
				if(packet->dp_Arg3 != 0)
				{
					UBYTE * buffer = (UBYTE *)packet->dp_Arg2;
					LONG len;

					/* A negative length indicates that the buffer
					   points to a NUL terminated string. */
					if(packet->dp_Arg3 < 0)
					{
						UBYTE c;

						len = 0;

						while((c = (*buffer++)) != '\0')
						{
							kputc(c);
							len++;
						}

						result = len;
					}
					else
					{
						len = packet->dp_Arg3;

						result = len;

						while(len-- > 0)
							kputc(*buffer++);
					}
				}
				else
				{
					result = 0;
				}

				break;

			/* Close the file handle. */
			case ACTION_END:

				if(num_open_files > 0)
					num_open_files--;

				result = DOSTRUE;
				break;

			/* If possible, shut down. */
			case ACTION_DIE:

				/* We can't leave until the last user has closed
				   his file handle. */
				if(num_open_files > 0)
				{
					error = ERROR_OBJECT_IN_USE;
					break;
				}

				/* Indicate success. */
				packet->dp_Res1 = DOSTRUE;
				packet->dp_Res2 = OK;

				Forbid();

				/* This will, at worst, restart this file system when the
				   next packet comes in. */
				device_node->dn_Task = NULL;

				/* Return all pending packets unanswered. */	
				while((message = GetMsg(process_port)) != NULL)
					ReplyPkt((struct DosPacket *)message->mn_Node.ln_Name,DOSFALSE,ERROR_ACTION_NOT_KNOWN);

				/* And we're finished. */
				done = TRUE;
				break;

			/* We don't support any other packet types. */
			default:

				error = ERROR_ACTION_NOT_KNOWN;
				break;
		}
	}
	while(NOT done);

 out:

	/* Close the library, if it's open, and we're almost finished. */
	if(DOSBase != NULL)
		CloseLibrary(DOSBase);

	/* Remember the reply port, we will need it in a minute. */
	reply_port = packet->dp_Port;

	/* Clear the return port, this file system is going down. */
	packet->dp_Port = NULL;

	/* Return the last packet, and we're finished. */
	PutMsg(reply_port,packet->dp_Link);
}
