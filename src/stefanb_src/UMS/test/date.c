#include <stdlib.h>
#include <stdio.h>

#include <clib/exec_protos.h>
#include <pragmas/exec_pragmas.h>
#include <clib/umsrfc_protos.h>
#include <pragmas/umsrfc_pragmas.h>

extern struct Library *SysBase, *DOSBase, *UtilityBase;

struct UMSRFCBases urb;

char DateBuffer[UMSRFC_TIMELEN];

int main(int argc, char *argv[])
{
 struct Library *UMSBase;

 if (UMSBase = OpenLibrary("ums.library", 11)) {
  struct Library *UMSRFCBase;

  if (UMSRFCBase = OpenLibrary("umsrfc.library", 0)) {
   struct UMSRFCData *urd;

   urb.urb_DOSBase     = DOSBase;
   urb.urb_UMSBase     = UMSBase;
   urb.urb_UtilityBase = UtilityBase;

   if (urd = UMSRFCAllocData(&urb, "uucp.default", "", NULL)) {

    printf("Time: %ld\n",
            UMSRFCGetTime(urd, "Thu, 03 Nov 1994 06:16:00 +0200"));

    printf("Time: %ld\n",
            UMSRFCGetTime(urd, "Thu, 03 Nov 94 06:16:00 +0200"));

    UMSRFCPrintCurrentTime(urd, DateBuffer);

    printf("Current Time: %s\n", DateBuffer);

    UMSRFCFreeData(urd);
   }
   CloseLibrary(UMSRFCBase);
  }
  CloseLibrary(UMSBase);
 }
 return(0);
}
