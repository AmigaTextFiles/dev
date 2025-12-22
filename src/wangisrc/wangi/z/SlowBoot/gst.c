/*************************************************************************
 *
 * SlowBoot
 *
 * Copyright ©1995 Lee Kindness cs2lk@scms.rgu.ac.uk
 *
 * gst.c
 */

#include <exec/types.h>
#include <dos/dos.h>
#include <dos/dosextens.h>
#include <dos/dostags.h>

#include <clib/exec_protos.h>
#include <clib/dos_protos.h>

#include <pragmas/exec_sysbase_pragmas.h>
#include <pragmas/dos_pragmas.h>

extern struct ExecBase *SysBase;
extern struct DosLibrary *DOSBase;
