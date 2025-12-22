/*
 * exportdata.c  V0.7.02
 *
 * Get export data from UMS config
 *
 * (c) 1992-93 Stefan Becker
 *
 */

#include "ums2uucp.h"

/* Get export data from UMS config */
BOOL GetExportData(char *name, struct ExportData *ed)
{
 BOOL rc=FALSE;

 /* Set defaults */
 ed->ed_Batch=FALSE;
 ed->ed_XFileCmd=NULL;
 ed->ed_CompCmd=NULL;
 ed->ed_DFileHdr=NULL;
 ed->ed_MaxSize=65536;
 ed->ed_OutFile=NULL;

 /* Get UMS config var */
 if (ed->ed_UMSVar=ReadUMSConfigTags(Account,UMSTAG_CfgName,name,
                                             TAG_DONE)) {
  /*
   * Config variable format:
   *
   *  <xcmd> , <batch> , <compcmd> , <dhdr> ,<max size>
   *   |        |         |           |       |
   *   |        |         |           |       --- Number of bytes for batch
   *   |        |         |           |           (Default: 65536)
   *   |        |         |           --- D.* file header (Default: None)
   *   |        |         --- Compress command name (Default: None)
   *   |        ------------- Batch? y,Y - Yes; n,N - No (Default: No)
   *   ---------------------- X.* file command (must be specified)
   */
  char *cp=ed->ed_UMSVar;

  /* Empty string or empty command name? */
  if ((*cp!='\0') && (*cp!=',')) {

   /* No, UUCP command found, reset error flag */
   ed->ed_XFileCmd=cp;
   rc=TRUE;

   /* Another field? */
   if (cp=strchr(cp,',')) {

    /* Yes, terminate last field and extract batch information  */
    *cp++='\0';
    if ((*cp=='y') || (*cp=='Y')) ed->ed_Batch=TRUE; /* Create batches */

    /* Another field? */
    if (cp=strchr(cp,',')) {

     /* Yes, get compress command name */
     ed->ed_CompCmd=++cp;

     /* Empty name? */
     if (*cp==',') ed->ed_CompCmd=NULL; /* No compression */

     /* Another field? */
     if (cp=strchr(cp,',')) {

      /* Yes, terminate last field and get D.* file header */
      *cp++='\0';
      ed->ed_DFileHdr=cp;

      /* Empty header? */
      if (*cp==',') ed->ed_DFileHdr=NULL; /* No header */

      /* Another field? */
      if (cp=strchr(cp,',')) {

       /* Yes, terminate last field and get batch size */
       *cp++='\0';
       ed->ed_MaxSize=atol(cp);
      }
     }
    }
   }

   /* Debugging */
   ulog(1,"%s: %sbatched, xcmd '%s', comp '%s', dhdr '%s', %d bytes per batch",
          name, (ed->ed_Batch) ? "" : "not ", ed->ed_XFileCmd,
          (ed->ed_CompCmd) ? ed->ed_CompCmd : "not compressed",
          (ed->ed_DFileHdr) ? ed->ed_DFileHdr : "no header",
          ed->ed_MaxSize);

   /* Error: No XFileCmd */
  } else {
   FreeUMSConfig(Account,ed->ed_UMSVar);
   ulog(-1,"%s: No UUCP command found!\n",name);
  }
 }

 return(rc);
}

/* Free export data */
void FreeExportData(struct ExportData *ed)
{
 FreeUMSConfig(Account,ed->ed_UMSVar);
}
