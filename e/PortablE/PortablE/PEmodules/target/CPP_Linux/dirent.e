OPT NATIVE
MODULE 'target/linux/limits'	->guessed
MODULE 'target/features'
MODULE 'target/x86_64-linux-gnu/bits/types'
PUBLIC MODULE 'target/x86_64-linux-gnu/bits/dirent'
/* Get the definitions of the POSIX.1 limits.  */
  MODULE 'target/x86_64-linux-gnu/bits/posix1_lim'
 MODULE 'target/stddef'
MODULE 'target/x86_64-linux-gnu/bits/dirent_ext'
{#include <dirent.h>}
/* Copyright (C) 1991-2020 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, see
   <https://www.gnu.org/licenses/>.  */

/*
 *	POSIX Standard: 5.1.2 Directory Operations	<dirent.h>
 */

NATIVE {_DIRENT_H}	CONST ->_DIRENT_H	= 1


->NATIVE {ino_t} OBJECT
->TYPE ino_t IS NATIVE {ino_t} INO_T__
  ->NATIVE {__ino_t_defined} DEF
->NATIVE {ino64_t} OBJECT
->TYPE ino64_t IS NATIVE {ino64_t} INO64_T__
  ->NATIVE {__ino64_t_defined} DEF

/* This file defines `struct dirent'.

   It defines the macro `_DIRENT_HAVE_D_NAMLEN' iff there is a `d_namlen'
   member that gives the length of `d_name'.

   It defines the macro `_DIRENT_HAVE_D_RECLEN' iff there is a `d_reclen'
   member that gives the size of the entire directory entry.

   It defines the macro `_DIRENT_HAVE_D_OFF' iff there is a `d_off'
   member that gives the file offset of the next directory entry.

   It defines the macro `_DIRENT_HAVE_D_TYPE' iff there is a `d_type'
   member that gives the type of the file.
 */


/*
#if defined __USE_MISC && !defined d_fileno
 NATIVE {d_ino}	CONST D_INO	= d_fileno		 /* Backward compatibility.  */
#endif
*/

/* These macros extract size information from a `struct dirent *'.
   They may evaluate their argument multiple times, so it must not
   have side effects.  Each of these may involve a relatively costly
   call to `strlen' on some systems, so these values should be cached.

   _D_EXACT_NAMLEN (DP)	returns the length of DP->d_name, not including
   its terminating null character.

   _D_ALLOC_NAMLEN (DP)	returns a size at least (_D_EXACT_NAMLEN (DP) + 1);
   that is, the allocation size needed to hold the DP->d_name string.
   Use this macro when you don't need the exact length, just an upper bound.
   This macro is less likely to require calling `strlen' than _D_EXACT_NAMLEN.
   */

 NATIVE {_D_EXACT_NAMLEN} PROC	->define _D_EXACT_NAMLEN(d) (strlen ((d)->d_name))
  NATIVE {_D_ALLOC_NAMLEN} PROC	->define _D_ALLOC_NAMLEN(d) (((char *) (d) + (d)->d_reclen) - &(d)->d_name[0])


/* File types for `d_type'.  */
NATIVE {DT_UNKNOWN} CONST DT_UNKNOWN = 0
NATIVE {DT_FIFO} CONST DT_FIFO = 1
NATIVE {DT_CHR} CONST DT_CHR = 2
NATIVE {DT_DIR} CONST DT_DIR = 4
NATIVE {DT_BLK} CONST DT_BLK = 6
NATIVE {DT_REG} CONST DT_REG = 8
NATIVE {DT_LNK} CONST DT_LNK = 10
NATIVE {DT_SOCK} CONST DT_SOCK = 12
NATIVE {DT_WHT} CONST DT_WHT = 14
  

/* Convert between stat structure types and directory types.  */
 NATIVE {IFTODT} CONST	->define IFTODT(mode)	(((mode) & 0170000) >> 12)
 NATIVE {DTTOIF} CONST	->define DTTOIF(dirtype)	((dirtype) << 12)


/* This is the data type of directory stream objects.
   The actual structure is opaque to users.  */
NATIVE {DIR} CONST
TYPE DIR IS NATIVE {DIR} VALUE	->#this is a kludge, as "VALUE" should really be "__dirstream", which is declared in "sysdeps/unix/dirstream.h"

/* Open a directory stream on NAME.
   Return a DIR stream on the directory, or NULL if it could not be opened.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
NATIVE {opendir} PROC
PROC opendir(__name:ARRAY OF CHAR) IS NATIVE {opendir(} __name {)} ENDNATIVE !!PTR TO DIR

/* Same as opendir, but open the stream on the file descriptor FD.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
NATIVE {fdopendir} PROC
PROC fdopendir(__fd:VALUE) IS NATIVE {fdopendir( (int) } __fd {)} ENDNATIVE !!PTR TO DIR

/* Close the directory stream DIRP.
   Return 0 if successful, -1 if not.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
NATIVE {closedir} PROC
PROC closedir(__dirp:PTR TO DIR) IS NATIVE {closedir(} __dirp {)} ENDNATIVE !!VALUE

/* Read a directory entry from DIRP.  Return a pointer to a `struct
   dirent' describing the entry, or NULL for EOF or error.  The
   storage returned may be overwritten by a later readdir call on the
   same DIR stream.

   If the Large File Support API is selected we have to use the
   appropriate interface.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
NATIVE {readdir} PROC
PROC readdir(__dirp:PTR TO DIR) IS NATIVE {readdir(} __dirp {)} ENDNATIVE !!PTR TO dirent

NATIVE {readdir64} PROC
PROC readdir64(__dirp:PTR TO DIR) IS NATIVE {readdir64(} __dirp {)} ENDNATIVE !!PTR TO dirent64

/* Reentrant version of `readdir'.  Return in RESULT a pointer to the
   next entry.

   This function is a possible cancellation point and therefore not
   marked with __THROW.  */
NATIVE {readdir_r} PROC
PROC readdir_r(__dirp:PTR TO DIR,
		      __entry:PTR TO dirent,
		      __result:ARRAY OF PTR TO dirent) IS NATIVE {readdir_r(} __dirp {,} __entry {, (dirent **__restrict ) } __result {)} ENDNATIVE !!VALUE
     
NATIVE {readdir64_r} PROC
PROC readdir64_r(__dirp:PTR TO DIR,
			__entry:PTR TO dirent64,
			__result:ARRAY OF PTR TO dirent64) IS NATIVE {readdir64_r(} __dirp {,} __entry {, (dirent64 **__restrict ) } __result {)} ENDNATIVE !!VALUE

/* Rewind DIRP to the beginning of the directory.  */
NATIVE {rewinddir} PROC
PROC rewinddir(__dirp:PTR TO DIR) IS NATIVE {rewinddir(} __dirp {)} ENDNATIVE


/* Seek to position POS on DIRP.  */
NATIVE {seekdir} PROC
PROC seekdir(__dirp:PTR TO DIR, __pos:CLONG) IS NATIVE {seekdir(} __dirp {,} __pos {)} ENDNATIVE

/* Return the current position of DIRP.  */
NATIVE {telldir} PROC
PROC telldir(__dirp:PTR TO DIR) IS NATIVE {telldir(} __dirp {)} ENDNATIVE !!CLONG


/* Return the file descriptor used by DIRP.  */
NATIVE {dirfd} PROC
PROC dirfd(__dirp:PTR TO DIR) IS NATIVE {dirfd(} __dirp {)} ENDNATIVE !!VALUE

/*
 #if defined __OPTIMIZE__ && defined _DIR_dirfd
  NATIVE {dirfd} PROC	->define dirfd(dirp)	_DIR_dirfd (dirp)
 #endif
*/


/* `MAXNAMLEN' is the BSD name for what POSIX calls `NAME_MAX'.  */
    NATIVE {MAXNAMLEN}	CONST MAXNAMLEN	= NAME_MAX

 ->NATIVE {__need_size_t} DEF

/* Scan the directory DIR, calling SELECTOR on each directory entry.
   Entries for which SELECT returns nonzero are individually malloc'd,
   sorted using qsort with CMP, and collected in a malloc'd array in
   *NAMELIST.  Returns the number of entries selected, or -1 on error.

   This function is a cancellation point and therefore not marked with
   __THROW.  */
NATIVE {scandir} PROC
PROC scandir(__dir:ARRAY OF CHAR,
		    __namelist:PTR TO ARRAY /*OF PTR TO dirent*/,
		    __selector:PTR /*int (*__selector) (const struct dirent *)*/,
		    __cmp:PTR /*int (*__cmp) (const struct dirent **,
				  const struct dirent **)*/) IS NATIVE {scandir(} __dir {, (dirent ***__restrict ) } __namelist {, (int (*) (const struct dirent *)) } __selector {, (int (*) (const struct dirent **, const struct dirent **)) } __cmp {)} ENDNATIVE !!VALUE

/* This function is like `scandir' but it uses the 64bit dirent structure.
   Please note that the CMP function must now work with struct dirent64 **.  */
NATIVE {scandir64} PROC
PROC scandir64(__dir:ARRAY OF CHAR,
		      __namelist:PTR TO ARRAY /*OF PTR TO dirent64*/,
		      __selector:PTR /*int (*__selector) (const struct dirent64 *)*/,
		      __cmp:PTR /*int (*__cmp) (const struct dirent64 **,
				    const struct dirent64 **)*/) IS NATIVE {scandir64(} __dir {, (dirent64 ***__restrict ) } __namelist {, (int (*) (const struct dirent64 *)) } __selector {, (int (*) (const struct dirent64 **, const struct dirent64 **)) } __cmp {)} ENDNATIVE !!VALUE

/* Similar to `scandir' but a relative DIR name is interpreted relative
   to the directory for which DFD is a descriptor.

   This function is a cancellation point and therefore not marked with
   __THROW.  */
NATIVE {scandirat} PROC
PROC scandirat(__dfd:VALUE, __dir:ARRAY OF CHAR,
		      __namelist:PTR TO ARRAY /*OF PTR TO dirent*/,
		      __selector:PTR /*int (*__selector) (const struct dirent *)*/,
		      __cmp:PTR /*int (*__cmp) (const struct dirent **,
				    const struct dirent **)*/) IS NATIVE {scandirat( (int) } __dfd {,} __dir {, (dirent ***__restrict ) } __namelist {, (int (*) (const struct dirent *)) } __selector {, (int (*) (const struct dirent **, const struct dirent **)) } __cmp {)} ENDNATIVE !!VALUE

/* This function is like `scandir' but it uses the 64bit dirent structure.
   Please note that the CMP function must now work with struct dirent64 **.  */
NATIVE {scandirat64} PROC
PROC scandirat64(__dfd:VALUE, __dir:ARRAY OF CHAR,
			__namelist:PTR TO ARRAY /*OF PTR TO dirent64*/,
			__selector:PTR /*int (*__selector) (const struct dirent64 *)*/,
			__cmp:PTR /*int (*__cmp) (const struct dirent64 **,
				      const struct dirent64 **)*/) IS NATIVE {scandirat64( (int) } __dfd {,} __dir {, (dirent64 ***__restrict ) } __namelist {, (int (*) (const struct dirent64 *)) } __selector {, (int (*) (const struct dirent64 **, const struct dirent64 **)) } __cmp {)} ENDNATIVE !!VALUE

/* Function to compare two `struct dirent's alphabetically.  */
NATIVE {alphasort} PROC
PROC alphasort(__e1:ARRAY OF PTR TO dirent,
		      __e2:ARRAY OF PTR TO dirent) IS NATIVE {alphasort( (const dirent **) } __e1 {, (const dirent **) } __e2 {)} ENDNATIVE !!VALUE

NATIVE {alphasort64} PROC
PROC alphasort64(__e1:ARRAY OF PTR TO dirent64,
			__e2:ARRAY OF PTR TO dirent64) IS NATIVE {alphasort64( (const dirent64 **) } __e1 {, (const dirent64 **) } __e2 {)} ENDNATIVE !!VALUE


/* Read directory entries from FD into BUF, reading at most NBYTES.
   Reading starts at offset *BASEP, and *BASEP is updated with the new
   position after reading.  Returns the number of bytes read; zero when at
   end of directory; or -1 for errors.  */
NATIVE {getdirentries} PROC
PROC getdirentries(__fd:VALUE, __buf:ARRAY OF CHAR,
				__nbytes:SIZE_T,
				__basep:PTR TO OFF_T__) IS NATIVE {getdirentries( (int) } __fd {,} __buf {,} __nbytes {,} __basep {)} ENDNATIVE !!SSIZE_T__

NATIVE {getdirentries64} PROC
PROC getdirentries64(__fd:VALUE, __buf:ARRAY OF CHAR,
				  __nbytes:SIZE_T,
				  __basep:PTR TO OFF64_T__) IS NATIVE {getdirentries64( (int) } __fd {,} __buf {,} __nbytes {,} __basep {)} ENDNATIVE !!SSIZE_T__

/* Function to compare two `struct dirent's by name & version.  */
NATIVE {versionsort} PROC
PROC versionsort(__e1:ARRAY OF PTR TO dirent,
			__e2:ARRAY OF PTR TO dirent) IS NATIVE {versionsort( (const dirent **) } __e1 {, (const dirent **) } __e2 {)} ENDNATIVE !!VALUE

NATIVE {versionsort64} PROC
PROC versionsort64(__e1:ARRAY OF PTR TO dirent64,
			  __e2:ARRAY OF PTR TO dirent64) IS NATIVE {versionsort64( (const dirent64 **) } __e1 {, (const dirent64 **) } __e2 {)} ENDNATIVE !!VALUE
