#ifndef TEST_H
#define TEST_H

#include <exec/types.h>
#include <exec/memory.h>
#include <exec/libraries.h>
#include <exec/lists.h>

#include <dos/dos.h>
#include <workbench/startup.h>
#include <workbench/workbench.h>

#ifdef __GNUC__
/* GCC needs all struct defs */
#include <dos/exall.h>
#include <graphics/graphint.h>
#include <intuition/classes.h>
#include <devices/keymap.h>
#include <exec/semaphores.h>
#endif

#include <clib/alib_protos.h>
#include <clib/exec_protos.h>
#include <clib/dos_protos.h>
#include <clib/icon_protos.h>
#include <clib/rexxsyslib_protos.h>

#ifndef __NO_PRAGMAS

#ifdef AZTEC_C
#include <pragmas/exec_lib.h>
#include <pragmas/dos_lib.h>
#include <pragmas/icon_lib.h>
#include <pragmas/rexxsyslib_lib.h>
#endif

#ifdef LATTICE
#include <pragmas/exec_pragmas.h>
#include <pragmas/dos_pragmas.h>
#include <pragmas/icon_pragmas.h>
#include <pragmas/rexxsyslib_pragmas.h>
#endif

#endif /* __NO_PRAGMAS */

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <fcntl.h>
#include <ctype.h>

#ifndef _toupper
#define _toupper(x) ((x) & 0x5f)
#endif

#endif /* TEST_H */
