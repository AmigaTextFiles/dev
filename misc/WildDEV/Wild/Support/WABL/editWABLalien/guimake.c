/*
**	EditWABL gui init/kill.
*/

#include <wabl.h>
#include <exec/exec.h>
#include <exec/libraries.h>
#include <dos/dos.h>
#include <utility/tagitem.h>
#include <utility/hooks.h>
#include <inline/dos.h>
#include <inline/intuition.h>
#include <intuition/intuition.h>

extern struct ExecBase *SysBase;
extern struct Library *DOSBase;
extern struct Library *IntuitionBase;
extern ULONG *wi_view;

ULONG InitGui()
 {
  static const struct TagItem tags[]={	{WA_Left,20},{WA_Top,20},
  					{WA_Width,500},{WA_Height,300},
  					{WA_CloseGadget,TRUE},{WA_SizeGadget,TRUE},
  					{WA_DragBar,TRUE},{WA_DepthGadget,TRUE},
  					{WA_Activate,TRUE},{WA_GimmeZeroZero,TRUE},
  					{WA_PubScreen,0},{0,0}};
  if (wi_view=OpenWindowTagList(NULL,tags))
   {
    return(TRUE);
   } // VIEWWINDOW
  return(FALSE); 
 }       

void KillGui()
 {
  if (wi_view)
   {CloseWindow(wi_view);
    wi_view=NULL;}    
 }