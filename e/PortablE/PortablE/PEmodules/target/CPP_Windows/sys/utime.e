OPT NATIVE
MODULE 'target/_mingw', 'target/sys/types'
{#include <sys/utime.h>}
/*
 * utime.h
 * This file has no copyright assigned and is placed in the Public Domain.
 * This file is a part of the mingw-runtime package.
 * No warranty is given; refer to the file DISCLAIMER within the package.
 *
 * Support for the utime function.
 *
 */
NATIVE {_UTIME_H_} DEF

/* All the headers include this file. */


/*
 * Structure used by _utime function.
 */
NATIVE {_utimbuf} OBJECT _utimbuf
	{actime}	actime	:TIME_T		/* Access time */
	{modtime}	modtime	:TIME_T	/* Modification time */
ENDOBJECT


/* NOTE: Must be the same as _utimbuf above. */
NATIVE {utimbuf} OBJECT utimbuf
	{actime}	actime	:TIME_T
	{modtime}	modtime	:TIME_T
ENDOBJECT

NATIVE {__utimbuf64} OBJECT __utimbuf64
	{actime}	actime	:TIME64_T
	{modtime}	modtime	:TIME64_T
ENDOBJECT


NATIVE {_utime} PROC
PROC _utime(param1:ARRAY OF CHAR, param2:PTR TO _utimbuf) IS NATIVE {_utime(} param1 {,} param2 {)} ENDNATIVE !!VALUE

NATIVE {utime} PROC
PROC utime(param1:ARRAY OF CHAR, param2:PTR TO utimbuf) IS NATIVE {utime(} param1 {,} param2 {)} ENDNATIVE !!VALUE

NATIVE {_futime} PROC
PROC _futime(param1:VALUE, param2:PTR TO _utimbuf) IS NATIVE {_futime( (int) } param1 {,} param2 {)} ENDNATIVE !!VALUE

/* The wide character version, only available for MSVCRT versions of the
 * C runtime library. */
/*
->#ifdef __MSVCRT__
NATIVE {_wutime} PROC
PROC _wutime(param1:ARRAY OF WCHAR_T, param2:PTR TO _utimbuf) IS NATIVE {_wutime(} param1 {,} param2 {)} ENDNATIVE !!VALUE
->#endif /* MSVCRT runtime */

/* These require newer versions of msvcrt.dll (6.10 or higher).  */ 
->#if __MSVCRT_VERSION__ >= 0x0601
NATIVE {_utime64} PROC
PROC _utime64(param1:ARRAY OF CHAR, param2:PTR TO __utimbuf64) IS NATIVE {_utime64(} param1 {,} param2 {)} ENDNATIVE !!VALUE
NATIVE {_wutime64} PROC
PROC _wutime64(param1:ARRAY OF WCHAR_T, param2:PTR TO __utimbuf64) IS NATIVE {_wutime64(} param1 {,} param2 {)} ENDNATIVE !!VALUE
NATIVE {_futime64} PROC
PROC _futime64(param1:VALUE, param2:PTR TO __utimbuf64) IS NATIVE {_futime64( (int) } param1 {,} param2 {)} ENDNATIVE !!VALUE
->#endif /* __MSVCRT_VERSION__ >= 0x0601 */
*/
