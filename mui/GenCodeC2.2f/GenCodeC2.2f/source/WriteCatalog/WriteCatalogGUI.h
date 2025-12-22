#ifndef GUI_FILE_H
#define GUI_FILE_H

/* Types */
#include <exec/types.h>
struct ObjApp
{
	APTR	App;
	APTR	WI_WriteCatalog;
	APTR	GR_GetStringName;
	APTR	STR_GetStringName;
	APTR	GR_Text;
	APTR	BT_GenerateFiles;
	APTR	BT_Save;
};

#define ID_BT_GenerateFiles 1
#define ID_BT_Save 2

extern struct ObjApp * CreateApp(void);
extern void DisposeApp(struct ObjApp *);

#endif
