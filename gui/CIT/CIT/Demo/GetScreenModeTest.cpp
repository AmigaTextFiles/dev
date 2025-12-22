#include <citra/CITGroup.h>
#include <citra/CITButton.h>
#include <citra/CITGetScreenMode.h>

#include <libraries/asl.h>

CITApp Application;

CITWorkbench     DemoScreen;
CITWindow        DemoWindow;
CITVGroup        winGroup;
CITGetScreenMode screenModeReq;
CITButton        quitButton;

ULONG filterFunc(struct ScreenModeRequester* smReq,ULONG modeID,ULONG myData);
void CloseEvent();
void ScreenModeReqEvent(ULONG ID,ULONG eventType);
void QuitEvent(ULONG ID,ULONG eventType);

int main(void)
{
  BOOL Error=FALSE;

  DemoScreen.InsObject(DemoWindow,Error);
    DemoWindow.Position(WPOS_CENTERSCREEN);
    DemoWindow.CloseGadget();
    DemoWindow.DragBar();
    DemoWindow.SizeGadget();
    DemoWindow.DepthGadget();
    DemoWindow.IconifyGadget();
    DemoWindow.Activate();
    DemoWindow.Caption("CITGetScreenMode Test");
    DemoWindow.CloseEventHandler(CloseEvent);
    DemoWindow.InsObject(winGroup,Error);
      winGroup.SpaceOuter();
      winGroup.InsObject(screenModeReq,Error);
        screenModeReq.LabelText("ScreenMode:");
        screenModeReq.RequesterTitleText("Select ScreenMode..");
        screenModeReq.EventHandler(ScreenModeReqEvent);
        screenModeReq.FilterFunc(&filterFunc,0);
      winGroup.InsObject(quitButton,Error);
        quitButton.Text("Quit");
        quitButton.MaxHeight(30);
        quitButton.EventHandler(QuitEvent);

  Application.InsObject(DemoScreen,Error);

  // Ok?
  if( Error )
    return 10;

  Application.Run();

  return 0;
}

ULONG filterFunc(struct ScreenModeRequester* smReq,ULONG modeID,ULONG myData)
{
  if( TRUE )  // Make a more interesting filter
    return 1;
  else
    return 0;
}

void ScreenModeReqEvent(ULONG ID,ULONG eventType)
{
  quitButton.Disabled(TRUE);
  screenModeReq.ReqScreenMode();
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
