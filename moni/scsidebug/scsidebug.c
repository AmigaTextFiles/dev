#include <exec/exec.h>
#include <devices/trackdisk.h>
#include <devices/scsidisk.h>
#include <dos/dos.h>
#include <proto/exec.h>
#include <proto/dos.h>
#include <stddef.h>
#include "SCSIDebug_rev.h"

#define PROGNAME "SCSIDebug"
#define TEMPLATE "DEVICE/A,UNIT/N/A"
#define dbug(x) DebugPrintF x

const char USED verstag[] = VERSTAG;

struct {
	const char *device;
	uint32 *unit;
} args;

struct Unit *unit;
void (*oldBeginIO) (struct DeviceManagerInterface *Self, struct IOStdReq *io);
void newBeginIO (struct DeviceManagerInterface *Self, struct IOStdReq *io);

int main () {
	APTR rdargs = NULL;
	int rc = RETURN_FAIL;
	struct MsgPort *mp = NULL;
	struct IOStdReq *io = NULL;
	int8 error;
	struct Library *base = NULL;
	struct Interface *interface = NULL;
	
	rdargs = ReadArgs(TEMPLATE, (APTR)&args, NULL);
	if (!rdargs) {
		PrintFault(IoErr(), PROGNAME);
		goto out;
	}
	
	mp = AllocSysObject(ASOT_PORT, NULL);
	io = AllocSysObjectTags(ASOT_IOREQUEST,
		ASOIOR_Size,		sizeof(struct IOStdReq),
		ASOIOR_ReplyPort,	mp,
		TAG_END);
	if (!io) {
		PrintFault(ERROR_NO_FREE_STORE, PROGNAME);
		goto out;
	}

	error = OpenDevice(args.device, *args.unit, (struct IORequest *)io, 0);
	if (error) {
		io->io_Device = NULL;
		Printf("%s:%ld: OpenDevice returned error %ld\n", args.device, *args.unit, error);
		goto out;
	}
	
	base = &io->io_Device->dd_Library;
	interface = GetInterface(base, "__device", 1, NULL);
	if (!interface) {
		Printf("%s:%ld: Failed to obtain device manager interface\n", args.device, *args.unit);
		goto out;
	}
	
	rc = RETURN_OK;

	unit = io->io_Unit;
	oldBeginIO = SetMethod(interface, offsetof(struct DeviceManagerInterface, BeginIO),
		(APTR)newBeginIO);
	Printf("oldBeginIO: %08lx\nnewBeginIO: %08lx\n", oldBeginIO, newBeginIO);
	
	Wait(SIGBREAKF_CTRL_C);
	
	SetMethod(interface, offsetof(struct DeviceManagerInterface, BeginIO),
		(APTR)oldBeginIO);

out:
	DropInterface(interface);
	if (io && io->io_Device) {
		CloseDevice((struct IORequest *)io);
	}
	FreeSysObject(ASOT_IOREQUEST, io);
	FreeSysObject(ASOT_PORT, mp);
	FreeArgs(rdargs);
	return rc;
}

void newBeginIO (struct DeviceManagerInterface *Self, struct IOStdReq *io) {
	if (io->io_Unit == unit && io->io_Command == HD_SCSICMD) {
		struct SCSICmd *scsi = io->io_Data;
		int i;
		dbug(("scsi_Data: 0x%08lx\n", scsi->scsi_Data));
		dbug(("scsi_Length: %ld\n", scsi->scsi_Length));
		dbug(("scsi_Command:"));
		for (i = 0; i < scsi->scsi_CmdLength; i++) {
			dbug((" %02lx", scsi->scsi_Command[i]));
		}
		dbug(("\nscsi_CmdLength: %ld\n", scsi->scsi_CmdLength));
		dbug(("scsi_Flags: 0x%02lx\n", scsi->scsi_Flags));
		dbug(("scsi_Status: 0x%02lx\n", scsi->scsi_Status));
		dbug(("scsi_SenseData: 0x%08lx\n", scsi->scsi_SenseData));
		dbug(("scsi_SenseLength: %ld\n", scsi->scsi_SenseLength));
	}
	oldBeginIO(Self, io);
}
