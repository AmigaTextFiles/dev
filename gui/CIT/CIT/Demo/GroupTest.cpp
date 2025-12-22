#include <citra/CITGroup.h>

CITApp Application;

CITWorkbench myScreen;
CITWindow    myWindow;
CITHGroup    winGroup;

void CloseEvent();

int main()
{
  BOOL Error=FALSE;

  myScreen.InsObject(myWindow,Error);
    myWindow.Position(30,30);
    myWindow.Size(250,120);
    myWindow.CloseGadget();
    myWindow.DragBar();
    myWindow.DepthGadget();
    myWindow.Activate();
    myWindow.SizeGadget();
    myWindow.Caption("CITGroup");
    myWindow.CloseEventHandler(&CloseEvent);
    myWindow.AppWindow();
    myWindow.InsObject(winGroup,Error);
      winGroup.BevelLabel("A text");
      winGroup.BevelStyle();

  Application.InsObject(myScreen,Error);

  // Ok?
  if( Error )
    return 10;

  Application.Run();

  return 0;
}

void CloseEvent()
{
  Application.Stop();
}
