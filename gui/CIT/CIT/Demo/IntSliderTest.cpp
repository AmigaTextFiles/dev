#include <citra/CITGroup.h>
#include <citra/CITButton.h>
#include <citra/CITIntSlider.h>

CITApp Application;

CITScreen    DemoScreen;
CITWindow    DemoWindow;
CITVGroup    group;
CITButton    quitButton;
CITIntSlider slider;

void CloseEvent();
void QuitEvent(ULONG ID,ULONG eventType);

int main(void)
{
  BOOL Error=FALSE;

  DemoScreen.Display("Workbench");
  DemoScreen.InsObject(DemoWindow,Error);
    DemoWindow.Size(300,50);
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
      group.BevelLabel("En tekst");
      group.HorizAlignment(LALIGN_RIGHT);
      group.InsObject(slider,Error);
        slider.Text("Slider value %3.d");
        //slider.TextPosition(NSP_BELOW);
        slider.Limits(-10,80,5);
        slider.Level(30);
        //slider.KnobDelta(15);
        //slider.TickSize(10);
        slider.Orientation(FREEHORIZ);
        slider.MinHeight(14);
        //slider.MaxWidth(100);
        //slider.WeightedHeight(0);
      group.InsObject(quitButton,Error);
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
      slider.Level(70);
      break;
    case 2:
      num = slider.Level();
      break;
    default:
      Application.Stop();
    break;
  }
}
