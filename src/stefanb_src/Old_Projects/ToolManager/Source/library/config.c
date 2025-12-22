/*
 * config.c  V2.1
 *
 * config file handling
 *
 * (c) 1990-1993 Stefan Becker
 */

#include "ToolManagerLib.h"

/* Config data structure */
struct ConfigBufNode {
                      struct MinNode cbn_Node;
                      ULONG          cbn_Size;
                     };

typedef BOOL (*ReadConfigFuncPtr)(struct ConfigBufNode *);

/* Private data */
static struct List ConfigBufList;
static BOOL clistinit=FALSE;
static ULONG stopchunks[]={ID_PREF,ID_TMEX,
                           ID_PREF,ID_TMIM,
                           ID_PREF,ID_TMSO,
                           ID_PREF,ID_TMMO,
                           ID_PREF,ID_TMIC,
                           ID_PREF,ID_TMDO,
                           ID_PREF,ID_TMAC};

/* Get one config string and correct pointer */
static char *GetConfigStr(UBYTE **buf)
{
 char *s=*buf;
 ULONG len=strlen(s)+1;

 /* Correct pointer */
 *buf+=len;

 /* Return pointer to config string */
 return(s);
}

static struct TagItem ExecPrefsTags[]={
                                       TMOP_Command,    NULL,
                                       TMOP_CurrentDir, NULL,
                                       TMOP_HotKey,     NULL,
                                       TMOP_Output,     NULL,
                                       TMOP_Path,       NULL,
                                       TMOP_PubScreen,  NULL,

                                       TMOP_Arguments,  FALSE,
                                       TMOP_ToFront,    FALSE,

                                       TMOP_Delay,      0,
                                       TMOP_ExecType,   0,
                                       TMOP_Priority,   0,
                                       TMOP_Stack,      0,

                                       TAG_DONE
                                      };

/* Interpret TMEX chunk */
static BOOL ReadExecConfig(struct ConfigBufNode *cbn)
{
 struct ExecPrefsObject *epo=(struct ExecPrefsObject *) &cbn[1];
 ULONG sbits=epo->epo_StringBits;
 UBYTE *ptr=(UBYTE *) &epo[1];
 char *name;

 /* Get name string */
 name=(sbits & EXPO_NAME) ? GetConfigStr(&ptr) : DefaultNoName;

 /* Set string tags */
 ExecPrefsTags[ 0].ti_Data=(ULONG) ((sbits & EXPO_COMMAND) ?
                                     GetConfigStr(&ptr) : NULL);
 ExecPrefsTags[ 1].ti_Data=(ULONG) ((sbits & EXPO_CURDIR) ?
                                     GetConfigStr(&ptr) : NULL);
 ExecPrefsTags[ 2].ti_Data=(ULONG) ((sbits & EXPO_HOTKEY) ?
                                     GetConfigStr(&ptr) : NULL);
 ExecPrefsTags[ 3].ti_Data=(ULONG) ((sbits & EXPO_OUTPUT) ?
                                     GetConfigStr(&ptr) : NULL);
 ExecPrefsTags[ 4].ti_Data=(ULONG) ((sbits & EXPO_PATH) ?
                                     GetConfigStr(&ptr) : NULL);
 ExecPrefsTags[ 5].ti_Data=(ULONG) ((sbits & EXPO_PSCREEN) ?
                                     GetConfigStr(&ptr) : NULL);

 /* Set boolean tags */
 ExecPrefsTags[ 6].ti_Data=(epo->epo_Flags & EXPOF_ARGS)    != 0;
 ExecPrefsTags[ 7].ti_Data=(epo->epo_Flags & EXPOF_TOFRONT) != 0;

 /* Set integer tags */
 ExecPrefsTags[ 8].ti_Data=epo->epo_Delay;
 ExecPrefsTags[ 9].ti_Data=epo->epo_ExecType;
 ExecPrefsTags[10].ti_Data=epo->epo_Priority;
 ExecPrefsTags[11].ti_Data=epo->epo_Stack;

 /* Create object */
 return(InternalCreateTMObject(PrivateTMHandle,name,TMOBJTYPE_EXEC,
                               ExecPrefsTags));
}

static struct TagItem ImagePrefsTags[]={
                                        TMOP_File, NULL,

                                        TAG_DONE
                                       };

/* Interpret TMIM chunk */
static BOOL ReadImageConfig(struct ConfigBufNode *cbn)
{
 struct ImagePrefsObject *ipo=(struct ImagePrefsObject *) &cbn[1];
 ULONG sbits=ipo->ipo_StringBits;
 UBYTE *ptr=(UBYTE *) &ipo[1];
 char *name;

 /* Get name string */
 name=(sbits & IMPO_NAME) ? GetConfigStr(&ptr) : DefaultNoName;

 /* Set string tags */
 ImagePrefsTags[ 0].ti_Data=(ULONG) ((sbits & IMPO_FILE) ?
                                      GetConfigStr(&ptr) : NULL);

 /* Create object */
 return(InternalCreateTMObject(PrivateTMHandle,name,TMOBJTYPE_IMAGE,
                               ImagePrefsTags));
}

static struct TagItem SoundPrefsTags[]={
                                        TMOP_Command, NULL,
                                        TMOP_Port,    NULL,

                                        TAG_DONE
                                       };

/* Interpret TMSO chunk */
static BOOL ReadSoundConfig(struct ConfigBufNode *cbn)
{
 struct SoundPrefsObject *spo=(struct SoundPrefsObject *) &cbn[1];
 ULONG sbits=spo->spo_StringBits;
 UBYTE *ptr=(UBYTE *) &spo[1];
 char *name;

 /* Get name string */
 name=(sbits & SOPO_NAME) ? GetConfigStr(&ptr) : DefaultNoName;

 /* Set string tags */
 SoundPrefsTags[ 0].ti_Data=(ULONG) ((sbits & SOPO_COMMAND) ?
                                      GetConfigStr(&ptr) : NULL);
 SoundPrefsTags[ 1].ti_Data=(ULONG) ((sbits & SOPO_PORT) ?
                                      GetConfigStr(&ptr) : NULL);

 /* Create object */
 return(InternalCreateTMObject(PrivateTMHandle,name,TMOBJTYPE_SOUND,
                               SoundPrefsTags));
}

static struct TagItem MenuPrefsTags[]={
                                       TMOP_Exec,  NULL,
                                       TMOP_Sound, NULL,

                                       TAG_DONE
                                      };

/* Interpret TMMO chunk */
static BOOL ReadMenuConfig(struct ConfigBufNode *cbn)
{
 struct MenuPrefsObject *mpo=(struct MenuPrefsObject *) &cbn[1];
 ULONG sbits=mpo->mpo_StringBits;
 UBYTE *ptr=(UBYTE *) &mpo[1];
 char *name;

 /* Get name string */
 name=(sbits & MOPO_NAME) ? GetConfigStr(&ptr) : DefaultNoName;

 /* Set string tags */
 MenuPrefsTags[ 0].ti_Data=(ULONG) ((sbits & MOPO_EXEC) ?
                                     GetConfigStr(&ptr) : NULL);
 MenuPrefsTags[ 1].ti_Data=(ULONG) ((sbits & MOPO_SOUND) ?
                                     GetConfigStr(&ptr) : NULL);

 /* Create object */
 return(InternalCreateTMObject(PrivateTMHandle,name,TMOBJTYPE_MENU,
                               MenuPrefsTags));
}

static struct TagItem IconPrefsTags[]={
                                       TMOP_Exec,     NULL,
                                       TMOP_Image,    NULL,
                                       TMOP_Sound,    NULL,

                                       TMOP_ShowName, FALSE,

                                       TMOP_LeftEdge, 0,
                                       TMOP_TopEdge,  0,

                                       TAG_DONE
                                      };

/* Interpret TMIC chunk */
static BOOL ReadIconConfig(struct ConfigBufNode *cbn)
{
 struct IconPrefsObject *ipo=(struct IconPrefsObject *) &cbn[1];
 ULONG sbits=ipo->ipo_StringBits;
 UBYTE *ptr=(UBYTE *) &ipo[1];
 char *name;

 /* Get name string */
 name=(sbits & ICPO_NAME) ? GetConfigStr(&ptr) : DefaultNoName;

 /* Set string tags */
 IconPrefsTags[ 0].ti_Data=(ULONG) ((sbits & ICPO_EXEC) ?
                                     GetConfigStr(&ptr) : NULL);
 IconPrefsTags[ 1].ti_Data=(ULONG) ((sbits & ICPO_IMAGE) ?
                                     GetConfigStr(&ptr) : NULL);
 IconPrefsTags[ 2].ti_Data=(ULONG) ((sbits & ICPO_SOUND) ?
                                     GetConfigStr(&ptr) : NULL);

 /* Set boolean tags */
 IconPrefsTags[ 3].ti_Data=(ipo->ipo_Flags & ICPOF_SHOWNAME) != 0;

 /* Set integer tags */
 IconPrefsTags[ 4].ti_Data=ipo->ipo_XPos;
 IconPrefsTags[ 5].ti_Data=ipo->ipo_YPos;

 /* Create object */
 return(InternalCreateTMObject(PrivateTMHandle,name,TMOBJTYPE_ICON,
                               IconPrefsTags));
}

static struct TagItem DockPrefsTags[]={
                                       TMOP_HotKey,    NULL,
                                       TMOP_PubScreen, NULL,
                                       TMOP_Title,     NULL,

                                       TMOP_Font,      NULL,

                                       TMOP_Activated, FALSE,
                                       TMOP_Backdrop,  FALSE,
                                       TMOP_Centered,  FALSE,
                                       TMOP_FrontMost, FALSE,
                                       TMOP_Menu,      FALSE,
                                       TMOP_Pattern,   FALSE,
                                       TMOP_PopUp,     FALSE,
                                       TMOP_Sticky,    FALSE,
                                       TMOP_Text,      FALSE,
                                       TMOP_Vertical,  FALSE,

                                       TMOP_Columns,   0,
                                       TMOP_LeftEdge,  0,
                                       TMOP_TopEdge,   0,

                                       TAG_MORE,       NULL
                                      };

struct ToolEntry {
                  char *te_Exec;
                  char *te_Image;
                  char *te_Sound;
                 };
#define MAXTOOLS    1000
#define TOOLBUFSIZE (MAXTOOLS*(sizeof(struct TagItem)+sizeof(struct ToolEntry)))

/* Interpret TMDO chunk */
static BOOL ReadDockConfig(struct ConfigBufNode *cbn)
{
 char *toolbuf;

 /* Allocate memory for tools tags & strings */
 if (toolbuf=AllocMem(TOOLBUFSIZE,MEMF_PUBLIC)) {
  struct TagItem *tt=(struct TagItem *) toolbuf;
  struct ToolEntry *te=(struct ToolEntry *)
                        ((struct TagItem *) toolbuf + MAXTOOLS);
  struct DockPrefsObject *dpo=(struct DockPrefsObject *) &cbn[1];
  ULONG sbits=dpo->dpo_StringBits;
  UBYTE *ptr=(UBYTE *) &dpo[1];
  char *name;
  BOOL rc;

  /* Get name string */
  name=(sbits & DOPO_NAME) ? GetConfigStr(&ptr) : DefaultNoName;

  /* Set string tags */
  DockPrefsTags[ 0].ti_Data=(ULONG) ((sbits & DOPO_HOTKEY) ?
                                      GetConfigStr(&ptr) : NULL);
  DockPrefsTags[ 1].ti_Data=(ULONG) ((sbits & DOPO_PSCREEN) ?
                                      GetConfigStr(&ptr) : NULL);
  DockPrefsTags[ 2].ti_Data=(ULONG) ((sbits & DOPO_TITLE) ?
                                      GetConfigStr(&ptr) : NULL);

  /* Get font */
  DockPrefsTags[ 3].ti_Data=
   (ULONG) ((dpo->dpo_Font.ta_Name=(sbits & DOPO_FONTNAME) ?
                                    GetConfigStr(&ptr) : NULL) ?
            &dpo->dpo_Font : NULL);

  /* Set boolean tags */
  DockPrefsTags[ 4].ti_Data=(dpo->dpo_Flags & DOPOF_ACTIVATED) != 0;
  DockPrefsTags[ 5].ti_Data=(dpo->dpo_Flags & DOPOF_BACKDROP)  != 0;
  DockPrefsTags[ 6].ti_Data=(dpo->dpo_Flags & DOPOF_CENTERED)  != 0;
  DockPrefsTags[ 7].ti_Data=(dpo->dpo_Flags & DOPOF_FRONTMOST) != 0;
  DockPrefsTags[ 8].ti_Data=(dpo->dpo_Flags & DOPOF_MENU)      != 0;
  DockPrefsTags[ 9].ti_Data=(dpo->dpo_Flags & DOPOF_PATTERN)   != 0;
  DockPrefsTags[10].ti_Data=(dpo->dpo_Flags & DOPOF_POPUP)     != 0;
  DockPrefsTags[11].ti_Data=(dpo->dpo_Flags & DOPOF_STICKY)    != 0;
  DockPrefsTags[12].ti_Data=(dpo->dpo_Flags & DOPOF_TEXT)      != 0;
  DockPrefsTags[13].ti_Data=(dpo->dpo_Flags & DOPOF_VERTICAL)  != 0;

  /* Set integer tags */
  DockPrefsTags[14].ti_Data=dpo->dpo_Columns;
  DockPrefsTags[15].ti_Data=dpo->dpo_XPos;
  DockPrefsTags[16].ti_Data=dpo->dpo_YPos;

  /* Read tool entries */
  {
   UBYTE tlflags;

   /* Get next tool entry */
   while ((tlflags=*ptr++) & DOPOT_CONTINUE) {
    /* Append tag */
    tt->ti_Tag =TMOP_Tool;
    tt->ti_Data=(ULONG) te;
    tt++;

    /* Set tool entry strings */
    te->te_Exec =(tlflags & DOPOT_EXEC)  ? GetConfigStr(&ptr) : NULL;
    te->te_Image=(tlflags & DOPOT_IMAGE) ? GetConfigStr(&ptr) : NULL;
    te->te_Sound=(tlflags & DOPOT_SOUND) ? GetConfigStr(&ptr) : NULL;
    te++;
   }
  }

  /* Terminate tool tag array and chain both tag arrays */
  tt->ti_Tag=TAG_DONE;
  DockPrefsTags[17].ti_Data=(ULONG) toolbuf;

  /* Create object */
  rc=InternalCreateTMObject(PrivateTMHandle,name,TMOBJTYPE_DOCK,DockPrefsTags);

  /* Free buffer */
  FreeMem(toolbuf,TOOLBUFSIZE);
  return(rc);
 }
 /* Call failed */
 return(FALSE);
}

static struct TagItem AccessPrefsTags[]={
                                         TAG_MORE, NULL
                                        };

#define MAXENTRIES 1000
#define ENTRYBUFSIZE (MAXENTRIES*sizeof(struct TagItem))

/* Interpret TMAC chunk */
static BOOL ReadAccessConfig(struct ConfigBufNode *cbn)
{
 char *entrybuf;

 /* Allocate memory for entry tags */
 if (entrybuf=AllocMem(ENTRYBUFSIZE,MEMF_PUBLIC)) {
  struct TagItem *et=(struct TagItem *) entrybuf;
  struct AccessPrefsObject *apo=(struct AccessPrefsObject *) &cbn[1];
  ULONG sbits=apo->apo_StringBits;
  UBYTE *ptr=(UBYTE *) &apo[1];
  char *name;
  BOOL rc;

  /* Get name string */
  name=(sbits & AOPO_NAME) ? GetConfigStr(&ptr) : DefaultNoName;

  /* Read access entries */
  {
   UBYTE aeflags;

   /* Get next tool entry */
   while ((aeflags=*ptr++) & AOPOE_CONTINUE) {
    /* Append tag */
    et->ti_Tag =TMOP_Exec;

    /* Get Exec name */
    et->ti_Data=(ULONG) ((aeflags & AOPOE_EXEC) ? GetConfigStr(&ptr) : NULL);

    /* Next tag */
    et++;
   }
  }

  /* Terminate tool tag array and chain both tag arrays */
  et->ti_Tag=TAG_DONE;
  AccessPrefsTags[0].ti_Data=(ULONG) entrybuf;

  /* Create object */
  rc=InternalCreateTMObject(PrivateTMHandle,name,TMOBJTYPE_ACCESS,
                            AccessPrefsTags);

  /* Free buffer */
  FreeMem(entrybuf,ENTRYBUFSIZE);
  return(rc);
 }
 /* Call failed */
 return(FALSE);
}

static ReadConfigFuncPtr ReadConfigFunctions[TMOBJTYPES]={
                                                          ReadExecConfig,
                                                          ReadImageConfig,
                                                          ReadSoundConfig,
                                                          ReadMenuConfig,
                                                          ReadIconConfig,
                                                          ReadDockConfig,
                                                          ReadAccessConfig
                                                         };

/* Read config file */
void ReadConfig(void)
{
 /* Open IFF parsing library */
 if (IFFParseBase=OpenLibrary("iffparse.library",0)) {
  struct IFFHandle *iff;

  DEBUG_PRINTF("IFF Library opened.\n");

  /* Alloc IFF handle */
  if (iff=AllocIFF()) {

   DEBUG_PRINTF("IFF Handle (0x%08lx)\n",iff);

   /* Open IFF file */
   if (iff->iff_Stream=Open(PrefsFileName,MODE_OLDFILE)) {
    /* Init IFF handle */
    InitIFFasDOS(iff);

    DEBUG_PRINTF("IFF Stream (0x%08lx)\n",iff->iff_Stream);

    /* Open IFF handle */
    if (!OpenIFF(iff,IFFF_READ)) {

     DEBUG_PRINTF("IFF Opened\n");

     /* Start IFF parsing */
     if (!ParseIFF(iff,IFFPARSE_STEP)) {
      struct ContextNode *cn;

      DEBUG_PRINTF("First IFF scan step\n");

      /* Init config list */
      NewList(&ConfigBufList);
      clistinit=TRUE;

      /* Check IFF type and set IFF chunk types */
      if ((cn=CurrentChunk(iff)) && (cn->cn_ID==ID_FORM) &&
          (cn->cn_Type==ID_PREF) &&
          !PropChunk(iff,ID_PREF,ID_PRHD) &&
          !StopChunks(iff,stopchunks,TMOBJTYPES) &&
          !StopOnExit(iff,ID_PREF,ID_FORM) &&
          !ParseIFF(iff,IFFPARSE_SCAN)) {
       /* First stop chunk encountered */
       struct StoredProperty *sp;

       /* Get pointer to PRHD chunk */
       if (sp=FindProp(iff,ID_PREF,ID_PRHD)) {
        struct PrefHeader *ph=(struct PrefHeader *) sp->sp_Data;

        /* Check file version number */
        if (ph->ph_Version==TMPREFSVERSION) {

         /* Parse IFF chunks */
         do {
          /* Get current chunk */
          if (cn=CurrentChunk(iff)) {
           LONG type;

           DEBUG_PRINTF("chunk ID: 0x%08lx",cn->cn_ID);
           DEBUG_PRINTF(" size: 0x%08lx",cn->cn_Size);

           /* Read IFF chunk according to chunk ID */
           switch(cn->cn_ID) {
            case ID_TMEX: type=TMOBJTYPE_EXEC;
                          break;
            case ID_TMIM: type=TMOBJTYPE_IMAGE;
                          break;
            case ID_TMSO: type=TMOBJTYPE_SOUND;
                          break;
            case ID_TMMO: type=TMOBJTYPE_MENU;
                          break;
            case ID_TMIC: type=TMOBJTYPE_ICON;
                          break;
            case ID_TMDO: type=TMOBJTYPE_DOCK;
                          break;
            case ID_TMAC: type=TMOBJTYPE_ACCESS;
                          break;
            default:      type=-1;
                          break;
           }

           DEBUG_PRINTF(" type: %ld\n",type);

           /* valid type? */
           if (type!=-1) {
            ULONG sizechunk=cn->cn_Size;
            ULONG sizebuf=sizechunk+sizeof(struct ConfigBufNode);
            struct ConfigBufNode *cbn;

            /* Allocate memory for config buffer */
            if (cbn=AllocMem(sizebuf,MEMF_PUBLIC)) {
             /* Read chunk, interpret contents & create object */
             if ((ReadChunkBytes(iff,cbn+1,sizechunk)==sizechunk) &&
                 (*ReadConfigFunctions[type])(cbn)) {
              /* Set size */
              cbn->cbn_Size=sizebuf;

              /* Add node */
              AddTail(&ConfigBufList,(struct Node *) cbn);
              cbn=NULL;
             }

             /* Error: free buffer */
             if (cbn) FreeMem(cbn,sizebuf);
            }

            DEBUG_PRINTF("cbn: 0x%08lx\n",cbn);
/*            DEBUG_GETCHR(); */
           }
          }
         /* Next parse step */
         } while (!ParseIFF(iff,IFFPARSE_SCAN));
        }
       }
      }
     }
     CloseIFF(iff);
    }
    Close(iff->iff_Stream);
   }
   FreeIFF(iff);
  }
  CloseLibrary(IFFParseBase);
 }
}

/* Free config buffers */
void FreeConfig(void)
{
 struct ConfigBufNode *cbn;

 /* List valid? */
 if (clistinit) {
  /* Scan list, remove head entry */
  while (cbn=(struct ConfigBufNode *) RemHead(&ConfigBufList))
   /* Free entry */
   FreeMem(cbn,cbn->cbn_Size);

  clistinit=FALSE;
 }
}
