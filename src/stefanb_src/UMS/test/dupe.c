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
 UMSTAG_WMsgID,    (ULONG) "12345678@dfv.rwth-aachen.de",

 TAG_DONE
};

extern struct Library *SysBase;

int main(int argc, char *argv[])
{
 struct Library *UMSBase;

 if (UMSBase = OpenLibrary("ums.library", 11)) {
  UMSAccount account;

  if (account = UMSRLogin("test", "uucp.lilly", "")) {
   UMSMsgNum msgnum;
   ULONG err;

   Message[0].ti_Data = (ULONG) "stefanb";
   Message[1].ti_Data = (ULONG) NULL;
   msgnum = UMSWriteMsg(account, Message);
   err    = UMSErrNum(account);
   printf("stefanb: %ld - err: %ld\n", msgnum, err);

   Message[0].ti_Data = (ULONG) "stefanb";
   Message[1].ti_Data = (ULONG) NULL;
   msgnum = UMSWriteMsg(account, Message);
   err    = UMSErrNum(account);
   printf("stefanb: %ld - err: %ld\n", msgnum, err);

   Message[0].ti_Data = (ULONG) "Stefan Becker";
   Message[1].ti_Data = (ULONG) NULL;
   msgnum = UMSWriteMsg(account, Message);
   err    = UMSErrNum(account);
   printf("Stefan Becker: %ld - err: %ld\n", msgnum, err);

   Message[0].ti_Data = (ULONG) "Stefan Becker";
   Message[1].ti_Data = (ULONG) NULL;
   msgnum = UMSWriteMsg(account, Message);
   err    = UMSErrNum(account);
   printf("Stefan Becker: %ld - err: %ld\n", msgnum, err);

   Message[0].ti_Data = (ULONG) "stefanb";
   Message[1].ti_Data = (ULONG) "stefanb@yello.ping.de";
   msgnum = UMSWriteMsg(account, Message);
   err    = UMSErrNum(account);
   printf("stefanb & addr: %ld - err: %ld\n", msgnum, err);

   Message[0].ti_Data = (ULONG) "stefanb";
   Message[1].ti_Data = (ULONG) "stefanb@yello.ping.de";
   msgnum = UMSWriteMsg(account, Message);
   err    = UMSErrNum(account);
   printf("stefanb & addr: %ld - err: %ld\n", msgnum, err);

   Message[0].ti_Data = (ULONG) "stefanb";
   Message[1].ti_Data = (ULONG) "stefanb@yello.ping.de";
   msgnum = UMSWriteMsg(account, Message);
   err    = UMSErrNum(account);
   printf("stefanb & addr: %ld - err: %ld\n", msgnum, err);

   Message[0].ti_Data = (ULONG) "Stefan Becker";
   Message[1].ti_Data = (ULONG) "stefanb@yello.ping.de";
   msgnum = UMSWriteMsg(account, Message);
   err    = UMSErrNum(account);
   printf("Stefan Becker & addr: %ld - err: %ld\n", msgnum, err);

   Message[0].ti_Data = (ULONG) "Stefan Becker";
   Message[1].ti_Data = (ULONG) "stefanb@yello.ping.de";
   msgnum = UMSWriteMsg(account, Message);
   err    = UMSErrNum(account);
   printf("Stefan Becker & addr: %ld - err: %ld\n", msgnum, err);

   Message[0].ti_Data = (ULONG) "stefanb";
   Message[1].ti_Data = (ULONG) "stefanb@test.adsp.sub.org";
   msgnum = UMSWriteMsg(account, Message);
   err    = UMSErrNum(account);
   printf("stefanb & addr2: %ld - err: %ld\n", msgnum, err);

   Message[0].ti_Data = (ULONG) "stefanb";
   Message[1].ti_Data = (ULONG) "stefanb@test.adsp.sub.org";
   msgnum = UMSWriteMsg(account, Message);
   err    = UMSErrNum(account);
   printf("stefanb & addr2: %ld - err: %ld\n", msgnum, err);

   Message[0].ti_Data = (ULONG) "Stefan Becker";
   Message[1].ti_Data = (ULONG) "abcd@test.adsp.sub.org";
   msgnum = UMSWriteMsg(account, Message);
   err    = UMSErrNum(account);
   printf("Stefan Becker & addr2: %ld - err: %ld\n", msgnum, err);

   Message[0].ti_Data = (ULONG) "Stefan Becker";
   Message[1].ti_Data = (ULONG) "abcd@test.adsp.sub.org";
   msgnum = UMSWriteMsg(account, Message);
   err    = UMSErrNum(account);
   printf("Stefan Becker & addr2: %ld - err: %ld\n", msgnum, err);

   UMSLogout(account);
  }

  CloseLibrary(UMSBase);
 }
 return(0);
}
