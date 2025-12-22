/*
 * setnntpdate.c V1.0.01
 *
 * Set date of last NNTP request
 *
 * (c) 1995-97 Stefan Becker
 */

#include "tools.h"

/* Constant strings */
static const char Version[] = "$VER: setnntpdate "
                              INTTOSTR(UMSRFC_LIBRARY_VERSION) "."
                              INTTOSTR(UMSRFC_REVISION)
                              " (" __COMMODORE_DATE__ ")";
static const char Template[] = "NAME/A,PASSWD/A,SERVER,DATE/K";
static const char VarName[]  = "nntpget.lastrequest";

/* Local data */
static struct {
               char *name;
               char *passwd;
               char *server;
               char *date;
              } args          = {NULL, NULL, NULL, NULL};
static struct UMSRFCBases urb;
static char DateBuffer[100];

/* Global data */
struct Library *UMSBase, *UMSRFCBase;

/* Dummy routine for CTRL-C */
static int brk(void)
{
 return(0);
}

/* Main entry point */
int main(int argc, char **argv)
{
 LONG rc              = RETURN_FAIL;
 struct ReadArgs *rda;

 /* Prevent CTRL-C's */
 onbreak(brk);

 /* Parse command line parameters */
 if (rda = ReadArgs(Template, (LONG *) &args, NULL)) {

  /* Open UMS library */
  if (UMSBase = OpenLibrary("ums.library", 11)) {

   /* Open UMSRFC library */
   if (UMSRFCBase = OpenLibrary(UMSRFC_LIBRARY_NAME, UMSRFC_LIBRARY_VERSION)) {
    struct UMSRFCData *urd;

    /* Initialize bases for UMS RFC login */
    urb.urb_UMSBase     = UMSBase;
    urb.urb_DOSBase     = DOSBase;
    urb.urb_UtilityBase = UtilityBase;

    /* Allocate UMS RFC data */
    if (urd = UMSRFCAllocData(&urb, args.name, args.passwd, args.server)) {
     UMSAccount account = urd->urd_Account;

     /* Get old contents */
     {
      char *cp;

      /* Read UMS config var */
      if (cp = UMSReadConfigTags(account, UMSTAG_CfgName, VarName, TAG_DONE)) {

       /* Convert to RFC date */
       UMSRFCPrintTime(urd, strtol(cp, NULL, 10), DateBuffer);

       /* Print time */
       printf("Old date: %s\n", DateBuffer);

       UMSFreeConfig(account, cp);
      } else
       printf("No old date set!\n");
     }

     /* Set new date? */
     if (args.date) {
      ULONG seconds;

      /* Convert new date to seconds */
      seconds = UMSRFCGetTime(urd, args.date);

      /* New date valid? */
      if (seconds) {

       /* Set UMS config var */
       sprintf(DateBuffer, "%ud", seconds);
       if (UMSWriteConfigTags(account, UMSTAG_CfgName, VarName,
                                       UMSTAG_CfgData, DateBuffer,
                                       TAG_DONE)) {

        /* Convert seconds to RFC date */
        UMSRFCPrintTime(urd, seconds, DateBuffer);

        /* Print time */
        printf("New date: %s\n", DateBuffer);

       } else
        fprintf(stderr, "Couldn't set new date!\n");

      } else
       fprintf(stderr, "Invalid new date!\n");

     }

     UMSRFCFreeData(urd);
    } else
     fprintf(stderr, "Couldn't login as '%s' on server '%s'!\n",
                      args.name, args.server ? args.server : "<default>");

    CloseLibrary(UMSRFCBase);
   } else
    fprintf(stderr, "Couldn't open " UMSRFC_LIBRARY_NAME "!\n");

   CloseLibrary(UMSBase);
  } else
   fprintf(stderr, "Couldn't open ums.library!\n");

  FreeArgs(rda);
 } else
  fprintf(stderr, "Error in command line!\n");

 return(rc);
}
