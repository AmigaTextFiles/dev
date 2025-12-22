/*
 * sound.c  V3.1
 *
 * ToolManager old preferences converter for Sound Objects
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
static struct MinList IDList;
static struct StandardDATAChunk sdc;

/* Old Prefs stuff */
struct SoundPrefsObject {
                         ULONG spo_StringBits;
                        };
#define SOPO_NAME    (1L << 0)
#define SOPO_COMMAND (1L << 1)
#define SOPO_PORT    (1L << 2)

/* Initialize Sound ID list */
void InitSoundIDList(void)
{
 NewList((struct List *) &IDList);
}

/* Free Sound ID list */
void FreeSoundIDList(void)
{
 FreeIDList(&IDList);
}

/* Find ID to corresponding Sound name */
ULONG FindSoundID(const char *name)
{
 return(FindIDInList(&IDList, name));
}

/* Conversion routine */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ConvertSoundConfig
BOOL ConvertSoundConfig(void *chunk, struct IFFHandle *iffh, ULONG id)
{
 struct SoundPrefsObject *spo = chunk;
 char                    *s   = (char *) (spo + 1);
 BOOL                     rc  = FALSE;

 SOUND_LOG(LOG3(Entry, "Chunk 0x%08lx IFF Handle 0x%08lx ID 0x%08lx",
                chunk, iffh, id))

 /* Get name to create ID list entry */
 if ((spo->spo_StringBits & SOPO_NAME) && AddIDToList(&IDList, s, id)) {

  /* Initialize fixed data */
  sdc.sdc_ID    = id;
  sdc.sdc_Flags = 0;

  /* Create new config entry */
  rc = (PushChunk(iffh, ID_TMSO, ID_FORM, IFFSIZE_UNKNOWN) == 0) &&
       (PushChunk(iffh, 0,       ID_DATA, IFFSIZE_UNKNOWN) == 0) &&
       (WriteChunkBytes(iffh, &sdc, sizeof(struct StandardDATAChunk))
         == sizeof(struct StandardDATAChunk)) &&
       (PopChunk(iffh) == 0) &&
       (((spo->spo_StringBits & SOPO_NAME)    == 0) ||
        (s = ConvertConfigString(s, iffh, ID_NAME))) &&
       (((spo->spo_StringBits & SOPO_COMMAND) == 0) ||
        (s = ConvertConfigString(s, iffh, ID_CMND))) &&
       (((spo->spo_StringBits & SOPO_PORT) == 0) ||
        (s = ConvertConfigString(s, iffh, ID_PORT))) &&
       (PopChunk(iffh) == 0)  ;
 }

 SOUND_LOG(LOG1(Result, "%ld", rc))

 return(rc);
}
