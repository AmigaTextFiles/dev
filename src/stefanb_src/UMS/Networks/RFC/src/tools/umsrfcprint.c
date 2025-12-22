/*
 * umsrfcprint.c V1.0.01
 *
 * Print UMS message as RFC message to stdout
 *
 * (c) 1996-97 Stefan Becker
 */

#include "tools.h"

/* Constant strings */
static const char Version[]  = "$VER: umsrfcprint "
                               INTTOSTR(UMSRFC_LIBRARY_VERSION) "."
                               INTTOSTR(UMSRFC_REVISION)
                               " (" __COMMODORE_DATE__ ")";
static const char Template[] = "NAME/A,PASSWD/A,SERVER,MSGNUM/K/N/A,DOTS/S";

/* Local data */
static struct {
               char *name;
               char *passwd;
               char *server;
               long *msgnum;
               long  dots;
              } args          = {NULL, NULL, NULL, NULL, 0};
static struct OutputData {
               struct Library *od_DOSBase;
               BPTR            od_Handle;
              } od;
static struct UMSRFCBases urb;

/* Global data */
struct Library *UMSBase, *UMSRFCBase;

/* Output function for umsrfc.library/UMSRFCWriteMessage */
static void OutputFunction(__A0 struct OutputData *od, __D0 char c)
{
 struct Library *DOSBase = od->od_DOSBase;

 /* Write character */
 FPutC(od->od_Handle, c);
}

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

     /* Get message */
     if (UMSRFCGetMessage(urd, *args.msgnum)) {

      /* All OK, set return code */
      rc = RETURN_OK;

      /* Initialize output data */
      od.od_DOSBase = DOSBase;
      od.od_Handle  = Output();

      /* Convert message */
      UMSRFCWriteMessage(urd, OutputFunction, &od, args.dots);

      UMSRFCFreeMessage(urd);
     } else
      fprintf(stderr, "Couldn't read message: %d - %s\n", UMSErrNum(account),
                                                          UMSErrTxt(account));

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
