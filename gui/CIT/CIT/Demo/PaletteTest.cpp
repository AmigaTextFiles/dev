#include <citra/CITGroup.h>
#include <citra/CITButton.h>
#include <citra/CITPalette.h>

CITApp Application;

CITWorkbench DemoScreen;
CITWindow    DemoWindow;
CITVGroup    winGroup;
CITPalette   palette;
CITButton    quitButton;

void CloseEvent();
void QuitEvent(ULONG ID,ULONG eventType);

int main(void)
{
  BOOL Error=FALSE;

  DemoScreen.InsObject(DemoWindow,Error);
    DemoWindow.CloseGadget();
    DemoWindow.DragBar();
    DemoWindow.SizeGadget();
    DemoWindow.DepthGadget();
    DemoWindow.IconifyGadget();
    DemoWindow.Activate();
    DemoWindow.Caption("CITPalette Test");
    DemoWindow.CloseEventHandler(CloseEvent);
    DemoWindow.InsObject(winGroup,Error);
      winGroup.SpaceOuter();
      winGroup.InsObject(palette,Error);
        palette.MinWidth(200);
        palette.MinHeight(150);
        palette.NumColours(256);
      winGroup.InsObject(quitButton,Error);
        quitButton.Text("Quit");
        quitButton.MaxHeight(20);
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
  int num;

  switch( ++repeatCount )
  {
    case 1:
      palette.Colour(5);
      break;
    case 2:
      num = palette.Colour();
      break;
    default:
      Application.Stop();
    break;
  }
}
