#include <citra/CITGroup.h>
#include <citra/CITButton.h>
#include <citra/CITFileRequest.h>

CITApp Application;

CITScreen DemoScreen;
CITWindow DemoWindow;
CITVGroup group;
CITButton quitButton;
CITButton fileReqButton;

void closeEvent();
void fileReqEvent(ULONG ID,ULONG eventType);
void quitEvent(ULONG ID,ULONG eventType);

int main(void)
{
  BOOL Error=FALSE;

  DemoScreen.Display("Workbench");
  DemoScreen.InsObject(DemoWindow,Error);
    DemoWindow.Position(30,30);
    DemoWindow.CloseGadget();
    DemoWindow.DragBar();
    DemoWindow.DepthGadget();
    DemoWindow.Activate();
    DemoWindow.SizeGadget();
    DemoWindow.IconifyGadget();
    DemoWindow.Caption("CITGadgets");
    DemoWindow.CloseEventHandler(closeEvent);
    DemoWindow.InsObject(group,Error);
      group.BevelStyle();
      group.InsObject(fileReqButton,Error);
        fileReqButton.Text("Select file..");
        fileReqButton.EventHandler(fileReqEvent);
      group.InsObject(quitButton,Error);
        quitButton.Text("Quit");
        quitButton.EventHandler(quitEvent);


  Application.InsObject(DemoScreen,Error);

  if( Error )
    return 10;
  else
  {
    Application.Run();
    return 0;
  }
}

void closeEvent()
{
  Application.Stop();
}

void quitEvent(ULONG ID,ULONG eventType)
{
  Application.Stop();
}

void fileReqEvent(ULONG ID,ULONG eventType)
{
  CITFileRequest frWd;

  BOOL Error = FALSE;

  frWd.Position(100,100);
  frWd.Size(250,120);
  frWd.CloseGadget();
  //frWd.SaveRequest();
  //frWd.DirRequest();
  frWd.FullPath("Sys:Devs/printer.device");
  frWd.Pattern("#?.device");

  DemoScreen.InsObject(frWd,Error);

  if( !Error )
  {
    UWORD  retval;

    retval = Application.Run(MAIN_STOPMASK|POPUP_CLOSE|POPUP_ACCEPT|POPUP_CANCEL);

    if( retval & POPUP_ACCEPT )
    {
      // Do something
    }
  }

  DemoScreen.RemObject(frWd);
}
