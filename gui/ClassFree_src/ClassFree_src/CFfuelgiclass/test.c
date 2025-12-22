/* Small test proggy for my listviewclass */

#include <clib/alib_protos.h>
#include <proto/exec.h>
#include <proto/graphics.h>
#include <proto/intuition.h>
#include <proto/dos.h>
#include <intuition/intuition.h>
#include <intuition/gadgetclass.h>
#include <intuition/imageclass.h>
#include <stdio.h>
#include "CFbutton.h"
#include "CFfuelgi.h"

#define QUIT_G   0
#define NUM_GADS 1


struct Library *CFBbase;
struct Library *CFfgbase;

void main(void)
{
  struct Window *win;
  struct Gadget *glist, *tgad, *gads[NUM_GADS];
  struct Image *img;
  struct IntuiMessage *imsg;
  BOOL breakflag = FALSE;
  LONG pos,iclass;

  CFBbase = OpenLibrary("Gadgets/CFbutton.gadget",NULL);
  CFfgbase = OpenLibrary("CFfuelg.image",NULL);

//  if(lvbase) printf("Class opened\n");

  win = OpenWindowTags(NULL,
  		WA_Left, 200,
  		WA_Width,400,WA_Height,200,
  		WA_IDCMP, IDCMP_GADGETUP,
  		TAG_DONE);
  SetAPen(win->RPort,1);


  img = (struct Image *)NewObject(NULL,CFfuelgiClassName,
  		IA_Left, 30, IA_Top, 30,
  		IA_Width, 100, IA_Height, 10,
  		CFFG_Max,  300,
  		CFFG_Label, "Loading",
  		TAG_DONE);


  gads[QUIT_G] = (struct Gadget *)NewObject(NULL,CFbuttonClassName,
  		GA_Left, 200, GA_Top, 90,
  		GA_Width, 50, GA_Height, 20,
  		GA_Text, "Quit",
  		GA_RelVerify, TRUE,
  		GA_ID, QUIT_G,
  		TAG_DONE);

  glist = gads[0];

  AddGList(win,glist,-1,-1,NULL);
  RefreshGadgets(glist,win,NULL);

  pos = 0;
  while(pos<300)
  {
    DrawImageState(win->RPort,img,0,0,pos,NULL);
    Delay(5);
    pos += 40;
  }
  DrawImageState(win->RPort,img,0,0,300,NULL);
  Delay(5);
  DrawImageState(win->RPort,img,0,0,200,NULL);
  Delay(5);
  DrawImageState(win->RPort,img,0,0,100,NULL);
  Delay(5);
  DrawImageState(win->RPort,img,0,0,0,NULL);

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
        }
      }
    }
  }

  RemoveGList(win,glist,-1);
  pos = 0;
  while(pos<NUM_GADS) DisposeObject(gads[pos++]);
  DisposeObject(img);
  CloseWindow(win);
  CloseLibrary(CFBbase);
  CloseLibrary(CFfgbase);
}