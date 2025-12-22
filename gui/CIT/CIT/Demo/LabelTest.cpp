#include <citra/CITGroup.h>
#include <citra/CITLabel.h>

#include <intuition/screens.h>
#include <stdlib.h>

__chip UWORD image_data[] =
{
  /* Plane 0 */
  0x0000, 0x0000,
  0x7F00, 0x0000,
  0x4180, 0x0000,
  0x4140, 0x0000,
  0x4120, 0x4000,
  0x41F0, 0x6000,
  0x401B, 0xF000,
  0x401B, 0xF800,
  0x401B, 0xF000,
  0x4018, 0x6000,
  0x4018, 0x4000,
  0x4018, 0x0000,
  0x4018, 0x0000,
  0x7FF8, 0x0000,
  0x1FF8, 0x0000,
  0x0000, 0x0000,
  /* Plane 1 */
  0x0000, 0x0000,
  0x0000, 0x0000,
  0x3E00, 0x0000,
  0x3E80, 0x0000,
  0x3EC0, 0x0000,
  0x3E00, 0x0000,
  0x3FE0, 0x0000,
  0x3FE0, 0x0000,
  0x3FE0, 0x0000,
  0x3FE0, 0x0000,
  0x3FE0, 0x0000,
  0x3FE0, 0x0000,
  0x3FE0, 0x0000,
  0x0000, 0x0000,
  0x0000, 0x0000,
  0x0000, 0x0000
};

struct Image image =
{
  0, 0, 22, 16, 2, image_data, 0x03, 0x00, NULL
};

UWORD map[] = {BACKGROUNDPEN,SHADOWPEN};
//UWORD map[] = {10,11};

CITApp Application;

CITWorkbench DemoScreen;
CITWindow    DemoWindow;
CITHGroup    winGroup;
CITLabel     label;

void CloseEvent();

int main(void)
{
  BOOL Error=FALSE;

  DemoScreen.InsObject(DemoWindow,Error);
    DemoWindow.Position(30,30);
    DemoWindow.Size(250,120);
    DemoWindow.CloseGadget();
    DemoWindow.DragBar();
    DemoWindow.DepthGadget();
    DemoWindow.Activate();
    DemoWindow.SizeGadget();
    DemoWindow.IconifyGadget();
    DemoWindow.Caption("CITGadgets");
    DemoWindow.CloseEventHandler(CloseEvent);
    DemoWindow.InsObject(winGroup,Error);
      winGroup.InsObject(label,Error);
        label.Justification(LABEL_CENTRE);
        label.Text("_Under-scored\nNot under-scored\n");
        label.Text("\n\nemerald.font\n");
          label.Font("emerald.font",18);
          label.FGPen(3);
        label.Image(&image);
          label.Mapping(map);

  Application.InsObject(DemoScreen,Error);

  // Ok?
  if( Error )
    return 10;

  Application.Run();

  Application.RemObject(DemoScreen);

  return 0;
}

int repeatCount = 0;

void CloseEvent()
{
  switch( ++repeatCount )
  {
    case 1:
      DemoWindow.Position(50,50);
      break;
    case 2:
      DemoWindow.Size(300,180);
      break;
    default:
      Application.Stop();
    break;
  }
}
