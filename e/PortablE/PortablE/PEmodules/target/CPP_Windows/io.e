OPT NATIVE, FORCENATIVE
MODULE 'target/_mingw', 'target/sys/types', 'target/stdint'
MODULE 'target/sys/stat'	->for {chmod} & {_chmod}
{#include <io.h>}
/* 
 * io.h
 * This file has no copyright assigned and is placed in the Public Domain.
 * This file is a part of the mingw-runtime package.
 * No warranty is given; refer to the file DISCLAIMER within the package.
 *
 * System level I/O functions and types.
 *
 */
NATIVE {_IO_H_} DEF

/* All the headers include this file. */

/* MSVC's io.h contains the stuff from dir.h, so I will too.
 * NOTE: This also defines off_t, the file offset type, through
 *       an inclusion of sys/types.h */


/*
 * Attributes of files as returned by _findfirst et al.
 */
NATIVE {_A_NORMAL}	CONST A_NORMAL	= $00000000
NATIVE {_A_RDONLY}	CONST A_RDONLY	= $00000001
NATIVE {_A_HIDDEN}	CONST A_HIDDEN	= $00000002
NATIVE {_A_SYSTEM}	CONST A_SYSTEM	= $00000004
NATIVE {_A_VOLID}	CONST A_VOLID	= $00000008
NATIVE {_A_SUBDIR}	CONST A_SUBDIR	= $00000010
NATIVE {_A_ARCH}		CONST A_ARCH		= $00000020


NATIVE {_fsize_t} OBJECT
TYPE FSIZE_T IS NATIVE {_fsize_t} LONG
NATIVE {_FSIZE_T_DEFINED} DEF

/*
 * The maximum length of a file name. You should use GetVolumeInformation
 * instead of this constant. But hey, this works.
 * Also defined in stdio.h. 
 */
NATIVE {FILENAME_MAX}	CONST FILENAME_MAX	= (260)

/*
 * The following structure is filled in by _findfirst or _findnext when
 * they succeed in finding a match.
 */
NATIVE {_finddata_t} OBJECT _finddata_t
	{attrib}	attrib	:ULONG		/* Attributes, see constants above. */
	{time_create}	time_create	:TIME_T
	{time_access}	time_access	:TIME_T	/* always midnight local time */
	{time_write}	time_write	:TIME_T
	{size}	size	:FSIZE_T
	{name}	name[FILENAME_MAX]	:ARRAY OF CHAR	/* may include spaces. */
ENDOBJECT

NATIVE {_finddatai64_t} OBJECT _finddatai64_t
    {attrib}	attrib	:ULONG
    {time_create}	time_create	:TIME_T
    {time_access}	time_access	:TIME_T
    {time_write}	time_write	:TIME_T
    {size}	size	:NATIVE {__int64} BIGVALUE
    {name}	name[FILENAME_MAX]	:ARRAY OF CHAR
ENDOBJECT

NATIVE {__finddata64_t} OBJECT __finddata64_t
    {attrib}	attrib	:ULONG
    {time_create}	time_create	:TIME64_T
    {time_access}	time_access	:TIME64_T
    {time_write}	time_write	:TIME64_T
    {size}	size	:FSIZE_T
    {name}	name[FILENAME_MAX]	:ARRAY OF CHAR
ENDOBJECT

NATIVE {_wfinddata_t} OBJECT _wfinddata_t
    	{attrib}	attrib	:ULONG
    	{time_create}	time_create	:TIME_T	/* -1 for FAT file systems */
    	{time_access}	time_access	:TIME_T	/* -1 for FAT file systems */
    	{time_write}	time_write	:TIME_T
    	{size}	size	:FSIZE_T
    	{name}	name[FILENAME_MAX]	:ARRAY OF WCHAR_T	/* may include spaces. */
ENDOBJECT

NATIVE {_wfinddatai64_t} OBJECT _wfinddatai64_t
    {attrib}	attrib	:ULONG
    {time_create}	time_create	:TIME_T
    {time_access}	time_access	:TIME_T
    {time_write}	time_write	:TIME_T
    {size}	size	:NATIVE {__int64} BIGVALUE
    {name}	name[FILENAME_MAX]	:ARRAY OF WCHAR_T
ENDOBJECT

NATIVE {__wfinddata64_t} OBJECT __wfinddata64_t
    {attrib}	attrib	:ULONG
    {time_create}	time_create	:TIME64_T
    {time_access}	time_access	:TIME64_T
    {time_write}	time_write	:TIME64_T
    {size}	size	:FSIZE_T
    {name}	name[FILENAME_MAX]	:ARRAY OF WCHAR_T
ENDOBJECT

NATIVE {_WFINDDATA_T_DEFINED} DEF


/*
 * Functions for searching for files. _findfirst returns -1 if no match
 * is found. Otherwise it returns a handle to be used in _findnext and
 * _findclose calls. _findnext also returns -1 if no match could be found,
 * and 0 if a match was found. Call _findclose when you are finished.
 */
/*  FIXME: Should these all use intptr_t, as per recent MSDN docs?  */
NATIVE {_findfirst} PROC
PROC _findfirst(param1:ARRAY OF CHAR, param2:PTR TO _finddata_t) IS NATIVE {_findfirst(} param1 {,} param2 {)} ENDNATIVE !!VALUE
NATIVE {_findnext} PROC
PROC _findnext(param1:VALUE, param2:PTR TO _finddata_t) IS NATIVE {_findnext(} param1 {,} param2 {)} ENDNATIVE !!VALUE
NATIVE {_findclose} PROC
PROC _findclose(param1:VALUE) IS NATIVE {_findclose(} param1 {)} ENDNATIVE !!VALUE

NATIVE {_chdir} PROC
->PROC _chdir(param1:ARRAY OF CHAR) IS NATIVE {_chdir(} param1 {)} ENDNATIVE !!VALUE
NATIVE {_getcwd} PROC
PROC _getcwd(param1:ARRAY OF CHAR, param2:VALUE) IS NATIVE {_getcwd(} param1 {, (int) } param2 {)} ENDNATIVE !!ARRAY OF CHAR
NATIVE {_mkdir} PROC
->PROC _mkdir(param1:ARRAY OF CHAR) IS NATIVE {_mkdir(} param1 {)} ENDNATIVE !!VALUE
NATIVE {_mktemp} PROC
PROC _mktemp(param1:ARRAY OF CHAR) IS NATIVE {_mktemp(} param1 {)} ENDNATIVE !!ARRAY OF CHAR
NATIVE {_rmdir} PROC
->PROC _rmdir(param1:ARRAY OF CHAR) IS NATIVE {_rmdir(} param1 {)} ENDNATIVE !!VALUE
->NATIVE {_chmod} PROC
PROC _chmod(param1:ARRAY OF CHAR, param2:VALUE) IS NATIVE {_chmod(} param1 {, (int) } param2 {)} ENDNATIVE !!VALUE

NATIVE {_filelengthi64} PROC
PROC _filelengthi64(param1:VALUE) IS NATIVE {_filelengthi64( (int) } param1 {)} ENDNATIVE !!NATIVE {__int64} BIGVALUE
NATIVE {_findfirsti64} PROC
PROC _findfirsti64(param1:ARRAY OF CHAR, param2:PTR TO _finddatai64_t) IS NATIVE {_findfirsti64(} param1 {,} param2 {)} ENDNATIVE !!VALUE
NATIVE {_findnexti64} PROC
PROC _findnexti64(param1:VALUE, param2:PTR TO _finddatai64_t) IS NATIVE {_findnexti64(} param1 {,} param2 {)} ENDNATIVE !!VALUE
NATIVE {_lseeki64} PROC
PROC _lseeki64(param1:VALUE, param2:NATIVE {__int64} BIGVALUE, param3:VALUE) IS NATIVE {_lseeki64( (int) } param1 {,} param2 {, (int) } param3 {)} ENDNATIVE !!NATIVE {__int64} BIGVALUE
NATIVE {_telli64} PROC
PROC _telli64(param1:VALUE) IS NATIVE {_telli64( (int) } param1 {)} ENDNATIVE !!NATIVE {__int64} BIGVALUE
/* These require newer versions of msvcrt.dll (6.1 or higher). */ 
NATIVE {_findfirst64} PROC
->unsupported for some reason: PROC _findfirst64(param1:ARRAY OF CHAR, param2:PTR TO __finddata64_t) IS NATIVE {_findfirst64(} param1 {,} param2 {)} ENDNATIVE !!INTPTR_T
NATIVE {_findnext64} PROC
->unsupported for some reason: PROC _findnext64(param1:INTPTR_T, param2:PTR TO __finddata64_t) IS NATIVE {_findnext64(} param1 {,} param2 {)} ENDNATIVE !!INTPTR_T

NATIVE {lseek64} PROC
PROC lseek64(fd:VALUE, offset:OFF64_T, whence:VALUE) IS NATIVE {lseek64( (int) } fd {,} offset {, (int) } whence {)} ENDNATIVE !!OFF64_T


NATIVE {chdir} PROC
PROC chdir(param1:ARRAY OF CHAR) IS NATIVE {chdir(} param1 {)} ENDNATIVE !!VALUE
NATIVE {getcwd} PROC
PROC getcwd(param1:ARRAY OF CHAR, param2:VALUE) IS NATIVE {getcwd(} param1 {, (int) } param2 {)} ENDNATIVE !!ARRAY OF CHAR
NATIVE {mkdir} PROC
PROC mkdir(param1:ARRAY OF CHAR) IS NATIVE {mkdir(} param1 {)} ENDNATIVE !!VALUE
NATIVE {mktemp} PROC
PROC mktemp(param1:ARRAY OF CHAR) IS NATIVE {mktemp(} param1 {)} ENDNATIVE !!ARRAY OF CHAR
NATIVE {rmdir} PROC
PROC rmdir(param1:ARRAY OF CHAR) IS NATIVE {rmdir(} param1 {)} ENDNATIVE !!VALUE
->NATIVE {chmod} PROC
PROC chmod(param1:ARRAY OF CHAR, param2:VALUE) IS NATIVE {chmod(} param1 {, (int) } param2 {)} ENDNATIVE !!VALUE


/* TODO: Maximum number of open handles has not been tested, I just set
 * it the same as FOPEN_MAX. */
NATIVE {HANDLE_MAX}	CONST ->HANDLE_MAX	= FOPEN_MAX

/* Some defines for _access nAccessMode (MS doesn't define them, but
 * it doesn't seem to hurt to add them). */
NATIVE {F_OK}	CONST F_OK	= 0	/* Check for file existence */
NATIVE {X_OK}	CONST X_OK	= 1	/* Check for execute permission. */
NATIVE {W_OK}	CONST W_OK	= 2	/* Check for write permission */
NATIVE {R_OK}	CONST R_OK	= 4	/* Check for read permission */


NATIVE {_access} PROC
PROC _access(param1:ARRAY OF CHAR, param2:VALUE) IS NATIVE {_access(} param1 {, (int) } param2 {)} ENDNATIVE !!VALUE
NATIVE {_chsize} PROC
PROC _chsize(param1:VALUE, param2:CLONG) IS NATIVE {_chsize( (int) } param1 {,} param2 {)} ENDNATIVE !!VALUE
NATIVE {_close} PROC
PROC _close(param1:VALUE) IS NATIVE {_close( (int) } param1 {)} ENDNATIVE !!VALUE
NATIVE {_commit} PROC
PROC _commit(param1:VALUE) IS NATIVE {_commit( (int) } param1 {)} ENDNATIVE !!VALUE

/* NOTE: The only significant bit in unPermissions appears to be bit 7 (0x80),
 *       the "owner write permission" bit (on FAT). */
NATIVE {_creat} PROC
PROC _creat(param1:ARRAY OF CHAR, param2:VALUE) IS NATIVE {_creat(} param1 {, (int) } param2 {)} ENDNATIVE !!VALUE

NATIVE {_dup} PROC
PROC _dup(param1:VALUE) IS NATIVE {_dup( (int) } param1 {)} ENDNATIVE !!VALUE
NATIVE {_dup2} PROC
PROC _dup2(param1:VALUE, param2:VALUE) IS NATIVE {_dup2( (int) } param1 {, (int) } param2 {)} ENDNATIVE !!VALUE
NATIVE {_filelength} PROC
PROC _filelength(param1:VALUE) IS NATIVE {_filelength( (int) } param1 {)} ENDNATIVE !!CLONG
NATIVE {_get_osfhandle} PROC
PROC _get_osfhandle(param1:VALUE) IS NATIVE {_get_osfhandle( (int) } param1 {)} ENDNATIVE !!CLONG
NATIVE {_isatty} PROC
PROC _isatty(param1:VALUE) IS NATIVE {_isatty( (int) } param1 {)} ENDNATIVE !!VALUE

/* In a very odd turn of events this function is excluded from those
 * files which define _STREAM_COMPAT. This is required in order to
 * build GNU libio because of a conflict with _eof in streambuf.h
 * line 107. Actually I might just be able to change the name of
 * the enum member in streambuf.h... we'll see. TODO */
NATIVE {_eof} PROC
PROC _eof(param1:VALUE) IS NATIVE {_eof( (int) } param1 {)} ENDNATIVE !!VALUE

/* LK_... locking commands defined in sys/locking.h. */
NATIVE {_locking} PROC
PROC _locking(param1:VALUE, param2:VALUE, param3:CLONG) IS NATIVE {_locking( (int) } param1 {, (int) } param2 {,} param3 {)} ENDNATIVE !!VALUE

NATIVE {_lseek} PROC
PROC _lseek(param1:VALUE, param2:CLONG, param3:VALUE) IS NATIVE {_lseek( (int) } param1 {,} param2 {, (int) } param3 {)} ENDNATIVE !!CLONG

/* Optional third argument is unsigned unPermissions. */
NATIVE {_open} PROC
PROC _open(param1:ARRAY OF CHAR, param2:VALUE, param22=0:ULONG, ...) IS NATIVE {_open(} param1 {, (int) } param2 {,} param22 {,} ... {)} ENDNATIVE !!VALUE

NATIVE {_open_osfhandle} PROC
PROC _open_osfhandle(param1:VALUE, param2:VALUE) IS NATIVE {_open_osfhandle(} param1 {, (int) } param2 {)} ENDNATIVE !!VALUE
NATIVE {_pipe} PROC
PROC _pipe(param1:PTR TO NATIVE {int} VALUE, param2:ULONG, param3:VALUE) IS NATIVE {_pipe(} param1 {, (int) } param2 {, (int) } param3 {)} ENDNATIVE !!VALUE
NATIVE {_read} PROC
PROC _read(param1:VALUE, param2:ARRAY, param3:ULONG) IS NATIVE {_read( (int) } param1 {,} param2 {, (int) } param3 {)} ENDNATIVE !!VALUE
NATIVE {_setmode} PROC
PROC _setmode(param1:VALUE, param2:VALUE) IS NATIVE {_setmode( (int) } param1 {, (int) } param2 {)} ENDNATIVE !!VALUE

/* SH_... flags for nShFlags defined in share.h
 * Optional fourth argument is unsigned unPermissions */
NATIVE {_sopen} PROC
PROC _sopen(param1:ARRAY OF CHAR, param2:VALUE, param3:VALUE, ...) IS NATIVE {_sopen(} param1 {, (int) } param2 {, (int) } param3 {, (int) } ... {)} ENDNATIVE !!VALUE

NATIVE {_tell} PROC
PROC _tell(param1:VALUE) IS NATIVE {_tell( (int) } param1 {)} ENDNATIVE !!CLONG
/* Should umask be in sys/stat.h and/or sys/types.h instead? */
NATIVE {_umask} PROC
PROC _umask(param1:VALUE) IS NATIVE {_umask( (int) } param1 {)} ENDNATIVE !!VALUE
NATIVE {_unlink} PROC
PROC _unlink(param1:ARRAY OF CHAR) IS NATIVE {_unlink(} param1 {)} ENDNATIVE !!VALUE
NATIVE {_write} PROC
PROC _write(param1:VALUE, param2:ARRAY, param3:ULONG) IS NATIVE {_write( (int) } param1 {,} param2 {, (int) } param3 {)} ENDNATIVE !!VALUE

/* Wide character versions. Also declared in wchar.h. */
/* Not in crtdll.dll */
NATIVE {_waccess} PROC
PROC _waccess(param1:ARRAY OF WCHAR_T, param2:VALUE) IS NATIVE {_waccess(} param1 {, (int) } param2 {)} ENDNATIVE !!VALUE
NATIVE {_wchmod} PROC
PROC _wchmod(param1:ARRAY OF WCHAR_T, param2:VALUE) IS NATIVE {_wchmod(} param1 {, (int) } param2 {)} ENDNATIVE !!VALUE
NATIVE {_wcreat} PROC
PROC _wcreat(param1:ARRAY OF WCHAR_T, param2:VALUE) IS NATIVE {_wcreat(} param1 {, (int) } param2 {)} ENDNATIVE !!VALUE
NATIVE {_wfindfirst} PROC
PROC _wfindfirst(param1:ARRAY OF WCHAR_T, param2:PTR TO _wfinddata_t) IS NATIVE {_wfindfirst(} param1 {,} param2 {)} ENDNATIVE !!VALUE
NATIVE {_wfindnext} PROC
PROC _wfindnext(param1:VALUE, param2:PTR TO _wfinddata_t) IS NATIVE {_wfindnext(} param1 {,} param2 {)} ENDNATIVE !!VALUE
NATIVE {_wunlink} PROC
PROC _wunlink(param1:ARRAY OF WCHAR_T) IS NATIVE {_wunlink(} param1 {)} ENDNATIVE !!VALUE
NATIVE {_wopen} PROC
PROC _wopen(param1:ARRAY OF WCHAR_T, param2:VALUE, param22=0:ULONG, ...) IS NATIVE {_wopen(} param1 {, (int) } param2 {,} param22 {,} ... {)} ENDNATIVE !!VALUE
NATIVE {_wsopen} PROC
PROC _wsopen(param1:ARRAY OF WCHAR_T, param2:VALUE, param3:VALUE, ...) IS NATIVE {_wsopen(} param1 {, (int) } param2 {, (int) } param3 {, (int) } ... {)} ENDNATIVE !!VALUE
NATIVE {_wmktemp} PROC
PROC _wmktemp(param1:ARRAY OF WCHAR_T) IS NATIVE {_wmktemp(} param1 {)} ENDNATIVE !!ARRAY OF WCHAR_T
NATIVE {_wfindfirsti64} PROC
PROC _wfindfirsti64(param1:ARRAY OF WCHAR_T, param2:PTR TO _wfinddatai64_t) IS NATIVE {_wfindfirsti64(} param1 {,} param2 {)} ENDNATIVE !!VALUE
NATIVE {_wfindnexti64} PROC
PROC _wfindnexti64(param1:VALUE, param2:PTR TO _wfinddatai64_t) IS NATIVE {_wfindnexti64(} param1 {,} param2 {)} ENDNATIVE !!VALUE
NATIVE {_wfindfirst64} PROC
->unsupported for some reason: PROC _wfindfirst64(param1:ARRAY OF WCHAR_T, param2:PTR TO __wfinddata64_t) IS NATIVE {_wfindfirst64(} param1 {,} param2 {)} ENDNATIVE !!INTPTR_T
NATIVE {_wfindnext64} PROC
->unsupported for some reason: PROC _wfindnext64(param1:INTPTR_T, param2:PTR TO __wfinddata64_t) IS NATIVE {_wfindnext64(} param1 {,} param2 {)} ENDNATIVE !!INTPTR_T

/*
 * Non-underscored versions of non-ANSI functions to improve portability.
 * These functions live in libmoldname.a.
 */

NATIVE {access} PROC
PROC access(param1:ARRAY OF CHAR, param2:VALUE) IS NATIVE {access(} param1 {, (int) } param2 {)} ENDNATIVE !!VALUE
NATIVE {chsize} PROC
PROC chsize(param1:VALUE, param2:CLONG) IS NATIVE {chsize( (int) } param1 {,} param2 {)} ENDNATIVE !!VALUE
NATIVE {close} PROC
PROC close(param1:VALUE) IS NATIVE {close( (int) } param1 {)} ENDNATIVE !!VALUE
NATIVE {creat} PROC
PROC creat(param1:ARRAY OF CHAR, param2:VALUE) IS NATIVE {creat(} param1 {, (int) } param2 {)} ENDNATIVE !!VALUE
NATIVE {dup} PROC
PROC dup(param1:VALUE) IS NATIVE {dup( (int) } param1 {)} ENDNATIVE !!VALUE
NATIVE {dup2} PROC
PROC dup2(param1:VALUE, param2:VALUE) IS NATIVE {dup2( (int) } param1 {, (int) } param2 {)} ENDNATIVE !!VALUE
NATIVE {eof} PROC
PROC eof(param1:VALUE) IS NATIVE {eof( (int) } param1 {)} ENDNATIVE !!VALUE
NATIVE {filelength} PROC
PROC filelength(param1:VALUE) IS NATIVE {filelength( (int) } param1 {)} ENDNATIVE !!CLONG
NATIVE {isatty} PROC
PROC isatty(param1:VALUE) IS NATIVE {isatty( (int) } param1 {)} ENDNATIVE !!VALUE
NATIVE {lseek} PROC
PROC lseek(param1:VALUE, param2:CLONG, param3:VALUE) IS NATIVE {lseek( (int) } param1 {,} param2 {, (int) } param3 {)} ENDNATIVE !!CLONG
NATIVE {open} PROC
PROC open(param1:ARRAY OF CHAR, param2:VALUE, param22=0:ULONG, ...) IS NATIVE {open(} param1 {, (int) } param2 {,} param22 {,} ... {)} ENDNATIVE !!VALUE
->NATIVE {read} PROC
PROC read(param1:VALUE, param2:ARRAY, param3:ULONG) IS NATIVE {read( (int) } param1 {,} param2 {, (int) } param3 {)} ENDNATIVE !!VALUE
NATIVE {setmode} PROC
PROC setmode(param1:VALUE, param2:VALUE) IS NATIVE {setmode( (int) } param1 {, (int) } param2 {)} ENDNATIVE !!VALUE
NATIVE {sopen} PROC
PROC sopen(param1:ARRAY OF CHAR, param2:VALUE, param3:VALUE, ...) IS NATIVE {sopen(} param1 {, (int) } param2 {, (int) } param3 {, (int) } ... {)} ENDNATIVE !!VALUE
NATIVE {tell} PROC
PROC tell(param1:VALUE) IS NATIVE {tell( (int) } param1 {)} ENDNATIVE !!CLONG
NATIVE {umask} PROC
PROC umask(param1:VALUE) IS NATIVE {umask( (int) } param1 {)} ENDNATIVE !!VALUE
NATIVE {unlink} PROC
PROC unlink(param1:ARRAY OF CHAR) IS NATIVE {unlink(} param1 {)} ENDNATIVE !!VALUE
->NATIVE {write} PROC
PROC write(param1:VALUE, param2:ARRAY, param3:ULONG) IS NATIVE {write( (int) } param1 {,} param2 {, (int) } param3 {)} ENDNATIVE !!VALUE
