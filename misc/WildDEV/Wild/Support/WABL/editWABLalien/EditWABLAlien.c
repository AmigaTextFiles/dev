/*
**	EditWABL: Simple editing funcs.
*/

#include <wabl.h>
#include <exec/exec.h>
#include <exec/libraries.h>
#include <dos/dos.h>
#include <utility/tagitem.h>
#include <utility/hooks.h>
#include <inline/dos.h>
#include <inline/intuition.h>

extern struct ExecBase *SysBase;
extern struct Library *DOSBase;
extern struct Library *IntuitionBase;

#define	ARG_WABLINPUT	0

ULONG 	*outfh,*wi_view;

extern ULONG InitGui();
extern void KillGui();

ULONG ReadHook( register struct Hook* hook __asm("a0"), register ULONG object __asm("a2"), register ULONG message __asm("a1"))
{
 return(FGetC(object));
}

int main()
{
 ULONG *rda,arg[1];
 if (rda=ReadArgs("WABL/A",&arg,0))
  {
   ULONG *fh;
   if (fh=Open(arg[ARG_WABLINPUT],MODE_OLDFILE))
    {
     struct WABL *wabl;
     struct Hook gethook;
     struct TagItem loadtags[3]={{WABL_FileHandle,fh},{WABL_GetCharHook,&gethook},{0,0}};
     gethook.h_Entry=&ReadHook;
     if (wabl=LoadWABL((struct TagItem*)loadtags))
      {
       outfh=Output();
       if (InitGui())
        {
         InitWABLDisplay(wabl,wi_view);
         RefreshWABLDisplay(wabl,wi_view);
         DrawWABLDisplay(wabl,wi_view);

         KillGui();
        } // GUI
       FreeWABL(wabl);
      }
     Close(fh); 
    }
  }
}

