#include <exec/types.h>
#include <intuition/intuition.h>
#include <graphics/gfx.h>

#include <clib/exec_protos.h>
#include <clib/graphics_protos.h>
#include <clib/intuition_protos.h>
#include <clib/gadtools_protos.h>

#include <stdio.h>
#include "progress.h"

struct Screen   *PR_Mysc=NULL;
struct Window   *PR_Mywin=NULL;
UWORD           PR_Topborder;
BYTE ProgressHere=0;

int OpenMyWindow(void);
int CloseMyWindow(void);

int Progress(int Got, int OutOf)
{
  switch(ProgressHere)
  {
    case 0:   
          if(OpenMyWindow())
          {
            ProgressHere=1;
          }
          else
          {
            ProgressHere=2;
          }
         break; 
    case 1:
          RectFill(PR_Mywin->RPort,PR_Mywin->BorderLeft,PR_Topborder,(int)((float)Got/OutOf*195),(PR_Topborder<<1)-1);

          break;

    default:
           break;
  }
          
  return 1;
}

int OpenMyWindow(void)
{
  void            *vi;

  if ( (PR_Mysc = LockPubScreen(NULL)) )
  {
    if ( (vi = GetVisualInfo(PR_Mysc, TAG_END)) )
    {
      PR_Topborder = PR_Mysc->WBorTop + (PR_Mysc->Font->ta_YSize + 1);
      if ((PR_Mywin = OpenWindowTags(NULL,
                      WA_Title,     "Progress",
                      WA_AutoAdjust,    TRUE,
                      WA_Width,       200,      WA_MinWidth,        50,
                      WA_InnerHeight, PR_Topborder,  WA_MinHeight,       6,
                      WA_DragBar,    TRUE,      WA_DepthGadget,   TRUE,
                      WA_Activate,   TRUE,      WA_CloseGadget,   FALSE,
                      WA_SizeGadget, FALSE,      WA_SimpleRefresh, FALSE,
                      WA_IDCMP, 0,
                      WA_PubScreen, PR_Mysc,
                      TAG_END)))
      {
        return 1;   /*did it*/
      }
    }
  }
  return 0; /*failed*/
}

int FinishProgress(void)
{
  CloseMyWindow();
  ProgressHere=0;
  return 1;
}

int CloseMyWindow(void)
{
  if(PR_Mysc) UnlockPubScreen(NULL, PR_Mysc);
  if(PR_Mywin) CloseWindow(PR_Mywin);
  PR_Mysc=NULL;
  PR_Mywin=NULL;
  return 1;
}

