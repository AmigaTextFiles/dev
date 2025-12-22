OPT NATIVE, PREPROCESS
{#include <sys/netinclude_types.h>}
/*
 * $Id: netinclude_types.h,v 1.3 2007-08-26 12:30:26 obarthel Exp $
 *
 * :ts=8
 *
 * 'Roadshow' -- Amiga TCP/IP stack
 * Copyright © 2001-2007 by Olaf Barthel.
 * All Rights Reserved.
 *
 * Amiga specific TCP/IP 'C' header files;
 * Freely Distributable
 */

NATIVE {_SYS_NETINCLUDE_TYPES_H} DEF

/****************************************************************************/

#define __LONG  LONG     /* signed 32-bit quantity */
#define __ULONG LONG     /* unsigned 32-bit quantity */
#define __WORD  INT      /* signed 16-bit quantity */
#define __UWORD INT      /* unsigned 16-bit quantity */
#define __BYTE  BYTE     /* signed 8-bit quantity */
#define __UBYTE BYTE     /* unsigned 8-bit quantity */

/****************************************************************************/

#define __APTR ARRAY /* 32-bit untyped pointer */

/****************************************************************************/

#define __STRPTR ARRAY OF CHAR /* string pointer (NULL terminated) */

#define __TEXT CHAR /* Non-negative character */
