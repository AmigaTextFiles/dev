#include <citra/CITGroup.h>
#include <citra/CITButton.h>
#include <citra/CITScroller.h>

#include <stdlib.h>
#include <iostream.h>


CITApp Application;

CITWorkbench DemoScreen;
CITWindow    DemoWindow;
CITVGroup    winGroup;
CITButton    quitButton;
CITScroller  scroller;

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
      winGroup.BevelLabel("En tekst");
      winGroup.InsObject(scroller,Error);
        scroller.Top(30);
        scroller.Total(90);
        scroller.Visible(10);
        scroller.Orientation(FREEHORIZ);
        scroller.MinHeight(14);
        scroller.WeightedHeight(0);
        scroller.LabelText("Scroller");
      winGroup.InsObject(quitButton,Error);
        quitButton.Text("_Quit");
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
  short num;

  switch( ++repeatCount )
  {
    case 1:
      scroller.Top(55);
      break;
    case 2:
      num = scroller.Top();
      break;
    default:
      Application.Stop();
    break;
  }
}
