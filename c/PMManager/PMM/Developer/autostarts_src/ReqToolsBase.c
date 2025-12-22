#include <stdio.h>
#include <exec/libraries.h>
#include <proto/exec.h>

struct Library *ReqToolsBase = NULL;

void _INIT_5_ReqToolsBase()
{
  if (!(ReqToolsBase = OpenLibrary("reqtools.library",0))) {
    exit(20);
  }
}

void _EXIT_5_ReqToolsBase()
{
  if (ReqToolsBase)
    CloseLibrary(ReqToolsBase);
}
