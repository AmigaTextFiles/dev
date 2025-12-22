/* Small test proggy for my listviewclass */

#include <clib/alib_protos.h>
#include <clib/exec_protos.h>
#include <clib/graphics_protos.h>
#include <clib/intuition_protos.h>
#include <clib/dos_protos.h>
#include <intuition/intuition.h>
#include <intuition/gadgetclass.h>
#include <intuition/imageclass.h>
#include <stdio.h>
#include "CFbutton.h"
#include "CFpumbutton.h"

#define CFPUM_G    0
#define TSTUP_G  1
#define TSTDN_G  2
#define QUIT_G   3
#define NUM_GADS 4


struct Library *CFbbase;
struct Library *CFpumbase;

void main(void)
{
  struct Screen *wb;
  struct DrawInfo *dri;
  struct Window *win;
  struct Gadget *glist, *tgad, *gads[NUM_GADS];
  struct IntuiMessage *imsg;
  char *labels[] = {"Snabel","Tekno","Rykke","Øv","Røvslikker",NULL};
  BOOL breakflag = FALSE;
  LONG pos,iclass;

  CFpumbase = OpenLibrary("CFpumbutton.gadget",NULL);
  CFbbase = OpenLibrary("Gadgets/CFbutton.gadget",NULL);

//  if(lvbase) printf("Class opened\n");

  win = OpenWindowTags(NULL,
  		WA_Left, 200,
  		WA_Width,400,WA_Height,200,
  		WA_IDCMP, IDCMP_GADGETUP,
  		TAG_DONE);
  SetAPen(win->RPort,1);

  wb = LockPubScreen("Workbench");
  dri = GetScreenDrawInfo(wb);

  gads[CFPUM_G] = (struct Gadget *)NewObject(NULL,CFpumbuttonClassName,
  		GA_Left, 30, GA_Top, 30,
  		GA_Width, 100, GA_Height, 20,
  		CFPU_Labels, labels,
  		GA_DrawInfo, dri,
  		GA_ID, CFPUM_G,
  		TAG_DONE);
  FreeScreenDrawInfo(wb,dri);
  UnlockPubScreen(NULL,wb);

  if(!gads[CFPUM_G])
  {
    CloseWindow(win);
    CloseLibrary(CFbbase);
    CloseLibrary(CFpumbase);
    exit(0);
  }
  glist = gads[CFPUM_G];
  gads[TSTUP_G] = (struct Gadget *)NewObject(NULL,CFbuttonClassName,
  		GA_Previous, gads[TSTUP_G-1],
  		GA_Left, 200, GA_Top, 30,
  		GA_Width, 50, GA_Height, 20,
  		GA_Highlight, FALSE,
  		GA_Text, "UP",
  		GA_RelVerify, TRUE,
  		GA_ID, TSTUP_G,
  		TAG_DONE);

  gads[TSTDN_G] = (struct Gadget *)NewObject(NULL,CFbuttonClassName,
  		GA_Previous, gads[TSTDN_G-1],
  		GA_Left, 200, GA_Top, 60,
  		GA_Width, 50, GA_Height, 20,
  		GA_Text, "DOWN",
  		GA_RelVerify, TRUE,
  		GA_ID, TSTDN_G,
  		TAG_DONE);
  gads[QUIT_G] = (struct Gadget *)NewObject(NULL,CFbuttonClassName,
  		GA_Previous, gads[QUIT_G-1],
  		GA_Left, 200, GA_Top, 90,
  		GA_Width, 50, GA_Height, 20,
  		GA_Text, "Quit",
  		GA_RelVerify, TRUE,
  		GA_ID, QUIT_G,
  		TAG_DONE);

//  if(glist) printf("NewObject succeded\n");
//  else printf("Failed to create lvc_object..\n");


  AddGList(win,glist,-1,-1,NULL);
  RefreshGadgets(glist,win,NULL);

  while(!breakflag)
  {
    WaitPort(win->UserPort);
    while(imsg = (struct IntuiMessage *)GetMsg(win->UserPort))
    {
      iclass = imsg->Class;
      tgad = (struct Gadget *)imsg->IAddress;
      pos = imsg->Code;
      ReplyMsg((struct Message *)imsg);
      if(iclass == IDCMP_GADGETUP)
      {
        switch(tgad->GadgetID)
        {
          case QUIT_G: breakflag = TRUE; break;
          case CFPUM_G:
//            printf("Snabel\n");
            break;
/*          case TSTUP_G:
            GetAttr(PGA_Top,gads[SCRL_G],(ULONG *)&pos);
            SetGadgetAttrs(gads[SCRL_G],win,NULL,PGA_Top,pos-1,TAG_DONE);
            break;
          case TSTDN_G:
            GetAttr(PGA_Top,gads[SCRL_G],(ULONG *)&pos);
            SetGadgetAttrs(gads[SCRL_G],win,NULL,PGA_Top,pos+1,TAG_DONE);
            break;*/
        }
      }
    }
  }

  RemoveGList(win,glist,-1);
  pos = 0;
  while(pos<NUM_GADS) DisposeObject(gads[pos++]);
  CloseWindow(win);
  CloseLibrary(CFbbase);
  CloseLibrary(CFpumbase);
}