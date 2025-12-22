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

BOOL WINAPI GetFileTime (HANDLE hFile, LPFILETIME lpCreationTime,
	LPFILETIME lpLastAccessTime, LPFILETIME lpLastWriteTime)
{
	if (hFile != INVALID_HANDLE_VALUE) {
		struct LIBW32_FILE *file = hFile;
		struct ExamineData *ed;
		if (lpCreationTime) {
			IUtility->ClearMem(lpCreationTime, sizeof(FILETIME));
		}
		if (lpLastAccessTime) {
			IUtility->ClearMem(lpLastAccessTime, sizeof(FILETIME));
		}
		if (lpLastWriteTime) {
			ed = IDOS->ExamineObjectTags(
				EX_FileHandleInput, file->file,
				TAG_END);
			if (ed) {
				DateStampToFileTime(&ed->Date, lpLastWriteTime);
				IDOS->FreeDosObject(DOS_EXAMINEDATA, ed);
			} else {
				IUtility->ClearMem(lpLastWriteTime, sizeof(FILETIME));
				SetLastError(DOSToW32Error(IDOS->IoErr()));
				return FALSE;
			}
		}
		SetLastError(NO_ERROR);
		return TRUE;
	} else {
		SetLastError(ERROR_INVALID_HANDLE);
		return FALSE;
	}
}
