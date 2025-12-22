/* Copyright 2011 Fredrik Wikstrom. All rights reserved.
**
** Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions
** are met:
**
** 1. Redistributions of source code must retain the above copyright
**    notice, this list of conditions and the following disclaimer.
**
** 2. Redistributions in binary form must reproduce the above copyright
**    notice, this list of conditions and the following disclaimer in the
**    documentation and/or other materials provided with the distribution.
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS `AS IS'
** AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
** IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
** ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
** LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
** CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
** SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
** INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
** CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
** ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
** POSSIBILITY OF SUCH DAMAGE.
*/

#define NEED_DOS_ERRORS_H
#include "w32private.h"
#include <dos/errors.h>

DWORD DOSToW32Error (LONG lDosError) {
	switch (lDosError) {
		case ERROR_DELETE_PROTECTED: return LIBW32_ERROR_ACCESS_DENIED;
		case ERROR_DIR_NOT_FOUND: return LIBW32_ERROR_PATH_NOT_FOUND;
		case ERROR_DISK_FULL: return LIBW32_ERROR_DISK_FULL;
		case ERROR_DISK_WRITE_PROTECTED: return LIBW32_ERROR_WRITE_PROTECT;
		case ERROR_NO_FREE_STORE: return LIBW32_ERROR_NOT_ENOUGH_MEMORY;
		case ERROR_NOT_A_DOS_DISK: return LIBW32_ERROR_NOT_DOS_DISK;
		case ERROR_OBJECT_NOT_FOUND: return LIBW32_ERROR_FILE_NOT_FOUND;
		case ERROR_READ_PROTECTED: return LIBW32_ERROR_ACCESS_DENIED;
		case ERROR_SEEK_ERROR: return LIBW32_ERROR_SEEK;
		case ERROR_WRITE_PROTECTED: return LIBW32_ERROR_ACCESS_DENIED;
		default: return LIBW32_ERROR_UNKNOWN;
	}
}
