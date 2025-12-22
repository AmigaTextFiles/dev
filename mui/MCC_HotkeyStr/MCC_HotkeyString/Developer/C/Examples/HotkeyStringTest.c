/********************************************************************** 
	MCC HotkeyString - Copyright (C) 2003 - Ilkka Lehtoranta

	This library is free software; you can redistribute it and/or
	modify it under the terms of the GNU Lesser General Public
	License as published by the Free Software Foundation; either
	version 2.1 of the License, or (at your option) any later version.

	This library is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
	Lesser General Public License for more details.
***********************************************************************/

#include	<libraries/mui.h>
#include	<mui/HotkeyString_mcc.h>

#include	<clib/alib_protos.h>
#include	<proto/exec.h>
#include	<proto/intuition.h>
#include	<proto/muimaster.h>

#ifndef MAKE_ID
#define MAKE_ID(a,b,c,d)  ((ULONG) (a)<<24 | (ULONG) (b)<<16 | (ULONG) (c)<<8 | (ULONG) (d))
#endif

#define	MUIA_Application_UsedClasses	0x8042e9a7	/* V20 STRPTR *	i..	*/

static const STRPTR	ClassList[]	=
{
	NULL
};

struct IntuitionBase	*IntuitionBase;
struct Library			*MUIMasterBase;

static Object	*app, *win, *button, *str;

/***************************************************************
 * @Initialize																	*
 **************************************************************/

static BOOL Initialize(void)
{
	if ((IntuitionBase	= (struct IntuitionBase *)OpenLibrary("intuition.library", 36)) != NULL)
	if	((MUIMasterBase	= OpenLibrary("muimaster.library", 11)) != NULL)
	{
		app = ApplicationObject,
				MUIA_Application_Title			, "HotkeyString.mcc example",
				MUIA_Application_Version		, "1.0",
				MUIA_Application_Copyright		, "Public Domain",
				MUIA_Application_Author			, "Ilkka Lehtoranta",
				MUIA_Application_Base			, "HOTKEYSTRING_EXAMPLE",
				MUIA_Application_UsedClasses	, ClassList,

				SubWindow, win = WindowObject,
					MUIA_Window_Title	, "HotkeyString.mcc example",
					MUIA_Window_ID		, MAKE_ID('M','A','I','N'),
					WindowContents		, VGroup,
						Child, button	= TextObject, MUIA_Text_Contents, "Snoop", MUIA_Frame, MUIV_Frame_Button, MUIA_Background, MUII_ButtonBack, MUIA_InputMode, MUIV_InputMode_Toggle, End,
						Child, str	= HotkeyStringObject, StringFrame, MUIA_CycleChain, TRUE, End,
						End,
					End,
				End;

		if ( app != NULL )
		{
			DoMethod(button, MUIM_Notify, MUIA_Selected, MUIV_EveryTime, str, 3, MUIM_Set, MUIA_HotkeyString_Snoop, MUIV_TriggerValue);

			return TRUE;
		}
	}

	return FALSE;
}

/***************************************************************
 * @DeInitialize																*
 **************************************************************/

static void DeInitialize(void)
{
	MUI_DisposeObject(app);
	CloseLibrary((struct Library *)IntuitionBase);
	CloseLibrary(MUIMasterBase);
}

/***************************************************************
 * @main																			*
 **************************************************************/

int main(void)
{
	if (Initialize())
	{
		ULONG	foobar[3], signals	= 0;

		DoMethod(win, MUIM_Notify, MUIA_Window_CloseRequest, TRUE, MUIV_Notify_Application, 2, MUIM_Application_ReturnID, MUIV_Application_ReturnID_Quit);

		foobar[0]	= MUIA_Window_Open;
		foobar[1]	= TRUE;
		foobar[2]	= TAG_DONE;

		SetAttrsA(win, (struct TagItem *)&foobar);

		while (DoMethod(app, MUIM_Application_NewInput, &signals) != MUIV_Application_ReturnID_Quit)
		{
			if (signals != 0)
			{
				signals	= Wait(signals | SIGBREAKF_CTRL_C);

				if ( signals & SIGBREAKF_CTRL_C)
					break;
			}
		}

	}

	DeInitialize();

	return 0;
}
