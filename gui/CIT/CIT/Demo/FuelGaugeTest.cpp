#include <citra/CITGroup.h>
#include <citra/CITButton.h>
#include <citra/CITFuelGauge.h>

CITApp Application;

CITWorkbench DemoScreen;
CITWindow    DemoWindow;
CITVGroup    winGroup;
CITFuelGauge fuel;
CITButton    quitButton;

void  CloseEvent();
void  QuitEvent(ULONG ID,ULONG eventType);

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
    DemoWindow.Caption("CITFuelGauge Test");
    DemoWindow.CloseEventHandler(CloseEvent);
    DemoWindow.InsObject(winGroup,Error);
      winGroup.SpaceOuter();
      winGroup.InsObject(fuel,Error);
        fuel.LabelText("Level");
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

void QuitEvent(ULONG ID,ULONG eventType)
{
  Application.Stop();
}


int repeatCount = 0;

void CloseEvent()
{
  switch( ++repeatCount )
  {
    case 1:
      fuel.Level(25);
      break;
    case 2:
      fuel.Level(fuel.Level()+25);
      break;
    default:
      Application.Stop();
    break;
  }
}
