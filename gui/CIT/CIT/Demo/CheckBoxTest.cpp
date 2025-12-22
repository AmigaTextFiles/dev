#include <citra/CITGroup.h>
#include <citra/CITButton.h>
#include <citra/CITCheckBox.h>

#include <libraries/gadtools.h>

#include <stdlib.h>
#include <iostream.h>


CITApp Application;

CITWorkbench DemoScreen;
CITWindow    DemoWindow;
CITVGroup    winGroup;
CITButton    quitButton;
CITCheckBox  checkBox;

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
    DemoWindow.Caption("Click to check");
    DemoWindow.CloseEventHandler(CloseEvent);
    DemoWindow.InsObject(winGroup,Error);
      winGroup.BevelStyle();
      winGroup.BevelLabel("A text");
      winGroup.InsObject(checkBox,Error);
        checkBox.Text("_Check Me");
        checkBox.TextPlace(PLACETEXT_RIGHT);
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
      checkBox.Checked(TRUE);
      DemoWindow.Caption("Click to uncheck");
      break;
    case 2:
      checkBox.Checked(FALSE);
      break;
    default:
      Application.Stop();
    break;
  }
}
