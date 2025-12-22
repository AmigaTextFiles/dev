OPT NATIVE
PUBLIC MODULE 'target/io'
MODULE 'target/_mingw'
MODULE 'target/sys/types'	->for UINT
{#include <dirent.h>}
/*
 * DIRENT.H (formerly DIRLIB.H)
 * This file has no copyright assigned and is placed in the Public Domain.
 * This file is a part of the mingw-runtime package.
 * No warranty is given; refer to the file DISCLAIMER within the package.
 *
 */
NATIVE {_DIRENT_H_} DEF

/* All the headers include this file. */

NATIVE {dirent} OBJECT dirent
	{d_ino}	ino	:VALUE		/* Always zero. */
	{d_reclen}	reclen	:UINT	/* Always zero. */
	{d_namlen}	namlen	:UINT	/* Length of name in d_name. */
	{d_name}	name[FILENAME_MAX]	:ARRAY OF CHAR /* File name. */
ENDOBJECT

/*
 * This is an internal data structure. Good programmers will not use it
 * except as an argument to one of the functions below.
 * dd_stat field is now int (was short in older versions).
 */
/*typedef*/ NATIVE {DIR} OBJECT dir
	/* disk transfer area for this dir */
	{dd_dta}	dta	:_finddata_t

	/* dirent struct to return from dir (NOTE: this makes this thread
	 * safe as long as only one thread uses a particular DIR struct at
	 * a time) */
	{dd_dir}	dir	:dirent

	/* _findnext handle */
	{dd_handle}	handle	:VALUE

	/*
         * Status of search:
	 *   0 = not started yet (next entry to read is first entry)
	 *  -1 = off the end
	 *   positive = 0 based index of next entry
	 */
	{dd_stat}	stat	:VALUE

	/* given path for dir with search pattern (struct is extended) */
	{dd_name}	name	:ARRAY OF CHAR
ENDOBJECT /*DIR*/
TYPE DIR IS NATIVE {DIR} VALUE	->#this is a kludge, as "VALUE" should really be "dir"

NATIVE {opendir} PROC
PROC opendir(param1:ARRAY OF CHAR) IS NATIVE {opendir(} param1 {)} ENDNATIVE !!PTR TO DIR
NATIVE {readdir} PROC
PROC readdir(param1:PTR TO DIR) IS NATIVE {readdir(} param1 {)} ENDNATIVE !!PTR TO dirent
NATIVE {closedir} PROC
PROC closedir(param1:PTR TO DIR) IS NATIVE {closedir(} param1 {)} ENDNATIVE !!VALUE
NATIVE {rewinddir} PROC
PROC rewinddir(param1:PTR TO DIR) IS NATIVE {rewinddir(} param1 {)} ENDNATIVE
NATIVE {telldir} PROC
PROC telldir(param1:PTR TO DIR) IS NATIVE {telldir(} param1 {)} ENDNATIVE !!VALUE
NATIVE {seekdir} PROC
PROC seekdir(param1:PTR TO DIR, param2:VALUE) IS NATIVE {seekdir(} param1 {,} param2 {)} ENDNATIVE


/* wide char versions */

NATIVE {_wdirent} OBJECT _wdirent
	{d_ino}	ino	:VALUE		/* Always zero. */
	{d_reclen}	reclen	:UINT	/* Always zero. */
	{d_namlen}	namlen	:UINT	/* Length of name in d_name. */
	{d_name}	name[FILENAME_MAX]	:ARRAY OF WCHAR_T /* File name. */
ENDOBJECT

/*
 * This is an internal data structure. Good programmers will not use it
 * except as an argument to one of the functions below.
 */
/*typedef*/ NATIVE {_WDIR} OBJECT _wdir
	/* disk transfer area for this dir */
	{dd_dta}	dta	:_wfinddata_t

	/* dirent struct to return from dir (NOTE: this makes this thread
	 * safe as long as only one thread uses a particular DIR struct at
	 * a time) */
	{dd_dir}	dir	:_wdirent

	/* _findnext handle */
	{dd_handle}	handle	:VALUE

	/*
         * Status of search:
	 *   0 = not started yet (next entry to read is first entry)
	 *  -1 = off the end
	 *   positive = 0 based index of next entry
	 */
	{dd_stat}	stat	:VALUE

	/* given path for dir with search pattern (struct is extended) */
	{dd_name}	name	:ARRAY OF WCHAR_T
ENDOBJECT /*_WDIR*/
TYPE WDIR IS NATIVE {_WDIR} VALUE	->#this is a kludge, as "VALUE" should really be "_wdir"



NATIVE {_wopendir} PROC
PROC _wopendir(param1:ARRAY OF WCHAR_T) IS NATIVE {_wopendir(} param1 {)} ENDNATIVE !!PTR TO WDIR
NATIVE {_wreaddir} PROC
PROC _wreaddir(param1:PTR TO WDIR) IS NATIVE {_wreaddir(} param1 {)} ENDNATIVE !!PTR TO _wdirent
NATIVE {_wclosedir} PROC
PROC _wclosedir(param1:PTR TO WDIR) IS NATIVE {_wclosedir(} param1 {)} ENDNATIVE !!VALUE
NATIVE {_wrewinddir} PROC
PROC _wrewinddir(param1:PTR TO WDIR) IS NATIVE {_wrewinddir(} param1 {)} ENDNATIVE
NATIVE {_wtelldir} PROC
PROC _wtelldir(param1:PTR TO WDIR) IS NATIVE {_wtelldir(} param1 {)} ENDNATIVE !!VALUE
NATIVE {_wseekdir} PROC
PROC _wseekdir(param1:PTR TO WDIR, param2:VALUE) IS NATIVE {_wseekdir(} param1 {,} param2 {)} ENDNATIVE
