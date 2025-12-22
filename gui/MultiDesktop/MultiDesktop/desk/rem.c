#include <exec/types.h>
#include <exec/execbase.h>

extern struct ExecBase *SysBase;

void main()
{
 struct Library *lib;

 lib=FindName(&SysBase->LibList,"multidesktop.library");
 if(lib)
  {
   lib->lib_OpenCnt=60000;
   Remove(lib);
   puts("Library entfernt!");
  }
}

