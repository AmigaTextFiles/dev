/**************************************************************************** 

$Source: MASTER:lib/misc/c_task.c,v $
$Revision: 3.0 $
$Date: 1994/07/08 09:10:46 $

This file contains those routines and global variables required by the SAS/C
link libraries.  Include it in your dottellenkay.  Also in this file is the
StdEntry procedure which will will set up a "standard" C program
environment for VMEbus systems running AmiExec.

****************************************************************************/
#include <exec/resident.h>
#include <ext/exec.h>
#include <resources/cpu.h>
#include <proto/exec.h>


/* C language globals. */

ULONG  _OSERR;
ULONG  _SIGFPE;
ULONG  _ONBREAK;
ULONG  _ProgramName;
ULONG *_oserr = &_OSERR;


/* AmiExec, VME system globals. */

struct ExecBase *SysBase;
ULONG  VMEbusStandard;
ULONG  VMEbusShort;


/*-----------------------------------***-----------------------------------*/

void __asm StdEntry(register __a6 struct ExecBase *sysbase)

/* Function: This function sets up the VME execution environment by initializing 
             commonly used global variables so that modules can just assume that 
             they exist and are valid.  At the moment it:
                  - initializes SysBase so the caller has access to
                    exec.library
                  - initializes the pointers VMEbusStandard and VMEbusShort.
                    These are pointers to the bus address spaces.

             Future additions may include the initialization of a private
             memory pool.

             Only ROM resident tasks and processes should specify this as their 
             entry point.  Tasks created at run-time needn't bother with this
             procedure as they share their creators link space.
             
   Inputs:   sysbase - ptr to exec.library */

{
   struct CPUResource *cpu;
   struct Resident    *resident;


   /* Stuff SysBase.  Nobody on a VME system should be using AbsSysBase
      to find Exec because AbsSysBase may change from system to system. */

   SysBase = sysbase;


   /* As of AmiExec V3R0 VME bus addresses are available via a cpu.resource.
      Support the older individual ROMTag method as well. */

   cpu = (struct CPUResource *) OpenResource("cpu.resource");
   if (cpu != NULL)
      {
      VMEbusStandard = cpu->VMEbusStandard;
      VMEbusShort = cpu->VMEbusShort;
      }
   else
      {
      resident = FindResident("VMEbusStandard");   
      if (resident != NULL)
         VMEbusStandard = (ULONG) ((struct RtInitMem *) resident->rt_Init)->base;
      else
         VMEbusStandard = -1;

      resident = FindResident("VMEbusShort");   
      if (resident != NULL)
         VMEbusShort = (ULONG) ((struct RtInitMem *) resident->rt_Init)->base;
      else
         VMEbusShort = -1;
      }


   /* Startup type code complete - invoke user mainline. */

   main();
}
      

/*-------------------------------------------------------------------------*/

void XCEXIT(void)

/* This function is required for successful linking.  Nobody exits on a VME 
   system so nobody should ever end up here.  This function performs a Crash, 
   complaining that it's been called. */

{
   Crash("SAS/C: XCEXIT() - Not allowed.");
}


/*-------------------------------------------------------------------------*/

void _XCEXIT(void)

{
   Crash("SAS/C: _XCEXIT() - Not allowed.");
}
