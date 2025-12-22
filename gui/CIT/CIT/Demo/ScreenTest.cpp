#include <citra/CITGroup.h>
#include <citra/CITButton.h>
#include <citra/CITGetScreenMode.h>

#include <libraries/asl.h>

#define NEWSCREEN (MAIN_STOPMASK<<1)

CITApp Application;

CITScreen        DemoScreen;
CITWindow        DemoWindow;
CITVGroup        winGroup;
CITGetScreenMode screenModeReq;
CITButton        quitButton;

ULONG modeID = DEF_MONITOR;
UBYTE depth = 0;

void CloseEvent();
void ScreenModeReqEvent(ULONG ID,ULONG eventType);
void QuitEvent(ULONG ID,ULONG eventType);

int main(void)
{
  ULONG StopCode;
  BOOL  Error=FALSE;

  DemoScreen.InsObject(DemoWindow,Error);
    DemoWindow.Position(WPOS_CENTERSCREEN);
    DemoWindow.CloseGadget();
    DemoWindow.DragBar();
    DemoWindow.SizeGadget();
    DemoWindow.DepthGadget();
    DemoWindow.IconifyGadget();
    DemoWindow.Activate();
    DemoWindow.Caption("CIT Screen Test");
    DemoWindow.CloseEventHandler(CloseEvent);
    DemoWindow.InsObject(winGroup,Error);
      winGroup.SpaceOuter();
      winGroup.InsObject(screenModeReq,Error);
        screenModeReq.LabelText("ScreenMode:");
        screenModeReq.RequesterTitleText("Select ScreenMode..");
        screenModeReq.EventHandler(ScreenModeReqEvent);
      winGroup.InsObject(quitButton,Error);
        quitButton.Text("Quit");
        quitButton.MaxHeight(30);
        quitButton.EventHandler(QuitEvent);
  do
  {
    DemoScreen.Display(modeID);
    DemoScreen.Depth(depth);

    Application.InsObject(DemoScreen,Error);

    // Ok?
    if( Error )
      return 10;

    StopCode = Application.Run(NEWSCREEN|MAIN_STOPMASK);

    Application.RemObject(DemoScreen);
  }
  while( !(StopCode&MAIN_STOPMASK) );

  return 0;
}

void ScreenModeReqEvent(ULONG ID,ULONG eventType)
{
  ULONG oldModeID;
  UBYTE oldDepth;

  quitButton.Disabled(TRUE);

  oldModeID = screenModeReq.DisplayID();
  oldDepth = screenModeReq.DisplayDepth();
  screenModeReq.ReqScreenMode();
  modeID = screenModeReq.DisplayID();
  depth = screenModeReq.DisplayDepth();

  if( (oldModeID != modeID) || (oldDepth != depth) )
    Application.Stop(NEWSCREEN);

  quitButton.Disabled(FALSE);
}

void QuitEvent(ULONG ID,ULONG eventType)
{
  Application.Stop();
}

void CloseEvent()
{
  Application.Stop();
}
