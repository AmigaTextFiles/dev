/*
 * Hello World!
*/

#include <proto/exec.h>
#include <proto/dos.h>


 
LONG hello(void)
{
  struct DosLibrary *DOSBase;


  if ((DOSBase = (void *)OpenLibrary("dos.library", 36L)))
  {          
    FPuts(Output(), "Hello World!\n");

    CloseLibrary((void *)DOSBase);
  }

  return 0;
}
