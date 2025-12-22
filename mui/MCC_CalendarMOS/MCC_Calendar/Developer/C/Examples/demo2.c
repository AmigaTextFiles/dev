
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

void
closeFun(Object *str,Object *cal)
{
    UBYTE buf[128];

    DoMethod(cal,MUIM_Calendar_FormatDate,MUIV_Calendar_FormatDate_Long,buf,sizeof(buf));
    set(str,MUIA_Text_Contents,buf);
}

void
_closeFun(void)
{
    closeFun((Object *)REG_A1,(Object *)REG_A2);
}

static struct EmulLibEntry closeTrap = {TRAP_LIBNR,0,(void (*)(void))_closeFun};
static struct Hook closeHook = {0,0,(HOOKFUNC)&closeTrap};

/***********************************************************************/

int
main(int argc,char **argv)
{
    int res;

    if (MUIMasterBase = OpenLibrary("muimaster.library",19))
    {
        Object *app, *win, *pop, *str, *cal;

        if (app = ApplicationObject,
                MUIA_Application_Title,         "Calendar Demo2",
                MUIA_Application_Version,       "$VER: CalendarDemo2 1.0 (1.2.2004)",
                MUIA_Application_Copyright,     "Copyright 2004 by Alfonso Ranieri",
                MUIA_Application_Author,        "Alfonso Ranieri <alforan@tin.it>",
                MUIA_Application_Description,   "Calendar.mcc test",
                MUIA_Application_Base,          "CALTEST",
                SubWindow, win = WindowObject,
                    MUIA_Window_ID,             MAKE_ID('M','A','I','N'),
                    MUIA_Window_Title,          "Calendar Demo2",

                    WindowContents, VGroup,
                        Child, pop = PopobjectObject,
                            MUIA_Popstring_String, str = TextObject,
                                TextFrame,
                                MUIA_Text_PreParse, "\33c",
                            End,
                            MUIA_Popstring_Button, MUI_MakeObject(MUIO_PopButton,MUII_PopUp),
                            MUIA_Popobject_Object, cal = CalendarObject,
                                InputListFrame,
                                MUIA_Calendar_ShowToday,  TRUE,
                                MUIA_Calendar_TodayClick, MUIV_Calendar_TodayClick_Double,
                                MUIA_Calendar_SetDaysAsDefault, TRUE,
                            End,
                            MUIA_Popobject_ObjStrHook, &closeHook,
                        End,
                    End,
                End,
            End)
        {
            ULONG sigs = 0;

            closeFun(str,cal);

            DoMethod(win,MUIM_Notify,MUIA_Window_CloseRequest,TRUE,MUIV_Notify_Application,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit);
            DoMethod(cal,MUIM_Notify,MUIA_Calendar_DoubleClick,MUIV_EveryTime,pop,2,MUIM_Popstring_Close,TRUE);

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
