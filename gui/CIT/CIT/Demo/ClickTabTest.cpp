#include <citra/CITGroup.h>
#include <citra/CITButton.h>
#include <citra/CITClickTabPage.h>
#include <citra/CITString.h>

CITApp Application;

CITWorkbench    myScreen;
CITWindow       myWindow;
CITVGroup       pageGroup[2];
CITVGroup       group;
CITButton       quitButton;
CITClickTabPage clickTab;
CITString       string1,string2,string3;

void CloseEvent();
void QuitEvent(ULONG ID,ULONG eventFlag);

int main(void)
{
  BOOL Error=FALSE;

  myScreen.InsObject(myWindow,Error);
    myWindow.Position(WPOS_CENTERSCREEN);
    myWindow.CloseGadget();
    myWindow.DragBar();
    myWindow.SizeGadget();
    myWindow.DepthGadget();
    myWindow.IconifyGadget();
    myWindow.Caption("CITGadgets");
    myWindow.CloseEventHandler(CloseEvent);
    myWindow.InsObject(group,Error);
      group.BevelStyle();
      group.BevelLabel("A text");
      group.InsObject(clickTab,Error);
        clickTab.NewTab(pageGroup[0],"Tab 1");
          pageGroup[0].InsObject(string1,Error);
            string1.LabelText("Type a text _1:");
            string1.LabelJustification(LJ_RIGHT);
            string1.TextVal("Start");
            string1.MinVisible(10);
            string1.MaxChars(20);
        clickTab.NewTab(pageGroup[1],"Tab 2");
          pageGroup[1].InsObject(string2,Error);
            string2.LabelText("Type text number _2:");
            string2.LabelJustification(LJ_RIGHT);
            string2.TextVal("");
            string2.MinVisible(10);
            string2.MaxChars(20);
          pageGroup[1].InsObject(string3,Error);
            string3.LabelText("Write text _3:");
            string3.LabelJustification(LJ_RIGHT);
            string3.TextVal("");
            string3.MinVisible(10);
            string3.MaxChars(20);
      group.InsObject(quitButton,Error);
        quitButton.Text("Quit");
        quitButton.EventHandler(QuitEvent);

  Application.InsObject(myScreen,Error);

  // Ok?
  if( Error )
    return 10;

  Application.Run();

  Application.RemObject(myScreen);

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
      pageGroup[1].RemObject(string3);
  	   break;
  	 case 2:
  	   {
  	     BOOL Error = FALSE;

        pageGroup[1].InsObject(string3,Error);
      }
  	   break;
	 default:
      Application.Stop();
  }
}
