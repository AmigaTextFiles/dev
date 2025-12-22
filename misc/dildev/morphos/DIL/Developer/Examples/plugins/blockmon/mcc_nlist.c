/*
 * blockmon.dilp - Block Monitor plugin for DIL
 * Copyright ©2004-2007 Rupert Hausberger <naTmeg@gmx.net>
 * All rights reserved.
 *
 * Please see "License.readme" for the terms of this file
 */

#include "include.h"

//------------------------------------------------------------------------------
/*
static Object *AddItem(Object *menu, UBYTE *title, ULONG userdata)
{
	Object *obj;

	if ((obj = MenuitemObject,
		MUIA_Menuitem_Title, title,
		MUIA_UserData, userdata,
	End))
		DoMethod(menu, MUIM_Family_AddTail, obj);

   return obj;
}

static Object *AddCheckItem(Object *menu, UBYTE *title, BOOL checked, BOOL enabled, ULONG userdata)
{
	Object *obj;

	if ((obj = MenuitemObject,
		MUIA_Menuitem_Title, title,
		MUIA_Menuitem_Checked, checked,
		MUIA_Menuitem_Checkit, TRUE,
		MUIA_Menuitem_Toggle, TRUE,
		MUIA_Menuitem_Enabled, enabled,
		MUIA_UserData, userdata,
	End))
		DoMethod(menu, MUIM_Family_AddTail, obj);

   return obj;
}

static Object *AddBarItem(Object *menu)
{
	Object *obj;

	if ((obj = MenuitemObject,
		MUIA_Menuitem_Title, NM_BARLABEL,
		MUIA_UserData, NULL,
	End))
		DoMethod(menu, MUIM_Family_AddTail, obj);

   return obj;
}

#define MM(title) \
	(data->obj_contextmenu = MenustripObject, Child, m = MenuObjectT(title), End, End)

#define A(title, userdata) \
	AddItem(m, title, userdata)

#define AS(title, userdata) \
	AddItem(sm, title, userdata)

#define ASS(title, userdata) \
	AddItem(ssm, title, userdata)

#define AC(title, checked, enabled, userdata) \
	AddCheckItem(m, title, checked, enabled, userdata)

#define ASC(title, checked, enabled, userdata) \
	AddCheckItem(sm, title, checked, enabled, userdata)

#define ASSC(title, checked, enabled, userdata) \
	AddCheckItem(ssm, title, checked, enabled, userdata)

#define AB \
	AddBarItem(m)

#define ASB \
	AddBarItem(sm)

#define ASSB \
	AddBarItem(ssm)

#define ASTD \
	A(MSG(MSG_CL_MCC_LIST_PP_TITLE_DWT), MUIV_NList_Menu_DefWidth_This); \
	A(MSG(MSG_CL_MCC_LIST_PP_TITLE_DWA), MUIV_NList_Menu_DefWidth_All); \
	A(MSG(MSG_CL_MCC_LIST_PP_TITLE_DOT), MUIV_NList_Menu_DefOrder_This); \
	A(MSG(MSG_CL_MCC_LIST_PP_TITLE_DOA), MUIV_NList_Menu_DefOrder_All);

#define ID_SUBMENU ~0ul
*/
//------------------------------------------------------------------------------

static BOOL myObtainPen(struct IClass *cl, Object *obj, LONG id)
{
	struct MCC_NList_Data *data = INST_DATA(cl, obj);
   Control *control = data->nld_MainData->md_ApplicationData->ad_Params->p_User;
	Settings *settings = &control->c_Settings;

	if (!(data->nld_Pen[id] = MUI_ObtainPen(muiRenderInfo(obj), &(settings->s_PenSpec[id]), 0ul)))
      return FALSE;

	return TRUE;
}

static void myReleasePen(struct IClass *cl, Object *obj, LONG id)
{
	struct MCC_NList_Data *data = INST_DATA(cl, obj);

	if (data->nld_Pen[id] != -1) {
		MUI_ReleasePen(muiRenderInfo(obj), data->nld_Pen[id]);
		data->nld_Pen[id] = -1l;
	}
}

//------------------------------------------------------------------------------

static ULONG mNew(struct IClass *cl, Object *obj, struct opSet *msg)
{
	struct MCC_NList_Data tmp;

	memclr(&tmp, sizeof(struct MCC_NList_Data));
	
	if ((obj = (Object *)DoSuperNew(cl, obj,
      MUIA_ContextMenu, MUIV_NList_ContextMenu_Always,
		MUIA_NList_AutoVisible, TRUE,
		MUIA_NList_DefaultObjectOnClick, FALSE,
		MUIA_NList_Exports, MUIV_NList_Exports_All,
		MUIA_NList_Imports, MUIV_NList_Imports_All,
      MUIA_NList_MinColSortable, 0,
		MUIA_NList_Title, TRUE,
		MUIA_NList_TitleClick, TRUE,
		MUIA_NList_TitleClick2, TRUE,
		MUIA_NList_TitleSeparator, TRUE,
   TAG_MORE, msg->ops_AttrList)))
	{
		struct MCC_NList_Data *data = INST_DATA(cl, obj);
		LONG i;

		CopyMem(&tmp, data, sizeof(struct MCC_NList_Data));

		data->obj_self = obj;
		data->obj_contextmenu = NULL;

		for (i = 0l; i < BIP_END; i++)
			data->nld_Pen[i] = -1l;

		data->nld_ID = GetTagData(MUIA_NList_ID, 0ul, msg->ops_AttrList);
		
		set(obj, MUIA_ObjectID,
			GetTagData(MUIA_ObjectID, 0ul, msg->ops_AttrList));
		
		set(obj, MUIA_NList_Format,
			GetTagData(MUIA_NList_Format, 0ul, msg->ops_AttrList));

		set(obj, MUIA_NList_Input,
			GetTagData(MUIA_NList_Input, 0ul, msg->ops_AttrList));

		set(obj, MUIA_NList_MultiSelect,
			GetTagData(MUIA_NList_MultiSelect, 0ul, msg->ops_AttrList));

		set(obj, MUIA_NList_DragSortable,
			GetTagData(MUIA_NList_DragSortable, 0ul, msg->ops_AttrList));

		set(obj, MUIA_NList_ConstructHook2,
			GetTagData(MUIA_NList_ConstructHook2, 0ul, msg->ops_AttrList));

		set(obj, MUIA_NList_DestructHook2,
			GetTagData(MUIA_NList_DestructHook2, 0ul, msg->ops_AttrList));

		set(obj, MUIA_NList_DisplayHook2,
			GetTagData(MUIA_NList_DisplayHook2, 0ul, msg->ops_AttrList));

		set(obj, MUIA_NList_CompareHook2,
			GetTagData(MUIA_NList_CompareHook2, 0ul, msg->ops_AttrList));
   }
	return ((ULONG)obj);
}

//------------------------------------------------------------------------------

static ULONG mDispose(struct IClass *cl, Object *obj, Msg msg)
{
	struct MCC_NList_Data *data = INST_DATA(cl, obj);
	
	if (data->obj_contextmenu)
		DisposeObject(data->obj_contextmenu);

	return (DoSuperMethodA(cl, obj, msg));
}

//------------------------------------------------------------------------------

static ULONG mSet(struct IClass *cl, Object *obj, Msg msg)
{
	struct MCC_NList_Data *data = INST_DATA(cl, obj);
   struct TagItem *tags, *tag;

	for ((tags = ((struct opSet *)msg)->ops_AttrList); (tag = NextTagItem(&tags));) {
		switch (tag->ti_Tag) {
			case MUIA_NList_MainData:
				data->nld_MainData = (struct MCC_Main_Data *)tag->ti_Data;
				break;
		}
	}
	return (DoSuperMethodA(cl, obj, msg));
}

//------------------------------------------------------------------------------

static ULONG mSetup(struct IClass *cl, Object *obj, Msg msg)
{
	struct MCC_NList_Data *data = INST_DATA(cl, obj);

	if (!(DoSuperMethodA(cl, obj, msg)))
		return FALSE;

	if (data->nld_ID == MUIV_NList_ID_Stats) {
		myObtainPen(cl, obj, BIP_Stats_R);
		myObtainPen(cl, obj, BIP_Stats_G);
		myObtainPen(cl, obj, BIP_Stats_B);
	}
	return TRUE;
}

//------------------------------------------------------------------------------

static ULONG mCleanup(struct IClass *cl, Object *obj, Msg msg)
{
	struct MCC_NList_Data *data = INST_DATA(cl, obj);
	
	if (data->nld_ID == MUIV_NList_ID_Stats) {
		myReleasePen(cl, obj, BIP_Stats_R);
		myReleasePen(cl, obj, BIP_Stats_G);
		myReleasePen(cl, obj, BIP_Stats_B);
	}
	return (DoSuperMethodA(cl, obj, msg));
}

//------------------------------------------------------------------------------

static ULONG mContextMenuBuild(struct IClass *cl, Object *obj, struct MUIP_NList_ContextMenuBuild *msg)
{
	struct MCC_NList_Data *data = INST_DATA(cl, obj);
	//struct MCC_Main_Data *md = data->nld_MainData;
	//Settings *settings = &control->c_Settings;

	if (!_isinobject(msg->mx, msg->my))
		return 0;
	
   if (data->obj_contextmenu) {
		DisposeObject(data->obj_contextmenu);
		data->obj_contextmenu = NULL;
	}
	
   /*switch (data->nld_ID)
	{
		case MUIV_NList_ID_Stats:
		{
			Object *m;
			LONG id = CF_Stats;

         if (msg->ontop) {
				if (MM(MSG(MSG_LOG_LIST_TITLE_TITLE))) {
					AC(MSG(MSG_LOG_LIST_TITLE_0), issetb(settings->s_ColumnFlags[id], 0), TRUE, 0);
					AC(MSG(MSG_LOG_LIST_TITLE_1), issetb(settings->s_ColumnFlags[id], 1), TRUE, 1);
					AC(MSG(MSG_LOG_LIST_TITLE_2), issetb(settings->s_ColumnFlags[id], 2), FALSE, 2);
					AC(MSG(MSG_LOG_LIST_TITLE_3), issetb(settings->s_ColumnFlags[id], 3), TRUE, 3);
					AB;
					ASTD;
					break;
				}
			}
			
			if (MM(MSG(MSG_LOG_LIST_TITLE))) {
				A(MSG(MSG_LOG_CLEAR), MUIV_NList_ID_Stats_Clear);
			}
			break;
		}
	}*/
   return ((ULONG)data->obj_contextmenu);
}

//------------------------------------------------------------------------------

static ULONG mContextMenuChoice(struct IClass *cl, Object *obj, struct MUIP_ContextMenuChoice *msg)
{
	struct MCC_NList_Data *data = INST_DATA(cl, obj);
	//struct MCC_Main_Data *md = data->nld_MainData;
   Control *control = data->nld_MainData->md_ApplicationData->ad_Params->p_User;
	Settings *settings = &control->c_Settings;
   ULONG userdata = muiUserData(msg->item);

	switch (data->nld_ID)
	{
		case MUIV_NList_ID_Stats:
		{
			switch (userdata) {
				case 0:
				case 1:
				case 2:
				case 3:
				case 4:
				case 5:
				case 6:
				case 7: {
					LONG id = CF_Stats;

					(issetb(settings->s_ColumnFlags[id], userdata)) ?
						clrb(settings->s_ColumnFlags[id], userdata) :
						setb(settings->s_ColumnFlags[id], userdata);

					DoMethod(obj, MUIM_NList_MakeFormat, id, 8);
					break;
				}
				/*case MUIV_NList_ID_Stats_Clear:
					DoMethod(_app(obj), MUIM_Application_PushMethod,
						md->obj_self, 1,
                  MUIM_Main_Log_Clear);
					break;
				*/
            default:
					return (DoSuperMethodA(cl, obj, msg));
			}
			break;
		}
		default:
			return (DoSuperMethodA(cl, obj, msg));
	}
	return 0;
}

//------------------------------------------------------------------------------

static ULONG mMakeFormat(struct IClass * cl, Object *obj, struct MUIP_NList_MakeFormat *msg)
{
	struct MCC_NList_Data *data = INST_DATA(cl, obj);
   Control *control = data->nld_MainData->md_ApplicationData->ad_Params->p_User;
	Settings *settings = &control->c_Settings;
	UBYTE fmt[10 * msg->maxcols];
	LONG i;

	*fmt = '\0';
	for (i = 0l; i < msg->maxcols; i++) {
		if (issetb(settings->s_ColumnFlags[msg->id], i))
			sprintf(&fmt[strlen(fmt)], "C=%ld BAR,", i);
	}
	if (*fmt)
		fmt[strlen(fmt) - 1] = '\0';
	
	set(obj, MUIA_NList_Format, fmt);
	return 0;
}

//------------------------------------------------------------------------------

static ULONG mUpdateColors(struct IClass *cl, Object *obj, Msg msg)
{
	struct MCC_NList_Data *data = INST_DATA(cl, obj);
	
	if (data->nld_ID == MUIV_NList_ID_Stats) {
		myReleasePen(cl, obj, BIP_Stats_R);
		myReleasePen(cl, obj, BIP_Stats_G);
		myReleasePen(cl, obj, BIP_Stats_B);

		myObtainPen(cl, obj, BIP_Stats_R);
		myObtainPen(cl, obj, BIP_Stats_G);
		myObtainPen(cl, obj, BIP_Stats_B);
	}
	return 0;
}

//------------------------------------------------------------------------------

MCC_DISPATCHER(dpNList)
{
	if (msg) switch (msg->MethodID)
	{
		case OM_NEW 							: return (mNew(cl, obj, (APTR)msg));
		case OM_DISPOSE 						: return (mDispose(cl, obj, (APTR)msg));
		case OM_SET 							: return (mSet(cl, obj, (APTR)msg));
		case MUIM_Setup 						: return (mSetup(cl, obj, (APTR)msg));
		case MUIM_Cleanup 					: return (mCleanup(cl, obj, (APTR)msg));
		case MUIM_NList_ContextMenuBuild : return (mContextMenuBuild(cl, obj, (APTR)msg));
		case MUIM_ContextMenuChoice 		: return (mContextMenuChoice(cl, obj, (APTR)msg));
		case MUIM_NList_MakeFormat			: return (mMakeFormat(cl, obj, (APTR)msg));
		case MUIM_NList_UpdateColors		: return (mUpdateColors(cl, obj, (APTR)msg));
   }
	return (DoSuperMethodA(cl, obj, msg));
}
MCC_DISPATCHER_END

//------------------------------------------------------------------------------










