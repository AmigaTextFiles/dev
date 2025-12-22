/*
 * $Id: global.h 1.2 1998/04/18 15:45:01 olsen Exp olsen $
 *
 * :ts=4
 *
 * Blowup -- Catches and displays task errors
 *
 * Written by Olaf `Olsen' Barthel <olsen@sourcery.han.de>
 * Public Domain
 */

#ifndef _GLOBAL_H
#define _GLOBAL_H 1

/******************************************************************************/

#ifndef _SYSTEM_HEADERS_H
#include "system_headers.h"
#endif	/* _SYSTEM_HEADERS_H */

/******************************************************************************/

#define MILLION 1000000

/******************************************************************************/

#define MAX_FILENAME_LEN 256

/******************************************************************************/

#define SIG_Stop	SIGBREAKF_CTRL_C

/******************************************************************************/

#ifdef __SASC
#define FAR			__far
#define ASM			__asm
#define REG(x)		register __ ## x
#endif	/* __SASC */

/******************************************************************************/

#define FLAG_IS_SET(v,f)	(((v) & (f)) != 0)
#define FLAG_IS_CLEAR(v,f)	(((v) & (f)) == 0)

/******************************************************************************/

#define OK		(0)
#define SAME	(0)
#define NO		!
#define NOT		!
#define CANNOT	!

/******************************************************************************/

#define SUCCESS	(TRUE)
#define FAILURE	(FALSE)

/******************************************************************************/

typedef STRPTR	KEY;
typedef LONG *	NUMBER;
typedef LONG	SWITCH;

/******************************************************************************/

#define PORT_MASK(p) (1UL << (p)->mp_SigBit)

/******************************************************************************/

#define NUM_ELEMENTS(t)	(sizeof(t) / sizeof(t[0]))

/******************************************************************************/

#include "data.h"
#include "protos.h"

/******************************************************************************/

VOID kprintf(const STRPTR,...);

/******************************************************************************/

#include "Assert.h"

/******************************************************************************/

#endif	/* _GLOBAL_H */
