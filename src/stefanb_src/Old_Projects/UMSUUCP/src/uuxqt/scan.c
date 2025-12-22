/*
 * scan.c  V0.8.01
 *
 * scan incoming directory
 *
 * (c) 1992-94 Stefan Becker
 *
 */

#include "uuxqt.h"

ULONG FileCounter=0;
ULONG FileBadCounter=0;

#define FILENAMEBUFSIZE 8192
#define EXALLBUFSIZE    (FILENAMEBUFSIZE + 4)
struct ExAllBuffer {
                    struct ExAllBuffer *eab_Next;
                    struct ExAllData    eab_Data;
                   };

static struct ExAllBuffer *ExAllBufsRoot=NULL;
static struct ExAllData   *ExAllDataRoot=NULL;

#define PARSEBUFSIZE 20
static char ParseBuf[PARSEBUFSIZE];

/* Get all file names of incoming command files (sorted) */
static BOOL GetFileNames(BPTR dirlock)
{
 struct ExAllControl *eac;
 struct ExAllData *root=NULL;
 BOOL rc=FALSE;

 /* Allocate ExAllControl structure */
 if (eac=AllocDosObjectTags(DOS_EXALLCONTROL,TAG_DONE)) {

  /* Create parse pattern */
  if (ParsePatternNoCase("X.#?",ParseBuf,PARSEBUFSIZE)!=-1) {
   ULONG files=0;
   BOOL more;

   /* Init ExAllControl structure */
   eac->eac_LastKey=0;
   eac->eac_MatchString=ParseBuf;
   eac->eac_MatchFunc=NULL;

   /* Reset return code */
   rc=TRUE;

   /* Main loop: Process X.#? files */
   do {
    struct ExAllBuffer *eab;
    struct ExAllData *ead;

    /* Allocate new file name buffer */
    if (eab=AllocMem(EXALLBUFSIZE,MEMF_PUBLIC|MEMF_CLEAR)) {
     /* Chain into buffer list */
     if (ExAllBufsRoot) eab->eab_Next=ExAllBufsRoot;
     ExAllBufsRoot=eab;
    } else {
     ErrLog("couldn't allocate memory for file names!\n");
     break;
    }

    /* Read file names */
    ead=&eab->eab_Data;
    more=ExAll(dirlock,ead,FILENAMEBUFSIZE,ED_NAME,eac);

    /* Error? */
    if (!more && (IoErr() != ERROR_NO_MORE_ENTRIES)) {
     ErrLog("error in ExAll()!\n");
     root=NULL;
     rc=FALSE;
     break;
    }

    /* Finished? */
    if (eac->eac_Entries==0) continue;

    /* Process files */
    do {
     struct ExAllData *next=ead->ed_Next;

     /* First file name? */
     if (root) {
      /* No, sort new file name into list */
      struct ExAllData *current=root,*parent=NULL;

      /* Find place to insert name */
      while (current && (strcmp(current->ed_Name,ead->ed_Name)<0)) {
       parent=current;
       current=current->ed_Next;
      }

      /* Last node? */
      if (current) {
       /* No. Insert node */
       ead->ed_Next=current;

       /* New root node? */
       if (parent)
        /* No, build chain */
        parent->ed_Next=ead;
       else
        /* Yes, set new root */
        root=ead;

      } else {
       /* Yes. Append node */
       parent->ed_Next=ead;
       ead->ed_Next=NULL;
      }
     }
     else {
      /* Yes, init root */
      root=ead;
      ead->ed_Next=NULL;

      /* New files found! */
      printf("New files have arrived.\n");
     }

     /* Next file name */
     files++;
     ead=next;
    } while (ead);
   } while (more);

   if (root) {
    ulog(1,"found %d command files.",files);
    ExAllDataRoot=root;
   }

   FreeDosObject(DOS_EXALLCONTROL,eac);
  } else
   ErrLog("can't parse pattern!\n");
 } else
  ErrLog("can't allocate ExAllControl!\n");

 return(rc);
}

/* Free all allocated file name buffers */
static void FreeFileNames(void)
{
 struct ExAllBuffer *eab=ExAllBufsRoot;

 /* Scan all buffers */
 while (eab) {
  struct ExAllBuffer *next=eab->eab_Next;

  /* Free Buffer */
  FreeMem(eab,EXALLBUFSIZE);

  /* Next Buffer */
  eab=next;
 }
}

/* Scan incoming directory */
int ScanInDir(BPTR dirlock)
{
 int rc=RETURN_FAIL;

 /* Get file names */
 if (GetFileNames(dirlock)) {
  struct ExAllData *ead;

  /* Reset return code */
  rc=RETURN_OK;

  /* Got any files? */
  if (ead=ExAllDataRoot) {

   /* Yes, scan file name list */
   while (ead && (rc!=RETURN_FAIL)) {
    char *workfile=ead->ed_Name;
    int   trc;

    /* Lock file */
    LockFile(workfile);

    /* Process one command file */
    if ((trc=ParseCommandFile(workfile))!=RETURN_OK) {
     /* Error */
     FileBadCounter++;
     rc=trc;
    }
    FileCounter++;
    PrintProgress(FALSE);

    /* Unlock file */
    UnLockFile(workfile);

    /* Next file */
    ead=ead->ed_Next;
   }

   /* Log aborts */
   if (rc==RETURN_FAIL) {
    ErrLog("*** FATAL ERROR *** aborting!\n");
    ulog(-1,"fatal error, aborting!");
   }

   /* Close error log */
   CloseErrLog();

   /* All OK. */
   PrintProgress(TRUE);
   ulog(-1,"processed %d files",FileCounter);
  }
 }
 FreeFileNames();

 return(rc);
}
