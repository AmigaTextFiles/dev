/*
 * blockmon.dilp - Block Monitor plugin for DIL
 * Copyright ©2004-2007 Rupert Hausberger <naTmeg@gmx.net>
 * All rights reserved.
 *
 * Please see "License.readme" for the terms of this file
 */

#include "include.h"

//------------------------------------------------------------------------------

void SetTitle(Object *obj, UBYTE *fmt, ...)
{
	va_list args;
	ULONG size = 0ul;

	va_start(args, fmt);
	size = (ULONG)vscountf(fmt, args);
	va_end(args);

	if (size) {
		struct MCC_Main_Data *data = INST_DATA(OCLASS(_win(obj)), _win(obj));
		Control *control = data->md_ApplicationData->ad_Params->p_User;

		if (data->md_WindowTitle)
			FreeVP(control, data->md_WindowTitle);
		
		if ((data->md_WindowTitle = AllocVP(control, size + 1))) {
			va_start(args, fmt);
			vsprintf(data->md_WindowTitle, fmt, args);
			va_end(args);
			set(_win(obj), MUIA_Window_Title, data->md_WindowTitle);
		}
	}
}

//------------------------------------------------------------------------------

static UBYTE *nlBIP(struct MCC_NList_Data *data, LONG id)
{
   Control *control = data->nld_MainData->md_ApplicationData->ad_Params->p_User;
	Settings *settings = &control->c_Settings;
	static UBYTE head[64];
	LONG b = settings->s_Bold[id];
	LONG i =	settings->s_Italic[id];

	memclr(head, sizeof(head));

	if (b && i)
		sprintf(head, "\033P[%ld]\033b\033i", MUIPEN(data->nld_Pen[id]));
	else if (b)
		sprintf(head, "\033P[%ld]\033b", MUIPEN(data->nld_Pen[id]));
	else if (i)
		sprintf(head, "\033P[%ld]\033i", MUIPEN(data->nld_Pen[id]));
	else
		sprintf(head, "\033P[%ld]", MUIPEN(data->nld_Pen[id]));

	return head;
}

//------------------------------------------------------------------------------

static void dspFUNC_NList(void)
{
	struct NList_DisplayMessage *msg = (APTR)REG_A1;
	Object *obj = (APTR)REG_A2;
	struct MCC_NList_Data *data = INST_DATA(OCLASS(obj), obj);
	Entry *entry = (Entry *)msg->entry;

	if (entry) {
		struct DosEnvec *de = &data->nld_MainData->md_ApplicationData->ad_Params->p_DosEnvec;
		static UBYTE lba[16];
		static UBYTE cyl[16];
		static UBYTE sur[16];
		static UBYTE trk[16];
		static UBYTE len[16];
		static UBYTE rac[16];
		static UBYTE wac[16];
		static UBYTE la[32];
		ULONG cylinder, surface, track;
		ULONG lowblock = 0ul; //GetLowBlock(de); //absolute or relative offset?

		LBA2CST(de, entry->e_BlockOffset - lowblock, &cylinder, &surface, &track);

		sprintf(lba, "%lu", entry->e_BlockOffset - lowblock);
		sprintf(cyl, "%lu", cylinder);
		sprintf(sur, "%lu", surface);
		sprintf(trk, "%lu", track);
		sprintf(len, "%lu", entry->e_BlockCount);
		sprintf(rac, "%lu", entry->e_RAC);
		sprintf(wac, "%lu", entry->e_WAC);
		sprintf(la, "%s%s",
			(entry->e_LA == 1) ? nlBIP(data, BIP_Stats_B) : nlBIP(data, BIP_Stats_R),
			(entry->e_LA == 1) ? "Read" : "Write");

		msg->strings[0] = lba;
		msg->strings[1] = cyl;
		msg->strings[2] = sur;
		msg->strings[3] = trk;
		msg->strings[4] = len;
		msg->strings[5] = rac;
		msg->strings[6] = wac;
		msg->strings[7] = la;
	} else {
		//msg->strings[0] = issetb(control->c_Settings.s_ColumnFlags[CF_Stats], 31) ? "short" : "long";
		msg->strings[0] = "LBA";
		msg->strings[1] = "Cylinder";
		msg->strings[2] = "Surface";
		msg->strings[3] = "Track";
		msg->strings[4] = "Blocks";
		msg->strings[5] = "Read access count";
		msg->strings[6] = "Write access count";
		msg->strings[7] = "Last access";
	}
	msg->preparses[0]	= "\033r";
	msg->preparses[1]	= "\033r";
	msg->preparses[2]	= "\033r";
	msg->preparses[3]	= "\033r";
	msg->preparses[4]	= "\033r";
	msg->preparses[5]	= "\033r";
	msg->preparses[6]	= "\033r";
	msg->preparses[7]	= "\033l";
}
STATIC_HOOK(dspHOOK_NList, dspFUNC_NList);

//------------------------------------------------------------------------------

#define TYPE_Decimal(x, type) \
	result = (LONG)((type) ? (entry2->x - entry1->x) : (entry1->x - entry2->x));

#define TYPE_Decimal_Direct(x1, x2, type) \
	result = (LONG)((type) ? (x2 - x1) : (x1 - x2));

static LONG cmpFUNC_NList(void)
{
	struct NList_CompareMessage *msg = (APTR)REG_A1;
	Object *obj = (APTR)REG_A2;
	struct MCC_NList_Data *data = INST_DATA(OCLASS(obj), obj);
	struct DosEnvec *de = &data->nld_MainData->md_ApplicationData->ad_Params->p_DosEnvec;
   Entry *entry1 = (Entry *)msg->entry1;
	Entry *entry2 = (Entry *)msg->entry2;
   LONG col1 = msg->sort_type  & MUIV_NList_TitleMark_ColMask;
	LONG col2 = msg->sort_type2 & MUIV_NList_TitleMark2_ColMask;
	LONG type1 = msg->sort_type & MUIV_NList_TitleMark_TypeMask;
	LONG type2 = msg->sort_type2 & MUIV_NList_TitleMark2_TypeMask;
	ULONG cylinder[2], surface[2], track[2];
	ULONG lowblock = 0ul; //GetLowBlock(de); //absolute or relative offset?
	LONG result = 0l;

	if (msg->sort_type == MUIV_NList_SortType_None)
		return 0;

	LBA2CST(de, entry1->e_BlockOffset - lowblock, &cylinder[0], &surface[0], &track[0]);
	LBA2CST(de, entry2->e_BlockOffset - lowblock, &cylinder[1], &surface[1], &track[1]);

		  if (col1 == 0) TYPE_Decimal(e_BlockOffset, type1)
	else if (col1 == 1) TYPE_Decimal_Direct(cylinder[0], cylinder[1], type1)
	else if (col1 == 2) TYPE_Decimal_Direct(surface[0], surface[1], type1)
	else if (col1 == 3) TYPE_Decimal_Direct(track[0], track[1], type1)
	else if (col1 == 4) TYPE_Decimal(e_BlockCount, type1)
	else if (col1 == 5) TYPE_Decimal(e_RAC, type1)
	else if (col1 == 6) TYPE_Decimal(e_WAC, type1)
	else if (col1 == 7) TYPE_Decimal(e_LA, type1)

	if (result || (col1 == col2))
		return result;

		  if (col2 == 0) TYPE_Decimal(e_BlockOffset, type2)
	else if (col2 == 1) TYPE_Decimal(e_BlockCount, type2)
	else if (col2 == 2) TYPE_Decimal_Direct(cylinder[0], cylinder[1], type2)
	else if (col2 == 3) TYPE_Decimal_Direct(surface[0], surface[1], type2)
	else if (col2 == 4) TYPE_Decimal_Direct(track[0], track[1], type2)
	else if (col2 == 5) TYPE_Decimal(e_RAC, type2)
	else if (col2 == 6) TYPE_Decimal(e_WAC, type2)
	else if (col2 == 7) TYPE_Decimal(e_LA, type2)

	return result;
}
STATIC_HOOK(cmpHOOK_NList, cmpFUNC_NList);

//------------------------------------------------------------------------------

static ULONG mNew(struct IClass *cl, Object *obj, struct opSet *msg)
{
	static const UBYTE *pages[] = {
		"Display",
		"Statistics",
		NULL
	};
	struct MCC_Main_Data tmp;
	struct MCC_Application_Data *ad = (struct MCC_Application_Data *)GetTagData(MUIA_Main_ApplicationData, 0ul, msg->ops_AttrList);
	Control *control = ad->ad_Params->p_User;

	memclr(&tmp, sizeof(struct MCC_Main_Data));

	if ((obj = (Object *)DoSuperNew(cl, obj,
		MUIA_Window_ID, MAKE_ID('W','0','0','1'),
		MUIA_Window_Title, NAME_LONG" · ",
		MUIA_Window_ShowIconify, TRUE,
		MUIA_Window_ShowAbout, FALSE,
		MUIA_Window_ShowPrefs, FALSE,
		MUIA_Window_ShowJump, FALSE,
		MUIA_Window_ShowSnapshot, FALSE,
		MUIA_Window_ShowPopup, FALSE,
      WindowContents, VGroup,
			Child, RegisterGroup(pages),
				Child, tmp.obj_group_display = VGroup,
					MUIA_CycleChain, TRUE,
					Child, tmp.obj_display = ScrollgroupObject,
						MUIA_Scrollgroup_AutoBars, TRUE,
						MUIA_Scrollgroup_Contents, VirtgroupObject, VirtualFrame,
							Child, tmp.mcc_display = _DisplayObject,
                     	MUIA_Display_Control, control,
                     End,
						End,
					End,
				End,
				Child, VGroup,
					MUIA_CycleChain, TRUE,
					Child, NListviewObject,
						MUIA_Listview_Input, FALSE,
						MUIA_NListview_NList, tmp.obj_list = _NListObject,
							MUIA_NList_ID, MUIV_NList_ID_Stats,
							MUIA_ObjectID, MAKE_ID('L','0','0','1'),
							MUIA_NList_Format, (ULONG)"BAR,BAR,BAR,BAR,BAR,BAR,BAR,BAR",
							MUIA_NList_MultiSelect, MUIV_NList_MultiSelect_None,
							MUIA_NList_DisplayHook2, (ULONG)&dspHOOK_NList,
							MUIA_NList_CompareHook2, (ULONG)&cmpHOOK_NList,
						End,
					End,
					Child, ColGroup(3),
						Child, HVSpace,
						Child, tmp.obj_update = _Button("Update", 'u'),
						Child, HVSpace,
               End,
				End,
			End,
      End,
		TAG_MORE, msg->ops_AttrList)))
	{
		struct MCC_Main_Data *data = INST_DATA(cl, obj);

		CopyMem(&tmp, data, sizeof(struct MCC_Main_Data));

		data->obj_self = obj;
		data->obj_parent = (Object *)GetTagData(MUIA_Parent, 0ul, msg->ops_AttrList);
		data->md_ApplicationData = ad;
		
		set(data->mcc_display, MUIA_Parent, obj);
		set(data->mcc_display, MUIA_Display_MainData, data);

		set(data->obj_list, MUIA_NList_MainData, data);
		set(data->obj_list, MUIA_NList_SortType, 0 | 1);

      set(obj, MUIA_Window_ActiveObject, data->obj_display);
		set(obj, MUIA_Window_DefaultObject, data->obj_display);

		//close request
		DoMethod(obj, MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
			MUIV_Notify_Application, 4,
			MUIM_Application_PushMethod, data->obj_parent, 1,
			MUIM_Application_Project_Iconify);

		//list
		DoMethod(data->obj_list, MUIM_Notify, MUIA_NList_TitleClick,  MUIV_EveryTime,
			data->obj_list, 4,
			MUIM_NList_Sort3, MUIV_TriggerValue, MUIV_NList_SortTypeAdd_2Values, MUIV_NList_Sort3_SortType_Both
		);
		DoMethod(data->obj_list, MUIM_Notify, MUIA_NList_TitleClick2, MUIV_EveryTime,
			data->obj_list, 4,
			MUIM_NList_Sort3, MUIV_TriggerValue, MUIV_NList_SortTypeAdd_2Values, MUIV_NList_Sort3_SortType_2
		);
		DoMethod(data->obj_list, MUIM_Notify, MUIA_NList_SortType, MUIV_EveryTime,
			data->obj_list, 3,
			MUIM_Set, MUIA_NList_TitleMark, MUIV_TriggerValue
		);
		DoMethod(data->obj_list, MUIM_Notify, MUIA_NList_SortType2, MUIV_EveryTime,
			data->obj_list, 3,
			MUIM_Set, MUIA_NList_TitleMark2, MUIV_TriggerValue
		);

		//update button
		DoMethod(data->obj_update, MUIM_Notify, MUIA_Pressed, FALSE,
			obj, 1,
			MUIM_Main_Update
		);

		return ((ULONG)obj);
   }
	return 0;
}

//------------------------------------------------------------------------------

static ULONG mDispose(struct IClass *cl, Object *obj, Msg msg)
{
	struct MCC_Main_Data *data = INST_DATA(cl, obj);
   Control *control = data->md_ApplicationData->ad_Params->p_User;
	
	if (data->md_WindowTitle)
		FreeVP(control, data->md_WindowTitle);

	return (DoSuperMethodA(cl, obj, msg));
}

//------------------------------------------------------------------------------

static ULONG mInit(struct IClass *cl, Object *obj, Msg msg)
{
	struct MCC_Main_Data *data = INST_DATA(cl, obj);
	DILParams *params = data->md_ApplicationData->ad_Params;

	//setup display
	//set(data->mcc_display, MUIA_Parent, obj);
	//set(data->mcc_display, MUIA_Display_MainData, data);
	
	//setup nlist
	//set(data->obj_list, MUIA_NList_MainData, data);
	//set(data->obj_list, MUIA_NList_SortType, 0 | 1);
	//DoMethod(data->obj_list, MUIM_NList_MakeFormat, CF_Stats, 8);

	if (LoadCache(params))
		return TRUE;
	
   return FALSE;
}

//------------------------------------------------------------------------------

static ULONG mExit(struct IClass *cl, Object *obj, Msg msg)
{
	struct MCC_Main_Data *data = INST_DATA(cl, obj);
	DILParams *params = data->md_ApplicationData->ad_Params;

	SaveCache(params);
   return 0;
}

//------------------------------------------------------------------------------

static void SortList(Object *list)
{
	LONG sorttype;

   get(list, MUIA_NList_SortType, &sorttype);
	if (sorttype != MUIV_NList_SortType_None) {
		LONG active, first;

		get(list, MUIA_NList_Active, &active);
		get(list, MUIA_NList_First, &first);
		DoMethod(list, MUIM_NList_Sort);
		set(list, MUIA_NList_Active, active);
		set(list, MUIA_NList_First, first);
	}
}

static ULONG mUpdate(struct IClass *cl, Object *obj, Msg msg)
{
	struct MCC_Main_Data *data = INST_DATA(cl, obj);
   Control *control = data->md_ApplicationData->ad_Params->p_User;
	Object *ptr = data->obj_list;
	Entry *entry;

	disAPP;
	set(ptr, MUIA_NList_Quiet, TRUE);
	DoMethod(ptr, MUIM_NList_Clear);
	
   ForeachNode(&control->c_List, entry)
		DoMethod(ptr, MUIM_NList_InsertSingle, entry, MUIV_NList_Insert_Sorted);
	
	SortList(ptr);
   set(ptr, MUIA_NList_Quiet, FALSE);
	enAPP;
	
   return 0;
}

//------------------------------------------------------------------------------

MCC_DISPATCHER(dpMain)
{
	if (msg) switch (msg->MethodID) {
		case OM_NEW 				: return (mNew(cl, obj, (APTR)msg));
		case OM_DISPOSE 			: return (mDispose(cl, obj, (APTR)msg));
		case MUIM_Main_Init		: return (mInit(cl, obj, (APTR)msg));
		case MUIM_Main_Exit		: return (mExit(cl, obj, (APTR)msg));
		case MUIM_Main_Update	: return (mUpdate(cl, obj, (APTR)msg));
   }
	return (DoSuperMethodA(cl, obj, msg));
}
MCC_DISPATCHER_END

//------------------------------------------------------------------------------






















