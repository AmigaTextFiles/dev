#include <citra/CITGroup.h>
#include <citra/CITButton.h>
#include <citra/CITGetFont.h>

CITApp Application;

CITWorkbench DemoScreen;
CITWindow    DemoWindow;
CITVGroup    winGroup;
CITGetFont   fontReq;
CITButton    quitButton;

void CloseEvent();
void FontReqEvent(ULONG ID,ULONG eventType);
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
    DemoWindow.Caption("CITGetFont Test");
    DemoWindow.CloseEventHandler(CloseEvent);
    DemoWindow.InsObject(winGroup,Error);
      winGroup.SpaceOuter();
      winGroup.InsObject(fontReq,Error);
        fontReq.MaxHeight(15);
        fontReq.LabelText("Font:");
        fontReq.RequesterTitleText("Select Font..");
        fontReq.EventHandler(FontReqEvent);
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

void FontReqEvent(ULONG ID,ULONG eventType)
{
  fontReq.RequestFont();
}

void QuitEvent(ULONG ID,ULONG eventType)
{
  Application.Stop();
}


int repeatCount = 0;

void CloseEvent()
{
  int mode;

  switch( ++repeatCount )
  {
    case 1:
      fontReq.DrawMode(5);
      break;
    case 2:
      mode = fontReq.DrawMode();
      break;
    default:
      Application.Stop();
    break;
  }
}
