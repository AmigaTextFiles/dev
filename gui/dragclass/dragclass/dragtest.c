#include "draggadget.h"
#include <intuition/classes.h>
#include <intuition/gadgetclass.h>
#include <intuition/imageclass.h>
#include <intuition/screens.h>
#include <workbench/workbench.h>

#include <inline/stubs.h>
#include <inline/intuition.h>
#include <inline/exec.h>
#include <inline/icon.h>

struct IntuitionBase *IntuitionBase=NULL;
struct Library *IconBase=NULL;
struct DClassLibrary *DragBase=NULL;

main()
{
  struct Gadget *dg1;
  struct Window *win;
  struct IntuiMessage *msg;
  struct IClass *dc;
  struct DiskObject *icon;
  struct Image *image,*image2;
  BOOL done=FALSE;

  if(DragBase=OpenLibrary("drag.gadget",0))
  {
    dc=DragBase->dcl_DragClass;
    if( (IntuitionBase=(struct IntuitionBase*)OpenLibrary("intuition.library",37)) &&
        (IconBase=OpenLibrary("icon.library",37)) )
    {
      if(win=OpenWindowTags(NULL,WA_Left,100,
                                 WA_Top,100,
                                 WA_Width,200,
                                 WA_Height,200,
                                 WA_Title,"drag&drop-test",
                                 WA_IDCMP,IDCMP_CLOSEWINDOW|IDCMP_GADGETUP|IDCMP_MOUSEBUTTONS,
                                 WA_CloseGadget,TRUE,
                                 WA_DragBar,TRUE,
                                 WA_DepthGadget,TRUE,
                                 WA_NoCareRefresh,TRUE,NULL))
      {
        if(icon=GetDiskObject("sys:Disk"))
        {
          image=icon->do_Gadget.GadgetRender;
          image2=icon->do_Gadget.SelectRender;
          if(dg1=NewObject(dc,NULL,GA_Left,20,
                                   GA_Top,20,
                                   GA_ID,1,
                                   DGA_Screen,win->WScreen,
                                   DGA_ExtSelect,TRUE,
                                   GA_Image,image,
                                   GA_SelectRender,image2,
                                   GA_RelVerify,TRUE,
                                   GA_Highlight,GFLG_GADGHIMAGE,NULL))
          {
            AddGadget(win,dg1,-1);
            RefreshGList(dg1,win,NULL,1);
            while(!done)
            {
              WaitPort(win->UserPort);
              while(msg=GetMsg(win->UserPort))
              {
                switch (msg->Class) {
                  case IDCMP_CLOSEWINDOW:
                    done=TRUE;
                    break;
                  case IDCMP_GADGETUP:
                    {
                      struct DragInfo *dr=(struct DragInfo*)((struct Gadget*)msg->IAddress)->SpecialInfo;
                      printf("Gadget %d up; x: %d, y: %d\n",((struct Gadget*)msg->IAddress)->GadgetID,
                                                            dr->mouse.X,dr->mouse.Y);
                    }
                    break;
                  case IDCMP_MOUSEBUTTONS:
                    if(msg->Code==SELECTDOWN)
                      SetGadgetAttrs(dg1,win,NULL,GA_Selected,FALSE,NULL);
                }
                ReplyMsg(msg);
              }
            }
            RemoveGadget(win,dg1);
            DisposeObject(dg1);
          }
          FreeDiskObject(icon);
        }
        CloseWindow(win);
      }
      if(IntuitionBase) CloseLibrary((struct Library*)IntuitionBase);
      if(IconBase) CloseLibrary(IconBase);
    }
    CloseLibrary(DragBase);
  }
}
