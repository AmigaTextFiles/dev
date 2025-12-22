;/*
sc LINK GetColor.c NOSTACKCHECK
quit
*/

#define __USE_SYSBASE
#include <reaction/reaction_macros.h>
#include <classes/window.h>
#include <gadgets/layout.h>
#include <gadgets/button.h>
#include <gadgets/getcolor.h>
#include <clib/alib_protos.h>
#include <proto/window.h>
#include <proto/layout.h>
#include <proto/button.h>
#include <proto/getcolor.h>
#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/intuition.h>
#include <stdio.h>

/* Note that getcolor.gadget and programs that use it (like this one)
   need some free pens to work properly. */

enum
{
   GID_GETCOLOR1 = 1,
   GID_GETCOLOR2
};

struct Library *WindowBase, *LayoutBase, *ButtonBase, *GetColorBase;


int main(void)
{
   Object *windowobj = NULL;
   struct Screen *scr;
   struct Window *win;
   struct Gadget *getcolor[2], *display;
   ULONG input, id, waitmask, result;
   UWORD code;
   BOOL done = FALSE;
   TEXT buffer[80];

   WindowBase = OpenLibrary("window.class",0);
   LayoutBase = OpenLibrary("Gadgets/layout.gadget",0);
   ButtonBase = OpenLibrary("Gadgets/button.gadget",0);
   GetColorBase = OpenLibrary("Gadgets/getcolor.gadget",0);

   if (WindowBase && LayoutBase && ButtonBase && GetColorBase)
   {
      if (scr = LockPubScreen(NULL))
      {
         windowobj = WindowObject,
            WA_IDCMP, IDCMP_CLOSEWINDOW | IDCMP_GADGETUP,
            WA_Activate, TRUE,
            WA_CloseGadget, TRUE,
            WA_Title, "GetColor Test",
            WA_DragBar, TRUE,
            WA_DepthGadget, TRUE,
            WA_SizeGadget, TRUE,
            WINDOW_Position, WPOS_CENTERSCREEN,
            WINDOW_ParentGroup, VGroupObject,
               LAYOUT_SpaceOuter, TRUE,
               LAYOUT_DeferLayout, TRUE,
               LAYOUT_FixedVert, FALSE,
               LAYOUT_AddChild, HGroupObject,
                  LAYOUT_AddChild, getcolor[0] = GetColorObject,
                     GA_ID, GID_GETCOLOR1,
                     GA_RelVerify, TRUE,
                     GETCOLOR_Screen, scr,
                     GETCOLOR_Color, 0x0045AF56,
                  GetColorEnd,

                  LAYOUT_AddChild, HGroupObject,
                  EndGroup,
                  CHILD_WeightedWidth, 0,
                  CHILD_MinWidth, 4,

                  LAYOUT_AddChild, getcolor[1] = GetColorObject,
                     GA_ID, GID_GETCOLOR2,
                     GA_RelVerify, TRUE,
                     GETCOLOR_Screen, scr,
                     GETCOLOR_Color, 0x00FF0000,
                     GETCOLOR_SwitchMode, FALSE,
                     GETCOLOR_ShowHSB, TRUE,
                  GetColorEnd,
               EndGroup,
               CHILD_WeightedHeight, 0,

               LAYOUT_AddChild, display = ButtonObject,
                  GA_ReadOnly, TRUE,
                  GA_Text, "Select a color",
                  BUTTON_DomainString, "Last selection: RGB MMM, MMM, MMM ($MMMMMM)",
               ButtonEnd,
               CHILD_WeightedHeight, 0,
            EndGroup,
         WindowEnd;

         UnlockPubScreen(NULL,scr);
      }

      if (windowobj)
      {
         if (win = (struct Window *)RA_OpenWindow(windowobj))
         {
            GetAttr(WINDOW_SigMask,windowobj,&waitmask);

            /* Event handling */

            while (!done)
            {
               Wait(waitmask);

               while ((input = RA_HandleInput(windowobj,&code)) != WMHI_LASTMSG)
               {
                  switch (input & WMHI_CLASSMASK)
                  {
                     case WMHI_CLOSEWINDOW:
                        done = TRUE;
                        break;

                     case WMHI_GADGETUP:

                        switch (id = (input & WMHI_GADGETMASK))
                        {
                           case GID_GETCOLOR1:
                           case GID_GETCOLOR2:

                              if (DoMethod((Object *)getcolor[id - GID_GETCOLOR1],GCOLOR_REQUEST,win))
                              {
                                 GetAttr(GETCOLOR_Color,getcolor[id - GID_GETCOLOR1],&result);
                                 sprintf(buffer,"Last selection: RGB %3ld, %3ld, %3ld ($%06lX)",
                                         (result >> 16) & 0xFF,(result >> 8) & 0xFF,result & 0xFF,result);
                                 SetGadgetAttrs(display,win,NULL,GA_Text,buffer,TAG_END);
                              }

                              break;
                        }

                        break;
                  }
               }
            }

            RA_CloseWindow(windowobj);
         }

         DisposeObject(windowobj);
      }
   }

   CloseLibrary(GetColorBase);
   CloseLibrary(ButtonBase);
   CloseLibrary(LayoutBase);
   CloseLibrary(WindowBase);

   return (RETURN_OK);
}


