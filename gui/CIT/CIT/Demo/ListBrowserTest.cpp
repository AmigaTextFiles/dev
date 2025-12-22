#include <citra/CITGroup.h>
#include <citra/CITButton.h>
#include <citra/CITListBrowser.h>

#include <stdlib.h>

char* text[] = {"Line 1","Line 2","Long line 3","Line 4","Line 5",NULL};

ColumnInfo ci[] = { {25,"Col 1",0} , {-1,STRPTR(~0L),-1} };

CITApp Application;

CITWorkbench   DemoScreen;
CITWindow      DemoWindow;
CITVGroup      winGroup;
CITHGroup      lbGroup;
CITListBrowser lb;
CITButton      quitButton;

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
    DemoWindow.Activate();
    DemoWindow.Caption("CITListBrowser Test");
    DemoWindow.CloseEventHandler(CloseEvent);
    DemoWindow.InsObject(winGroup,Error);
      winGroup.SpaceOuter();
      winGroup.InsObject(lbGroup,Error);
        lbGroup.InsObject(lb,Error);
          lb.MinWidth(100);
          lb.Labels(text);
          lb.ColumnInfo(ci);
          lb.ShowSelected();
      winGroup.InsObject(quitButton,Error);
        quitButton.Text("Quit");
        quitButton.MaxHeight(20);
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

void CloseEvent()
{
  Application.Stop();
}
