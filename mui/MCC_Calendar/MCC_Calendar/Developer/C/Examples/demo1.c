
#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/muimaster.h>
#include <clib/alib_protos.h>
#include <MUI/Calendar_mcc.h>
#include <string.h>
#include <stdio.h>

/***********************************************************************/

long __stack = 8192;
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
        Object *app, *win, *cal;

        if (app = ApplicationObject,
                MUIA_Application_Title,         "Calendar Demo1",
                MUIA_Application_Version,       "$VER: CalendarDemo1 1.0 (1.2.2004)",
                MUIA_Application_Copyright,     "Copyright 2004 by Alfonso Ranieri",
                MUIA_Application_Author,        "Alfonso Ranieri <alforan@tin.it>",
                MUIA_Application_Description,   "Calendar.mcc test",
                MUIA_Application_Base,          "CALTEST",
                SubWindow, win = WindowObject,
                    MUIA_Window_ID,             MAKE_ID('M','A','I','N'),
                    MUIA_Window_Title,          "Calendar Demo1",
                    WindowContents, VGroup,
                        Child, cal = CalendarObject,
                            MUIA_Calendar_OnlyDays,         FALSE,
                            MUIA_Calendar_ShowToday,        TRUE,
                            MUIA_Calendar_SetDaysAsDefault, TRUE,
                        End,
                    End,
                End,
            End)
        {
            ULONG sigs = 0;

            DoMethod(win,MUIM_Notify,MUIA_Window_CloseRequest,TRUE,MUIV_Notify_Application,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit);

            set(win,MUIA_Window_Open,TRUE);

            while (DoMethod(app,MUIM_Application_NewInput,&sigs)!=MUIV_Application_ReturnID_Quit)
            {
                if (sigs)
                {
                    sigs = Wait(sigs | SIGBREAKF_CTRL_C);
                    if (sigs & SIGBREAKF_CTRL_C) break;
                }
            }

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
