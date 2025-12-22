#include <citra/CITGroup.h>
#include <citra/CITButton.h>
#include <citra/CITGetFile.h>

#include <dos/dosasl.h>
#include <stdlib.h>

CITApp Application;

CITWorkbench DemoScreen;
CITWindow    DemoWindow;
CITVGroup    winGroup;
CITGetFile   fileReq;
CITButton    quitButton;

ULONG filterFunc(struct FileRequest* fReq,struct AnchorPath* anch,ULONG myData);
void  CloseEvent();
void  FileReqEvent(ULONG ID,ULONG eventType);
void  QuitEvent(ULONG ID,ULONG eventType);

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
    DemoWindow.Caption("CITGetFile Test");
    DemoWindow.CloseEventHandler(CloseEvent);
    DemoWindow.InsObject(winGroup,Error);
      winGroup.SpaceOuter();
      winGroup.InsObject(fileReq,Error);
        fileReq.LabelText("File:");
        fileReq.RequesterTitleText("Select File..");
        fileReq.FilterFunc(&filterFunc,0);;
        fileReq.EventHandler(FileReqEvent);
      winGroup.InsObject(quitButton,Error);
        quitButton.Text("Quit");
        quitButton.MaxHeight(30);
        quitButton.EventHandler(QuitEvent);

  Application.InsObject(DemoScreen,Error);

  // Ok?
  if( Error )
    return 10;

  Application.Run();

  return 0;
}

ULONG filterFunc(struct FileRequest* fReq,struct AnchorPath* anch,ULONG myData)
{
  if( *anch->ap_Info.fib_FileName == 'B' )
    return 1;
  else
    return 0;
}

void FileReqEvent(ULONG ID,ULONG eventType)
{
  fileReq.RequestFile();
}

void QuitEvent(ULONG ID,ULONG eventType)
{
  Application.Stop();
}


int repeatCount = 0;

void CloseEvent()
{
  char* file;

  switch( ++repeatCount )
  {
    case 1:
      fileReq.File("alfa");
      break;
    case 2:
      file = fileReq.File();
      break;
    default:
      Application.Stop();
    break;
  }
}
