#ifndef _INCLUDE_ERRNO_H
#define _INCLUDE_ERRNO_H

/*
**  $VER: errno.h 1.0 (18.1.96)
**  StormC Release 1.1
**
**  '(C) Copyright 1995/96 Haage & Partner Computer GmbH'
**	 All Rights Reserved
*/

extern int errno;

#define EUSRBRK 900  /* User break: used as arg to exit() */
#define EASSERT 990  /* macro assert: used as arg to exit() */
#define EFREEMEM 996 /* free() or delete() with illegal arg: used as arg to exit() */
#define ERANGE 1000  /* mathematical overflow */
#define ENONUM 1001  /* string is invalid number */
#define ENOMEM 1002  /* not enough memory */

#endif
