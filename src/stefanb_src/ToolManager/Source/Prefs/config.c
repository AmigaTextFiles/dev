/*
 * config.c  V3.1
 *
 * Preferences editor configuration file handling routines
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

/* Local data */
static const char  TMConfigVersion[]  = TMCONFIGVERSION;
static const char *DefaultToolTypes[] = {"USE", NULL };

/* Local macros */
#define TREENODE(n) ((struct MUIS_Listtree_TreeNode *) (n))

/* IntuiMsg handler */
__geta4 static void IntuiMsgFunction(__a1 struct IntuiMessage *msg,
                                     __a2 struct FileRequester *req)
{
 /* Refresh window? */
 if (msg->Class == IDCMP_REFRESHWINDOW)

  /* Send message to application */
  DoMethod(req->fr_UserData, MUIM_Application_CheckRefresh);
}

static const struct Hook IntuiMsgHook = {
 {NULL, NULL}, (void *) IntuiMsgFunction, NULL, NULL
};

/* Handle ASL file requester */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION OpenFileRequester
static const char *OpenFileRequester(Object *wobj, const char *name,
                                     const char *title, BOOL save)
{
 char *pathpart;
 char *rc       = NULL;

 /* Allocate memory for old file name */
 if (pathpart = DuplicateString(name)) {
  Object               *app      = _app(wobj);
  struct FileRequester *fr;
  char                 *filepart;
  struct Window        *w;

  CONFIG_LOG(LOG1(Path buffer, "0x%08lx", pathpart))

  /* Get file part */
  filepart = FilePart(name);

  /* Append string terminator after path part */
  pathpart[filepart - name] = '\0';

  CONFIG_LOG(LOG3(Split, "Name %s Path %s File %s", name, pathpart, filepart))

  /* Get window pointer */
  GetAttr(MUIA_Window_Window, wobj, (ULONG *) &w);

  /* Allocate file requester */
  if (fr = MUI_AllocAslRequestTags(ASL_FileRequest,
       ASLFR_Window,          w,
       ASLFR_TitleText,       title,
       ASLFR_InitialLeftEdge, w->LeftEdge + w->BorderLeft + 2,
       ASLFR_InitialTopEdge,  w->TopEdge  + w->BorderTop  + 2,
       ASLFR_InitialWidth,    w->Width    - w->BorderLeft - w->BorderRight  - 4,
       ASLFR_InitialHeight,   w->Height   - w->BorderTop  - w->BorderBottom - 4,
       ASLFR_InitialPattern,  "#?.prefs",
       ASLFR_InitialDrawer,   pathpart,
       ASLFR_InitialFile,     filepart,
       ASLFR_DoPatterns,      TRUE,
       ASLFR_DoSaveMode,      save,
       ASLFR_RejectIcons,     TRUE,
       ASLFR_UserData,        app,
       ASLFR_IntuiMsgFunc,    &IntuiMsgHook,
       TAG_DONE)) {

   CONFIG_LOG(LOG1(Requester, "0x%08lx", fr))

   /* Put MUI application to sleep */
   SetAttrs(app, MUIA_Application_Sleep, TRUE, TAG_DONE);

   /* Open requester */
   if (MUI_AslRequestTags(fr, TAG_DONE)) {

    CONFIG_LOG(LOG0(Requester done))

    /* File name valid? */
    if (*fr->fr_File) {
     ULONG len = strlen(fr->fr_Drawer) + strlen(fr->fr_File) + 2;

     CONFIG_LOG(LOG4(Selected, "Path %s (0x%08lx) File %s (0x%08lx)",
                     fr->fr_Drawer, fr->fr_Drawer, fr->fr_File, fr->fr_File))

     /* Allocate memory for new file name */
     if (rc = GetVector(len)) {

      /* Create new file name */
      strcpy(rc, fr->fr_Drawer);
      AddPart(rc, fr->fr_File, len);

      CONFIG_LOG(LOG1(New file, "%s", rc))
     }
    }
   }

   /* Wake up MUI application */
   SetAttrs(app, MUIA_Application_Sleep, FALSE, TAG_DONE);

   /* Free ASL requester */
   MUI_FreeAslRequest(fr);
  }

  /* Release old file name */
  FreeVector(pathpart);
 }

 CONFIG_LOG(LOG1(Result, "0x%08lx", rc))

 /* Return pointer to new file name (caller has to FreeVector() it! */
 return(rc);
}

/* Set quiet mode of all lists */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION SetQuietMode
static void SetQuietMode(Object **lists, ULONG value)
{
 int i;

 CONFIG_LOG(LOG0(Entry))

 /* For all object types */
 for (i = TMOBJTYPE_EXEC; i < TMOBJTYPES; i++, lists++)

  /* Set list quiet mode */
  SetAttrs(*lists, MUIA_Listtree_Quiet, value, TAG_DONE);
}

/* Create object from FORM */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION CreateObjectFromFORM
static BOOL CreateObjectFromFORM(struct IFFHandle *iffh, Object **lists,
                                 ULONG type,
                                 struct MUIS_Listtree_TreeNode *node)
{
 Object *obj;
 BOOL    rc  = FALSE;

 /* Create object */
 if (obj = NewObject(ObjectClasses[type]->mcc_Class, NULL,
                                                     TMA_Name, TextGlobalEmpty,
                                                     TMA_List, lists[type],
                                                     TAG_DONE)) {

  CONFIG_LOG(LOG1(Object, "0x%08lx", obj))

  /* Tell object to parse the IFF chunk */
  if (DoMethod(obj, TMM_ParseIFF, iffh, lists)) {

   CONFIG_LOG(LOG0(IFF chunk parse OK))

   /* Append object to list */
   if (DoMethod(lists[type], MUIM_Listtree_Insert, TextGlobalEmpty, obj, node,
                MUIV_Listtree_Insert_PrevNode_Tail, 0)) {

    CONFIG_LOG(LOG0(Object inserted))

    /* All OK */
    rc = TRUE;
   }
  }

  /* Error? Delete object again */
  if (rc == FALSE) MUI_DisposeObject(obj);
 }

 return(rc);
}

/* Open group */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION OpenGroup
static struct MUIS_Listtree_TreeNode *OpenGroup(struct IFFHandle *iffh,
                                                Object *list, ULONG type)
{
 struct MUIS_Listtree_TreeNode *rc = NULL;

 /* Parse PROP chunk */
 if ((PropChunk(iffh, type, ID_OGRP) == 0) &&
     (StopOnExit(iffh, type, ID_PROP) == 0) &&
     (ParseIFF(iffh, IFFPARSE_SCAN) == IFFERR_EOC)) {
  struct StoredProperty *sp;

  CONFIG_LOG(LOG0(PROP chunk parsed))

  /* Get group chunk */
  if (sp = FindProp(iffh, type, ID_OGRP)) {
   struct MUIS_Listtree_TreeNode *next =
                                TREENODE(MUIV_Listtree_GetEntry_Position_Head);

   CONFIG_LOG(LOG2(Group property, "%s (0x%08lx)", sp->sp_Data, sp->sp_Data))

   /* Start from root node */
   rc = TREENODE(MUIV_Listtree_GetEntry_ListNode_Root);

   /* Scan current list */
   while (rc = TREENODE(DoMethod(list, MUIM_Listtree_GetEntry, rc, next, 0))) {
    char *name;

    CONFIG_LOG(LOG1(Next node, "%s", rc))

    /* Get group name */
    GetAttr(TMA_Name, (Object *) rc->tn_User, (ULONG *) &name);

    /* Group found? Yes, leave loop */
    if (strcmp(sp->sp_Data, name) == 0) break;

    /* Search for next object on the same level */
    next = TREENODE(MUIV_Listtree_GetEntry_Position_Next);
   }

   /* Group not found? */
   if (rc == NULL) {
    Object *group;

    /* Group not found, create new one */
    if (group = NewObject(GroupClass->mcc_Class, NULL, TMA_Name, sp->sp_Data,
                                                       TMA_List, list,
                                                       TAG_DONE)) {

     CONFIG_LOG(LOG1(New Group, "0x%08lx", group))

     /* Append group to list */
     if ((rc = TREENODE(DoMethod(list, MUIM_Listtree_Insert, sp->sp_Data,
                                 group, MUIV_Listtree_Insert_ListNode_Root,
                                 MUIV_Listtree_Insert_PrevNode_Tail,
                                 TNF_LIST))) == NULL)

      /* Can't append group, delete group object again */
      MUI_DisposeObject(group);
    }
   }
  }
 }

 CONFIG_LOG(LOG1(Result, "0x%08lx", rc))

 /* Return pointer to group */
 return(rc);
}

/* Parse configuration */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ParseConfig
static BOOL ParseConfig(struct IFFHandle *iffh, Object **lists)
{
 ULONG                          CurrentType  = ID_TMGP;
 ULONG                          CurrentClass;
 struct MUIS_Listtree_TreeNode *CurrentGroup;
 BOOL                           rc           = TRUE;
 BOOL                           notend       = TRUE;

 /* Parse as long as no error occurs */
 while (rc && notend) {

  /* Next parse step */
  switch (ParseIFF(iffh, IFFPARSE_STEP)) {

   case 0: {
     struct ContextNode *cn;

     /* Normal parse step, get current chunk */
     if (cn = CurrentChunk(iffh))

      /* Which chunk type? */
      switch (cn->cn_ID) {
       case ID_LIST:
        CONFIG_LOG(LOG2(Enter LIST, "Type 0x%08lx Size %ld",
                        cn->cn_Type, cn->cn_Size))

        /* Store & check type and get corresponding class & list */
        switch (CurrentType = cn->cn_Type) {
         case ID_TMEX: CurrentClass = TMOBJTYPE_EXEC;   break;
         case ID_TMIM: CurrentClass = TMOBJTYPE_IMAGE;  break;
         case ID_TMSO: CurrentClass = TMOBJTYPE_SOUND;  break;
         case ID_TMMO: CurrentClass = TMOBJTYPE_MENU;   break;
         case ID_TMIC: CurrentClass = TMOBJTYPE_ICON;   break;
         case ID_TMDO: CurrentClass = TMOBJTYPE_DOCK;   break;
         case ID_TMAC: CurrentClass = TMOBJTYPE_ACCESS; break;

         default:
          CONFIG_LOG(LOG0(Unknown LIST))
          rc = FALSE;
          break;
        }
        break;

       case ID_PROP:
        CONFIG_LOG(LOG2(Enter PROP, "Type 0x%08lx Size %ld",
                        cn->cn_Type, cn->cn_Size))

        /* Open group */
        if ((CurrentGroup = OpenGroup(iffh, lists[CurrentClass], CurrentType))
             == NULL) {
         CONFIG_LOG(LOG0(Could not open group))
         rc = FALSE;
        }
        break;

       case ID_FORM:
        CONFIG_LOG(LOG2(Enter FORM, "Type 0x%08lx Size %ld",
                        cn->cn_Type, cn->cn_Size))

        /* Is the type correct? */
        if (cn->cn_Type == CurrentType)

         /* Yes, global parameters or object chunk? */
         rc = (cn->cn_Type == ID_TMGP) ? ParseGlobalIFF(iffh) :
                                         CreateObjectFromFORM(iffh,
                                                              lists,
                                                              CurrentClass,
                                                              CurrentGroup);
        else {
         /* Unexpected FORM type */
         CONFIG_LOG(LOG0(Unexpected FORM!))
         rc = FALSE;
        }
        break;

       default:
        /* No LIST/PROP/FORM */
        CONFIG_LOG(LOG0(No LIST/PROP/FORM!))
        rc = FALSE;
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

     /* End of chunk reached. Get current chunk */
     if (cn = CurrentChunk(iffh))

      /* Which type? */
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

   case IFFERR_EOF:
    /* End of configuration reached. All OK! */
    CONFIG_LOG(LOG0(Configuration parsed OK!))
    notend = FALSE;
    break;

   default:
    CONFIG_LOG(LOG0(Error in parsing))
    rc = FALSE;
    break;
  }
 }

 CONFIG_LOG(LOG1(Result, "%ld", rc))

 return(rc);
}

/* Read configuration file */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ReadConfig
void ReadConfig(Object *wobj, Object **lists, BOOL delete, const char *name)
{
 struct IFFHandle *iffh;
 BOOL              rc   = FALSE;

 CONFIG_LOG(LOG2(Name, "%s (0x%08lx)", name, name))

 /* Put application to sleep */
 SetAttrs(_app(wobj), MUIA_Application_Sleep, TRUE, TAG_DONE);

 /* Allocate IFF handle */
 if (iffh = AllocIFF()) {

  CONFIG_LOG(LOG1(IFFHandle, "0x%08lx", iffh))

  /* Open configuration file */
  if (iffh->iff_Stream = Open(name, MODE_OLDFILE)) {

   CONFIG_LOG(LOG1(File, "0x%08lx", iffh->iff_Stream))

   /* Initialize IFF handle */
   InitIFFasDOS(iffh);

   /* Open IFF handle */
   if (OpenIFF(iffh, IFFF_READ) == 0) {

    CONFIG_LOG(LOG0(Handle open))

    /* Start IFF parsing */
    if (ParseIFF(iffh, IFFPARSE_STEP) == 0) {
     struct ContextNode *cn;

     CONFIG_LOG(LOG0(First parse step))

     /* a) Check IFF type: FORM TMPR */
     /* b) Step to version chunk     */
     if ((cn = CurrentChunk(iffh)) &&
         (cn->cn_ID == ID_FORM) && (cn->cn_Type == ID_TMPR) &&
         (ParseIFF(iffh, IFFPARSE_STEP) == 0) &&
         (cn = CurrentChunk(iffh)) &&
         (cn->cn_ID == ID_FVER) && (cn->cn_Size == sizeof(TMCONFIGVERSION))) {
      char *buf;

      CONFIG_LOG(LOG0(Version chunk found))

      /* Allocate memory for version chunk */
      if (buf = GetMemory(sizeof(TMCONFIGVERSION))) {

       /* Read version chunk and check version */
       if ((ReadChunkBytes(iffh, buf, sizeof(TMCONFIGVERSION))
             == sizeof(TMCONFIGVERSION)) &&
           (strcmp(buf, TMConfigVersion) == 0) &&
           (ParseIFF(iffh, IFFPARSE_STEP) == IFFERR_EOC)) {

        CONFIG_LOG(LOG0(Configuration file OK))

        /* Set lists to quiet mode */
        SetQuietMode(lists, TRUE);

        /* Delete old configuration? */
        if (delete) {
         int i;

         /* For all object types */
         for (i = TMOBJTYPE_ACCESS; i >= TMOBJTYPE_EXEC; i--)

          /* Delete all entries in list */
          DoMethod(lists[i], MUIM_Listtree_Remove,
                   MUIV_Listtree_Remove_ListNode_Root,
                   MUIV_Listtree_Remove_TreeNode_All, 0);

        }

        /* Parse configuration */
        rc = ParseConfig(iffh, lists);

        /* Set lists to verbose mode */
        SetQuietMode(lists, FALSE);
       }

       /* Free version chunk */
       FreeMemory(buf, sizeof(TMCONFIGVERSION));
      }
     }
    }

    /* Close IFF handle */
    CloseIFF(iffh);
   }

   /* Close file */
   Close(iffh->iff_Stream);
  }

  /* Free IFF handle */
  FreeIFF(iffh);
 }

 /* Wake application up */
 SetAttrs(_app(wobj), MUIA_Application_Sleep, FALSE, TAG_DONE);

 /* Error? */
 if (rc == FALSE) {

  CONFIG_LOG(LOG0(Error in config file read))

  MUI_Request(_app(wobj), wobj, 0,
              TextGlobalTitle, TextGlobalCancel,
              TranslateString(LOCALE_TEXT_CONFIG_READ_ERROR_STR,
                              LOCALE_TEXT_CONFIG_READ_ERROR),
              name);
 }
}

/* Read configuration file using file requester */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ReadConfigWithRequester
const char *ReadConfigWithRequester(Object *wobj, Object **lists, BOOL delete,
                                    const char *name)
{
 const char *title = delete ?
                           TranslateString(LOCALE_TEXT_CONFIG_LOAD_FILE_STR,
                                           LOCALE_TEXT_CONFIG_LOAD_FILE) :
                           TranslateString(LOCALE_TEXT_CONFIG_APPEND_FILE_STR,
                                           LOCALE_TEXT_CONFIG_APPEND_FILE);
 const char *newname;

 /* Open file requester */
 if (newname = OpenFileRequester(wobj, name, title, FALSE)) {

  CONFIG_LOG(LOG2(File, "%s (0x%08lx)", newname, newname))

  /* Read configuration from file */
  ReadConfig(wobj, lists, delete, newname);
 }

 CONFIG_LOG(LOG1(Result, "0x%08lx", newname))

 /* Return pointer to new file name. Caller has to FreeVector() it! */
 return(newname);
}

/* Write configuration file */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION WriteConfig
BOOL WriteConfig(Object *wobj, Object **lists, const char *name, BOOL icons)
{
 struct IFFHandle *iffh;
 BOOL              rc   = FALSE;

 CONFIG_LOG(LOG2(Name, "%s (0x%08lx)", name, name))

 /* Put application to sleep */
 SetAttrs(_app(wobj), MUIA_Application_Sleep, TRUE, TAG_DONE);

 /* Allocate IFF handle */
 if (iffh = AllocIFF()) {

  CONFIG_LOG(LOG1(IFFHandle, "0x%08lx", iffh))

  /* Open configuration file */
  if (iffh->iff_Stream = Open(name, MODE_NEWFILE)) {
   ULONG protection = 0;

   CONFIG_LOG(LOG1(File, "0x%08lx", iffh->iff_Stream))

   /* Set protection bits */
   {
    struct FileInfoBlock *fib;

    /* Allocate file info block */
    if (fib = AllocDosObject(DOS_FIB, NULL)) {

     CONFIG_LOG(LOG1(FIB, "0x%08lx", fib))

     /* Examine file */
     if (ExamineFH(iffh->iff_Stream, fib)) {

      CONFIG_LOG(LOG1(Old protection bits, "0x%08lx", fib->fib_Protection))

      /* Copy protection bits */
      protection = fib->fib_Protection;
     }

     /* Free file info block */
     FreeDosObject(DOS_FIB, fib);
    }
   }

   /* Initialize IFF handle */
   InitIFFasDOS(iffh);

   /* Open IFF handle */
   if (OpenIFF(iffh, IFFF_WRITE) == 0) {

    CONFIG_LOG(LOG0(Handle open))

    /* Prepare new configuration file  */
    /* a) Push FORM TMPR chunk         */
    /* b) Push, write & pop FVER chunk */
    /* c) Write global data            */
    if ((PushChunk(iffh, ID_TMPR, ID_FORM, IFFSIZE_UNKNOWN) == 0) &&
        (PushChunk(iffh, 0,       ID_FVER, IFFSIZE_UNKNOWN) == 0) &&
        (WriteChunkBytes(iffh, TMConfigVersion, sizeof(TMCONFIGVERSION))
         == sizeof(TMCONFIGVERSION)) &&
        (PopChunk(iffh) == 0) &&
        WriteGlobalIFF(iffh)) {
     int i;

     CONFIG_LOG(LOG0(Configuration file prepared))

     /* Reset error flag */
     rc = TRUE;

     /* For each object type */
     for (i = TMOBJTYPE_EXEC; rc && (i < TMOBJTYPES); i++) {
      Object                        *CurrentList  = *lists++;
      struct MUIS_Listtree_TreeNode *CurrentGroup;

      CONFIG_LOG(LOG1(Next list, "0x%08lx", CurrentList))

      /* Get first group in list */
      if (CurrentGroup = TREENODE(DoMethod(CurrentList, MUIM_Listtree_GetEntry,
                                    MUIV_Listtree_GetEntry_ListNode_Root,
                                    MUIV_Listtree_GetEntry_Position_Head,
                                    0))) {
       ULONG   CurrentType;

       CONFIG_LOG(LOG1(First group, "0x%08lx", CurrentGroup))

       /* Get chunk ID from object type */
       switch (i) {
        case TMOBJTYPE_EXEC:   CurrentType = ID_TMEX; break;
        case TMOBJTYPE_IMAGE:  CurrentType = ID_TMIM; break;
        case TMOBJTYPE_SOUND:  CurrentType = ID_TMSO; break;
        case TMOBJTYPE_MENU:   CurrentType = ID_TMMO; break;
        case TMOBJTYPE_ICON:   CurrentType = ID_TMIC; break;
        case TMOBJTYPE_DOCK:   CurrentType = ID_TMDO; break;
        case TMOBJTYPE_ACCESS: CurrentType = ID_TMAC; break;
       }

       /* Open LIST */
       if (PushChunk(iffh, CurrentType, ID_LIST, IFFSIZE_UNKNOWN) == 0) {

        CONFIG_LOG(LOG1(LIST opened, "Type 0x%08lx", CurrentType))


        /* For each group */
        do {
         ULONG  grouplen;
         char  *groupname;

         CONFIG_LOG(LOG1(Next group, "0x%08lx", CurrentGroup))

         /* Get group name */
         GetAttr(TMA_Name, CurrentGroup->tn_User, (ULONG *) &groupname);
         grouplen = strlen(groupname) + 1;

         CONFIG_LOG(LOG2(Group name, "%s (0x%08lx)", groupname, groupname))

         /* Write group property */
         if ((PushChunk(iffh, CurrentType, ID_PROP, IFFSIZE_UNKNOWN) == 0) &&
             (PushChunk(iffh, 0,           ID_OGRP, IFFSIZE_UNKNOWN) == 0) &&
             (WriteChunkBytes(iffh, groupname, grouplen) == grouplen) &&
             (PopChunk(iffh) == 0) && /* OGRP */
             (PopChunk(iffh) == 0)) { /* PROP */
          struct MUIS_Listtree_TreeNode *tn  = CurrentGroup;
          struct MUIS_Listtree_TreeNode *pos =
                                TREENODE(MUIV_Listtree_GetEntry_Position_Head);

          CONFIG_LOG(LOG0(Group PROP written))

          /* For each object in node */
          while (rc && (tn = TREENODE(DoMethod(CurrentList,
                                   MUIM_Listtree_GetEntry, tn, pos, 0)))) {

           CONFIG_LOG(LOG1(Next object, "0x%08lx", tn->tn_User))

           /* a) Open new FORM chunk                        */
           /* b) Tell object to write its data to the chunk */
           /* c) Close FORM chunk */
           rc = (PushChunk(iffh, CurrentType, ID_FORM, IFFSIZE_UNKNOWN)
                 == 0) &&
                DoMethod(tn->tn_User, TMM_WriteIFF, iffh) &&
                (PopChunk(iffh) == 0);

           /* Search for next object on the same level */
           pos = TREENODE(MUIV_Listtree_GetEntry_Position_Next);
          }

         } else {
          CONFIG_LOG(LOG0(Could not write group PROP))
          rc = FALSE;
         }

        /* Get next group */
        } while (rc &&
                 (CurrentGroup = TREENODE(DoMethod(CurrentList,
                                    MUIM_Listtree_GetEntry,
                                    CurrentGroup,
                                    MUIV_Listtree_GetEntry_Position_Next,
                                    0))));

        /* Close LIST */
        if (PopChunk(iffh) != 0) {
         CONFIG_LOG(LOG0(Could not close LIST))
         rc = FALSE;
        }
       } else {
        CONFIG_LOG(LOG0(Could not open LIST))
        rc = FALSE;
       }
      }
     }
    }

    /* Close IFF handle */
    CloseIFF(iffh);
   }

   /* Close file */
   Close(iffh->iff_Stream);

   /* Clear execute flag */
   SetProtection(name, protection | FIBF_EXECUTE);
  }

  /* Free IFF handle */
  FreeIFF(iffh);
 }

 /* Wake application up */
 SetAttrs(_app(wobj), MUIA_Application_Sleep, FALSE, TAG_DONE);

 /* No error? */
 if (rc) {

  /* Create icons? */
  if (icons) {
   struct DiskObject *dobj;

   CONFIG_LOG(LOG0(Create icon))

   /* Get default icon for projects */
   if ((dobj = GetDiskObject("ENV:Sys/def_pref")) ||
       (dobj = GetDiskObjectNew(name))) {
    char   *oldtool = dobj->do_DefaultTool;
    char  **oldtt   = dobj->do_ToolTypes;
    UBYTE   oldtype = dobj->do_Type;

    CONFIG_LOG(LOG1(DiskObject, "0x%08lx", dobj))

    /* Set new values */
    dobj->do_DefaultTool = ProgramName;
    dobj->do_ToolTypes   = DefaultToolTypes;
    dobj->do_Type        = WBPROJECT;

    /* Write icon */
    PutDiskObject(name, dobj);

    /* Reset to old values */
    dobj->do_DefaultTool = oldtool;
    dobj->do_ToolTypes   = oldtt;
    dobj->do_Type        = oldtype;

    /* Free icon */
    FreeDiskObject(dobj);
   }
  }
 } else {

  CONFIG_LOG(LOG0(Error in config file write))

  MUI_Request(_app(wobj), wobj, 0,
              TextGlobalTitle, TextGlobalCancel,
              TranslateString(LOCALE_TEXT_CONFIG_WRITE_ERROR_STR,
                              LOCALE_TEXT_CONFIG_WRITE_ERROR),
              name);
 }

 CONFIG_LOG(LOG1(Result, "%ld", rc))

 return(rc);
}

/* Write configuration file using file requester */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION WriteConfigWithRequester
const char *WriteConfigWithRequester(Object *wobj, Object **lists,
                                     const char *name, BOOL icons)
{
 const char *newname;

 /* Open file requester */
 if (newname = OpenFileRequester(wobj, name,
                            TranslateString(LOCALE_TEXT_CONFIG_SAVE_FILE_STR,
                                            LOCALE_TEXT_CONFIG_SAVE_FILE),
                            TRUE)) {

  CONFIG_LOG(LOG2(File, "%s (0x%08lx)", newname, newname))

  /* Read configuration from file */
  WriteConfig(wobj, lists, newname, icons);
 }

 CONFIG_LOG(LOG1(Result, "0x%08lx", newname))

 /* Return pointer to new file name. Caller has to FreeVector() it! */
 return(newname);
}

/* Read a string from the IFF property and duplicate it */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ReadStringProperty
char *ReadStringProperty(struct IFFHandle *iffh, ULONG type, ULONG id)
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

/* Write data to an IFF property */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION WriteProperty
BOOL WriteProperty(struct IFFHandle *iffh, ULONG id, void *data, ULONG size)
{
 BOOL rc;

 CONFIG_LOG(LOG4(Entry, "IFFHandle 0x%08lx ID 0x%08lx Data 0x%08lx Size %ld",
                 iffh, id, data, size))

 /* a) Open new property chunk */
 /* b) Write data to chunk     */
 /* c) Close property chunk    */
 rc = (PushChunk(iffh, 0, id, IFFSIZE_UNKNOWN) == 0) &&
      (WriteChunkBytes(iffh, data, size) == size) &&
      (PopChunk(iffh) == 0);

 CONFIG_LOG(LOG1(Result, "%ld", rc))

 return(rc);
}

/* Write string to an IFF property */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION WriteStringProperty
BOOL WriteStringProperty(struct IFFHandle *iffh, ULONG id, const char *string)
{
 BOOL rc = TRUE;

 CONFIG_LOG(LOG4(Entry, "IFFHandle 0x%08lx ID 0x%08lx String %s (0x%08lx)",
                 iffh, id, string, string))

 /* String valid? */
 if (string)

  /* Yes, write string */
  rc = WriteProperty(iffh, id, string, strlen(string) + 1);

 CONFIG_LOG(LOG1(Result, "%ld", rc))

 return(rc);
}
