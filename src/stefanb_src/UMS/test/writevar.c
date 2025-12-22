#include <stdlib.h>
#include <stdio.h>

#include <clib/exec_protos.h>
#include <pragmas/exec_pragmas.h>
#include <libraries/ums.h>
#include <clib/ums_protos.h>
#include <pragmas/ums_pragmas.h>

static struct TagItem TagArray[] = {
 UMSTAG_CfgName,  (ULONG) "temp.123456",
 UMSTAG_CfgData,  (ULONG) "g1\ng2\ng3",
 UMSTAG_CfgLocal, TRUE,
 TAG_DONE
};

extern struct Library *SysBase;

int main(int argc, char *argv[])
{
 struct Library *UMSBase;

 if (UMSBase = OpenLibrary("ums.library", 11)) {
  UMSAccount account;

  if (account = UMSRLogin("test", "uucp.lilly", "")) {
   ULONG rc;

#if 1
   rc = UMSWriteConfigTags(account, UMSTAG_CfgName,  "temp.123456",
                                    UMSTAG_CfgData,  "g1\ng2\ng3",
                                    UMSTAG_CfgLocal, TRUE,
                                    TAG_DONE);
#else
   rc = UMSWriteConfig(account, TagArray);
#endif

   printf("Result: 0x%08lx\n", rc);

   printf("UMS Error: %d - %s\n", UMSErrNum(account), UMSErrTxt(account));

   UMSLogout(account);
  }

  CloseLibrary(UMSBase);
 }
 return(0);
}
