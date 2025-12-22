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

DWORD WINAPI SetFilePointer (HANDLE hFile, LONG lDistanceToMove,
	PLONG lpDistanceToMoveHigh, DWORD dwMoveMethod)
{
	if (hFile != INVALID_HANDLE_VALUE) {
		struct LIBW32_FILE *file = hFile;
		QUAD filesize;
		QUAD pointer;
		QUAD offset;
		if (lpDistanceToMoveHigh) {
			offset = ((QUAD)*lpDistanceToMoveHigh << 32)|((DWORD)lDistanceToMove);
		} else {
			offset = lDistanceToMove;
		}
		switch (dwMoveMethod) {
			case FILE_BEGIN:
				pointer = offset;
				break;
			case FILE_CURRENT:
				if (file->pointer != -1) {
					pointer = file->pointer;
				} else {
					pointer = IDOS->GetFilePosition(file->file);
				}
				if (pointer == -1) {
					SetLastError(ERROR_SEEK);
					return INVALID_SET_FILE_POINTER;
				}
				pointer = pointer + offset;
				break;
			case FILE_END:
				filesize = IDOS->GetFileSize(file->file);
				if (filesize == -1) {
					SetLastError(ERROR_SEEK);
					return INVALID_SET_FILE_POINTER;
				}
				pointer = filesize + offset;
				break;
			default:
				SetLastError(ERROR_INVALID_PARAMETER);
				return INVALID_SET_FILE_POINTER;
		}
		if (pointer < 0) {
			SetLastError(ERROR_NEGATIVE_SEEK);
			return INVALID_SET_FILE_POINTER;
		}
		if (lpDistanceToMoveHigh) {
			*lpDistanceToMoveHigh = pointer >> 32;
		} else {
			if (pointer > (DWORD)~0) {
				SetLastError(ERROR_SEEK);
				return INVALID_SET_FILE_POINTER;
			}
		}
		file->pointer = pointer;
		SetLastError(NO_ERROR);
		return pointer;
	} else {
		SetLastError(ERROR_INVALID_HANDLE);
		return INVALID_SET_FILE_POINTER;
	}
}
