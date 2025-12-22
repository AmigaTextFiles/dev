//
// Weighted demo
//
#include <citra/CITGroup.h>
#include <citra/CITButton.h>

#include <images/bevel.h>

CITApp Application;

CITWorkbench WeightedScreen;
CITWindow    WeightedWindow;

CITVGroup winGroup;
CITHGroup hTopGroup,fixedAndFreeGroup,hBotGroup;
CITHGroup horizGroup;
CITVGroup vertGroup;

CITButton vEmpty1,vEmpty2,vEmpty3;
CITButton hEmpty1,hEmpty2,hEmpty3;
CITButton w25,w50,w75,w100;
CITButton free1,fixed1,free2,fixed2;

void closeEvent();

int main(void)
{
  BOOL Error=FALSE;

  WeightedScreen.InsObject(WeightedWindow,Error);
    WeightedWindow.Position(1);
    WeightedWindow.CloseGadget();
    WeightedWindow.DragBar();
    WeightedWindow.SizeGadget();
    WeightedWindow.DepthGadget();
    WeightedWindow.Activate();
    WeightedWindow.Caption("CIT Weighted Layout Example");
    WeightedWindow.CloseEventHandler(closeEvent);
    WeightedWindow.InsObject(winGroup,Error);
      winGroup.BevelStyle(BVS_GROUP);
      winGroup.SpaceOuter();
      winGroup.InsObject(hTopGroup,Error);
        hTopGroup.SpaceOuter();
        hTopGroup.InsObject(horizGroup,Error);
          horizGroup.SpaceOuter();
          horizGroup.BevelStyle(BVS_GROUP);
          horizGroup.BevelLabel("Horizontal");
          horizGroup.InsObject(vEmpty1,Error);
          horizGroup.InsObject(vEmpty2,Error);
          horizGroup.InsObject(vEmpty3,Error);
        hTopGroup.InsObject(vertGroup,Error);
          vertGroup.SpaceOuter();
          vertGroup.BevelStyle(BVS_GROUP);
          vertGroup.BevelLabel("Vertictal");
          vertGroup.InsObject(hEmpty1,Error);
          vertGroup.InsObject(hEmpty2,Error);
          vertGroup.InsObject(hEmpty3,Error);
      winGroup.InsObject(fixedAndFreeGroup,Error);
        fixedAndFreeGroup.BevelStyle(BVS_SBAR_VERT);
        fixedAndFreeGroup.BevelLabel("Free, Fixed and Weighted sizes.");
        fixedAndFreeGroup.WeightedHeight(0);
        fixedAndFreeGroup.InsObject(w25,Error);
          w25.Text("25kg");
          w25.WeightedWidth(25);
        fixedAndFreeGroup.InsObject(w50,Error);
          w50.Text("50kg");
          w50.WeightedWidth(50);
        fixedAndFreeGroup.InsObject(w75,Error);
          w75.Text("75kg");
          w75.WeightedWidth(75);
        fixedAndFreeGroup.InsObject(w100,Error);
          w100.Text("100kg");
          w100.WeightedWidth(100);
      winGroup.InsObject(hBotGroup,Error);
        hBotGroup.WeightedHeight(0);
        hBotGroup.MinWidth(300);
        hBotGroup.InsObject(free1,Error);
          free1.Text("Free");
        hBotGroup.InsObject(fixed1,Error);
          fixed1.Text("Fixed");
          fixed1.WeightedWidth(0);
        hBotGroup.InsObject(free2,Error);
          free2.Text("Free");
        hBotGroup.InsObject(fixed2,Error);
          fixed2.Text("Fixed");
          fixed2.WeightedWidth(0);

  Application.InsObject(WeightedScreen,Error);

  if( Error )
    return 10;

  Application.Run();

  return 0;
}

void closeEvent()
{
  Application.Stop();
}
