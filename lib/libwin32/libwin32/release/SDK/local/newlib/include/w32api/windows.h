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

#ifndef _WINDOWS_H
#define _WINDOWS_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#include "winerror.h"

#define WINAPI
#define LIBW32(x) LIBW32_##x

#define MAX_PATH 256

#ifndef __AROS__
#ifdef __AMIGAOS4__
typedef int64 QUAD;
typedef uint64 UQUAD;
#else
typedef signed long long QUAD;
typedef unsigned long long UQUAD;
#endif
#endif
typedef QUAD LONGLONG;
#ifdef __AMIGAOS4__
typedef uint8  LIBW32(BYTE);
typedef uint16 LIBW32(WORD);
typedef uint32 LIBW32(DWORD);
typedef uint64 LIBW32(QWORD);
#else
typedef UBYTE  LIBW32(BYTE);
typedef UWORD  LIBW32(WORD);
typedef ULONG  LIBW32(DWORD);
typedef UQUAD  LIBW32(QWORD);
#endif
typedef int    LIBW32(BOOL);
#define BYTE   LIBW32(BYTE)
#define WORD   LIBW32(WORD)
#define DWORD  LIBW32(DWORD)
#define QWORD  LIBW32(QWORD)
#define BOOL   LIBW32(BOOL)
typedef APTR   HANDLE;
#define INVALID_HANDLE_VALUE NULL

typedef void *PVOID, *LPVOID;
typedef BYTE *PBYTE, *LPBYTE;
typedef WORD *PWORD, *LPWORD;
typedef LONG *PLONG, *LPLONG;
typedef LONGLONG *PLONGLONG, *LPLONGLONG;
typedef DWORD *PDWORD, *LPDWORD;
typedef QWORD *PQWORD, *LPQWORD;
typedef CONST void *LPCVOID;
typedef CONST BYTE *LPCBYTE;
typedef CONST WORD *LPCWORD;
typedef CONST DWORD *LPCDWORD;
typedef CONST QWORD *LPCQWORD;
typedef TEXT CHAR, TCHAR;
typedef STRPTR LPSTR, LPTSTR;
typedef CONST_STRPTR LPCSTR, LPCTSTR;

typedef union _LARGE_INTEGER {
	struct {
		LONG  HighPart;
		DWORD LowPart;
	};
	struct {
		LONG  HighPart;
		DWORD LowPart;
	} u;
	LONGLONG QuadPart;
} LARGE_INTEGER, *PLARGE_INTEGER;

#define GENERIC_ALL       (0x10000000UL)
#define GENERIC_READ      (0x80000000UL)
#define GENERIC_WRITE     (0x40000000UL)
#define GENERIC_EXECUTE   (0x20000000UL)

#define FILE_SHARE_DELETE (0x00000004UL)
#define FILE_SHARE_READ   (0x00000001UL)
#define FILE_SHARE_WRITE  (0x00000002UL)

#define CREATE_ALWAYS     (0x00000002UL)
#define CREATE_NEW        (0x00000001UL)
#define OPEN_ALWAYS       (0x00000004UL)
#define OPEN_EXISTING     (0x00000003UL)
#define TRUNCATE_EXISTING (0x00000005UL)

#define FILE_ATTRIBUTE_ARCHIVE       (0x00000020UL)
#define FILE_ATTRIBUTE_COMPRESSED    (0x00000800UL)
#define FILE_ATTRIBUTE_DEVICE        (0x00000040UL)
#define FILE_ATTRIBUTE_DIRECTORY     (0x00000010UL)
#define FILE_ATTRIBUTE_ENCRYPTED     (0x00004000UL)
#define FILE_ATTRIBUTE_HIDDEN        (0x00000002UL)
#define FILE_ATTRIBUTE_NORMAL        (0x00000080UL)
#define FILE_ATTRIBUTE_OFFLINE       (0x00001000UL)
#define FILE_ATTRIBUTE_READONLY      (0x00000001UL)
#define FILE_ATTRIBUTE_SYSTEM        (0x00000004UL)
#define FILE_ATTRIBUTE_TEMPORARY     (0x00000100UL)

#define FILE_FLAG_BACKUP_SEMANTICS   (0x02000000UL)
#define FILE_FLAG_DELETE_ON_CLOSE    (0x04000000UL)
#define FILE_FLAG_NO_BUFFERING       (0x20000000UL)
#define FILE_FLAG_OPEN_NO_RECALL     (0x00100000UL)
#define FILE_FLAG_OPEN_REPARSE_POINT (0x00200000UL)
#define FILE_FLAG_OVERLAPPED         (0x40000000UL)
#define FILE_FLAG_POSIX_SEMANTICS    (0x01000000UL)
#define FILE_FLAG_RANDOM_ACCESS      (0x10000000UL)
#define FILE_FLAG_SEQUENTIAL_SCAN    (0x08000000UL)
#define FILE_FLAG_WRITE_THROUGH      (0x80000000UL)

#define FILE_BEGIN   (0UL)
#define FILE_CURRENT (1UL)
#define FILE_END     (2UL)

#define INVALID_SET_FILE_POINTER (~0UL)
#define INVALID_FILE_SIZE (~0UL)

typedef APTR LPSECURITY_ATTRIBUTES;
typedef APTR LPOVERLAPPED;

typedef struct _FILETIME {
	DWORD dwHighDateTime;
	DWORD dwLowDateTime;
} FILETIME, *PFILETIME, *LPFILETIME;

typedef struct _SYSTEMTIME {
	WORD wYear;
	WORD wMonth;
	WORD wDayOfWeek;
	WORD wDay;
	WORD wHour;
	WORD wMinute;
	WORD wSecond;
	WORD wMilliseconds;
} SYSTEMTIME, *PSYSTEMTIME, *LPSYSTEMTIME;

typedef struct _WIN32_FIND_DATA {
	DWORD dwFileAttributes;
	FILETIME ftCreationTime;
	FILETIME ftLastAccessTime;
	FILETIME ftLastWriteTime;
	DWORD nFileSizeHigh;
	DWORD nFileSizeLow;
	DWORD dwReserved0;
	DWORD dwReserved1;
	TCHAR cFileName[MAX_PATH];
	TCHAR cAlternateFileName[14];
} WIN32_FIND_DATA, *PWIN32_FIND_DATA, *LPWIN32_FIND_DATA;

BOOL WINAPI CloseHandle (HANDLE hObject);
BOOL WINAPI CreateDirectory (LPCTSTR lpPathName,
	LPSECURITY_ATTRIBUTES lpSecurityAttributes);
HANDLE WINAPI CreateFile (LPCTSTR lpFileName, DWORD dwDesiredAccess,
	DWORD dwShareMode, LPSECURITY_ATTRIBUTES lpSecurityAttributes,
	DWORD dwCreationDisposition, DWORD dwFlagsAndAttributes,
	HANDLE hTemplateFile);
BOOL WINAPI DeleteFile (LPCTSTR lpFileName);
BOOL WINAPI FileTimeToLocalFileTime (const FILETIME *lpFileTime,
	LPFILETIME lpLocalFileTime);
BOOL WINAPI FileTimeToSystemTime (const FILETIME *lpFileTime,
	LPSYSTEMTIME lpSystemTime);
BOOL WINAPI FindClose (HANDLE hFindFile);
HANDLE WINAPI FindFirstFile (LPCTSTR lpFileName,
	LPWIN32_FIND_DATA lpFindFileData);
BOOL WINAPI FindNextFile (HANDLE hFindFile,
	LPWIN32_FIND_DATA lpFindFileData);
DWORD WINAPI GetFileSize (HANDLE hFile, LPDWORD lpFileSizeHigh);
BOOL WINAPI GetFileSizeEx (HANDLE hFile, PLARGE_INTEGER lpFileSize);
BOOL WINAPI GetFileTime (HANDLE hFile, LPFILETIME lpCreationTime,
	LPFILETIME lpLastAccessTime, LPFILETIME lpLastWriteTime);
DWORD WINAPI GetLastError (void);
BOOL WINAPI ReadFile (HANDLE hFile, LPVOID lpBuffer,
	DWORD nNumberOfBytesToRead, LPDWORD lpNumberOfBytesRead,
	LPOVERLAPPED lpOverlapped);
BOOL WINAPI RemoveDirectory (LPCTSTR lpPathName);
BOOL WINAPI SetEndOfFile (HANDLE hFile);
DWORD WINAPI SetFilePointer (HANDLE hFile, LONG lDistanceToMove,
	PLONG lpDistanceToMoveHigh, DWORD dwMoveMethod);
BOOL WINAPI SetFileTime (HANDLE hFile, const FILETIME *lpCreationTime,
	const FILETIME *lpLastAccessTime, const FILETIME *lpLastWriteTime);
void WINAPI SetLastError (DWORD dwErrCode);
void WINAPI SetLastErrorEx (DWORD dwErrCode, DWORD dwType);
BOOL WINAPI WriteFile (HANDLE hFile, LPCVOID lpBuffer,
	DWORD nNumberOfBytesToWrite, LPDWORD lpNumberOfBytesWritten,
	LPOVERLAPPED lpOverlapped);

#endif
