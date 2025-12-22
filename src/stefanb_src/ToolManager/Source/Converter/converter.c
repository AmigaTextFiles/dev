/*
 * converter.c  V3.1
 *
 * ToolManager preferences file converter (2.x -> 3.x)
 *
 * Copyright (C) 1990-98 Stefan Becker
 *
 * This source code is for educational purposes only. You may study it
 * and copy ideas or algorithms from it for your own projects. It is
 * not allowed to use any of the source codes (in full or in parts)
 * in other programs. Especially it is not allowed to create variants
 * of ToolManager or ToolManager-like programs from this source code.
 *
 */

#include "converter.h"

/* Local data */
static const char Version[]       = "$VER: TMPrefsConverter " TMVERSION
                                    " (" __COMMODORE_DATE__ ")";
#define TMCONFIGNAME "ToolManager.prefs" /* TEMPORARY! */
static const char PrefsFileName[] = "ENVARC:" TMCONFIGNAME;
static const char NewFileName[]   = "ENVARC:" TMCONFIGNAME ".new";

/* Global data */
extern struct Library *DOSBase;
extern struct Library *IFFParseBase;

/* Check ToolManager 2.x preferences file */
static BOOL CheckOldPrefs(struct IFFHandle *iffh)
{
 struct ContextNode *cn;
 struct PrefHeader   ph;

 /* a) Do first parse step       */
 /* b) Check for FORM PREF chunk */
 /* c) Check for PRHD chunk      */
 /* d) Read PRHD chunk           */
 /* e) Check for version 0       */
 /* f) Do next Parse step        */
 return((ParseIFF(iffh, IFFPARSE_STEP) == 0) &&
        (cn = CurrentChunk(iffh)) && (cn->cn_ID   == ID_FORM) &&
                                     (cn->cn_Type == ID_PREF) &&
        (ParseIFF(iffh, IFFPARSE_STEP) == 0) &&
        (cn = CurrentChunk(iffh)) && (cn->cn_ID   == ID_PRHD) &&
        (ReadChunkBytes(iffh, &ph, sizeof(struct PrefHeader))
          == sizeof(struct PrefHeader)) &&
        (ph.ph_Version == 0) &&
        (ParseIFF(iffh, IFFPARSE_STEP) == IFFERR_EOC));
}

/* Prepare ToolManager 3.0 preferences file */
static BOOL PrepareNewPrefs(struct IFFHandle *iffh)
{
 struct GlobalDATAChunk gdc;

 /* Initialize DATA chunk */
 gdc.gdc_Flags     = DATA_GLOBALF_REMAPENABLE;
 gdc.gdc_Precision = DATA_GLOBAL_PRECISION_DEFAULT;

        /* a) Push FORM TMPR chunk         */
        /* b) Push, write & pop FVER chunk */
        /* c) Push FORM TMGP chunk         */
        /* d) Push, write & pop DATA chunk */
        /* e) Pop FORM TMGP chunk          */
 return((PushChunk(iffh, ID_TMPR, ID_FORM, IFFSIZE_UNKNOWN) == 0)        &&
        (PushChunk(iffh, 0,       ID_FVER, IFFSIZE_UNKNOWN) == 0)        &&
        (WriteChunkBytes(iffh, TMCONFIGVERSION, sizeof(TMCONFIGVERSION))
          == sizeof(TMCONFIGVERSION))                                    &&
        (PopChunk(iffh) == 0)                                            &&
        (PushChunk(iffh, ID_TMGP, ID_FORM, IFFSIZE_UNKNOWN) == 0)        &&
        (PushChunk(iffh, 0,       ID_DATA, IFFSIZE_UNKNOWN) == 0)        &&
        (WriteChunkBytes(iffh, &gdc, sizeof(struct GlobalDATAChunk))
         == sizeof(struct GlobalDATAChunk))                              &&
        (PopChunk(iffh) == 0)                                            &&
        (PopChunk(iffh) == 0));
}

/* CLI main entry point */
#define DEBUGFUNCTION main
int main(int argc, char **argv)
{
 int rc = RETURN_FAIL;

 INITDEBUG(ToolManagerConverterDebug)

 /* Workbench startup? Yes, make sure that stdout is open */
 if ((argc != 0) ||
      freopen("CON:0/0/640/200/ToolManager Prefs Conversion/WAIT/CLOSE/AUTO",
              "w", stdout)) {
  struct IFFHandle *OldIFFHandle;

  /* Print banner */
  printf("%s\n", &Version[6]);

  /* Initialize memory pool */
  if (InitMemory()) {

   /* Print progress */
   printf("Opening ToolManager 2.x Preferences...");
   fflush(stdout);

   /* Allocate IFF Handle for old prefs file */
   if (OldIFFHandle = AllocIFF()) {

    MAIN_LOG(LOG1(Old IFF Handle, "0x%08lx", OldIFFHandle))

    /* Open old prefs file */
    if (OldIFFHandle->iff_Stream = Open(PrefsFileName, MODE_OLDFILE)) {

     MAIN_LOG(LOG1(Old File Handle, "0x%08lx", OldIFFHandle->iff_Stream))

     /* Initialize IFF handle */
     InitIFFasDOS(OldIFFHandle);

     /* Open IFF handle */
     if (OpenIFF(OldIFFHandle, IFFF_READ) == 0) {
      struct IFFHandle *NewIFFHandle;

      MAIN_LOG(LOG0(Old IFF Handle open))

      /* Check old prefs file */
      if (CheckOldPrefs(OldIFFHandle)) {

       MAIN_LOG(LOG0(Old Prefs file OK))

       printf(" OK\nOpening ToolManager 3.0 Preferences...");
       fflush(stdout);

       /* Allocate IFF Handle for new prefs file */
       if (NewIFFHandle = AllocIFF()) {

        MAIN_LOG(LOG1(New IFF Handle, "0x%08lx", NewIFFHandle))

        /* Open new prefs file */
        if (NewIFFHandle->iff_Stream = Open(NewFileName, MODE_NEWFILE)) {
         ULONG protection = 0;

         MAIN_LOG(LOG1(New File Handle, "0x%08lx", NewIFFHandle->iff_Stream))

         /* Set protection bits */
         {
          struct FileInfoBlock *fib;

          /* Allocate file info block */
          if (fib = AllocDosObject(DOS_FIB, NULL)) {

           MAIN_LOG(LOG1(FIB, "0x%08lx", fib))

           /* Examine file */
           if (ExamineFH(NewIFFHandle->iff_Stream, fib)) {

            MAIN_LOG(LOG1(Old protection bits, "0x%08lx", fib->fib_Protection))

            /* Copy protection bits */
            protection = fib->fib_Protection;

            /* Clear execute flag */
            SetProtection(NewFileName, fib->fib_Protection | FIBF_EXECUTE);
           }

           /* Free file info block */
           FreeDosObject(DOS_FIB, fib);
          }
         }

         /* Initialize IFF handle */
         InitIFFasDOS(NewIFFHandle);

         /* Open IFF handle */
         if (OpenIFF(NewIFFHandle, IFFF_WRITE) == 0) {

           MAIN_LOG(LOG0(New IFF Handle open))

           /* Prepare new preferences file */
           if (PrepareNewPrefs(NewIFFHandle)) {

            MAIN_LOG(LOG0(New Prefs prepared))

            printf(" OK\nConverting");
            fflush(stdout);

            /* Scan old preferences file */
            if (ScanOldConfig(OldIFFHandle, NewIFFHandle)) {

             MAIN_LOG(LOG0(Converted))

             /* Complete new preferences file */
             if (PopChunk(NewIFFHandle) == 0) {

              MAIN_LOG(LOG0(New Prefs completed))

              /* All OK */
              rc = TRUE;
             }
            }
           }

          CloseIFF(NewIFFHandle);
         }
         Close(NewIFFHandle->iff_Stream);

         /* Clear execute flag */
         SetProtection(NewFileName, protection | FIBF_EXECUTE);
        }
        FreeIFF(NewIFFHandle);
       }
      }
      CloseIFF(OldIFFHandle);
     }
     Close(OldIFFHandle->iff_Stream);
    }
    FreeIFF(OldIFFHandle);
   }

   /* Error? */
   if (rc == RETURN_FAIL) {

#ifndef DEBUG
    /* Delete new file */
    DeleteFile(NewFileName);
#endif

    printf(" ***FAILED***!\n");

   } else {

    MAIN_LOG(LOG0(Renaming Files))

#ifndef DEBUG
    /* All OK, rename files */
    Rename(PrefsFileName, "ENVARC:" TMCONFIGNAME ".old");
    Rename(NewFileName,   PrefsFileName);
#endif

    printf(" DONE\nOld Preferences file has been renamed to: "
            "ENVARC:" TMCONFIGNAME ".old\n" );
   }

   DeleteMemory();
  }
 }

 MAIN_LOG(LOG1(Result, "%ld", rc))

 return(rc);
}

#ifdef _DCC
/* Workbench main entry point */
int wbmain(struct WBStartup *wbs)
{
 /* Just call the CLI entry with argc set to zero */
 return(main(0, NULL));
}
#endif
