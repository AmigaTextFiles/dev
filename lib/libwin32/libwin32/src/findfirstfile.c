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

static void GetFindFileData (struct AnchorPath *anchor,
	LPWIN32_FIND_DATA lpFindFileData);
static BOOL CloseFindFile (HANDLE hFindFile);

HANDLE WINAPI FindFirstFile (LPCTSTR lpFileName,
	LPWIN32_FIND_DATA lpFindFileData)
{
	struct LIBW32_FINDFILE *findfile;
	DWORD error = NO_ERROR;
	findfile = IExec->AllocVecTagList(sizeof(*findfile), NULL);
	if (findfile) {
		findfile->handle.CloseHandle = CloseFindFile;
		findfile->anchor = IDOS->AllocDosObject(DOS_ANCHORPATH, NULL);
		if (findfile->anchor) {
			LONG dos_error;
			dos_error = IDOS->MatchFirst(lpFileName, findfile->anchor);
			if (dos_error) {
				error = DOSToW32Error(dos_error);
			} else {
				GetFindFileData(findfile->anchor, lpFindFileData);
				error = NO_ERROR;
			}
		} else {
			error = ERROR_NOT_ENOUGH_MEMORY;
		}
		if (error != NO_ERROR) {
			FindClose(findfile);
			findfile = NULL;
		}
	} else {
		error = ERROR_NOT_ENOUGH_MEMORY;
	}
	SetLastError(error);
	return findfile;
}

BOOL WINAPI FindNextFile (HANDLE hFindFile,
	LPWIN32_FIND_DATA lpFindFileData)
{
	if (hFindFile != INVALID_HANDLE_VALUE) {
		struct LIBW32_FINDFILE *findfile = hFindFile;
		LONG dos_error;
		dos_error = IDOS->MatchNext(findfile->anchor);
		if (dos_error) {
			SetLastError(DOSToW32Error(dos_error));
			return FALSE;
		} else {
			GetFindFileData(findfile->anchor, lpFindFileData);
			SetLastError(NO_ERROR);
			return TRUE;
		}
	} else {
		SetLastError(ERROR_INVALID_HANDLE);
		return FALSE;
	}
}

BOOL WINAPI FindClose (HANDLE hFindFile) {
	return CloseHandle(hFindFile);
}

static void GetFindFileData (struct AnchorPath *anchor,
	LPWIN32_FIND_DATA lpFindFileData)
{
	IUtility->ClearMem(lpFindFileData, sizeof(*lpFindFileData));
	if (anchor->ap_ExData) {
		struct ExamineData *ed = anchor->ap_ExData;
		if (EXD_IS_FILE(ed)) {
			lpFindFileData->dwFileAttributes = FILE_ATTRIBUTE_NORMAL;
		} else {
			lpFindFileData->dwFileAttributes = FILE_ATTRIBUTE_DIRECTORY;
		}
		DateStampToFileTime(&ed->Date, &lpFindFileData->ftLastWriteTime);
		lpFindFileData->nFileSizeHigh = ed->FileSize >> 32;
		lpFindFileData->nFileSizeLow = ed->FileSize;
		IUtility->Strlcpy(lpFindFileData->cFileName, ed->Name, MAX_PATH);
	} else {
		struct FileInfoBlock *fib = &anchor->ap_Info;
		if (FIB_IS_FILE(fib)) {
			lpFindFileData->dwFileAttributes = FILE_ATTRIBUTE_NORMAL;
		} else {
			lpFindFileData->dwFileAttributes = FILE_ATTRIBUTE_DIRECTORY;
		}
		DateStampToFileTime(&fib->fib_Date, &lpFindFileData->ftLastWriteTime);
		lpFindFileData->nFileSizeLow = fib->fib_Size;
		IUtility->Strlcpy(lpFindFileData->cFileName, fib->fib_FileName, MAX_PATH);
	}
}

static BOOL CloseFindFile (HANDLE hFindFile) {
	struct LIBW32_FINDFILE *findfile = hFindFile;
	if (findfile->anchor) {
		IDOS->FreeDosObject(DOS_ANCHORPATH, findfile->anchor);
	}
	return TRUE;
}
