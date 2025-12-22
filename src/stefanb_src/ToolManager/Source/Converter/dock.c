/*
 * dock.c  V3.1
 *
 * ToolManager old preferences converter for Dock Objects
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
static struct DockDATAChunk ddc;

/* Old Prefs stuff */
struct DockPrefsObject {
                        ULONG           dpo_StringBits;
                        ULONG           dpo_Flags;
                        LONG            dpo_XPos;
                        LONG            dpo_YPos;
                        ULONG           dpo_Columns;
                        struct TextAttr dpo_Font;
                       };
#define DOPO_NAME     (1L << 0)
#define DOPO_HOTKEY   (1L << 1)
#define DOPO_PSCREEN  (1L << 2)
#define DOPO_TITLE    (1L << 3)
#define DOPO_FONTNAME (1L << 4)
#define DOPOF_ACTIVATED (1L << 0)
#define DOPOF_CENTERED  (1L << 1)
#define DOPOF_FRONTMOST (1L << 2)
#define DOPOF_MENU      (1L << 3)
#define DOPOF_PATTERN   (1L << 4)
#define DOPOF_POPUP     (1L << 5)
#define DOPOF_TEXT      (1L << 6)
#define DOPOF_VERTICAL  (1L << 7)
#define DOPOF_BACKDROP  (1L << 8)
#define DOPOF_STICKY    (1L << 9)
#define DOPOT_EXEC     (1L << 0)
#define DOPOT_IMAGE    (1L << 1)
#define DOPOT_SOUND    (1L << 2)
#define DOPOT_CONTINUE (1L << 7)

/* Conversion routine */
#define DEBUGFUNCTION ConvertDockConfig
BOOL ConvertDockConfig(void *chunk, struct IFFHandle *iffh, ULONG id)
{
 struct DockPrefsObject *dpo = chunk;
 char                   *s   = (char *) (dpo + 1);
 BOOL                    rc  = FALSE;

 DOCK_LOG(LOG3(Entry, "Chunk 0x%08lx IFF Handle 0x%08lx ID 0x%08lx",
               chunk, iffh, id))

 /* Get name to create ID list entry */
 if (dpo->dpo_StringBits & DOPO_NAME) {
  char *name = s;

  /* Copy fixed data */
  ddc.ddc_Standard.sdc_ID    = id;
  ddc.ddc_Standard.sdc_Flags = 0;
  ddc.ddc_LeftEdge           = dpo->dpo_XPos;
  ddc.ddc_TopEdge            = dpo->dpo_YPos;
  ddc.ddc_Columns            = dpo->dpo_Columns;
  ddc.ddc_FontYSize          = dpo->dpo_Font.ta_YSize;
  ddc.ddc_FontStyle          = dpo->dpo_Font.ta_Style;
  ddc.ddc_FontFlags          = dpo->dpo_Font.ta_Flags;

  /* Copy flags */
  if (dpo->dpo_Flags & DOPOF_ACTIVATED) ddc.ddc_Standard.sdc_Flags
                                          = DATA_DOCKF_ACTIVATED;
  if (dpo->dpo_Flags & DOPOF_MENU)      ddc.ddc_Standard.sdc_Flags
                                         |= DATA_DOCKF_MENU;
  if (dpo->dpo_Flags & DOPOF_TEXT)      ddc.ddc_Standard.sdc_Flags
                                         |= DATA_DOCKF_TEXT;
  else
                                        ddc.ddc_Standard.sdc_Flags
                                         |= DATA_DOCKF_IMAGES;
  if (dpo->dpo_Flags & DOPOF_CENTERED)  ddc.ddc_Standard.sdc_Flags
                                         |= DATA_DOCKF_CENTERED;
  if (dpo->dpo_Flags & DOPOF_STICKY)    ddc.ddc_Standard.sdc_Flags
                                         |= DATA_DOCKF_STICKY;
  if (dpo->dpo_Flags & DOPOF_BACKDROP)  ddc.ddc_Standard.sdc_Flags
                                         |= DATA_DOCKF_BACKDROP;
  if (dpo->dpo_Flags & DOPOF_FRONTMOST) ddc.ddc_Standard.sdc_Flags
                                         |= DATA_DOCKF_FRONTMOST;
  if (dpo->dpo_Flags & DOPOF_POPUP)     ddc.ddc_Standard.sdc_Flags
                                         |= DATA_DOCKF_POPUP;

  /* Window title set? Yes, set border flag */
  if (dpo->dpo_StringBits & DOPO_TITLE) ddc.ddc_Standard.sdc_Flags
                                         |= DATA_DOCKF_BORDER;

  /* Create new config entry */
  rc = (PushChunk(iffh, ID_TMDO, ID_FORM, IFFSIZE_UNKNOWN) == 0) &&
       (PushChunk(iffh, 0,       ID_DATA, IFFSIZE_UNKNOWN) == 0) &&
       (WriteChunkBytes(iffh, &ddc, sizeof(struct DockDATAChunk))
         == sizeof(struct DockDATAChunk)) &&
       (PopChunk(iffh) == 0) &&
       (((dpo->dpo_StringBits & DOPO_NAME)     == 0) ||
        (s = ConvertConfigString(s, iffh, ID_NAME))) &&
       (((dpo->dpo_StringBits & DOPO_HOTKEY)   == 0) ||
        (s = ConvertConfigString(s, iffh, ID_HKEY))) &&
       (((dpo->dpo_StringBits & DOPO_PSCREEN)  == 0) ||
        (s = ConvertConfigString(s, iffh, ID_PSCR))) &&
       (((dpo->dpo_StringBits & DOPO_TITLE)    == 0) ||
        (s += strlen(s) + 1))                        && /* Ignore title */
       (((dpo->dpo_StringBits & DOPO_FONTNAME) == 0) ||
        (s = ConvertConfigString(s, iffh, ID_FONT)));

  /* All OK? */
  if (rc) {
   struct DockEntryChunk dec;
   UBYTE                 flags;

   /* Yes, convert dock entries. Get next tool entry */
   while (rc && ((flags = *s++) & DOPOT_CONTINUE)) {

    /* Convert Exec object */
    if (flags & DOPOT_EXEC) {
     dec.dec_ExecObject = FindExecID(s);
     s += strlen(s) + 1;
    } else
     dec.dec_ExecObject = 0;

    /* Convert Image object */
    if (flags & DOPOT_IMAGE) {
     dec.dec_ImageObject = FindImageID(s);
     s += strlen(s) + 1;
    } else
     dec.dec_ImageObject = 0;

    /* Convert Sound object */
    if (flags & DOPOT_SOUND) {
     dec.dec_SoundObject = FindSoundID(s);
     s += strlen(s) + 1;
    } else
     dec.dec_SoundObject = 0;

    /* Create dock entry chunk */
    rc = (PushChunk(iffh, 0, ID_ENTR, IFFSIZE_UNKNOWN) == 0) &&
         (WriteChunkBytes(iffh, &dec, sizeof(struct DockEntryChunk))
          == sizeof(struct DockEntryChunk)) &&
         (PopChunk(iffh) == 0);
   }

   /* All OK? Yes, pop config entry */
   if (rc) rc = (PopChunk(iffh) == 0);
  }
 }

 DOCK_LOG(LOG1(Result, "%ld", rc))

 return(rc);
}
