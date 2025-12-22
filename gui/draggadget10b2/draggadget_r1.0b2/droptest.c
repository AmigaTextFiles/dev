#include "include/gadgets/drag.h"
#include <intuition/gadgetclass.h>

#include <proto/intuition.h>
#include <proto/exec.h>
#include <proto/icon.h>
#include "proto/drag.h"

struct IntuitionBase *IntuitionBase;
struct Library *IconBase;
struct ClassLibrary *DragBase;

static ULONG __saveds __asm Dispatcher(register __a0 struct IClass *class,
                                       register __a2 Object *obj,
                                       register __a1 Msg msg );

struct ClassLibrary *fstrc;

struct IClass *CreateSClass(void)
{
  struct IClass *cl=NULL;

  if(fstrc=(struct ClassLibrary*)OpenLibrary("gadgets/string.gadget",40))
    if(cl=MakeClass(NULL,NULL,fstrc->cl_Class,0,0))
      cl->cl_Dispatcher.h_Entry=(HOOKFUNC)Dispatcher;
  return cl;
}

void FreeSClass(struct IClass *c)
{
  if(c)
    FreeClass(c);
  if(fstrc)
    CloseLibrary((struct Library*)fstrc);
}

main()
{
  struct Gadget *dg1,*dg2;
  struct Gadget *str;
  struct Window *win,*win2=NULL;
  APTR context,dw2;
  struct IntuiMessage *msg;
  struct IClass *dc,*strc=NULL;
  struct DiskObject *icon,*icon2=NULL;
  struct Image *image,*image2,*image3,*image4;
  BOOL done=FALSE;

  if(DragBase=(struct ClassLibrary*)OpenLibrary("gadgets/drag.gadget",40))
  {
    dc=DragBase->cl_Class;

    if( (IntuitionBase=(struct IntuitionBase*)OpenLibrary("intuition.library",37)) &&
        (IconBase=OpenLibrary("icon.library",37)) &&
        (strc=CreateSClass()) )
    {
      if((win=OpenWindowTags(NULL,WA_Left,100,
                                  WA_Top,100,
                                  WA_Width,200,
                                  WA_Height,120,
                                  WA_MaxWidth,~0,
                                  WA_MaxHeight,~0,
                                  WA_Title,(ULONG)"drag&drop-test",
                                  WA_IDCMP,IDCMP_CLOSEWINDOW,
                                  WA_CloseGadget,TRUE,
                                  WA_SizeGadget,TRUE,
                                  WA_DragBar,TRUE,
                                  WA_DepthGadget,TRUE,
                                  WA_SimpleRefresh,TRUE,
                                  WA_NoCareRefresh,TRUE,NULL)) &&
        (win2=OpenWindowTags(NULL,WA_Left,320,
                                  WA_Top,120,
                                  WA_Width,200,
                                  WA_Height,80,
                                  WA_Title,(ULONG)"string",
                                  WA_DragBar,TRUE,
                                  WA_DepthGadget,TRUE,
                                  WA_SimpleRefresh,TRUE,
                                  WA_NoCareRefresh,TRUE,NULL)))
      {
        context=CreateDContext(win->WScreen);
        dw2=AddDropWindow(context,2,0,win2,NULL);

        if( (icon=GetDiskObject("sys:prefs/locale")) &&
            (icon2=GetDiskObject("sys:prefs/palette")) )
        {
          image=icon->do_Gadget.GadgetRender;
          image2=icon->do_Gadget.SelectRender;
          image3=icon2->do_Gadget.GadgetRender;
          image4=icon2->do_Gadget.SelectRender;
          if(dg1=NewObject(dc,NULL,GA_RelRight,-180,
                                   GA_RelBottom,-100,
                                   GA_ID,1,
                                   GA_UserData,(ULONG)"sys:prefs/locale",
                                   DGA_Context,context,
                                   GA_Image,(ULONG)image,
                                   GA_SelectRender,(ULONG)image2,
                                   GA_Highlight,(icon->do_Gadget.Flags) & GFLG_GADGHIGHBITS,
                                   NULL))
          {
            if(dg2=NewObject(dc,NULL,GA_RelRight,-180,
                                     GA_RelBottom,-50,
                                     GA_ID,2,
                                     GA_UserData,(ULONG)"sys:prefs/palette",
                                     GA_Previous,(ULONG)dg1,
                                     DGA_Context,context,
                                     GA_Image,(ULONG)image3,
                                     GA_SelectRender,(ULONG)image4,
                                     GA_Highlight,(icon2->do_Gadget.Flags) & GFLG_GADGHIGHBITS,
                                     NULL))
            {
              if(str=NewObject(strc,NULL,GA_Left,20,
                                         GA_Top,40,
                                         GA_Width,140,
                                         GA_Height,19,
                                         GA_ID,3,
                                         STRINGA_TextVal,(ULONG)"",
                                         STRINGA_MaxChars,SG_DEFAULTMAXCHARS-1,
                                         NULL))
              {
                AddGList(win,dg1,-1,-1,NULL);
                RefreshGList(dg1,win,NULL,-1);
                AddGList(win2,str,-1,-1,NULL);
                RefreshGList(str,win2,NULL,-1);
                while(!done)
                {
                  WaitPort(win->UserPort);
                  while(msg=(struct IntuiMessage*)GetMsg(win->UserPort))
                  {
                    if(msg->Class==IDCMP_CLOSEWINDOW)
                        done=TRUE;

                    ReplyMsg((struct Message*)msg);
                  }
                }
                RemoveGList(win,dg1,-1);
                RemoveGList(win2,str,-1);

                DisposeObject(str);
              }
              DisposeObject(dg2);
            }
            DisposeObject(dg1);
          }
        }
        if(icon) FreeDiskObject(icon);
        if(icon2) FreeDiskObject(icon2);

        RemoveDropWindow(dw2);
        DeleteDContext(context);
      }
      if(win)CloseWindow(win);
      if(win2)CloseWindow(win2);
    }
    if(strc) FreeSClass(strc);
    if(IntuitionBase) CloseLibrary((struct Library*)IntuitionBase);
    if(IconBase) CloseLibrary(IconBase);

    CloseLibrary((struct Library*)DragBase);
  }
}

static ULONG __saveds __asm Dispatcher(register __a0 struct IClass *class,
                                       register __a2 Object *obj,
                                       register __a1 Msg msg )
{
  ULONG ret=DoSuperMethodA(class,obj,msg);

  if(msg->MethodID == OM_DROPACTION)
  {
    struct opDropAction *dm=(struct opDropAction*)msg;
    struct TagItem attrs[2];

    attrs[0].ti_Tag=STRINGA_TextVal;
    attrs[0].ti_Data=(ULONG)(dm->opda_DragInfo->userdata);
    attrs[1].ti_Tag=NULL;

    ret=DoMethod(obj,OM_SET,attrs,dm->opda_GInfo);
  }

  return ret;
}
