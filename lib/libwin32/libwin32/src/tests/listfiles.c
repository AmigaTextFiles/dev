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
#include <stdio.h>

LPCSTR weekdays[]={"Sun","Mon","Tue","Wed","Thu","Fri","Sat"};

int main (int argc, char **argv) {
	WIN32_FIND_DATA findfiledata;
	HANDLE find;
	if (argc != 2) {
		printf("Bad args!\n");
		return 20;
	}
	printf("Target file is %s\n", argv[1]);
	find = FindFirstFile(argv[1], &findfiledata);
	if (find == INVALID_HANDLE_VALUE) {
		printf("FindFirstFile failed (%ld)\n", GetLastError());
		return 20;
	} else {
		do {
			FILETIME filetime;
			SYSTEMTIME systime;
			CHAR datestr[32];
			FileTimeToLocalFileTime(&findfiledata.ftLastWriteTime, &filetime);
			FileTimeToSystemTime(&filetime, &systime);
			snprintf(datestr, sizeof(datestr), "%s %02d:%02d:%02d:%03d %02d-%02d-%04d",
				weekdays[systime.wDayOfWeek],
				systime.wHour, systime.wMinute, systime.wSecond, systime.wMilliseconds,
				systime.wDay, systime.wMonth, systime.wYear);
			if (findfiledata.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY) {
				printf("%12s %s %s (dir)\n", "", datestr, findfiledata.cFileName);
			} else {
				LONGLONG filesize = ((LONGLONG)findfiledata.nFileSizeHigh << 32)|(findfiledata.nFileSizeLow);
				printf("%12lld %s %s\n", filesize, datestr, findfiledata.cFileName);
			}
		} while (FindNextFile(find, &findfiledata));
		FindClose(find);
	}
	return 0;
}
