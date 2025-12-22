/*
 * config.c  V3.1
 *
 * ToolManager configuration file handling routines
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

/* Global data */
struct Library *IFFParseBase                  = NULL;

/* Local data */
static const char            ConfigFileName[] = "ENV:" TMCONFIGNAME;
static struct IFFHandle     *ConfigIFFHandle  = NULL;
static ULONG                 ConfigOpen       = FALSE;
static ULONG                 CurrentType;
static struct NotifyRequest  ConfigNotify     = {ConfigFileName, NULL, 0,
 NRF_SEND_SIGNAL | NRF_NOTIFY_INITIAL, NULL};

/* Start configuration file change notification */
#define DEBUGFUNCTION StartConfigChangeNotify
LONG StartConfigChangeNotify(void)
{
 LONG signal;

 CONFIG_LOG(LOG0(Entry))

 /* Allocate Signal for file notification */
 if ((signal = AllocSignal(-1)) != -1) {

  CONFIG_LOG(LOG1(Signal,"%ld", signal))

  /* Initialize notify request */
  ConfigNotify.nr_stuff.nr_Signal.nr_Task      = FindTask(NULL);
  ConfigNotify.nr_stuff.nr_Signal.nr_SignalNum = signal;

  /* Start notification */
  if (StartNotify(&ConfigNotify) == FALSE) {

   CONFIG_LOG(LOG0(Failed))

   /* Notification failed */
   FreeSignal(signal);
   signal = -1;
  }
#ifdef DEBUG
  else CONFIG_LOG(LOG0(Started))
#endif
 }

 return(signal);
}

/* Stop configuration file parsing */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION StopConfigParse
static void StopConfigParse(void)
{
 CONFIG_LOG(LOG0(Entry))

 /* IFF parser library open? */
 if (IFFParseBase) {

  CONFIG_LOG(LOG1(Library, "0x%08lx", IFFParseBase))

  /* Handle allocated? */
  if (ConfigIFFHandle) {

   CONFIG_LOG(LOG1(IFFHandle, "0x%08lx", ConfigIFFHandle))

   /* Configuration file open? */
   if (ConfigIFFHandle->iff_Stream) {

    CONFIG_LOG(LOG1(File, "0x%08lx", ConfigIFFHandle->iff_Stream))

    /* IFF handle open? */
    if (ConfigOpen) {

     CONFIG_LOG(LOG0(Config open))

     /* Close IFF handle */
     CloseIFF(ConfigIFFHandle);
     ConfigOpen = FALSE;
    }

    /* Close file */
    Close(ConfigIFFHandle->iff_Stream);
   }

   /* Free IFF handle */
   FreeIFF(ConfigIFFHandle);
   ConfigIFFHandle = NULL;
  }

  /* Close library */
  CloseLibrary(IFFParseBase);
  IFFParseBase = NULL;
 }
}

/* Stop configuration file change notification */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION StopConfigChangeNotify
void StopConfigChangeNotify(void)
{
 CONFIG_LOG(LOG0(Entry))

 /* Stop configuration file parsing */
 StopConfigParse();

 /* Stop notification */
 EndNotify(&ConfigNotify);
 FreeSignal(ConfigNotify.nr_stuff.nr_Signal.nr_SignalNum);

 CONFIG_LOG(LOG0(Exit))
}

/* Handle configuration file changes */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION HandleConfigChange
BOOL HandleConfigChange(void)
{
 BOOL rc = FALSE;

 /*
  * NOTE: Notification happens only when the changed file has been closed.
  *       But the file can't be changed while we are still reading it. Thus
  *       this function can ONLY be called when we are not currently reading
  *       in the configuration file.
  */

 CONFIG_LOG(LOG0(Configuration has changed))

 /* Open IFF parser library */
 if (IFFParseBase = OpenLibrary("iffparse.library", 39)) {

  CONFIG_LOG(LOG1(IFFParse open, "0x%08lx", IFFParseBase))

  /* Allocate IFF handle */
  if (ConfigIFFHandle = AllocIFF()) {

   CONFIG_LOG(LOG1(IFFHandle, "0x%08lx", ConfigIFFHandle))

   /* Open configuration file */
   if (ConfigIFFHandle->iff_Stream = Open(ConfigFileName, MODE_OLDFILE)) {

    CONFIG_LOG(LOG1(File, "0x%08lx", ConfigIFFHandle->iff_Stream))

    /* Initialize IFF handle */
    InitIFFasDOS(ConfigIFFHandle);

    /* Open IFF handle */
    if (OpenIFF(ConfigIFFHandle, IFFF_READ) == 0) {

     CONFIG_LOG(LOG0(Handle open))

     /* Set open flag */
     ConfigOpen = TRUE;

     /* Start IFF parsing */
     if (ParseIFF(ConfigIFFHandle, IFFPARSE_STEP) == 0) {
      struct ContextNode *cn;

      CONFIG_LOG(LOG0(First parse step))

      /* a) Check IFF type: FORM TMPR */
      /* b) Step to version chunk     */
      if ((cn = CurrentChunk(ConfigIFFHandle)) &&
          (cn->cn_ID == ID_FORM) && (cn->cn_Type == ID_TMPR) &&
          (ParseIFF(ConfigIFFHandle, IFFPARSE_STEP) == 0) &&
          (cn = CurrentChunk(ConfigIFFHandle)) &&
          (cn->cn_ID == ID_FVER) && (cn->cn_Size == sizeof(TMCONFIGVERSION))) {
       char *buf;

       CONFIG_LOG(LOG0(Version chunk found))

       /* Allocate memory for version chunk */
       if (buf = GetMemory(sizeof(TMCONFIGVERSION))) {

        /* Read version chunk and check version */
        if ((ReadChunkBytes(ConfigIFFHandle, buf, sizeof(TMCONFIGVERSION))
              == sizeof(TMCONFIGVERSION)) &&
            (strcmp(buf, TMCONFIGVERSION) == 0) &&
            (ParseIFF(ConfigIFFHandle, IFFPARSE_STEP) == IFFERR_EOC)) {

         CONFIG_LOG(LOG0(Configuration file OK))

         /* Next FORM must be global parameters */
         CurrentType = ID_TMGP;

         /* Configuration file passed the tests */
         rc = TRUE;
        }

        /* Free version chunk */
        FreeMemory(buf, sizeof(TMCONFIGVERSION));
       }
      }
     }
    }
   }
  }

  /* Error while opening configuration file? */
  if (rc == FALSE) StopConfigParse();
 }

 CONFIG_LOG(LOG1(Result, "%ld", rc))

 return(rc);
}

/* Skip an unkown chunk */
#ifdef DEBUG
#define SkipUnknownChunk(type, cn) _SkipUnknownChunk(type, cn)
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION SkipUnknownChunk
static BOOL _SkipUnknownChunk(ULONG type, struct ContextNode *cn)
{
 BOOL rc = TRUE;

 switch (type) {
  case 0:
   CONFIG_LOG(LOG3(Unknown Chunk, "ID 0x%08lx Type 0x%08lx Size %ld",
                   cn->cn_ID, cn->cn_Type, cn->cn_Size))
   break;

  case 1:
   CONFIG_LOG(LOG2(Ignoring PROP, "Type 0x%08lx Size %ld",
                   cn->cn_Type, cn->cn_Size))
   break;

  case 2:
   CONFIG_LOG(LOG2(Unexpected FORM, "Type 0x%08lx Size %ld",
                   cn->cn_Type, cn->cn_Size))
   break;

  case 3:
   CONFIG_LOG(LOG2(Unknown FORM, "Type 0x%08lx Size %ld",
                   cn->cn_Type, cn->cn_Size))
   break;
 }

#else
#define SkipUnknownChunk(type, cn) _SkipUnknownChunk(cn)
static BOOL _SkipUnknownChunk(struct ContextNode *cn)
{
 BOOL rc = TRUE;
#endif

 /* Skip chunk */
 if ((StopOnExit(ConfigIFFHandle, cn->cn_Type, cn->cn_ID) != 0) ||
     (ParseIFF(ConfigIFFHandle, IFFPARSE_SCAN) != IFFERR_EOC)) {

  CONFIG_LOG(LOG0(Cannot skip unknown chunk))

  rc = FALSE;
 }

 return(rc);
}

/* Create an ToolManager object from an IFF FORM chunk */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION CreateObjectFromFORM
static BOOL CreateObjectFromFORM(struct TMHandle *tmh, ULONG type)
{
 Object *obj;
 BOOL    rc  = FALSE;

 /* Create ToolManager object */
 if (obj = CreateToolManagerObject(tmh, type)) {

  CONFIG_LOG(LOG1(Object, "0x%08lx", obj))

  /* Let the object parse the FORM chunk */
  if (DoMethod(obj, TMM_ParseIFF, ConfigIFFHandle) == FALSE) {

   CONFIG_LOG(LOG0(IFF Parse failed))

   /* Delete object */
   DisposeObject(obj);
  }

  /* All OK (ignore that object parsing might fail) */
  rc = TRUE;
 }

 return(rc);
}

/* Parse next configuration element */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION NextConfigParseStep
BOOL NextConfigParseStep(struct TMHandle *tmh)
{
 BOOL rc = TRUE;

 /* Next parse step */
 switch (ParseIFF(ConfigIFFHandle, IFFPARSE_STEP)) {

  case 0: {
    struct ContextNode *cn;

    if (cn = CurrentChunk(ConfigIFFHandle))

     /* Which chunk type? */
     switch (cn->cn_ID) {
      case ID_LIST:

       CONFIG_LOG(LOG2(Enter LIST, "Type 0x%08lx Size %ld",
                       cn->cn_Type, cn->cn_Size))

       /* Store the type */
       CurrentType = cn->cn_Type;
       break;

      case ID_PROP:
       /* Ignore PROP chunks */
       rc = SkipUnknownChunk(1, cn);
       break;

      case ID_FORM:

       CONFIG_LOG(LOG2(Enter FORM, "Type 0x%08lx Size %ld",
                       cn->cn_Type, cn->cn_Size))

       /* Is the type correct? */
       if (cn->cn_Type == CurrentType) {

        /* Yes, which FORM type? */
        switch (cn->cn_Type) {
         case ID_TMGP:
          rc = ParseGlobalIFF(ConfigIFFHandle);
          break;

         case ID_TMEX:
          rc = CreateObjectFromFORM(tmh, TMOBJTYPE_EXEC);
          break;

         case ID_TMIM:
          rc = CreateObjectFromFORM(tmh, TMOBJTYPE_IMAGE);
          break;

         case ID_TMSO:
          rc = CreateObjectFromFORM(tmh, TMOBJTYPE_SOUND);
          break;

         case ID_TMMO:
          rc = CreateObjectFromFORM(tmh, TMOBJTYPE_MENU);
          break;

         case ID_TMIC:
          rc = CreateObjectFromFORM(tmh, TMOBJTYPE_ICON);
          break;

         case ID_TMDO:
          rc = CreateObjectFromFORM(tmh, TMOBJTYPE_DOCK);
          break;

         case ID_TMAC:
          rc = CreateObjectFromFORM(tmh, TMOBJTYPE_ACCESS);
          break;

         default:
          /* Expected, but unknown FORM type */
          rc = SkipUnknownChunk(3, cn);
          break;
        }

       } else
        /* Unexpected FORM type */
        rc = SkipUnknownChunk(2, cn);
       break;

      default:
       /* No LIST/PROP/FORM */
       rc = SkipUnknownChunk(0, cn);
       break;
     }

    else {
     CONFIG_LOG(LOG0(No current chunk?!?))

     rc = FALSE;
    }
   }
   break;

  case IFFERR_EOC:
#ifdef DEBUG
   {
    struct ContextNode *cn;

    if (cn = CurrentChunk(ConfigIFFHandle))

     switch(cn->cn_ID) {
      case ID_LIST:
       CONFIG_LOG(LOG2(Leave LIST, "Type 0x%08lx Size %ld",
                       cn->cn_Type, cn->cn_Size))
       break;

      case ID_FORM:
       CONFIG_LOG(LOG2(Leave FORM, "Type 0x%08lx Size %ld",
                       cn->cn_Type, cn->cn_Size))
       break;

      default:
       CONFIG_LOG(LOG3(Leave unknown context,
                       "ID 0x%08lx Type 0x%08lx Size %ld",
                       cn->cn_ID, cn->cn_Type, cn->cn_Size))
       break;
     }
   }
#endif
   break;

#ifdef DEBUG
  case IFFERR_EOF:
   CONFIG_LOG(LOG0(End of configuration reached))

   rc = FALSE;
   break;
#endif

  default:
    CONFIG_LOG(LOG0(Error in parsing))

    rc = FALSE;
    break;
 }

 /* Stop parsing? */
 if (rc == FALSE) StopConfigParse();

 CONFIG_LOG(LOG1(Result, "%ld", rc))

 return(rc);
}

#undef  DEBUGFUNCTION
#define DEBUGFUNCTION DuplicateProperty
void *DuplicateProperty(struct IFFHandle *iffh, ULONG type, ULONG id)
{
 void                  *rc = NULL;
 struct StoredProperty *sp;

 CONFIG_LOG(LOG3(Entry, "Handle 0x%08lx Type 0x%08lx ID 0x%08lx",
                 iffh, type, id))

 /* Find property */
 if (sp = FindProp(iffh, type, id)) {

  CONFIG_LOG(LOG2(Property, "Data 0x%08lx Size %ld", sp->sp_Data, sp->sp_Size))

  /* Allocate memory for property */
  if (rc = GetVector(sp->sp_Size))

   /* Copy property */
   CopyMem(sp->sp_Data, rc, sp->sp_Size);
 }

 CONFIG_LOG(LOG1(Result, "0x%08lx", rc))

 return(rc);
}
