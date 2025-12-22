/*
 * config.c  V2.1
 *
 * preferences file handling
 *
 * (c) 1990-1993 Stefan Becker
 */

#include "ToolManagerConf.h"

/* misc. data */
#define BUFSIZE 65536
ULONG stopchunks[]={ID_PREF,ID_TMEX,
                    ID_PREF,ID_TMIM,
                    ID_PREF,ID_TMSO,
                    ID_PREF,ID_TMMO,
                    ID_PREF,ID_TMIC,
                    ID_PREF,ID_TMDO,
                    ID_PREF,ID_TMAC};
struct PrefHeader PrefHdrChunk={TMPREFSVERSION,0,0};

/* Function tables */
ReadNodeFuncPtr ReadNodeFunctions[TMOBJTYPES]={
                                               ReadExecNode,
                                               ReadImageNode,
                                               ReadSoundNode,
                                               ReadMenuNode,
                                               ReadIconNode,
                                               ReadDockNode,
                                               ReadAccessNode
                                              };

WriteNodeFuncPtr WriteNodeFunctions[TMOBJTYPES]={
                                                 WriteExecNode,
                                                 WriteImageNode,
                                                 WriteSoundNode,
                                                 WriteMenuNode,
                                                 WriteIconNode,
                                                 WriteDockNode,
                                                 WriteAccessNode
                                                };

/* Read config file */
BOOL ReadConfigFile(char *filename)
{
 UBYTE *configbuf;
 BOOL rc=FALSE;

 DEBUG_PRINTF("read config from '%s'\n",filename);

 /* Allocate memory for config buffer */
 if (configbuf=malloc(BUFSIZE)) {
  struct IFFHandle *iff;

  DEBUG_PRINTF("config buffer: 0x%08lx\n",configbuf)

  /* Allocate IFF handle */
  if (iff=AllocIFF()) {
   /* Every error will be ignored after this point! */
   rc=TRUE;

   DEBUG_PRINTF("IFF Handle: 0x%08lx\n",iff);

   /* Open IFF File */
   if (iff->iff_Stream=Open(filename,MODE_OLDFILE)) {
    /* Init IFF handle */
    InitIFFasDOS(iff);

    DEBUG_PRINTF("IFF Stream: 0x%08lx\n",iff->iff_Stream);

    /* Open IFF handle */
    if (!OpenIFF(iff,IFFF_READ)) {

     DEBUG_PRINTF("IFF open\n");

     /* Start IFF parsing */
     if (!ParseIFF(iff,IFFPARSE_STEP)) {
      struct ContextNode *cn;

      DEBUG_PRINTF("First IFF scan step\n");

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
            ULONG size=cn->cn_Size;

            /* Read chunk */
            if (ReadChunkBytes(iff,configbuf,size)==size) {
             struct Node *node;

             DEBUG_PRINTF("chunk read\n");

             /* Interpret chunk contents */
             if (node=(*ReadNodeFunctions[type])(configbuf)) {

              DEBUG_PRINTF("new node: 0x%08lx\n",node);

              /* Make sure ln_Name is valid */
              if (!node->ln_Name) node->ln_Name=strdup("");

              /* Append new node to list */
              AddTail(&ObjectLists[type],node);
             }
            }
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
  free(configbuf);
 }
 return(rc);
}

/* Write config file */
BOOL WriteConfigFile(char *filename)
{
 UBYTE *configbuf;
 BOOL rc=FALSE;

 DEBUG_PRINTF("write config to '%s'\n",filename);

 /* Allocate memory for config buffer */
 if (configbuf=malloc(BUFSIZE)) {
  struct IFFHandle *iff;

  DEBUG_PRINTF("config buffer: 0x%08lx\n",configbuf)

  /* Allocate IFF handle */
  if (iff=AllocIFF()) {

   DEBUG_PRINTF("IFF Handle: 0x%08lx\n",iff);

   /* Open IFF File */
   if (iff->iff_Stream=Open(filename,MODE_NEWFILE)) {
    /* Init IFF handle */
    InitIFFasDOS(iff);

    DEBUG_PRINTF("IFF Stream: 0x%08lx\n",iff->iff_Stream);

    /* Open IFF handle */
    if (!OpenIFF(iff,IFFF_WRITE)) {

     DEBUG_PRINTF("IFF open\n");

     /* Push FORM IFF chunk */
     if (!PushChunk(iff,ID_PREF,ID_FORM,IFFSIZE_UNKNOWN)) {

      /* Write PRHD IFF chunk */
      if (!PushChunk(iff,0,ID_PRHD,sizeof(struct PrefHeader)) &&
          (WriteChunkBytes(iff,(UBYTE *) &PrefHdrChunk,
                           sizeof(struct PrefHeader))
                            ==sizeof(struct PrefHeader)) &&
          !PopChunk(iff))
       /* Set return code */
       rc=TRUE;

      /* error? */
      if (rc) {
       ULONG i;

       /* No, scan all object lists */
       for (i=0; (i<TMOBJTYPES) && rc; i++) {
        struct Node *node=GetHead(&ObjectLists[i]);
        WriteNodeFuncPtr wnfp=WriteNodeFunctions[i];

        /* Scan list */
        while (node && rc) {
         /* Convert node into IFF chunk */
         rc=(*wnfp)(iff,configbuf,node);

         /* Get next node */
         node=GetSucc(node);
        }
       }
      }
     }
     CloseIFF(iff);
    }
    Close(iff->iff_Stream);

    /* Clear execution flag */
    SetProtection(filename,FIBF_EXECUTE);
   }
   FreeIFF(iff);
  }
  free(configbuf);
 }
 return(rc);
}

/* Read one config string and correct pointer */
char *GetConfigStr(UBYTE **buf)
{
 char *s=*buf;
 char *new;
 ULONG len=strlen(s)+1;

 /* Allocate string buffer */
 if (new=malloc(len)) {
  /* Copy string */
  strcpy(new,s);

  /* Correct pointer */
  *buf+=len;
 }
 return(new);
}

/* Write one config string and correct pointer */
BOOL PutConfigStr(char *s, UBYTE **buf)
{
 /* string valid? */
 if (s) {
  /* Copy string to buffer */
  strcpy(*buf,s);

  /* Correct pointer */
  *buf+=strlen(s)+1;
  return(TRUE);
 }
 return(FALSE);
}
