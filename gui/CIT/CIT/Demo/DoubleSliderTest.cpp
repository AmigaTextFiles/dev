#include <citra/CITGroup.h>
#include <citra/CITButton.h>
#include <citra/CITDoubleSlider.h>

CITApp Application;

CITScreen    DemoScreen;
CITWindow    DemoWindow;
CITVGroup    group;
CITButton    quitButton;
CITDoubleSlider slider;

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
      group.HorizAlignment(LALIGN_RIGHT);
      group.InsObject(slider,Error);
        slider.Text("Slider value %5.1f");
        //slider.TextPosition(NSP_BELOW);
        slider.Level(10);
        slider.Limits(-25,25,0.5);
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
  double num;

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
