
#include <inline/exec.h>
#include <libraries/mui.h>
#include <exec/memory.h>


struct ObjWI_AsciiText
{
	APTR	WI_AsciiText;
	APTR	STR_DEFAsciiTextName;
	APTR	LV_AsciiTextStrings;
	APTR	STR_AsciiTextString;
	APTR	STR_AsciiTextWidth;
	APTR	BT_AsciiTextAdd;
	APTR	BT_AsciiTextDelete;
	APTR	STR_AsciiTextSpacing;
	APTR	CY_AsciiTextJustification;
	APTR	BT_AsciiTextOk;
	APTR	BT_AsciiTextCancel;
	char *	CY_AsciiTextJustificationContent[4];
};

extern struct ObjWI_AsciiText * CreateWI_AsciiText(void);
extern void DisposeWI_AsciiText(struct ObjWI_AsciiText *);
