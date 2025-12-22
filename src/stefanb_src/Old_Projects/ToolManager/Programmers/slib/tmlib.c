
#include <exec/libraries.h>

#include <proto/exec.h> 
#include <proto/toolmanager.h>

extern void __regargs __autoopenfail(char *);

struct Library *ToolManagerBase;
static struct Library *LibBase;

void __stdargs _STI_OpenToolMan(void)

{
 ToolManagerBase=LibBase=OpenLibrary("toolmanager.library",3L);
 if (ToolManagerBase==NULL) __autoopenfail("toolmanager.library");
}

void __stdargs _STD_CloseToolMan(void)

{
 if (LibBase)
  {
   CloseLibrary (LibBase);
   LibBase=ToolManagerBase=NULL;
  }
}
