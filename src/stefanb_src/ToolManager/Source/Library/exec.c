/*
 * exec.c  V3.1
 *
 * ToolManager Objects Exec class
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
const char DefaultOutput[]    = "NIL:";
const char DefaultDirectory[] = "SYS:";

/* Hook function prototype */
typedef ULONG (*HookFuncPtr)(__A0 struct Hook *, __A1 void *, __A2 void *);

/* Local data */
#define PROPCHUNKS 6
static const ULONG PropChunkTable[2 * PROPCHUNKS] = {
 ID_TMEX, ID_CDIR,
 ID_TMEX, ID_CMND,
 ID_TMEX, ID_HKEY,
 ID_TMEX, ID_OUTP,
 ID_TMEX, ID_PATH,
 ID_TMEX, ID_PSCR
};
static const struct TagItem TagsToFlags[] = {
 TMOP_Arguments, DATA_EXECF_ARGUMENTS,
 TMOP_ToFront,   DATA_EXECF_TOFRONT,
 TAG_DONE
};

/* Exec class instance data */
struct ExecClassData {
 ULONG                 ecd_Flags;
 UWORD                 ecd_ExecType;
 WORD                  ecd_Priority;
 ULONG                 ecd_Stack;
 char                 *ecd_CurrentDir;
 char                 *ecd_Command;
 char                 *ecd_Output;
 char                 *ecd_Path;
 char                 *ecd_PubScreen;
 char                **ecd_PathArray;
 CxObj                *ecd_HotKey;
 struct TMMemberData  *ecd_DockLink;
};
#define TYPED_INST_DATA(cl, o) ((struct ExecClassData *) INST_DATA((cl), (o)))

/* Flags for strings allocated in IFF parsing */
#define IFFF_CURRENTDIR 0x80000000  /* ecd_CurrentDir          */
#define IFFF_COMMAND    0x40000000  /* ecd_Command             */
#define IFFF_OUTPUT     0x20000000  /* ecd_Output              */
#define IFFF_PATH       0x10000000  /* ecd_Path                */
#define IFFF_PUBSCREEN  0x08000000  /* ecd_PubScreen           */

/* Convert comma seperated path list to array of string pointers */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ConvertPathList
static char **ConvertPathList(char *s)
{
 ULONG   count = 0;
 char  **rc    = NULL;

 EXECCLASS_LOG(LOG2(Paths, "%s (0x%08lx)", s, s))

 /* Count entries in string and add string terminators */
 {
  char *path = s;

  /* Scan path string */
  while (path) {

   /* Find next entry and add string terminator to current entry */
   if (path = strchr(path, ',')) *path = '\0';

   /* Increment counter */
   count++;
  }
 }

 EXECCLASS_LOG(LOG1(Count, "%ld", count))

 /* Any entries in list? Allocate path array */
 if (count && (rc = GetVector(sizeof(char *) * (count + 1)))) {
  char **entry = rc;

  EXECCLASS_LOG(LOG1(PathArray, "0x%08lx", rc))

  /* For each entry */
  while (count--) {

   EXECCLASS_LOG(LOG1(Next Entry, "%s", s))

   /* Store pointer to next path */
   *entry++ = s;

   /* Go to next path (skip string terminator) */
   s += strlen(s) + 1;
  }

  /* Set array terminator */
  *entry = NULL;
 }

 EXECCLASS_LOG(LOG1(Result, "0x%08lx", rc))

 return(rc);
}

/* Exec class method: OM_NEW */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ExecClassNew
static ULONG ExecClassNew(Class *cl, Object *obj, struct opSet *ops)
{
 EXECCLASS_LOG((LOG1(Tags, "0x%08lx", ops->ops_AttrList),
                PrintTagList(ops->ops_AttrList)))

 /* Call SuperClass */
 if (obj = (Object *) DoSuperMethodA(cl, obj, (Msg) ops)) {
  struct ExecClassData *ecd = TYPED_INST_DATA(cl, obj);

  /* Initialize instance data */
  ecd->ecd_Flags     = 0;
  ecd->ecd_Command   = NULL;
  ecd->ecd_Output    = DefaultOutput;
  ecd->ecd_PathArray = NULL;
  ecd->ecd_HotKey    = NULL;
  ecd->ecd_DockLink  = NULL;
 }

 return((ULONG) obj);
}

/* Exec class method: OM_DISPOSE */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ExecClassDispose
static ULONG ExecClassDispose(Class *cl, Object *obj, Msg msg)
{
 struct ExecClassData *ecd = TYPED_INST_DATA(cl, obj);

 EXECCLASS_LOG(LOG0(Disposing))

 /* Dock attached? Release it */
 if (ecd->ecd_DockLink)
  DoMethod(ecd->ecd_DockLink->tmmd_Object, TMM_Release, ecd->ecd_DockLink);

 /* Hotkey allocated? */
 if (ecd->ecd_HotKey) SafeDeleteCxObjAll(ecd->ecd_HotKey, obj);

 /* Path array allocated? */
 if (ecd->ecd_PathArray) FreeVector(ecd->ecd_PathArray);

 /* Free IFF data */
 if (ecd->ecd_Flags & IFFF_PUBSCREEN)  FreeVector(ecd->ecd_PubScreen);
 if (ecd->ecd_Flags & IFFF_PATH)       FreeVector(ecd->ecd_Path);
 if (ecd->ecd_Flags & IFFF_OUTPUT)     FreeVector(ecd->ecd_Output);
 if (ecd->ecd_Flags & IFFF_COMMAND)    FreeVector(ecd->ecd_Command);
 if (ecd->ecd_Flags & IFFF_CURRENTDIR) FreeVector(ecd->ecd_CurrentDir);

 /* Call SuperClass */
 return(DoSuperMethodA(cl, obj, msg));
}

/* Exec class method: TMM_Release */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ExecClassRelease
static ULONG ExecClassRelease(Class *cl, Object *obj, struct TMP_Detach *tmpd)
{
 struct ExecClassData *ecd = TYPED_INST_DATA(cl, obj);

 EXECCLASS_LOG(LOG2(Arguments, "Data 0x%08lx Object 0x%08lx",
                    tmpd->tmpd_MemberData, tmpd->tmpd_MemberData->tmmd_Object))

 /* Detach dock */
 DoMethod(ecd->ecd_DockLink->tmmd_Object, TMM_Detach, ecd->ecd_DockLink);
 ecd->ecd_DockLink = NULL;

 /* Return 1 to indicate that the method is implemented */
 return(1);
}

/* Exec class method: TMM_ParseIFF */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ExecClassParseIFF
static ULONG ExecClassParseIFF(Class *cl, Object *obj,
                               struct TMP_ParseIFF *tmppi)
{
 BOOL rc = FALSE;

 EXECCLASS_LOG(LOG1(Handle, "0x%08lx", tmppi->tmppi_IFFHandle))

 /* Initialize IFF parser and forward method to SuperClass */
 if ((PropChunks(tmppi->tmppi_IFFHandle, PropChunkTable, PROPCHUNKS) == 0) &&
     DoSuperMethodA(cl, obj, (Msg) tmppi)) {
  struct StoredProperty *sp;

  EXECCLASS_LOG(LOG0(FORM TMEX chunk parsed OK))

  /* Check for mandatory DATA property */
  if (sp = FindProp(tmppi->tmppi_IFFHandle, ID_TMEX, ID_DATA)) {
   struct ExecClassData *ecd = TYPED_INST_DATA(cl, obj);
   struct ExecDATAChunk *edc = sp->sp_Data;

   EXECCLASS_LOG(LOG4(Data, "Flags 0x%08lx Type %ld Prio %ld Stack %ld",
                      edc->edc_Standard.sdc_Flags, edc->edc_ExecType,
                      edc->edc_Priority, edc->edc_Stack))

   /* Initialize class data */
   ecd->ecd_Flags    = edc->edc_Standard.sdc_Flags & DATA_EXECF_MASK;
   ecd->ecd_ExecType = edc->edc_ExecType;
   ecd->ecd_Priority = edc->edc_Priority;
   ecd->ecd_Stack    = edc->edc_Stack;

   /* Duplicate strings and set flags */
   if (ecd->ecd_CurrentDir = DuplicateProperty(tmppi->tmppi_IFFHandle,
                                               ID_TMEX, ID_CDIR))
    ecd->ecd_Flags |= IFFF_CURRENTDIR;
   else
    ecd->ecd_CurrentDir    = GetGlobalDefaultDirectory();
   if (ecd->ecd_Command    = DuplicateProperty(tmppi->tmppi_IFFHandle,
                                               ID_TMEX, ID_CMND))
    ecd->ecd_Flags |= IFFF_COMMAND;
   if (ecd->ecd_Output     = DuplicateProperty(tmppi->tmppi_IFFHandle,
                                               ID_TMEX, ID_OUTP))
    ecd->ecd_Flags |= IFFF_OUTPUT;
   else
    ecd->ecd_Output        = DefaultOutput;
   if (ecd->ecd_Path       = DuplicateProperty(tmppi->tmppi_IFFHandle,
                                               ID_TMEX, ID_PATH))
    ecd->ecd_Flags |= IFFF_PATH;
   if (ecd->ecd_PubScreen  = DuplicateProperty(tmppi->tmppi_IFFHandle,
                                               ID_TMEX, ID_PSCR))
    ecd->ecd_Flags |= IFFF_PUBSCREEN;

   /* Convert path string to path array */
   ecd->ecd_PathArray = ConvertPathList(ecd->ecd_Path);

   /* HotKey specified? */
   if (sp = FindProp(tmppi->tmppi_IFFHandle, ID_TMEX, ID_HKEY))

    /* Yes, reate Hotkey */
    ecd->ecd_HotKey = CreateHotKey(sp->sp_Data, obj);

   /* Configuration data parsed */
   rc = TRUE;
  }
 }

 EXECCLASS_LOG(LOG1(Result, "%ld", rc))

 return(rc);
}

/* Exec class method: TMM_ParseTags */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ExecClassParseTags
static ULONG ExecClassParseTags(Class *cl, Object *obj,
                                struct TMP_ParseTags *tmppt)
{
 struct ExecClassData *ecd    = TYPED_INST_DATA(cl, obj);
 struct TagItem       *tstate = tmppt->tmppt_Tags;
 struct TagItem       *ti;
 BOOL                  rc     = TRUE;

 EXECCLASS_LOG((LOG1(Tags, "0x%08lx", tmppt->tmppt_Tags),
                PrintTagList(tmppt->tmppt_Tags)))

 /* Scan tag list */
 while (rc && (ti = NextTagItem(&tstate)))

  /* Which tag? */
  switch (ti->ti_Tag) {
   case TMOP_Command:
    if (ti->ti_Data)

     ecd->ecd_Command = (char *) ti->ti_Data;

    else

     rc = FALSE;

    break;

   case TMOP_CurrentDir:
    if (ti->ti_Data)

     /* Set new current directory */
     ecd->ecd_CurrentDir = (char *) ti->ti_Data;

    else

     /* Set to default value */
     ecd->ecd_CurrentDir = DefaultDirectory;

    break;

   case TMOP_ExecType: {
     UWORD type = ti->ti_Data;

     /* Sanity check */
     if ((type <= TMET_Network) || (type == TMET_Hook))

      /* Type OK */
      ecd->ecd_ExecType = type;

     else

      /* Error */
      rc = FALSE;
    }
    break;

   case TMOP_HotKey:
    /* Free old hotkey */
    if (ecd->ecd_HotKey) SafeDeleteCxObjAll(ecd->ecd_HotKey, obj);

    /* String valid? */
    if (ti->ti_Data)

     /* Yes, create new hotkey */
     rc = (ecd->ecd_HotKey = CreateHotKey((char *) ti->ti_Data, obj)) != NULL;

    else

     /* Hotkey cleared */
     ecd->ecd_HotKey = NULL;

    break;

   case TMOP_Output:
    if (ti->ti_Data)

     /* Set new output file */
     ecd->ecd_Output = (char *) ti->ti_Data;

    else

     /* Reset to default output file */
     ecd->ecd_Output = DefaultOutput;

    break;

   case TMOP_Path:
    /* Free old path */
    if (ecd->ecd_Flags & IFFF_PATH) FreeVector(ecd->ecd_Path);

    /* Free old path array */
    if (ecd->ecd_PathArray) FreeVector(ecd->ecd_PathArray);

    /* String valid? Duplicate it */
    if (ti->ti_Data &&
        (ecd->ecd_Path = GetVector(strlen((char *) ti->ti_Data) + 1))) {

     /* Copy string */
     strcpy(ecd->ecd_Path, (char *) ti->ti_Data);

     /* Set flag */
     ecd->ecd_Flags |= IFFF_PATH;

     /* Convert path string */
     rc = (ecd->ecd_PathArray = ConvertPathList(ecd->ecd_Path)) != NULL;

    } else {

     /* Path cleared */
     ecd->ecd_Flags     &= ~IFFF_PATH;
     ecd->ecd_PathArray  = NULL;
    }
    break;

   case TMOP_Priority:
    ecd->ecd_Priority = ti->ti_Data;
    break;

   case TMOP_PubScreen:
    ecd->ecd_PubScreen = (char *) ti->ti_Data;
    break;

   case TMOP_Stack:
    ecd->ecd_Stack = ti->ti_Data;
    break;
  }

 /* Set flags if no error */
 if (rc) ecd->ecd_Flags = PackBoolTags(ecd->ecd_Flags, tmppt->tmppt_Tags,
                                       TagsToFlags);

 EXECCLASS_LOG(LOG1(Result, "%ld", rc))

 return(rc);
}

/* Exec class method: TMM_Activate */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ExecClassActivate
static ULONG ExecClassActivate(Class *cl, Object *obj,
                               struct TMP_Activate *tmpa)
{
 struct ExecClassData *ecd = TYPED_INST_DATA(cl, obj);
 BOOL                  rc  = FALSE;

 EXECCLASS_LOG(LOG1(Data, "0x%08lx", tmpa->tmpa_Data))

 /* Check if command is valid */
 if (ecd->ecd_Command) {

  /* Check ToFront flag */
  if (ecd->ecd_Flags & DATA_EXECF_TOFRONT) {
   struct Screen *s;

   /* Flag set, lock public screen */
   if (s = LockPubScreen(ecd->ecd_PubScreen)) {

    /* Move screen to front */
    ScreenToFront(s);

    /* Unlock screen */
    UnlockPubScreen(NULL, s);
   }
  }

  /* Which exec type? */
  switch (ecd->ecd_ExecType) {
   case TMET_CLI:
    rc = StartCLIProgram(ecd->ecd_Command, ecd->ecd_CurrentDir,
                         ecd->ecd_PathArray, ecd->ecd_Output, ecd->ecd_Stack,
                         ecd->ecd_Priority,
                         (ecd->ecd_Flags & DATA_EXECF_ARGUMENTS) ?
                          tmpa->tmpa_Data : NULL);
    break;

   case TMET_WB:
    rc = StartWBProgram(ecd->ecd_Command, ecd->ecd_CurrentDir, ecd->ecd_Stack,
                        ecd->ecd_Priority,
                        (ecd->ecd_Flags & DATA_EXECF_ARGUMENTS) ?
                         tmpa->tmpa_Data : NULL);
    break;

   case TMET_ARexx:
    rc = StartARexxProgram(ecd->ecd_Command, ecd->ecd_CurrentDir,
                           (ecd->ecd_Flags & DATA_EXECF_ARGUMENTS) ?
                            tmpa->tmpa_Data : NULL);
    break;

   case TMET_Dock: {
     struct TMHandle *tmh;
     Object          *dock;

     /* Get TMHandle */
     GetAttr(TMA_TMHandle, obj, (ULONG *) &tmh);

     /* Find dock */
     if (dock = FindTypedNamedTMObject(tmh, ecd->ecd_Command,
                                       TMOBJTYPE_DOCK)) {

      EXECCLASS_LOG(LOG1(Dock, "0x%08lx", dock))

      /* Send activate message */
      DoMethod(dock, TMM_Activate, NULL);

      /* All OK */
      rc = TRUE;
     }
    }
    break;

   case TMET_HotKey:
    rc = SendInputEvent(ecd->ecd_Command);
    break;

   case TMET_Network:
    /* NOT SUPPORTED YET! */
    break;

   case TMET_Hook: {
     struct Hook *hook = (struct Hook *) ecd->ecd_Command;

     EXECCLASS_LOG(LOG3(Call Hook, "Hook 0x%08lx Entry 0x%08lx Data 0x%08lx",
                        hook, hook->h_Entry, hook->h_Data))

     /* Call hook function. Calling conventions:          */
     /* A0 (hook)   : pointer to hook structure           */
     /* A1 (message): pointer to AppMessage (may be NULL) */
     /* A2 (object) : value of hook->h_Data               */
     /* Return Code : BOOL, FALSE for failure             */
     rc = ((HookFuncPtr) hook->h_Entry)(hook, tmpa->tmpa_Data, hook->h_Data);
    }
    break;

  }
 }

 /* Program started? */
 if (rc == FALSE) DisplayBeep(NULL);

 /* Return 1 to indicate that the method is implemented */
 return(1);
}

/* Exec class dispatcher */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ExecClassDispatcher
static __geta4 ULONG ExecClassDispatcher(__A0 Class *cl, __A2 Object *obj,
                                         __A1 Msg msg)
{
 ULONG rc;

 EXECCLASS_LOG(LOG3(Arguments, "Class 0x%08lx Object 0x%08lx Msg 0x%08lx",
                    cl, obj, msg))

 switch(msg->MethodID) {
  /* BOOPSI methods */
  case OM_NEW:
   rc = ExecClassNew(cl, obj, (struct opSet *) msg);
   break;

  case OM_DISPOSE:
   rc = ExecClassDispose(cl, obj, msg);
   break;

  /* TM methods */
  case TMM_Release:
   rc = ExecClassRelease(cl, obj, (struct TMP_Detach *) msg);
   break;

  case TMM_ParseIFF:
   rc = ExecClassParseIFF(cl, obj, (struct TMP_ParseIFF *) msg);
   break;

  case TMM_ParseTags:
   rc = ExecClassParseTags(cl, obj, (struct TMP_ParseTags *) msg);
   break;

  case TMM_Activate:
   rc = ExecClassActivate(cl, obj, (struct TMP_Activate *) msg);
   break;

  /* Unknown method -> delegate to SuperClass */
  default:
   rc = DoSuperMethodA(cl, obj, msg);
   break;
 }

 return(rc);
}

/* Create Exec class */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION CreateExecClass
Class *CreateExecClass(Class *superclass)
{
 Class *cl;

 EXECCLASS_LOG(LOG1(SuperClass, "0x%08lx", superclass))

 /* Create class */
 if (cl = MakeClass(NULL, NULL, superclass, sizeof(struct ExecClassData), 0))

  /* Set dispatcher */
  cl->cl_Dispatcher.h_Entry = (ULONG (*)()) ExecClassDispatcher;

 EXECCLASS_LOG(LOG1(Class, "0x%08lx", cl))

 /* Return pointer to class */
 return(cl);
}
