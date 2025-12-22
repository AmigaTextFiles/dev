#include <citra/CITGroup.h>
#include <citra/CITButton.h>
#include <citra/CITRadioButton.h>

#include <stdlib.h>

CITApp Application;

CITWorkbench   DemoScreen;
CITWindow      DemoWindow;
CITVGroup      winGroup;
CITRadioButton rb;
CITButton      quitButton;

char* text[] = {"300","600","1200","2400","4800","9600",NULL};

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
    DemoWindow.Caption("CITRadioButton Test");
    DemoWindow.CloseEventHandler(CloseEvent);
    DemoWindow.InsObject(winGroup,Error);
      winGroup.SpaceOuter();
      winGroup.InsObject(rb,Error);
        rb.Labels(text);
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
      rb.Selected(3);
      break;
    case 2:
      num = rb.Selected();
      break;
    default:
      Application.Stop();
    break;
  }
}
