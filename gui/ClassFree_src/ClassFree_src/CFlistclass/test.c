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
#include "CFlist.h"
#include "CFbutton.h"

#define CFB_G    0
#define TSTUP_G  1
#define TSTDN_G  2
#define QUIT_G   3
#define NUM_GADS 4


struct Library *CFBbase;
struct Library *CFLbase;

void main(void)
{
  struct Window *win;
  struct Gadget *glist, *tgad, *gads[NUM_GADS];
  struct IntuiMessage *imsg;
  struct List list;
  struct Node node[5];
  char *label[] = {"Numme","Snabel","Tester","Rygge","Arrrg"};
  BOOL breakflag = FALSE;
  LONG pos,iclass;

  CFBbase = OpenLibrary("Gadgets/CFbutton.gadget",NULL);
  CFLbase = OpenLibrary("CFlist.gadget",NULL);

//  if(lvbase) printf("Class opened\n");

  win = OpenWindowTags(NULL,
  		WA_Left, 200,
  		WA_Width,400,WA_Height,200,
  		WA_IDCMP, IDCMP_GADGETUP,
  		TAG_DONE);
  SetAPen(win->RPort,1);

  NewList(&list);
  pos = 0;
  while(pos<5)
  {
    node[pos].ln_Name = label[pos];
    AddTail(&list,&node[pos]);
    pos++;
  }

  gads[CFB_G] = (struct Gadget *)NewObject(NULL,CFlistClassName,
  		GA_Left, 30, GA_Top, 30,
  		GA_Width, 70, GA_Height, 60,
  		CFL_Labels, &list,
  		CFL_Top, 1,
  		CFL_Selected, 2,
  		GA_ID, CFB_G,
  		TAG_DONE);
  if(!gads[CFB_G])
  {
    CloseWindow(win);
    CloseLibrary(CFLbase);
    CloseLibrary(CFBbase);
    exit(0);
  }
  glist = gads[CFB_G];
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
  		CFBU_Layout, LAYOUT_TXTLEFT,
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
          case CFB_G:
            printf("Code returned: %ld\n",pos);
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
  CloseLibrary(CFBbase);
  CloseLibrary(CFLbase);
}