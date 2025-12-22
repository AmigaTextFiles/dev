
/* sc demo LINK INCDIR=/Include             */
/* gcc -odemo demo.c -noixemul -I../Include */

#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/muimaster.h>
#include <clib/alib_protos.h>
#include <mui/MiniMailer_mcc.h>
#include <string.h>
#include <stdio.h>

/***********************************************************************/

#ifdef __MORPHOS__
long __stack = 16384;
#else
long __stack = 8192;
#endif

struct Library *MUIMasterBase;

/***********************************************************************/

#ifndef MAKE_ID
#define MAKE_ID(a,b,c,d) ((ULONG) (a)<<24 | (ULONG) (b)<<16 | (ULONG) (c)<<8 | (ULONG) (d))
#endif

/***********************************************************************/

int
main(int argc,char **argv)
{
    int res;

    if (MUIMasterBase = OpenLibrary("muimaster.library",19))
    {
        Object *app, *win, *mm;

        if (app = ApplicationObject,
                MUIA_Application_Title,        "MiniMailer Demo1",
                MUIA_Application_Version,      "$VER: MiniMailerDemo1 1.0 (28.7.2005)",
                MUIA_Application_Copyright,    "Copyright 2004-2005 by Alfonso Ranieri",
                MUIA_Application_Author,       "Alfonso Ranieri <alforan@tin.it>",
                MUIA_Application_Description,  "MiniMailer example",
                MUIA_Application_Base,         "MINIMAILEREXAMPLE",

                SubWindow, win = WindowObject,
                    MUIA_Window_ID,    MAKE_ID('M','A','I','N'),
                    MUIA_Window_Title, "MiniMailer Demo1",

                    WindowContents, VGroup,
                        Child, mm = MiniMailerObject,
                            MUIA_MiniMailer_To,         "ranieria@tiscali.it",
                            MUIA_MiniMailer_Subject,    "MiniMailer Test",
                            MUIA_MiniMailer_Text,       "Hello,\nhow are you?\n\nCiao.",
                        End,
                    End,
                End,
            End)
        {
            ULONG sigs = 0;

            DoMethod(win,MUIM_Notify,MUIA_Window_CloseRequest,TRUE,MUIV_Notify_Application,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit);
            DoMethod(mm,MUIM_MiniMailer_LoadPrefs,"RAM:MiniMailer");

            set(win,MUIA_Window_Open,TRUE);

            while (DoMethod(app,MUIM_Application_NewInput,&sigs)!=MUIV_Application_ReturnID_Quit)
            {
                if (sigs)
                {
                    sigs = Wait(sigs | SIGBREAKF_CTRL_C);
                    if (sigs & SIGBREAKF_CTRL_C) break;
                }
            }

            DoMethod(mm,MUIM_MiniMailer_SavePrefs,"RAM:MiniMailer");
            MUI_DisposeObject(app);

            res = RETURN_OK;
        }
        else
        {
            printf("%s: can't create application\n",argv[0]);
            res = RETURN_FAIL;
        }

        CloseLibrary(MUIMasterBase);
    }
    else
    {
        printf("%s: Can't open muimaster.library ver 19 or higher\n",argv[0]);
        res = RETURN_ERROR;
    }

    return res;
}

/***********************************************************************/

