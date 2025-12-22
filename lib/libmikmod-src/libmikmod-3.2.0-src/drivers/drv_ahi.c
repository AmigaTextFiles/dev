/*	MikMod sound library
	(c) 1998, 1999, 2000 Miodrag Vallat and others - see file AUTHORS for
	complete list.

	This library is free software; you can redistribute it and/or modify
	it under the terms of the GNU Library General Public License as
	published by the Free Software Foundation; either version 2 of
	the License, or (at your option) any later version.
 
	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU Library General Public License for more details.
 
	You should have received a copy of the GNU Library General Public
	License along with this library; if not, write to the Free Software
	Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
	02111-1307, USA.
*/

/*==============================================================================

  $Id: drv_AHI(AMIGA).c,v 1.0 26/04/2007

  Driver for output to native Amiga AHI device (OS4)

==============================================================================*/

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include "mikmod_internals.h"

#include <stdio.h>

#include <exec/exec.h>
#include <devices/ahi.h>
#include <proto/exec.h>

#define BUFFERSIZE (4 << 10)

struct MsgPort *AHImp;
struct AHIRequest *AHIio;
struct AHIRequest *AHIio2;
struct AHIRequest *join;
BYTE AHIDevice = -1;

int16 *SBuff1, *SBuff2;

void closeLibs() {
    // close ahi
    IExec->FreeVec(SBuff1);
    IExec->FreeVec(SBuff2);
	if (!AHIDevice) {
        IExec->CloseDevice((struct IORequest *)AHIio);
	}
	IExec->FreeSysObject(ASOT_IOREQUEST, AHIio);
	IExec->FreeSysObject(ASOT_IOREQUEST, AHIio2);
    IExec->FreeSysObject(ASOT_PORT, AHImp);
}

static BOOL AHI_IsThere(void) {
	return 1;
}

static BOOL AHI_Init(void) {
	AHImp = IExec->AllocSysObject(ASOT_PORT, NULL);
	AHIio = IExec->AllocSysObjectTags(ASOT_IOREQUEST,
		ASOIOR_Size,		sizeof(struct AHIRequest),
		ASOIOR_ReplyPort,	AHImp,
		TAG_END);
	if (AHIio) {
		AHIio->ahir_Version = 4;
		AHIDevice = IExec->OpenDevice(AHINAME, 0, (struct IORequest *)AHIio, 0);
	}

    if (AHIDevice) {
        closeLibs();
        return 1;
    }

	AHIio2 = IExec->AllocSysObjectTags(ASOT_IOREQUEST,
		ASOIOR_Duplicate,	AHIio,
		TAG_END);
    if(!AHIio2) {
        closeLibs();
        return 1;
    }

    SBuff1 = IExec->AllocVec(BUFFERSIZE, MEMF_SHARED);
    SBuff2 = IExec->AllocVec(BUFFERSIZE, MEMF_SHARED);
	if (!SBuff1 || !SBuff2 || VC_Init()) {
		closeLibs();
		return 1;
	}
	return 0;
}

static void AHI_Exit(void) {
    if(join) {
		if (!IExec->CheckIO((struct IORequest *)AHIio)) {
	        IExec->AbortIO((struct IORequest *)AHIio);
		}
        IExec->WaitIO((struct IORequest *)AHIio);
    }

	VC_Exit();
    closeLibs();
	
}


static void AHI_Update(void) {
    uint32 numBytes = 0;
    void *p1 = SBuff1, *p2 = SBuff2;

	numBytes = VC_WriteBytes(p1, BUFFERSIZE);

	AHIio->ahir_Std.io_Message.mn_Node.ln_Pri = 0;
    AHIio->ahir_Std.io_Command = CMD_WRITE;
    AHIio->ahir_Std.io_Data = p1;
    AHIio->ahir_Std.io_Length = numBytes;
    AHIio->ahir_Std.io_Offset = 0;
    AHIio->ahir_Frequency = md_mixfreq; //Get freq from libmikmod
    AHIio->ahir_Type = (md_mode&DMODE_STEREO) ? AHIST_S16S : AHIST_M16S; //Workout mode to set
    AHIio->ahir_Volume = 0x10000;
    AHIio->ahir_Position = 0x8000;
    AHIio->ahir_Link = join;
    IExec->SendIO((struct IORequest *)AHIio);

    if (join) {
        IExec->WaitIO((struct IORequest *)join);
    }

    join = AHIio;

	SBuff1 = p2;
	SBuff2 = p1;

    void *tmp = AHIio;
    AHIio = AHIio2;
    AHIio2 = (struct AHIRequest *)tmp;
}

MIKMODAPI MDRIVER drv_ahi={
	NULL,
	"AHI",
	"Native AHI Amiga Output driver",
	0,255,
	"AHI",
	NULL,
	NULL,
	AHI_IsThere,
	VC_SampleLoad,
	VC_SampleUnload,
	VC_SampleSpace,
	VC_SampleLength,
	AHI_Init,
	AHI_Exit,
	NULL,
	VC_SetNumVoices,
	VC_PlayStart,
	VC_PlayStop,
	AHI_Update,
	NULL,
	VC_VoiceSetVolume,
	VC_VoiceGetVolume,
	VC_VoiceSetFrequency,
	VC_VoiceGetFrequency,
	VC_VoiceSetPanning,
	VC_VoiceGetPanning,
	VC_VoicePlay,
	VC_VoiceStop,
	VC_VoiceStopped,
	VC_VoiceGetPosition,
	VC_VoiceRealVolume
};

