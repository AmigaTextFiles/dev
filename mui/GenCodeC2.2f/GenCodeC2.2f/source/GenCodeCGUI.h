#ifndef GUI_FILE_H
#define GUI_FILE_H

/* Types */
#include <exec/types.h>
struct ObjApp
{
	APTR	App;
	APTR	WI_C_Generation;
	APTR	TX_Prg_Name;
	APTR	CH_Generate_Main_File;
	APTR	GR_Catalog;
	APTR	CH_Add_new_entries_in_Catalog_Description_File;
	APTR	GR_H_Header;
	APTR	GR_C_Header;
	APTR	GR_Main_Header;
	APTR	BT_Generate;
	APTR	BT_Save_Local;
	APTR	BT_Save_Global;
	char *	STR_TX_Prg_Name;
	char *	STR_GR_Register[4];
};

#define ID_BT_SAVE_LOCAL 1
#define ID_BT_SAVE_GLOBAL 2
#define ID_BT_GENERATE 3

extern struct ObjApp * CreateApp(void);
extern void DisposeApp(struct ObjApp *);

#endif
