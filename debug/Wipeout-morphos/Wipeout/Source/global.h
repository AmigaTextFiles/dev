/*
 * $Id: global.h,v 1.5 2009/06/14 08:46:40 itix Exp $
 *
 * :ts=4
 *
 * Wipeout -- Traces and munges memory and detects memory trashing
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

#define	TRACKEDCALLERSTACKSIZE	16

/******************************************************************************/

#define MILLION 1000000

/******************************************************************************/

#define MAX_FILENAME_LEN 256

/******************************************************************************/

#define SIG_Handshake	SIGF_SINGLE
#define SIG_Check		SIGBREAKF_CTRL_C
#define SIG_Disable		SIGBREAKF_CTRL_D
#define SIG_Enable		SIGBREAKF_CTRL_E

/******************************************************************************/

#ifdef __SASC
#define FAR		__far
#define ASM		__asm
#define REG(x)	register __ ## x
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

#include "wipeoutsemaphore.h"
#include "taskinfo.h"
#include "magic.h"
#include "allocator.h"
#include "pools.h"
#include "data.h"
#include "protos.h"

#define	CALLEDFROMSUPERVISORMODE(...)	FALSE		//CalledFromSupervisorMode()

/******************************************************************************/

VOID kprintf(const STRPTR,...);

/******************************************************************************/

#include "assert.h"

/******************************************************************************/

#if defined(__MORPHOS__)
#define __TEXTSEGMENT__ __attribute__((section(".text")))
#else
#define __TEXTSEGMENT__
#endif

/******************************************************************************/

#endif	/* _GLOBAL_H */
