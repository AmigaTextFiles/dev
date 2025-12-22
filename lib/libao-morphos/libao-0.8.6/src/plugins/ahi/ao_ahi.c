/*
 *
 *  ao_ahi.c
 *
 *      Original Copyright (C) Ilkka Lehtoranta - Jan 2006
 *
 *  This file is part of libao, a cross-platform audio output library.  See
 *  README for a history of this source code.
 *
 *  libao is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2, or (at your option)
 *  any later version.
 *
 *  libao is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with GNU Make; see the file COPYING.  If not, write to
 *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
 *
 */


#include <ao/ao.h>
#include <ao/plugin.h>

#include <devices/ahi.h>
#include <proto/exec.h>


/*********************************************************************/

#ifndef __MORPHOS__
#define AllocTaskPooled(size)			AllocMem(size, MEMF_ANY)
#define FreeTaskPooled(mem, size)	FreeMem(mem, size)
#endif

/*********************************************************************/


static const ao_info ao_ahi_info =
{
	AO_TYPE_LIVE,
	"AHI output",
	"ahi",
	"Ilkka Lehtoranta <ilkleht@isoveli.org>",
	"Outputs to the AHI.",
	AO_FMT_NATIVE,
	40,
	NULL,
	0
};


typedef struct ao_ahi_internal
{
	struct AHIRequest req1, req2;
	struct MsgPort *port;
	void *buf1, *buf2;
	int slots;
	int bufsize;
} ao_ahi_internal;


int ao_plugin_test()
{
	return 1;
}


ao_info *ao_plugin_driver_info(void)
{
	return (ao_info *)&ao_ahi_info;
}


int ao_plugin_device_init(ao_device *device)
{
	ao_ahi_internal *internal;
	int rc = 0;

	internal = (ao_ahi_internal *)AllocTaskPooled(sizeof(ao_ahi_internal));

	if (internal)
	{
		rc = 1;
		internal->port = NULL;
		device->internal = internal;
	}

	return rc;
}

int ao_plugin_set_option(ao_device *device, const char *key, const char *value)
{
	ao_ahi_internal *internal = (ao_ahi_internal *) device->internal;

	/* No options */

	return 1;
}

int ao_plugin_open(ao_device *device, ao_sample_format *format)
{
	ao_ahi_internal *internal = (ao_ahi_internal *) device->internal;
	int type;

	if (format->channels ==1 || format->channels == 2)
	{
		int bufsize = format->channels * 8192;

		switch (format->bits)
		{
			case 8  : type = format->channels == 1 ? AHIST_M8S : AHIST_S8S;
				break;
			case 16 : type = format->channels == 1 ? AHIST_M16S : AHIST_S16S;
				bufsize *= 2;
				break;
			case 32 : type = format->channels == 1 ? AHIST_M32S : AHIST_S32S;
				bufsize *= 4;
				break;
			default : return 0;
		}

		internal->bufsize = bufsize;

		internal->buf1 = AllocTaskPooled(bufsize);
		internal->buf2 = AllocTaskPooled(bufsize);

		if (internal->buf1 && internal->buf2)
		{
			internal->port = CreateMsgPort();

			if (internal->port)
			{
				internal->req1.ahir_Std.io_Message.mn_Node.ln_Pri = 0;
				internal->req1.ahir_Std.io_Message.mn_ReplyPort = internal->port;
				internal->req1.ahir_Std.io_Message.mn_Length = sizeof(struct AHIRequest);
				internal->req1.ahir_Version = 4;

				if (OpenDevice("ahi.device", AHI_DEFAULT_UNIT, (struct IORequest *)&internal->req1, 0) == 0)
				{
					internal->slots = 2;
					internal->req1.ahir_Std.io_Command = CMD_WRITE;
					internal->req1.ahir_Std.io_Offset = 0;
					internal->req1.ahir_Type = type;
					internal->req1.ahir_Frequency = format->rate;
					internal->req1.ahir_Volume = 0x10000;
					internal->req1.ahir_Position = 0x8000;

					CopyMemQuick(&internal->req1, &internal->req2, sizeof(struct AHIRequest));
					device->driver_byte_format = AO_FMT_NATIVE;
					return 1;
				}

				DeleteMsgPort(internal->port);
			}

			if (internal->buf1)
				FreeTaskPooled(internal->buf1, bufsize);

			if (internal->buf2)
				FreeTaskPooled(internal->buf2, bufsize);

			internal->port = NULL;
			internal->buf1 = NULL;
			internal->buf2 = NULL;
		}
	}

	return 0;
}


int ao_plugin_play(ao_device *device, const char* output_samples, uint_32 num_bytes)
{
	ao_ahi_internal *internal = (ao_ahi_internal *) device->internal;

	while (num_bytes)
	{
		struct AHIRequest *msg, *link;
		int size;
		void *buf;

		if (internal->slots == 0)
			WaitPort(internal->port);

		while (msg = (struct AHIRequest *)GetMsg(internal->port))
		{
			internal->slots++;
		}

		size = internal->bufsize > num_bytes ? num_bytes : internal->bufsize;

		internal->slots--;

		if (msg == &internal->req1)
		{
			buf = internal->buf1;
			link = &internal->req2;
		}
		else
		{
			buf = internal->buf2;
			link = &internal->req1;
		}

		num_bytes -= size;

		msg->ahir_Std.io_Data = buf;
		msg->ahir_Std.io_Length = size;
		msg->ahir_Link = link;

		CopyMem(output_samples, buf, size);
		SendIO((struct IORequest *)msg);
	}

	return 1;
}


int ao_plugin_close(ao_device *device)
{
	ao_ahi_internal *internal = (ao_ahi_internal *) device->internal;

	if (internal->port)
	{
		if (!CheckIO((struct IORequest *)&internal->req1))
		{
			AbortIO((struct IORequest *)&internal->req1);
			WaitIO((struct IORequest *)&internal->req1);
		}

		if (!CheckIO((struct IORequest *)&internal->req1))
		{
			AbortIO((struct IORequest *)&internal->req1);
			WaitIO((struct IORequest *)&internal->req1);
		}

		#if 0
		GetMsg(internal->port);
		GetMsg(internal->port);
		#endif

		CloseDevice((struct IORequest *)&internal->req1);
		DeleteMsgPort(internal->port);

		FreeTaskPooled(internal->buf1, internal->bufsize);
		FreeTaskPooled(internal->buf2, internal->bufsize);

		internal->port = NULL;
		internal->buf1 = NULL;
		internal->buf2 = NULL;
	}

	return 1;
}


void ao_plugin_device_clear(ao_device *device)
{
	ao_ahi_internal *internal = (ao_ahi_internal *) device->internal;

	FreeTaskPooled(internal, sizeof(*internal));
}
