#ifndef  FLUSH_H
#define  FLUSH_H

/*
 * --------------------------------------------------------------
 * Project name: FLUSHLibrary    Launched: 01/04/92      by Ms...
 * --------------------------------------------------------------
 * This file "flush.library C include file"
 *       created: 01/04/92               last modified: 14/04/92
 *       version: 1.1                    PV: 003
 * These are general data, needed by client programs written in
 * the C programming language.
 * These are library function definitions.
 *
 * FLUSH:C-Support/Flush.H                flush@alphanet.imp.com
 * This file (C) Marc Schaefer 1992.
 * Created by Michel Schinz, and fine tuned to the Commodore
 * specifications by Yves Perrenoud.
 */

#ifndef  EXEC_TYPES_H
#include <exec/types.h>
#endif

/* Defines */

#define MODE_SIGNALME   1
#define MODE_HANDLER    2
#define MODE_MSG        3

/* Pragmas. */

#ifdef LATTICE
#pragma libcall FlushBase FlushDo 1E 0
#pragma libcall FlushBase FlushEnableAnnounce 24 218004
#pragma libcall FlushBase FlushDisableAnnounce 2A 001
#endif LATTICE

/* Protos. */

void FlushDo(void);
ULONG FlushEnableAnnounce(ULONG mode, APTR handler, ULONG data, LONG pri);
void FlushDisableAnnounce(ULONG flushid);

#endif   /* FLUSH_H */
