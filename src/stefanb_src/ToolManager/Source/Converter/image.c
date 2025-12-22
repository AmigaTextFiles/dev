/*
 * image.c  V3.1
 *
 * ToolManager old preferences converter for Image Objects
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
struct ImagePrefsObject {
                         ULONG ipo_StringBits;
                        };
#define IMPO_NAME (1L << 0)
#define IMPO_FILE (1L << 1)

/* Initialize Image ID list */
void InitImageIDList(void)
{
 NewList((struct List *) &IDList);
}

/* Free Image ID list */
void FreeImageIDList(void)
{
 FreeIDList(&IDList);
}

/* Find ID to corresponding Image name */
ULONG FindImageID(const char *name)
{
 return(FindIDInList(&IDList, name));
}

/* Conversion routine */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ConvertImageConfig
BOOL ConvertImageConfig(void *chunk, struct IFFHandle *iffh, ULONG id)
{
 struct ImagePrefsObject *ipo = chunk;
 char                    *s   = (char *) (ipo + 1);
 BOOL                     rc  = FALSE;

 IMAGE_LOG(LOG3(Entry, "Chunk 0x%08lx IFF Handle 0x%08lx ID 0x%08lx",
                chunk, iffh, id))

 /* Get name to create ID list entry */
 if ((ipo->ipo_StringBits & IMPO_NAME) && AddIDToList(&IDList, s, id)) {

  /* Initialize fixed data */
  sdc.sdc_ID    = id;
  sdc.sdc_Flags = 0;

  /* Create new config entry */
  rc = (PushChunk(iffh, ID_TMIM, ID_FORM, IFFSIZE_UNKNOWN) == 0) &&
       (PushChunk(iffh, 0,       ID_DATA, IFFSIZE_UNKNOWN) == 0) &&
       (WriteChunkBytes(iffh, &sdc, sizeof(struct StandardDATAChunk))
         == sizeof(struct StandardDATAChunk)) &&
       (PopChunk(iffh) == 0) &&
       (((ipo->ipo_StringBits & IMPO_NAME)    == 0) ||
        (s = ConvertConfigString(s, iffh, ID_NAME))) &&
       (((ipo->ipo_StringBits & IMPO_FILE) == 0) ||
        (s = ConvertConfigString(s, iffh, ID_FILE))) &&
       (PopChunk(iffh) == 0)  ;
 }

 IMAGE_LOG(LOG1(Result, "%ld", rc))

 return(rc);
}
