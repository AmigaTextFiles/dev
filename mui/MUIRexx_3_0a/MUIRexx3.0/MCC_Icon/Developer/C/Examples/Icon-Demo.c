/* MUI */
#include <libraries/mui.h>
#include <MUI/Icon_mcc.h>

/* System */
#include <exec/exec.h>
#include <dos/dos.h>

/* Prototypes */
#include <proto/alib.h>
#include <proto/dos.h>
#include <proto/exec.h>

#include <inline/muimaster.h>

/* ANSI C */
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

struct Library *MUIMasterBase = NULL;

static VOID fail(Object *app, char *str)
{
    if (app) MUI_DisposeObject(app);

    if (MUIMasterBase) CloseLibrary(MUIMasterBase);
    if (str) {
        puts(str);
        exit(20);
    }
    exit(0);
}

static VOID init(VOID)
{
    if (!(MUIMasterBase = (struct Library *) OpenLibrary(MUIMASTER_NAME,MUIMASTER_VMIN-1)))
        fail(NULL,"Failed to open "MUIMASTER_NAME".");
}

int main(int argc,char *argv[])
{
    Object *app, *win;
    char *iconname, defname[] = "Icon-Demo";

    if (argc < 2) iconname = defname;
    else iconname = argv[1];

    init();

    app = ApplicationObject,
        MUIA_Application_Title      , "Icon-Demo",
        MUIA_Application_Version    , "$VER: Icon-Demo ["__DATE__"]",
        MUIA_Application_Copyright  , "Written by Russell Leighton, 1996",
        MUIA_Application_Author     , "Russell Leighton",
        MUIA_Application_Description, "Icon-Demo",
        MUIA_Application_Base       , "ICONDEMO",

        SubWindow, win = WindowObject,
            MUIA_Window_Title, "Icon-Demo 1996",
            WindowContents, VGroup,
                Child, IconObject,
                    MUIA_InputMode, MUIV_InputMode_Toggle,
                    MUIA_Frame, MUIV_Frame_Button,
                    MUIA_Icon_Name, iconname,
                End,
                Child, TextObject,
                    MUIA_Text_Contents, iconname,
                End,
            End,
        End,
    End;

    if(!app) fail(app,"Failed to create Application.");

    DoMethod(win,MUIM_Notify,MUIA_Window_CloseRequest,TRUE,
        app,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit);

    set(win,MUIA_Window_Open,TRUE);

    {
        ULONG sigs = 0;

        while (DoMethod(app,MUIM_Application_NewInput,&sigs) != MUIV_Application_ReturnID_Quit) {
            if (sigs) {
                sigs = Wait(sigs | SIGBREAKF_CTRL_C);
                if (sigs & SIGBREAKF_CTRL_C) break;
            }
        }
    }

    set(win,MUIA_Window_Open,FALSE);
    fail(app,NULL);
}
