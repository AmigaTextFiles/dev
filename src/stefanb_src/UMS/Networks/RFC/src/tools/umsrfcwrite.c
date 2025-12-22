/*
 * umsrfcwrite.c V1.0.00
 *
 * Read RFC message from stdin and write UMS message
 *
 * (c) 1997 Stefan Becker
 */

#include "tools.h"

/* Buffer length */
#define BUFLEN 1024

/* Constant strings */
static const char Version[]  = "$VER: umsrfcwrote "
                               INTTOSTR(UMSRFC_LIBRARY_VERSION) "."
                               INTTOSTR(UMSRFC_REVISION)
                               " (" __COMMODORE_DATE__ ")";
static const char Template[] = "NAME/A,PASSWD/A,SERVER,FILE/K,DOTS/S,RECIPIENTS/M";

/* Local data */
static struct {
               char  *name;
               char  *passwd;
               char  *server;
               char  *file;
               long   dots;
               char **recipients;
              } args          = {NULL, NULL, NULL, NULL, 0, NULL};
static struct UMSRFCBases urb;
static char CopyBuffer[BUFLEN];

/* Global data */
struct Library *UMSBase, *UMSRFCBase;

/* Dummy routine for CTRL-C */
static int brk(void)
{
 return(0);
}

/* Read message from file/stdin */
static char *ReadMessage(char *filename, ULONG *length)
{
 char  *tmpfile = NULL;
 char  *buffer  = NULL;
 BPTR   file;

 /* File or stdin? */
 if (filename) {

  /* Open file */
  if (file = Open(filename, MODE_OLDFILE))

   /* Go to end of file */
   Seek(file, 0, OFFSET_END);

  else
   fprintf(stderr, "Couldn't open file '%s'!\n");

 } else {

  /* Read from stdin and copy to a temporary file */
  tmpfile = tmpnam(NULL);

  /* Open temporary file */
  if (file = Open(tmpfile, MODE_READWRITE)) {
   LONG n;

   /* Read from stdin */
   while ((n = Read(Input(), CopyBuffer, BUFLEN)) > 0)

    /* Write to temporary file */
    if (Write(file, CopyBuffer, n) != n) {

     /* ERROR! Leave loop*/
     n = -1;
     break;
    }

   /* All data copied? */
   if (n < 0) {
    fprintf(stderr, "Couldn't copy data to temporary file!\n");
    Close(file);
    DeleteFile(tmpfile);
    file = NULL;
   }

  } else
   fprintf(stderr, "Couldn't open temporary file!\n");
 }

 /* File OK? */
 if (file) {
  ULONG len = Seek(file, 0, OFFSET_BEGINNING);

  /* Allocate buffer for file */
  if ((len > 2) && (buffer = AllocMem(len + 1, MEMF_PUBLIC))) {

   /* Read file into buffer */
   if (Read(file, buffer, len) == len) {

    /* File read into buffer. Add string terminator */
    buffer[len] = '\0';

    /* Store buffer length */
    *length = len + 1;

    /* Couldn't read file, free buffer */
   } else {
    fprintf(stderr, "Couldn't read file into memory!\n");
    FreeMem(buffer, len + 1);
    buffer = NULL;
   }

  } else
   fprintf(stderr, "Couldn't allocate memory for message!\n");

  /* Close file */
  Close(file);

  /* Temporary file used? Yes, delete it */
  if (tmpfile) DeleteFile(tmpfile);
 }

 return(buffer);
}

/* Main entry point */
int main(int argc, char **argv)
{
 int              rc  = RETURN_FAIL;
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
     char  *buf;
     ULONG  len;

     /* Read file/stdout into buffer */
     if (buf = ReadMessage(args.file, &len)) {

      /* Process message */
      if (UMSRFCReadMessage(urd, buf, args.recipients != NULL, args.dots)) {

       /* Mail or News message? */
       if (args.recipients != NULL) {
        UMSAccount  account   = urd->urd_Account;
        char       *recipient;

        /* Set OK level */
        rc = RETURN_OK;

        /* News article */
        printf("Sending mail to:\n");

        while (recipient = *args.recipients++) {

         printf("%s...", recipient);
         fflush(stdout);

         /* Yes, write message, check for "dupes" */
         if (UMSRFCPutMailMessage(urd, recipient) != 0)

          /* Message written */
          printf(" OK\n");

         else {

          /* Error */
          printf(" ERROR: %d - %s\n", UMSErrNum(account), UMSErrTxt(account));

          /* Set error code */
          rc = RETURN_FAIL;

          /* Leave loop */
          break;
         }
        }

        /* Post news article */
       } else {
        char *nextgroup = (char *)
                           urd->urd_NewsTags[UMSRFC_TAGS_GROUP].ti_Data;

        /* Group field valid? */
        if (nextgroup) {
         UMSAccount account = urd->urd_Account;
         UMSMsgNum  oldnum  = 0;     /* linked (crossposted) messages */

            /* Set warning level */
         rc = RETURN_WARN;

         /* News article */
         printf("Posting article to group(s):\n");

         /* For each newsgroup */
         do {
          char      *group  = nextgroup;
          UMSMsgNum  newnum;

          /* Scan newsgroup line for ',' */
          if (nextgroup = strchr(nextgroup, ',')) {
           char c;

           /* another group -> remove ',' and set string terminator */
           *nextgroup = '\0';

           /* Skip white space */
           while ((c = *++nextgroup) && ((c == ' ') || (c == '\t')));
          }

          /* Group name valid? */
          if (*group) {

           printf("%s...", group);
           fflush(stdout);

           /* Yes, write message, save message number */
           if (newnum = UMSRFCPutNewsMessage(urd, group, oldnum)) {

            /* All OK */
            printf(" OK\n");

            /* Posted at least once! */
            rc = RETURN_OK;

            /* Save message number */
            oldnum = newnum;

           /* Real error? */
           } else if (UMSErrNum(account) == UMSERR_NoWriteAccess)

            /* Crossposting not allowed */
            printf(" crossposting not allowed!\n");

           else {
            printf(" ERROR: %d - %s\n", UMSErrNum(account),
                                        UMSErrTxt(account));

            /* Set error code */
            rc = RETURN_FAIL;

            /* Leave loop */
            break;
           }
          }

          /* Repeat as long as news groups specified */
         } while (nextgroup);

        } else
         fprintf(stderr, "No newsgroup specified for article!\n");
       }

      } else
       fprintf(stderr, "Couldn't parse message!\n");

      FreeMem(buf, len);
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
