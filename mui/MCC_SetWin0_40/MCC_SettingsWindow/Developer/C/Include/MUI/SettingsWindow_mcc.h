/*
** SettingsWindow.mcc (c) by Ingo Weinhold
** Not yet registered class of the Magic User Interface.
** SettingsWindow_mcc.h
**
** Used tag ID's:
**   attributes: 0xac01221 - 0xac01223
**   methods   : 0xac01221 - 0xac01230
*/


#ifndef MUI_SETTINGSWINDOW_MCC_H

	#define MUI_SETTINGSWINDOW_MCC_H

	#define MUIC_SettingsWindow "SettingsWindow.mcc"

	#define SettingsWindowObject	MUI_NewObject(MUIC_SettingsWindow

	/* Attributes */

	#define MUIA_SettingsWindow_PortDirectly		0xac01221
	#define MUIA_SettingsWindow_TestMode			0xac01222
	#define MUIA_SettingsWindow_TestButton			0xac01223
	#define MUIA_SettingsWindow_Changed				0xac01224


	/* Methods */

	#define MUIM_SettingsWindow_Save					0xac01221
	#define MUIM_SettingsWindow_Use					0xac01222
	#define MUIM_SettingsWindow_Cancel				0xac01223
	#define MUIM_SettingsWindow_Init					0xac01224
	#define MUIM_SettingsWindow_GetItem				0xac01225
	#define MUIM_SettingsWindow_SetItem				0xac01226
	#define MUIM_SettingsWindow_NNSetItem			0xac01227
	#define MUIM_SettingsWindow_Notify				0xac01228
	#define MUIM_SettingsWindow_KillNotify			0xac01229
	#define MUIM_SettingsWindow_KillNotifyObj		0xac0122a
	#define MUIM_SettingsWindow_Reset				0xac0122b
	#define MUIM_SettingsWindow_Store				0xac0122c
	#define MUIM_SettingsWindow_Load					0xac0122d
	#define MUIM_SettingsWindow_LastSaved			0xac0122e
	#define MUIM_SettingsWindow_SaveAs				0xac0122f
	#define MUIM_SettingsWindow_Restore				0xac01230
	#define MUIM_SettingsWindow_CustomInsert		0xac01231


	/* Structures */

	struct MUIS_SettingsWindow_Init_Item
	{
		Object	*swi_Obj;
		ULONG		swi_Attr;
		ULONG		swi_Type;
		ULONG		swi_Size;
		ULONG		swi_ID;
	};


	/* Method Parameter Structures */

	struct MUIP_SettingsWindow_Save				{ ULONG MethodID; };
	struct MUIP_SettingsWindow_Use				{ ULONG MethodID; };
	struct MUIP_SettingsWindow_Cancel			{ ULONG MethodID; };
	struct MUIP_SettingsWindow_Load				{ ULONG MethodID; };
	struct MUIP_SettingsWindow_LastSaved		{ ULONG MethodID; };
	struct MUIP_SettingsWindow_Restore			{ ULONG MethodID; };
	struct MUIP_SettingsWindow_SaveAs			{ ULONG MethodID; };
	struct MUIP_SettingsWindow_Init				{ ULONG MethodID; struct MUIS_SettingsWindow_Init_Item Items[1]; };
	struct MUIP_SettingsWindow_GetItem			{ ULONG MethodID; ULONG ID; ULONG *Storage; };
	struct MUIP_SettingsWindow_SetItem			{ ULONG MethodID; ULONG ID; ULONG Value; };
	struct MUIP_SettingsWindow_NNSetItem		{ ULONG MethodID; ULONG ID; ULONG Value; };
	struct MUIP_SettingsWindow_Notify			{ ULONG MethodID; ULONG TrigID; ULONG TrigValue; Object *DestObj; ULONG FollowParams; };
	struct MUIP_SettingsWindow_KillNotify		{ ULONG MethodID; ULONG TrigID; };
	struct MUIP_SettingsWindow_KillNotifyObj	{ ULONG MethodID; ULONG TrigID; Object *DestObj; };
	struct MUIP_SettingsWindow_Reset				{ ULONG MethodID; };
	struct MUIP_SettingsWindow_Store				{ ULONG MethodID; };
	struct MUIP_SettingsWindow_CustomInsert	{ ULONG MethodID; APTR Entries; ULONG Count; ULONG Pos};


	/* Special Values */

	/* Types */

	#define SWIT_STANDARD		0x0001
	#define SWIT_STRING			0x0002
	#define SWIT_STRUCT			0x0003
	#define SWIT_COMPLEX			0x0004

	#define SWIT_LISTSTANDARD	0x0010
	#define SWIT_LISTSTRING		0x0011
	#define SWIT_LISTSTRUCT		0x0012
	#define SWIT_LISTCOMPLEX	0x0013
	#define SWIT_LISTCUSTOM		0x0014

	#define SWIT_NLISTSTANDARD	(SWIT_LISTSTANDARD	| SWIT_NLIST)
	#define SWIT_NLISTSTRING	(SWIT_LISTSTRING		| SWIT_NLIST)
	#define SWIT_NLISTSTRUCT	(SWIT_LISTSTRUCT		| SWIT_NLIST)
	#define SWIT_NLISTCOMPLEX	(SWIT_LISTCUSTOM		| SWIT_NLIST)
	#define SWIT_NLISTCUSTOM	(SWIT_LISTCUSTOM		| SWIT_NLIST)

	#define SWIT_TYPES			0x001f	/* private, don't use */
	#define SWIT_EMPTY			0x0100	/* private, don't use */
	#define SWIT_NLIST			0x0200	/* an NList instead of a List */

	/* Structure Values */

	#define SWIS_BYTE				-1
	#define SWIS_WORD				-2
	#define SWIS_LONG				-3
	#define SWIS_ARRAY			-4
	#define SWIS_STRING			-5
	#define SWIS_POINTER			-6
	#define SWIS_STRUCT			-7
	#define SWIS_END				-8
	#define SWIS_EVEN				-9
	#define SWIS_EVEN4			-10


	/* Shortcuts */

	#ifndef MUI_NOSHORTCUTS

		#define swget(obj,id,storage)	DoMethod(obj,MUIM_SettingsWindow_GetItem,id,storage)
		#define swset(obj,id,value)	DoMethod(obj,MUIM_SettingsWindow_SetItem,id,value)

	#endif

#endif


