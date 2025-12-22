// **********************************
// HTMLtext-DEMO
// (C)opyright by Dirk Holtwick, 1997
// **********************************

// This demo is kind of a WYSIWYG editor for HTML.
// Just edit the string in the gadget and you will
// see the effect in the same moment.

// If you have problems, please report me the bug
// and send me the text that leaded to confusion.

/// Includes
#include <workbench/startup.h>
#include <clib/alib_protos.h>
#include <proto/dos.h>
#include <proto/exec.h>
#include <proto/intuition.h>
#include <proto/graphics.h>
#include <proto/asl.h>
#include <proto/utility.h>
#include <proto/muimaster.h>
#include <proto/icon.h>
#include <stdio.h>
#include <string.h>
#include <mui/HTMLtext_mcc.h>

#define MAKE_ID(a,b,c,d) ((ULONG) (a)<<24 | (ULONG) (b)<<16 | (ULONG) (c)<<8 | (ULONG) (d))

extern struct Library *SysBase;

/*  ATTENTION !!!
**  HTMLtext.mcc makes use of recursion and so you
**  have to take care, that there is always
**  enough space on the stack. The more the better!
*/

LONG __stack = 8192;
///

/// Demotext
#define DEMOTEXT \
   "<html>This <i>is a <small>small</small> <big>Demo</big></i> of " \
   "the <b>HTMLtext class.</b><br> "\
   "Try to drop a HTML file in this window! " \
   "<p align=right>Yours Dirk</html>"
///
/// Pointers
APTR app;
APTR window;
APTR str;
APTR html;
APTR scroll;
APTR url;
///

/// OpenURLHook
__saveds ULONG __asm OpenURL(register __a0 struct Hook *h, register __a2 Object *obj, register __a1 struct{ char *url; char *tmpname; } *msg)
{
   /*
    *    I know that this function and the following are quite
    *    ugly and I will try to write a better example, soon.
    */

   FILE *f;

   // Is it HTML ...
   if(!stricmp(msg->url+strlen(msg->url)-5,".html"))
   {
      // puts("Open HTML");
      if(f=fopen(msg->tmpname,"w"))
      {
         fprintf(f,"Simulated copying of URL '%s' to '%s'.",msg->url,msg->tmpname);
         fclose(f);
         return(TRUE);
      }
   }

   // or an image ...
   else
   {
      // puts("Open IMAGE");
      strcpy(msg->tmpname, "default.img");
      return(TRUE);
   }

   return(FALSE);
}
///
/// CloseURLHook
__saveds ULONG __asm CloseURL(register __a0 struct Hook *h, register __a2 Object *obj, register __a1 struct{ char *tmpname; } *msg)
{
   // Delete temporary file
   if(!strnicmp(msg->tmpname, "t:", 2))
   {
      // puts("Close URL");
      remove(msg->tmpname);
   }
   else
   {
      ;
      // puts("Close IMAGE");
   }

   return(0);
}
///
/// VLinkHook
static BOOL followed;

__saveds ULONG __asm VLink(register __a0 struct Hook *h, register __a2 Object *obj, register __a1 struct{ char *url; } *msg)
{
   /*
    *    This is a really simple example. It just mixes followed
    *    and not followed links. Normaly a URL comparison has to
    *    be done in this case.
    */

   return(followed = !followed);
}
///
/// AppMsgFunc
__saveds __asm LONG AppMsgFunc(register __a2 APTR obj, register __a1 struct AppMessage **x)
{
   /*
    *   Very simple functions to parse the
    *   AppMessage and set URL
    *   (Taken from AppWindow.c)
    */

   struct WBArg *ap;
   struct AppMessage *amsg = *x;
   static char buf[256];

   if(amsg->am_NumArgs)
   {
      ap=amsg->am_ArgList;
      NameFromLock(ap->wa_Lock,buf,sizeof(buf));
      AddPart(buf,ap->wa_Name,sizeof(buf));
      set(obj,MUIA_HTMLtext_URL,buf);
   }

   return(0);
}
///
/// Main
int main(int argc,char *argv[])
{
   struct   Library *IntuitionBase;
   int      ret=RETURN_ERROR;
   static   const struct Hook AppMsgHook   = { { NULL,NULL },(VOID *)AppMsgFunc,NULL,NULL };
   static   const struct Hook OpenURLHook  = { { NULL,NULL },(VOID *)OpenURL ,NULL,NULL };
   static   const struct Hook CloseURLHook = { { NULL,NULL },(VOID *)CloseURL ,NULL,NULL };
   static   const struct Hook VLinkHook    = { { NULL,NULL },(VOID *)VLink ,NULL,NULL };

   if(IntuitionBase = OpenLibrary("intuition.library", 36))
   {
      struct Library *MUIMasterBase;

      if(MUIMasterBase = OpenLibrary(MUIMASTER_NAME, 13))
      {
         ULONG signals;
         BOOL running = TRUE;

         // Load the text
         app = ApplicationObject,
            MUIA_Application_Title      , "HTMLtext-DEMO",
            MUIA_Application_Version    , "$VER: HTMLtext-DEMO 1.1 " __AMIGADATE__,
            MUIA_Application_Copyright  , "(C)opyright by Dirk Holtwick 1997",
            MUIA_Application_Author     , "Dirk Holtwick",
            MUIA_Application_Description, "Uses the HTMLtext.mcc to display text.",
            MUIA_Application_Base       , "HTMLTEXTDEMO",

            SubWindow, window = WindowObject,
               MUIA_Window_Title, "HTMLtext-Demo © Dirk Holtwick, 1997",
               MUIA_Window_ID   , MAKE_ID('D','E','M','O'),
               MUIA_Window_UseRightBorderScroller, TRUE,
               MUIA_Window_UseBottomBorderScroller, TRUE,
               MUIA_Window_AppWindow, TRUE,

               WindowContents, VGroup,

                  Child, url = TextObject,
                     TextFrame,
                     MUIA_Font,        MUIV_Font_Tiny,
                     MUIA_Background,  MUII_TextBack,
                     End,

                  /*
                   *   Try to put the HTMLtextObject in a ScrollgroupObject
                   *   to allow the user an easy handling of the VirtualGroup
                   *   created by HTMLtext.mcc.
                   */

                  Child, scroll = ScrollgroupObject,
                     MUIA_CycleChain, 1,
                     MUIA_Scrollgroup_UseWinBorder, TRUE,
                     MUIA_Scrollgroup_Contents, html = HTMLtextObject,
                        TextFrame,
                        MUIA_HTMLtext_Contents,       DEMOTEXT,
                        MUIA_HTMLtext_OpenURLHook,    &OpenURLHook,
                        MUIA_HTMLtext_CloseURLHook,   &CloseURLHook,
                        MUIA_HTMLtext_VLinkHook,      &VLinkHook,
                        End,
                     End,

                  Child, str = StringObject,
                     StringFrame,
                     MUIA_ObjectID,          1,
                     MUIA_CycleChain,        1,
                     MUIA_String_MaxLen,     1024,
                     MUIA_String_Contents,   DEMOTEXT,
                     End,
                  End,
               End,
            End;

         if(app)
         {
            // Window closing
            DoMethod(window, MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
               app, 2, MUIM_Application_ReturnID, MUIV_Application_ReturnID_Quit);

            // after modification of string contents refresh HTML object
            DoMethod(str,MUIM_Notify,MUIA_String_Contents,MUIV_EveryTime,
               html,3,MUIM_Set,MUIA_HTMLtext_Contents,MUIV_TriggerValue);

            // string gadgets will always be active
            DoMethod(str,MUIM_Notify,MUIA_String_Acknowledge,MUIV_EveryTime,
               window,3,MUIM_Set,MUIA_Window_ActiveObject,str);

            // react if someone droped an icon on the HTML object
            DoMethod(html,MUIM_Notify,MUIA_AppMessage,MUIV_EveryTime,
               html,3,MUIM_CallHook,&AppMsgHook,MUIV_TriggerValue);

            // display title in windows title bar
            DoMethod(html,MUIM_Notify,MUIA_HTMLtext_Title,MUIV_EveryTime,
               window,3,MUIM_Set,MUIA_Window_Title,MUIV_TriggerValue);

            // display current URL
            DoMethod(html,MUIM_Notify,MUIA_HTMLtext_URL,MUIV_EveryTime,
               url,3,MUIM_Set,MUIA_Text_Contents,MUIV_TriggerValue);

            // ready to open the window ...
            set(window,MUIA_Window_ActiveObject,   str);
            set(window,MUIA_Window_DefaultObject,  html);
//            set(str, MUIA_String_Contents, DEMOTEXT);

            // Load string
            DoMethod(app, MUIM_Application_Load, MUIV_Application_Load_ENVARC);

            set(window,MUIA_Window_Open,TRUE);

            while (running)
            {
               switch(DoMethod(app,MUIM_Application_Input,&signals))
               {
                  case MUIV_Application_ReturnID_Quit:
                     running = FALSE;
                     break;
               }

               if(running && signals)
                  Wait(signals);
            }

            set(window, MUIA_Window_Open, FALSE);

            DoMethod(app, MUIM_Application_Save, MUIV_Application_Save_ENVARC);

            MUI_DisposeObject(app);

            ret = RETURN_OK;
         }
         else
         {
            puts("Could not open application!");
            ret = RETURN_FAIL;
         }

         CloseLibrary(MUIMasterBase);
      }
      else
      {
         puts("Could not open muimaster.library v13!");
         ret = RETURN_FAIL;
      }

      CloseLibrary(IntuitionBase);
   }
   else
   {
      puts("Could not open intuition.library v36!");
      ret = RETURN_FAIL;
   }

   return(ret);
}
///

