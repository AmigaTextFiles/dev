#include <citra/CITGroup.h>
#include <citra/CITButton.h>
#include <citra/CITDouble.h>

#include <stdlib.h>


CITApp Application;

CITWorkbench DemoScreen;
CITWindow    DemoWindow;
CITVGroup    winGroup;
CITButton    quitButton;
CITDouble    doubleInput;

void CloseEvent();
void QuitEvent(ULONG ID,ULONG eventFlag);

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
    DemoWindow.Caption("Click to set");
    DemoWindow.CloseEventHandler(CloseEvent);
    DemoWindow.InsObject(winGroup,Error);
      winGroup.BevelStyle();
      winGroup.BevelLabel("A text");
      winGroup.InsObject(doubleInput,Error);
        doubleInput.LabelText("Type a _Number:");
        doubleInput.LabelJustification(LJ_RIGHT);
        doubleInput.Number(3.14159);
        doubleInput.MinVisible(10);
        doubleInput.MaxChars(20);
      winGroup.InsObject(quitButton,Error);
        quitButton.Text("Quit");
        quitButton.EventHandler(QuitEvent);

  Application.InsObject(DemoScreen,Error);

  // Ok?
  if( Error )
    return 11;

  Application.Run();

  Application.RemObject(DemoScreen);
  return 0;
}

void QuitEvent(ULONG ID,ULONG eventFlag)
{
  Application.Stop();
}


int repeatCount = 0;

void CloseEvent()
{
  switch( ++repeatCount )
  {
    case 1:
      doubleInput.Number(27.12345);
      break;
    default:
      Application.Stop();
    break;
  }
}
