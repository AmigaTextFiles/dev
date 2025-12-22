#include "include/gadgets/drag.h"
#include <intuition/gadgetclass.h>
#include <intuition/screens.h>
#include <workbench/workbench.h>

#include <clib/alib_stdio_protos.h>
#include <proto/intuition.h>
#include <proto/exec.h>
#include <proto/icon.h>
#include "proto/drag.h"

struct IntuitionBase *IntuitionBase;
struct Library *IconBase;
struct ClassLibrary *DragBase;
struct Window *win;

main()
{
  struct Gadget *dg[2];
  struct Screen *scr;
  APTR sc,dw,group;
  int i;
  struct MsgPort *dwport;
  struct IntuiMessage *msg;
  struct DropMessage *dmsg;
  struct DiskObject *icon,*icon2,*anim[15];
  struct Image *image1[3],*image2[3],*image3[16];
  char buffer[80];
  BOOL done=FALSE;

  if(DragBase=(struct ClassLibrary*)OpenLibrary("gadgets/drag.gadget",40))
  {
    if( (IntuitionBase=(struct IntuitionBase*)OpenLibrary("intuition.library",37)) &&
        (IconBase=OpenLibrary("icon.library",37)) )
    {
      scr=LockPubScreen(NULL);
      sc=CreateDContext(scr);
      group=NewDragGroup();
      if(win=OpenWindowTags(NULL,WA_Left,100,
                                 WA_Top,100,
                                 WA_Width,200,
                                 WA_Height,200,
                                 WA_Title,(ULONG)"drag&drop-test",
                                 WA_IDCMP,IDCMP_CLOSEWINDOW|IDCMP_MOUSEBUTTONS,
                                 WA_CloseGadget,TRUE,
                                 WA_DragBar,TRUE,
                                 WA_DepthGadget,TRUE,
                                 WA_SimpleRefresh,TRUE,
                                 WA_GimmeZeroZero,TRUE,
                                 WA_NoCareRefresh,TRUE,NULL))
      {
        if( (icon=GetDiskObject("sys:prefs/locale")) &&
            (icon2=GetDiskObject("sys:prefs/palette")) )
        {
          for(i=0;i<15;i++)
          {
            sprintf(buffer,"icons/t%d",i+1);
            anim[i]=GetDiskObject(buffer);
            image3[i]=anim[i]->do_Gadget.GadgetRender;
          }
          image3[15]=NULL;
          image1[0]=icon->do_Gadget.GadgetRender;
          image1[1]=icon->do_Gadget.SelectRender;
          image1[2]=NULL;
          image2[0]=icon2->do_Gadget.GadgetRender;
          image2[1]=icon2->do_Gadget.SelectRender;
          image2[2]=NULL;
          if(dg[0]=NewObject(DragBase->cl_Class,NULL,
                                   GA_Left,20,
                                   GA_Top,20,
                                   GA_ID,0,
                                   DGA_Context,sc,
                                   DGA_DragGroup,group,
                                   DGA_ExtSelect,TRUE,
                                   DGA_DragAnim,image3,
                                   GA_Image,image1[0],
                                   GA_SelectRender,image1[1],
                                   GA_RelVerify,TRUE,
                                   GA_Highlight,(icon->do_Gadget.Flags) & GFLG_GADGHIGHBITS,
                                   NULL))
          {
            if(dg[1]=NewObject(DragBase->cl_Class,NULL,
                                     GA_Left,20,
                                     GA_Top,70,
                                     GA_ID,1,
                                     GA_Previous,(ULONG)dg[0],
                                     DGA_Context,sc,
                                     DGA_DragGroup,group,
                                     DGA_ExtSelect,TRUE,
                                     GA_Image,image2[0],
                                     GA_SelectRender,image2[1],
                                     GA_RelVerify,TRUE,
                                     GA_Highlight,(icon2->do_Gadget.Flags) & GFLG_GADGHIGHBITS,
                                     NULL))
            {
              if(dwport=CreateMsgPort())
              {
                dw=AddDropWindow(sc,1,0,win,dwport);
                AddGList(win,dg[0],-1,2,NULL);
                RefreshGList(dg[0],win,NULL,2);
                while(!done)
                {
                  Wait((1<<win->UserPort->mp_SigBit)|(1<<dwport->mp_SigBit));

                  while(dmsg=(struct DropMessage*)GetMsg(dwport))
                  {
                    struct DragInfo *di=dmsg->dm_DragInfo;
                    WORD woleft=win->LeftEdge + win->BorderLeft;
                    WORD wotop =win->TopEdge + win->BorderTop;

                    while(di)
                    {
                      RemoveGadget(win,dg[di->id]);
                      EraseImage(win->RPort,dg[di->id]->GadgetRender,
                                 dg[di->id]->LeftEdge,dg[di->id]->TopEdge);
                      SetGadgetAttrs(dg[di->id],win,NULL,
                                      GA_Left,di->mouse.X - woleft - di->offset.X,
                                      GA_Top,di->mouse.Y - wotop - di->offset.Y,
                                      NULL);
                      AddGadget(win,dg[di->id],0);
                      di=di->next;
                    }
                    RefreshGadgets(win->FirstGadget,win,NULL);

                    ReplyMsg((struct Message*)dmsg);
                  }

                  while(msg=(struct IntuiMessage*)GetMsg(win->UserPort))
                  {
                    switch (msg->Class)
                    {
                      case IDCMP_CLOSEWINDOW:
                        done=TRUE;
                        break;
                      case IDCMP_MOUSEBUTTONS:
                        if(msg->Code==SELECTDOWN)
                        {
                          SetGadgetAttrs(dg[0],win,NULL,GA_Selected,FALSE,NULL);
                          SetGadgetAttrs(dg[1],win,NULL,GA_Selected,FALSE,NULL);
                        }
                    }
                    ReplyMsg((struct Message*)msg);
                  }
                }
                RemoveGadget(win,dg[0]);
                RemoveGadget(win,dg[1]);
                RemoveDropWindow(dw);
                DeleteMsgPort(dwport);
              }
              DisposeObject(dg[1]);
            }
            DisposeObject(dg[0]);
          }
          if(icon) FreeDiskObject(icon);
          if(icon2) FreeDiskObject(icon2);
          for(i=0;i<15;i++)
            FreeDiskObject(anim[i]);
        }
        CloseWindow(win);
      }
      FreeDragGroup(group);
      DeleteDContext(sc);
      UnlockPubScreen(NULL,scr);

      if(IntuitionBase) CloseLibrary((struct Library*)IntuitionBase);
      if(IconBase) CloseLibrary(IconBase);
    }
    CloseLibrary((struct Library*)DragBase);
  }
}
