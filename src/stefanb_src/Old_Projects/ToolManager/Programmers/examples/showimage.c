/*
 * showimage.c  V2.1
 *
 * Show an image file in a ToolManager dock
 *
 * (c) 1990-1993 Stefan Becker
 */

#include <utility/tagitem.h>
#include <utility/hooks.h>
#include <clib/exec_protos.h>
#include <clib/toolmanager_protos.h>
#include <pragmas/exec_pragmas.h>
#include <pragmas/toolmanager_pragmas.h>
#include <stdlib.h>
#include <stdio.h>

extern struct Library *SysBase;
extern struct Library *ToolManagerBase;

char *tool[]={NULL,"a",NULL};

struct TagItem dockti[]={
                         TMOP_Activated, TRUE,
                         TMOP_Centered,  TRUE,
                         TMOP_FrontMost, TRUE,
                         TMOP_Vertical,  FALSE,
                         TMOP_Text,      FALSE,
                         TMOP_Tool,      (ULONG) tool,
                         TAG_DONE
                        };

int main(int argc, char *argv[])
{
 void *handle;

 if (argc<2) {
  printf("Usage: showimage <file>\n");
  exit(20);
 }

 if (handle=AllocTMHandle()) {
  printf("Handle: 0x%08lx\n",handle);

  if (CreateTMObjectTags(handle,"a",TMOBJTYPE_IMAGE,TMOP_File,argv[1],
                                                    TAG_DONE)) {
   printf("Image loaded...\n");

   CreateTMObjectTagList(handle,"b",TMOBJTYPE_DOCK,dockti);
   Wait(0xF000);
  }

  FreeTMHandle(handle);
 }
 return(0);
}
