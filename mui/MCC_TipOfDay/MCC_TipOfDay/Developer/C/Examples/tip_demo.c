
/*
** $Id: tip_demo.c,v 1.3 2000/06/29 22:41:48 carlos Exp $
*/

/// Includes

#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <stdlib.h>
#include <exec/types.h>
#include <libraries/mui.h>
#include <libraries/asl.h>
#include <proto/exec.h>
#include <proto/muimaster.h>
#include <proto/utility.h>

#include "tipwindow_mcc.h"

LONG __stack = 18192;

#define SAVEDS __saveds
#define ASM __asm
#define REG(x) register __ ## x

//|

char VER[] = "$VER: Tip Of The Day Demo 1.0 (30.06.2000)";

/// CleanUp
void CleanUp(void)
{
   if(MUIMasterBase)   {CloseLibrary(MUIMasterBase); MUIMasterBase = NULL; }
}
//|
/// TextButton

Object *TextButton(char *num)
{
        Object *obj = MUI_MakeObject(MUIO_Button,num);

        if(obj) set(obj, MUIA_CycleChain, TRUE);
        return(obj);
}

//|
/// xget
ULONG xget( Object *obj, int attr)
{
ULONG val;

        get( obj, attr, &val);
        return( val );
}
//|

/// Main

struct  Library *MUIMasterBase  = NULL;

#define TextObj(a) TextObject, MUIA_Text_Contents, (a), MUIA_Font, MUIV_Font_Tiny, End


int main(void)
{

APTR app, window, tips, button;


   // let's open necessary libriaries
   if( !(MUIMasterBase = OpenLibrary(MUIMASTER_NAME, MUIMASTER_VMIN)) )
       {
       printf("Can't open %s v%ld\n", MUIMASTER_NAME, MUIMASTER_VMIN);
       CleanUp();
       return(EXIT_FAILURE);
       }


   // application object is a core of any MUI app. So we
   // shall have one as well for our demo app...

   app = ApplicationObject,
            MUIA_Application_Title      , "TipOfTheDay Demo",
            MUIA_Application_Copyright  , "©1999-2000 Marcin Orlowski <carlos@amiga.com.pl>",
            MUIA_Application_Author     , "Marcin Orlowski",
            MUIA_Application_Base       , "TIPOFTHEDAY",
            MUIA_Application_Window     ,
               window = WindowObject,
                        MUIA_Window_ID, 0,
                        MUIA_Window_Title, "TipOfTheDay demo",
                        WindowContents,
                              VGroup,
                              Child, button = TextButton(" Show _Tip of The Day" ),
                              End,
                        End,


                 MUIA_Application_Window, tips = TipwindowObject, 
//                                               MUIA_Tip_FileBase, "example",
                                               End,

                 End;



      if(app)
        {
        // standard notification - close app window to quit
        DoMethod(window, MUIM_Notify, MUIA_Window_CloseRequest, TRUE, MUIV_Notify_Application, 2, MUIM_Application_ReturnID, MUIV_Application_ReturnID_Quit);

        // when user hit "Show tip of the day" button,
        // we gonna show him next tip. It TOD window
        // is closed, it will be opened. And of course
        // the window will pop up no matter what if
        // "Show Tips on Startup" is on or off (it's
        // not startup event ;-)
        DoMethod(button, MUIM_Notify, MUIA_Pressed, FALSE, tips, 2, MUIM_Tip_Show, MUIV_Tip_Show_Next );


        // let's pop up our main app window
        set(window, MUIA_Window_Open, TRUE);

        // now we gonna show tip window. MUIV_Tip_Show_Startup
        // is a special value that tells TOD class that it
        // shall consider value of "Show Tips on Startup"
        // checkmark and open the window only if user wants
        // to see startup tips. This is how you shall use
        // the class in your app as well!
        DoMethod( tips, MUIM_Tip_Show, MUIV_Tip_Show_Startup );


        // we now can access internal TOD window object:
        set( (Object *)xget(tips, MUIA_Tip_WindowObject), MUIA_Window_Title, "Custom titles roxx!" );


        // main loop. It recomended if we managed to open
        // our windows before proceed.
        if( xget(window, MUIA_Window_Open) )
           {
           ULONG sigs = 0;

           while(DoMethod(app,MUIM_Application_NewInput,&sigs) != MUIV_Application_ReturnID_Quit)
             {
             if(sigs)
               {
               sigs = Wait(sigs | SIGBREAKF_CTRL_C);
               if(sigs & SIGBREAKF_CTRL_C) break;
               }
             }
           }
        else
           {
           printf("Can't open window!\n");
           }

//              printf( "Result string: '%s'\n", xget(pph, MUIA_Popph_Contents) );

        MUI_DisposeObject(app);
        }
      else
        {
        printf("Can't create application object\n");
        DisplayBeep(NULL);
        }

   CleanUp();
   return(EXIT_SUCCESS);
}
//|
