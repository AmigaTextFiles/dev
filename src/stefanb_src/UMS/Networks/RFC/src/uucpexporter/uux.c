/*
 * uux.c  V1.0.03
 *
 * submit UUCP files (implements UUX command)
 *
 * (c) 1992-98 Stefan Becker
 *
 */

#include "ums2uucp.h"

/* Constant strings */
static const char CommandFormat[]    = "S %s %s root - %s 0666\n";
static const char TmpCmdFileFormat[] = "_.%s%c%s";
static const char DataFileFormat[]   = "D.%sD%s";
static const char DataFileError[]    = "couldn't create data file '%s'!";
static const char CmdFileError[]     = "couldn't create command file '%s'!";

/* Local data */
static char LocalExecFile[UUX_FILENAMELEN];      /* Exec file name (local) */
static char RemoteExecFile[UUX_FILENAMELEN];     /* Exec file name (remote) */
static char RemoteDataFile[UUX_FILENAMELEN];     /* Data file name (remote) */
static char TaylorUUCPFile[UUX_FILENAMELEN + 3]; /* Data file name (local) */
BOOL TaylorUUCPMode = FALSE;

/* Set Taylor UUCP mode */
void EnableTaylorUUCPMode(void)
{
 TaylorUUCPMode = TRUE;
}

/* Create Taylor UUCP style files for new data file */
BOOL CreateTaylorUUCPFiles(struct ExportData *ed, char *sender, char *command)
{
 char *tmpcmdfile = ed->ed_TmpCmdFile;
 char *datafile   = ed->ed_DataFile;
 char *seqname;
 FILE *fh;

 /* Get sequence number (4 digits) */
 seqname = SeqToName(GetSequence(1));

 /* Build file names */
 sprintf(ed->ed_LocalCmdFile, "C./C.%s%c%s",    CutRemoteName, ed->ed_Grade,
                                                seqname);
 sprintf(tmpcmdfile,          TmpCmdFileFormat, CutRemoteName, ed->ed_Grade,
                                                seqname);
 sprintf(datafile,            DataFileFormat,   CutRemoteName, seqname);
 sprintf(RemoteDataFile,      DataFileFormat,   CutNodeName,   seqname);

 /* Lock file */
 LockFile(tmpcmdfile);

 /* Open command file */
 if (fh = fopen(tmpcmdfile, "w")) {
  char *fname;

  /* Write command file data */
  fprintf(fh, "E %s %s root - %s 0666 \"\" 0 %s\n",
              datafile, RemoteDataFile, datafile, command);
  fclose(fh);
  UnLockFile(tmpcmdfile);
  LockFile(datafile);

  /* Compression? Yes, create temporary file */
  fname = ed->ed_CompCmd ? tmpnam(ed->ed_TmpName) : datafile;

  /* Open data file */
  if (ed->ed_Handle = Open(fname, MODE_NEWFILE))

   /* All OK. */
   return(TRUE);

  else {
   ulog(-1, DataFileError, fname);
   UnLockFile(datafile);
  }
 } else {
  ulog(-1, CmdFileError, tmpcmdfile);
  UnLockFile(tmpcmdfile);
 }

 return(FALSE);
}

/* Create normal UUCP files for new data file */
BOOL CreateNormalUUCPFiles(struct ExportData *ed, char *sender, char *command)
{
 char *tmpcmdfile = ed->ed_TmpCmdFile;
 char *datafile   = ed->ed_DataFile;
 char *seqname;
 FILE *fh;

 /* Get sequence number (4 digits) */
 seqname = SeqToName(GetSequence(1));

 /* Build file names */
 sprintf(ed->ed_LocalCmdFile, "C.%s%c%s",        CutRemoteName, ed->ed_Grade,
                                                 seqname);
 sprintf(tmpcmdfile,          TmpCmdFileFormat,  CutRemoteName, ed->ed_Grade,
                                                 seqname);
 sprintf(LocalExecFile,       "D.%sX%s",         CutRemoteName, seqname);
 sprintf(datafile,            DataFileFormat,    CutRemoteName, seqname);
 sprintf(RemoteExecFile,      "X.%sX%s",         CutNodeName,   seqname);
 sprintf(RemoteDataFile,      DataFileFormat,    CutNodeName,   seqname);

 /* Lock file */
 LockFile(LocalExecFile);

 /* Open local exec file */
 if (fh = fopen(LocalExecFile, "w")) {

  /* Write exec file data */
  fprintf(fh, "U %s %s\nR postmaster\nZ\nF %s\nI %s\nC %s\n",
              sender, NodeName, RemoteDataFile, RemoteDataFile, command);
  fclose(fh);
  UnLockFile(LocalExecFile);
  LockFile(tmpcmdfile);

  /* Open command file */
  if (fh = fopen(tmpcmdfile, "w")) {
   char *fname;

   /* Write command file data */
   fprintf(fh, CommandFormat, datafile,      RemoteDataFile, datafile);
   fprintf(fh, CommandFormat, LocalExecFile, RemoteExecFile, LocalExecFile);
   fclose(fh);
   UnLockFile(tmpcmdfile);
   LockFile(datafile);

   /* Compression? Yes, create temporary file */
   fname = ed->ed_CompCmd ? tmpnam(ed->ed_TmpName) : datafile;

   /* Open data file */
   if (ed->ed_Handle = Open(fname, MODE_NEWFILE))

    /* All OK. */
    return(TRUE);

   else {
    ulog(-1, DataFileError, fname);
    UnLockFile(datafile);
   }
  } else {
   ulog(-1, CmdFileError, tmpcmdfile);
   UnLockFile(tmpcmdfile);
  }
 } else {
  ulog(-1, "couldn't create exec file '%s'!", LocalExecFile);
  UnLockFile(LocalExecFile);
 }

 /* Error */
 return(FALSE);
}

/* Create UUCP files for new data file */
BOOL CreateUUCPFiles(struct ExportData *ed, char *sender, char *command)
{
 /* Taylor UUCP mode? */
 return(TaylorUUCPMode ? CreateTaylorUUCPFiles(ed, sender, command) :
                         CreateNormalUUCPFiles(ed, sender, command));
}

/* Finish UUCP files */
BOOL FinishUUCPFiles(struct ExportData *ed)
{
 BOOL rc = TRUE;

 /* Close data file */
 Close(ed->ed_Handle);
 ed->ed_Handle = 0;

 /* Compress data file? */
 if (ed->ed_CompCmd) {
  BPTR newfile;

  /* Open new file for writing */
  rc = FALSE;
  if (newfile = Open(ed->ed_DataFile, MODE_NEWFILE)) {
   BPTR oldfile;

   if (ed->ed_DFileHdr) {
    VFPrintf(newfile, "#! %s\n", (LONG *) &ed->ed_DFileHdr);
    Flush(newfile);
   }

   /* Open old file for reading */
   if (oldfile = Open(ed->ed_TmpName, MODE_OLDFILE)) {

    /* Start compression program */
    if (SystemTags(ed->ed_CompCmd, SYS_Input,     oldfile,
                                   SYS_Output,    newfile,
                                   SYS_UserShell, TRUE,
                                   TAG_DONE) == 0)
     /* All OK! */
     rc = TRUE;

    else
     /* Error in compression */
     ulog(-1, "couldn't compress data file '%s'!", ed->ed_TmpName);

    Close(oldfile);
    if (rc) DeleteFile(ed->ed_TmpName);
   } else
    ulog(-1, "couldn't open temporary file '%s'!", ed->ed_TmpName);

   Close(newfile);
  } else
   ulog(-1, "couldn't open final data file '%s'!", ed->ed_DataFile);
 }

 /* Rename local files if job creation was successful */
 if (rc)

  /* Taylor UUCP mode? */
  if (TaylorUUCPMode) {
   /* Yes, create final data file name */
   sprintf(TaylorUUCPFile, "D./%s", ed->ed_DataFile);

   /* Rename data and command file */
   rc = Rename(ed->ed_DataFile,   TaylorUUCPFile)      &&
        Rename(ed->ed_TmpCmdFile, ed->ed_LocalCmdFile);

  } else
   /* No, just rename command file */
   rc = Rename(ed->ed_TmpCmdFile, ed->ed_LocalCmdFile);

 /* Unlock data file */
 UnLockFile(ed->ed_DataFile);
 return(rc);
}
