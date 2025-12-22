OPT NATIVE
PUBLIC MODULE 'target/io'
MODULE 'target/_mingw'
{#include <fcntl.h>}
/*
 * fcntl.h
 * This file has no copyright assigned and is placed in the Public Domain.
 * This file is a part of the mingw-runtime package.
 * No warranty is given; refer to the file DISCLAIMER within the package.
 *
 * Access constants for _open. Note that the permissions constants are
 * in sys/stat.h (ick).
 *
 */
NATIVE {_FCNTL_H_} DEF

/* All the headers include this file. */

/*
 * It appears that fcntl.h should include io.h for compatibility...
 */


/* Specifiy one of these flags to define the access mode. */
NATIVE {_O_RDONLY}	CONST O_RDONLY	= 0
NATIVE {_O_WRONLY}	CONST O_WRONLY	= 1
NATIVE {_O_RDWR}		CONST O_RDWR		= 2

/* Mask for access mode bits in the _open flags. */
NATIVE {_O_ACCMODE}	CONST O_ACCMODE	= (O_RDONLY OR O_WRONLY OR O_RDWR)

NATIVE {_O_APPEND}	CONST O_APPEND	= $0008	/* Writes will add to the end of the file. */

NATIVE {_O_RANDOM}	CONST O_RANDOM	= $0010
NATIVE {_O_SEQUENTIAL}	CONST O_SEQUENTIAL	= $0020
NATIVE {_O_TEMPORARY}	CONST O_TEMPORARY	= $0040	/* Make the file dissappear after closing.
				 * WARNING: Even if not created by _open! */
NATIVE {_O_NOINHERIT}	CONST O_NOINHERIT	= $0080

NATIVE {_O_CREAT}	CONST O_CREAT	= $0100	/* Create the file if it does not exist. */
NATIVE {_O_TRUNC}	CONST O_TRUNC	= $0200	/* Truncate the file if it does exist. */
NATIVE {_O_EXCL}		CONST O_EXCL		= $0400	/* Open only if the file does not exist. */

NATIVE {_O_SHORT_LIVED}  CONST O_SHORT_LIVED  = $1000

/* NOTE: Text is the default even if the given _O_TEXT bit is not on. */
NATIVE {_O_TEXT}		CONST O_TEXT		= $4000	/* CR-LF in file becomes LF in memory. */
NATIVE {_O_BINARY}	CONST O_BINARY	= $8000	/* Input and output is not translated. */
NATIVE {_O_RAW}		CONST O_RAW		= O_BINARY

->#ifndef	_NO_OLDNAMES

/* POSIX/Non-ANSI names for increased portability */
NATIVE {O_RDONLY}	CONST ->O_RDONLY	= _O_RDONLY
NATIVE {O_WRONLY}	CONST ->O_WRONLY	= _O_WRONLY
NATIVE {O_RDWR}		CONST ->O_RDWR		= _O_RDWR
NATIVE {O_ACCMODE}	CONST ->O_ACCMODE	= _O_ACCMODE
NATIVE {O_APPEND}	CONST ->O_APPEND	= _O_APPEND
NATIVE {O_CREAT}		CONST ->O_CREAT		= _O_CREAT
NATIVE {O_TRUNC}		CONST ->O_TRUNC		= _O_TRUNC
NATIVE {O_EXCL}		CONST ->O_EXCL		= _O_EXCL
NATIVE {O_TEXT}		CONST ->O_TEXT		= _O_TEXT
NATIVE {O_BINARY}	CONST ->O_BINARY	= _O_BINARY
NATIVE {O_TEMPORARY}	CONST ->O_TEMPORARY	= _O_TEMPORARY
NATIVE {O_NOINHERIT}	CONST ->O_NOINHERIT	= _O_NOINHERIT
NATIVE {O_SEQUENTIAL}	CONST ->O_SEQUENTIAL	= _O_SEQUENTIAL
NATIVE {O_RANDOM}	CONST ->O_RANDOM	= _O_RANDOM

->#endif	/* Not _NO_OLDNAMES */
