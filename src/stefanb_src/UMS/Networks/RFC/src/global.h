/*
 * global.h V1.0.01
 *
 * UMS RFC common include file
 *
 * (c) 1997-98 Stefan Becker
 */

#define UMS_V11_NAMES_ONLY

/* OS include files */
#include <exec/types.h>
#include <exec/memory.h>
#include <dos/dos.h>
#include <libraries/umsrfc.h>

/* OS function prototypes */
#include <clib/dos_protos.h>
#include <clib/exec_protos.h>
#include <clib/ums_protos.h>
#include <clib/umsrfc_protos.h>

/* OS function inline calls */
#include <pragmas/dos_pragmas.h>
#include <pragmas/exec_pragmas.h>
#include <pragmas/ums_pragmas.h>
#include <pragmas/umsrfc_pragmas.h>

/* ANSI C include files */
#include <stdio.h>
#include <stdlib.h>
#include <strings.h>

/* Debugging */
#ifdef DEBUG
void kprintf(const char *, ...);
#define DEBUGLOG(x) x
#else
#define DEBUGLOG(x)
#endif
