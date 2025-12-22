/*
 * toolmanager.h  V3.1
 *
 * ToolManager starter include file
 *
 * Copyright (C) 1990-98 Stefan Becker
 *
 * This source code is for educational purposes only. You may study it
 * and copy ideas or algorithms from it for your own projects. It is
 * not allowed to use any of the source codes (in full or in parts)
 * in other programs. Especially it is not allowed to create variants
 * of ToolManager or ToolManager-like programs from this source code.
 *
 */

/* OS include files */
#include <dos/dosextens.h>
#include <dos/var.h>
#include <intuition/intuition.h>
#include <libraries/toolmanager.h>

/* OS function prototypes */
#include <clib/dos_protos.h>
#include <clib/exec_protos.h>
#include <clib/intuition_protos.h>
#include <clib/locale_protos.h>
#include <clib/toolmanager_protos.h>

/* OS function inline calls */
#include <pragmas/dos_pragmas.h>
#include <pragmas/exec_pragmas.h>
#include <pragmas/intuition_pragmas.h>
#include <pragmas/locale_pragmas.h>
#include <pragmas/toolmanager_pragmas.h>

/* Localization */
#define CATCOMP_NUMBERS
#define CATCOMP_STRINGS
#include "/locale/toolmanager.h"

/* Debugging */
#ifdef DEBUG
/* Global data */
#define DEBUGFLAGENTRIES 1

/* Macros */
#define MAIN_LOG(x) _LOG(0,  0, (x))
#else
#define MAIN_LOG(x)
#endif

/* Global ToolManager definitions */
#include "/global.h"

#ifdef DEBUG
/* Global data */
extern struct Library *SysBase; /* For debugging routines */
#endif
