/*
** NAME: ModemLinkDev.c
** DESC: This file contains the init and shut down routines for the device.
**       When the device is opened using OpenDevice() the SAS/C device code
**       will call __UserDevInit().  When the device is closed it will then
**       make a call to __UserDevCleanup.  These are obviously only used in
**       the device version of the modemlink package.
**
** AUTHOR:        DATE:       DESCRIPTION:
** ~~~~~~~~~~~~~~ ~~~~~~~~~~~ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
** Mike Veroukis  06 Apr 1997 Created
** Mike Veroukis  26 Oct 1997 Found bug in __UserDevInit.  It wasn't creating
**                            the ModemLink semaphore used to lock out other
**                            instances of the same Unit number.
*/


#include <exec/execbase.h>
#include <exec/io.h>
#include <exec/memory.h>
#include <exec/semaphores.h>
#include <proto/exec.h>
#include <proto/intuition.h>

#include "Link.h"

extern struct ExecBase *SysBase;


int  __saveds __asm __UserDevInit(register __d0 long unit,
                                   register __a0 struct IORequest *ior,
                                   register __a6 struct Library *libbase)
{
  struct IOExtLink *LinkIO = (struct IOExtLink *)ior;
  struct SignalSemaphore *DevSem;
  char SemName[20];
  int ReturnCode = 0;

  /*
  ** can only run under 2.0 or greater
  */
  if (SysBase->LibNode.lib_Version < 36)
    ReturnCode = 1;
  else {
    stcl_h(SemName, LinkIO->Unit);
    strins(SemName, "ModemLink");

    Forbid();

    DevSem = FindSemaphore(SemName);
    if (!DevSem) {
      if (DevSem = AllocMem(sizeof(struct SignalSemaphore), MEMF_PUBLIC | MEMF_CLEAR)) {
        InitSemaphore(DevSem);

        DevSem->ss_Link.ln_Pri = 0;
        DevSem->ss_Link.ln_Name = AllocMem(strlen(SemName) + 1L, MEMF_PUBLIC | MEMF_CLEAR);
        strcpy(DevSem->ss_Link.ln_Name, SemName);

        AddSemaphore(DevSem);
        ObtainSemaphore(DevSem);
      }
      else {
        Permit();
        ReturnCode = 2;
      }
    }
    else {
      Permit();
      ReturnCode = 3;
    }

    Permit();

    if (!ReturnCode) {
      LinkIO->LinkPortName[0] = 0;
      LinkIO->LinkProcName[0] = 0;
      LinkIO->Unit = unit;
    }
  }

  ior->io_Error = ReturnCode;
  return ReturnCode;
}

void __saveds __asm __UserDevCleanup(register __a0 struct IORequest *ior,
                                     register __a6 struct Library *libbase)
{
  struct IOExtLink *LinkIO = (struct IOExtLink *)ior;
  struct SignalSemaphore *DevSem;
  char SemName[20];

  if (LinkIO->LinkProcName[0] && FindTask(LinkIO->LinkProcName))
    ML_Terminate(LinkIO);

  stcl_h(SemName, LinkIO->Unit);
  strins(SemName, "ModemLink");

  Forbid();

  if (DevSem = FindSemaphore(SemName)) {
    RemSemaphore(DevSem);
    ReleaseSemaphore(DevSem);
    if (DevSem->ss_Link.ln_Name)
      FreeMem(DevSem->ss_Link.ln_Name, strlen(DevSem->ss_Link.ln_Name) + 1L);
    FreeMem(DevSem, sizeof(struct SignalSemaphore));
  }

  Permit();
}
