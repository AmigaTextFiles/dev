OPT NATIVE
MODULE 'target/_mingw'
{#include <sys/types.h>}

TYPE UBYTE IS NATIVE {unsigned char} CHAR
TYPE UINT  IS NATIVE {unsigned short} INT
TYPE ULONG IS NATIVE {unsigned long} VALUE
TYPE UBIGVALUE IS NATIVE {unsigned long long} BIGVALUE

/*
 * types.h
 * This file has no copyright assigned and is placed in the Public Domain.
 * This file is a part of the mingw-runtime package.
 * No warranty is given; refer to the file DISCLAIMER within the package.
 *
 * The definition of constants, data types and global variables.
 *
 */

NATIVE {_TYPES_H_} DEF

/* All the headers include this file. */
->#ifndef RC_INVOKED
->#include <stddef.h>
TYPE WCHAR_T   IS NATIVE {wchar_t}   VALUE
TYPE SIZE_T    IS NATIVE {size_t}    VALUE
TYPE PTRDIFF_T IS NATIVE {ptrdiff_t} VALUE
->#endif	/* Not RC_INVOKED */

->#ifndef RC_INVOKED

NATIVE {time_t} OBJECT
TYPE TIME_T IS NATIVE {time_t} VALUE
NATIVE {_TIME_T_DEFINED} DEF

NATIVE {__time64_t} OBJECT
TYPE TIME64_T IS NATIVE {__time64_t} BIGVALUE
NATIVE {_TIME64_T_DEFINED} DEF

NATIVE {_OFF_T_} DEF
NATIVE {_off_t} OBJECT
TYPE OFF_T IS NATIVE {off_t} VALUE		->NATIVE {_off_t} VALUE

NATIVE {off_t} OBJECT


NATIVE {_DEV_T_} DEF
NATIVE {_dev_t} OBJECT
TYPE DEV_T IS NATIVE {dev_t} INT		->NATIVE {_dev_t} INT

NATIVE {dev_t} OBJECT


NATIVE {_INO_T_} DEF
NATIVE {_ino_t} OBJECT
TYPE INO_T IS NATIVE {ino_t} INT		->NATIVE {_ino_t} INT

NATIVE {ino_t} OBJECT


NATIVE {_PID_T_} DEF
NATIVE {_pid_t} OBJECT
TYPE PID_T IS NATIVE {pid_t} VALUE		->NATIVE {_pid_t} VALUE

NATIVE {pid_t} OBJECT


NATIVE {_MODE_T_} DEF
NATIVE {_mode_t} OBJECT
TYPE MODE_T IS NATIVE {mode_t} INT		->NATIVE {_mode_t} INT

NATIVE {mode_t} OBJECT


NATIVE {_SIGSET_T_} DEF
NATIVE {_sigset_t} OBJECT
TYPE SIGSET_T IS NATIVE {sigset_t} VALUE		->NATIVE {_sigset_t} VALUE

NATIVE {sigset_t} OBJECT

NATIVE {_SSIZE_T_} DEF
NATIVE {_ssize_t} OBJECT
TYPE SSIZE_T IS NATIVE {ssize_t} VALUE		->NATIVE {_ssize_t} VALUE

NATIVE {ssize_t} OBJECT

NATIVE {_FPOS64_T_} DEF
NATIVE {fpos64_t} OBJECT
TYPE FPOS64_T IS NATIVE {fpos64_t} BIGVALUE

NATIVE {_OFF64_T_} DEF
NATIVE {off64_t} OBJECT
TYPE OFF64_T IS NATIVE {off64_t} BIGVALUE

->#endif	/* Not RC_INVOKED */
