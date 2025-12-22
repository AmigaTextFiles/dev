
#include <inline/exec.h>
#include <libraries/mui.h>
#include <exec/memory.h>


struct ObjWI_Scale
{
	APTR	WI_Scale;
	APTR	STR_DEFScaleName;
	APTR	STR_ScaleX;
	APTR	STR_ScaleY;
	APTR	STR_ScaleZ;
	APTR	BT_ScaleOk;
	APTR	BT_ScaleDefault;
	APTR	BT_ScaleCancel;
};

extern struct ObjWI_Scale * CreateWI_Scale(void);
extern void DisposeWI_Scale(struct ObjWI_Scale *);
