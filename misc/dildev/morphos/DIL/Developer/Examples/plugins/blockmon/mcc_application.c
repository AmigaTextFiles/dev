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
	struct MCC_Application_Data tmp;

	memclr(&tmp, sizeof(struct MCC_Application_Data));
	
   if ((obj = (Object *)DoSuperNew(cl, obj,
		MUIA_Application_Author, AUTHOR,
		MUIA_Application_Base, NAME_SHORT,
		MUIA_Application_Copyright, AUTHOR,
		MUIA_Application_Description,	DESC,
		MUIA_Application_Title, NAME,
		MUIA_Application_Version, VSTRING,
		MUIA_Application_HelpFile, "HELP:dil.guide", //APP_HELPFILE,
		//MUIA_Application_DiskObject, GetDiskObject(APP_DISKOBJECT),
		MUIA_Application_UseCommodities, TRUE,
		MUIA_Application_DoubleStart, FALSE,
		MUIA_Application_Menustrip, tmp.obj_menustrip = MenustripObject,
			Child, tmp.obj_menuitem[MENU_Project] = MenuObject,
				MUIA_Menu_Title, "Project",
				Child, tmp.obj_menuitem[MENU_Project_About] = MenuitemObject,
					MUIA_Menuitem_Title, "About...",
					MUIA_Menuitem_Shortcut, "?",
            End,
				Child, tmp.obj_menuitem[MENU_Project_AboutMUI] = MenuitemObject,
					MUIA_Menuitem_Title, "About MUI...",
            End,
				Child, MenuitemObject, MUIA_Menuitem_Title, NM_BARLABEL,
            End,
				Child, tmp.obj_menuitem[MENU_Project_Iconify] = MenuitemObject,
					MUIA_Menuitem_Title, "Iconify",
					MUIA_Menuitem_Shortcut, "I",
            End,
			End,
			Child, tmp.obj_menuitem[MENU_Cache] = MenuObject,
				MUIA_Menu_Title, "Cache",
				Child, tmp.obj_menuitem[MENU_Cache_Save] = MenuitemObject,
					MUIA_Menuitem_Title, "Save",
					MUIA_Menuitem_Shortcut, "s",
            End,
			End,
		End,
      TAG_MORE, msg->ops_AttrList)))
	{
		struct MCC_Application_Data *data = INST_DATA(cl, obj);

		CopyMem(&tmp, data, sizeof(struct MCC_Application_Data));

		data->app = obj;
      data->ad_Params = (DILParams *)GetTagData(MUIA_Application_Params, 0ul, msg->ops_AttrList);

		DoMethod(data->obj_menuitem[MENU_Project_About], MUIM_Notify, MUIA_Menuitem_Trigger, MUIV_EveryTime,
			obj, 1,
			MUIM_Application_Project_About
		);
		DoMethod(data->obj_menuitem[MENU_Project_AboutMUI], MUIM_Notify, MUIA_Menuitem_Trigger, MUIV_EveryTime,
			obj, 1,
			MUIM_Application_Project_AboutMUI
		);
		DoMethod(data->obj_menuitem[MENU_Project_Iconify], MUIM_Notify, MUIA_Menuitem_Trigger, MUIV_EveryTime,
			obj, 1,
			MUIM_Application_Project_Iconify
		);
		DoMethod(data->obj_menuitem[MENU_Cache_Save], MUIM_Notify, MUIA_Menuitem_Trigger, MUIV_EveryTime,
			obj, 1,
			MUIM_Application_Cache_Save
		);

		return ((ULONG)obj);
   }
	return 0;
}

//------------------------------------------------------------------------------

static ULONG mDispose(struct IClass *cl, Object *obj, Msg msg)
{
	return (DoSuperMethodA(cl, obj, msg));
}

//------------------------------------------------------------------------------

static ULONG mInit(struct IClass *cl, Object *obj, Msg msg)
{
	struct MCC_Application_Data *data = INST_DATA(cl, obj);
   Control *control = data->ad_Params->p_User;
	ULONG result = FALSE;

	disAPP;
	if ((data->mcc_main = _MainObject,
		MUIA_Parent, obj,
		MUIA_Main_ApplicationData, data,
	End))
	{
		DoMethod(obj, OM_ADDMEMBER, data->mcc_main);

		if ((result = DoMethod(data->mcc_main, MUIM_Main_Init)))
			set(data->mcc_main, MUIA_Window_Open, TRUE);
		else {
			DoMethod(obj, OM_REMMEMBER, data->mcc_main);
			DisposeObject(data->mcc_main); data->mcc_main = NULL;
		}
	}
	enAPP;
	
   return result;
}

//------------------------------------------------------------------------------

static ULONG mExit(struct IClass *cl, Object *obj, Msg msg)
{
	struct MCC_Application_Data *data = INST_DATA(cl, obj);
	
	if (data->mcc_main) {
		disAPP;
		set(data->mcc_main, MUIA_Window_Open, FALSE);
		DoMethod(data->mcc_main, MUIM_Main_Exit);
		DoMethod(obj, OM_REMMEMBER, data->mcc_main);
		MUI_DisposeObject(data->mcc_main); data->mcc_main = NULL;
		enAPP;
	}
   return 0;
}

//------------------------------------------------------------------------------

static ULONG mLoadOptions(struct IClass *cl, Object *obj, Msg msg)
{
	/*BPTR handle = Open(FILE_OPTIONS, MODE_OLDFILE);

	if (handle)
	{
		if (Read(handle, (APTR)&control.options, sizeof(struct Options)) != sizeof(struct Options))
			printf("error: loading options\n");

		Close(handle);
	} else {
		DoMethod(obj, MUIM_Application_MakeOptions);
		DoMethod(obj, MUIM_Application_SaveOptions);
	}*/
	
	DoMethod(obj, MUIM_Application_Load, MUIV_Application_Load_ENVARC);
   return 0;
}

static ULONG mSaveOptions(struct IClass *cl, Object *obj, Msg msg)
{
	/*BPTR handle = Open(FILE_OPTIONS, MODE_NEWFILE);

	if (handle)
	{
		if (Write(handle, (APTR)&control.options, sizeof(struct Options)) != sizeof(struct Options))
			printf("error: saving options\n");

		Close(handle);
	}*/
	
   DoMethod(obj, MUIM_Application_Save, MUIV_Application_Save_ENVARC);
	return 0;
}

static ULONG mMakeOptions(struct IClass *cl, Object *obj, Msg msg)
{
	//memset((APTR)&control.options, 0, sizeof(struct Options));

	return 0;
}

//------------------------------------------------------------------------------

static ULONG mProject_About(struct IClass *cl, Object *obj, Msg msg)
{
	struct MCC_Application_Data *data = INST_DATA(cl, obj);
   Control *control = data->ad_Params->p_User;

	if ((data->mcc_about = _AboutObject,
		MUIA_Parent, obj,
		MUIA_About_ApplicationData, data,
	End))
	{
		DoMethod(obj, OM_ADDMEMBER, data->mcc_about);
		DoMethod(data->mcc_about, MUIM_About_About);
		DoMethod(obj, OM_REMMEMBER, data->mcc_about);

		MUI_DisposeObject(data->mcc_about); data->mcc_about = NULL;
	}
	return 0;
}

//------------------------------------------------------------------------------

static ULONG mProject_AboutMUI(struct IClass *cl, Object *obj, Msg msg)
{
	Object *win;

	if ((win = AboutmuiObject, MUIA_Aboutmui_Application, obj, End))
		set(win, MUIA_Window_Open, TRUE);

	return 0;
}

//------------------------------------------------------------------------------

static ULONG mProject_Iconify(struct IClass *cl, Object *obj, Msg msg)
{
	set(obj, MUIA_Application_Iconified, TRUE);
	return 0;
}

//------------------------------------------------------------------------------

static ULONG mCache_Save(struct IClass *cl, Object *obj, Msg msg)
{
	struct MCC_Application_Data *data = INST_DATA(cl, obj);
	
	SaveCache(data->ad_Params);
	return 0;
}

//------------------------------------------------------------------------------

MCC_DISPATCHER(dpApplication)
{
	if (msg) switch(msg->MethodID) {
		case OM_NEW 									: return (mNew(cl, obj, (APTR)msg));
		case OM_DISPOSE 								: return (mDispose(cl, obj, (APTR)msg));
		case MUIM_Application_Init					: return (mInit(cl, obj, (APTR)msg));
		case MUIM_Application_Exit					: return (mExit(cl, obj, (APTR)msg));
		case MUIM_Application_LoadOptions		: return (mLoadOptions(cl, obj, (APTR)msg));
		case MUIM_Application_SaveOptions		: return (mSaveOptions(cl, obj, (APTR)msg));
		case MUIM_Application_MakeOptions		: return (mMakeOptions(cl, obj, (APTR)msg));
		
      case MUIM_Application_Project_About		: return (mProject_About(cl, obj, (APTR)msg));
		case MUIM_Application_Project_AboutMUI	: return (mProject_AboutMUI(cl, obj, (APTR)msg));
		case MUIM_Application_Project_Iconify	: return (mProject_Iconify(cl, obj, (APTR)msg));
		case MUIM_Application_Cache_Save			: return (mCache_Save(cl, obj, (APTR)msg));
	}
	return (DoSuperMethodA(cl, obj, (Msg)msg));
}
MCC_DISPATCHER_END

//------------------------------------------------------------------------------




















