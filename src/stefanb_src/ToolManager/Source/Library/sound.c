/*
 * sound.c  V3.1
 *
 * ToolManager Objects Sound class
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
#define PROPCHUNKS 2
static const ULONG PropChunkTable[2 * PROPCHUNKS] = {
 ID_TMSO, ID_CMND,
 ID_TMSO, ID_PORT
};

/* Sound class instance data */
struct SoundClassData {
 char  *scd_Command;
};
#define TYPED_INST_DATA(cl, o) ((struct SoundClassData *) INST_DATA((cl), (o)))

/* Create ARexx command */
#define DEBUGFUNCTION CreateSoundCommand
static char *CreateSoundCommand(char *cmd, ULONG len, char *port)
{
 char *rc = NULL;

 SOUNDCLASS_LOG(LOG3(Entry, "Command '%s' (%ld) Port '%s'", cmd, len, port))

 /* Port valid? No, set default port */
 if (port == NULL) port = "PLAY";

 /* Calculate ARexx command string length */
 /* + 10   for "'address \""              */
 /* + 3    for "\" \""                    */
 /* + 2    for "\"'"                      */
 /* + length of port name                 */
 len += 15 + strlen(port);

 /* Allocate memory for command string (plus string terminator!) */
 if (rc = GetVector(len + 1)) {
  char *s = rc;

  /* Build command line */
  strcpy(s, "'address \""); s += 10;
  strcpy(s, port);          s += strlen(s);
  strcpy(s, "\" \"");       s += 3;
  strcpy(s, cmd);           s += strlen(s);
  strcpy(s, "\"'");

  SOUNDCLASS_LOG(LOG3(ARexx Cmd, "%s (0x%08lx, %ld)", rc, rc, len))
 }

 SOUNDCLASS_LOG(LOG1(Result, "0x%08lx", rc))

 return(rc);
}

/* Sound class method: OM_NEW */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION SoundClassNew
static ULONG SoundClassNew(Class *cl, Object *obj, struct opSet *ops)
{
 SOUNDCLASS_LOG((LOG1(Tags, "0x%08lx", ops->ops_AttrList),
                 PrintTagList(ops->ops_AttrList)))

 /* Call SuperClass */
 if (obj = (Object *) DoSuperMethodA(cl, obj, (Msg) ops)) {
  struct SoundClassData *scd = TYPED_INST_DATA(cl, obj);

  /* Initialize instance data */
  scd->scd_Command = NULL;
 }

 return((ULONG) obj);
}

/* Sound class method: OM_DISPOSE */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION SoundClassDispose
static ULONG SoundClassDispose(Class *cl, Object *obj, Msg msg)
{
 struct SoundClassData *scd = TYPED_INST_DATA(cl, obj);

 SOUNDCLASS_LOG(LOG0(Disposing))

 /* Free command string */
 if (scd->scd_Command) FreeVector(scd->scd_Command);

 /* Call SuperClass */
 return(DoSuperMethodA(cl, obj, msg));
}

/* Sound class method: TMM_ParseIFF */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION SoundClassParseIFF
static ULONG SoundClassParseIFF(Class *cl, Object *obj,
                                struct TMP_ParseIFF *tmppi)
{
 BOOL rc = FALSE;

 SOUNDCLASS_LOG(LOG1(Handle, "0x%08lx", tmppi->tmppi_IFFHandle))

 /* Initialize IFF parser and forward method to SuperClass */
 if ((PropChunks(tmppi->tmppi_IFFHandle, PropChunkTable, PROPCHUNKS) == 0) &&
     DoSuperMethodA(cl, obj, (Msg) tmppi)) {
  struct StoredProperty *cmnd;

  SOUNDCLASS_LOG(LOG0(FORM TMSO chunk parsed OK))

  /* Check for mandatory CMND property */
  if (cmnd = FindProp(tmppi->tmppi_IFFHandle, ID_TMSO, ID_CMND)) {
   struct StoredProperty *sp;

   SOUNDCLASS_LOG(LOG2(Command, "'%s' (%ld)", cmnd->sp_Data, cmnd->sp_Size))

   /* Find PORT property */
   sp = FindProp(tmppi->tmppi_IFFHandle, ID_TMSO, ID_PORT);

   /* Create sound command string */
   if (TYPED_INST_DATA(cl, obj)->scd_Command =
        CreateSoundCommand(cmnd->sp_Data, cmnd->sp_Size - 1,
                           sp ? sp->sp_Data : NULL))

    /* Configuration data parsed */
    rc = TRUE;
  }
 }

 SOUNDCLASS_LOG(LOG1(Result, "%ld", rc))

 return(rc);
}

/* Sound class method: TMM_ParseTags */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION SoundClassParseTags
static ULONG SoundClassParseTags(Class *cl, Object *obj,
                                 struct TMP_ParseTags *tmppt)
{
 struct SoundClassData *scd    = TYPED_INST_DATA(cl, obj);
 struct TagItem        *tstate = tmppt->tmppt_Tags;
 struct TagItem        *ti;
 char                  *cmd;
 char                  *port;
 BOOL                   rc     = TRUE;

 SOUNDCLASS_LOG((LOG1(Tags, "0x%08lx", tmppt->tmppt_Tags),
                PrintTagList(tmppt->tmppt_Tags)))

 /* Free old command */
 if (scd->scd_Command) FreeVector(scd->scd_Command);

 /* Scan tag list */
 while (rc && (ti = NextTagItem(&tstate)))

  /* Which tag? */
  switch (ti->ti_Tag) {
   case TMOP_Command:
    if (ti->ti_Data)

     cmd = (char *) ti->ti_Data;

    else

     rc = FALSE;

    break;

   case TMOP_Port:
    port = (char *) ti->ti_Data;
    break;
  }

 /* No error? */
 if (rc)

  /* Yes, create new command */
  rc = (scd->scd_Command = CreateSoundCommand(cmd, strlen(cmd), port)) != NULL;

 else

  /* Clear command pointer */
  scd->scd_Command = NULL;

 SOUNDCLASS_LOG(LOG1(Result, "%ld", rc))

 return(rc);
}

/* Sound class method: TMM_Activate */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION SoundClassActivate
static ULONG SoundClassActivate(Class *cl, Object *obj)
{
 struct SoundClassData *scd = TYPED_INST_DATA(cl, obj);

 SOUNDCLASS_LOG(LOG0(Entry))

 /* Send ARexx command */
 if (scd->scd_Command) SendARexxCommand(scd->scd_Command,
                                        strlen(scd->scd_Command));

 /* Return 1 to indicate that the method is implemented */
 return(1);
}

/* Sound class dispatcher */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION SoundClassDispatcher
static __geta4 ULONG SoundClassDispatcher(__A0 Class *cl, __A2 Object *obj,
                                          __A1 Msg msg)
{
 ULONG rc;

 SOUNDCLASS_LOG(LOG3(Arguments, "Class 0x%08lx Object 0x%08lx Msg 0x%08lx",
                     cl, obj, msg))

 switch(msg->MethodID) {
  /* BOOPSI methods */
  case OM_NEW:
   rc = SoundClassNew(cl, obj, (struct opSet *) msg);
   break;

  case OM_DISPOSE:
   rc = SoundClassDispose(cl, obj, msg);
   break;

  /* TM methods */
  case TMM_ParseIFF:
   rc = SoundClassParseIFF(cl, obj, (struct TMP_ParseIFF *) msg);
   break;

  case TMM_ParseTags:
   rc = SoundClassParseTags(cl, obj, (struct TMP_ParseTags *) msg);
   break;

  case TMM_Activate:
   rc = SoundClassActivate(cl, obj);
   break;

  /* Unknown method -> delegate to SuperClass */
  default:
   rc = DoSuperMethodA(cl, obj, msg);
   break;
 }

 return(rc);
}

/* Create Sound class */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION CreateSoundClass
Class *CreateSoundClass(Class *superclass)
{
 Class *cl;

 SOUNDCLASS_LOG(LOG1(SuperClass, "0x%08lx", superclass))

 /* Create class */
 if (cl = MakeClass(NULL, NULL, superclass, sizeof(struct SoundClassData), 0))

  /* Set dispatcher */
  cl->cl_Dispatcher.h_Entry = (ULONG (*)()) SoundClassDispatcher;

 SOUNDCLASS_LOG(LOG1(Class, "0x%08lx", cl))

 /* Return pointer to class */
 return(cl);
}
