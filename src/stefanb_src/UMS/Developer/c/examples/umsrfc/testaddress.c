#include <clib/exec_protos.h>
#include <clib/umsrfc_protos.h>
#include <pragmas/exec_pragmas.h>
#include <pragmas/umsrfc_pragmas.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

extern struct Library *SysBase, *DOSBase, *UtilityBase;
struct UMSRFCBases urb;
char Address[1024];
char Name[1024];

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

    while (--argc) {
     UMSRFCConvertRFCAddress(urd, *++argv, Address, Name);
     printf("Name: '%s', Address: '%s'\n", Name, Address);
    }
    UMSRFCFreeData(urd);
   }
   CloseLibrary(UMSRFCBase);
  }
  CloseLibrary(UMSBase);
 }
 return(0);
}
