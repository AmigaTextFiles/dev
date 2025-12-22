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

#include "w32private.h"

BOOL WINAPI ReadFile (HANDLE hFile, LPVOID lpBuffer,
	DWORD nNumberOfBytesToRead, LPDWORD lpNumberOfBytesRead,
	LPOVERLAPPED lpOverlapped)
{
	*lpNumberOfBytesRead = 0;
	if (hFile != INVALID_HANDLE_VALUE) {
		struct LIBW32_FILE *file = hFile;
		if (nNumberOfBytesToRead == 0) {
			SetLastError(NO_ERROR);
			return TRUE;
		}
		if (file->pointer != -1) {
			if (!IDOS->ChangeFilePosition(file->file, file->pointer, OFFSET_BEGINNING)) {
				SetLastError(DOSToW32Error(IDOS->IoErr()));
				return FALSE;
			}
			file->pointer = -1;
		}
		*lpNumberOfBytesRead = IDOS->Read(file->file, lpBuffer, nNumberOfBytesToRead);
		if (*lpNumberOfBytesRead == nNumberOfBytesToRead) {
			SetLastError(NO_ERROR);
			return TRUE;
		}
		if (*lpNumberOfBytesRead == (DWORD)-1) {
			SetLastError(DOSToW32Error(IDOS->IoErr()));
		} else {
			SetLastError(ERROR_HANDLE_EOF);
		}
		return FALSE;
	} else {
		SetLastError(ERROR_INVALID_HANDLE);
		return FALSE;
	}
}
