#include <citra/CITGroup.h>
#include <citra/CITButton.h>
#include <citra/CITString.h>

#include <stdlib.h>


CITApp Application;

CITWorkbench DemoScreen;
CITWindow    DemoWindow;
CITVGroup    winGroup;
CITButton    quitButton;
CITString    stringInput;

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
      winGroup.BevelLabel("A Bevel Text");
      winGroup.InsObject(stringInput,Error);
        stringInput.LabelText("Type a text:");
        stringInput.LabelJustification(LJ_RIGHT);
        stringInput.TextVal("Start");
        stringInput.MinVisible(10);
        stringInput.MaxChars(20);
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
  char* text;

  switch( ++repeatCount )
  {
    case 1:
      stringInput.TextVal("Hello!");
      break;
    case 2:
      text = stringInput.TextVal();
      break;
    default:
      Application.Stop();
    break;
  }
}
