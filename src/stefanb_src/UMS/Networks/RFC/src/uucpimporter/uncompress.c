/*
 * uncompress.c  V1.0.00
 *
 * uncompress and load a data file
 *
 * (c) 1992-97 Stefan Becker
 *
 */

#include "uuxqt.h"

/* Constant strings */
static const char ReadErrMsg[]="read error on file '%s'!\n";

/* Uncompress data file into temporary file */
static char *UncompressFile(char *name, char *command, ULONG offset)
{
 char *rc    = NULL;
 BPTR infile;

 /* Open AmigaDOS file */
 if (infile = Open(name, MODE_OLDFILE)) {

  /* Seek into file */
  Seek(infile, offset, OFFSET_BEGINNING);

  /* No error? */
  if (IoErr() == 0) {
   char *outname = tmpnam(NULL);

   /* Create command string */
   sprintf(TempBuffer1, "%s -d >%s", command, outname);

   /* Run command */
   if (SystemTags(TempBuffer1, SYS_Input,     infile,
                               SYS_UserShell, TRUE,
                               TAG_DONE) == 0)
    /* News file decompressed */
    rc = outname;
   else
    UMSRFCLog(DefaultLog, "error in '%s' command!\n", TempBuffer1);

  } else
   UMSRFCLog(DefaultLog, "seek error in compressed file '%s'!\n", name);

  Close(infile);
 } else
  UMSRFCLog(DefaultLog, "couldn't open compressed file '%s'!\n", name);

 return(rc);
}

char *GetDataFile(char *datafile, ULONG *size)
{
 FILE *fh;

 /* Open date file */
 if (fh = fopen(datafile, "r")) {
  int c;

  /* Read first character */
  if ((c = fgetc(fh)) != EOF) {
   char *tmpfilename = NULL;
   BOOL dodelete     = TRUE;

   /* Detect file type */
   {
    int offset = 0;

    /* Command line? */
    if (c == '#') {

     /* Yes, skip complete command line */
     offset = 2;
     while (((c = fgetc(fh)) != '\n') && (c != EOF)) offset++;
     c = fgetc(fh);
    }

    /* Compressed file? */
    if (c == '\x1f') {

     /* Yes, check compression type */
     if ((c = fgetc(fh)) != EOF)
      switch (c) {
       case  0x8B: /* Zipped */
                   tmpfilename = UncompressFile(datafile, "gzip", offset);
                   break;
       case  0x9D: /* Compressed */
                   tmpfilename = UncompressFile(datafile, "compress", offset);
                   break;
       case  0x9F: /* Frozen */
                   tmpfilename = UncompressFile(datafile, "freeze", offset);
                   break;
       default:    UMSRFCLog(DefaultLog,
                             "Unknown compression type in file '%s'!\n",
                             datafile);
                   break;
      }
     else
      UMSRFCLog(URData, ReadErrMsg, datafile);

    /* Uncompressed file? */
    } else if (c != EOF) {
     tmpfilename = datafile;
     dodelete    = FALSE;

    /* File error */
    } else
     UMSRFCLog(URData, ReadErrMsg, datafile);
   }

   /* Temporary file name set? */
   if (tmpfilename) {
    ULONG filesize = 0;

    /* Get file size */
    {
     struct stat statbuf;

     /* Get file statistic */
     if (stat(tmpfilename, &statbuf) != -1)
      filesize = statbuf.st_size;
     else
      UMSRFCLog(URData, "couldn't stat data file '%s'!\n", tmpfilename);
    }

    /* File size set? */
    if (filesize) {
     char *buffer;

     /* Can the buffer be allocated? */
     if (buffer = AllocVec(filesize + 1, MEMF_PUBLIC)) {
      BPTR infile;

      /* Open temporary file */
      if (infile = Open(tmpfilename, MODE_OLDFILE)) {

       /* Read data file into buffer */
       if (Read(infile, buffer, filesize) == filesize) {
        /* Data file read in. Close and delete it */
        Close(infile);
        fclose(fh);
        if (dodelete) DeleteFile(tmpfilename);

        /* Set string terminator */
        buffer[filesize] = '\0';

        /* Return parameters */
        *size = filesize;
        return(buffer);
       }
       Close(infile);
      }
      FreeVec(buffer);
     } else
      UMSRFCLog(URData,
                "couldn't allocate buffer for data file '%s'!\n", tmpfilename);

    }
    if (dodelete) DeleteFile(tmpfilename);
   }
  } else
   UMSRFCLog(URData, ReadErrMsg, datafile);

  fclose(fh);
 } else
  UMSRFCLog(URData, "couldn't open data file '%s'!\n", datafile);

 return(NULL);
}
