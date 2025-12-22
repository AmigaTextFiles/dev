
#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/muimaster.h>
#include <clib/alib_protos.h>
#include <mui/SpeedBar_mcc.h>
#include <mui/SpeedBarCfg_mcc.h>
#include <string.h>
#include <stdio.h>

/***********************************************************************/

long __stack = 8192;
struct Library *MUIMasterBase;

/***********************************************************************/

#define MAKE_ID(a,b,c,d) ((ULONG)(a)<<24|(ULONG)(b)<<16|(ULONG)(c)<<8|(ULONG)(d))

/***********************************************************************/

struct MUIS_SpeedBar_Button buttons[] =
{
    {0, "_Get", "Get the disc.", 0, NULL},
    {1, "Sa_ve", "Save the disc.", 0, NULL},
    {2, "_Stop", "Stop the connection.", 0, NULL},
    {3, "_Disc", "Disc page.", 0, NULL},
    {4, "_Matches", "Matches page.", 0, NULL},
    {5, "_Edit", "Edit page.", 0, NULL},
    {MUIV_SpeedBar_End},
};

/***********************************************************************/

int
main(int argc,char **argv)
{
    int res = RETURN_ERROR;

    if (MUIMasterBase = OpenLibrary("muimaster.library",19))
    {
        Object *app, *win, *sb;

        if (app = ApplicationObject,
                MUIA_Application_Title,         "SpeedBar Demo9",
                MUIA_Application_Version,       "$VER: SpeedBarDemo9 16.1 (3.12.2002)",
                MUIA_Application_Copyright,     "Copyright 1999-2002 by Alfonso Ranieri",
                MUIA_Application_Author,        "Alfonso Ranieri <alforan@tin.it>",
                MUIA_Application_Description,   "Speed(Bar|Button|BarCfg).mcc test",
                MUIA_Application_Base,          "SPEEDBARTEST",

                SubWindow, win = WindowObject,
                    MUIA_Window_ID,             MAKE_ID('M','A','I','N'),
                    MUIA_Window_Title,          "SpeedBar Demo9",

                    WindowContents, VGroup,
                        Child, HGroup,
                            Child, VGroup,
                                GroupFrame,
                                Child, sb = SpeedBarObject,
                                    MUIA_Group_Rows,                3,
                                    MUIA_SpeedBar_Spread,           TRUE,
                                    MUIA_Weight,                    0,
                                    MUIA_Group_Spacing,             1,
                                    MUIA_Group_SameHeight,          TRUE,
                                    MUIA_Group_SameWidth,           TRUE,
                                    MUIA_SpeedBar_Buttons,          buttons,
                                    MUIA_SpeedBar_StripUnderscore,  TRUE,
                                    MUIA_SpeedBar_EnableUnderscore, TRUE,
                                    MUIA_SpeedBar_PicsDrawer,       "PROGDIR:Pics",
                                    MUIA_SpeedBar_Strip,            "Main.toolbar",
                                    MUIA_SpeedBar_StripButtons,     14,
                                End,
                                Child, VSpace(0),
                            End,
                            Child, HSpace(0),
                        End,
                    End,
                End,
            End)
        {
            ULONG signals;

            DoMethod(win,MUIM_Notify,MUIA_Window_CloseRequest,TRUE,MUIV_Notify_Application,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit);

            set(win,MUIA_Window_Open,TRUE);

            for (signals = 0; DoMethod(app,MUIM_Application_NewInput,&signals)!=MUIV_Application_ReturnID_Quit; )
                if (signals && ((signals = Wait(signals | SIGBREAKF_CTRL_C)) & SIGBREAKF_CTRL_C)) break;

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
    else printf("%s: Can't open muimaster.library ver 19 or higher\n",argv[0]);

    return res;
}

/***********************************************************************/
