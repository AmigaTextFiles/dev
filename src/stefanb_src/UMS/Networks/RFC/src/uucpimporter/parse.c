/*
 * parse.c  V1.0.01
 *
 * parse one command file
 *
 * (c) 1992-98 Stefan Becker
 *
 */

#include "uuxqt.h"

static const char BadJobsDir[] = "bad-jobs/";
static char MungeBuf[128];

/* Parse one command file */
int ParseCommandFile(BPTR datadirlock, char *comfile)
{
 ULONG filesize = 0;
 int   rc       = RETURN_WARN;

 ulog(2, "processing command file '%s'", comfile);

 /* Get file size */
 {
  struct stat statbuf;

  /* Get file statistic */
  if (stat(comfile, &statbuf) != -1)
   filesize = statbuf.st_size;
  else
   UMSRFCLog(DefaultLog, "couldn't stat command file '%s'!\n", comfile);
 }

 /* File size set? */
 if (filesize) {
  char *buffer;

  /* Can the buffer be allocated? */
  if (buffer = AllocMem(filesize + 1, MEMF_PUBLIC)) {
   BPTR infile;

   /* Open temporary file */
   if (infile = Open(comfile, MODE_OLDFILE)) {

    /* Read command file into buffer */
    if (Read(infile, buffer, filesize) == filesize) {

     /* Command file read in */
     char *sender   = NULL;
     char *datafile = NULL;
     char *argument = NULL;

     /* Close command file */
     Close(infile);
     infile = NULL;

     /* Set string terminator */
     buffer[filesize] = '\0';

     /* Parse command file buffer */
     {
      char *lp = buffer;

      /* Parse next line */
      while (lp) {
       char *nextline;
       char *firstarg = strchr(lp + 1, ' ');

       /* Find next line and set string terminator */
       if (nextline = strchr(lp, '\n')) *nextline++ = '\0';

       /* Command type? */
       switch (*lp) {
        case 'C': /* Command: C <cmd> <arg> */
                  /* Skip command */
                  if (firstarg && (argument = strchr(firstarg + 1, ' ')))
                   argument++;
                  break;

        case 'F': /* Data file name: F <file> */
                  datafile = firstarg + 1;
                  break;

        case 'U': /* Sender information: U <user> <system> */
                  /* Skip user name */
                  if (firstarg && (sender = strchr(firstarg + 1, ' ')))
                   sender++;
                  break;

        default: /* Ignore all other commands */
                 break;
       }

       /* Next line */
       lp = nextline;
      }
     }

     /* Got all information we need? */
     if (sender && datafile) {
      BPTR olddir = CurrentDir(datadirlock); /* Change to data file dir. */

      /* Login as sender */
      if (Login(sender)) {
       char  *buffer;
       ULONG  size;

       /* Check for munge-cased file name */
       {
        BPTR lock;

        /* File found? */
        if (lock = Lock(datafile, ACCESS_READ))
         /* Yes, name not munged */
         UnLock(lock);
        else {
         /* No, name must be munged */
         mungecase_filename(datafile, MungeBuf);
         datafile = MungeBuf;
        }
       }

       ulog(3, "command file data: file '%s' sender '%s' arg '%s'",
               datafile, sender, argument ? argument : "");

       /* Get data file */
       if (buffer = GetDataFile(datafile, &size)) {

        /* Check data file, rnews file? */
        if (strnicmp(buffer, "#! rnews", 8) == 0)
         rc = ReceiveNewsFile(datafile, buffer, size);

        /* BSMTP File? */
        else if (strnicmp(buffer, "HELO ", 5) == 0)
         rc = ReceiveBSMTPFile(datafile, buffer);

        /* Mail File? */
        else if ((strnicmp(buffer, "From ", 5) == 0) && argument)
         rc = ReceiveMailFile(datafile, buffer, argument);

        /* Unknown data file */
        else
         UMSRFCLog(URData, "unknown data type in file '%s'!\n", datafile);

        /* Free buffer */
        FreeVec(buffer);
       }
      }

      /* Log errors */
      if (rc != RETURN_OK)
       UMSRFCLog(DefaultLog,
                 "Error in command file '%s' Sender: %s Data file: %s\n",
                 comfile, sender, datafile);

      /* File processed? */
      switch (rc) {
       case RETURN_OK:   /* Yes, delete command and data file */
                         ulog(2,
                              "command file '%s' processed, deleting files.",
                              comfile);
                         DeleteFile(datafile);

                         /* Back to old directory */
                         CurrentDir(olddir);
                         DeleteFile(comfile);
                         break;

       case RETURN_WARN: /* No severe error, let the user handle this jobs */
                         /* Try to move the files to the bad jobs directory */
                         strcpy(TempBuffer1, BadJobsDir);
                         strcat(TempBuffer1, comfile);

                         /* Back to old directory */
                         CurrentDir(olddir);

                         /* Try to move the command file */
                         if (Rename(comfile, TempBuffer1)) {

                          /* Move successful, move data file too */
                          CurrentDir(datadirlock);
                          strcpy(TempBuffer1, BadJobsDir);
                          strcat(TempBuffer1, datafile);
                          Rename(datafile, TempBuffer1);
                          CurrentDir(olddir);
                         } else {
                          /* No directory, rename cmd file 'X.*' to 'E.*' */
                          strcpy(TempBuffer1, comfile);
                          *TempBuffer1 = 'E';
                          Rename(comfile, TempBuffer1);
                         }
                         break;

       default:          /* Severe error, do nothing */
                         /* Back to old directory */
                         CurrentDir(olddir);
                         break;
      }

     } else
      /* Some information is missing */
      UMSRFCLog(DefaultLog, "No F or U line in '%s'!\n", comfile);

    } else
     UMSRFCLog(DefaultLog, "couldn't read command file '%s'!\n", comfile);

    if (infile) Close(infile);
   } else
    UMSRFCLog(DefaultLog,"couldn't open command file '%s'!\n", comfile);

   FreeMem(buffer, filesize + 1);
  } else
   UMSRFCLog(DefaultLog, "couldn't allocate buffer for command file '%s'!\n",
             comfile);
 }

 return(rc);
}
