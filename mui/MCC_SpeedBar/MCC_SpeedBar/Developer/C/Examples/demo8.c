
#include "barclass.h"
#include <proto/dos.h>
#include <stdio.h>

/***********************************************************************/

long __stack = 8192;

struct Library *MUIMasterBase;
struct Library *UtilityBase;

/***********************************************************************/

#define MAKE_ID(a,b,c,d) ((ULONG)(a)<<24|(ULONG)(b)<<16|(ULONG)(c)<<8|(ULONG)(d))

/***********************************************************************/

enum
{
    BGET,
    BSAVE,
    BSUBMIT,
    BSTOP,
    BDUMMY1,
    BDISC,
    BMATCHES,
};

static struct SBButton sbuttons[] =
{
    SBENTRY("Get",     "_Get",      "Lookup a disc.",                    0,0),
    SBENTRY("Save",    "S_ave",     "Save the disc to the local cache",  MUIV_SpeedBar_ButtonFlag_Disabled,0),
    SBENTRY("Submit",  "S_ubmit",   "Submit the disc.",                  0,0),
    SBENTRY("Stop",    "_Stop",     "Stop connections",                  MUIV_SpeedBar_ButtonFlag_Disabled,0),
    SBSPACER,
    SBENTRY("Disc",    "_Disc",     "Switch to edit page.",              MUIV_SpeedBar_ButtonFlag_Immediate|MUIV_SpeedBar_ButtonFlag_Selected,1<<BMATCHES),
    SBENTRY("Matches", "_Matches",  "Switch to multi matches page.",     MUIV_SpeedBar_ButtonFlag_Immediate,1<<BDISC),
    SBEND
};

/***********************************************************************/

int
main(int argc,char **argv)
{
    register int res = RETURN_ERROR;

    if (UtilityBase = OpenLibrary("utility.library",37))
    {
        if (MUIMasterBase = OpenLibrary("muimaster.library",19))
        {
		    struct MUI_CustomClass *barClass;

			if (createBarClass(&barClass))
			{
                Object *app, *win, *sb;

               	if (app = ApplicationObject,
                		MUIA_Application_Title,         "SpeedBar SubClass demo",
                        MUIA_Application_Version,       "$VER: SpeedBarDemo8 16.1 (3.12.2002)",
                        MUIA_Application_Copyright,     "Copyright 1999-2002 by Alfonso Ranieri",
                        MUIA_Application_Author,        "Alfonso Ranieri <alforan@tin.it>",
                        MUIA_Application_Description,   "SpeedBar.mcc sub class test",
                        MUIA_Application_Base,          "SPEEDBARTEST",

                        SubWindow, win = WindowObject,
                            MUIA_Window_ID,    MAKE_ID('M','A','I','N'),
                            MUIA_Window_Title, "SpeedBar Demo8",

                            WindowContents, VGroup,
                                Child, sb = NewObject(barClass->mcc_Class,NULL,
                                    GroupFrame,
                                    MUIA_Bar_Buttons,         sbuttons,
                                    MUIA_SpeedBar_PicsDrawer, "Pics",
                                    MUIA_SpeedBar_Layout,     MUIV_SpeedBar_Layout_Left,
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
                    Printf("%s: can't create application\n",argv[0]);
                    res = RETURN_FAIL;
                }

				deleteBarClass(&barClass);
			}
            else Printf("%s: Can't create subclass\n",argv[0]);

            CloseLibrary(MUIMasterBase);
        }
        else Printf("%s: Can't open muimaster.library ver 19 or higher\n",argv[0]);

        CloseLibrary(UtilityBase);
    }
    else Printf("%s: Can't open utility.library ver 37 or higher\n",argv[0]);

    return res;
}

/***********************************************************************/
