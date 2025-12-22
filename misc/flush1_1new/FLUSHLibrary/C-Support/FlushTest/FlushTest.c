/* Small flush test. */

#include <exec/types.h>
#include <exec/libraries.h>
#include <proto/exec.h>
#include <proto/dos.h>
#include "flush.h"

#define DATA 0xDEADBEEF

struct Library *FlushBase;

void __saveds __asm flushHandler(register __d0 ULONG data)
{
   printf("Handler called with data $%08lx.\n",data);
}

void main(void)
{
   ULONG id;

   if (FlushBase = OpenLibrary("flush.library",0))
   {
      if (id = FlushEnableAnnounce(MODE_HANDLER,flushHandler,DATA,0))
      {
         printf("Flushing...\n");

         FlushDo();

         printf("I did it...\n");

         FlushDisableAnnounce(id);
      }
      else
         printf("FlushEnableAnnounce() failed!\n");

      CloseLibrary(FlushBase);
   }
   else
      printf("flush.library not found!\n");
}
