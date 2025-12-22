/*
 * uux.c  V0.8.01
 *
 * submit UUCP files (implements UUX command)
 *
 * (c) 1992-94 Stefan Becker
 *
 */

#include "ums2uucp.h"

static const char CommandFormat[]="S %s %s root - %s 0666\n";
static char LocalExecFile[UUX_FILENAMELEN];  /* Exec file name (local) */
static char RemoteExecFile[UUX_FILENAMELEN]; /* Exec file name (remote) */
static char RemoteDataFile[UUX_FILENAMELEN]; /* Data file name (remote) */

/* Create UUCP files for new data file */
BOOL CreateUUCPFiles(struct ExportData *ed, char *sender, char *command)
{
 char *tmpcmdfile=ed->ed_TmpCmdFile;
 char *datafile=ed->ed_DataFile;
 char *seqname;
 FILE *fh;

 /* Get sequence number (4 digits) */
 seqname=SeqToName(GetSequence(1));

 /* Build file names */
 sprintf(ed->ed_LocalCmdFile,"C.%sN%s",CutRemoteName,seqname);
 sprintf(tmpcmdfile,"_.%sN%s",CutRemoteName,seqname);
 sprintf(LocalExecFile,"D.%sX%s",CutRemoteName,seqname);
 sprintf(datafile,"D.%sB%s",CutRemoteName,seqname);
 sprintf(RemoteExecFile,"X.%sX%s",CutNodeName,seqname);
 sprintf(RemoteDataFile,"D.%sB%s",CutNodeName,seqname);

 /* Lock file */
 LockFile(LocalExecFile);

 /* Open local exec file */
 if (fh=fopen(LocalExecFile,"w")) {

  /* Write exec file data */
  fprintf(fh,"U %s %s\nR postmaster\nZ\nF %s\nI %s\nC %s\n",
             sender,NodeName,RemoteDataFile,RemoteDataFile,command);
  fclose(fh);
  UnLockFile(LocalExecFile);
  LockFile(tmpcmdfile);

  /* Open command file */
  if (fh=fopen(tmpcmdfile,"w")) {
   char *fname;

   /* Write command file data */
   fprintf(fh,CommandFormat,datafile,RemoteDataFile,datafile);
   fprintf(fh,CommandFormat,LocalExecFile,RemoteExecFile,LocalExecFile);
   fclose(fh);
   UnLockFile(tmpcmdfile);
   LockFile(datafile);

   /* Compression? */
   if (ed->ed_CompCmd)
    /* Yes, create temporary file */
    fname=tmpnam(ed->ed_TmpName);
   else
    /* No */
    fname=datafile;

   /* Open data file */
   if (ed->ed_OutFile=fopen(fname,"w"))
    /* All OK. */
    return(TRUE);
   else {
    ulog(-1,"couldn't create data file '%s'!",fname);
    UnLockFile(datafile);
   }
  } else {
   ulog(-1,"couldn't create command file '%s'!",tmpcmdfile);
   UnLockFile(tmpcmdfile);
  }
 } else {
  ulog(-1,"couldn't create exec file '%s'!",LocalExecFile);
  UnLockFile(LocalExecFile);
 }

 /* Error */
 return(FALSE);
}

/* Finish UUCP files */
BOOL FinishUUCPFiles(struct ExportData *ed)
{
 BOOL rc=TRUE;

 /* Close data file */
 fclose(ed->ed_OutFile);
 ed->ed_OutFile=NULL;

 /* Compress data file? */
 if (ed->ed_CompCmd) {
  BPTR newfile;

  /* Open new file for writing */
  rc=FALSE;
  if (newfile=Open(ed->ed_DataFile,MODE_NEWFILE)) {
   BPTR oldfile;

   if (ed->ed_DFileHdr) {
    VFPrintf(newfile,"#! %s\n",(LONG *) &ed->ed_DFileHdr);
    Flush(newfile);
   }

   /* Open old file for reading */
   if (oldfile=Open(ed->ed_TmpName,MODE_OLDFILE))

    /* Start compression program */
    if (SystemTags(ed->ed_CompCmd,SYS_Input,     oldfile,
                                  SYS_Output,    newfile,
                                  SYS_UserShell, TRUE,
                                  TAG_DONE)==0)
     /* All OK! */
     rc=TRUE;
    else
     /* Error in compression */
     ulog(-1,"couldn't compress data file '%s'!",ed->ed_TmpName);

   Close(oldfile);
   if (rc) DeleteFile(ed->ed_TmpName);
   else
    ulog(-1,"couldn't open temporary file '%s'!",ed->ed_TmpName);

   Close(newfile);
  } else
   ulog(-1,"couldn't open final data file '%s'!",ed->ed_DataFile);
 }

 /* Rename local command file, if job creation was successful */
 if (rc) rc=Rename(ed->ed_TmpCmdFile,ed->ed_LocalCmdFile);

 /* Unlock data file */
 UnLockFile(ed->ed_DataFile);
 return(rc);
}
