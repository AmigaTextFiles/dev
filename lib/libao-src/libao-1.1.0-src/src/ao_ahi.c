/*
 *
 *  ao_ahi.c
 *
 *  This file is part of libao, a cross-platform library.  See
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

#ifdef __amigaos4__
#define __USE_INLINE__
#endif
#include <devices/ahi.h>
#include <proto/exec.h>
#include <string.h>
#include <ao/ao.h>
#include <ao/plugin.h>

#define AO_AHI_BUF_SIZE 32768

#ifndef __amigaos4__
#define MEMF_PRIVATE 0
#define MEMF_SHARED MEMF_PUBLIC
#define IOERR_SUCCESS 0
#endif

static const char *ao_ahi_options[] = {
  "debug","verbose","matrix","quiet"
};
static ao_info ao_ahi_info = {
	AO_TYPE_LIVE,
	"AHI output",
	"ahi",
	"Fredrik Wikstrom <fredrik@a500.org>",
	"Outputs to AHI",
	AO_FMT_NATIVE,
	1,
	ao_ahi_options,
	sizeof(ao_ahi_options)/sizeof(*ao_ahi_options)
};

typedef struct ao_ahi_internal {
	void *buf, *buf2;
	LONG buf_size;
	LONG buf_end;
	LONG fmt, rate;
	struct MsgPort *mp;
	struct AHIRequest *io, *io2;
	struct AHIRequest *join;
} ao_ahi_internal;

int ao_ahi_test () {
	return 1;
}

ao_info *ao_ahi_driver_info () {
	return &ao_ahi_info;
}

int ao_ahi_device_init (ao_device *device) {
	ao_ahi_internal *internal;

	internal = AllocVecTags(sizeof(*internal),
		AVT_ClearWithValue, 0,
		TAG_END);
	if (!internal) {
		return 0;
	}

	internal->buf_size = AO_AHI_BUF_SIZE;

	device->internal = internal;
	device->output_matrix_order = AO_OUTPUT_MATRIX_FIXED;

	return 1;
}

int ao_ahi_set_option(ao_device *device, const char *key, const char *value) {
	return 1;
}

int ao_ahi_open(ao_device *device, ao_sample_format *format) {
	ao_ahi_internal *internal = device->internal;

	switch (format->bits) {
		case 8:
			switch (format->channels) {
				case 1: internal->fmt = AHIST_M8S; break;
				case 2: internal->fmt = AHIST_S8S; break;
				default: return 0;
			}
			break;
		case 16:
			switch (format->channels) {
				case 1: internal->fmt = AHIST_M16S; break;
				case 2: internal->fmt = AHIST_S16S; break;
				default: return 0;
			}
			break;
		case 32:
			switch (format->channels) {
				case 1: internal->fmt = AHIST_M32S; break;
				case 2: internal->fmt = AHIST_S32S; break;
				default: return 0;
			}
			break;
		default:
			return 0;
	}
	device->driver_byte_format = AO_FMT_NATIVE;

	if (!device->inter_matrix) {
		/* set up out matrix such that users are warned about > stereo playback */
		if (device->output_channels == 1)
			device->inter_matrix = strdup("C");
		else if (device->output_channels == 2)
			device->inter_matrix = strdup("L,R");
		//else no matrix, which results in a warning
	}
	
	internal->rate = format->rate;

	internal->buf = AllocVecTags(internal->buf_size,
		AVT_Type, MEMF_SHARED,
		TAG_END);
	internal->buf2 = AllocVecTags(internal->buf_size,
		AVT_Type, MEMF_SHARED,
		TAG_END);
	if (!internal->buf || !internal->buf2) {
		return 0;
	}
	internal->buf_end = 0;

#ifdef __amigaos4__
	internal->mp = AllocSysObject(ASOT_PORT, NULL);
	internal->io = AllocSysObjectTags(ASOT_IOREQUEST,
		ASOIOR_ReplyPort,	internal->mp,
		ASOIOR_Size,		sizeof(struct AHIRequest),
		TAG_END);
#else
	internal->mp = CreateMsgPort();
	internal->io = (struct AHIRequest *)CreateIORequest(internal->mp, sizeof(struct AHIRequest));
#endif
	if (!internal->io) {
		return 0;
	}

	internal->io->ahir_Version = 4;
	if (OpenDevice("ahi.device", 0, (struct IORequest *)internal->io, 0) != IOERR_SUCCESS) {
		internal->io->ahir_Std.io_Device = NULL;
		return 0;
	}

#ifdef __amigaos4__
	internal->io2 = AllocSysObjectTags(ASOT_IOREQUEST,
		ASOIOR_Duplicate,	internal->io,
		TAG_END);
#else
	internal->io2 = (struct AHIRequest *)CreateIORequest(internal->mp, sizeof(struct AHIRequest));
	if (internal->io2) {
		CopyMem(internal->io, internal->io2, sizeof(struct AHIRequest));
	}
#endif
	if (!internal->io2) {
		return 0;
	}

	internal->join = NULL;

	return 1;
}

static int _ahi_write_buffer (ao_ahi_internal *s) {
	struct AHIRequest *io = s->io;
	void *buf = s->buf;

	if (!s->buf_end) return 1;

	io->ahir_Std.io_Message.mn_Node.ln_Pri = 0;
	io->ahir_Std.io_Command = CMD_WRITE;
	io->ahir_Std.io_Data = buf;
	io->ahir_Std.io_Length = s->buf_end;
	io->ahir_Std.io_Offset = 0;
	io->ahir_Frequency = s->rate;
	io->ahir_Type = s->fmt;
	io->ahir_Volume = 0x10000;
	io->ahir_Position = 0x8000;
	io->ahir_Link = s->join;
	SendIO((struct IORequest *)io);

	if (s->join) {
		WaitIO((struct IORequest *)s->join);
	}
	s->join = io;

	s->buf = s->buf2;
	s->buf2 = buf;

	s->io = s->io2;
	s->io2 = io;

	s->buf_end = 0;
	return 1;
}

int ao_ahi_play(ao_device *device, const char *samples, 
		uint_32 num_bytes)
{
	ao_ahi_internal *internal = device->internal;
	LONG packed = 0;
	LONG copy_len;
	int ok = 1;

	while (packed < num_bytes && ok) {
		/* Pack the buffer */
		if (num_bytes-packed < internal->buf_size - internal->buf_end)
			copy_len = num_bytes - packed;
		else
			copy_len = internal->buf_size - internal->buf_end;

		CopyMem(samples + packed, internal->buf + internal->buf_end,
		       copy_len);
		packed += copy_len;
		internal->buf_end += copy_len;

		if(internal->buf_end == internal->buf_size)
			ok = _ahi_write_buffer(internal);
	}

	return ok;
}

int ao_ahi_close(ao_device *device) {
	ao_ahi_internal *internal = device->internal;
	int result;

	result = _ahi_write_buffer(internal);

	if (internal->join) {
		WaitIO((struct IORequest *)internal->join);
	}

	if (internal->io && internal->io->ahir_Std.io_Device) {
		CloseDevice((struct IORequest *)internal->io);
	}

#ifdef __amigaos4__
	FreeSysObject(ASOT_IOREQUEST, internal->io);
	FreeSysObject(ASOT_IOREQUEST, internal->io2);
	FreeSysObject(ASOT_PORT, internal->mp);
#else
	DeleteIORequest((struct IORequest *)internal->io);
	DeleteIORequest((struct IORequest *)internal->io2);
	DeleteMsgPort(internal->mp);
#endif

	FreeVec(internal->buf);
	FreeVec(internal->buf2);

	return result;
}

void ao_ahi_device_clear(ao_device *device) {
	ao_ahi_internal *internal = device->internal;

	FreeVec(internal);
}

ao_functions ao_ahi = {
	ao_ahi_test,
	ao_ahi_driver_info,
	ao_ahi_device_init,
	ao_ahi_set_option,
	ao_ahi_open,
	ao_ahi_play,
	ao_ahi_close,
	ao_ahi_device_clear
};
