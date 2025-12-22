/* VRastPort example */

#include <proto/intuition.h>
#include <proto/dos.h>
#include <proto/exec.h>
#include <graphics/rpattr.h>

#include "/vrastport.h"

void InputLoop (void);
void DrawLogo (struct VRastPort *vrp);

struct Window *win;
struct VRastPort *vrp;

void main ()
 {
  /* opening window on Workbench screen */
  
  if (win = OpenWindowTags (NULL,
   WA_Left,47,
   WA_Top,25,
   WA_Width,300,
   WA_Height,250,
   WA_IDCMP,IDCMP_CLOSEWINDOW,
   WA_Title,"VRastPort example",
   WA_ScreenTitle, "VRastPort 2.0 BlaBla Corp. 1998",
   WA_DragBar,TRUE,
   WA_DepthGadget,TRUE,
   WA_CloseGadget,TRUE,
   WA_Activate,TRUE,
   WA_RMBTrap,TRUE,
   WA_SmartRefresh,TRUE,
   TAG_END))
   {
    /* creating VRastPort */
    
    if (vrp = MakeVRastPortTags (
     VRP_RastPort,win->RPort,
     VRP_LeftBound,20,
     VRP_RightBound,280,
     VRP_TopBound,20,
     VRP_BottomBound,230,
     RPTAG_APen,2,
     RPTAG_DrMd,JAM1,
     TAG_END))
     {
      SetVRPAttrs (vrp,RPTAG_APen,2,TAG_END);

			Printf ("Base unit is 0.000001 inch.\n");
			
      DrawLogo (vrp);
      Printf ("75 dpi\n");
      Delay (200);

      SetVRPAttrs (vrp,VRP_XScale,644245,VRP_YScale,644245,TAG_END);
      DrawLogo (vrp);
      Printf ("150 dpi\n");
      Delay (200);

      SetVRPAttrs (vrp,VRP_YScale,322123,TAG_END);
      DrawLogo (vrp);
      Printf ("150x75 dpi\n");
      Delay (200);

      SetVRPAttrs (vrp,VRP_XOffset,-500000,VRP_YOffset,-500000,TAG_END);
      DrawLogo (vrp);
      Printf ("Moving window by 0.5 inch in both axes.\n");
			Delay (200);

			Printf ("END\n");
      FreeVRastPort (vrp);
     }
    InputLoop ();
    CloseWindow (win);
   }
  return;
 }


void InputLoop ()
 {
  struct IntuiMessage *msg;
  ULONG class;

  do 
   {
    WaitPort (win->UserPort);
    msg = (struct IntuiMessage*)GetMsg (win->UserPort);
    class = msg->Class;
    ReplyMsg ((struct Message*)msg);
   }
  while (class != IDCMP_CLOSEWINDOW);

  while (msg = (struct IntuiMessage*)GetMsg (win->UserPort))
    ReplyMsg ((struct Message*)msg);

  return;
 }

void DrawLogo (struct VRastPort *vrp)
	{
		VSetRast (vrp,3);
		SetVRPAttrs (vrp, RPTAG_APen, 2, TAG_END);

		/* Put any vrastport.lib rendering calls here */

		VAreaBox (vrp, 0, 0, 400000, 1000000);
		VAreaBox (vrp, -300000, 700000, 500000, 900000);
		VAreaBox (vrp, 1200000, -140000, 1700000, 800000);
		VDrawEllipse (vrp, 800000, 800000, 300000, 250000);
		SetVRPAttrs (vrp, RPTAG_APen, 1, TAG_END);
		VAreaBox (vrp, 2000000, 1300000, 10000000, 1800000);
		VAreaBox (vrp, 400000, 1800000, 900000, 10000000);
		VAreaEllipse (vrp, 1000000, 50000, 250000, 400000);
		return;
	}
