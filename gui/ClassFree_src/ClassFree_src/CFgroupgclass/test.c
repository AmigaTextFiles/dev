/* Small test proggy for my listviewclass */

#include <clib/alib_protos.h>
#include <clib/exec_protos.h>
#include <clib/graphics_protos.h>
#include <clib/intuition_protos.h>
#include <clib/dos_protos.h>
#include <intuition/intuition.h>
#include <intuition/gadgetclass.h>
#include <intuition/imageclass.h>
#include <intuition/icclass.h>
#include <stdio.h>
#include "CFscroller.h"
#include "CFbutton.h"

#define CFSCR_G  0
#define TSTUP_G  1
#define TSTDN_G  2
#define QUIT_G   3
#define NUM_GADS 4


struct Library *CFSCRbase;
struct Library *btnbase;

void main(void)
{
  struct Screen *wb;
  struct DrawInfo *wb_dri;
  struct Window *win;
  struct Gadget *glist, *tgad, *gads[NUM_GADS];
  struct IntuiMessage *imsg;
  BOOL breakflag = FALSE;
  LONG pos,iclass;

  printf("Test started.\n");

  CFSCRbase = OpenLibrary("CFscroller.gadget",NULL);
  btnbase = OpenLibrary("Gadgets/CFbutton.gadget",NULL);

  if(!CFSCRbase) printf("Error! Could not open test class\n");

  win = OpenWindowTags(NULL,
  		WA_Left, 200,
  		WA_Width,400,WA_Height,200,
  		WA_IDCMP, IDCMP_GADGETUP|IDCMP_GADGETDOWN|IDCMP_MOUSEMOVE
  			|IDCMP_IDCMPUPDATE,
  		TAG_DONE);
  SetAPen(win->RPort,1);

  wb = LockPubScreen("Workbench");
  wb_dri = GetScreenDrawInfo(wb);

  gads[CFSCR_G] = (struct Gadget *)NewObject(NULL,CFscrollerClassName,
  		GA_Left, 30, GA_Top, 30,
  		GA_Width, 120,
  		GA_DrawInfo, wb_dri,
  		GA_RelVerify, TRUE,
  		ICA_TARGET, ICTARGET_IDCMP,
//  		CFSC_Size, SIZE_HIRES,
  		CFSC_Freedom, FREEHORIZ,
  		CFSC_Total, 30, CFSC_Top, 1, CFSC_Visible, 4,
  		GA_ID, CFSCR_G,
  		TAG_DONE);

  FreeScreenDrawInfo(wb,wb_dri);
  UnlockPubScreen(NULL,wb);

  if(!gads[CFSCR_G])
  {
//    printf("Error! Did not get test object.\n");
    CloseWindow(win);
    CloseLibrary(btnbase);
    CloseLibrary(CFSCRbase);
    exit(0);
  }
  glist = gads[CFSCR_G];
  gads[TSTUP_G] = (struct Gadget *)NewObject(NULL,CFbuttonClassName,
  		GA_Previous, gads[TSTUP_G-1],
  		GA_Left, 200, GA_Top, 30,
  		GA_Width, 50, GA_Height, 20,
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
      switch(iclass)
      {
        case IDCMP_IDCMPUPDATE:
          printf("Update recieved\n");
          break;
        case IDCMP_MOUSEMOVE:
          printf("Mousemove recieved\n");
          break;
        case IDCMP_GADGETDOWN:
          printf("Gadgeytdown recieved\n");
          break;
        case IDCMP_GADGETUP:
          switch(tgad->GadgetID)
          {
            case QUIT_G: breakflag = TRUE; break;
            case CFSCR_G:
              printf("Scroller up, PGA_Top: %ld \n",pos);
              break;
            default:
              printf("Button up\n");
              break;
/*          case TSTUP_G:
              GetAttr(PGA_Top,gads[SCRL_G],(ULONG *)&pos);
              SetGadgetAttrs(gads[SCRL_G],win,NULL,PGA_Top,pos-1,TAG_DONE);
              break;
            case TSTDN_G:
              GetAttr(PGA_Top,gads[SCRL_G],(ULONG *)&pos);
              SetGadgetAttrs(gads[SCRL_G],win,NULL,PGA_Top,pos+1,TAG_DONE);
              break;*/
          } /* switch GadgetID */
      } /* switch iclass */
    } /* while imsg */
  } /* while !breakflag */

  RemoveGList(win,glist,-1);
  pos = 0;
  while(pos<NUM_GADS) DisposeObject(gads[pos++]);
  CloseWindow(win);
  CloseLibrary(CFSCRbase);
  CloseLibrary(btnbase);
}