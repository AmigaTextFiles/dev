
#include <inline/exec.h>
#include <libraries/mui.h>
#include <exec/memory.h>


struct ObjWI_FontStyle
{
	APTR	WI_FontStyle;
	APTR	STR_DEFFontStyleName;
	APTR	STR_FontStyleSize;
	APTR	CY_FontStyleFamily;
	APTR	CH_FontStyleBold;
	APTR	CH_FontStyleItalic;
	APTR	BT_FontStyleOk;
	APTR	BT_FontStyleDefault;
	APTR	BT_FontStyleCancel;
	char *	CY_FontStyleFamilyContent[4];
};

extern struct ObjWI_FontStyle * CreateWI_FontStyle(void);
extern void DisposeWI_FontStyle(struct ObjWI_FontStyle *);
