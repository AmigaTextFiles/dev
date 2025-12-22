/*
 * MUI Test
 *
 * MUITest is a small example that shows how one would read
 * the text from the Textfield gadget used in a MUI interface.
 */

#include <stdio.h>

#include <exec/types.h>
#include <libraries/mui.h>
#include <intuition/classes.h>
#include <gadgets/textfield.h>

#include <proto/muimaster.h>
#include <proto/dos.h>
#include <proto/exec.h>
#include <proto/intuition.h>

#include <clib/alib_protos.h>

#include "muitest.h"

static BOOL init(void);
static void clean(void);

struct Library *MUIMasterBase;

main()
{
	BOOL running = TRUE;
	ULONG signal;
	struct ObjApp *obj_app;

	if (init())
	{
		obj_app = CreateApp();
		if (obj_app)
		{
			DoMethod(obj_app->window, MUIM_Notify, MUIA_Window_CloseRequest, TRUE, obj_app->App, 2,
						MUIM_Application_ReturnID, MUIV_Application_ReturnID_Quit);
			DoMethod(obj_app->text, MUIM_Notify, TEXTFIELD_Lines, MUIV_EveryTime,
						obj_app->sbar, 3, MUIM_Set, MUIA_Prop_Entries, MUIV_TriggerValue);
			DoMethod(obj_app->text, MUIM_Notify, TEXTFIELD_Visible, MUIV_EveryTime,
						obj_app->sbar, 3, MUIM_Set, MUIA_Prop_Visible, MUIV_TriggerValue);
			DoMethod(obj_app->text, MUIM_Notify, TEXTFIELD_Top, MUIV_EveryTime,
						obj_app->sbar, 3, MUIM_NoNotifySet, MUIA_Prop_First, MUIV_TriggerValue);
			DoMethod(obj_app->sbar, MUIM_Notify, MUIA_Prop_First, MUIV_EveryTime,
						obj_app->text, 3, MUIM_NoNotifySet, TEXTFIELD_Top, MUIV_TriggerValue);

			set(obj_app->window, MUIA_Window_Open, TRUE);

			while (running)
			{
				switch (DoMethod(obj_app->App, MUIM_Application_Input, &signal))
				{
					case MUIV_Application_ReturnID_Quit:
						running = FALSE;
						break;
				}
				if (running && signal)
				{
					Wait(signal);
				}
			}

			{
				struct Window *window;
				struct Gadget *gadget;
				char *text;
				ULONG size, i;

				GetAttr(MUIA_Window_Window, obj_app->window, (ULONG *)&window);
				GetAttr(MUIA_Boopsi_Object, obj_app->text, (ULONG *)&gadget);
				if (window)
				{
					// Set to readonly mode so I can grab the text from the gadget
					SetGadgetAttrs(gadget, window, NULL, TEXTFIELD_ReadOnly, TRUE, TAG_DONE);
					GetAttr(TEXTFIELD_Size, gadget, &size);
					GetAttr(TEXTFIELD_Text, gadget, (ULONG *)&text);
					if (text && size)
					{
						for (i = 0; i < size; i++)
						{
							putchar(text[i]);
						}
					}
					SetGadgetAttrs(gadget, window, NULL, TEXTFIELD_ReadOnly, FALSE, TAG_DONE);
				}
				else
				{
					printf("No window\n");
				}

				DisposeApp(obj_app);

				// Version of MUI prior to 9 have a bug that
				// doesn't dispose of smart BOOPSI objects.
				if (MUIMasterBase->lib_Version < 9)
				{
					// Dispose of text gadget after disposing of
					// object that encapsulates the text gadget
					DisposeObject(gadget);
				}
			}
		}
	}
}

static BOOL init(void)
{
	MUIMasterBase = OpenLibrary(MUIMASTER_NAME,MUIMASTER_VMIN);
	if (MUIMasterBase)
	{
		return TRUE;
	}
	else
	{
		return FALSE;
	}
}

static void clean(void)
{
	CloseLibrary(MUIMasterBase);
}
