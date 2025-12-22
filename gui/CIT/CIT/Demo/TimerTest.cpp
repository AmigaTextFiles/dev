#include <citra/CITTimer.h>
#include <citra/CITGroup.h>
#include <citra/CITButton.h>
#include <citra/CITFuelGauge.h>

CITApp Application;

CITTimer     timer;
CITWorkbench DemoScreen;
CITWindow    DemoWindow;
CITVGroup    winGroup;
CITFuelGauge fuel;
CITButton    quitButton;


void timerEvent();
void CloseEvent();
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
    DemoWindow.Caption("CITTimer Test");
    DemoWindow.CloseEventHandler(CloseEvent);
    DemoWindow.InsObject(winGroup,Error);
      winGroup.SpaceOuter();
      winGroup.InsObject(fuel,Error);
        fuel.LabelText("Level");
      winGroup.InsObject(quitButton,Error);
        quitButton.Text("Quit");
        quitButton.MaxHeight(30);
        quitButton.EventHandler(QuitEvent);

  Application.InsObject(timer,Error);
  Application.InsObject(DemoScreen,Error);

  // Ok?
  if( Error )
    return 10;

  timer.AddEvent(0.2,timerEvent,0);

  Application.Run();

  return 0;
}


int value = 0;
int step  = 1;

void timerEvent()
{
  value += step;
  if( value > 100 )
  {
    step = -step;
    value = 100 + step;
  }
  else if( value < 0 )
  {
    step = -step;
    value = step;
  }

  fuel.Level(value);
  timer.AddEvent(0.2,timerEvent,0);
}

void QuitEvent(ULONG ID,ULONG eventType)
{
  Application.Stop();
}

void CloseEvent()
{
  Application.Stop();
}
