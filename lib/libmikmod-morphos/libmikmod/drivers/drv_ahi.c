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

  Driver for output to native Amiga AHI device

  Based on an AHI driver by Fredrik Wikstr�m and Szilárd Biró.
==============================================================================*/

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include <string.h>

#include "mikmod_internals.h"

#include <devices/ahi.h>
#include <exec/execbase.h>
#include <proto/exec.h>

#define BUFFERSIZE (4 << 10)

struct AmigaAHI
{
	BYTE Buffer1[BUFFERSIZE];
	BYTE Buffer2[BUFFERSIZE];

	struct AHIRequest req[2];
	struct MsgPort mp;

	BYTE current;
	BYTE playing;
	BYTE signed8;
};

STATIC struct AmigaAHI *aahi;

static BOOL AHI_IsThere(void) {
	return 1;
}

static int AHI_Init(void)
{
	LONG sigbit = AllocSignal(-1);

	if (sigbit >= 0)
	{
		struct AmigaAHI *p = AllocMem(sizeof(*p), MEMF_ANY);

		if (p)
		{
			p->req[0].ahir_Std.io_Message.mn_ReplyPort = &p->mp;
			p->req[0].ahir_Std.io_Command = CMD_WRITE;
			p->req[0].ahir_Std.io_Data = NULL;
			p->req[0].ahir_Std.io_Offset = 0;
			p->req[0].ahir_Version = 4;
			p->req[0].ahir_Frequency = md_mixfreq; //Get freq from libmikmod
			p->req[0].ahir_Type = (md_mode & DMODE_16BITS)?
								((md_mode & DMODE_STEREO)? AHIST_S16S : AHIST_M16S) :
								((md_mode & DMODE_STEREO)? AHIST_S8S  : AHIST_M8S );
			p->req[0].ahir_Volume = 0x10000;
			p->req[0].ahir_Position = 0x8000;

			p->mp.mp_Flags = PA_SIGNAL;
			p->mp.mp_SigBit = sigbit;
			p->mp.mp_SigTask = SysBase->ThisTask;

			NEWLIST(&p->mp.mp_MsgList);

			p->current = 0;
			p->playing = 0;
			p->signed8 = (md_mode & DMODE_16BITS)? 0 : 1;

			if (OpenDevice((STRPTR)AHINAME, 0, (struct IORequest *)&p->req[0], 0) == 0)
			{
				aahi = p;

				bcopy(&p->req[0], &p->req[1], sizeof(struct AHIRequest));

				if (!VC_Init())
					return 0;
			}

			CloseDevice((struct IORequest *)&p->req[0]);
		}

		FreeMem(p, sizeof(*p));
	}

	FreeSignal(sigbit);
	_mm_errno = MMERR_OPENING_AUDIO;
	return 1;
}

static void AHI_Exit(void) {
	struct AmigaAHI *p = aahi;
	size_t i;

	VC_Exit();

	for (i = 0; i < 2; i++)
	{
		if (p->req[i].ahir_Std.io_Data)
		{
			AbortIO((APTR)&p->req[i]);
			WaitIO((APTR)&p->req[i]);
		}
	}

	CloseDevice((struct IORequest *)&p->req[0]);
	FreeSignal(p->mp.mp_SigBit);
	FreeMem(p, sizeof(*p));
}

static void AHI_Update(void)
{
	struct AmigaAHI *p = aahi;
	ULONG playing = p->playing, curr = p->current, next = curr ^ 1;

	if (playing > 1)
	{
		playing--;
		WaitIO((APTR)&p->req[curr]);

		if (playing > 0)
		{
			if (CheckIO((APTR)&p->req[next]))
			{
				playing--;
				WaitIO((APTR)&p->req[next]);
			}
		}
	}

	while (playing < 2)
	{
		ULONG numBytes;
		struct AHIRequest *req = &p->req[curr];
		BYTE *buf = curr == 0 ? p->Buffer1 : p->Buffer2;

		req->ahir_Std.io_Data = buf;
		req->ahir_Std.io_Length = numBytes = VC_WriteBytes(buf, BUFFERSIZE);
		req->ahir_Link = p->playing ? &p->req[next] : NULL;

		if (p->signed8) { /* convert u8 data to s8 */
			ULONG i = 0;
			for (; i < numBytes; ++i)
				buf[i] -= 128;
		}

		SendIO((struct IORequest *)req);

		curr  = next;
		next ^= 1;
		playing++;
	}

	p->current = curr;
	p->playing = playing;
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
