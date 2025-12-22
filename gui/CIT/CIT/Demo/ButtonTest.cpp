#include <citra/CITGroup.h>
#include <citra/CITText.h>
#include <citra/CITButton.h>

CITApp Application;

CITWorkbench DemoScreen;
CITWindow    DemoWindow;
CITVGroup    group;
CITText      text;
CITButton    quitButton;
CITButton    okButton;

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
    DemoWindow.Caption("CITGadgets");
    DemoWindow.CloseEventHandler(CloseEvent);
    DemoWindow.InsObject(group,Error);
      group.BevelStyle();
      group.InsObject(text,Error);
        text.Text("Text Gadget");
      group.InsObject(okButton,Error);
        okButton.Text("Ok");
      group.InsObject(quitButton,Error);
        quitButton.Font("CGTimes.font",24,24);
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
  BOOL Error=FALSE;

  repeatCount++;

  switch( repeatCount )
  {
    case 1:
      DemoScreen.Display(DEF_MONITOR);
      break;
    case 2:
      DemoWindow.Size(300,180);
      break;
    default:
      Application.Stop();
      break;
  }
}
