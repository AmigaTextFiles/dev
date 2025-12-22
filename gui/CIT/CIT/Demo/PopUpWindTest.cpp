#include <citra/CITGroup.h>
#include <citra/CITLabel.h>
#include <citra/CITButton.h>
#include <citra/CITPopUpWindow.h>

CITApp Application;

CITScreen DemoScreen;
CITWindow DemoWindow;
CITVGroup group;
CITButton quitButton;
CITButton popupButton;

void closeEvent();
void popupEvent(ULONG ID,ULONG eventType);
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
      group.BevelLabel("En tekst");
      group.InsObject(popupButton,Error);
        popupButton.Text("Pop Up");
        popupButton.EventHandler(popupEvent);
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

void popupEvent(ULONG ID,ULONG eventType)
{
  CITPopUpWindow popupWd;
  CITLabel       label;

  BOOL Error = FALSE;

  popupWd.Position(100,100);
  popupWd.Size(250,120);
  popupWd.CloseGadget();
  popupWd.Caption("Pop Up");
  popupWd.InsAcceptButton("Ok",Error);
  popupWd.InsCancelButton(Error);
    popupWd.AcceptMinHeight(25);
  popupWd.InsObject(label,Error);
    label.Text("Hello!\n");

  DemoScreen.InsObject(popupWd,Error);

  if( !Error )
  {
    UWORD  retval;

    retval = Application.Run(MAIN_STOPMASK|POPUP_CLOSE|POPUP_ACCEPT|POPUP_CANCEL);

    if( retval & POPUP_ACCEPT )
    {
      // Do something
    }

    DemoScreen.RemObject(popupWd);
  }

}
