
#include <inline/exec.h>
#include <libraries/mui.h>
#include <exec/memory.h>


struct ObjWI_Cone
{
	APTR	WI_Cone;
	APTR	STR_DEFConeName;
	APTR	STR_ConeBottomRadius;
	APTR	STR_ConeHeight;
	APTR	CH_ConeSides;
	APTR	CH_ConeBottom;
	APTR	BT_ConeOk;
	APTR	BT_ConeDefault;
	APTR	BT_ConeCancel;
};

extern struct ObjWI_Cone * CreateWI_Cone(void);
extern void DisposeWI_Cone(struct ObjWI_Cone *);
