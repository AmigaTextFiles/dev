#include <stdio.h>
#include <exec/libraries.h>
#include <proto/exec.h>

struct Library *IntuiSupBase = NULL;

void _INIT_5_IntuiSupBase()
{
  if (!(IntuiSupBase = OpenLibrary("Intuisup.library",0))) {
    exit(20);
  }
}

void _EXIT_5_IntuiSupBase()
{
  if (IntuiSupBase)
    CloseLibrary(IntuiSupBase);
}
