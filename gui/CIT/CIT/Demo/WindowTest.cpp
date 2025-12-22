#include <citra/CITWindow.h>

CITApp Application;

CITWorkbench myScreen;
CITWindow    myWindow;

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
    myWindow.IconifyGadget();
    myWindow.Caption("WindowTest");
    myWindow.CloseEventHandler(CloseEvent);

  Application.InsObject(myScreen,Error);

  // Ok?
  if( Error )
    return 10;

  Application.Run();

  return 0;
}

int repeatCount = 0;

void CloseEvent()
{
  switch(++ repeatCount )
  {
    case 1:
      myWindow.Position(50,50);
      break;
    case 2:
      myWindow.Size(300,180);
      break;
    default:
      Application.Stop();
      break;
  }
}
