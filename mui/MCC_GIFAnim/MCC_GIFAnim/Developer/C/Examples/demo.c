
#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/muimaster.h>
#include <clib/alib_protos.h>

#include <mui/GIFAnim_mcc.h>

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

#define TEMPLATE  "FILE,NTR=NTTRANSPARENT/S,NTA=NTANIM/S,P1=PLAYONCE/S,SCALE/K/N"
#define DEFFILE   "PROGDIR:Pics/Smileys.gif"
#define GETNUM(a) (*((LONG *)a))

int
main(int argc,char **argv)
{
    struct RDArgs   *ra;
    LONG            arg[8] = {0};
    int             res;

    if (ra = ReadArgs(TEMPLATE,arg,NULL))
    {
        if (MUIMasterBase = OpenLibrary("muimaster.library",19))
        {
            Object *app, *win, *gif, *next, *pred, *first, *last, *play, *play1, *pause;
            LONG   scale;

            if (arg[4]) scale = GETNUM(arg[4]);
            else scale = 0;

            if (app = ApplicationObject,
                    MUIA_Application_Title,         "GIFAnim Demo",
                    MUIA_Application_Version,       "$VER: GIFAnimDemo 1.2 (16.9.2002)",
                    MUIA_Application_Copyright,     "Copyright 2002 by Alfonso Ranieri",
                    MUIA_Application_Author,        "Alfonso Ranieri <alforan@tin.it>",
                    MUIA_Application_Description,   "GIFAnim test",
                    MUIA_Application_Base,          "GIFANIMTEST",

                    SubWindow, win = WindowObject,
                        MUIA_Window_ID,             MAKE_ID('M','A','I','N'),
                        MUIA_Window_Title,          "GIFAnim Demo",

                        WindowContents, VGroup,

                            Child, VGroup,
                                Child, RectangleObject, MUIA_Weight,1, End,
                                Child, HGroup,
                                    Child, RectangleObject, MUIA_Weight,1, End,
                                    Child, gif = GIFAnimObject,
                                        MUIA_GIFAnim_File,        arg[0] ? (char *)arg[0] : DEFFILE,
                                        MUIA_GIFAnim_Transparent, !arg[1],
                                        MUIA_GIFAnim_Anim,        !arg[2],
                                        scale ? MUIA_GIFAnim_Scale : TAG_IGNORE, scale,
                                    End,
                                    Child, RectangleObject, MUIA_Weight,1, End,
                                End,
                                Child, RectangleObject, MUIA_Weight,1, End,
                            End,

                            Child, HGroup,
                                Child, next = MUI_MakeObject(MUIO_Button,"_Next"),
                                Child, RectangleObject, MUIA_Weight,1, End,
                                Child, pred = MUI_MakeObject(MUIO_Button,"_Pred"),
                                Child, RectangleObject, MUIA_Weight,1, End,
                                Child, first = MUI_MakeObject(MUIO_Button,"_First"),
                                Child, RectangleObject, MUIA_Weight,1, End,
                                Child, last = MUI_MakeObject(MUIO_Button,"_Last"),
                                Child, RectangleObject, MUIA_Weight,1, End,
                                Child, play = MUI_MakeObject(MUIO_Button,"Pl_ay"),
                                Child, RectangleObject, MUIA_Weight,1, End,
                                Child, play1 = MUI_MakeObject(MUIO_Button,"Play _1"),
                                Child, RectangleObject, MUIA_Weight,1, End,
                                Child, pause = MUI_MakeObject(MUIO_Button,"P_ause"),
                            End,

                        End,

                    End,
                End)
            {
                ULONG sigs = 0;

                DoMethod(win,MUIM_Notify,MUIA_Window_CloseRequest,TRUE,MUIV_Notify_Application,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit);

                DoMethod(app,MUIM_MultiSet,MUIA_Disabled,TRUE,next,pred,first,last,play,play1,pause,NULL);

                DoMethod(next,MUIM_Notify,MUIA_Pressed,FALSE,gif,1,MUIM_GIFAnim_Next);
                DoMethod(pred,MUIM_Notify,MUIA_Pressed,FALSE,gif,1,MUIM_GIFAnim_Pred);
                DoMethod(first,MUIM_Notify,MUIA_Pressed,FALSE,gif,1,MUIM_GIFAnim_First);
                DoMethod(last,MUIM_Notify,MUIA_Pressed,FALSE,gif,1,MUIM_GIFAnim_Last);
                DoMethod(play,MUIM_Notify,MUIA_Pressed,FALSE,gif,2,MUIM_GIFAnim_Play,MUIV_GIFAnim_Play_On|MUIV_GIFAnim_Play_Rewind);
                DoMethod(play1,MUIM_Notify,MUIA_Pressed,FALSE,gif,2,MUIM_GIFAnim_Play,MUIV_GIFAnim_Play_On|MUIV_GIFAnim_Play_Once|MUIV_GIFAnim_Play_Rewind);
                DoMethod(pause,MUIM_Notify,MUIA_Pressed,FALSE,gif,2,MUIM_GIFAnim_Play,MUIV_GIFAnim_Play_Off);

                DoMethod(gif,MUIM_Notify,MUIA_GIFAnim_Decoded,MUIV_EveryTime,next,3,MUIM_Set,MUIA_Disabled,MUIV_NotTriggerValue);
                DoMethod(gif,MUIM_Notify,MUIA_GIFAnim_Decoded,MUIV_EveryTime,pred,3,MUIM_Set,MUIA_Disabled,MUIV_NotTriggerValue);
                DoMethod(gif,MUIM_Notify,MUIA_GIFAnim_Decoded,MUIV_EveryTime,first,3,MUIM_Set,MUIA_Disabled,MUIV_NotTriggerValue);
                DoMethod(gif,MUIM_Notify,MUIA_GIFAnim_Decoded,MUIV_EveryTime,last,3,MUIM_Set,MUIA_Disabled,MUIV_NotTriggerValue);
                DoMethod(gif,MUIM_Notify,MUIA_GIFAnim_Decoded,MUIV_EveryTime,play,3,MUIM_Set,MUIA_Disabled,MUIV_NotTriggerValue);
                DoMethod(gif,MUIM_Notify,MUIA_GIFAnim_Decoded,MUIV_EveryTime,play1,3,MUIM_Set,MUIA_Disabled,MUIV_NotTriggerValue);
                DoMethod(gif,MUIM_Notify,MUIA_GIFAnim_Decoded,MUIV_EveryTime,pause,3,MUIM_Set,MUIA_Disabled,MUIV_NotTriggerValue);

                set(win,MUIA_Window_Open,TRUE);

                if (arg[3]) DoMethod(gif,MUIM_GIFAnim_Play,MUIV_GIFAnim_Play_On|MUIV_GIFAnim_Play_Once);

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

        FreeArgs(ra);
    }
    else
    {
        PrintFault(IoErr(),argv[0]);
        res = RETURN_FAIL;
    }

    return res;
}

/***********************************************************************/
