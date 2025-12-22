/*
 * menu.c  V3.1
 *
 * ToolManager old preferences converter for Menu Objects
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
static struct MenuDATAChunk mdc;

/* Old Prefs stuff */
struct MenuPrefsObject {
                        ULONG mpo_StringBits;
                       };
#define MOPO_NAME  (1L << 0)
#define MOPO_EXEC  (1L << 1)
#define MOPO_SOUND (1L << 2)

/* Conversion routine */
#define DEBUGFUNCTION ConvertMenuConfig
BOOL ConvertMenuConfig(void *chunk, struct IFFHandle *iffh, ULONG id)
{
 struct MenuPrefsObject *mpo = chunk;
 char                   *s   = (char *) (mpo + 1);
 BOOL                    rc  = FALSE;

 MENU_LOG(LOG3(Entry, "Chunk 0x%08lx IFF Handle 0x%08lx ID 0x%08lx",
               chunk, iffh, id))

 /* Check that name is valid */
 if (mpo->mpo_StringBits & MOPO_NAME) {
  char *name = s;

  /* Skip name */
  s += strlen(name) + 1;

  /* Initialize fixed data */
  mdc.mdc_Standard.sdc_ID    = id;
  mdc.mdc_Standard.sdc_Flags = 0;
  mdc.mdc_ExecObject         = 0;
  mdc.mdc_SoundObject        = 0;

  /* Find linked objects */
  if (mpo->mpo_StringBits & MOPO_EXEC) {
   mdc.mdc_ExecObject = FindExecID(s);
   s += strlen(s) + 1;
  }
  if (mpo->mpo_StringBits & MOPO_SOUND)
   mdc.mdc_SoundObject = FindSoundID(s);

  /* Create new config entry */
  rc = (PushChunk(iffh, ID_TMMO, ID_FORM, IFFSIZE_UNKNOWN) == 0) &&
       (PushChunk(iffh, 0,       ID_DATA, IFFSIZE_UNKNOWN) == 0) &&
       (WriteChunkBytes(iffh, &mdc, sizeof(struct MenuDATAChunk))
         == sizeof(struct MenuDATAChunk)) &&
       (PopChunk(iffh) == 0) &&
       (ConvertConfigString(name, iffh, ID_NAME) != NULL) &&
       (PopChunk(iffh) == 0)  ;
 }

 MENU_LOG(LOG1(Result, "%ld", rc))

 return(rc);
}
