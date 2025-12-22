#include <citra/CITGroup.h>
#include <citra/CITButton.h>
#include <citra/CITInteger.h>

#include <stdlib.h>


CITApp Application;

CITWorkbench DemoScreen;
CITWindow    DemoWindow;
CITVGroup    winGroup;
CITButton    quitButton;
CITInteger   integerInput;

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
    DemoWindow.Caption("CITGadgets");
    DemoWindow.CloseEventHandler(CloseEvent);
    DemoWindow.InsObject(winGroup,Error);
      winGroup.BevelStyle();
      winGroup.BevelLabel("A text");
      winGroup.InsObject(integerInput,Error);
        integerInput.LabelText("Type a number:");
        integerInput.LabelJustification(LJ_RIGHT);
        integerInput.Arrows();
        integerInput.Minimum(-32);
        integerInput.Maximum(32);
        integerInput.Number(0);
        integerInput.MinVisible(10);
        integerInput.MaxChars(20);
      winGroup.InsObject(quitButton,Error);
        quitButton.Text("Quit");
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
      integerInput.Number(27);
      break;
    case 2:
      num = integerInput.Number();
      break;
    default:
      Application.Stop();
    break;
  }
}
