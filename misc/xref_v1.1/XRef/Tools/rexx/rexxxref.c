/*
** $PROJECT: rexxxref.library
**
** $VER: rexxxref.c 1.1 (08.01.95)
**
** by
**
** Stefan Ruppert , Windthorststraße 5 , 65439 Flörsheim , GERMANY
**
** (C) Copyright 1995
** All Rights Reserved !
**
** $HISTORY:
**
** 08.01.95 : 001.001 : initial
*/

#include "rexxxref.h"


LibCall struct Library *LibInit (REGD0 struct RexxXRefBase *rxb, REGA0 BPTR seglist, REGA6 struct Library * sysbase)
{
   rxb->rxb_SegList = seglist;
   rxb->rxb_SysBase = sysbase;

   if(rxb->rxb_SysBase->lib_Version >= 37)
   {
      if((rxb->rxb_XRefBase      = OpenLibrary ("xref.library", 1)))
      {
         if((rxb->rxb_RexxSysBase = OpenLibrary("rexxsyslib.library",36)))
         {
            rxb->rxb_IntuitionBase = OpenLibrary ("intuition.library",37);
            rxb->rxb_DOSBase       = OpenLibrary ("dos.library",      37);
            rxb->rxb_UtilityBase   = OpenLibrary ("utility.library",  37);
         } else
         {
            CloseLibrary(rxb->rxb_XRefBase);
            rxb = NULL;
         }
      } else
         rxb = NULL;
   } else
      rxb = NULL;

  return((struct Library *) rxb);
}

LibCall LONG LibOpen (REGA6 struct RexxXRefBase *rxb)
{
   LONG retval = (LONG) rxb;

   /* Use an internal use counter */
   rxb->rxb_Lib.lib_OpenCnt++;
   rxb->rxb_Lib.lib_Flags &= ~LIBF_DELEXP;

   return (retval);
}

LibCall LONG LibClose (REGA6 struct RexxXRefBase *rxb)
{
   LONG retval = NULL;

   if (rxb->rxb_Lib.lib_OpenCnt)
      rxb->rxb_Lib.lib_OpenCnt--;

   if(rxb->rxb_Lib.lib_Flags & LIBF_DELEXP)
       retval = LibExpunge (rxb);

   return (retval);
}

LibCall LONG LibExpunge(REGA6 struct RexxXRefBase *rxb)
{
   BPTR seg = rxb->rxb_SegList;

   Remove((struct Node *) rxb);

   CloseLibrary(rxb->rxb_UtilityBase);
   CloseLibrary(rxb->rxb_DOSBase);
   CloseLibrary(rxb->rxb_XRefBase);
   CloseLibrary(rxb->rxb_RexxSysBase);
   CloseLibrary(rxb->rxb_IntuitionBase);

   FreeMem((APTR)((ULONG)(rxb) - (ULONG)(rxb->rxb_Lib.lib_NegSize)), rxb->rxb_Lib.lib_NegSize + rxb->rxb_Lib.lib_PosSize);

   return((LONG) seg);
}

