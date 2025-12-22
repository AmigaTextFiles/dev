#include <citra/CITGroup.h>
#include <citra/CITButton.h>
#include <citra/CITString.h>

#include <intuition/sghooks.h>
#include <stdlib.h>

#define PASSWORDCHAR '*'

char Password[64];

CITApp Application;

CITWorkbench DemoScreen;
CITWindow    DemoWindow;
CITVGroup    winGroup;
CITButton    quitButton;
CITString    stringInput1;
CITString    stringInput2;

void CloseEvent();
void QuitEvent(ULONG ID,ULONG eventType);
ULONG PasswordHook(struct SGWork *sgw,ULONG *msg,ULONG myData);

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
    DemoWindow.Caption("CITString Example");
    DemoWindow.CloseEventHandler(CloseEvent);
    DemoWindow.InsObject(winGroup,Error);
      winGroup.SpaceOuter();
      winGroup.InsObject(stringInput1,Error);
        stringInput1.LabelText("String _1");
        stringInput1.TextVal("Testing");
        stringInput1.MinVisible(10);
        stringInput1.MaxChars(24);
        stringInput1.TabCycle();
      winGroup.InsObject(stringInput2,Error);
        stringInput2.LabelText("String _2");
        stringInput2.MinVisible(10);
        stringInput2.MaxChars(24);
        stringInput2.TabCycle();
        stringInput2.EditHook(&PasswordHook,0);
      winGroup.InsObject(quitButton,Error);
        quitButton.Text("Quit");
        quitButton.EventHandler(QuitEvent);

  Application.InsObject(DemoScreen,Error);

  // Ok?
  if( Error )
    return 11;

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
  char* text;

  switch( ++repeatCount )
  {
    case 1:
      stringInput1.TextVal(Password);
      break;
    case 2:
      text = stringInput1.TextVal();
      break;
    default:
      Application.Stop();
      break;
  }
}

//
// Password Edit Hook
//
ULONG PasswordHook(struct SGWork *sgw,ULONG *msg,ULONG myData)
{
  sgw->BufferPos = sgw->NumChars;

  if(*msg == SGH_KEY)
  {
    switch (sgw->EditOp)
    {
      case EO_INSERTCHAR:
        Password[sgw->BufferPos - 1] = sgw->WorkBuffer[sgw->BufferPos - 1];
        Password[sgw->BufferPos] = '\0';
        sgw->WorkBuffer[sgw->BufferPos - 1] = (UBYTE)PASSWORDCHAR;
        break;
      case EO_DELBACKWARD:
        Password[sgw->BufferPos] = '\0';
        break;
      default:
        sgw->Actions &= ~SGA_USE;
        break;
    }

    sgw->Actions |= SGA_REDISPLAY;
    return( ULONG(~0L) );
  }
  if(*msg == SGH_CLICK)
  {
    sgw->BufferPos = sgw->NumChars;
    return( ULONG(~0L) );
  }
  return(0L);
}
