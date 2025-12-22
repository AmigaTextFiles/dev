/*
 * workbench.c  V2.1
 *
 * open & close icon/workbench.library
 *
 * (c) 1990-1993 Stefan Becker
 */

#include "ToolManagerLib.h"

/* Data */
static ULONG WBCount=0;
struct Library *WorkbenchBase=NULL;

/* Try to open workbench.library */
BOOL GetWorkbench(void)
{
 /* Workbench already open or can we open it? */
 if (WorkbenchBase || (WorkbenchBase=OpenLibrary("workbench.library",37)))
  {
   /* Increment WB counter */
   WBCount++;
   DEBUG_PRINTF("WorkbenchBase 0x%08lx ",WorkbenchBase);
   DEBUG_PRINTF("(Count %2ld)\n",WBCount);

   /* All OK */
   return(TRUE);
  }

 /* Call failed */
 return(FALSE);
}

/* Try to close workbench.library */
void FreeWorkbench(void)
{
 /* Decrement WB counter and close workbench.library if zero */
 if (--WBCount==0) {
  CloseLibrary(WorkbenchBase);
  WorkbenchBase=NULL;
 }
}
