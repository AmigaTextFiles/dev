OPT NATIVE
MODULE 'target/_mingw', 'target/sys/types'
{#include <sys/stat.h>}
/*
 * stat.h
 * This file has no copyright assigned and is placed in the Public Domain.
 * This file is a part of the mingw-runtime package.
 * No warranty is given; refer to the file DISCLAIMER within the package.
 *
 * Symbolic constants for opening and creating files, also stat, fstat and
 * chmod functions.
 *
 */

NATIVE {_STAT_H_} DEF

/* All the headers include this file. */

/*
 * Constants for the stat st_mode member.
 */
NATIVE {_S_IFIFO}	CONST S_IFIFO_	= $1000	/* FIFO */
NATIVE {_S_IFCHR}	CONST S_IFCHR_	= $2000	/* Character */
NATIVE {_S_IFBLK}	CONST S_IFBLK_	= $3000	/* Block: Is this ever set under w32? */
NATIVE {_S_IFDIR}	CONST S_IFDIR_	= $4000	/* Directory */
NATIVE {_S_IFREG}	CONST S_IFREG_	= $8000	/* Regular */

NATIVE {_S_IFMT}		CONST S_IFMT_		= $F000	/* File type mask */

NATIVE {_S_IEXEC}	CONST S_IEXEC_	= $0040
NATIVE {_S_IWRITE}	CONST S_IWRITE_	= $0080
NATIVE {_S_IREAD}	CONST S_IREAD_	= $0100

NATIVE {_S_IRWXU}	CONST S_IRWXU_	= (S_IREAD_ OR S_IWRITE_ OR S_IEXEC_)
NATIVE {_S_IXUSR}	CONST S_IXUSR_	= S_IEXEC_
NATIVE {_S_IWUSR}	CONST S_IWUSR_	= S_IWRITE_
NATIVE {_S_IRUSR}	CONST S_IRUSR_	= S_IREAD_

NATIVE {_S_ISDIR} PROC
->PROC s_isdir(m) IS NATIVE {_S_ISDIR(} m {)} ENDNATIVE !!VALUE <> 0
NATIVE {_S_ISFIFO} PROC
->PROC s_isfifo(m) IS NATIVE {_S_ISFIFO(} m {)} ENDNATIVE !!VALUE <> 0
NATIVE {_S_ISCHR} PROC
->PROC s_ischr(m) IS NATIVE {_S_ISCHR(} m {)} ENDNATIVE !!VALUE <> 0
NATIVE {_S_ISBLK} PROC
->PROC s_isblk(m) IS NATIVE {_S_ISBLK(} m {)} ENDNATIVE !!VALUE <> 0
NATIVE {_S_ISREG} PROC
->PROC s_isreg(m) IS NATIVE {_S_ISREG(} m {)} ENDNATIVE !!VALUE <> 0


NATIVE {S_IFIFO}		CONST S_IFIFO		= S_IFIFO_
NATIVE {S_IFCHR}		CONST S_IFCHR		= S_IFCHR_
NATIVE {S_IFBLK}		CONST S_IFBLK		= S_IFBLK_
NATIVE {S_IFDIR}		CONST S_IFDIR		= S_IFDIR_
NATIVE {S_IFREG}		CONST S_IFREG		= S_IFREG_
NATIVE {S_IFMT}		CONST S_IFMT		= S_IFMT_
NATIVE {S_IEXEC}		CONST S_IEXEC		= S_IEXEC_
NATIVE {S_IWRITE}	CONST S_IWRITE	= S_IWRITE_
NATIVE {S_IREAD}		CONST S_IREAD		= S_IREAD_
NATIVE {S_IRWXU}		CONST S_IRWXU		= S_IRWXU_
NATIVE {S_IXUSR}		CONST S_IXUSR		= S_IXUSR_
NATIVE {S_IWUSR}		CONST S_IWUSR		= S_IWUSR_
NATIVE {S_IRUSR}		CONST S_IRUSR		= S_IRUSR_

NATIVE {S_IRGRP}    CONST S_IRGRP = (S_IRUSR SHR 3)
NATIVE {S_IWGRP}    CONST S_IWGRP = (S_IWUSR SHR 3)
NATIVE {S_IXGRP}    CONST S_IXGRP = (S_IXUSR SHR 3)
NATIVE {S_IRWXG}    CONST S_IRWXG = (S_IRWXU SHR 3)

NATIVE {S_IROTH}    CONST S_IROTH = (S_IRGRP SHR 3)
NATIVE {S_IWOTH}    CONST S_IWOTH = (S_IWGRP SHR 3)
NATIVE {S_IXOTH}    CONST S_IXOTH = (S_IXGRP SHR 3)
NATIVE {S_IRWXO}    CONST S_IRWXO = (S_IRWXG SHR 3)

NATIVE {S_ISDIR} PROC
PROC s_isdir(m) IS NATIVE {S_ISDIR(} m {)} ENDNATIVE !!VALUE <> 0
NATIVE {S_ISFIFO} PROC
PROC s_isfifo(m) IS NATIVE {S_ISFIFO(} m {)} ENDNATIVE !!VALUE <> 0
NATIVE {S_ISCHR} PROC
PROC s_ischr(m) IS NATIVE {S_ISCHR(} m {)} ENDNATIVE !!VALUE <> 0
NATIVE {S_ISBLK} PROC
PROC s_isblk(m) IS NATIVE {S_ISBLK(} m {)} ENDNATIVE !!VALUE <> 0
NATIVE {S_ISREG} PROC
PROC s_isreg(m) IS NATIVE {S_ISREG(} m {)} ENDNATIVE !!VALUE <> 0



/*
 * The structure manipulated and returned by stat and fstat.
 *
 * NOTE: If called on a directory the values in the time fields are not only
 * invalid, they will cause localtime et. al. to return NULL. And calling
 * asctime with a NULL pointer causes an Invalid Page Fault. So watch it!
 */
NATIVE {_stat} OBJECT _stat
	{st_dev}	dev	:DEV_T		/* Equivalent to drive number 0=A 1=B ... */
	{st_ino}	ino	:INO_T		/* Always zero ? */
	{st_mode}	mode	:MODE_T	/* See above constants */
	{st_nlink}	nlink	:INT	/* Number of links. */
	{st_uid}	uid	:INT		/* User: Maybe significant on NT ? */
	{st_gid}	gid	:INT		/* Group: Ditto */
	{st_rdev}	rdev	:DEV_T	/* Seems useless (not even filled in) */
	{st_size}	size	:OFF_T	/* File size in bytes */
	{st_atime}	atime	:TIME_T	/* Accessed date (always 00:00 hrs local
				 * on FAT) */
	{st_mtime}	mtime	:TIME_T	/* Modified time */
	{st_ctime}	ctime	:TIME_T	/* Creation time */
ENDOBJECT

/* NOTE: Must be the same as _stat above. */
NATIVE {stat} OBJECT stat
	{st_dev}	dev	:DEV_T		/* Equivalent to drive number 0=A 1=B ... */
	{st_ino}	ino	:INO_T		/* Always zero ? */
	{st_mode}	mode	:MODE_T	/* See above constants */
	{st_nlink}	nlink	:INT	/* Number of links. */
	{st_uid}	uid	:INT		/* User: Maybe significant on NT ? */
	{st_gid}	gid	:INT		/* Group: Ditto */
	{st_rdev}	rdev	:DEV_T	/* Seems useless (not even filled in) */
	{st_size}	size	:OFF_T	/* File size in bytes */
	{st_atime}	atime	:TIME_T	/* Accessed date (always 00:00 hrs local
				 * on FAT) */
	{st_mtime}	mtime	:TIME_T	/* Modified time */
	{st_ctime}	ctime	:TIME_T	/* Creation time */
ENDOBJECT

/*
->#if defined (__MSVCRT__)
NATIVE {_stati64} OBJECT _stati64
    {st_dev}	dev	:DEV_T
    {st_ino}	ino	:INO_T
    {st_mode}	mode	:UINT
    {st_nlink}	nlink	:INT
    {st_uid}	uid	:INT
    {st_gid}	gid	:INT
    {st_rdev}	rdev	:DEV_T
    {st_size}	size	:NATIVE {__int64} BIGVALUE
    {st_atime}	atime	:TIME_T
    {st_mtime}	mtime	:TIME_T
    {st_ctime}	ctime	:TIME_T
ENDOBJECT

NATIVE {__stat64} OBJECT __stat64
    {st_dev}	dev	:DEV_T
    {st_ino}	ino	:INO_T
    {st_mode}	mode	:MODE_T
    {st_nlink}	nlink	:INT
    {st_uid}	uid	:INT
    {st_gid}	gid	:INT
    {st_rdev}	rdev	:DEV_T
    {st_size}	size	:NATIVE {__int64} BIGVALUE
    {st_atime}	atime	:TIME64_T
    {st_mtime}	mtime	:TIME64_T
    {st_ctime}	ctime	:TIME64_T
ENDOBJECT
->#endif /* __MSVCRT__ */
*/
NATIVE {_STAT_DEFINED} DEF

NATIVE {_fstat} PROC
PROC fstat(param1:VALUE, param2:PTR TO _stat) IS NATIVE {_fstat( (int) } param1 {,} param2 {)} ENDNATIVE !!VALUE
NATIVE {_chmod} PROC
->PROC chmod(param1:ARRAY OF CHAR, param2:VALUE) IS NATIVE {_chmod(} param1 {, (int) } param2 {)} ENDNATIVE !!VALUE
->NATIVE {_stat} PROC
PROC stat(param1:ARRAY OF CHAR, param2:PTR TO _stat) IS NATIVE {_stat(} param1 {,} param2 {)} ENDNATIVE !!VALUE


/* These functions live in liboldnames.a. */
NATIVE {fstat} PROC
->PROC fstat(param1:VALUE, param2:PTR TO stat) IS NATIVE {fstat( (int) } param1 {,} param2 {)} ENDNATIVE !!VALUE
NATIVE {chmod} PROC
->PROC chmod(param1:ARRAY OF CHAR, param2:VALUE) IS NATIVE {chmod(} param1 {, (int) } param2 {)} ENDNATIVE !!VALUE
->NATIVE {stat} PROC
->PROC stat(param1:ARRAY OF CHAR, param2:PTR TO stat) IS NATIVE {stat(} param1 {,} param2 {)} ENDNATIVE !!VALUE


/*
->#if defined (__MSVCRT__)
NATIVE {_fstati64} PROC
PROC _fstati64(param1:VALUE, param2:PTR TO _stati64) IS NATIVE {_fstati64( (int) } param1 {,} param2 {)} ENDNATIVE !!VALUE
NATIVE {_stati64} PROC
PROC _stati64(param1:ARRAY OF CHAR, param2:PTR TO _stati64) IS NATIVE {_stati64(} param1 {,} param2 {)} ENDNATIVE !!VALUE
/* These require newer versions of msvcrt.dll (6.10 or higher).  */ 
->#if __MSVCRT_VERSION__ >= 0x0601
NATIVE {_fstat64} PROC
PROC _fstat64(param1:VALUE, param2:PTR TO __stat64) IS NATIVE {_fstat64( (int) } param1 {,} param2 {)} ENDNATIVE !!VALUE
NATIVE {_stat64} PROC
PROC _stat64(param1:ARRAY OF CHAR, param2:PTR TO __stat64) IS NATIVE {_stat64(} param1 {,} param2 {)} ENDNATIVE !!VALUE
->#endif /* __MSVCRT_VERSION__ >= 0x0601 */
->#if !defined ( _WSTAT_DEFINED) /* also declared in wchar.h */
NATIVE {_wstat} PROC
PROC _wstat(param1:ARRAY OF WCHAR_T, param2:PTR TO _stat) IS NATIVE {_wstat(} param1 {,} param2 {)} ENDNATIVE !!VALUE
NATIVE {_wstati64} PROC
PROC _wstati64(param1:ARRAY OF WCHAR_T, param2:PTR TO _stati64) IS NATIVE {_wstati64(} param1 {,} param2 {)} ENDNATIVE !!VALUE
->#if __MSVCRT_VERSION__ >= 0x0601
NATIVE {_wstat64} PROC
PROC _wstat64(param1:ARRAY OF WCHAR_T, param2:PTR TO __stat64) IS NATIVE {_wstat64(} param1 {,} param2 {)} ENDNATIVE !!VALUE
->#endif /* __MSVCRT_VERSION__ >= 0x0601 */
NATIVE {_WSTAT_DEFINED} DEF
->#endif /* _WSTAT_DEFIND */
->#endif /* __MSVCRT__ */
*/
