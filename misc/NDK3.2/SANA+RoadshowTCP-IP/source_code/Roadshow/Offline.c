/*
 * "Roadshow" Amiga TCP/IP stack
 *
 * :ts=4
 *
 * Copyright © 2001-2019 by Olaf Barthel. All Rights Reserved.
 */

/*****************************************************************************/

#define __USE_OLD_TIMEVAL__
#include <devices/timer.h>

/****************************************************************************/

#include <dos/dosextens.h>
#include <dos/dosasl.h>
#include <dos/dostags.h>
#include <dos/rdargs.h>
#include <dos/stdio.h>

#include <exec/memory.h>

#include <devices/sana2.h>

/*****************************************************************************/

#include <clib/alib_protos.h>

/*****************************************************************************/

#define __NOLIBBASE__
#define __NOGLOBALIFACE__
#define __USE_INLINE__

/*****************************************************************************/

#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/timer.h>

/*****************************************************************************/

#include <string.h>
#include <stdarg.h>
#include <stddef.h>

/****************************************************************************/

#include "Offline_rev.h"
TEXT Version[] = VERSTAG;

/****************************************************************************/

#include "macros.h"

/****************************************************************************/

/*#define DEBUG*/
#include "assert.h"

/****************************************************************************/

#if defined(__amigaos4__)
#define VAR_ARGS __attribute__((linearvarargs))
#else
#define VAR_ARGS
#endif /* __amigaos4__ */

/****************************************************************************/

extern struct Library *		SysBase;
extern struct Library *		DOSBase;

/****************************************************************************/

#if defined(__amigaos4__)

extern struct ExecIFace *	IExec;
extern struct DOSIFace *	IDOS;

#endif /* __amigaos4__ */

/****************************************************************************/

struct MsgPort *		TimePort;
struct timerequest * 	TimeRequest;
BOOL					TimeRequestPending;
LONG					Timeout;

/****************************************************************************/

struct RDArgs * read_args;

/****************************************************************************/

struct MsgPort *	NetPort;
struct IOSana2Req *	NetRequest;
struct IOSana2Req *	NetEventRequest;
BOOL				NetEventRequestPending;

/****************************************************************************/

STRPTR	NetDeviceName;
LONG	NetDeviceUnit;

/****************************************************************************/

STRPTR get_io_error_string(LONG error, UBYTE *buffer);
STRPTR get_wire_error_string(LONG error, UBYTE *buffer);
VOID VAR_ARGS local_sprintf(STRPTR buffer, STRPTR formatString, ...);
VOID cleanup(void);
BOOL setup(void);

/****************************************************************************/

/* Return a descriptive text for an I/O error code returned by a
 * SANA-II device.
 */
STRPTR
get_io_error_string(LONG error,UBYTE * buffer)
{
	STATIC struct { LONG val; STRPTR str; } tab[] =
	{
		{ IOERR_OPENFAIL,		"Device/unit failed to open" },
		{ IOERR_ABORTED,		"Request terminated early" },
		{ IOERR_NOCMD,			"Command not supported by device" },
		{ IOERR_BADLENGTH,		"Not a valid length" },
		{ IOERR_BADADDRESS,		"Invalid address" },
		{ IOERR_UNITBUSY,		"Device opens OK, but requested unit is busy" },
		{ IOERR_SELFTEST,		"Hardware failed self-test" },

		{ S2ERR_NO_RESOURCES,	"Resource allocation failure" },
		{ S2ERR_BAD_ARGUMENT,	"Bad argument" },
		{ S2ERR_BAD_STATE,		"Inappropriate state" },
		{ S2ERR_BAD_ADDRESS,	"Bad address" },
		{ S2ERR_MTU_EXCEEDED,	"Maximum transmission unit exceeded" },
		{ S2ERR_NOT_SUPPORTED,	"Command not supported by hardware" },
		{ S2ERR_SOFTWARE,		"Software error detected" },
		{ S2ERR_OUTOFSERVICE,	"Driver is offline" },
		{ S2ERR_TX_FAILURE,		"Transmission attempt failed" }
	};

	LONG i,n;

	n = -1;
	for(i = 0 ; i < (LONG)NUM_ENTRIES(tab) ; i++)
	{
		if(tab[i].val == error)
		{
			n = i;
			break;
		}
	}

	if(n != -1)
	{
		strcpy(buffer,tab[n].str);
	}
	else
	{
		if(error < 0)
			local_sprintf(buffer,"Unknown I/O error %ld",error);
		else
			local_sprintf(buffer,"Unknown SANA-II error %ld",error);
	}

	return(buffer);
}

/****************************************************************************/

/* Return a descriptive text for an wire error code returned
 * by a SANA-II device.
 */
STRPTR
get_wire_error_string(LONG error,UBYTE * buffer)
{
	STATIC struct { LONG val; STRPTR str; } tab[] =
	{
		{ S2WERR_GENERIC_ERROR,		"No specific information available" },
		{ S2WERR_NOT_CONFIGURED,	"Unit is not configured" },
		{ S2WERR_UNIT_ONLINE,		"Unit is currently online" },
		{ S2WERR_UNIT_OFFLINE,		"Unit is currently offline" },
		{ S2WERR_ALREADY_TRACKED,	"Protocol is already tracked" },
		{ S2WERR_NOT_TRACKED,		"Protocol is not tracked" },
		{ S2WERR_BUFF_ERROR,		"Buffer management function returned an error" },
		{ S2WERR_SRC_ADDRESS,		"Source address problem" },
		{ S2WERR_DST_ADDRESS,		"Destination address problem" },
		{ S2WERR_BAD_BROADCAST,		"Broadcast address problem" },
		{ S2WERR_BAD_MULTICAST,		"Multicast address problem" },
		{ S2WERR_MULTICAST_FULL,	"Multicast address list is full" },
		{ S2WERR_BAD_EVENT,			"Unsupported event class" },
		{ S2WERR_BAD_STATDATA,		"StatData failed sanity check" },
		{ S2WERR_IS_CONFIGURED,		"Attempted to configure twice" },
		{ S2WERR_NULL_POINTER,		"NULL pointer detected" },
		{ S2WERR_TOO_MANY_RETRIES,	"Transmission failed - too many retries" },
		{ S2WERR_RCVREL_HDW_ERR,	"Driver fixable hardware error" }
	};

	LONG i,n;

	n = -1;
	for(i = 0 ; i < (LONG)NUM_ENTRIES(tab) ; i++)
	{
		if(tab[i].val == error)
		{
			n = i;
			break;
		}
	}

	if(n != -1)
		strcpy(buffer,tab[n].str);
	else
		local_sprintf(buffer,"Unknown wire error %ld",error);

	return(buffer);
}

/****************************************************************************/

VOID VAR_ARGS
local_sprintf(STRPTR buffer, STRPTR formatString,...)
{
	va_list varArgs;

	#if defined(__amigaos4__)
	{
		va_startlinear(varArgs,formatString);
		RawDoFmt(formatString,va_getlinearva(varArgs, APTR),NULL,buffer);
		va_end(varArgs);
	}
	#else
	{
		va_start(varArgs,formatString);
		RawDoFmt(formatString,varArgs,(VOID (*)())"\x16\xC0\x4E\x75",buffer);
		va_end(varArgs);
	}
	#endif /* __amigaos4__ */
}

/****************************************************************************/

VOID
cleanup(void)
{
	if(NetEventRequestPending)
	{
		if(CheckIO((struct IORequest *)NetEventRequest) == BUSY)
			AbortIO((struct IORequest *)NetEventRequest);

		WaitIO((struct IORequest *)NetEventRequest);
		NetEventRequestPending = FALSE;
	}

	if(NetRequest != NULL)
	{
		if(NetRequest->ios2_Req.io_Device != NULL)
			CloseDevice((struct IORequest *)NetRequest);

		DeleteIORequest((struct IORequest *)NetRequest);
		NetRequest = NULL;
	}

	if(NetPort != NULL)
	{
		DeleteMsgPort(NetPort);
		NetPort = NULL;
	}

	if(TimeRequestPending)
	{
		if(CheckIO((struct IORequest *)TimeRequest) == BUSY)
			AbortIO((struct IORequest *)TimeRequest);

		WaitIO((struct IORequest *)TimeRequest);
		TimeRequestPending = FALSE;
	}

	if(TimeRequest != NULL)
	{
		if(TimeRequest->tr_node.io_Device != NULL)
			CloseDevice((struct IORequest *)TimeRequest);

		DeleteIORequest((struct IORequest *)TimeRequest);
		TimeRequest = NULL;
	}

	if(TimePort != NULL)
	{
		DeleteMsgPort(TimePort);
		TimePort = NULL;
	}

	if(read_args != NULL)
	{
		FreeArgs(read_args);
		read_args = NULL;
	}
}

/****************************************************************************/

BOOL
setup(void)
{
	struct
	{
		STRPTR	Name;
		LONG *	Unit;
		LONG *	Timeout;
	} args_list;

	STRPTR full_path_name = NULL;
	BOOL success = FALSE;
	LONG error;

	if(SysBase->lib_Version < 36)
		goto out;

	memset(&args_list,0,sizeof(args_list));

	read_args = ReadArgs("NAME/A,UNIT/N,TIMEOUT/N",(LONG *)&args_list,NULL);
	if(read_args == NULL)
	{
		PrintFault(IoErr(),"Offline");
		goto out;
	}

	NetDeviceName = args_list.Name;

	if(args_list.Unit != NULL)
		NetDeviceUnit = (*args_list.Unit);

	if(args_list.Timeout != NULL)
		Timeout = (*args_list.Timeout);

	TimePort = CreateMsgPort();
	if(TimePort == NULL)
	{
		Printf("%s: Could not create timer message port.\n", "Offline");
		goto out;
	}

	TimeRequest = (struct timerequest *)CreateIORequest(TimePort,sizeof(*TimeRequest));
	if(TimeRequest == NULL)
	{
		Printf("%s: Could not create timer I/O request.\n", "Offline");
		goto out;
	}

	if(OpenDevice(TIMERNAME,UNIT_VBLANK,(struct IORequest *)TimeRequest,0) != OK)
	{
		Printf("%s: Could not open 'timer.device'.\n", "Offline");
		goto out;
	}

	NetPort = CreateMsgPort();
	if(NetPort == NULL)
	{
		Printf("%s: Could not create net I/O message port.\n", "Offline");
		goto out;
	}

	NetRequest = (struct IOSana2Req *)CreateIORequest(NetPort,sizeof(*NetRequest));
	NetEventRequest = (struct IOSana2Req *)CreateIORequest(NetPort,sizeof(*NetEventRequest));

	if(NetRequest == NULL || NetEventRequest == NULL)
	{
		Printf("%s: Could not create net I/O request.\n", "Offline");
		goto out;
	}

	error = OpenDevice(NetDeviceName,NetDeviceUnit,(struct IORequest *)NetRequest,0);

	if(error == IOERR_OPENFAIL && FilePart(NetDeviceName) == NetDeviceName)
	{
		STRPTR prefix = "DEVS:Networks/";

		full_path_name = AllocVec(strlen(prefix)+strlen(NetDeviceName)+1,MEMF_ANY);
		if(full_path_name == NULL)
		{
			PrintFault(ERROR_NO_FREE_STORE,"Offline");
			goto out;
		}

		local_sprintf(full_path_name,"%s%s",prefix,NetDeviceName);

		error = OpenDevice(full_path_name,NetDeviceUnit,(struct IORequest *)NetRequest,0);
	}

	if(error != OK)
	{
		UBYTE io_error_string[100];

		Printf("%s: Could not open '%s', unit %ld (%ld, %s).\n",
			"Offline",NetDeviceName,NetDeviceUnit,error,get_io_error_string(error,io_error_string));

		goto out;
	}

	(*NetEventRequest) = (*NetRequest);
	NetEventRequest->ios2_Req.io_Message.mn_Node.ln_Type = NT_REPLYMSG;

	success = TRUE;

 out:

	if(full_path_name != NULL)
		FreeVec(full_path_name);

	return(success);
}

/****************************************************************************/

/****** ROADSHOW/OFFLINE *****************************************************
*
*   NAME
*	Offline - Attempt to take a network device driver offline
*
*   FORMAT
*	Offline <Device driver name> [UNIT=<Unit number>] [TIMEOUT=<Seconds>]
*
*   TEMPLATE
*	NAME/A,UNIT/N,TIMEOUT/N
*
*   PATH
*	C:Offline
*
*   FUNCTION
*	The "Offline" command attempts to take a network device driver offline.
*	This may be necessary to perform hardware diagnostics, for example.
*
*   OPTIONS
*	NAME/A
*	    The name of the SANA-II standard compliant network device
*	    driver, e.g. "ariadne.device".
*
*	UNIT/N
*	    The number of the device unit, e.g. 0 for the first network
*       interface managed by the device driver, 1 for the second,
*	    etc. The unit number defaults to 0.
*
*	TIMEOUT/N
*	    How many seconds to wait for the device unit to go offline
*	    before the attempt is aborted. The timeout defaults
*	    to 0, which means that the "Offline" command will wait forever
*	    for the the device unit to go offline.
*
*   NOTES
*	You may use the "Break" command or press the [Ctrl]+C keys to
*	abort the "Offline" command while it is waiting for the device
*	unit to go offline.
*
*	When the "Offline" command exits, the return code will indicate
*	error, warning or success which you may use in script files
*	to test for the outcome of the process.
*
*   EXAMPLES
*	Take the "a2065.device" offline, if possible; wait for up
*	to 5 seconds for it be offline:
*
*	    1> Offline a2065.device timeout 5
*
*   SEE ALSO
*	Online
*
******************************************************************************
*/
int
main(int argc,char **argv)
{
	int return_code = RETURN_ERROR;
	ULONG time_mask;
	ULONG net_mask;
	ULONG signal_mask;
	ULONG signals;
	LONG error;

	if(!setup())
		goto out;

	NetEventRequest->ios2_Req.io_Command	= S2_ONEVENT;
	NetEventRequest->ios2_WireError			= S2EVENT_OFFLINE;

	SendIO((struct IORequest *)NetEventRequest);
	NetEventRequestPending = TRUE;

	if(Timeout > 0)
	{
		TimeRequest->tr_node.io_Command	= TR_ADDREQUEST;
		TimeRequest->tr_time.tv_secs	= Timeout * 60;
		TimeRequest->tr_time.tv_micro	= 0;

		SendIO((struct IORequest *)TimeRequest);
		TimeRequestPending = TRUE;
	}

	NetRequest->ios2_Req.io_Command = S2_OFFLINE;

	error = DoIO((struct IORequest *)NetRequest);
	if(error == S2WERR_UNIT_OFFLINE)
	{
		return_code = RETURN_OK;
		goto out;
	}

	if(error != 0)
	{
		UBYTE io_error_string[100];

		Printf("%s: Could not take '%s', unit %ld offline (%ld, %s).\n",
			"Offline",NetDeviceName,NetDeviceUnit,error,get_io_error_string(error,io_error_string));

		goto out;
	}

	time_mask = 1UL << TimePort->mp_SigBit;
	net_mask = 1UL << NetPort->mp_SigBit;

	signal_mask = SIGBREAKF_CTRL_C | time_mask | net_mask;
	signals = 0;

	while(TRUE)
	{
		if(signals == 0)
			signals = Wait(signal_mask);
		else
			signals |= SetSignal(0,signal_mask) & signal_mask;

		if(signals & SIGBREAKF_CTRL_C)
		{
			PrintFault(ERROR_BREAK, "Offline");

			return_code = RETURN_WARN;
			break;
		}

		if(signals & net_mask)
		{
			if(NetEventRequestPending && CheckIO((struct IORequest *)NetEventRequest) != BUSY)
			{
				WaitIO((struct IORequest *)NetEventRequest);
				NetEventRequestPending = FALSE;

				if(NetEventRequest->ios2_Req.io_Error == 0 && (NetEventRequest->ios2_WireError & S2EVENT_OFFLINE))
				{
					return_code = RETURN_OK;
					break;
				}
			}

			signals &= ~net_mask;
		}

		if(signals & time_mask)
		{
			Printf("%s: '%s', unit %ld could not be taken offline (timeout).\n",
				"Offline",NetDeviceName,NetDeviceUnit);

			return_code = RETURN_WARN;
			break;
		}
	}

 out:

	cleanup();

	return(return_code);
}
