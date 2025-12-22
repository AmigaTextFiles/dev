/*
 * exportdata.c  V1.0.01
 *
 * Get export data from UMS config
 *
 * (c) 1992-98 Stefan Becker
 *
 */

#include "ums2uucp.h"

/* Get export data from UMS config */
BOOL GetExportData(char *name, struct ExportData *ed)
{
 BOOL rc = FALSE;

 /* Set defaults */
 ed->ed_Flags    = 0;
 ed->ed_XFileCmd = NULL;
 ed->ed_CompCmd  = NULL;
 ed->ed_DFileHdr = NULL;
 ed->ed_MaxSize  = 65536;
 ed->ed_DOSBase  = DOSBase;
 ed->ed_Handle   = 0;
 ed->ed_Counter  = 0;
 ed->ed_Grade    = 'A';

 /* Get UMS config var */
 if (ed->ed_UMSVar = UMSReadConfigTags(Account, UMSTAG_CfgName, name,
                                                TAG_DONE)) {
  /*
   * Config variable format:
   *
   *  <xcmd> , <grade> , <batch> , <compcmd> , <dhdr> ,<max size>
   *   |        |         |         |           |       |
   *   |        |         |         |           |       --- Number of bytes
   *   |        |         |         |           |           for batch
   *   |        |         |         |           |           (Default: 65536)
   *   |        |         |         |           --- D.* file header
   *   |        |         |         |                       (Default: None)
   *   |        |         |         --- Compress cmd name   (Default: None)
   *   |        |         --- Batch? y,Y - Yes; n,N - No    (Default: No)
   *   |        | ----------- Grade 0..9,A-Z,a-z            (Default: A)
   *   ---------------------- X.* file command              (must be specified)
   */
  char *cp = ed->ed_UMSVar;

  /* Empty string or empty command name? */
  if ((*cp != '\0') && (*cp != ',')) {

   /* No, UUCP command found, reset error flag */
   ed->ed_XFileCmd = cp;
   rc              = TRUE;

   /* Another field? */
   if (cp = strchr(cp, ',')) {

    /* Yes, terminate last field and extract grade information  */
    *cp++ = '\0';
    if (((*cp >= '0') && (*cp <= '9')) ||
        ((*cp >= 'A') && (*cp <= 'Z')) ||
        ((*cp >= 'a') && (*cp <= 'z'))) ed->ed_Grade = *cp;

    /* Another field? */
    if (cp = strchr(cp, ',')) {

     /* Yes, terminate last field and extract batch information  */
     *cp++ = '\0';
     if ((*cp == 'y') || (*cp == 'Y'))

      /* Create batches */
      ed->ed_Flags |= EXPORTDATA_FLAGS_BATCH;

     /* Another field? */
     if (cp = strchr(cp, ',')) {

      /* Yes, get compress command name */
      ed->ed_CompCmd = ++cp;

      /* Empty name? */
      if (*cp == ',') ed->ed_CompCmd = NULL; /* No compression */

      /* Another field? */
      if (cp = strchr(cp, ',')) {

       /* Yes, terminate last field and get D.* file header */
       *cp++           = '\0';
       ed->ed_DFileHdr = cp;

       /* Empty header? */
       if (*cp == ',') ed->ed_DFileHdr = NULL; /* No header */

       /* Another field? */
       if (cp = strchr(cp, ',')) {

        /* Yes, terminate last field and get batch size */
        *cp++          = '\0';
        ed->ed_MaxSize = atol(cp);
       }
      }
     }
    }
   }

   /* Debugging */
   ulog(1, "%s: %sbatched, xcmd '%s', comp '%s', dhdr '%s', %d bytes per batch",
           name, (ed->ed_Flags & EXPORTDATA_FLAGS_BATCH) ? "" : "not ",
           ed->ed_XFileCmd,
           (ed->ed_CompCmd) ? ed->ed_CompCmd : "not compressed",
           (ed->ed_DFileHdr) ? ed->ed_DFileHdr : "no header",
           ed->ed_MaxSize);

   /* Error: No XFileCmd */
  } else {
   UMSFreeConfig(Account, ed->ed_UMSVar);
   ulog(-1, "%s: No UUCP command found!", name);
  }
 }

 return(rc);
}

/* Free export data */
void FreeExportData(struct ExportData *ed)
{
 UMSFreeConfig(Account, ed->ed_UMSVar);
}
