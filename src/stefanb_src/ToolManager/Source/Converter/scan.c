/*
 * scan.c  V3.1
 *
 * ToolManager old preferences file scanner
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

/* Name for "unnamed" group */
#define GROUP_UNNAMED "unnamed"

/* Legal chunk IDs */
static const struct ChunkData {
 ULONG   cd_ID;
 BOOL  (*cd_Func)(void *, struct IFFHandle *, ULONG);
} LegalChunks[] = {
 0,       NULL,
 ID_TMEX, ConvertExecConfig,
 ID_TMIM, ConvertImageConfig,
 ID_TMSO, ConvertSoundConfig,
 ID_TMMO, ConvertMenuConfig,
 ID_TMIC, ConvertIconConfig,
 ID_TMDO, ConvertDockConfig,
 ID_TMAC, ConvertAccessConfig,
 0,       NULL
};

/* Check for legal chunk ID */
#define DEBUGFUNCTION IsLegalChunk
static struct ChunkData *IsLegalChunk(struct ChunkData *cd,
                                      struct ContextNode *cn,
                                      struct IFFHandle *iffh)
{
 static BOOL       LISTPending = FALSE; /* LIST Chunk must be pop'ed */
 struct ChunkData *rc;

 /* Same chunk? */
 if (cn->cn_ID == cd->cd_ID) {

  SCAN_LOG(LOG0(Same Chunk type))

  /* Yes, do nothing */
  rc = cd;

 } else {

  SCAN_LOG(LOG1(New Chunk type, "0x%08lx", cn->cn_ID))

  /* Set error code */
  rc = NULL;

  /* Get next legal chunk ID */
  while ((cn->cn_ID != (++cd)->cd_ID) && (cd->cd_ID != 0)) {

   SCAN_LOG(LOG1(Skipping, "0x%08lx", cd->cd_ID))
  }

  /* Legal chunk ID? */
  if (cd->cd_ID != 0) {

   /* Yes, close old LIST */
   if ((LISTPending == FALSE) || (PopChunk(iffh) == 0)) {

    /* Open next LIST */
    if ((PushChunk(iffh, cd->cd_ID, ID_LIST, IFFSIZE_UNKNOWN) == 0) &&
        (PushChunk(iffh, cd->cd_ID, ID_PROP, IFFSIZE_UNKNOWN) == 0) &&
        (PushChunk(iffh, 0,         ID_OGRP, IFFSIZE_UNKNOWN) == 0) &&
        (WriteChunkBytes(iffh, GROUP_UNNAMED, sizeof(GROUP_UNNAMED))
          == sizeof(GROUP_UNNAMED)) &&
        (PopChunk(iffh) == 0) && /* OGRP */
        (PopChunk(iffh) == 0)) { /* PROP */

     /* Chunk is open */
     LISTPending = TRUE;

     /* All OK */
     rc = cd;
    }
   }
  }
 }

 return(rc);
}

/* Scan old preferences file */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ScanOldConfig
BOOL ScanOldConfig(struct IFFHandle *oldiffh, struct IFFHandle *newiffh)
{
 struct ChunkData *cd = LegalChunks;
 ULONG             id = 1;
 BOOL              rc = TRUE;

 SCAN_LOG(LOG2(Entry, "Old 0x%08x New 0x%08lx", oldiffh, newiffh))

 /* Initialize ID lists */
 InitExecIDList();
 InitImageIDList();
 InitSoundIDList();

 /* Scan chunks */
 while (rc && (ParseIFF(oldiffh, IFFPARSE_STEP) == 0)) {
  struct ContextNode *cn;

  SCAN_LOG(LOG0(Next chunk));

  /* Check next chunk */
  if (cn = CurrentChunk(oldiffh)) {

   /* Current chunk type or next legal chunk type? */
   if (cd = IsLegalChunk(cd, cn, newiffh)) {
    void *buf;

    SCAN_LOG(LOG1(Legal chunk, "0x%08lx", cn->cn_ID))

    /* Allocate memory for chunk */
    if (buf = AllocMem(cn->cn_Size, MEMF_PUBLIC)) {

     SCAN_LOG(LOG2(Buffer, "0x%08lx (%ld)", buf, cn->cn_Size))

     /* Read, convert and leave chunk */
     if ((ReadChunkBytes(oldiffh, buf, cn->cn_Size) == cn->cn_Size)  &&
         ((*cd->cd_Func)(buf, newiffh, id++)) &&
         (ParseIFF(oldiffh, IFFPARSE_STEP) == IFFERR_EOC)) {

      SCAN_LOG(LOG0(Chunk converted))

      /* Progress report */
      putchar('.');
      fflush(stdout);

     } else
      rc = FALSE;

     FreeMem(buf, cn->cn_Size);
    } else
     rc = FALSE;

   } else {
    SCAN_LOG(LOG1(Unexpected chunk, "0x%08lx", cn->cn_ID))
    rc = FALSE;
   }

  } else {
   SCAN_LOG(LOG0(No current chunk?!?))
   rc = FALSE;
  }
 }

 /* Free ID lists */
 FreeSoundIDList();
 FreeImageIDList();
 FreeExecIDList();

 return(rc);
}
