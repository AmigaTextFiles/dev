/*
 * icon.c  V3.1
 *
 * ToolManager old preferences converter for Icon Objects
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
static struct IconDATAChunk idc;

/* Old Prefs stuff */
struct IconPrefsObject {
                        ULONG ipo_StringBits;
                        ULONG ipo_Flags;
                        LONG  ipo_XPos;
                        LONG  ipo_YPos;
                       };
#define ICPO_NAME  (1L << 0)
#define ICPO_EXEC  (1L << 1)
#define ICPO_IMAGE (1L << 2)
#define ICPO_SOUND (1L << 3)
#define ICPOF_SHOWNAME (1L << 0)

/* Conversion routine */
#define DEBUGFUNCTION ConvertIconConfig
BOOL ConvertIconConfig(void *chunk, struct IFFHandle *iffh, ULONG id)
{
 struct IconPrefsObject *ipo = chunk;
 char                   *s   = (char *) (ipo + 1);
 BOOL                    rc  = FALSE;

 ICON_LOG(LOG3(Entry, "Chunk 0x%08lx IFF Handle 0x%08lx ID 0x%08lx",
               chunk, iffh, id))

 /* Check that name is valid */
 if (ipo->ipo_StringBits & ICPO_NAME) {
  char *name = s;

  /* Skip name */
  s += strlen(name) + 1;

  /* Initialize fixed data */
  idc.idc_Standard.sdc_ID    = id;
  idc.idc_Standard.sdc_Flags = 0;
  idc.idc_LeftEdge           = ipo->ipo_XPos;
  idc.idc_TopEdge            = ipo->ipo_YPos;
  idc.idc_ExecObject         = 0;
  idc.idc_ImageObject        = 0;
  idc.idc_SoundObject        = 0;

  /* Copy flags */
  if (ipo->ipo_Flags & ICPOF_SHOWNAME)
   idc.idc_Standard.sdc_Flags = DATA_ICONF_SHOWNAME;

  /* Find linked objects */
  if (ipo->ipo_StringBits & ICPO_EXEC) {
   idc.idc_ExecObject = FindExecID(s);
   s += strlen(s) + 1;
  }
  if (ipo->ipo_StringBits & ICPO_IMAGE) {
   idc.idc_ImageObject = FindImageID(s);
   s += strlen(s) + 1;
  }
  if (ipo->ipo_StringBits & ICPO_SOUND)
   idc.idc_SoundObject = FindSoundID(s);

  /* Create new config entry */
  rc = (PushChunk(iffh, ID_TMIC, ID_FORM, IFFSIZE_UNKNOWN) == 0) &&
       (PushChunk(iffh, 0,       ID_DATA, IFFSIZE_UNKNOWN) == 0) &&
       (WriteChunkBytes(iffh, &idc, sizeof(struct IconDATAChunk))
         == sizeof(struct IconDATAChunk)) &&
       (PopChunk(iffh) == 0) &&
       (ConvertConfigString(name, iffh, ID_NAME) != NULL) &&
       (PopChunk(iffh) == 0)  ;
 }

 ICON_LOG(LOG1(Result, "%ld", rc))

 return(rc);
}
