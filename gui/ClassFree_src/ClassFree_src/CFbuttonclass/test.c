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

#define CFB_G    0
#define TSTUP_G  1
#define TSTDN_G  2
#define QUIT_G   3
#define NUM_GADS 4


struct Library *CFBbase;
struct Library *btnbase;

void main(void)
{
  struct Screen *wb;
  struct DrawInfo *wb_dri;
  struct Window *win;
  struct Gadget *glist, *tgad, *gads[NUM_GADS];
  struct Image *img;
  struct IntuiMessage *imsg;
  BOOL breakflag = FALSE;
  LONG pos,iclass;

  CFBbase = OpenLibrary("CFbutton.gadget",NULL);
  btnbase = OpenLibrary("gadgets/button.gadget",NULL);

//  if(lvbase) printf("Class opened\n");

  win = OpenWindowTags(NULL,
  		WA_Left, 200,
  		WA_Width,400,WA_Height,200,
  		WA_IDCMP, IDCMP_GADGETUP,
  		TAG_DONE);
  SetAPen(win->RPort,1);

  wb = LockPubScreen("Workbench");
  wb_dri = GetScreenDrawInfo(wb);

  img = (struct Image *)NewObject(NULL,SYSICLASS,
  		IA_Left, 0, IA_Top, 0,
  		SYSIA_DrawInfo, wb_dri,
  		SYSIA_Which, DOWNIMAGE,
  		SYSIA_Size, SYSISIZE_MEDRES,
  		TAG_DONE);

  FreeScreenDrawInfo(wb,wb_dri);
  UnlockPubScreen(NULL,wb);

  gads[CFB_G] = (struct Gadget *)NewObject(NULL,CFbuttonClassName,
  		GA_Left, 30, GA_Top, 30,
  		GA_Width, 70, GA_Height, 25,
  		GA_Immediate, TRUE,
  		GA_RelVerify, TRUE,
  		GA_Highlight, TRUE,
  		GA_Border, FALSE,
  		GA_Text, "Snabel",
  		GA_Image, img,
  		CFBU_Layout, LAYOUT_IMGABOVE,
  		GA_ID, CFB_G,
  		TAG_DONE);
  if(!gads[CFB_G])
  {
    CloseWindow(win);
    CloseLibrary(btnbase);
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
  		GA_ToggleSelect, TRUE,
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
      if(iclass == IDCMP_GADGETDOWN)
      {
        printf("Gadget up from CFB\n");
        switch(tgad->GadgetID)
        {
          case CFB_G:
            break
        }
      }
      if(iclass == IDCMP_GADGETUP)
      {
        switch(tgad->GadgetID)
        {
          case QUIT_G: breakflag = TRUE; break;
          case CFB_G:
            printf("Snabel\n");
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
  DisposeObject(img);
  CloseWindow(win);
  CloseLibrary(CFBbase);
  CloseLibrary(btnbase);
}