#include <citra/CITGroup.h>
#include <citra/CITButton.h>
#include <citra/CITSlider.h>

#include <stdlib.h>
#include <iostream.h>


CITApp Application;

CITWorkbench DemoScreen;
CITWindow    DemoWindow;
CITVGroup    winGroup;
CITButton    quitButton;
CITSlider    slider;

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
      winGroup.InsObject(slider,Error);
        slider.Level(0);
        slider.Min(0);
        slider.Max(25);
        slider.Orientation(FREEHORIZ);
        slider.MinHeight(14);
        slider.WeightedHeight(0);
        slider.LabelText("Slider");
      winGroup.InsObject(quitButton,Error);
        quitButton.Text("_Quit");
        quitButton.EventHandler(QuitEvent);

  Application.InsObject(DemoScreen,Error);

  // Ok?
  if( Error )
    return 10;

  Application.Run();

  return 0 ;
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
      slider.Level(15);
      break;
    case 2:
      num = slider.Level();
      break;
    default:
      Application.Stop();
    break;
  }
}
