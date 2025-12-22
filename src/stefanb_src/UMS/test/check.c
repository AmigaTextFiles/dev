#include <stdlib.h>
#include <stdio.h>

#include <clib/exec_protos.h>
#include <pragmas/exec_pragmas.h>
#include <libraries/ums.h>
#include <clib/ums_protos.h>
#include <pragmas/ums_pragmas.h>

struct TagItem Message[] = {
 UMSTAG_WToName,   (ULONG) NULL,
 UMSTAG_WToAddr,   (ULONG) NULL,
 UMSTAG_WFromName, (ULONG) "Stefan Becker",
 UMSTAG_WFromAddr, (ULONG) "stefanb@dfv.rwth-aachen.de",
 UMSTAG_WSubject,  (ULONG) "Dupe Test",
 UMSTAG_WAutoBounce, FALSE,
 UMSTAG_WCheckHeader, TRUE,

 TAG_DONE
};

extern struct Library *SysBase;

int main(int argc, char *argv[])
{
 struct Library *UMSBase;

 if (UMSBase = OpenLibrary("ums.library", 11)) {
  UMSAccount account;

  if (account = UMSRLogin("meeting", "NNTPD", "")) {

   Message[0].ti_Data = (ULONG) "a";
   Message[1].ti_Data = (ULONG) NULL;
   printf("Result: %d\n", UMSWriteMsg(account, Message));

   Message[0].ti_Data = (ULONG) "stefanb";
   Message[1].ti_Data = (ULONG) NULL;
   printf("Result: %d\n", UMSWriteMsg(account, Message));

   UMSLogout(account);
  }

  CloseLibrary(UMSBase);
 }
 return(0);
}
