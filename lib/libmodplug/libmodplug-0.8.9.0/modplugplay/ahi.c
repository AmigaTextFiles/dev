#include <devices/ahi.h>
#include <proto/exec.h>

struct MsgPort *ahi_mp;
struct AHIRequest *ahi_io[2], *ahi_busy;
int ahi_idx;

void CloseAHIDevice (void) {
	if (ahi_io[0] != NULL && ahi_io[0]->ahir_Std.io_Device != NULL) {
		if (ahi_busy != NULL) {
			IExec->AbortIO((struct IORequest *)ahi_busy);
			IExec->WaitIO((struct IORequest *)ahi_busy);
		}
		IExec->CloseDevice((struct IORequest *)ahi_io[0]);
	}
	IExec->FreeSysObject(ASOT_IOREQUEST, ahi_io[1]); ahi_io[1] = NULL;
	IExec->FreeSysObject(ASOT_IOREQUEST, ahi_io[0]); ahi_io[0] = NULL;
	IExec->FreeSysObject(ASOT_PORT, ahi_mp); ahi_mp = NULL;
}

int OpenAHIDevice (void) {
	ahi_mp = IExec->AllocSysObject(ASOT_PORT, NULL);
	ahi_io[0] = IExec->AllocSysObjectTags(ASOT_IOREQUEST,
		ASOIOR_ReplyPort, ahi_mp,
		ASOIOR_Size,      sizeof(struct AHIRequest),
		TAG_END);
	if (ahi_io[0] != NULL) {
		ahi_io[0]->ahir_Version = 4;
		if (IExec->OpenDevice("ahi.device", 0, (struct IORequest *)ahi_io[0], 0)
			== IOERR_SUCCESS)
		{
			ahi_io[1] = IExec->AllocSysObjectTags(ASOT_IOREQUEST,
				ASOIOR_Duplicate, ahi_io[0],
				TAG_END);
			if (ahi_io[1] != NULL) {
				return 1;
			}
		} else {
			ahi_io[0]->ahir_Std.io_Device = NULL;
		}
	}
	CloseAHIDevice();
	return 0;
}

void PlayPCM (void *pcm, unsigned int bytes, unsigned int freq) {
	struct AHIRequest *io = ahi_io[ahi_idx];

	io->ahir_Std.io_Message.mn_Node.ln_Pri = 0;
    io->ahir_Std.io_Command = CMD_WRITE;
    io->ahir_Std.io_Data = pcm;
    io->ahir_Std.io_Length = bytes;
    io->ahir_Std.io_Offset = 0;
    io->ahir_Frequency = freq;
    io->ahir_Type = AHIST_S16S;
    io->ahir_Volume = 0x10000;
    io->ahir_Position = 0x8000;
    io->ahir_Link = ahi_busy;
    IExec->SendIO((struct IORequest *)io);

	if (ahi_busy) {
		IExec->WaitIO((struct IORequest *)ahi_busy);
	}

	ahi_busy = io;
	ahi_idx ^= 1;
}

