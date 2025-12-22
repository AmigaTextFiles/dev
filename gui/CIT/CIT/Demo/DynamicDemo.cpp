//
// Dynamic demo
//
#include <citra/CITGroup.h>
#include <citra/CITButton.h>
#include <citra/CITCheckBox.h>

#include <libraries/gadtools.h>

CITApp Application;

CITWorkbench DynamicScreen;
CITWindow    DynamicWindow;
CITVGroup    winGroup;
CITHGroup    topGroup,botGroup;
CITButton    quitButton;
CITButton    rplButton;
CITButton    remButton;
CITButton    addButton;
CITButton    largeButton;
CITCheckBox  checkBox;

void closeEvent();
void quitEvent(ULONG ID,ULONG eventType);
void rplEvent(ULONG ID,ULONG eventType);
void remEvent(ULONG ID,ULONG eventType);
void addEvent(ULONG ID,ULONG eventType);

int main()
{
  BOOL Error=FALSE;

  DynamicScreen.InsObject(DynamicWindow,Error);
    DynamicWindow.Position(1);
    DynamicWindow.CloseGadget();
    DynamicWindow.DragBar();
    DynamicWindow.SizeGadget();
    DynamicWindow.DepthGadget();
    DynamicWindow.IconifyGadget();
    DynamicWindow.IconTitle("DynamicDemo");
    DynamicWindow.Activate();
    DynamicWindow.Caption("CIT Dynamic Layout Example");
    DynamicWindow.CloseEventHandler(closeEvent);
    DynamicWindow.InsObject(winGroup,Error);
      winGroup.InsObject(botGroup,Error);
        botGroup.EvenSize();
        botGroup.InsObject(addButton,Error);
          addButton.Text("_AddChild");
          addButton.EventHandler(addEvent);
        botGroup.InsObject(remButton,Error);
          remButton.Text("_RemoveChild");
          remButton.EventHandler(remEvent);
          remButton.Disabled();
        botGroup.InsObject(rplButton,Error);
          rplButton.Text("ReplaceChild");
          rplButton.EventHandler(rplEvent);
          rplButton.Disabled();
        botGroup.InsObject(quitButton,Error);
          quitButton.Text("_Quit");
          quitButton.EventHandler(quitEvent);

  //
  // To be inserted after user request
  //
  topGroup.Inverted();
  topGroup.InsObject(largeButton,Error);
    largeButton.Text("Peekaboo!");

  checkBox.Text("Peekaboo!");
  checkBox.TextPlace(PLACETEXT_RIGHT);

  Application.InsObject(DynamicScreen,Error);

  // Ok?
  if( Error )
    return 10;

  Application.Run();

  Application.RemObject(DynamicScreen);

  return 0;
}

void closeEvent()
{
  Application.Stop();
}

void rplEvent(ULONG ID,ULONG eventType)
{
  if( topGroup.Inserted() )
  {
  	 BOOL Error = FALSE;

    if( largeButton.Inserted() )
    {
  	   topGroup.RemObject(largeButton);
      topGroup.InsObject(checkBox,Error);
    }
    else
    {
    	topGroup.RemObject(checkBox);
  	   topGroup.InsObject(largeButton,Error);
  	 }
  }
}

void remEvent(ULONG ID,ULONG eventType)
{
  winGroup.RemObject(topGroup);

  addButton.Disabled(FALSE);
  remButton.Disabled(TRUE);
  rplButton.Disabled(TRUE);
}

void addEvent(ULONG ID,ULONG eventType)
{
  BOOL Error = FALSE;

  winGroup.InsObject(topGroup,Error);

  addButton.Disabled(TRUE);
  remButton.Disabled(FALSE);
  rplButton.Disabled(FALSE);
}

void quitEvent(ULONG ID,ULONG eventType)
{
  Application.Stop();
}
