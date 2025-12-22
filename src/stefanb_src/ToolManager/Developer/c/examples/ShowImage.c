/*
 * ShowImage.c  V3.1
 *
 * Show an image file in a ToolManager dock
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

#include <dos/dos.h>
#include <utility/tagitem.h>
#include <clib/exec_protos.h>
#include <clib/toolmanager_protos.h>
#include <pragmas/exec_pragmas.h>
#include <pragmas/toolmanager_pragmas.h>
#include <stdlib.h>

extern struct Library *SysBase;

char *Tool[] = {NULL, "Image", NULL};

struct TagItem Dock[] = {
 TMOP_Activated, TRUE,
 TMOP_Border,    TRUE,
 TMOP_Centered,  TRUE,
 TMOP_FrontMost, TRUE,
 TMOP_Images,    TRUE,
 TMOP_Columns,   1,
 TMOP_Tool,      (ULONG) Tool,
 TAG_DONE
};

/* Main entry point */
int main(int argc, char *argv[])
{
 int rc = RETURN_FAIL;

 /* Check argument count */
 if (argc > 1) {
  struct Library *ToolManagerBase;

  /* Open toolmanager.library */
  if (ToolManagerBase = OpenLibrary(TMLIBNAME, 0)) {
   void *handle;

   /* Create handle */
   if (handle = AllocTMHandle()) {

    /* Create image */
    if (CreateTMObjectTags(handle, "Image", TMOBJTYPE_IMAGE,
                                                            TMOP_File, argv[1],
                                                            TAG_DONE)) {

     /* Create dock with image */
     if (CreateTMObjectTagList(handle, "ShowImage", TMOBJTYPE_DOCK, Dock)) {

      /* Wait for CTRL-C/D/E/F */
      Wait(0xF000);

      rc = RETURN_OK;
     }
    }
    FreeTMHandle(handle);
   }
   CloseLibrary(ToolManagerBase);
  }
 }

 return(rc);
}
