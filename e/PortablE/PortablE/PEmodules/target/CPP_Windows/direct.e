OPT NATIVE
MODULE 'target/_mingw', 'target/io'
MODULE 'target/sys/types'	->for ULONG
{#include <direct.h>}
/*
 * direct.h
 * This file has no copyright assigned and is placed in the Public Domain.
 * This file is a part of the mingw-runtime package.
 * No warranty is given; refer to the file DISCLAIMER within the package.
 *
 * Functions for manipulating paths and directories (included from io.h)
 * plus functions for setting the current drive.
 *
 */
NATIVE {_DIRECT_H_} DEF

/* needed by _getdiskfree (also in dos.h) */
NATIVE {_diskfree_t} OBJECT _diskfree_t
	{total_clusters}	total_clusters	:ULONG
	{avail_clusters}	avail_clusters	:ULONG
	{sectors_per_cluster}	sectors_per_cluster	:ULONG
	{bytes_per_sector}	bytes_per_sector	:ULONG
ENDOBJECT
NATIVE {_DISKFREE_T_DEFINED} DEF

/*
 * You really shouldn't be using these. Use the Win32 API functions instead.
 * However, it does make it easier to port older code.
 */
NATIVE {_getdrive} PROC
PROC _getdrive() IS NATIVE {_getdrive()} ENDNATIVE !!VALUE
NATIVE {_getdrives} PROC
PROC _getdrives() IS NATIVE {_getdrives()} ENDNATIVE !!ULONG
NATIVE {_chdrive} PROC
PROC _chdrive(param1:VALUE) IS NATIVE {_chdrive( (int) } param1 {)} ENDNATIVE !!VALUE
NATIVE {_getdcwd} PROC
PROC _getdcwd(param1:VALUE, param2:ARRAY OF CHAR, param3:VALUE) IS NATIVE {_getdcwd( (int) } param1 {,} param2 {, (int) } param3 {)} ENDNATIVE !!ARRAY OF CHAR
NATIVE {_getdiskfree} PROC
PROC _getdiskfree(param1:ULONG, param2:PTR TO _diskfree_t) IS NATIVE {_getdiskfree( (int) } param1 {,} param2 {)} ENDNATIVE !!ULONG

->#ifndef	_NO_OLDNAMES
NATIVE {diskfree_t} CONST
->#endif

/* wide character versions. Also in wchar.h */
NATIVE {_wchdir} PROC
PROC _wchdir(param1:ARRAY OF WCHAR_T) IS NATIVE {_wchdir(} param1 {)} ENDNATIVE !!VALUE
NATIVE {_wgetcwd} PROC
PROC _wgetcwd(param1:ARRAY OF WCHAR_T, param2:VALUE) IS NATIVE {_wgetcwd(} param1 {, (int) } param2 {)} ENDNATIVE !!ARRAY OF WCHAR_T
NATIVE {_wgetdcwd} PROC
PROC _wgetdcwd(param1:VALUE, param2:ARRAY OF WCHAR_T, param3:VALUE) IS NATIVE {_wgetdcwd( (int) } param1 {,} param2 {, (int) } param3 {)} ENDNATIVE !!ARRAY OF WCHAR_T
NATIVE {_wmkdir} PROC
PROC _wmkdir(param1:ARRAY OF WCHAR_T) IS NATIVE {_wmkdir(} param1 {)} ENDNATIVE !!VALUE
NATIVE {_wrmdir} PROC
PROC _wrmdir(param1:ARRAY OF WCHAR_T) IS NATIVE {_wrmdir(} param1 {)} ENDNATIVE !!VALUE
NATIVE {_WDIRECT_DEFINED} DEF

