/*
 * blockmon.dilp - Block Monitor plugin for DIL
 * Copyright ©2004-2007 Rupert Hausberger <naTmeg@gmx.net>
 * All rights reserved.
 *
 * Please see "License.readme" for the terms of this file
 */

#include "include.h"

//------------------------------------------------------------------------------

static ULONG mNew(struct IClass *cl, Object *obj, struct opSet *msg)
{
	Object *text, *ok;
	
   if ((obj = (Object *)DoSuperNew(cl, obj,
		MUIA_Window_Title, NAME_LONG" · About",
		MUIA_Window_CloseGadget, FALSE,
		MUIA_Window_SizeGadget, FALSE,
		MUIA_Window_ShowIconify, FALSE,
		MUIA_Window_ShowAbout, FALSE,
		MUIA_Window_ShowPrefs, FALSE,
		MUIA_Window_ShowJump, FALSE,
		MUIA_Window_ShowSnapshot, FALSE,
		MUIA_Window_ShowPopup, FALSE,
      MUIA_Window_NoMenus, TRUE,
		MUIA_Background, MUII_RequesterBack,
		WindowContents, VGroup,
			InnerSpacing(4, 4),
			Child, VGroup, VirtualFrame,
				Child, text = TextObject, End,
			End,
			Child, VSpace(2),
			Child, HGroup,
				Child, HVSpace,
				Child, ok = KeyButton("Ok", 'o'),
				Child, HVSpace,
			End,
		End,
	TAG_MORE, msg->ops_AttrList)))
	{
		static const UBYTE *buffer =
			"\033c\n"
         "\033b- "NAME_LONG" -\033n\n"
			"(DIL plugin)\n"
			"\n"
			DESC"\n"
			"\n"
			"\n"
			"Version "VERSION_STR"."REVISION_STR" ("__AMIGADATE__")\n"
			"\n"
			COPY"\n"
			"("URL")\n"
			"\n"
			"\n"
			"License: "LICENCE"\n";
		
		struct MCC_About_Data *data = INST_DATA(cl, obj);
		
      memclr(data, sizeof(struct MCC_About_Data));

		data->obj_self = obj;
		data->obj_parent = (Object *)GetTagData(MUIA_Parent, 0ul, msg->ops_AttrList);
		data->ad_ApplicationData = (struct MCC_Application_Data *)GetTagData(MUIA_About_ApplicationData, 0ul, msg->ops_AttrList);

		DoMethod(obj, MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
			MUIV_Notify_Application, 2,
			MUIM_Application_ReturnID, MUIV_About_Ok
		);
		DoMethod(ok, MUIM_Notify, MUIA_Pressed, FALSE,
			MUIV_Notify_Application, 2,
			MUIM_Application_ReturnID, MUIV_About_Ok
		);
		
      set(obj, MUIA_Window_ActiveObject, ok);
		set(text, MUIA_Text_Contents, buffer);
	}
	return ((ULONG)obj);
}

//------------------------------------------------------------------------------

static ULONG mDispose(struct IClass *cl, Object *obj, Msg msg)
{
   return (DoSuperMethodA(cl, obj, msg));
}

//------------------------------------------------------------------------------

static ULONG mAbout(struct IClass *cl, Object *obj, Msg msg)
{
	BOOL done = FALSE;
	ULONG result = 0;

	disAPP;
   set(obj, MUIA_Window_Open, TRUE);

	while (!done)
	{
		ULONG signals;

		switch (DoMethod(_app(obj), MUIM_Application_NewInput, &signals))
		{
			case MUIV_Application_ReturnID_Quit:
			case MUIV_About_Ok:
				done = TRUE;
            break;
		}
		if (!done && signals) Wait(signals);
	}

	set(obj, MUIA_Window_Open, FALSE);
	enAPP;

	return (result);
}

//------------------------------------------------------------------------------

MCC_DISPATCHER(dpAbout)
{
	if (msg) switch (msg->MethodID) {
		case OM_NEW 				: return (mNew    (cl, obj, (APTR)msg));
		case OM_DISPOSE 			: return (mDispose(cl, obj, (APTR)msg));
		case MUIM_About_About	: return (mAbout  (cl, obj, (APTR)msg));
	}
	return (DoSuperMethodA(cl, obj, msg));
}
MCC_DISPATCHER_END

//------------------------------------------------------------------------------






























