
#include <inline/exec.h>
#include <libraries/mui.h>
#include <exec/memory.h>


struct ObjWI_WWWInline
{
	APTR	WI_WWWInline;
	APTR	STR_DEFWWWInlineName;
	APTR	STR_WWWInlineName;
	APTR	BT_WWWInlineRead;
	APTR	STR_WWWInlineBoxSizeX;
	APTR	STR_WWWInlineBoxSizeY;
	APTR	STR_WWWInlineBoxSizeZ;
	APTR	STR_WWWInlineBoxCenterX;
	APTR	STR_WWWInlineBoxCenterY;
	APTR	STR_WWWInlineBoxCenterZ;
	APTR	BT_WWWInlineOk;
	APTR	BT_WWWInlineDefault;
	APTR	BT_WWWInlineCancel;
};

extern struct ObjWI_WWWInline * CreateWI_WWWInline(void);
extern void DisposeWI_WWWInline(struct ObjWI_WWWInline *);
