/*
 * RemDev.c   V0.02 (beta)
 *
 * "UnMount" a DOS device. USE WITH CARE!!!
 *
 * (c) 1991 by Stefan Becker
 *
 */

#include <dos/dos.h>
#include <dos/filehandler.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <clib/exec_protos.h>
#include <clib/dos_protos.h>

#define FreeDosMem(aptr) FreeMem((ULONG *) (aptr)-1, *((ULONG *) (aptr)-1))

char ident[]="$VER: remdev 0.02 (07.04.1991)";

void main(int argc, char *argv[])
{
 char *s;
 struct MsgPort *devpr;

 if (argc<2)
  {
   printf("Usage: %s <name>\n",argv[0]);
   exit(20);
  }

 /* Copy name string */
 if (s=strdup(argv[1]))
  {
   /* Remove trailing ':' */
   s[strlen(s)-1]='\0';

   /* Find device handler process */
   if (devpr=DeviceProc(argv[1]))

    /* Send shutdown packet to handler process */
    if (DoPkt(devpr,ACTION_DIE,0,0,0,0,0)==DOSTRUE)
     {
      /* Handler process has stopped. Remove device node */
      struct DosList *dol1,*dol2;

      dol1=LockDosList(LDF_DEVICES|LDF_WRITE);

      if (dol2=FindDosEntry(dol1,s,LDF_DEVICES)) RemDosEntry(dol2);

      UnLockDosList(LDF_DEVICES|LDF_WRITE);

      if (dol2)
       {
        /* Free memory associated with the device node */
        struct FileSysStartupMsg *fssm=BADDR(dol2->
                                             dol_misc.dol_handler.dol_Startup);

        FreeDosMem(BADDR(fssm->fssm_Device));
        FreeDosMem(BADDR(fssm->fssm_Environ));
        FreeDosMem(fssm);
        FreeDosMem(BADDR(dol2->dol_misc.dol_handler.dol_Handler));

        /* Unload handler code */
        UnLoadSeg(dol2->dol_misc.dol_handler.dol_SegList);

        FreeDosEntry(dol2);
        printf("Device '%s' removed!\n",argv[1]);
       }
     }
    else printf("Handler of device '%s' wouldn't die!\n",argv[1]);
   else printf("Device '%s' not found!\n",argv[1]);

   free(s);
  }

 exit(0);
}
