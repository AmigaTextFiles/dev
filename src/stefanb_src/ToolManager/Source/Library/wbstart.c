/*
 * wbstart.c  V3.1
 *
 * ToolManager library WB start handling routines
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
static struct Library *WBStartBase;

#ifdef _DCC
/* Varargs stub */
static LONG WBStartTags(Tag tag1, ...)
{
 return(WBStartTagList((struct TagItem *) &tag1));
}
#endif

/* Start a CLI program */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION StartWBProgram
BOOL StartWBProgram(const char *cmd, const char *cdir, ULONG stack, WORD prio,
                    struct AppMessage *msg)
{
 BOOL rc = FALSE;

 WBSTART_LOG(LOG5(Arguments,
                  "Cmd '%s' Dir '%s' Stack %ld Prio %ld Msg 0x%08lx",
                  cmd, cdir, stack, prio, msg))

 /* Open wbstart.library */
 if (WBStartBase = OpenLibrary(WBSTART_NAME, WBSTART_VERSION)) {

  WBSTART_LOG(LOG1(WBStartBase, "0x%08lx", WBStartBase))

  /* Start WB program */
  rc = WBStartTags(WBStart_Name,          cmd,
                   WBStart_DirectoryName, cdir,
                   WBStart_Stack,         stack,
                   WBStart_Priority,      prio,
                   WBStart_ArgumentCount, msg ? msg->am_NumArgs : 0,
                   WBStart_ArgumentList,  msg ? msg->am_ArgList : 0,
                   TAG_DONE)
        == RETURN_OK;

  /* Close library */
  CloseLibrary(WBStartBase);
 }

 WBSTART_LOG(LOG1(Result, "%ld", rc))

 return(rc);
}
