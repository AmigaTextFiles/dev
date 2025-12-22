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

static BOOL FileExists (LPCTSTR lpFileName);
static BOOL CloseFile (HANDLE hFile);

HANDLE WINAPI CreateFile (LPCTSTR lpFileName, DWORD dwDesiredAccess,
	DWORD dwShareMode, LPSECURITY_ATTRIBUTES lpSecurityAttributes,
	DWORD dwCreationDisposition, DWORD dwFlagsAndAttributes,
	HANDLE hTemplateFile)
{
	struct LIBW32_FILE *file;
	DWORD error = NO_ERROR;
	file = IExec->AllocVecTagList(sizeof(*file), NULL);
	if (file) {
		file->handle.CloseHandle = CloseFile;
		file->pointer = -1;
		if (FileExists(lpFileName)) {
			switch (dwCreationDisposition) {
				case CREATE_ALWAYS:
					file->file = IDOS->Open(lpFileName, MODE_NEWFILE);
					if (file->file) {
						error = ERROR_ALREADY_EXISTS;
					}
					break;
				case CREATE_NEW:
					error = ERROR_ALREADY_EXISTS;
					break;
				case OPEN_ALWAYS:
					file->file = IDOS->Open(lpFileName, MODE_OLDFILE);
					if (file->file) {
						error = ERROR_ALREADY_EXISTS;
					}
					break;
				case OPEN_EXISTING:
					file->file = IDOS->Open(lpFileName, MODE_OLDFILE);
					break;
				case TRUNCATE_EXISTING:
					file->file = IDOS->Open(lpFileName, MODE_NEWFILE);
					break;
				default:
					error = ERROR_INVALID_PARAMETER;
					break;
			}
		} else {
			switch (dwCreationDisposition) {
				case CREATE_ALWAYS:
				case CREATE_NEW:
				case OPEN_ALWAYS:
					file->file = IDOS->Open(lpFileName, MODE_NEWFILE);
					break;
				case OPEN_EXISTING:
				case TRUNCATE_EXISTING:
					error = ERROR_FILE_NOT_FOUND;
					break;
				default:
					error = ERROR_INVALID_PARAMETER;
					break;
			}
		}
		if (file->file == ZERO) {
			if (error == NO_ERROR) {
				error = DOSToW32Error(IDOS->IoErr());
			}
			IExec->FreeVec(file);
			file = NULL;
		}
	} else {
		error = ERROR_NOT_ENOUGH_MEMORY;
	}
	SetLastError(error);
	return file;
}

static BOOL FileExists (LPCTSTR lpFileName) {
	BPTR file;
	file = IDOS->Open(lpFileName, MODE_OLDFILE);
	if (file) {
		IDOS->Close(file);
	}
	return !!file;
}

static BOOL CloseFile (HANDLE hFile) {
	struct LIBW32_FILE *file = hFile;
	if (file->file) {
		IDOS->Close(file->file);
	}
	return TRUE;
}
