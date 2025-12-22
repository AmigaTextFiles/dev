#include <stdlib.h>
#include <stdio.h>

#include <clib/exec_protos.h>
#include <pragmas/exec_pragmas.h>
#include <libraries/ums.h>
#include <clib/ums_protos.h>
#include <pragmas/ums_pragmas.h>
#include <libraries/umsrfc.h>
#include <clib/umsrfc_protos.h>
#include <pragmas/umsrfc_pragmas.h>

struct UMSRFCBases urb;

extern struct Library *SysBase, *DOSBase, *UtilityBase;

int main(int argc, char *argv[])
{
 struct Library *UMSBase;

 if (UMSBase = OpenLibrary("ums.library", 11)) {
  struct Library *UMSRFCBase;

  if (UMSRFCBase = OpenLibrary("umsrfc.library", 0)) {
   struct UMSRFCData *urd;

   urb.urb_DOSBase     = DOSBase;
   urb.urb_UtilityBase = UtilityBase;
   urb.urb_UMSBase     = UMSBase;

   if (urd = UMSRFCAllocData(&urb, "uucp.lilly", "", "test")) {
    UMSAccount account = urd->urd_Account;
    UMSMsgNum msgnum;
    ULONG err;

    urd->urd_MailTags[UMSRFC_TAGS_FROMNAME].ti_Data = (ULONG) "Stefan Becker",
    urd->urd_MailTags[UMSRFC_TAGS_FROMADDR].ti_Data = (ULONG) "stefanb@dfv.rwth-aachen.de",
    urd->urd_MailTags[UMSRFC_TAGS_SUBJECT].ti_Data = (ULONG) "Dupe Test",
    urd->urd_MailTags[UMSRFC_TAGS_MSGID].ti_Data = (ULONG) "12345678@dfv.rwth-aachen.de",

    msgnum = UMSRFCPutMailMessage(urd, "stefanb");
    err    = UMSErrNum(account);
    printf("stefanb: %ld - err: %ld\n", msgnum, err);

    msgnum = UMSRFCPutMailMessage(urd, "stefanb");
    err    = UMSErrNum(account);
    printf("stefanb: %ld - err: %ld\n", msgnum, err);

    msgnum = UMSRFCPutMailMessage(urd, "Stefan Becker");
    err    = UMSErrNum(account);
    printf("Stefan Becker: %ld - err: %ld\n", msgnum, err);

    msgnum = UMSRFCPutMailMessage(urd, "Stefan Becker");
    err    = UMSErrNum(account);
    printf("Stefan Becker: %ld - err: %ld\n", msgnum, err);

    msgnum = UMSRFCPutMailMessage(urd, "stefanb <stefanb@yello.ping.de>");
    err    = UMSErrNum(account);
    printf("stefanb & addr: %ld - err: %ld\n", msgnum, err);

    msgnum = UMSRFCPutMailMessage(urd, "stefanb <stefanb@yello.ping.de>");
    err    = UMSErrNum(account);
    printf("stefanb & addr: %ld - err: %ld\n", msgnum, err);

    msgnum = UMSRFCPutMailMessage(urd, "stefanb <stefanb@yello.ping.de>");
    err    = UMSErrNum(account);
    printf("stefanb & addr: %ld - err: %ld\n", msgnum, err);

    msgnum = UMSRFCPutMailMessage(urd, "\"Stefan Becker\" <stefanb@yello.ping.de>");
    err    = UMSErrNum(account);
    printf("Stefan Becker & addr: %ld - err: %ld\n", msgnum, err);

    msgnum = UMSRFCPutMailMessage(urd, "\"Stefan Becker\" <stefanb@yello.ping.de>");
    err    = UMSErrNum(account);
    printf("Stefan Becker & addr: %ld - err: %ld\n", msgnum, err);

    msgnum = UMSRFCPutMailMessage(urd, "stefanb <stefanb@test.adsp.sub.org>");
    err    = UMSErrNum(account);
    printf("stefanb & addr2: %ld - err: %ld\n", msgnum, err);

    msgnum = UMSRFCPutMailMessage(urd, "stefanb <stefanb@test.adsp.sub.org>");
    err    = UMSErrNum(account);
    printf("stefanb & addr2: %ld - err: %ld\n", msgnum, err);

    msgnum = UMSRFCPutMailMessage(urd, "\"Stefan Becker\" <abcd@test.adsp.sub.org>");
    err    = UMSErrNum(account);
    printf("Stefan Becker & addr2: %ld - err: %ld\n", msgnum, err);

    msgnum = UMSRFCPutMailMessage(urd, "\"Stefan Becker\" <abcd@test.adsp.sub.org>");
    err    = UMSErrNum(account);
    printf("Stefan Becker & addr2: %ld - err: %ld\n", msgnum, err);

    UMSRFCFreeData(urd);
   }

   CloseLibrary(UMSRFCBase);
  }

  CloseLibrary(UMSBase);
 }
 return(0);
}
