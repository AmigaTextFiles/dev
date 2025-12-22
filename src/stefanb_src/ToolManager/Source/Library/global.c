/*
 * global.c  V3.1
 *
 * ToolManager global parameters
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

#include "toolmanager.h"

/* Local data */
#define PROPCHUNKS 3
static const ULONG PropChunksTable[2 * PROPCHUNKS] = {
 ID_TMGP, ID_DATA,
 ID_TMGP, ID_CDIR,
 ID_TMGP, ID_CMND
};
static const ULONG MapRemapPrecision[DATA_GLOBAL_PRECISION_MAX] = {
 PRECISION_EXACT, PRECISION_IMAGE, PRECISION_ICON, PRECISION_GUI
};
static char *GlobalDirectory   = NULL;
static char *GlobalPreferences = NULL;

/* Parse global parameters IFF chunk */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ParseGlobalIFF
BOOL ParseGlobalIFF(struct IFFHandle *iffh)
{
 BOOL rc = FALSE;

 GLOBAL_LOG(LOG1(Handle, "0x%08lx", iffh))

 /* Configure & start IFF parser */
 if ((PropChunks(iffh, PropChunksTable, PROPCHUNKS) == 0) &&
     (StopOnExit(iffh, ID_TMGP, ID_FORM) == 0)  &&
     (ParseIFF(iffh, IFFPARSE_SCAN) == IFFERR_EOC)) {
  struct StoredProperty *sp;

  GLOBAL_LOG(LOG1(Parsed, "Data 0x%08lx", sp))

  /* Chunk parsed. First delete old global parameters */
  FreeGlobalParameters();

  /* Duplicate strings */
  GlobalDirectory   = DuplicateProperty(iffh, ID_TMGP, ID_CDIR);
  GlobalPreferences = DuplicateProperty(iffh, ID_TMGP, ID_CMND);

  GLOBAL_LOG(LOG2(Directory, "%s (0x%08lx)",   GlobalDirectory,
                  GlobalDirectory))
  GLOBAL_LOG(LOG2(Preferences, "%s (0x%08lx)", GlobalPreferences,
                  GlobalPreferences))

  /* Directory valid? */
  if (GlobalDirectory)

   /* Yes, go to directory. This may fail but our directory is NULL anyway */
   CurrentDir(Lock(GlobalDirectory, SHARED_LOCK));

  /* Does DATA chunk exist? */
  if (sp = FindProp(iffh, ID_TMGP, ID_DATA)) {
   struct GlobalDATAChunk *gdc = (struct GlobalDATAChunk *) sp->sp_Data;
   ULONG                   i;

   GLOBAL_LOG(LOG2(Data, "Flags 0x%08lx Precision %ld", gdc->gdc_Flags,
                   gdc->gdc_Precision))

   /* Network enabled or disabled? */
   if (gdc->gdc_Flags & DATA_GLOBALF_NETWORKENABLE)
    EnableNetwork();
   else
    DisableNetwork();

   /* Sanity check for remap precision */
   if ((i = gdc->gdc_Precision) >= DATA_GLOBAL_PRECISION_MAX)
    i = DATA_GLOBAL_PRECISION_DEFAULT;

   /* Remapping enabled? */
   EnableRemap((gdc->gdc_Flags & DATA_GLOBALF_REMAPENABLE) != 0,
               MapRemapPrecision[i]);
  }

  /* Chunk OK */
  rc = TRUE;
 }

 GLOBAL_LOG(LOG1(Result, "%ld", rc))

 return(rc);
}

#undef  DEBUGFUNCTION
#define DEBUGFUNCTION FreeGlobalParameters
/* Free global parameters */
void FreeGlobalParameters(void)
{
 GLOBAL_LOG(LOG0(Freeing global data))

 /* Free strings */
 if (GlobalPreferences) FreeVector(GlobalPreferences);
 GlobalPreferences = NULL;
 if (GlobalDirectory)   FreeVector(GlobalDirectory);
 GlobalDirectory   = NULL;

 /* Return to NULL lock and release old directory (Maybe NULL!) */
 UnLock(CurrentDir(NULL));
}

/* Return name of global default directory */
char *GetGlobalDefaultDirectory(void)
{
 return(GlobalDirectory ? GlobalDirectory : DefaultDirectory);
}

/* Start preferences program */
void StartPreferences(void)
{
 /* Start preferences as WB program */
 StartWBProgram(GlobalPreferences ? GlobalPreferences :
                                    "SYS:Prefs/ToolManager",
                GlobalDirectory, 4096, 0, NULL);
}
