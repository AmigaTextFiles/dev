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

#include "windows.h"

#ifndef _W32PRIVATE_H
#define _W32PRIVATE_H

#include <exec/exec.h>
#include <dos/dos.h>
#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/utility.h>
#include <proto/timezone.h>

#define _MICROSECOND (10ULL)
#define _MILLISECOND (1000 * _MICROSECOND)
#define _SECOND      (1000 * _MILLISECOND)
#define _MINUTE      (60 * _SECOND)
#define _HOUR        (60 * _MINUTE)
#define _DAY         (24 * _HOUR)

struct LIBW32_HANDLE {
	BOOL (*CloseHandle) (HANDLE hObject);
};

struct LIBW32_FILE {
	struct LIBW32_HANDLE handle;
	BPTR file;
	QUAD pointer;
};

struct LIBW32_FINDFILE {
	struct LIBW32_HANDLE handle;
	struct AnchorPath *anchor;
};

DWORD DOSToW32Error (LONG lDosError);
void DateStampToFileTime (const struct DateStamp *lpDateStamp,
	LPFILETIME lpFileTime);
void FileTimeToDateStamp (const FILETIME *lpFileTime,
	struct DateStamp *lpDateStamp);

#endif
