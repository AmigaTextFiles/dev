/*
 * exec.c  V3.1
 *
 * ToolManager old preferences converter for Exec Objects
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
static struct MinList       IDList;
static struct ExecDATAChunk edc;

/* Old Prefs stuff */
struct ExecPrefsObject {
                        ULONG epo_StringBits;
                        ULONG epo_Flags;
                        ULONG epo_Delay;
                        ULONG epo_Stack;
                        UWORD epo_ExecType;
                        WORD  epo_Priority;
                       };
#define EXPO_NAME     (1L << 0)
#define EXPO_COMMAND  (1L << 1)
#define EXPO_CURDIR   (1L << 2)
#define EXPO_HOTKEY   (1L << 3)
#define EXPO_OUTPUT   (1L << 4)
#define EXPO_PATH     (1L << 5)
#define EXPO_PSCREEN  (1L << 6)
#define EXPOF_ARGS    (1L << 0)
#define EXPOF_TOFRONT (1L << 1)

/* Initialize Exec ID list */
void InitExecIDList(void)
{
 NewList((struct List *) &IDList);
}

/* Free Exec ID list */
void FreeExecIDList(void)
{
 FreeIDList(&IDList);
}

/* Find ID to corresponding Exec name */
ULONG FindExecID(const char *name)
{
 return(FindIDInList(&IDList, name));
}

/* Conversion routine */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ConvertExecConfig
BOOL ConvertExecConfig(void *chunk, struct IFFHandle *iffh, ULONG id)
{
 struct ExecPrefsObject *epo = chunk;
 char                   *s   = (char *) (epo + 1);
 BOOL                    rc  = FALSE;

 EXEC_LOG(LOG3(Entry, "Chunk 0x%08lx IFF Handle 0x%08lx ID 0x%08lx",
               chunk, iffh, id))

 /* Get name to create ID list entry */
 if ((epo->epo_StringBits & EXPO_NAME) && AddIDToList(&IDList, s, id)) {

  /* Copy fixed data */
  edc.edc_Standard.sdc_ID    = id;
  edc.edc_Standard.sdc_Flags = 0;
  edc.edc_ExecType           = epo->epo_ExecType;
  edc.edc_Priority           = epo->epo_Priority;
  edc.edc_Stack              = epo->epo_Stack;

  /* Copy flags */
  if (epo->epo_Flags & EXPOF_ARGS)    edc.edc_Standard.sdc_Flags
                                        = DATA_EXECF_ARGUMENTS;
  if (epo->epo_Flags & EXPOF_TOFRONT) edc.edc_Standard.sdc_Flags
                                       |= DATA_EXECF_TOFRONT;

  /* Create new config entry */
  rc = (PushChunk(iffh, ID_TMEX, ID_FORM, IFFSIZE_UNKNOWN) == 0) &&
       (PushChunk(iffh, 0,       ID_DATA, IFFSIZE_UNKNOWN) == 0) &&
       (WriteChunkBytes(iffh, &edc, sizeof(struct ExecDATAChunk))
         == sizeof(struct ExecDATAChunk)) &&
       (PopChunk(iffh) == 0) &&
       (((epo->epo_StringBits & EXPO_NAME)    == 0) ||
        (s = ConvertConfigString(s, iffh, ID_NAME))) &&
       (((epo->epo_StringBits & EXPO_COMMAND) == 0) ||
        (s = ConvertConfigString(s, iffh, ID_CMND))) &&
       (((epo->epo_StringBits & EXPO_CURDIR)  == 0) ||
        (s = ConvertConfigString(s, iffh, ID_CDIR))) &&
       (((epo->epo_StringBits & EXPO_HOTKEY)  == 0) ||
        (s = ConvertConfigString(s, iffh, ID_HKEY))) &&
       (((epo->epo_StringBits & EXPO_OUTPUT)  == 0) ||
        (s = ConvertConfigString(s, iffh, ID_OUTP))) &&
       (((epo->epo_StringBits & EXPO_PATH)    == 0) ||
        (s = ConvertConfigString(s, iffh, ID_PATH))) &&
       (((epo->epo_StringBits & EXPO_PSCREEN) == 0) ||
        (s = ConvertConfigString(s, iffh, ID_PSCR))) &&
       (PopChunk(iffh) == 0)  ;
 }

 EXEC_LOG(LOG1(Result, "%ld", rc))

 return(rc);
}
